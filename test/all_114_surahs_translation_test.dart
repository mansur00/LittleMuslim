import 'package:flutter_test/flutter_test.dart';
import 'package:little_muslim/screens/quran/quran_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AlQuranCloudRepository repo;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await AlQuranCloudRepository.preloadBundledData();
    repo = AlQuranCloudRepository();
  });

  group('All 114 Surahs Multi-Language Completeness Test', () {

    test('All 114 Surahs exist in curriculum index and have correct ayah counts', () async {
      final surahs = await repo.getSurahs();
      expect(surahs.length, 114, reason: 'Must contain exactly 114 surahs');

      var totalAyahs = 0;
      for (final surah in surahs) {
        expect(surah.number, greaterThanOrEqualTo(1));
        expect(surah.number, lessThanOrEqualTo(114));
        expect(surah.ayahCount, greaterThan(0));
        totalAyahs += surah.ayahCount;
      }
      expect(totalAyahs, 6236, reason: 'Quran must have exactly 6236 ayahs across 114 surahs');
    });

    for (final locale in ['en', 'bn', 'hi', 'it']) {
      test('Every one of the 114 surahs loads with non-empty translations in "$locale"', () async {
        final surahs = await repo.getSurahs();
        expect(surahs.length, 114);

        var totalAyahsVerified = 0;

        for (final surah in surahs) {
          final content = await repo.getSurah(surah, locale: locale);
          expect(
            content.ayahs.length,
            surah.ayahCount,
            reason: 'Surah ${surah.number} ($locale) ayah count must match expected ${surah.ayahCount}',
          );

          for (final ayah in content.ayahs) {
            expect(
              ayah.arabic.trim().isNotEmpty,
              isTrue,
              reason: 'Surah ${surah.number} Ayah ${ayah.number} Arabic text must not be empty',
            );
            expect(
              ayah.translation.trim().isNotEmpty,
              isTrue,
              reason: 'Surah ${surah.number} Ayah ${ayah.number} ($locale) translation must not be empty',
            );
            totalAyahsVerified++;
          }
        }

        expect(
          totalAyahsVerified,
          6236,
          reason: 'Must verify translations for all 6236 ayahs in locale "$locale"',
        );
      });
    }
  });
}
