class QaidaLetter {
  const QaidaLetter({
    required this.id,
    required this.letter,
    required this.name,
    required this.makhraj,
  });

  final String id;
  final String letter;
  final String name;
  final String makhraj;

  String get title => '$name চিনি';
  String? get audioAsset => qaidaLetterAudioAssets[id];

  String get transliteration => qaidaLetterTransliteration[letter] ?? id.replaceAll('qaida_', '');
  String get arabicName => qaidaLetterArabicNames[letter] ?? letter;
}

const Map<String, String> qaidaLetterTransliteration = {
  'ا': 'Alif',
  'ب': 'Baa',
  'ت': 'Taa',
  'ث': 'Thaa',
  'ج': 'Jeem',
  'ح': 'Haa',
  'خ': 'Khaa',
  'د': 'Daal',
  'ذ': 'Dhaal',
  'ر': 'Raa',
  'ز': 'Zaay',
  'س': 'Seen',
  'ش': 'Sheen',
  'ص': 'Saad',
  'ض': 'Daad',
  'ط': 'Toa',
  'ظ': 'Zoa',
  'ع': 'Ayn',
  'غ': 'Ghayn',
  'ف': 'Faa',
  'ق': 'Qaaf',
  'ك': 'Kaaf',
  'ل': 'Laam',
  'م': 'Meem',
  'ن': 'Noon',
  'ه': 'Haa',
  'و': 'Waaw',
  'ي': 'Yaa',
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
      name: 'আলিফ',
      makhraj:
          'মাদ্দের আলিফ মুখ-গলার ফাঁকা পথ দিয়ে টানা হয়। শুরু-হামযার ধ্বনি গলার একেবারে নিচের দিক থেকে আসে।'),
  QaidaLetter(
      id: 'qaida_ba',
      letter: 'ب',
      name: 'বা',
      makhraj: 'দুই ঠোঁট মিলিয়ে “বা” বলো; নাক দিয়ে টেনে নয়।'),
  QaidaLetter(
      id: 'qaida_ta',
      letter: 'ت',
      name: 'তা',
      makhraj: 'জিহ্বার আগা ওপরের সামনের দাঁতের গোড়ায় ছোঁয়াও।'),
  QaidaLetter(
      id: 'qaida_tha',
      letter: 'ث',
      name: 'ছা',
      makhraj: 'জিহ্বার আগা সামনের দাঁতের কিনারায় হালকা রেখে বাতাস ছাড়ো।'),
  QaidaLetter(
      id: 'qaida_jeem',
      letter: 'ج',
      name: 'জীম',
      makhraj: 'জিহ্বার মাঝখান ও তালুর কাছ থেকে ধ্বনিটি বের হয়।'),
  QaidaLetter(
      id: 'qaida_ha',
      letter: 'ح',
      name: 'হা',
      makhraj: 'গলার মাঝখান থেকে নরম, নিঃশ্বাসি “হা” বলো।'),
  QaidaLetter(
      id: 'qaida_kha',
      letter: 'خ',
      name: 'খা',
      makhraj: 'গলার মুখের কাছের অংশ থেকে “খা” ধ্বনি বের করো।'),
  QaidaLetter(
      id: 'qaida_dal',
      letter: 'د',
      name: 'দাল',
      makhraj: 'জিহ্বার আগা ওপরের সামনের দাঁতের গোড়ায় ঠেকাও।'),
  QaidaLetter(
      id: 'qaida_dhal',
      letter: 'ذ',
      name: 'যাল',
      makhraj: 'জিহ্বার আগা সামনের দাঁতের কিনারায় রেখে ধ্বনি বলো।'),
  QaidaLetter(
      id: 'qaida_ra',
      letter: 'ر',
      name: 'রা',
      makhraj: 'জিহ্বার আগা ওপরের দাঁতের গোড়ার কাছে রাখো; জোরে কাঁপিয়ো না।'),
  QaidaLetter(
      id: 'qaida_zay',
      letter: 'ز',
      name: 'যাই',
      makhraj: 'জিহ্বার আগা নিচের সামনের দাঁতের কাছে রেখে গুঞ্জনধ্বনি করো।'),
  QaidaLetter(
      id: 'qaida_seen',
      letter: 'س',
      name: 'সীন',
      makhraj: 'জিহ্বার আগা নিচের দাঁতের কাছে; সরু ফাঁক দিয়ে বাতাস বের হয়।'),
  QaidaLetter(
      id: 'qaida_sheen',
      letter: 'ش',
      name: 'শীন',
      makhraj: 'জিহ্বার মাঝখান তালুর কাছে তুলে “শ” ধ্বনি বলো।'),
  QaidaLetter(
      id: 'qaida_sad',
      letter: 'ص',
      name: 'সোয়াদ',
      makhraj: 'সীনের জায়গা থেকেই বলো, তবে জিহ্বা একটু উঁচু ও ভারী রাখো।'),
  QaidaLetter(
      id: 'qaida_dad',
      letter: 'ض',
      name: 'দোয়াদ',
      makhraj: 'জিহ্বার এক পাশ ওপরের পেছনের দাঁতের সঙ্গে লাগাও।'),
  QaidaLetter(
      id: 'qaida_ta_emphatic',
      letter: 'ط',
      name: 'তোয়া',
      makhraj: 'জিহ্বার আগা ওপরের দাঁতের গোড়ায়; ধ্বনিটি ভারী করে বলো।'),
  QaidaLetter(
      id: 'qaida_za_emphatic',
      letter: 'ظ',
      name: 'জোয়া',
      makhraj: 'জিহ্বার আগা সামনের দাঁতের কিনারায় রেখে ভারী ধ্বনি বলো।'),
  QaidaLetter(
      id: 'qaida_ayn',
      letter: 'ع',
      name: 'আইন',
      makhraj: 'গলার মাঝখান থেকে “আইন” বলো; গলা চেপে ধরো না।'),
  QaidaLetter(
      id: 'qaida_ghayn',
      letter: 'غ',
      name: 'গাইন',
      makhraj: 'গলার মুখের কাছের অংশ থেকে নরম গুঞ্জনধ্বনি আসে।'),
  QaidaLetter(
      id: 'qaida_fa',
      letter: 'ف',
      name: 'ফা',
      makhraj: 'নিচের ঠোঁট ওপরের সামনের দাঁতে আলতো ছোঁয়াও।'),
  QaidaLetter(
      id: 'qaida_qaf',
      letter: 'ق',
      name: 'ক্বাফ',
      makhraj: 'জিহ্বার একেবারে পেছন নরম তালুর কাছে তোলো।'),
  QaidaLetter(
      id: 'qaida_kaf',
      letter: 'ك',
      name: 'কাফ',
      makhraj: 'জিহ্বার পেছন থেকে, ক্বাফের তুলনায় একটু সামনে ধ্বনি বলো।'),
  QaidaLetter(
      id: 'qaida_lam',
      letter: 'ل',
      name: 'লাম',
      makhraj: 'জিহ্বার আগা ও সামনের অংশ ওপরের মাড়ির কাছে রাখো।'),
  QaidaLetter(
      id: 'qaida_meem',
      letter: 'م',
      name: 'মীম',
      makhraj: 'দুই ঠোঁট মিলিয়ে বলো; মীমে নাকের অনুরণনও থাকে।'),
  QaidaLetter(
      id: 'qaida_noon',
      letter: 'ن',
      name: 'নূন',
      makhraj: 'জিহ্বার আগা ওপরের মাড়িতে; নূনে নাকের অনুরণন থাকে।'),
  QaidaLetter(
      id: 'qaida_ha_soft',
      letter: 'ه',
      name: 'হা',
      makhraj: 'গলার একেবারে নিচের দিক থেকে হালকা নিঃশ্বাসে বলো।'),
  QaidaLetter(
      id: 'qaida_waw',
      letter: 'و',
      name: 'ওয়াও',
      makhraj:
          'ব্যঞ্জনধ্বনিতে দুই ঠোঁট গোল করো; মাদ্দ হলে মুখের ফাঁকা পথ দিয়ে টানো।'),
  QaidaLetter(
      id: 'qaida_ya',
      letter: 'ي',
      name: 'ইয়া',
      makhraj:
          'জিহ্বার মাঝখান তালুর কাছে তোলো; মাদ্দ হলে মুখের ফাঁকা পথ দিয়ে টানো।'),
];

List<String> qaidaLetterOptions(int index) {
  final previous =
      qaidaLetters[(index - 1 + qaidaLetters.length) % qaidaLetters.length]
          .letter;
  final current = qaidaLetters[index].letter;
  final next = qaidaLetters[(index + 1) % qaidaLetters.length].letter;
  return [previous, current, next];
}
