import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:little_muslim/l10n/app_localizations.dart';
import 'package:little_muslim/screens/achievements/achievements_screen.dart';
import 'package:little_muslim/screens/duas/duas_screen.dart';
import 'package:little_muslim/screens/home/home_screen.dart';
import 'package:little_muslim/screens/live_learning/live_learning_screen.dart';
import 'package:little_muslim/screens/missions/daily_missions_screen.dart';
import 'package:little_muslim/screens/onboarding/language_page.dart';
import 'package:little_muslim/screens/onboarding/onboarding_screen.dart';
import 'package:little_muslim/screens/prayer/prayer_screen.dart';
import 'package:little_muslim/screens/profile/login_screen.dart';
import 'package:little_muslim/screens/profile/profile_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_chapters_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_exam_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_lesson_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_report_screen.dart';
import 'package:little_muslim/screens/quran/quran_screen.dart';
import 'package:little_muslim/screens/seerah/seerah_screen.dart';
import 'package:little_muslim/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _VerificationApp extends StatelessWidget {
  const _VerificationApp({required this.state, required this.child});
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

  group('Phase 7: Language Persistence & SharedPreferences Reload Tests', () {
    for (final lang in ['en', 'bn', 'hi', 'it']) {
      test('Language "$lang" persists across app reload / SharedPreferences',
          () async {
        // Step 1: Initialize with mock prefs
        SharedPreferences.setMockInitialValues({'language': 'en'});
        final state1 = AppState();
        await state1.loadFromPrefs();

        // Step 2: Switch to target language
        await state1.updateLanguage(lang);
        expect(state1.selectedLanguage, lang);

        // Step 3: Simulate fresh app boot / page reload
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('language'), lang);

        final state2 = AppState();
        await state2.loadFromPrefs();
        expect(state2.selectedLanguage, lang,
            reason: 'Persisted language must be restored on reload');
      });
    }
  });

  group('Phase 7: Fallback & Resilience Verification', () {
    testWidgets('Missing key in target locale falls back to English',
        (tester) async {
      SharedPreferences.setMockInitialValues({'language': 'hi'});
      final state = AppState();
      await state.loadFromPrefs();

      await tester.pumpWidget(
        _VerificationApp(
          state: state,
          child: Builder(
            builder: (context) {
              // Known key that exists
              final known = context.t('settings.title');
              // Key that doesn't exist anywhere
              final missing = context.t('non.existent.dummy.key');
              return Column(
                children: [
                  Text('Known: $known'),
                  Text('Missing: $missing'),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Known: सेटिंग्स'), findsOneWidget);
      // Untranslated keys gracefully return the key itself without crashing
      expect(find.text('Missing: non.existent.dummy.key'), findsOneWidget);
    });
  });

  group('Phase 7: Screen-by-Screen Multi-Language (All 4 Locales) Verification', () {
    const locales = ['en', 'bn', 'hi', 'it'];

    for (final loc in locales) {
      testWidgets('SettingsScreen renders completely in "$loc"', (tester) async {
        SharedPreferences.setMockInitialValues({
          'language': loc,
          'onboarding_done': true,
          'user_name': 'Ahmad',
          'user_age': 8,
        });
        final state = AppState();
        await state.loadFromPrefs();

        await tester.pumpWidget(
          _VerificationApp(state: state, child: const SettingsScreen()),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        // Check that screen rendered without crashing
        expect(find.byType(SettingsScreen), findsOneWidget);
        // Verify no placeholder TODOs exist in widget tree
        expect(find.textContaining('TODO'), findsNothing);
      });

      testWidgets('DailyMissionsScreen renders completely in "$loc"', (tester) async {
        SharedPreferences.setMockInitialValues({
          'language': loc,
          'onboarding_done': true,
          'user_name': 'Ahmad',
        });
        final state = AppState();
        await state.loadFromPrefs();

        await tester.pumpWidget(
          _VerificationApp(state: state, child: const DailyMissionsScreen()),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        expect(find.byType(DailyMissionsScreen), findsOneWidget);
        expect(find.textContaining('TODO'), findsNothing);
      });

      testWidgets('AchievementsScreen renders completely in "$loc"', (tester) async {
        SharedPreferences.setMockInitialValues({
          'language': loc,
          'onboarding_done': true,
          'user_name': 'Ahmad',
        });
        final state = AppState();
        await state.loadFromPrefs();

        await tester.pumpWidget(
          _VerificationApp(state: state, child: const AchievementsScreen()),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        expect(find.byType(AchievementsScreen), findsOneWidget);
        expect(find.textContaining('TODO'), findsNothing);
      });

      testWidgets('PrayerScreen renders completely in "$loc"', (tester) async {
        SharedPreferences.setMockInitialValues({
          'language': loc,
          'onboarding_done': true,
        });
        final state = AppState();
        await state.loadFromPrefs();

        await tester.pumpWidget(
          _VerificationApp(state: state, child: const PrayerScreen()),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        expect(find.byType(PrayerScreen), findsOneWidget);
        expect(find.textContaining('TODO'), findsNothing);
      });

      testWidgets('DuasScreen renders completely in "$loc"', (tester) async {
        SharedPreferences.setMockInitialValues({
          'language': loc,
          'onboarding_done': true,
        });
        final state = AppState();
        await state.loadFromPrefs();

        await tester.pumpWidget(
          _VerificationApp(state: state, child: const DuasScreen()),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        expect(find.byType(DuasScreen), findsOneWidget);
        expect(find.textContaining('TODO'), findsNothing);
      });

      testWidgets('SeerahScreen renders completely in "$loc"', (tester) async {
        SharedPreferences.setMockInitialValues({
          'language': loc,
          'onboarding_done': true,
        });
        final state = AppState();
        await state.loadFromPrefs();

        await tester.pumpWidget(
          _VerificationApp(state: state, child: const SeerahScreen()),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        expect(find.byType(SeerahScreen), findsOneWidget);
        expect(find.textContaining('TODO'), findsNothing);
      });

      testWidgets('QuranScreen renders completely in "$loc"', (tester) async {
        SharedPreferences.setMockInitialValues({
          'language': loc,
          'onboarding_done': true,
        });
        final state = AppState();
        await state.loadFromPrefs();

        await tester.pumpWidget(
          _VerificationApp(state: state, child: const QuranScreen()),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        expect(find.byType(QuranScreen), findsOneWidget);
        expect(find.textContaining('TODO'), findsNothing);
      });

      testWidgets('QaidaReportScreen renders completely in "$loc"', (tester) async {
        SharedPreferences.setMockInitialValues({
          'language': loc,
          'onboarding_done': true,
        });
        final state = AppState();
        await state.loadFromPrefs();

        await tester.pumpWidget(
          _VerificationApp(state: state, child: const QaidaReportScreen()),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        expect(find.byType(QaidaReportScreen), findsOneWidget);
        expect(find.textContaining('TODO'), findsNothing);
      });

      testWidgets('QaidaChaptersScreen renders completely in "$loc"', (tester) async {
        SharedPreferences.setMockInitialValues({
          'language': loc,
          'onboarding_done': true,
        });
        final state = AppState();
        await state.loadFromPrefs();

        await tester.pumpWidget(
          _VerificationApp(state: state, child: const QaidaChaptersScreen()),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        expect(find.byType(QaidaChaptersScreen), findsOneWidget);
        expect(find.textContaining('TODO'), findsNothing);
      });

      testWidgets('LanguagePage renders completely in "$loc"', (tester) async {
        SharedPreferences.setMockInitialValues({
          'language': loc,
        });
        final state = AppState();
        await state.loadFromPrefs();

        await tester.pumpWidget(
          _VerificationApp(
            state: state,
            child: LanguagePage(
              isTablet: false,
              onNext: () {},
              onBack: () {},
            ),
          ),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        expect(find.byType(LanguagePage), findsOneWidget);
        expect(find.textContaining('TODO'), findsNothing);
      });

      testWidgets('Profile & Login screens render completely in "$loc"', (tester) async {
        SharedPreferences.setMockInitialValues({
          'language': loc,
          'onboarding_done': true,
          'user_name': 'Zainab',
        });
        final state = AppState();
        await state.loadFromPrefs();

        await tester.pumpWidget(
          _VerificationApp(state: state, child: const ProfileScreen()),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        expect(find.byType(ProfileScreen), findsOneWidget);
        expect(find.textContaining('TODO'), findsNothing);

        await tester.pumpWidget(
          _VerificationApp(state: state, child: const LoginScreen()),
        );
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pumpAndSettle();

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.textContaining('TODO'), findsNothing);
      });
    }
  });
}
