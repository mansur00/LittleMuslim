import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:little_muslim/screens/live_learning/class_schedule.dart';
import 'package:little_muslim/screens/prayer/prayer_times.dart';
import 'package:little_muslim/screens/quran/quran_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Prayer Times Offline Cache', () {
    test('falls back to cached result when network fails after a successful fetch',
        () async {
      var callCount = 0;
      final mockClient = MockClient((request) async {
        callCount++;
        if (callCount == 1) {
          // First call succeeds and saves to cache
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
            200,
          );
        } else {
          // Second call simulates offline failure
          throw http.ClientException('Network is down');
        }
      });

      final repo = AlAdhanPrayerTimesRepository(client: mockClient);
      const location = PrayerLocationSelection.city(
        city: 'Dhaka',
        country: 'Bangladesh',
      );
      final date = DateTime(2026, 10, 12);

      // 1st request: fetches online and caches
      final onlineResult = await repo.calculate(
        location: location,
        date: date,
        methodId: 1,
        asrSchool: 0,
      );
      expect(onlineResult.isCached, isFalse);
      expect(onlineResult.times['Fajr']?.hour, 4);

      // 2nd request: network throws, should load from cache
      final cachedResult = await repo.calculate(
        location: location,
        date: date,
        methodId: 1,
        asrSchool: 0,
      );
      expect(cachedResult.isCached, isTrue);
      expect(cachedResult.times['Fajr']?.hour, 4);
      expect(cachedResult.timeZoneId, 'Asia/Dhaka');
    });
  });

  group('Quran Offline Cache', () {
    test('falls back to cached surah content when network is offline', () async {
      var callCount = 0;
      final mockClient = MockClient((request) async {
        callCount++;
        if (callCount <= 2) {
          if (request.url.toString().contains('api.alquran.cloud')) {
            return http.Response.bytes(
              utf8.encode(jsonEncode({
                'code': 200,
                'data': [
                  {
                    'edition': {'identifier': 'quran-uthmani'},
                    'ayahs': [
                      {
                        'numberInSurah': 1,
                        'text': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                      }
                    ]
                  },
                  {
                    'edition': {'identifier': 'bn.bengali'},
                    'ayahs': [
                      {
                        'numberInSurah': 1,
                        'text': 'আল্লাহর নামে শুরু করছি যিনি পরম দয়ালু।',
                      }
                    ]
                  }
                ]
              })),
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          } else {
            return http.Response.bytes(
              utf8.encode(jsonEncode({
                'verses': [
                  {
                    'verse_key': '1:1',
                    'text_uthmani_tajweed':
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  }
                ]
              })),
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          }
        } else {
          throw http.ClientException('Offline mode');
        }
      });

      final repo = AlQuranCloudRepository(client: mockClient);
      const surah = QuranSurah(
        number: 1,
        arabicName: 'الفاتحة',
        englishName: 'Al-Fatiha',
        nameMeaning: 'The Opening',
        ayahCount: 1,
        revelationType: 'Meccan',
      );

      // 1st call online
      final onlineContent = await repo.getSurah(surah);
      expect(onlineContent.ayahs.length, 1);
      expect(onlineContent.ayahs.first.number, 1);

      // 2nd call offline
      final cachedContent = await repo.getSurah(surah);
      expect(cachedContent.ayahs.length, 1);
      expect(cachedContent.ayahs.first.arabic,
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ');
      expect(cachedContent.ayahs.first.translation,
          'আল্লাহর নামে শুরু করছি যিনি পরম দয়ালু।');
    });
  });

  group('Live Class Scheduling & Timezone Safety', () {
    test('LiveClass.fromJson parses accurately', () {
      final json = {
        'id': 'class-1',
        'title': 'Tajweed Basics',
        'teacher': 'Ustadh Hasan',
        'startAt': '2026-10-15T10:00:00.000Z',
        'endAt': '2026-10-15T11:00:00.000Z',
        'meetingUrl': 'https://meet.google.com/abc-defg-hij',
        'recordState': 'scheduled',
      };
      final liveClass = LiveClass.fromJson(json);
      expect(liveClass.id, 'class-1');
      expect(liveClass.title, 'Tajweed Basics');
      expect(liveClass.teacher, 'Ustadh Hasan');
      expect(liveClass.safeMeetingUri?.host, 'meet.google.com');
    });

    test('LiveClass.statusAt calculates status safely across UTC boundaries', () {
      final start = DateTime.utc(2026, 10, 15, 14, 0);
      final end = DateTime.utc(2026, 10, 15, 15, 0);

      final liveClass = LiveClass(
        id: 'tz-test',
        title: 'Timezone Class',
        startAt: start,
        endAt: end,
      );

      // Before start in UTC
      expect(
        liveClass.statusAt(DateTime.utc(2026, 10, 15, 13, 59)),
        LiveClassStatus.upcoming,
      );

      // During class in local time equivalent (+6h: 20:30 local = 14:30 UTC)
      final localDuring = DateTime.parse('2026-10-15 20:30:00+0600');
      expect(
        liveClass.statusAt(localDuring),
        LiveClassStatus.live,
      );

      // After class
      expect(
        liveClass.statusAt(DateTime.utc(2026, 10, 15, 15, 1)),
        LiveClassStatus.completed,
      );
    });

    test('HttpClassScheduleRepository loads and parses list from endpoint',
        () async {
      final mockClient = MockClient((request) async {
        expect(request.headers['Authorization'], 'Bearer secret-key');
        return http.Response(
          jsonEncode([
            {
              'id': 'api-class-1',
              'title': 'Weekly Quran Halaqah',
              'teacher': 'Sister Fatima',
              'startAt': '2026-10-20T16:00:00.000Z',
              'endAt': '2026-10-20T17:00:00.000Z',
              'meetingUrl': 'https://zoom.us/j/123456789',
            }
          ]),
          200,
        );
      });

      final repo = HttpClassScheduleRepository(
        endpointUri: Uri.parse('https://example.com/api/classes'),
        apiKey: 'secret-key',
        client: mockClient,
      );

      final classes = await repo.loadClasses();
      expect(classes.length, 1);
      expect(classes.first.id, 'api-class-1');
      expect(classes.first.teacher, 'Sister Fatima');
    });
  });
}
