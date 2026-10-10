import 'dart:convert';

import 'package:http/http.dart' as http;

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

abstract interface class QuranRepository {
  Future<List<QuranSurah>> getSurahs();
  Future<QuranSurahContent> getSurah(QuranSurah surah);
}

class AlQuranCloudRepository implements QuranRepository {
  AlQuranCloudRepository({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<List<QuranSurah>> getSurahs() async {
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
    return surahs;
  }

  @override
  Future<QuranSurahContent> getSurah(QuranSurah surah) async {
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
    final tajweedBody =
        jsonDecode(utf8.decode(responses[1].bodyBytes)) as Map<String, dynamic>;
    final tajweedRows = (tajweedBody['verses'] as List<dynamic>?) ?? const [];
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

    return QuranSurahContent(
      surah: surah,
      ayahs: [
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
      ],
    );
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
