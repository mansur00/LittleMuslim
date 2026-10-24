class QaidaLetter {
  const QaidaLetter({
    required this.id,
    required this.letter,
    required this.nameKey,
    required this.makhrajKey,
  });

  final String id;
  final String letter;
  final String nameKey;
  final String makhrajKey;

  String get name => nameKey;
  String get makhraj => makhrajKey;
  String get titleKey => 'qaida.letter.$id.title';
  String get title => titleKey;
  String? get audioAsset => qaidaLetterAudioAssets[id];

  String get transliterationKey => qaidaLetterNameKeys[letter] ?? nameKey;
  String get transliteration => transliterationKey;
  String get arabicName => qaidaLetterArabicNames[letter] ?? letter;
}

const Map<String, String> qaidaLetterNameKeys = {
  'ا': 'qaida.letter.alif.name',
  'ب': 'qaida.letter.baa.name',
  'ت': 'qaida.letter.taa.name',
  'ث': 'qaida.letter.thaa.name',
  'ج': 'qaida.letter.jeem.name',
  'ح': 'qaida.letter.haa.name',
  'خ': 'qaida.letter.khaa.name',
  'د': 'qaida.letter.daal.name',
  'ذ': 'qaida.letter.dhaal.name',
  'ر': 'qaida.letter.raa.name',
  'ز': 'qaida.letter.zay.name',
  'س': 'qaida.letter.seen.name',
  'ش': 'qaida.letter.sheen.name',
  'ص': 'qaida.letter.saad.name',
  'ض': 'qaida.letter.daad.name',
  'ط': 'qaida.letter.toa.name',
  'ظ': 'qaida.letter.zoa.name',
  'ع': 'qaida.letter.ayn.name',
  'غ': 'qaida.letter.ghayn.name',
  'ف': 'qaida.letter.faa.name',
  'ق': 'qaida.letter.qaaf.name',
  'ك': 'qaida.letter.kaaf.name',
  'ل': 'qaida.letter.laam.name',
  'م': 'qaida.letter.meem.name',
  'ن': 'qaida.letter.noon.name',
  'ه': 'qaida.letter.haa_small.name',
  'و': 'qaida.letter.waaw.name',
  'ي': 'qaida.letter.yaa.name',
};

const Map<String, String> qaidaLetterArabicNames = {
  'ا': 'أَلِف',
  'ب': 'بَاء',
  'ت': 'تَاء',
  'ث': 'ثَاء',
  'ج': 'جِيم',
  'ح': 'حَاء',
  'خ': 'خَاء',
  'د': 'دَال',
  'ذ': 'ذَال',
  'ر': 'رَاء',
  'ز': 'زَاي',
  'س': 'سِين',
  'ش': 'شِين',
  'ص': 'صَاد',
  'ض': 'ضَاد',
  'ط': 'طَاء',
  'ظ': 'ظَاء',
  'ع': 'عَيْن',
  'غ': 'غَيْن',
  'ف': 'فَاء',
  'ق': 'قَاف',
  'ك': 'كَاف',
  'ل': 'لَام',
  'م': 'مِيم',
  'ن': 'نُون',
  'ه': 'هَاء',
  'و': 'وَاو',
  'ي': 'يَاء',
};

const Map<String, String> qaidaLetterAudioAssets = {
  'qaida_alif': 'assets/audio/letters/alif.mp3',
  'qaida_ba': 'assets/audio/letters/ba.mp3',
  'qaida_ta': 'assets/audio/letters/ta.mp3',
  'qaida_tha': 'assets/audio/letters/tha.mp3',
  'qaida_jeem': 'assets/audio/letters/jeem.mp3',
  'qaida_ha': 'assets/audio/letters/haa.mp3',
  'qaida_kha': 'assets/audio/letters/khaa.mp3',
  'qaida_dal': 'assets/audio/letters/dal.mp3',
  'qaida_dhal': 'assets/audio/letters/dhal.mp3',
  'qaida_ra': 'assets/audio/letters/raa.mp3',
  'qaida_zay': 'assets/audio/letters/zay.mp3',
  'qaida_seen': 'assets/audio/letters/seen.mp3',
  'qaida_sheen': 'assets/audio/letters/sheen.mp3',
  'qaida_sad': 'assets/audio/letters/saad.mp3',
  'qaida_dad': 'assets/audio/letters/daad.mp3',
  'qaida_ta_emphatic': 'assets/audio/letters/toa.mp3',
  'qaida_za_emphatic': 'assets/audio/letters/zoa.mp3',
  'qaida_ayn': 'assets/audio/letters/ayn.mp3',
  'qaida_ghayn': 'assets/audio/letters/ghayn.mp3',
  'qaida_fa': 'assets/audio/letters/faa.mp3',
  'qaida_qaf': 'assets/audio/letters/qaaf.mp3',
  'qaida_kaf': 'assets/audio/letters/kaaf.mp3',
  'qaida_lam': 'assets/audio/letters/laam.mp3',
  'qaida_meem': 'assets/audio/letters/meem.mp3',
  'qaida_noon': 'assets/audio/letters/noon.mp3',
  'qaida_ha_soft': 'assets/audio/letters/ha.mp3',
  'qaida_waw': 'assets/audio/letters/waw.mp3',
  'qaida_ya': 'assets/audio/letters/yaa.mp3',
};

const Map<String, String> arabicCharToAudioAsset = {
  'ا': 'assets/audio/letters/alif.mp3',
  'ب': 'assets/audio/letters/ba.mp3',
  'ت': 'assets/audio/letters/ta.mp3',
  'ث': 'assets/audio/letters/tha.mp3',
  'ج': 'assets/audio/letters/jeem.mp3',
  'ح': 'assets/audio/letters/haa.mp3',
  'خ': 'assets/audio/letters/khaa.mp3',
  'د': 'assets/audio/letters/dal.mp3',
  'ذ': 'assets/audio/letters/dhal.mp3',
  'ر': 'assets/audio/letters/raa.mp3',
  'ز': 'assets/audio/letters/zay.mp3',
  'س': 'assets/audio/letters/seen.mp3',
  'ش': 'assets/audio/letters/sheen.mp3',
  'ص': 'assets/audio/letters/saad.mp3',
  'ض': 'assets/audio/letters/daad.mp3',
  'ط': 'assets/audio/letters/toa.mp3',
  'ظ': 'assets/audio/letters/zoa.mp3',
  'ع': 'assets/audio/letters/ayn.mp3',
  'غ': 'assets/audio/letters/ghayn.mp3',
  'ف': 'assets/audio/letters/faa.mp3',
  'ق': 'assets/audio/letters/qaaf.mp3',
  'ك': 'assets/audio/letters/kaaf.mp3',
  'ل': 'assets/audio/letters/laam.mp3',
  'م': 'assets/audio/letters/meem.mp3',
  'ن': 'assets/audio/letters/noon.mp3',
  'ه': 'assets/audio/letters/ha.mp3',
  'و': 'assets/audio/letters/waw.mp3',
  'ي': 'assets/audio/letters/yaa.mp3',
};

/// The 28 Arabic letters taught in the Qaida path, in learning order.
const qaidaLetters = <QaidaLetter>[
  QaidaLetter(
    id: 'qaida_alif',
    letter: 'ا',
    nameKey: 'qaida.letter.alif.name',
    makhrajKey: 'qaida.letter.alif.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_ba',
    letter: 'ب',
    nameKey: 'qaida.letter.ba.name',
    makhrajKey: 'qaida.letter.ba.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_ta',
    letter: 'ت',
    nameKey: 'qaida.letter.ta.name',
    makhrajKey: 'qaida.letter.ta.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_tha',
    letter: 'ث',
    nameKey: 'qaida.letter.tha.name',
    makhrajKey: 'qaida.letter.tha.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_jeem',
    letter: 'ج',
    nameKey: 'qaida.letter.jeem.name',
    makhrajKey: 'qaida.letter.jeem.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_ha',
    letter: 'ح',
    nameKey: 'qaida.letter.ha.name',
    makhrajKey: 'qaida.letter.ha.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_kha',
    letter: 'خ',
    nameKey: 'qaida.letter.kha.name',
    makhrajKey: 'qaida.letter.kha.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_dal',
    letter: 'د',
    nameKey: 'qaida.letter.dal.name',
    makhrajKey: 'qaida.letter.dal.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_dhal',
    letter: 'ذ',
    nameKey: 'qaida.letter.dhal.name',
    makhrajKey: 'qaida.letter.dhal.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_ra',
    letter: 'ر',
    nameKey: 'qaida.letter.ra.name',
    makhrajKey: 'qaida.letter.ra.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_zay',
    letter: 'ز',
    nameKey: 'qaida.letter.zay.name',
    makhrajKey: 'qaida.letter.zay.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_seen',
    letter: 'س',
    nameKey: 'qaida.letter.seen.name',
    makhrajKey: 'qaida.letter.seen.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_sheen',
    letter: 'ش',
    nameKey: 'qaida.letter.sheen.name',
    makhrajKey: 'qaida.letter.sheen.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_sad',
    letter: 'ص',
    nameKey: 'qaida.letter.sad.name',
    makhrajKey: 'qaida.letter.sad.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_dad',
    letter: 'ض',
    nameKey: 'qaida.letter.dad.name',
    makhrajKey: 'qaida.letter.dad.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_ta_emphatic',
    letter: 'ط',
    nameKey: 'qaida.letter.toa.name',
    makhrajKey: 'qaida.letter.toa.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_za_emphatic',
    letter: 'ظ',
    nameKey: 'qaida.letter.zoa.name',
    makhrajKey: 'qaida.letter.zoa.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_ayn',
    letter: 'ع',
    nameKey: 'qaida.letter.ayn.name',
    makhrajKey: 'qaida.letter.ayn.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_ghayn',
    letter: 'غ',
    nameKey: 'qaida.letter.ghayn.name',
    makhrajKey: 'qaida.letter.ghayn.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_fa',
    letter: 'ف',
    nameKey: 'qaida.letter.fa.name',
    makhrajKey: 'qaida.letter.fa.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_qaf',
    letter: 'ق',
    nameKey: 'qaida.letter.qaf.name',
    makhrajKey: 'qaida.letter.qaf.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_kaf',
    letter: 'ك',
    nameKey: 'qaida.letter.kaf.name',
    makhrajKey: 'qaida.letter.kaf.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_lam',
    letter: 'ل',
    nameKey: 'qaida.letter.lam.name',
    makhrajKey: 'qaida.letter.lam.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_meem',
    letter: 'م',
    nameKey: 'qaida.letter.meem.name',
    makhrajKey: 'qaida.letter.meem.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_noon',
    letter: 'ن',
    nameKey: 'qaida.letter.noon.name',
    makhrajKey: 'qaida.letter.noon.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_ha_soft',
    letter: 'ه',
    nameKey: 'qaida.letter.ha_soft.name',
    makhrajKey: 'qaida.letter.ha_soft.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_waw',
    letter: 'و',
    nameKey: 'qaida.letter.waw.name',
    makhrajKey: 'qaida.letter.waw.makhraj',
  ),
  QaidaLetter(
    id: 'qaida_ya',
    letter: 'ي',
    nameKey: 'qaida.letter.ya.name',
    makhrajKey: 'qaida.letter.ya.makhraj',
  ),
];

List<String> qaidaLetterOptions(int index) {
  final previous =
      qaidaLetters[(index - 1 + qaidaLetters.length) % qaidaLetters.length]
          .letter;
  final current = qaidaLetters[index].letter;
  final next = qaidaLetters[(index + 1) % qaidaLetters.length].letter;
  return [previous, current, next];
}
