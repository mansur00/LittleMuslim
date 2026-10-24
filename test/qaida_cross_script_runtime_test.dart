import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/data/nurani_qaida_data.dart';
import 'package:little_muslim/data/qaida_curriculum_data.dart';
import 'package:little_muslim/l10n/app_localizations.dart';
import 'package:little_muslim/screens/qaida/qaida_activity_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_chapters_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_exam_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_lesson_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_next_course_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_report_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_revision_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_track_lessons_screen.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _TestApp extends StatelessWidget {
  const _TestApp({required this.state, required this.child});
  final AppState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: state,
      child: Consumer<AppState>(
        builder: (context, appState, _) => MaterialApp(
          locale: Locale(appState.selectedLanguage),
          supportedLocales: AppLanguages.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: child,
        ),
      ),
    );
  }
}

List<String> _extractAllRenderedStrings(WidgetTester tester) {
  final strings = <String>[];
  for (final element in find.byType(Text).evaluate()) {
    final widget = element.widget as Text;
    if (widget.data != null && widget.data!.isNotEmpty) {
      strings.add(widget.data!);
    } else if (widget.textSpan != null) {
      final s = widget.textSpan!.toPlainText();
      if (s.isNotEmpty) strings.add(s);
    }
  }
  for (final element in find.byType(RichText).evaluate()) {
    final widget = element.widget as RichText;
    final s = widget.text.toPlainText();
    if (s.isNotEmpty) strings.add(s);
  }
  return strings;
}

final Map<String, int> _stringsCheckedPerLocale = {
  'en': 0,
  'bn': 0,
  'hi': 0,
  'it': 0,
};

void _assertNoCrossScriptLeakage({
  required String locale,
  required String screenName,
  required List<String> renderedStrings,
}) {
  final banglaRegex = RegExp(r'[\u0980-\u09FF]');
  // Indic dandas (। \u0964, ॥ \u0965) are shared across Bengali and Devanagari. Exclude them from pure Hindi letters.
  final hindiRegex = RegExp(r'[\u0900-\u0963\u0966-\u097F]');
  final rawKeyRegex = RegExp(r'^[a-z]+(\.[a-z0-9_]+){2,}$');
  final placeholderRegex = RegExp(r'\{[a-zA-Z0-9_]+\}');
  final twoLatinWordsRegex = RegExp(r'\b[a-zA-Z]{2,}\s+[a-zA-Z]{2,}\b');

  const allowlistedBrandAndTransliteration = [
    'Little Muslim',
    'Noorani Qaida',
    'Sahih Bukhari',
    'Sahih Muslim',
    'Sunan Ibn Majah',
    'Sunan Abu Dawud',
    'Abu Dawud',
    'Musnad Ahmad',
    'Sirat Ibn Hisham',
    'Tarikh al-Tabari',
    'Jami at-Tirmidhi',
    'Sunan al-Kubra',
    'Sayyid al-Istighfar',
    'Assalamu Alaikum',
    'JazakAllahu Khairan',
    'Ba · Bi · Bu',
    'Bi · Bu · Ba',
    'Bu · Ba · Bi',
    'Al-Adhan',
    'AlAdhan',
  ];

  _stringsCheckedPerLocale[locale] =
      (_stringsCheckedPerLocale[locale] ?? 0) + renderedStrings.length;

  for (final str in renderedStrings) {
    final trimmed = str.trim();
    if (trimmed.isEmpty) continue;

    // Check raw key leak
    if (rawKeyRegex.hasMatch(trimmed)) {
      fail('[$screenName in $locale] Leaked unresolved i18n key: "$str"');
    }

    // Check unresolved placeholder
    if (placeholderRegex.hasMatch(trimmed)) {
      fail('[$screenName in $locale] Leaked unresolved placeholder: "$str"');
    }

    // Check script purity
    if (locale == 'en' || locale == 'it') {
      if (banglaRegex.hasMatch(str)) {
        fail('[$screenName in $locale] Leaked Bengali script in string: "$str"');
      }
      if (hindiRegex.hasMatch(str)) {
        fail('[$screenName in $locale] Leaked Devanagari script in string: "$str"');
      }
    } else if (locale == 'hi') {
      if (banglaRegex.hasMatch(str)) {
        fail('[$screenName in $locale] Leaked Bengali script in string: "$str"');
      }
      // Assert no run of 2+ Latin words
      var cleaned = str;
      for (final allowed in allowlistedBrandAndTransliteration) {
        cleaned = cleaned.replaceAll(allowed, '');
      }
      final match = twoLatinWordsRegex.firstMatch(cleaned);
      if (match != null) {
        fail('[$screenName in $locale] Leaked 2+ Latin words "${match.group(0)}" in string: "$str"');
      }
    } else if (locale == 'bn') {
      if (hindiRegex.hasMatch(str)) {
        fail('[$screenName in $locale] Leaked Devanagari script in string: "$str"');
      }
      // Assert no run of 2+ Latin words
      var cleaned = str;
      for (final allowed in allowlistedBrandAndTransliteration) {
        cleaned = cleaned.replaceAll(allowed, '');
      }
      final match = twoLatinWordsRegex.firstMatch(cleaned);
      if (match != null) {
        fail('[$screenName in $locale] Leaked 2+ Latin words "${match.group(0)}" in string: "$str"');
      }
    }
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('flutter_tts'), (call) async => 1);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/shared_preferences'),
            (call) async => null);

    const delegate = AppLocalizationsDelegate();
    await delegate.load(const Locale('en'));
    await delegate.load(const Locale('bn'));
    await delegate.load(const Locale('hi'));
    await delegate.load(const Locale('it'));
  });

  const locales = ['en', 'bn', 'hi', 'it'];

  group('Cross-Script Leakage Widget Tests across all 4 locales (Admin OFF & ON)', () {
    for (final loc in locales) {
      for (final isAdmin in [false, true]) {
        final modeLabel = isAdmin ? 'Admin ON' : 'Admin OFF';

        Future<AppState> buildState() async {
          SharedPreferences.setMockInitialValues({
            'language': loc,
            'onboarding_done': true,
            'user_role': isAdmin ? 'admin' : 'child',
          });
          final state = AppState();
          await state.loadFromPrefs();
          return state;
        }

        testWidgets(
            'QaidaChaptersScreen ($loc, $modeLabel) renders without cross-script leakage',
            (tester) async {
          final state = await buildState();
          await tester.pumpWidget(_TestApp(
            state: state,
            child: const QaidaChaptersScreen(),
          ));
          await tester.pumpAndSettle();

          final strings = _extractAllRenderedStrings(tester);
          expect(strings, isNotEmpty);
          _assertNoCrossScriptLeakage(
            locale: loc,
            screenName: 'QaidaChaptersScreen ($modeLabel)',
            renderedStrings: strings,
          );
        });

        testWidgets(
            'QaidaTrackLessonsScreen ($loc, $modeLabel) renders all tracks without cross-script leakage',
            (tester) async {
          final state = await buildState();
          for (final track in QaidaCurriculumData.tracks) {
            await tester.pumpWidget(_TestApp(
              state: state,
              child: QaidaTrackLessonsScreen(track: track),
            ));
            await tester.pumpAndSettle();

            final strings = _extractAllRenderedStrings(tester);
            expect(strings, isNotEmpty);
            _assertNoCrossScriptLeakage(
              locale: loc,
              screenName: 'QaidaTrackLessonsScreen (${track.id}, $modeLabel)',
              renderedStrings: strings,
            );
          }
        });

        testWidgets(
            'QaidaReportScreen ($loc, $modeLabel) renders without cross-script leakage',
            (tester) async {
          final state = await buildState();
          await tester.pumpWidget(_TestApp(
            state: state,
            child: const QaidaReportScreen(),
          ));
          await tester.pumpAndSettle();

          final strings = _extractAllRenderedStrings(tester);
          expect(strings, isNotEmpty);
          _assertNoCrossScriptLeakage(
            locale: loc,
            screenName: 'QaidaReportScreen ($modeLabel)',
            renderedStrings: strings,
          );
        });

        testWidgets(
            'QaidaRevisionScreen ($loc, $modeLabel) renders without cross-script leakage',
            (tester) async {
          final state = await buildState();
          await tester.pumpWidget(_TestApp(
            state: state,
            child: const QaidaRevisionScreen(),
          ));
          await tester.pumpAndSettle();

          final strings = _extractAllRenderedStrings(tester);
          expect(strings, isNotEmpty);
          _assertNoCrossScriptLeakage(
            locale: loc,
            screenName: 'QaidaRevisionScreen ($modeLabel)',
            renderedStrings: strings,
          );
        });

        testWidgets(
            'QaidaNextCourseScreen ($loc, $modeLabel) renders without cross-script leakage',
            (tester) async {
          final state = await buildState();
          await tester.pumpWidget(_TestApp(
            state: state,
            child: const QaidaNextCourseScreen(initialIndex: 0),
          ));
          await tester.pumpAndSettle();

          final strings = _extractAllRenderedStrings(tester);
          expect(strings, isNotEmpty);
          _assertNoCrossScriptLeakage(
            locale: loc,
            screenName: 'QaidaNextCourseScreen ($modeLabel)',
            renderedStrings: strings,
          );
        });

        testWidgets(
            'QaidaLessonScreen ($loc, $modeLabel) renders ALL lessons across all 17 steps without cross-script leakage',
            (tester) async {
          final state = await buildState();
          int renderedCount = 0;

          for (final step in NuraniQaidaData.steps) {
            for (final lesson in step.lessons) {
              await tester.pumpWidget(_TestApp(
                state: state,
                child: QaidaLessonScreen(
                  lessonId: lesson.id,
                  lessonTitle: lesson.title,
                  letter: lesson.arabicDisplay,
                  letterName: lesson.title,
                  options: lesson.activities.isNotEmpty && lesson.activities.first.options.isNotEmpty
                      ? lesson.activities.first.options
                      : const ['ا', 'ب', 'ت'],
                  makhrajNote: lesson.makhrajKey ?? lesson.description,
                ),
              ));
              await tester.pumpAndSettle();

              final strings = _extractAllRenderedStrings(tester);
              expect(strings, isNotEmpty);
              _assertNoCrossScriptLeakage(
                locale: loc,
                screenName: 'QaidaLessonScreen (${lesson.id}, $modeLabel)',
                renderedStrings: strings,
              );
              renderedCount++;
            }
          }
          debugPrint('>>> [LESSONS_RENDERED] Locale: $loc ($modeLabel): $renderedCount lessons across 17 steps');
        });

        testWidgets(
            'QaidaActivityScreen ($loc, $modeLabel) renders ALL lessons across all 8 tracks without cross-script leakage',
            (tester) async {
          final state = await buildState();
          int renderedTrackLessonCount = 0;

          for (final track in QaidaCurriculumData.tracks) {
            for (final trackLesson in track.lessons) {
              await tester.pumpWidget(_TestApp(
                state: state,
                child: QaidaActivityScreen(lesson: trackLesson),
              ));
              await tester.pumpAndSettle();

              final strings = _extractAllRenderedStrings(tester);
              expect(strings, isNotEmpty);
              _assertNoCrossScriptLeakage(
                locale: loc,
                screenName: 'QaidaActivityScreen (${track.id}:${trackLesson.id}, $modeLabel)',
                renderedStrings: strings,
              );
              renderedTrackLessonCount++;
            }
          }
          debugPrint('>>> [TRACK_LESSONS_RENDERED] Locale: $loc ($modeLabel): $renderedTrackLessonCount track lessons across 8 tracks');
        });

        testWidgets(
            'QaidaExamScreen ($loc, $modeLabel) renders ALL exams across all 17 steps without cross-script leakage',
            (tester) async {
          final state = await buildState();
          int renderedExamCount = 0;

          for (final step in NuraniQaidaData.steps) {
            await tester.pumpWidget(_TestApp(
              state: state,
              child: QaidaExamScreen(
                tier: QaidaExamTier.stepBoss,
                step: step,
              ),
            ));
            await tester.pumpAndSettle();

            final strings = _extractAllRenderedStrings(tester);
            expect(strings, isNotEmpty);
            _assertNoCrossScriptLeakage(
              locale: loc,
              screenName: 'QaidaExamScreen (step_${step.stepNumber}, $modeLabel)',
              renderedStrings: strings,
            );
            renderedExamCount++;
          }
          debugPrint('>>> [EXAMS_RENDERED] Locale: $loc ($modeLabel): $renderedExamCount exams across 17 steps');
        });
      }
    }

    tearDownAll(() {
      for (final loc in locales) {
        debugPrint('>>> [STRINGS_CHECKED] Locale: $loc: ${_stringsCheckedPerLocale[loc] ?? 0} strings checked');
      }
    });
  });
}

