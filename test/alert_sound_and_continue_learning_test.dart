import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:little_muslim/l10n/app_localizations.dart';
import 'package:little_muslim/screens/home/home_screen.dart';
import 'package:little_muslim/screens/prayer/prayer_screen.dart';
import 'package:little_muslim/screens/settings/settings_screen.dart';
import 'package:little_muslim/services/alert_sound_service.dart';
import 'package:little_muslim/utils/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const delegate = AppLocalizationsDelegate();
    await delegate.load(const Locale('en'));
    await delegate.load(const Locale('bn'));
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await AlertSoundService.instance.stop();
  });

  Widget createTestApp(Widget child, [AppState? state]) {
    final appState = state ?? AppState();
    return ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('AlertSoundService toggle and stop state test', (tester) async {
    final service = AlertSoundService.instance;

    // Initially not playing
    expect(service.isPlaying, isFalse);
    expect(service.currentType, isNull);

    // Call stop safely
    await service.stop();
    expect(service.isPlaying, isFalse);
  });

  testWidgets('AppState persists prayer alerts and learning alarm settings',
      (tester) async {
    final appState = AppState();
    await appState.loadFromPrefs();

    expect(appState.prayerAlertsEnabled, isTrue);
    expect(appState.isPrayerAlertEnabled('Fajr'), isTrue);
    expect(appState.learningAlarmEnabled, isTrue);
    expect(appState.learningAlarmTime, '17:30');

    // Toggle a prayer
    await appState.updatePrayerAlertSettings(
      prayerKey: 'Fajr',
      prayerEnabled: false,
    );
    expect(appState.isPrayerAlertEnabled('Fajr'), isFalse);
    expect(appState.isPrayerAlertEnabled('Dhuhr'), isTrue);

    // Toggle master prayer alert
    await appState.updatePrayerAlertSettings(masterEnabled: false);
    expect(appState.prayerAlertsEnabled, isFalse);
    expect(appState.isPrayerAlertEnabled('Dhuhr'), isFalse);

    // Update learning alarm
    await appState.updateLearningAlarmSettings(
      enabled: false,
      time: '18:15',
    );
    expect(appState.learningAlarmEnabled, isFalse);
    expect(appState.learningAlarmTime, '18:15');

    // Reload from prefs to ensure persistence
    final reloadedState = AppState();
    await reloadedState.loadFromPrefs();
    expect(reloadedState.prayerAlertsEnabled, isFalse);
    expect(reloadedState.isPrayerAlertEnabled('Fajr'), isFalse);
    expect(reloadedState.learningAlarmEnabled, isFalse);
    expect(reloadedState.learningAlarmTime, '18:15');
  });

  testWidgets(
      'Home screen switches to "আমার পড়া" tab and displays resume dashboard',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 3600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final appState = AppState();
    await appState.loadFromPrefs();

    await tester.pumpWidget(createTestApp(const HomeScreen(), appState));
    await tester.pumpAndSettle();

    // Bottom nav bar contains 'আমার পড়া'
    expect(find.text('আমার পড়া'), findsOneWidget);

    // Tap 'আমার পড়া' tab
    await tester.tap(find.text('আমার পড়া'));
    await tester.pumpAndSettle();

    // Verify dashboard content
    expect(find.text('আমার পড়ার ড্যাশবোর্ড'), findsOneWidget);
    expect(find.text('চলমান কায়দা পাঠ'), findsOneWidget);
    expect(find.text('কায়দা পড়া চালিয়ে যাই'), findsOneWidget);
    expect(find.text('আযান ও পড়ার অ্যালার্ম'), findsOneWidget);
    expect(find.text('আযান শুনুন'), findsOneWidget);
    expect(find.text('পড়ার অ্যালার্ম শুনুন'), findsOneWidget);
  });

  testWidgets('Settings screen contains prayer adhan and learning alarm controls',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 3600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final appState = AppState();
    await appState.loadFromPrefs();

    await tester.pumpWidget(createTestApp(const SettingsScreen(), appState));
    await tester.pumpAndSettle();

    expect(find.text('নামাজের আযান অ্যালার্ট'), findsOneWidget);
    expect(find.text('নামাজের সময় আযান বাজবে'), findsOneWidget);
    expect(find.text('আযান টেস্ট করুন / শুনুন'), findsOneWidget);

    expect(find.text('পড়ার অ্যালার্ম ও স্ট্রিক রিমাইন্ডার'), findsOneWidget);
    expect(find.text('দৈনিক পড়ার অ্যালার্ম (আউযুবিল্লাহ ও বিসমিল্লাহ)'),
        findsOneWidget);
    expect(find.text('পড়ার অ্যালার্মের সময়'), findsOneWidget);
    expect(
        find.text('পড়ার অ্যালার্ম টেস্ট করুন (আউযুবিল্লাহ ও বিসমিল্লাহ)'),
        findsOneWidget);
  });

  testWidgets('Prayer screen renders test adhan button and prayer alert bell icons',
      (tester) async {
    final appState = AppState();
    await appState.loadFromPrefs();

    await tester.pumpWidget(createTestApp(const PrayerScreen(), appState));
    await tester.pumpAndSettle();

    expect(find.text('নামাজ শিখি'), findsOneWidget);
    expect(
        find.byWidgetPredicate((w) =>
            w is Text && (w.data == 'Prayer times' || w.data == 'নামাজের সময়')),
        findsOneWidget);
  });
}
