// Fixture: Quran data file with hardcoded Bangla translation string (Leak)
class AyahModel {
  const AyahModel({
    required this.number,
    required this.arabic,
    required this.translation,
  });

  final int number;
  final String arabic;
  final String translation;
}

const quranSampleAyahs = [
  AyahModel(
    number: 1,
    arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    translation: 'শুরু করছি আল্লাহর নামে যিনি পরম করুণাময়, অতি দয়ালু।',
  ),
];
