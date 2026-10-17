import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuranSurah {
  const QuranSurah({
    required this.number,
    required this.arabicName,
    required this.englishName,
    required this.nameMeaning,
    required this.ayahCount,
    required this.revelationType,
  });

  final int number;
  final String arabicName;
  final String englishName;
  final String nameMeaning;
  final int ayahCount;
  final String revelationType;

  factory QuranSurah.fromJson(Map<String, dynamic> json) => QuranSurah(
        number: json['number'] as int,
        arabicName: json['name'] as String,
        englishName: json['englishName'] as String,
        nameMeaning: json['englishNameTranslation'] as String? ?? '',
        ayahCount: json['numberOfAyahs'] as int,
        revelationType: json['revelationType'] as String? ?? '',
      );
}

class QuranAyah {
  const QuranAyah({
    required this.number,
    required this.arabic,
    required this.tajweedText,
    required this.translation,
  });

  final int number;
  final String arabic;
  final String tajweedText;
  final String translation;
}

class QuranSurahContent {
  const QuranSurahContent({required this.surah, required this.ayahs});
  final QuranSurah surah;
  final List<QuranAyah> ayahs;
}

class QuranJuz {
  const QuranJuz({
    required this.number,
    required this.arabicName,
    required this.startSurahNumber,
    required this.startSurahName,
    required this.startAyahNumber,
  });

  final int number;
  final String arabicName;
  final int startSurahNumber;
  final String startSurahName;
  final int startAyahNumber;
}

const List<QuranJuz> quranJuzList = [
  QuranJuz(number: 1, arabicName: 'الم', startSurahNumber: 1, startSurahName: 'Al-Fatiha', startAyahNumber: 1),
  QuranJuz(number: 2, arabicName: 'سَيَقُولُ', startSurahNumber: 2, startSurahName: 'Al-Baqarah', startAyahNumber: 142),
  QuranJuz(number: 3, arabicName: 'تِلْكَ الرُّسُلُ', startSurahNumber: 2, startSurahName: 'Al-Baqarah', startAyahNumber: 253),
  QuranJuz(number: 4, arabicName: 'كُلُّ الطَّعَامِ', startSurahNumber: 3, startSurahName: 'Ali \'Imran', startAyahNumber: 93),
  QuranJuz(number: 5, arabicName: 'وَالْمُحْصَنَاتُ', startSurahNumber: 4, startSurahName: 'An-Nisa', startAyahNumber: 24),
  QuranJuz(number: 6, arabicName: 'لَا يُحِبُّ اللَّهُ', startSurahNumber: 4, startSurahName: 'An-Nisa', startAyahNumber: 148),
  QuranJuz(number: 7, arabicName: 'وَإِذَا سَمِعُوا', startSurahNumber: 5, startSurahName: 'Al-Ma\'idah', startAyahNumber: 82),
  QuranJuz(number: 8, arabicName: 'وَلَوْ أَنَّنَا', startSurahNumber: 6, startSurahName: 'Al-An\'am', startAyahNumber: 111),
  QuranJuz(number: 9, arabicName: 'قَالَ الْمَلَأُ', startSurahNumber: 7, startSurahName: 'Al-A\'raf', startAyahNumber: 88),
  QuranJuz(number: 10, arabicName: 'وَاعْلَمُوا', startSurahNumber: 8, startSurahName: 'Al-Anfal', startAyahNumber: 41),
  QuranJuz(number: 11, arabicName: 'يَعْتَذِرُونَ', startSurahNumber: 9, startSurahName: 'At-Tawbah', startAyahNumber: 93),
  QuranJuz(number: 12, arabicName: 'وَمَا مِنْ دَابَّةٍ', startSurahNumber: 11, startSurahName: 'Hud', startAyahNumber: 6),
  QuranJuz(number: 13, arabicName: 'وَمَا أُبَرِّئُ', startSurahNumber: 12, startSurahName: 'Yusuf', startAyahNumber: 53),
  QuranJuz(number: 14, arabicName: 'رُبَمَا', startSurahNumber: 15, startSurahName: 'Al-Hijr', startAyahNumber: 1),
  QuranJuz(number: 15, arabicName: 'سُبْحَانَ الَّذِي', startSurahNumber: 17, startSurahName: 'Al-Isra', startAyahNumber: 1),
  QuranJuz(number: 16, arabicName: 'قَالَ أَلَمْ', startSurahNumber: 18, startSurahName: 'Al-Kahf', startAyahNumber: 75),
  QuranJuz(number: 17, arabicName: 'اقْتَرَبَ لِلنَّاسِ', startSurahNumber: 21, startSurahName: 'Al-Anbiya', startAyahNumber: 1),
  QuranJuz(number: 18, arabicName: 'قَدْ أَفْلَحَ', startSurahNumber: 23, startSurahName: 'Al-Mu\'minun', startAyahNumber: 1),
  QuranJuz(number: 19, arabicName: 'وَقَالَ الَّذِينَ', startSurahNumber: 25, startSurahName: 'Al-Furqan', startAyahNumber: 21),
  QuranJuz(number: 20, arabicName: 'فَمَا كَانَ', startSurahNumber: 27, startSurahName: 'An-Naml', startAyahNumber: 56),
  QuranJuz(number: 21, arabicName: 'وَلَا تُجَادِلُوا', startSurahNumber: 29, startSurahName: 'Al-\'Ankabut', startAyahNumber: 46),
  QuranJuz(number: 22, arabicName: 'وَمَنْ يَقْنُتْ', startSurahNumber: 33, startSurahName: 'Al-Ahzab', startAyahNumber: 31),
  QuranJuz(number: 23, arabicName: 'وَمَا أَنْزَلْنَا', startSurahNumber: 36, startSurahName: 'Ya-Sin', startAyahNumber: 28),
  QuranJuz(number: 24, arabicName: 'فَمَنْ أَظْلَمُ', startSurahNumber: 39, startSurahName: 'Az-Zumar', startAyahNumber: 32),
  QuranJuz(number: 25, arabicName: 'إِلَيْهِ يُرَدُّ', startSurahNumber: 41, startSurahName: 'Fussilat', startAyahNumber: 47),
  QuranJuz(number: 26, arabicName: 'حم', startSurahNumber: 46, startSurahName: 'Al-Ahqaf', startAyahNumber: 1),
  QuranJuz(number: 27, arabicName: 'قَالَ فَمَا خَطْبُكُمْ', startSurahNumber: 51, startSurahName: 'Adh-Dhariyat', startAyahNumber: 31),
  QuranJuz(number: 28, arabicName: 'قَدْ سَمِعَ اللَّهُ', startSurahNumber: 58, startSurahName: 'Al-Mujadila', startAyahNumber: 1),
  QuranJuz(number: 29, arabicName: 'تَبَارَكَ الَّذِي', startSurahNumber: 67, startSurahName: 'Al-Mulk', startAyahNumber: 1),
  QuranJuz(number: 30, arabicName: 'عَمَّ', startSurahNumber: 78, startSurahName: 'An-Naba', startAyahNumber: 1),
];

abstract interface class QuranRepository {
  Future<List<QuranSurah>> getSurahs();
  Future<QuranSurahContent> getSurah(QuranSurah surah);
}

class AlQuranCloudRepository implements QuranRepository {
  AlQuranCloudRepository({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<QuranSurah>?> _loadCachedSurahs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('quran_surahs_cache');
      if (raw == null) return null;
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => QuranSurah.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCachedSurahs(List<dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('quran_surahs_cache', jsonEncode(data));
    } catch (_) {}
  }

  Future<QuranSurahContent?> _loadCachedSurahContent(QuranSurah surah) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('quran_surah_${surah.number}_cache');
      if (raw == null) return null;
      final list = jsonDecode(raw) as List<dynamic>;
      final ayahs = list.map((item) {
        final m = item as Map<String, dynamic>;
        return QuranAyah(
          number: m['number'] as int,
          arabic: m['arabic'] as String,
          tajweedText: m['tajweedText'] as String,
          translation: m['translation'] as String,
        );
      }).toList(growable: false);
      if (ayahs.isEmpty) return null;
      return QuranSurahContent(surah: surah, ayahs: ayahs);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCachedSurahContent(
      int surahNumber, List<QuranAyah> ayahs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = ayahs
          .map((a) => {
                'number': a.number,
                'arabic': a.arabic,
                'tajweedText': a.tajweedText,
                'translation': a.translation,
              })
          .toList(growable: false);
      await prefs.setString(
          'quran_surah_${surahNumber}_cache', jsonEncode(list));
    } catch (_) {}
  }

  @override
  Future<List<QuranSurah>> getSurahs() async {
    try {
      final response = await _client
          .get(Uri.parse('https://api.alquran.cloud/v1/surah'))
          .timeout(const Duration(seconds: 15));
      final body = _decodeResponse(response);
      final data = body['data'] as List<dynamic>;
      final surahs = data
          .map((entry) => QuranSurah.fromJson(entry as Map<String, dynamic>))
          .toList(growable: false);
      if (surahs.length != 114) {
        throw const FormatException('The surah list was incomplete.');
      }
      await _saveCachedSurahs(data);
      return surahs;
    } catch (e) {
      final cached = await _loadCachedSurahs();
      if (cached != null && cached.length == 114) return cached;
      rethrow;
    }
  }

  @override
  Future<QuranSurahContent> getSurah(QuranSurah surah) async {
    try {
      final responses = await Future.wait([
        _client
            .get(Uri.parse(
              'https://api.alquran.cloud/v1/surah/${surah.number}/editions/'
              'quran-uthmani,bn.bengali',
            ))
            .timeout(const Duration(seconds: 20)),
        _client
            .get(Uri.parse(
              'https://api.quran.com/api/v4/quran/verses/uthmani_tajweed'
              '?chapter_number=${surah.number}',
            ))
            .timeout(const Duration(seconds: 20)),
      ]);
      final body = _decodeResponse(responses[0]);
      if (responses[1].statusCode != 200) {
        throw http.ClientException(
            'Tajweed service returned ${responses[1].statusCode}.');
      }
      final tajweedBody = jsonDecode(utf8.decode(responses[1].bodyBytes))
          as Map<String, dynamic>;
      final tajweedRows =
          (tajweedBody['verses'] as List<dynamic>?) ?? const [];
      final tajweedByVerse = {
        for (final row in tajweedRows.cast<Map<String, dynamic>>())
          row['verse_key'] as String: row['text_uthmani_tajweed'] as String,
      };
      if (tajweedByVerse.length != surah.ayahCount) {
        throw const FormatException('The tajweed text was incomplete.');
      }
      final editions =
          (body['data'] as List<dynamic>).cast<Map<String, dynamic>>();
      Map<String, dynamic>? edition(String id) {
        for (final item in editions) {
          if ((item['edition'] as Map<String, dynamic>?)?['identifier'] == id) {
            return item;
          }
        }
        return null;
      }

      final arabic = edition('quran-uthmani');
      final bengali = edition('bn.bengali');
      if (arabic == null || bengali == null) {
        throw const FormatException('The surah text was incomplete.');
      }
      final arabicAyahs = arabic['ayahs'] as List<dynamic>;
      final bengaliAyahs = bengali['ayahs'] as List<dynamic>;
      if (arabicAyahs.length != bengaliAyahs.length) {
        throw const FormatException(
            'Arabic and translation ayahs did not match.');
      }

      final ayahs = [
        for (var i = 0; i < arabicAyahs.length; i++)
          () {
            final arabicAyah = arabicAyahs[i] as Map<String, dynamic>;
            final number = arabicAyah['numberInSurah'] as int;
            return QuranAyah(
              number: number,
              arabic: arabicAyah['text'] as String,
              tajweedText: tajweedByVerse['${surah.number}:$number'] ??
                  arabicAyah['text'] as String,
              translation:
                  (bengaliAyahs[i] as Map<String, dynamic>)['text'] as String,
            );
          }(),
      ];

      final content = QuranSurahContent(surah: surah, ayahs: ayahs);
      await _saveCachedSurahContent(surah.number, ayahs);
      return content;
    } catch (e) {
      final cached = await _loadCachedSurahContent(surah);
      if (cached != null) return cached;
      rethrow;
    }
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw http.ClientException(
          'Quran service returned ${response.statusCode}.');
    }
    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    if (json['code'] != 200 || json['data'] == null) {
      throw const FormatException('Quran data could not be loaded.');
    }
    return json;
  }
}
