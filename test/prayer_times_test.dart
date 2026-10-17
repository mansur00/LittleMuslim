import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:little_muslim/l10n/app_localizations.dart';
import 'package:little_muslim/screens/prayer/prayer_screen.dart';
import 'package:little_muslim/screens/prayer/prayer_times.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _SynchronousAppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _SynchronousAppLocalizationsDelegate(this.localizations);
  final AppLocalizations localizations;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(localizations);

  @override
  bool shouldReload(_SynchronousAppLocalizationsDelegate old) => false;
}

class _FakePrayerRepository implements PrayerTimesRepository {
  final List<DateTime> dates = [];

  void dispose() {}

  @override
  Future<PrayerTimesResult> calculate({
    required PrayerLocationSelection location,
    required DateTime date,
    required int methodId,
    required int asrSchool,
  }) async {
    dates.add(date);
    return PrayerTimesResult(
      date: date,
      timeZoneId: location.timeZoneId ?? 'Asia/Dhaka',
      times: {
        for (final key in [
          'Fajr',
          'Sunrise',
          'Dhuhr',
          'Asr',
          'Maghrib',
          'Isha'
        ])
          key: DateTime(date.year, date.month, date.day, 5, 15)
      },
    );
  }
}

class _DeniedLocationProvider implements PrayerDeviceLocationProvider {
  @override
  Future<PrayerCoordinates> currentCoordinates() async =>
      throw const DeviceLocationException(DeviceLocationFailure.deniedForever);
  @override
  Future<bool> openAppSettings() async => false;
}

Widget _buildTestApp({
  required AppState state,
  required Widget home,
  AppLocalizations? localizations,
  Key? key,
}) {
  return ChangeNotifierProvider<AppState>.value(
    value: state,
    child: MaterialApp(
      key: key ?? UniqueKey(),
      locale: const Locale('en'),
      supportedLocales: const [Locale('bn'), Locale('en')],
      localizationsDelegates: [
        if (localizations != null)
          _SynchronousAppLocalizationsDelegate(localizations)
        else
          const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AlAdhan request uses fixed date, coordinates and selected methods',
      () async {
    Uri? requested;
    final client = MockClient((request) async {
      requested = request.url;
      return http.Response(
          jsonEncode({
            'code': 200,
            'data': {
              'meta': {'timezone': 'Asia/Dhaka'},
              'timings': {
                'Fajr': '2026-10-12T04:42:00+06:00',
                'Sunrise': '2026-10-12T05:55:00+06:00',
                'Dhuhr': '2026-10-12T11:48:00+06:00',
                'Asr': '2026-10-12T15:05:00+06:00',
                'Maghrib': '2026-10-12T17:40:00+06:00',
                'Isha': '2026-10-12T18:54:00+06:00',
              },
            },
          }),
          200);
    });
    final repository = AlAdhanPrayerTimesRepository(client: client);
    await repository.calculate(
      location: const PrayerLocationSelection.device(
          latitude: 23.8103, longitude: 90.4125),
      date: DateTime(2026, 10, 12),
      methodId: 1,
      asrSchool: 1,
    );
    expect(requested, isNotNull);
    expect(requested!.path, '/v1/timings/12-10-2026');
    expect(requested!.queryParameters['latitude'], '23.8103');
    expect(requested!.queryParameters['longitude'], '90.4125');
    expect(requested!.queryParameters['method'], '1');
    expect(requested!.queryParameters['school'], '1');
    expect(requested!.queryParameters['iso8601'], 'true');
  });

  test('city lookup sends city and country without substituting a location',
      () async {
    Uri? requested;
    final client = MockClient((request) async {
      requested = request.url;
      return http.Response(
          jsonEncode({
            'code': 200,
            'data': {
              'meta': {'timezone': 'Asia/Dhaka'},
              'timings': {
                'Fajr': '2026-10-12T04:42:00+06:00',
                'Sunrise': '2026-10-12T05:55:00+06:00',
                'Dhuhr': '2026-10-12T11:48:00+06:00',
                'Asr': '2026-10-12T15:05:00+06:00',
                'Maghrib': '2026-10-12T17:40:00+06:00',
                'Isha': '2026-10-12T18:54:00+06:00',
              }
            }
          }),
          200);
    });
    final repository = AlAdhanPrayerTimesRepository(client: client);
    await repository.calculate(
      location: const PrayerLocationSelection.city(
          city: 'Dhaka', country: 'Bangladesh'),
      date: DateTime(2026, 10, 12),
      methodId: 1,
      asrSchool: 0,
    );
    expect(requested!.path, '/v1/timingsByCity/12-10-2026');
    expect(requested!.queryParameters['city'], 'Dhaka');
    expect(requested!.queryParameters['country'], 'Bangladesh');
  });

  test(
      'malformed response and invalid coordinates fail without placeholder data',
      () async {
    final badResponse = AlAdhanPrayerTimesRepository(
        client: MockClient((_) async => http.Response('{}', 200)));
    expect(
        () => badResponse.calculate(
              location: const PrayerLocationSelection.device(
                  latitude: 95, longitude: 0),
              date: DateTime(2026),
              methodId: 1,
              asrSchool: 0,
            ),
        throwsA(isA<PrayerTimesException>()));
    final malformed = AlAdhanPrayerTimesRepository(
        client: MockClient((_) async => http.Response('{}', 200)));
    expect(
        malformed.calculate(
          location: const PrayerLocationSelection.city(
              city: 'Dhaka', country: 'Bangladesh'),
          date: DateTime(2026),
          methodId: 1,
          asrSchool: 0,
        ),
        throwsA(isA<PrayerTimesException>()));
  });

  test('settings survive a fresh store instance and ignore invalid coordinates',
      () async {
    SharedPreferences.setMockInitialValues({});
    const settings = PrayerCalculationSettings(
      location: PrayerLocationSelection.city(
          city: 'Dhaka', country: 'Bangladesh', timeZoneId: 'Asia/Dhaka'),
      methodId: 3,
      asrSchool: 0,
    );
    await SharedPreferencesPrayerSettingsStore().save(settings);
    final restored = await SharedPreferencesPrayerSettingsStore().load();
    expect(restored.methodId, 3);
    expect(restored.asrSchool, 0);
    expect(restored.location?.city, 'Dhaka');
    expect(restored.location?.timeZoneId, 'Asia/Dhaka');
    expect(
        PrayerLocationSelection.fromJson(
            {'kind': 'device', 'latitude': 91, 'longitude': 0}),
        isNull);
  });

  test('today follows the requested timezone across a date boundary', () {
    final instant = DateTime.utc(2026, 10, 11, 18, 30);
    expect(PrayerDateTools.today(timeZoneId: 'Asia/Dhaka', now: instant),
        DateTime(2026, 10, 12));
    expect(PrayerDateTools.today(timeZoneId: 'America/New_York', now: instant),
        DateTime(2026, 10, 11));
    final beforeFallBack = DateTime.utc(2026, 11, 1, 5, 30);
    final afterFallBack = DateTime.utc(2026, 11, 1, 6, 30);
    expect(
        PrayerDateTools.today(
            timeZoneId: 'America/New_York', now: beforeFallBack),
        DateTime(2026, 11, 1));
    expect(
        PrayerDateTools.today(
            timeZoneId: 'America/New_York', now: afterFallBack),
        DateTime(2026, 11, 1));
  });

  testWidgets('manual city shows calculated times and date changes refresh',
      (tester) async {
    SharedPreferences.setMockInitialValues({'language': 'en'});
    final appState = AppState();
    await appState.loadFromPrefs();
    final localizations = await tester.runAsync(
        () => const AppLocalizationsDelegate().load(const Locale('en')));
    final repository = _FakePrayerRepository();
    await tester.pumpWidget(_buildTestApp(
      state: appState,
      localizations: localizations,
      home: PrayerScreen(
        repository: repository,
        settingsStore: SharedPreferencesPrayerSettingsStore(),
      ),
    ));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enter city'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Dhaka');
    await tester.enterText(find.byType(TextField).at(1), 'Bangladesh');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(repository.dates, hasLength(1));
    expect(find.text('05:15'), findsNWidgets(5));
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(repository.dates, hasLength(2));
    expect(repository.dates.last,
        repository.dates.first.add(const Duration(days: 1)));
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('permanently denied location explains recovery and city fallback',
      (tester) async {
    SharedPreferences.setMockInitialValues({'language': 'en'});
    final appState = AppState();
    await appState.loadFromPrefs();
    final localizations = await tester.runAsync(
        () => const AppLocalizationsDelegate().load(const Locale('en')));
    await tester.pumpWidget(_buildTestApp(
      state: appState,
      localizations: localizations,
      home: PrayerScreen(
        repository: _FakePrayerRepository(),
        settingsStore: SharedPreferencesPrayerSettingsStore(),
        locationProvider: _DeniedLocationProvider(),
      ),
    ));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Use device location'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(
        find.text(
            'Location permission is blocked. Open app settings or enter a city.'),
        findsOneWidget);
    expect(find.text('Enter city'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
