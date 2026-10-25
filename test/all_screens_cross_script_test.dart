import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/data/nurani_qaida_data.dart';
import 'package:little_muslim/data/qaida_curriculum_data.dart';
import 'package:little_muslim/l10n/app_localizations.dart';
import 'package:little_muslim/screens/achievements/achievements_screen.dart';
import 'package:little_muslim/screens/basics/islam_basics_screen.dart';
import 'package:little_muslim/screens/duas/duas_screen.dart';
import 'package:little_muslim/screens/home/home_screen.dart';
import 'package:little_muslim/screens/live_learning/live_learning_screen.dart';
import 'package:little_muslim/screens/missions/daily_missions_screen.dart';
import 'package:little_muslim/screens/onboarding/language_page.dart';
import 'package:little_muslim/screens/onboarding/name_age_page.dart';
import 'package:little_muslim/screens/onboarding/onboarding_screen.dart';
import 'package:little_muslim/screens/onboarding/ready_page.dart';
import 'package:little_muslim/screens/onboarding/welcome_page.dart';
import 'package:little_muslim/screens/prayer/prayer_screen.dart';
import 'package:little_muslim/screens/profile/login_screen.dart';
import 'package:little_muslim/screens/profile/profile_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_activity_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_chapters_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_exam_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_lesson_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_next_course_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_report_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_revision_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_track_lessons_screen.dart';
import 'package:little_muslim/screens/quran/quran_data.dart';
import 'package:little_muslim/screens/quran/quran_reader_screen.dart';
import 'package:little_muslim/screens/quran/quran_screen.dart';
import 'package:little_muslim/screens/seerah/seerah_screen.dart';
import 'package:little_muslim/screens/settings/settings_screen.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CrossScriptTestApp extends StatelessWidget {
  const _CrossScriptTestApp({required this.state, required this.child});
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
          home: Material(child: child),
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
  for (final element in find.byType(EditableText).evaluate()) {
    final widget = element.widget as EditableText;
    final s = widget.controller.text;
    if (s.isNotEmpty) strings.add(s);
  }
  return strings;
}

final _rawKeyRegex = RegExp(r'^[a-z][a-zA-Z0-9_]*(\.[a-zA-Z0-9_]+)+$');
final _embeddedRawKeyRegex = RegExp(r'\b[a-z][a-zA-Z0-9_]*(\.[a-zA-Z0-9_]+)+\b');

const _allowedDottedTokens = {
  'quran.com',
  'alquran.cloud',
  'api.alquran.cloud',
  'meet.google.com',
  'zoom.us',
  'example.com',
  'github.com',
  'flutter.dev',
  'e.g',
  'i.e',
};

bool _isAllowedDottedToken(String token) {
  if (_allowedDottedTokens.contains(token.toLowerCase())) return true;
  if (token.endsWith('.mp3') ||
      token.endsWith('.png') ||
      token.endsWith('.jpg') ||
      token.endsWith('.json')) {
    return true;
  }
  if (RegExp(r'^v?\d+(\.\d+)+$').hasMatch(token)) return true;
  return false;
}

final _bengaliRegex = RegExp(r'[\u0980-\u09FF]');
// Indic dandas (\u0964, \u0965) are shared Indic punctuation. Exclude from pure Devanagari letters.
final _devanagariRegex = RegExp(r'[\u0900-\u0963\u0966-\u097F]');
final _twoLatinWordsRegex = RegExp(r'\b[a-zA-Z]{2,}\s+[a-zA-Z]{2,}\b');

const _allowedLatinPhrases = [
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
  'Al-Fatiha',
  'Al-Faatiha',
  'Al-Baqarah',
  'Yasin',
  'Ya-Sin',
  'Al-Ikhlas',
  'Al-Falaq',
  'An-Nas',
  'Google',
  'Apple',
  'Ahmad',
  'Zainab',
  'English',
  'Italiano',
  'Italian',
  'Bengali',
  'Hindi',
  'Quran.com',
  'Al Quran Cloud',
];

void _assertScreenStrings({
  required String screenName,
  required String locale,
  required List<String> strings,
}) {
  bool hasBengaliChar = false;
  bool hasDevanagariChar = false;

  final isLanguagePicker =
      screenName == 'LanguagePage' || screenName == 'OnboardingScreen';

  for (final str in strings) {
    final trimmed = str.trim();
    if (trimmed.isEmpty) continue;

    // 1. Raw key assertion: Must NOT match raw key regex (standalone or embedded)
    final embeddedKeyMatches = _embeddedRawKeyRegex.allMatches(trimmed);
    for (final match in embeddedKeyMatches) {
      final keyCandidate = match.group(0)!;
      if (!_isAllowedDottedToken(keyCandidate)) {
        fail('[$screenName in "$locale"] Raw translation key rendered in UI: "$keyCandidate" inside "$trimmed"');
      }
    }

    if (_bengaliRegex.hasMatch(str)) hasBengaliChar = true;
    if (_devanagariRegex.hasMatch(str)) hasDevanagariChar = true;

    // In language selector widgets, native language names ('বাংলা', 'हिंदी', etc.) are expected.
    if (isLanguagePicker) {
      if (AppLanguages.all.any((lang) =>
          str == lang.nativeName ||
          str == lang.name ||
          str == lang.englishName)) {
        continue;
      }
    }

    // 2. Script purity assertions
    if (locale == 'bn') {
      if (_devanagariRegex.hasMatch(str)) {
        fail('[$screenName in "$locale"] Leaked Devanagari script in string: "$str"');
      }
      var cleaned = str;
      for (final allowed in _allowedLatinPhrases) {
        cleaned = cleaned.replaceAll(allowed, '');
      }
      // Also allow standalone time formats like 05:12 AM / PM
      cleaned = cleaned.replaceAll(RegExp(r'\b(AM|PM|XP|LVL)\b', caseSensitive: false), '');
      final match = _twoLatinWordsRegex.firstMatch(cleaned);
      if (match != null) {
        fail('[$screenName in "$locale"] Leaked 2+ Latin words "${match.group(0)}" in string: "$str"');
      }
    } else if (locale == 'hi') {
      if (_bengaliRegex.hasMatch(str)) {
        fail('[$screenName in "$locale"] Leaked Bengali script in string: "$str"');
      }
      var cleaned = str;
      for (final allowed in _allowedLatinPhrases) {
        cleaned = cleaned.replaceAll(allowed, '');
      }
      cleaned = cleaned.replaceAll(RegExp(r'\b(AM|PM|XP|LVL)\b', caseSensitive: false), '');
      final match = _twoLatinWordsRegex.firstMatch(cleaned);
      if (match != null) {
        fail('[$screenName in "$locale"] Leaked 2+ Latin words "${match.group(0)}" in string: "$str"');
      }
    } else if (locale == 'en' || locale == 'it') {
      if (_bengaliRegex.hasMatch(str)) {
        fail('[$screenName in "$locale"] Leaked Bengali script in string: "$str"');
      }
      if (_devanagariRegex.hasMatch(str)) {
        fail('[$screenName in "$locale"] Leaked Devanagari script in string: "$str"');
      }
    }
  }

  // Target script presence assertion
  if (locale == 'bn') {
    expect(hasBengaliChar, isTrue,
        reason: '[$screenName in "$locale"] Must contain at least one Bengali character on screen');
  } else if (locale == 'hi') {
    expect(hasDevanagariChar, isTrue,
        reason: '[$screenName in "$locale"] Must contain at least one Devanagari character on screen');
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

    for (final ch in [
      'xyz.luan/audioplayers.global',
      'xyz.luan/audioplayers.global/events',
      'xyz.luan/audioplayers',
      'xyz.luan/audioplayers/events',
    ]) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(MethodChannel(ch), (call) async => 1);
    }

    const delegate = AppLocalizationsDelegate();
    await delegate.load(const Locale('en'));
    await delegate.load(const Locale('bn'));
    await delegate.load(const Locale('hi'));
    await delegate.load(const Locale('it'));

    await AlQuranCloudRepository.preloadBundledData();
  });

  group('Task 3 b: Regex Self-Test Against Raw Keys', () {
    test('rawKeyRegex correctly catches raw translation keys and accepts normal UI prose', () {
      // Must match known raw keys
      expect(_rawKeyRegex.hasMatch('qaida.step.2.desc'), isTrue);
      expect(_rawKeyRegex.hasMatch('qaida.step.3.desc'), isTrue);
      expect(_rawKeyRegex.hasMatch('qaida.step.1.desc'), isTrue);
      expect(_rawKeyRegex.hasMatch('quran.surah.1.name'), isTrue);
      expect(_rawKeyRegex.hasMatch('quran.surah.1.meaning'), isTrue);
      expect(_rawKeyRegex.hasMatch('settings.title'), isTrue);
      expect(_rawKeyRegex.hasMatch('home.welcome_back'), isTrue);

      // Must reject normal display text in all languages
      expect(_rawKeyRegex.hasMatch('Home'), isFalse);
      expect(_rawKeyRegex.hasMatch('শুরু করছি আল্লাহর নামে'), isFalse);
      expect(_rawKeyRegex.hasMatch('সূরহ আল-ফাতিহা'), isFalse);
      expect(_rawKeyRegex.hasMatch('सूरह अल-फ़ातिहा'), isFalse);
      expect(_rawKeyRegex.hasMatch('अल्लाह के नाम से'), isFalse);
      expect(_rawKeyRegex.hasMatch('In nome di Allah'), isFalse);
      expect(_rawKeyRegex.hasMatch('In the name of Allah, the Entirely Merciful, the Especially Merciful.'), isFalse);

      // Embedded raw key detection
      expect(_embeddedRawKeyRegex.hasMatch('In Progress: Step 1: qaida.step.1.title'), isTrue);
      expect(_embeddedRawKeyRegex.firstMatch('In Progress: Step 1: qaida.step.1.title')?.group(0), 'qaida.step.1.title');
      expect(_isAllowedDottedToken('quran.com'), isTrue);
      expect(_isAllowedDottedToken('qaida.step.1.title'), isFalse);
    });
  });

  group('Task 3 a, b, c: 26 Screens Cross-Script & Raw Key Verification Across All 4 Locales', () {
    const locales = ['en', 'bn', 'hi', 'it'];
    final ayah1Translations = <String, String>{};

    for (final loc in locales) {
      testWidgets('Render all 26 screens under "$loc" with strict raw-key and script purity assertions',
          (tester) async {
        tester.view.physicalSize = const Size(1200, 2400);
        tester.view.devicePixelRatio = 1.0;
        final originalOnError = FlutterError.onError;
        FlutterError.onError = (FlutterErrorDetails details) {
          final msg = details.exceptionAsString();
          if (msg.contains('overflowed') ||
              msg.contains('RenderFlex') ||
              msg.contains('audioplayers') ||
              msg.contains('MissingPluginException')) {
            return;
          }
          originalOnError?.call(details);
        };
        addTearDown(() {
          tester.view.resetPhysicalSize();
          FlutterError.onError = originalOnError;
        });

        SharedPreferences.setMockInitialValues({
          'language': loc,
          'onboarding_done': true,
          'user_name': 'Ahmad',
          'user_age': 8,
          'streak_count': 5,
          'xp': 120,
          'completed_lessons': ['qaida_step1_alif'],
        });
        final state = AppState();
        await state.loadFromPrefs();
        await state.updateLanguage(loc);

        final renderedScreens = <String>[];

        Future<void> pumpAndVerify(String name, Widget widget, {bool isScrollable = false}) async {
          // ignore: avoid_print
          print('===> PUMPING $name in $loc');
          renderedScreens.add(name);
          await tester.pumpWidget(_CrossScriptTestApp(state: state, child: widget));
          await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
          await tester.pumpAndSettle();

          var strings = _extractAllRenderedStrings(tester);
          _assertScreenStrings(screenName: name, locale: loc, strings: strings);

          // For QaidaChaptersScreen, scroll through all 17 steps to force their lazy widgets to build
          if (isScrollable && name == 'QaidaChaptersScreen') {
            final scrollableFinder = find.byType(ListView);
            expect(scrollableFinder, findsOneWidget);
            for (var i = 0; i < 17; i++) {
              await tester.drag(scrollableFinder, const Offset(0, -350));
              await tester.pumpAndSettle();
              final scrolledStrings = _extractAllRenderedStrings(tester);
              _assertScreenStrings(screenName: '$name (Step scroll $i)', locale: loc, strings: scrolledStrings);
            }
          }
        }

        // 1. HomeScreen
        await pumpAndVerify('HomeScreen', const HomeScreen());

        // 2. PrayerScreen
        await pumpAndVerify('PrayerScreen', const PrayerScreen());

        // 3. QuranScreen
        await pumpAndVerify('QuranScreen', const QuranScreen());

        // 4. QuranReaderScreen (Surahs 1, 2, 36, 112, 114)
        final surahs = await AlQuranCloudRepository().getSurahs(locale: loc);
        final surah1 = surahs.firstWhere((s) => s.number == 1);
        final surah2 = surahs.firstWhere((s) => s.number == 2);
        final surah36 = surahs.firstWhere((s) => s.number == 36);
        final surah112 = surahs.firstWhere((s) => s.number == 112);
        final surah114 = surahs.firstWhere((s) => s.number == 114);

        // Test QuranReaderScreen with Surah 1 and extract Ayah 1 translation
        await pumpAndVerify('QuranReaderScreen', QuranReaderScreen(surah: surah1));

        // Extract translation of Ayah 1 for verification
        final readerStrings = _extractAllRenderedStrings(tester);
        String? ayah1Text;
        for (final s in readerStrings) {
          if (loc == 'en' && s.contains('In the name of Allah')) {
            ayah1Text = s;
            break;
          } else if (loc == 'bn' && s.contains('শুরু করছি আল্লাহর নামে')) {
            ayah1Text = s;
            break;
          } else if (loc == 'hi' && s.contains('अल्लाह के नाम से')) {
            ayah1Text = s;
            break;
          } else if (loc == 'it' && s.contains('In nome di Allah')) {
            ayah1Text = s;
            break;
          }
        }
        expect(ayah1Text, isNotNull,
            reason: 'Ayah 1 translation not found for locale "$loc" in reader strings: $readerStrings');
        ayah1Translations[loc] = ayah1Text!;

        // Also verify QuranReaderScreen on other bundled surahs (Surahs 2, 36, 112, 114)
        for (final surah in [surah2, surah36, surah112, surah114]) {
          await tester.pumpWidget(
              _CrossScriptTestApp(state: state, child: QuranReaderScreen(surah: surah)));
          await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
          await tester.pumpAndSettle();
          final extraStrings = _extractAllRenderedStrings(tester);
          _assertScreenStrings(
              screenName: 'QuranReaderScreen(Surah ${surah.number})',
              locale: loc,
              strings: extraStrings);
        }

        // 5. DuasScreen
        await pumpAndVerify('DuasScreen', const DuasScreen());

        // 6. SeerahScreen
        await pumpAndVerify('SeerahScreen', const SeerahScreen());

        // 7. IslamBasicsScreen
        await pumpAndVerify('IslamBasicsScreen', const IslamBasicsScreen());

        // 8. DailyMissionsScreen
        await pumpAndVerify('DailyMissionsScreen', const DailyMissionsScreen());

        // 9. AchievementsScreen
        await pumpAndVerify('AchievementsScreen', const AchievementsScreen());

        // 10. SettingsScreen
        await pumpAndVerify('SettingsScreen', const SettingsScreen());

        // 11. ProfileScreen
        await pumpAndVerify('ProfileScreen', const ProfileScreen());

        // 12. LoginScreen
        await pumpAndVerify('LoginScreen', const LoginScreen());

        // 13. LiveLearningScreen
        await pumpAndVerify('LiveLearningScreen', const LiveLearningScreen());

        // 14. OnboardingScreen
        await pumpAndVerify('OnboardingScreen', const OnboardingScreen());

        // 15. LanguagePage
        await pumpAndVerify(
          'LanguagePage',
          LanguagePage(isTablet: false, onNext: () {}, onBack: () {}),
        );

        // 16. NameAgePage
        await pumpAndVerify(
          'NameAgePage',
          NameAgePage(isTablet: false, onNext: () {}, onBack: () {}),
        );

        // 17. ReadyPage
        await pumpAndVerify(
          'ReadyPage',
          ReadyPage(isTablet: false, onBack: () {}),
        );

        // 18. WelcomePage
        await pumpAndVerify(
          'WelcomePage',
          WelcomePage(isTablet: false, onNext: () {}),
        );

        // 19. QaidaChaptersScreen (with 17-step scrolling to force lazy widgets)
        await pumpAndVerify(
          'QaidaChaptersScreen',
          const QaidaChaptersScreen(),
          isScrollable: true,
        );

        // 20. QaidaLessonScreen
        await pumpAndVerify(
          'QaidaLessonScreen',
          const QaidaLessonScreen(
            lessonId: '1',
            lessonTitle: 'Alif',
            letter: 'ا',
            letterName: 'Alif',
            options: ['ا', 'ب', 'ت'],
          ),
        );

        // 21. QaidaTrackLessonsScreen
        await pumpAndVerify(
          'QaidaTrackLessonsScreen',
          QaidaTrackLessonsScreen(track: QaidaCurriculumData.tracks.first),
        );

        // 22. QaidaActivityScreen
        await pumpAndVerify(
          'QaidaActivityScreen',
          QaidaActivityScreen(lesson: QaidaCurriculumData.tracks.first.lessons.first),
        );
        await tester.pump(const Duration(seconds: 2));

        // 23. QaidaExamScreen
        await pumpAndVerify(
          'QaidaExamScreen',
          QaidaExamScreen(tier: QaidaExamTier.stepBoss, step: NuraniQaidaData.steps.first),
        );

        // 24. QaidaReportScreen
        await pumpAndVerify('QaidaReportScreen', const QaidaReportScreen());

        // 25. QaidaRevisionScreen
        await pumpAndVerify('QaidaRevisionScreen', const QaidaRevisionScreen());

        // 26. QaidaNextCourseScreen
        await pumpAndVerify('QaidaNextCourseScreen', const QaidaNextCourseScreen());

        // Output and verify screen count
        debugPrint('Rendered ${renderedScreens.length} screens for locale "$loc":');
        for (var i = 0; i < renderedScreens.length; i++) {
          debugPrint('  [${i + 1}/26] ${renderedScreens[i]}');
        }
        expect(renderedScreens.length, 26,
            reason: 'Must render exactly 26 distinct screen widgets for locale "$loc"');
      });
    }

    test('QuranReaderScreen Surah 1 Ayah 1 translation assertion (en != bn != hi != it)', () {
      final en = ayah1Translations['en'];
      final bn = ayah1Translations['bn'];
      final hi = ayah1Translations['hi'];
      final it = ayah1Translations['it'];

      expect(en, isNotNull);
      expect(bn, isNotNull);
      expect(hi, isNotNull);
      expect(it, isNotNull);

      // Verify specific expected translation texts
      expect(en, equals('In the name of Allah, the Entirely Merciful, the Especially Merciful.'));
      expect(bn, contains('শুরু করছি আল্লাহর নামে'));
      expect(hi, contains('अल्लाह के नाम से'));
      expect(it, contains('In nome di Allah'));

      // Assert complete distinctness across all 4 locales
      expect(en != bn, isTrue);
      expect(en != hi, isTrue);
      expect(en != it, isTrue);
      expect(bn != hi, isTrue);
      expect(bn != it, isTrue);
      expect(hi != it, isTrue);
    });
  });
}
