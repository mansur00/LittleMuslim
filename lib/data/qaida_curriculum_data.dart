import 'package:flutter/material.dart';
import '../models/qaida/qaida_models.dart';
import '../screens/qaida/qaida_letters.dart';

/// Master curriculum data for the 8 tracks of the Qaida system.
class QaidaCurriculumData {
  static final List<QaidaTrackInfo> tracks = [
    _track1Letters,
    _track2Forms,
    _track3Harakat,
    _track4Madd,
    _track5Ghunnah,
    _track6Joined,
    _track7Words,
    _track8Sentences,
  ];

  static QaidaTrackInfo getTrackById(String trackId) {
    return tracks.firstWhere(
      (t) => t.id == trackId,
      orElse: () => tracks.first,
    );
  }

  static QaidaLessonInfo? getLessonById(String lessonId) {
    for (final track in tracks) {
      for (final lesson in track.lessons) {
        if (lesson.id == lessonId) return lesson;
      }
    }
    return null;
  }

  // -------------------------------------------------------------
  // TRACK 1: 28 Hijaiyah Letters (হরফ পরিচয়)
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track1Letters = QaidaTrackInfo(
    id: 'track_1_letters',
    trackNumber: 1,
    title: 'হরফ পরিচয়',
    subtitle: '২৮টি আরবি হরফ চেনা ও সঠিক মাখরাজ',
    arabicTitle: 'حُرُوفُ الْهِجَاءِ',
    description: 'আরবি বর্ণমালার মোট ২৮টি হরফ সহীহ শুদ্ধ মাখরাজ ও উচ্চারণে শেখা।',
    colorHex: 0xFF58CC02, // Duo Green
    icon: Icons.abc_rounded,
    lessons: List.generate(qaidaLetters.length, (index) {
      final letter = qaidaLetters[index];
      final audio = qaidaLetterAudioAssets[letter.id];
      final prevLetter = index > 0 ? qaidaLetters[index - 1] : null;
      final nextLetter = index < qaidaLetters.length - 1 ? qaidaLetters[index + 1] : null;

      // Distractor options
      final distractors = <String>[];
      if (prevLetter != null) distractors.add(prevLetter.letter);
      if (nextLetter != null) distractors.add(nextLetter.letter);
      while (distractors.length < 3) {
        final candidate = qaidaLetters[(index + distractors.length + 3) % qaidaLetters.length].letter;
        if (candidate != letter.letter && !distractors.contains(candidate)) {
          distractors.add(candidate);
        }
      }

      final options1 = [letter.letter, distractors[0], distractors[1]]..shuffle();
      final options2 = [letter.name, prevLetter?.name ?? 'তা', nextLetter?.name ?? 'জীম']..shuffle();

      return QaidaLessonInfo(
        id: letter.id,
        trackId: 'track_1_letters',
        lessonNumber: index + 1,
        title: '${letter.name} চিনি',
        subtitle: 'হরফ: ${letter.letter}',
        arabicDisplay: letter.letter,
        description: 'সহীহ মাখরাজ থেকে ${letter.name} উচ্চারণ শিখি।',
        audioAsset: audio,
        makhraj: letter.makhraj,
        activities: [
          // 1. Intro
          QaidaActivity(
            id: '${letter.id}_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'মনোযোগ দিয়ে হরফটি লক্ষ্য করি এবং তিলাওয়াত শুনি',
            arabicTarget: letter.letter,
            audioAsset: audio,
            makhrajInfo: letter.makhraj,
            explanation: 'মাখরাজ: ${letter.makhraj}',
          ),
          // 2. Identify letter
          QaidaActivity(
            id: '${letter.id}_identify',
            type: QaidaActivityType.identifyLetter,
            prompt: 'নিচের কোনটি “${letter.name}” (${letter.letter})?',
            arabicTarget: letter.letter,
            options: options1,
            correctIndex: options1.indexOf(letter.letter),
            explanation: 'সঠিক! এটি “${letter.letter}” (${letter.name})।',
          ),
          // 3. Listen and identify
          QaidaActivity(
            id: '${letter.id}_listen',
            type: QaidaActivityType.listenAndIdentify,
            prompt: 'অডিও শুনে সঠিক হরফটি বাছাই করো',
            arabicTarget: letter.letter,
            audioAsset: audio,
            options: options1,
            correctIndex: options1.indexOf(letter.letter),
            explanation: 'মাশাআল্লাহ! আপনি সঠিক হরফ চিনেছেন।',
          ),
          // 4. Letter name matching
          QaidaActivity(
            id: '${letter.id}_name',
            type: QaidaActivityType.identifyLetter,
            prompt: 'হরফ “${letter.letter}” এর নাম কী?',
            arabicTarget: letter.letter,
            options: options2,
            correctIndex: options2.indexOf(letter.name),
            explanation: 'আলহামদুলিল্লাহ! হরফটির নাম “${letter.name}”।',
          ),
          // 5. Final lesson check
          QaidaActivity(
            id: '${letter.id}_check',
            type: QaidaActivityType.lessonCheck,
            prompt: 'হরফটি আবার যাচাই করি — “${letter.name}” চিনে নিন',
            arabicTarget: letter.letter,
            options: options1,
            correctIndex: options1.indexOf(letter.letter),
            explanation: 'চমৎকার! আপনি “${letter.name}” পাঠ সফলভাবে সম্পন্ন করেছেন।',
          ),
        ],
      );
    }),
  );

  // -------------------------------------------------------------
  // TRACK 2: 28 Letter Forms (হরফের রূপভেদ - শুরু, মধ্য, শেষ)
  // -------------------------------------------------------------
  static final List<Map<String, dynamic>> _letterFormsRaw = [
    {'name': 'আলিফ', 'iso': 'ا', 'init': 'ا', 'med': 'ـا', 'fin': 'ـا', 'join': false},
    {'name': 'বা', 'iso': 'ب', 'init': 'بـ', 'med': 'ـبـ', 'fin': 'ـب', 'join': true},
    {'name': 'তা', 'iso': 'ت', 'init': 'تـ', 'med': 'ـتـ', 'fin': 'ـت', 'join': true},
    {'name': 'ছা', 'iso': 'ث', 'init': 'ثـ', 'med': 'ـثـ', 'fin': 'ـث', 'join': true},
    {'name': 'জীম', 'iso': 'ج', 'init': 'جـ', 'med': 'ـجـ', 'fin': 'ـج', 'join': true},
    {'name': 'হা', 'iso': 'ح', 'init': 'حـ', 'med': 'ـحـ', 'fin': 'ـح', 'join': true},
    {'name': 'খা', 'iso': 'خ', 'init': 'خـ', 'med': 'ـخـ', 'fin': 'ـخ', 'join': true},
    {'name': 'দাল', 'iso': 'د', 'init': 'د', 'med': 'ـد', 'fin': 'ـد', 'join': false},
    {'name': 'যাল', 'iso': 'ذ', 'init': 'ذ', 'med': 'ـذ', 'fin': 'ـذ', 'join': false},
    {'name': 'রা', 'iso': 'ر', 'init': 'ر', 'med': 'ـر', 'fin': 'ـر', 'join': false},
    {'name': 'যা', 'iso': 'ز', 'init': 'ز', 'med': 'ـز', 'fin': 'ـز', 'join': false},
    {'name': 'সীন', 'iso': 'س', 'init': 'سـ', 'med': 'ـسـ', 'fin': 'ـس', 'join': true},
    {'name': 'শীন', 'iso': 'ش', 'init': 'شـ', 'med': 'ـشـ', 'fin': 'ـش', 'join': true},
    {'name': 'সোয়াদ', 'iso': 'ص', 'init': 'صـ', 'med': 'ـصـ', 'fin': 'ـص', 'join': true},
    {'name': 'দোয়াদ', 'iso': 'ض', 'init': 'ضـ', 'med': 'ـضـ', 'fin': 'ـض', 'join': true},
    {'name': 'তোয়া', 'iso': 'ط', 'init': 'طـ', 'med': 'ـطـ', 'fin': 'ـط', 'join': true},
    {'name': 'যোয়া', 'iso': 'ظ', 'init': 'ظـ', 'med': 'ـظـ', 'fin': 'ـظ', 'join': true},
    {'name': 'আইন', 'iso': 'ع', 'init': 'عـ', 'med': 'ـعـ', 'fin': 'ـع', 'join': true},
    {'name': 'গাইন', 'iso': 'غ', 'init': 'غـ', 'med': 'ـغـ', 'fin': 'ـغ', 'join': true},
    {'name': 'ফা', 'iso': 'ف', 'init': 'فـ', 'med': 'ـفـ', 'fin': 'ـف', 'join': true},
    {'name': 'ক্বাফ', 'iso': 'ق', 'init': 'قـ', 'med': 'ـقـ', 'fin': 'ـق', 'join': true},
    {'name': 'কাফ', 'iso': 'ك', 'init': 'كـ', 'med': 'ـكـ', 'fin': 'ـك', 'join': true},
    {'name': 'লাম', 'iso': 'ل', 'init': 'لـ', 'med': 'ـلـ', 'fin': 'ـل', 'join': true},
    {'name': 'মীম', 'iso': 'م', 'init': 'مـ', 'med': 'ـمـ', 'fin': 'ـم', 'join': true},
    {'name': 'নূন', 'iso': 'ن', 'init': 'نـ', 'med': 'ـنـ', 'fin': 'ـن', 'join': true},
    {'name': 'ওয়াও', 'iso': 'و', 'init': 'و', 'med': 'ـو', 'fin': 'ـو', 'join': false},
    {'name': 'হা (নরম)', 'iso': 'ه', 'init': 'هـ', 'med': 'ـهـ', 'fin': 'ـه', 'join': true},
    {'name': 'ইয়া', 'iso': 'ي', 'init': 'يـ', 'med': 'ـيـ', 'fin': 'ـي', 'join': true},
  ];

  static final QaidaTrackInfo _track2Forms = QaidaTrackInfo(
    id: 'track_2_forms',
    trackNumber: 2,
    title: 'হরফের রূপভেদ',
    subtitle: 'শুরু, মধ্য ও শেষ অবস্থানের বিভিন্ন রূপ',
    arabicTitle: 'أَشْكَالُ الْحُرُوفِ',
    description: 'শব্দের বিভিন্ন স্থানে (শুরু, মধ্য ও শেষ) হরফের পরিবর্তিত রূপ চেনা।',
    colorHex: 0xFF1CB0F6, // Duo Blue
    icon: Icons.text_fields_rounded,
    lessons: List.generate(_letterFormsRaw.length, (index) {
      final f = _letterFormsRaw[index];
      final name = f['name'] as String;
      final iso = f['iso'] as String;
      final init = f['init'] as String;
      final med = f['med'] as String;
      final fin = f['fin'] as String;
      final joins = f['join'] as bool;

      return QaidaLessonInfo(
        id: 'qaida_form_$index',
        trackId: 'track_2_forms',
        lessonNumber: index + 1,
        title: '$name-এর রূপভেদ',
        subtitle: 'শুরু $init · মধ্য $med · শেষ $fin',
        arabicDisplay: '$init  $med  $fin',
        description: '$name হরফের একা, শুরুতে, মাঝে ও শেষে রূপ চিনি।',
        ruleSummary: joins
            ? 'এই হরফটি দুই পাশেই জোড়া লাগে।'
            : 'গুরুত্বপূর্ণ: এই হরফটি নিজের পরের অক্ষরের সাথে জোড়া লাগে না!',
        activities: [
          QaidaActivity(
            id: 'form_${index}_intro',
            type: QaidaActivityType.shapeMatching,
            prompt: '$name ($iso) হরফের রূপগুলো লক্ষ্য করি',
            arabicTarget: '$init    $med    $fin',
            explanation: 'শুরুতে: $init | মাঝে: $med | শেষে: $fin',
          ),
          QaidaActivity(
            id: 'form_${index}_init',
            type: QaidaActivityType.shapeMatching,
            prompt: 'শব্দের শুরুতে $name দেখতে কেমন?',
            arabicTarget: init,
            options: [init, med, fin],
            correctIndex: 0,
            explanation: 'সঠিক! শব্দের শুরুতে $name এমন রূপ ধারণ করে: $init',
          ),
          QaidaActivity(
            id: 'form_${index}_med',
            type: QaidaActivityType.shapeMatching,
            prompt: 'শব্দের মাঝে $name দেখতে কেমন রূপ হয়?',
            arabicTarget: med,
            options: [med, init, fin],
            correctIndex: 0,
            explanation: 'মাশাআল্লাহ! মাঝের রূপ হলো: $med',
          ),
          QaidaActivity(
            id: 'form_${index}_fin',
            type: QaidaActivityType.shapeMatching,
            prompt: 'শব্দের শেষে $name এর রূপ কোনটি?',
            arabicTarget: fin,
            options: [fin, init, med],
            correctIndex: 0,
            explanation: 'আলহামদুলিল্লাহ! শেষের রূপ হলো: $fin',
          ),
          QaidaActivity(
            id: 'form_${index}_rule',
            type: QaidaActivityType.ruleInContext,
            prompt: joins
                ? '$name কি পরের অক্ষরের সাথে জোড়া লাগে?'
                : '$name কি নিজের পরের অক্ষরের সাথে জোড়া লাগে?',
            arabicTarget: iso,
            options: joins
                ? ['হ্যাঁ, জোড়া লাগে', 'না, কখনো জোড়া লাগে না']
                : ['না, পরের অক্ষরের সাথে জোড়া লাগে না', 'হ্যাঁ, সবসময় জোড়া লাগে'],
            correctIndex: 0,
            explanation: joins
                ? '$name একটি সংযোগকারী হরফ।'
                : 'মনে রাখুন: (ا د ذ ر ز و) এই ৬টি হরফ নিজের পরের হরফের সাথে জোড়া লাগে না!',
          ),
        ],
      );
    }),
  );

  // -------------------------------------------------------------
  // TRACK 3: 7 Harakat, Tanwin & Sukun (হরকত, তানউইন ও সুকুন)
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track3Harakat = QaidaTrackInfo(
    id: 'track_3_harakat',
    trackNumber: 3,
    title: 'হরকত, তানউইন ও সুকুন',
    subtitle: 'যবর, যের, পেশ, তানউইন ও জযম',
    arabicTitle: 'الْحَرَكَاتُ وَالتَّنْوِينُ وَالسُّكُونُ',
    description: 'আরবি স্বরচিহ্নসমূহ চেনা এবং ছোট স্বর ও জযমযুক্ত হরফ সহীহভাবে পড়া।',
    colorHex: 0xFFFF9600, // Duo Orange
    icon: Icons.graphic_eq_rounded,
    lessons: [
      QaidaLessonInfo(
        id: 'qaida_harakat_fatha',
        trackId: 'track_3_harakat',
        lessonNumber: 1,
        title: 'যবর (ফাতহাহ)',
        subtitle: 'হরফের উপরে আ-কার স্বরধ্বনি',
        arabicDisplay: 'بَ  تَ  ثَ',
        description: 'যবর হরফের উপরে থাকে এবং দ্রুত ছোট “আ/অ” ধ্বনি দেয়। একে না টেনে এক হারাকাত পড়তে হয়।',
        activities: [
          QaidaActivity(
            id: 'fatha_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'যবর ( َ ) হরফের উপরে বসে “আ” ধ্বনি তৈরি করে',
            arabicTarget: 'بَ',
            explanation: 'بَ = বা (যবরকে এক আলিফ টানা যাবে না, দ্রুত পড়তে হয়)',
          ),
          QaidaActivity(
            id: 'fatha_sound',
            type: QaidaActivityType.identifyLetter,
            prompt: '“দাল” হরফের উপর যবর থাকলে কীভাবে পড়ব?',
            arabicTarget: 'دَ',
            options: ['দা', 'দি', 'দু'],
            correctIndex: 0,
            explanation: 'সঠিক! দাল যবর “দা”।',
          ),
          QaidaActivity(
            id: 'fatha_odd',
            type: QaidaActivityType.oddOneOut,
            prompt: 'কোনটিতে যবর নেই?',
            options: ['بِ', 'بَ', 'تَ'],
            correctIndex: 0,
            explanation: 'بِ এর নিচে যের রয়েছে, যবর নয়।',
          ),
          QaidaActivity(
            id: 'fatha_check',
            type: QaidaActivityType.lessonCheck,
            prompt: 'رَ এর সঠিক উচ্চারণ কোনটি?',
            arabicTarget: 'رَ',
            options: ['র', 'রি', 'রু'],
            correctIndex: 0,
            explanation: 'র এর উপর যবর থাকলে তা ভারী/মোটা করে “র” উচ্চারিত হয়।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'qaida_harakat_kasra',
        trackId: 'track_3_harakat',
        lessonNumber: 2,
        title: 'যের (কাসরাহ)',
        subtitle: 'হরফের নিচে ই-কার স্বরধ্বনি',
        arabicDisplay: 'بِ  تِ  ثِ',
        description: 'যের হরফের নিচে থাকে এবং ছোট “ই” ধ্বনি দেয়।',
        activities: [
          QaidaActivity(
            id: 'kasra_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'যের ( ِ ) হরফের নিচে বসে “ই” ধ্বনি তৈরি করে',
            arabicTarget: 'بِ',
            explanation: 'بِ = বি (না টেনে দ্রুত উচ্চারণ করতে হয়)',
          ),
          QaidaActivity(
            id: 'kasra_identify',
            type: QaidaActivityType.identifyLetter,
            prompt: 'مِ এর সঠিক উচ্চারণ কোনটি?',
            arabicTarget: 'مِ',
            options: ['মি', 'মা', 'মু'],
            correctIndex: 0,
            explanation: 'মীম যের “মি”।',
          ),
          QaidaActivity(
            id: 'kasra_odd',
            type: QaidaActivityType.oddOneOut,
            prompt: 'কোনটিতে যের রয়েছে?',
            options: ['سِ', 'سَ', 'سُ'],
            correctIndex: 0,
            explanation: 'সীন-এর নিচে দাগটি হলো যের ( ِ )।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'qaida_harakat_damma',
        trackId: 'track_3_harakat',
        lessonNumber: 3,
        title: 'পেশ (দাম্মাহ)',
        subtitle: 'হরফের উপরে উ-কার স্বরধ্বনি',
        arabicDisplay: 'بُ  تُ  ثُ',
        description: 'পেশ হরফের উপরে ওয়াও-এর মতো ক্ষুদ্র আকারে থাকে এবং ঠোঁট গোল করে “উ” ধ্বনি দেয়।',
        activities: [
          QaidaActivity(
            id: 'damma_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'পেশ ( ُ ) ঠোঁট গোল করে “উ” ধ্বনি প্রকাশ করে',
            arabicTarget: 'بُ',
            explanation: 'বা পেশ “বু”।',
          ),
          QaidaActivity(
            id: 'damma_seq',
            type: QaidaActivityType.sortGroups,
            prompt: 'বَ بِ بُ — এর সঠিক উচ্চারণ ক্রম কোনটি?',
            arabicTarget: 'بَ بِ بُ',
            options: ['বা · বি · বু', 'বি · বু · বা', 'বু · বা · বি'],
            correctIndex: 0,
            explanation: 'যবর (আ), যের (ই), পেশ (উ) = বা · বি · বু।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'qaida_tanwin_fathatayn',
        trackId: 'track_3_harakat',
        lessonNumber: 4,
        title: 'দুই যবর (তানউইন)',
        subtitle: 'হরফের উপরে দুই যবর “আন” ধ্বনি',
        arabicDisplay: 'بًا  تًا  ثًا',
        description: 'দুই যবরকে তানউইন বলে। এর সাথে একটি অদৃশ্য নূন সাকিনের ধ্বনি “আন” যুক্ত হয়।',
        activities: [
          QaidaActivity(
            id: 'tanwin_f_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'দুই যবর ( ً ) যুক্ত হলে “আন” ধ্বনি তৈরি হয়',
            arabicTarget: 'بًا',
            explanation: 'بًا = বা আলিফ দুই যবর “বান্”।',
          ),
          QaidaActivity(
            id: 'tanwin_f_identify',
            type: QaidaActivityType.identifyLetter,
            prompt: 'أَبًا এর উচ্চারণ কী হবে?',
            arabicTarget: 'أَبًا',
            options: ['আবান্', 'আবা', 'আবি'],
            correctIndex: 0,
            explanation: 'সঠিক! আলিফ যবর আ, বা দুই যবর বান্ = আবান্।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'qaida_tanwin_kasratayn',
        trackId: 'track_3_harakat',
        lessonNumber: 5,
        title: 'দুই যের (তানউইন)',
        subtitle: 'হরফের নিচে দুই যের “ইন” ধ্বনি',
        arabicDisplay: 'بٍ  تٍ  ثٍ',
        description: 'হরফের নিচে দুই যের থাকলে তানউইনের “ইন” ধ্বনি সৃষ্টি হয়।',
        activities: [
          QaidaActivity(
            id: 'tanwin_k_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'দুই যের ( ٍ ) থাকলে “ইন” ধ্বনি উচ্চারিত হয়',
            arabicTarget: 'بٍ',
            explanation: 'بٍ = বিন্।',
          ),
          QaidaActivity(
            id: 'tanwin_k_read',
            type: QaidaActivityType.identifyLetter,
            prompt: 'قَوْمٍ এর শেষ হরফের ধ্বনি কী?',
            arabicTarget: 'قَوْمٍ',
            options: ['মিন্ (দুই যের)', 'মান্', 'মুন'],
            correctIndex: 0,
            explanation: 'মাশাআল্লাহ! মীম দুই যের “মিন্”।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'qaida_tanwin_dammatayn',
        trackId: 'track_3_harakat',
        lessonNumber: 6,
        title: 'দুই পেশ (তানউইন)',
        subtitle: 'হরফের উপরে দুই পেশ “উন” ধ্বনি',
        arabicDisplay: 'بٌ  تٌ  ثٌ',
        description: 'হরফের উপরে দুই পেশ থাকলে “উন” ধ্বনি উচ্চারিত হয়।',
        activities: [
          QaidaActivity(
            id: 'tanwin_d_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'দুই পেশ ( ٌ ) থাকলে “উন” ধ্বনি উচ্চারিত হয়',
            arabicTarget: 'بٌ',
            explanation: 'بٌ = বুন।',
          ),
          QaidaActivity(
            id: 'tanwin_d_read',
            type: QaidaActivityType.identifyLetter,
            prompt: 'أَحَدٌ এর শেষে কী আছে?',
            arabicTarget: 'أَحَدٌ',
            options: ['দাল দুই পেশ “দুন”', 'দাল পেশ “দু”', 'দাল যবর “দা”'],
            correctIndex: 0,
            explanation: 'সঠিক! কুল হুয়াল্লাহু আহাদুন-এ দাল দুই পেশ “দুন”।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'qaida_sukun_jazm',
        trackId: 'track_3_harakat',
        lessonNumber: 7,
        title: 'জযম বা সুকুন',
        subtitle: 'হরফের স্থির বা থামা রূপ ( ْ )',
        arabicDisplay: 'أَبْ  أَتْ  أَثْ',
        description: 'জযমযুক্ত হরফ একা পড়া যায় না; পূর্বের হরকতের সাথে মিলিয়ে স্থিরভাবে পড়তে হয়।',
        activities: [
          QaidaActivity(
            id: 'sukun_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'জযম ( ْ ) যুক্ত হরফ তার আগের হরকতের সাথে মিলিত হয়ে পড়া হয়',
            arabicTarget: 'أَبْ',
            explanation: 'আলিফ যবর আ, বা জযম আব্ = আব্।',
          ),
          QaidaActivity(
            id: 'sukun_check',
            type: QaidaActivityType.lessonCheck,
            prompt: 'مَنْ শব্দটিতে কোন হরফে জযম আছে?',
            arabicTarget: 'مَنْ',
            options: ['নূন (نْ)', 'মীম (مَ)', 'কোনটিতেই নয়'],
            correctIndex: 0,
            explanation: 'নূন-এর উপর জযম আছে, তাই এটি মীম যবর ও নূন মিলে “মান্”।',
          ),
        ],
      ),
    ],
  );

  // -------------------------------------------------------------
  // TRACK 4: 10 Madd Lessons (১০ প্রকার মাদ্দ - Verified Taxonomy)
  // 1-alif Madd: 3 types (Tabii, Badal, Leen)
  // 3-alif Madd: 2 types (Aridi, Munfasil)
  // 4-alif Madd: 5 types (Lazim Harfi Mukhaffaf, Lazim Harfi Mushaqqal,
  //                        Lazim Kalimi Mukhaffaf, Lazim Kalimi Mushaqqal, Muttasil)
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track4Madd = QaidaTrackInfo(
    id: 'track_4_madd',
    trackNumber: 4,
    title: '১০ প্রকার মাদ্দ',
    subtitle: '১ আলিফ, ৩ আলিফ ও ৪ আলিফ টেনে পড়ার কানুন',
    arabicTitle: 'أَقْسَامُ الْمُدُودِ الْعَشَرَةُ',
    description: 'নূরানী ক্বায়দার ১০ প্রকার মাদ্দের সম্পূর্ণ নিয়ম ও সহীহ মাত্রা।',
    colorHex: 0xFF9069CD, // Duo Purple
    icon: Icons.waves_rounded,
    lessons: [
      // 1-alif (3 types)
      QaidaLessonInfo(
        id: 'madd_1_tabii',
        trackId: 'track_4_madd',
        lessonNumber: 1,
        title: '১. মাদ্দে তাবি’ঈ (স্বাভাবিক মাদ্দ)',
        subtitle: '১ আলিফ টান · আসল মাদ্দ',
        arabicDisplay: 'بَا  بِي  بُو',
        description: 'যবরের বামে খালি আলিফ, পেশের বামে জযমওয়ালা ওয়াও, যেরের বামে জযমওয়ালা ইয়া থাকলে ১ আলিফ টেনে পড়তে হয়।',
        activities: [
          QaidaActivity(
            id: 'm_tabii_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'মাদের হরফ ৩টি: খালি আলিফ, ওয়াও সাকিন ও ইয়া সাকিন',
            arabicTarget: 'بَا  بِي  بُو',
            explanation: '১ আলিফ পরিমাণ টেনে স্বাভাবিকভাবে পড়তে হয়।',
          ),
          QaidaActivity(
            id: 'm_tabii_identify',
            type: QaidaActivityType.ruleInContext,
            prompt: 'قَالَ শব্দে কোন মাদ্দ রয়েছে?',
            arabicTarget: 'قَالَ',
            options: ['মাদ্দে তাবি’ঈ (১ আলিফ)', 'মাদ্দে মুত্তাসিল', 'মাদ্দ নেই'],
            correctIndex: 0,
            explanation: 'যবরের পর খালি আলিফ এসেছে, তাই এটি মাদ্দে তাবি’ঈ।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'madd_2_badal',
        trackId: 'track_4_madd',
        lessonNumber: 2,
        title: '২. মাদ্দে বাদাল',
        subtitle: '১ আলিফ টান · হামযার পর মাদ্দ',
        arabicDisplay: 'ءَامَنَ  إِيمَانٌ  أُوتُوا',
        description: 'হামযার পর মাদ্দের হরফ আসলে তাকে মাদ্দে বাদাল বলে। ১ আলিফ টানতে হয়।',
        activities: [
          QaidaActivity(
            id: 'm_badal_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'হামযার পরে মাদ্দের হরফ এলে তা মাদ্দে বাদাল',
            arabicTarget: 'ءَامَنَ',
            explanation: 'ء এর পর খালি ا এসেছে = আমানা (১ আলিফ টান)।',
          ),
          QaidaActivity(
            id: 'm_badal_rule',
            type: QaidaActivityType.ruleInContext,
            prompt: 'إِيمَانٌ শব্দে মাদ্দে বাদাল কত আলিফ টানতে হয়?',
            arabicTarget: 'إِيمَانٌ',
            options: ['১ আলিফ', '৩ আলিফ', '৪ আলিফ'],
            correctIndex: 0,
            explanation: 'মাদ্দে বাদাল ১ আলিফ টেনে পড়তে হয়।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'madd_3_leen',
        trackId: 'track_4_madd',
        lessonNumber: 3,
        title: '৩. মাদ্দে লীন',
        subtitle: '১ আলিফ নরমভাবে পড়া',
        arabicDisplay: 'خَوْفٍ  بَيْتٍ',
        description: 'যবরের বামে জযমওয়ালা ওয়াও বা ইয়া থাকলে লীন হয়। ওয়াকফ ছাড়া ১ আলিফ নরমভাবে পড়ে।',
        activities: [
          QaidaActivity(
            id: 'm_leen_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'যবরের পর وْ বা يْ আসলে নরম করে দ্রুত পড়তে হয়',
            arabicTarget: 'خَوْفٍ',
            explanation: 'খাওফিন - নরম সুরে পড়া লীনের হরফ।',
          ),
          QaidaActivity(
            id: 'm_leen_letters',
            type: QaidaActivityType.identifyLetter,
            prompt: 'লীনের হরফ কয়টি?',
            options: ['২টি (وْ এবং يْ)', '৩টি', '৪টি'],
            correctIndex: 0,
            explanation: 'যবরের পর সাকিন ওয়াও এবং সাকিন ইয়া — এই ২টি লীনের হরফ।',
          ),
        ],
      ),
      // 3-alif (2 types)
      QaidaLessonInfo(
        id: 'madd_4_aridi',
        trackId: 'track_4_madd',
        lessonNumber: 4,
        title: '৪. মাদ্দে আরিদী',
        subtitle: '৩ আলিফ টান · ওয়াকফের কারণে সাকিন',
        arabicDisplay: 'الْعَالَمِينَ  الرَّحِيمِ',
        description: 'মাদ্দের হরফের পরের হরফে ওয়াকফ করার কারণে সাকিন সৃষ্টি হলে ৩ আলিফ টেনে পড়তে হয়।',
        activities: [
          QaidaActivity(
            id: 'm_aridi_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'আয়াতের শেষে থামলে (ওয়াকফ করলে) আরিদী মাদ্দ হয়',
            arabicTarget: 'الْعَالَمِينَ',
            explanation: 'আল-আলামীন... থামার সময় নূন সাকিন হয়ে ৩ আলিফ টানা হয়।',
          ),
          QaidaActivity(
            id: 'm_aridi_check',
            type: QaidaActivityType.ruleInContext,
            prompt: 'الرَّحِيمِ -তে থামলে কত আলিফ টানতে হবে?',
            arabicTarget: 'الرَّحِيمِ',
            options: ['৩ আলিফ (মাদ্দে আরিদী)', '১ আলিফ', 'টানা নিষেধ'],
            correctIndex: 0,
            explanation: 'ওয়াকফ করার কারণে এটি মাদ্দে আরিদী হয়ে ৩ আলিফ দীর্ঘ হয়।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'madd_5_munfasil',
        trackId: 'track_4_madd',
        lessonNumber: 5,
        title: '৫. মাদ্দে মুনফাসিল',
        subtitle: '৩ আলিফ টান · পৃথক শব্দে হামযা',
        arabicDisplay: 'فِي أَنفُسِكُمْ  قُو أَنفُسَكُمْ',
        description: 'মাদ্দের হরফের পর পৃথক শব্দে হামযা (ء বা ا) আসলে মাদ্দে মুনফাসিল হয়। ৩ আলিফ টান।',
        activities: [
          QaidaActivity(
            id: 'm_munfasil_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'মাদ্দের হরফের পর পরবর্তী শব্দে হামযা আসলে মাদ্দে মুনফাসিল',
            arabicTarget: 'فِي أَنفُسِكُمْ',
            explanation: 'فِي এর শেষে ইয়া মাদ্দ, পরের শব্দে أَنفُসِكُمْ এর শুরুতে হামযা এসেছে।',
          ),
          QaidaActivity(
            id: 'm_munfasil_length',
            type: QaidaActivityType.identifyLetter,
            prompt: 'মাদ্দে মুনফাসিল সাধারণত কত আলিফ টানতে হয়?',
            options: ['৩ আলিফ', '১ আলিফ', '৫ আলিফ'],
            correctIndex: 0,
            explanation: 'নূরানী কায়দা অনুসারে মাদ্দে মুনফাসিল ৩ আলিফ টান।',
          ),
        ],
      ),
      // 4-alif (5 types)
      QaidaLessonInfo(
        id: 'madd_6_harfi_mukh',
        trackId: 'track_4_madd',
        lessonNumber: 6,
        title: '৬. মাদ্দে লাযিম হরফী মুখাফফাফ',
        subtitle: '৪ আলিফ টান · মুকাত্তা’আত হরফে হালকা সাকিন',
        arabicDisplay: 'ص  ق  ن',
        description: 'হুরুফে মুকাত্তা’আতের যে হরফের মাদ্দের পর সাকিন থাকে এবং ইদগাম হয় না, তা ৪ আলিফ টানা হয়।',
        activities: [
          QaidaActivity(
            id: 'm_hmukh_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'কুরআনের শুরুতে “নূন”, “ক্বাফ”, “সোয়াদ” ৪ আলিফ টেনে পড়তে হয়',
            arabicTarget: 'نٓ  ۚ  وَالْقَلَمِ',
            explanation: 'نٓ = নূওওন (৪ আলিফ লাযিম হরফী মুখাফফাফ)।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'madd_7_harfi_mush',
        trackId: 'track_4_madd',
        lessonNumber: 7,
        title: '৭. মাদ্দে লাযিম হরফী মুসাক্কাল',
        subtitle: '৪ আলিফ টান · মুকাত্তা’আত হরফে ভারী তাশদীদ',
        arabicDisplay: 'الم  (الـلَّامُ-مِّيم)',
        description: 'হুরুফে মুকাত্তা’আতের হরফে মাদ্দের পর তাশদীদসহ ইদগাম হলে ৪ আলিফ পূর্ণ টেনে পড়া হয়।',
        activities: [
          QaidaActivity(
            id: 'm_hmush_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'الم-তে “লাম”-এর মাদ্দের পর “মীম”-এ তাশদীদ হয়',
            arabicTarget: 'الٓمٓ',
            explanation: 'আলিফ-লাআআআম-মীইইইম (লাম-এ ৪ আলিফ মুসাক্কাল টান)।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'madd_8_kalimi_mukh',
        trackId: 'track_4_madd',
        lessonNumber: 8,
        title: '৮. মাদ্দে লাযিম কালিমী মুখাফফাফ',
        subtitle: '৪ আলিফ টান · শব্দে মাদ্দের পর সাকিন',
        arabicDisplay: 'ءَآلْآنَ',
        description: 'একই শব্দের মধ্যে মাদ্দের হরফের পর আসল সাকিন আসলে মাদ্দে লাযিম কালিমী মুখাফফাফ হয়।',
        activities: [
          QaidaActivity(
            id: 'm_kmukh_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'ءَآلْآنَ শব্দে মাদ্দের পর লাম সাকিন (لْ) রয়েছে',
            arabicTarget: 'ءَآلْآنَ',
            explanation: 'কুরআনে এটি ৪ আলিফ টেনে স্পষ্ট পড়া হয়।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'madd_9_kalimi_mush',
        trackId: 'track_4_madd',
        lessonNumber: 9,
        title: '৯. মাদ্দে লাযিম কালিমী মুসাক্কাল',
        subtitle: '৪ আলিফ টান · শব্দে মাদ্দের পর তাশদীদ',
        arabicDisplay: 'الضَّالِّينَ  الْحَاقَّةُ',
        description: 'শব্দের মধ্যে মাদ্দের হরফের পরে তাশদীদযুক্ত হরফ আসলে ৪ আলিফ পূর্ণ টেনে পড়তে হয়।',
        activities: [
          QaidaActivity(
            id: 'm_kmush_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'সূরা ফাতিহার الضَّالِّينَ শব্দে ৪ আলিফ টেনে পড়তে হয়',
            arabicTarget: 'وَلَا الضَّالِّينَ',
            explanation: 'দোয়াদ আলিফ মাদ্দের পর লাম-এ তাশদীদ এসেছে, তাই ৪ আলিফ টান।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'madd_10_muttasil',
        trackId: 'track_4_madd',
        lessonNumber: 10,
        title: '১০. মাদ্দে মুত্তাসিল',
        subtitle: '৪ আলিফ টান · একই শব্দে হামযা',
        arabicDisplay: 'جَاءَ  سُوءَ  سِيئَتْ',
        description: 'একই শব্দের ভেতরে মাদ্দের হরফের ঠিক পরেই হামযা আসলে মাদ্দে মুত্তাসিল হয়। ৪ আলিফ টানতে হয়।',
        activities: [
          QaidaActivity(
            id: 'm_muttasil_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'একই শব্দে মাদ্দের সাথে হামযা এলে মাদ্দে মুত্তাসিল',
            arabicTarget: 'جَاءَ نَصْرُ اللَّهِ',
            explanation: 'جَاءَ শব্দে আলিফ মাদ্দের পর হামযা একই শব্দে এসেছে = ৪ আলিফ টান।',
          ),
          QaidaActivity(
            id: 'm_muttasil_check',
            type: QaidaActivityType.ruleInContext,
            prompt: 'سَمَاءٌ শব্দে কোন মাদ্দ আছে?',
            arabicTarget: 'سَمَاءٌ',
            options: ['মাদ্দে মুত্তাসিল (৪ আলিফ)', 'মাদ্দে তাবি’ঈ (১ আলিফ)', 'মাদ্দ নেই'],
            correctIndex: 0,
            explanation: 'একই শব্দে হামযা থাকায় এটি মাদ্দে মুত্তাসিল।',
          ),
        ],
      ),
    ],
  );

  // -------------------------------------------------------------
  // TRACK 5: 10 Noon/Meem Sakin & Ghunnah (নূন সাকিন, মীম সাকিন ও গুন্নাহ)
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track5Ghunnah = QaidaTrackInfo(
    id: 'track_5_ghunnah',
    trackNumber: 5,
    title: 'নূন সাকিন ও গুন্নাহ',
    subtitle: 'ইযহার, ইদগাম, ইক্বলাব, ইখফা ও ক্বলক্বলাহ',
    arabicTitle: 'أَحْكَامُ النُّونِ السَّاكِنَةِ وَالْمِيمِ',
    description: 'নূন সাকিন, তানউইন, মীম সাকিন এবং ওয়াজিব গুন্নাহ ও ক্বলক্বলাহর ১০টি মূল নিয়ম।',
    colorHex: 0xFF2B70C9, // Deep Blue
    icon: Icons.record_voice_over_rounded,
    lessons: [
      QaidaLessonInfo(
        id: 'ghunnah_1_wajib',
        trackId: 'track_5_ghunnah',
        lessonNumber: 1,
        title: '১. ওয়াজিব গুন্নাহ',
        subtitle: 'নূন ও মীম তাশদীদ (نّ ও مّ)',
        arabicDisplay: 'إِنَّ  عَمَّ  ثُمَّ',
        description: 'নূন ও মীমের উপর তাশদীদ হলে নাকের বাঁশিতে ১ আলিফ পরিমাণ গুন্নাহ করা ওয়াজিব।',
        activities: [
          QaidaActivity(
            id: 'g_wajib_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'نّ বা مّ দেখলে অবশ্যই ১ আলিফ পরিমাণ গুন্নাহ করতে হবে',
            arabicTarget: 'إِنَّ اللَّهَ مَعَنَا',
            explanation: 'ইন্নাল্লাহা — নূনে তাশদীদ থাকায় সুন্দর গুন্নাহ হবে।',
          ),
          QaidaActivity(
            id: 'g_wajib_identify',
            type: QaidaActivityType.ruleInContext,
            prompt: 'عَمَّ يَتَسَاءَلُونَ -এ কোন হরফে ওয়াজিব গুন্নাহ?',
            arabicTarget: 'عَمَّ',
            options: ['মীম তাশদীদ (مّ)', 'আইন', 'কোনটিতেই নয়'],
            correctIndex: 0,
            explanation: 'মীম তাশদীদ হলো ওয়াজিব গুন্নাহর হরফ।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'ghunnah_2_izhar',
        trackId: 'track_5_ghunnah',
        lessonNumber: 2,
        title: '২. ইযহার (স্পষ্ট পড়া)',
        subtitle: 'হলক্বী ৬ হরফ: ء ه ع ح غ خ',
        arabicDisplay: 'مَنْ ءَامَنَ  مِنْ خَوْفٍ',
        description: 'নূন সাকিন বা তানউইনের পর হলক্বী ৬টি হরফের যেকোনোটি আসলে গুন্নাহ ছাড়া স্পষ্ট পড়তে হয়।',
        activities: [
          QaidaActivity(
            id: 'g_izhar_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'ইযহারের হরফ ৬টি: হামযা, হা, আইন, হা, গাইন, খা',
            arabicTarget: 'مَنْ هَدَى',
            explanation: 'মান্ হাদা — এখানে নূন সাকিন গুন্নাহ ছাড়া স্পষ্ট পড়া হয়।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'ghunnah_3_idgham_ghunnah',
        trackId: 'track_5_ghunnah',
        lessonNumber: 3,
        title: '৩. ইদগামে বাগুন্নাহ',
        subtitle: 'গুন্নাহসহ মেলানো (ي ن م و)',
        arabicDisplay: 'مَن يَقُولُ  مِن مَّالٍ',
        description: 'নূন সাকিন বা তানউইনের পর ي ن م و হরফ আসলে গুন্নাহর সাথে মিলিয়ে পড়তে হয়।',
        activities: [
          QaidaActivity(
            id: 'g_idgham_b_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'مَن يَقُولُ = মাইঁইয়াক্বূলু (গুন্নাহসহ মিলিয়ে পড়া)',
            arabicTarget: 'مَن يَقُولُ',
            explanation: 'নূন সাকিনের পর ইয়া আসায় ইদগামে বাগুন্নাহ হয়েছে।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'ghunnah_4_idgham_bila',
        trackId: 'track_5_ghunnah',
        lessonNumber: 4,
        title: '৪. ইদগামে বেলাগুন্নাহ',
        subtitle: 'গুন্নাহ ছাড়া মেলানো (ل ও ر)',
        arabicDisplay: 'مِّن رَّبِّهِمْ  هُدًى لِّلْمُتَّقِينَ',
        description: 'নূন সাকিন বা তানউইনের পর লাম (ل) বা রা (ر) আসলে গুন্নাহ ছাড়াই মিলিয়ে পড়তে হয়।',
        activities: [
          QaidaActivity(
            id: 'g_idgham_l_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'مِّن رَّبِّهِمْ = মির রাব্বিহিম (গুন্নাহ ছাড়া)',
            arabicTarget: 'مِّن رَّبِّهِمْ',
            explanation: 'নূন সাকিনের পর রা আসায় বেলাগুন্নাহ হয়েছে।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'ghunnah_5_iqlab',
        trackId: 'track_5_ghunnah',
        lessonNumber: 5,
        title: '৫. ইক্বলাব (পরিবর্তন)',
        subtitle: 'বা (ب) আসলে মীম (م) দিয়ে পড়া',
        arabicDisplay: 'مِن بَعْدِ  (مِم بَعْدِ)',
        description: 'নূন সাকিন বা তানউইনের পর বা (ب) আসলে নূনটি মীম (م)-এ পরিণত হয়ে গুন্নাহসহ পড়া হয়।',
        activities: [
          QaidaActivity(
            id: 'g_iqlab_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'مِن بَعْدِ = মিম্ বা’দি (ছোট م দেখে চিনুন)',
            arabicTarget: 'مِنۢ بَعْدِ',
            explanation: 'নূন পরিবর্তিত হয়ে মীম হয়ে যায় এবং গুন্নাহ হয়।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'ghunnah_6_ikhfa',
        trackId: 'track_5_ghunnah',
        lessonNumber: 6,
        title: '৬. ইখফা (গোপন করে পড়া)',
        subtitle: '১৫টি হরফে নাকের বাঁশিতে লুকানো',
        arabicDisplay: 'أَنتُمْ  مِن قَبْلُ  كُنتُمْ',
        description: 'নূন সাকিন বা তানউইনের পর ইখফার ১৫টি হরফ আসলে নাকের বাঁশিতে লুকিয়ে গুন্নাহ করা হয়।',
        activities: [
          QaidaActivity(
            id: 'g_ikhfa_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'أَنتُمْ = আংতুম (নাকের বাঁশিতে নূনের ধ্বনি লুকানো)',
            arabicTarget: 'أَنتُمْ',
            explanation: 'তা (ت) ইখফার হরফ, তাই এখানে গুন্নাহ লুকানো হয়েছে।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'ghunnah_7_meem_ikhfa',
        trackId: 'track_5_ghunnah',
        lessonNumber: 7,
        title: '৭. মীম সাকিন - ইখফায়ে শাফাবী',
        subtitle: 'মীম সাকিনের পর বা (ب)',
        arabicDisplay: 'تَرْمِيهِم بِحِجَارَةٍ',
        description: 'মীম সাকিনের পর বা আসলে ঠোঁট আলতোভাবে মিলিয়ে গুন্নাহর সাথে ইখফা করা হয়।',
        activities: [
          QaidaActivity(
            id: 'g_m_ikhfa_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'تَرْمِيهِم بِحِجَارَةٍ - মীম সাকিনের পর বা এসেছে',
            arabicTarget: 'تَرْمِيهِم بِحِجَارَةٍ',
            explanation: 'তারমীহিম্ বিহিজারাহ — গুন্নাহর সাথে পড়া।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'ghunnah_8_meem_idgham',
        trackId: 'track_5_ghunnah',
        lessonNumber: 8,
        title: '৮. মীম সাকিন - ইদগামে শাফাবী',
        subtitle: 'মীম সাকিনের পর মীম (م)',
        arabicDisplay: 'لَهُم مَّا يَشَاءُونَ',
        description: 'মীম সাকিনের পর আরেকটি মীম আসলে গুন্নাহসহ উভয় মীম মিলিয়ে তাশদীদ দিয়ে পড়া হয়।',
        activities: [
          QaidaActivity(
            id: 'g_m_idgham_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'لَهُم مَّا = লাহুম্মা (উভয় মীম মিলিয়ে গুন্নাহ)',
            arabicTarget: 'لَهُم مَّا',
            explanation: 'মীম সাকিনের পর মীম আসলে ইদগাম হয়।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'ghunnah_9_meem_izhar',
        trackId: 'track_5_ghunnah',
        lessonNumber: 9,
        title: '৯. মীম সাকিন - ইযহারে শাফাবী',
        subtitle: 'বা ও মীম ছাড়া বাকি ২৬ হরফে স্পষ্ট পড়া',
        arabicDisplay: 'أَلَمْ تَرَ  عَلَيْهِمْ وَلَا',
        description: 'মীম সাকিনের পর বা এবং মীম ছাড়া যেকোনো হরফ আসলে গুন্নাহ ছাড়া স্পষ্ট পড়তে হয়।',
        activities: [
          QaidaActivity(
            id: 'g_m_izhar_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'أَلَمْ تَرَ = আলাম তারা (স্পষ্ট মীম সাকিন)',
            arabicTarget: 'أَلَمْ تَرَ',
            explanation: 'মীম সাকিনের পর তা আসায় স্পষ্ট পড়তে হবে।',
          ),
        ],
      ),
      QaidaLessonInfo(
        id: 'ghunnah_10_qalqalah',
        trackId: 'track_5_ghunnah',
        lessonNumber: 10,
        title: '১০. ক্বলক্বলাহ (প্রতিধ্বনি)',
        subtitle: '৫টি হরফে সাকিন হলে ধাক্কা দিয়ে পড়া',
        arabicDisplay: 'قُطْبُ جَدٍّ  (ق ط ب ج د)',
        description: 'ক্বলক্বলার হরফ ৫টি: ক্বাফ, তোয়া, বা, জীম, দাল। এতে জযম হলে প্রতিধ্বনি বা ধাক্কা দিয়ে পড়তে হয়।',
        activities: [
          QaidaActivity(
            id: 'g_qalqalah_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'قُلْ هُوَ اللَّهُ أَحَدْ - শেষে দাল সাকিনে ক্বলক্বলাহ হবে',
            arabicTarget: 'أَحَدْ ۚ',
            explanation: 'দাল সাকিন হলে ধাক্কা দিয়ে “আহাদ্ব্” পড়তে হয়।',
          ),
          QaidaActivity(
            id: 'g_qalqalah_letters',
            type: QaidaActivityType.identifyLetter,
            prompt: 'ক্বলক্বলার হরফ কয়টি?',
            options: ['৫টি (ق ط ب ج د)', '৩টি', '৭টি'],
            correctIndex: 0,
            explanation: 'ক্বলক্বলার ৫টি হরফ সংক্ষেপে “কুতুবু জাদিন”।',
          ),
        ],
      ),
    ],
  );

  // -------------------------------------------------------------
  // TRACK 6: 20 Joined Letters (যুক্তাক্ষর পাঠ)
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track6Joined = QaidaTrackInfo(
    id: 'track_6_joined',
    trackNumber: 6,
    title: 'যুক্তাক্ষর পাঠ',
    subtitle: '২ ও ৩ হরফের সংযুক্ত রূপ ও সংযোগ বিধান',
    arabicTitle: 'الْحُرُوفُ الْمُرَكَّبَةُ',
    description: 'একাধিক হরফ একসাথে জুড়ে কীভাবে শব্দরূপ গঠিত হয় তা ধারাবাহিকভাবে চেনা।',
    colorHex: 0xFF0D7377, // Deep Teal
    icon: Icons.extension_rounded,
    lessons: List.generate(20, (index) {
      final samples = [
        {'text': 'لا', 'parts': 'ل + ا', 'name': 'লাম-আলিফ'},
        {'text': 'با', 'parts': 'ب + ا', 'name': 'বা-আলিফ'},
        {'text': 'تا', 'parts': 'ت + ا', 'name': 'তা-আলিফ'},
        {'text': 'ثا', 'parts': 'ث + ا', 'name': 'ছা-আলিফ'},
        {'text': 'بل', 'parts': 'ب + ل', 'name': 'বা-লাম'},
        {'text': 'تل', 'parts': 'ت + ل', 'name': 'তা-লাম'},
        {'text': 'ثل', 'parts': 'ث + ل', 'name': 'ছা-লাম'},
        {'text': 'بج', 'parts': 'ب + ج', 'name': 'বা-জীম'},
        {'text': 'تح', 'parts': 'ت + ح', 'name': 'তা-হা'},
        {'text': 'ثخ', 'parts': 'ث + خ', 'name': 'ছা-খা'},
        {'text': 'يم', 'parts': 'ي + م', 'name': 'ইয়া-মীম'},
        {'text': 'نم', 'parts': 'ن + م', 'name': 'নূন-মীম'},
        {'text': 'تم', 'parts': 'ت + م', 'name': 'তা-মীম'},
        {'text': 'سم', 'parts': 'س + م', 'name': 'সীন-মীম'},
        {'text': 'شم', 'parts': 'ش + م', 'name': 'শীন-মীম'},
        {'text': 'صم', 'parts': 'ص + م', 'name': 'সোয়াদ-মীম'},
        {'text': 'ضم', 'parts': 'ض + م', 'name': 'দোয়াদ-মীম'},
        {'text': 'بيت', 'parts': 'ب + ي + ت', 'name': 'বা-ইয়া-তা'},
        {'text': 'نجم', 'parts': 'ن + ج + م', 'name': 'নূন-জীম-মীম'},
        {'text': 'شمس', 'parts': 'ش + م + س', 'name': 'শীন-মীম-সীন'},
      ];
      final item = samples[index % samples.length];

      return QaidaLessonInfo(
        id: 'qaida_joined_$index',
        trackId: 'track_6_joined',
        lessonNumber: index + 1,
        title: 'যুক্তাক্ষর: ${item['name']}',
        subtitle: '${item['parts']} = ${item['text']}',
        arabicDisplay: item['text']!,
        description: 'হরফ সংযুক্ত করে পড়ার অনুশীলন: ${item['parts']}',
        activities: [
          QaidaActivity(
            id: 'j_${index}_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'লক্ষ্য করুন: ${item['parts']} একসাথে যুক্ত হয়ে কী রূপ ধারণ করে',
            arabicTarget: item['text']!,
            explanation: '${item['parts']} = ${item['text']}',
          ),
          QaidaActivity(
            id: 'j_${index}_build',
            type: QaidaActivityType.buildWord,
            prompt: '“${item['text']}” যুক্তাক্ষরে কোন কোন হরফ রয়েছে?',
            arabicTarget: item['text']!,
            options: [item['parts']!, 'বাকি হরফ', 'ভুল বিন্যাস'],
            correctIndex: 0,
            explanation: 'সঠিক! এটি গঠিত হয়েছে: ${item['parts']}',
          ),
          QaidaActivity(
            id: 'j_${index}_check',
            type: QaidaActivityType.lessonCheck,
            prompt: 'সঠিক যুক্তরূপটি চিনে নাও',
            arabicTarget: item['text']!,
            options: [item['text']!, 'بت', 'نت'],
            correctIndex: 0,
            explanation: 'আলহামদুলিল্লাহ! আপনি সঠিক যুক্তরূপ চিনেছেন।',
          ),
        ],
      );
    }),
  );

  // -------------------------------------------------------------
  // TRACK 7: 30 Word Reading (শব্দ পাঠ)
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track7Words = QaidaTrackInfo(
    id: 'track_7_words',
    trackNumber: 7,
    title: 'শব্দ পাঠ',
    subtitle: 'কুরআনের পরিচিত শব্দের সহীহ বানান ও পাঠ',
    arabicTitle: 'قِرَاءَةُ الْكَلِمَاتِ',
    description: 'হরকত, সুকুন ও মাদ্দ মিলিয়ে সম্পূর্ণ আরবি শব্দ সাবলীলভাবে পড়ার অনুশীলন।',
    colorHex: 0xFF00CD9C, // Bright Mint
    icon: Icons.auto_stories_rounded,
    lessons: List.generate(30, (index) {
      final words = [
        {'ar': 'كَتَبَ', 'bn': 'কাতাবা', 'desc': '৩টি যবরযুক্ত সহজ শব্দ'},
        {'ar': 'قَرَأَ', 'bn': 'ক্বারা-আ', 'desc': 'হামযাসহ শব্দ পাঠ'},
        {'ar': 'عَلِمَ', 'bn': 'আলিমা', 'desc': 'যবর, যের ও যবর'},
        {'ar': 'سَمِعَ', 'bn': 'সামিআ', 'desc': 'দ্রুত হরকত পড়া'},
        {'ar': 'خَلَقَ', 'bn': 'খালাক্বা', 'desc': 'ভারী ও হালকা হরফের মিশ্রণ'},
        {'ar': 'رَزَقَ', 'bn': 'রাঝাক্বা', 'desc': 'অসংযুক্ত হরফ র'},
        {'ar': 'ذَكَرَ', 'bn': 'যাকারা', 'desc': 'নরম হরফ যাল'},
        {'ar': 'صَدَقَ', 'bn': 'সাদাক্বা', 'desc': 'সোয়াদ ও ক্বাফ'},
        {'ar': 'نَصَرَ', 'bn': 'নাসারা', 'desc': 'সহজ শব্দ'},
        {'ar': 'ضَرَبَ', 'bn': 'দারাবা', 'desc': 'দোয়াদ হরফের রূপ'},
        {'ar': 'بِسْمِ', 'bn': 'বিসমি', 'desc': 'সুকুনযুক্ত শব্দ'},
        {'ar': 'الْحَمْدُ', 'bn': 'আল-হামদু', 'desc': 'আলিফ-লাম ও সুকুন'},
        {'ar': 'رَبِّ', 'bn': 'রাব্বি', 'desc': 'তাশদীদযুক্ত শব্দ'},
        {'ar': 'مَالِكِ', 'bn': 'মালিকি', 'desc': 'খাড়া যবর ও ১ আলিফ মাদ্দ'},
        {'ar': 'يَوْمِ', 'bn': 'ইয়াওমি', 'desc': 'মাদ্দে লীনযুক্ত শব্দ'},
        {'ar': 'الدِّينِ', 'bn': 'আদ-দীনি', 'desc': 'শামসী হরফ ও তাশদীদ'},
        {'ar': 'إِيَّاكَ', 'bn': 'ইয়্যাকা', 'desc': 'তাশদীদ ও মাদ্দ'},
        {'ar': 'نَعْبُدُ', 'bn': 'না’বুদু', 'desc': 'আইন সাকিন স্পষ্ট করা'},
        {'ar': 'نَسْتَعِينُ', 'bn': 'নাসতাঈনু', 'desc': 'সুকুন ও মাদ্দের শব্দ'},
        {'ar': 'اهْدِنَا', 'bn': 'ইহদিনা', 'desc': 'নরম হা ও সুকুন'},
        {'ar': 'الصِّرَاطَ', 'bn': 'আস-সিরাতা', 'desc': 'ভারী হরফের মিশ্রণ'},
        {'ar': 'الْمُسْتَقِيمَ', 'bn': 'আল-মুসতাক্বীম', 'desc': 'লম্বা পরিচিত শব্দ'},
        {'ar': 'أَنْعَمْتَ', 'bn': 'আন’আমতা', 'desc': 'ইযহার ও আইন সাকিন'},
        {'ar': 'عَلَيْهِمْ', 'bn': 'আলাইহিম', 'desc': 'লীন ও মীম সাকিন'},
        {'ar': 'غَيْرِ', 'bn': 'গাইরি', 'desc': 'গাইন ও লীন হরফ'},
        {'ar': 'الْمَغْضُوبِ', 'bn': 'আল-মাগদূবি', 'desc': 'গাইন ও দোয়াদ সাকিন'},
        {'ar': 'وَلاَ', 'bn': 'ওয়ালা', 'desc': 'লাম আলিফ মাদ্দ'},
        {'ar': 'الضَّالِّينَ', 'bn': 'আদ-দ্বাল্লীন', 'desc': '৪ আলিফ লাযিম মাদ্দ'},
        {'ar': 'سُبْحَانَ', 'bn': 'সুবহানা', 'desc': 'বা সাকিনে ক্বলক্বলাহ'},
        {'ar': 'قُلْ', 'bn': 'ক্বুল', 'desc': 'পেশ ও সুকুন'},
      ];
      final item = words[index % words.length];

      return QaidaLessonInfo(
        id: 'qaida_word_$index',
        trackId: 'track_7_words',
        lessonNumber: index + 1,
        title: 'শব্দ: ${item['ar']}',
        subtitle: '${item['bn']} (${item['desc']})',
        arabicDisplay: item['ar']!,
        description: 'কুরআনের শব্দ “${item['ar']}” সহীহ উচ্চারণে বানান ও পড়া শিখি।',
        activities: [
          QaidaActivity(
            id: 'w_${index}_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'শব্দটি মনোযোগ দিয়ে দেখুন: ${item['ar']}',
            arabicTarget: item['ar']!,
            explanation: '${item['ar']} = ${item['bn']}। ${item['desc']}',
          ),
          QaidaActivity(
            id: 'w_${index}_identify',
            type: QaidaActivityType.identifyLetter,
            prompt: '“${item['ar']}” শব্দের সঠিক বাংলা উচ্চারণ কোনটি?',
            arabicTarget: item['ar']!,
            options: [item['bn']!, 'ভুল রূপ ১', 'ভুল রূপ ২'],
            correctIndex: 0,
            explanation: 'মাশাআল্লাহ! সঠিক উচ্চারণ: ${item['bn']}।',
          ),
          QaidaActivity(
            id: 'w_${index}_check',
            type: QaidaActivityType.lessonCheck,
            prompt: 'নিচের কোনটি “${item['ar']}”?',
            arabicTarget: item['ar']!,
            options: [item['ar']!, 'كَتَبَتْ', 'عَلِمُوا'],
            correctIndex: 0,
            explanation: 'চমৎকার! আপনি শব্দটি নিখুঁতভাবে চিহ্নিত করেছেন।',
          ),
        ],
      );
    }),
  );

  // -------------------------------------------------------------
  // TRACK 8: 40 Sentence & Continuous Reading (আয়াত ও বাক্য পাঠ)
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track8Sentences = QaidaTrackInfo(
    id: 'track_8_sentences',
    trackNumber: 8,
    title: 'আয়াত ও বাক্য পাঠ',
    subtitle: 'ধারাবাহিক তিলাওয়াত, ওয়াকফ ও সূরা ফাতিহা',
    arabicTitle: 'قِرَاءَةُ الآيَاتِ وَالسُّوَرِ',
    description: 'শেখা সকল নিয়ম ও মাদ্দ প্রয়োগ করে কুরআনের পূর্ণ আয়াত ও বাক্য পাঠ।',
    colorHex: 0xFFE040FB, // Vibrant Magenta
    icon: Icons.menu_book_rounded,
    lessons: List.generate(40, (index) {
      final ayahs = [
        {'ar': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', 'bn': 'বিসমিল্লাহির রাহমানির রাহীম', 'focus': 'তাসমিয়া'},
        {'ar': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', 'bn': 'আলহামদু লিল্লাহি রাব্বিল আলামীন', 'focus': 'সূরা ফাতিহা আয়াত ১'},
        {'ar': 'الرَّحْمَٰنِ الرَّحِيمِ', 'bn': 'আর-রাহমানির রাহীম', 'focus': 'সূরা ফাতিহা আয়াত ২'},
        {'ar': 'مَالِكِ يَوْمِ الدِّينِ', 'bn': 'মালিকি ইয়াওমিদ্দীন', 'focus': 'সূরা ফাতিহা আয়াত ৩'},
        {'ar': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', 'bn': 'ইয়্যাকা না’বুদু ওয়া ইয়্যাকা নাসতাঈন', 'focus': 'সূরা ফাতিহা আয়াত ৪'},
        {'ar': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', 'bn': 'ইহদিনাস সিরাতাল মুসতাক্বীম', 'focus': 'সূরা ফাতিহা আয়াত ৫'},
        {'ar': 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ', 'bn': 'সিরাতাল্লাযীনা আন’আমতা আলাইহিম', 'focus': 'সূরা ফাতিহা আয়াত ৬'},
        {'ar': 'غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ', 'bn': 'গাইরিল মাগদূবি আলাইহিম ওয়ালাদ-দ্বাল্লীন', 'focus': 'সূরা ফাতিহা আয়াত ৭'},
        {'ar': 'قُلْ هُوَ اللَّهُ أَحَدٌ', 'bn': 'ক্বুল হুয়াল্লাহু আহাদ', 'focus': 'সূরা ইখলাস আয়াত ১'},
        {'ar': 'اللَّهُ الصَّمَدُ', 'bn': 'আল্লাহুস সামাদ', 'focus': 'সূরা ইখলাস আয়াত ২'},
        {'ar': 'لَمْ يَلِدْ وَلَمْ يُولَدْ', 'bn': 'লাম ইয়ালিদ ওয়া লাম ইয়ূলাদ', 'focus': 'সূরা ইখলাস আয়াত ৩'},
        {'ar': 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ', 'bn': 'ওয়া লাম ইয়াকুল্লাহু কুফুওয়ান আহাদ', 'focus': 'সূরা ইখলাস আয়াত ৪'},
        {'ar': 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ', 'bn': 'ক্বুল আউযু বিরাব্বিল ফালাক্ব', 'focus': 'সূরা ফালাক্ব আয়াত ১'},
        {'ar': 'مِن شَرِّ مَا خَلَقَ', 'bn': 'মিন শাররি মা খালাক্ব', 'focus': 'সূরা ফালাক্ব আয়াত ২'},
        {'ar': 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ', 'bn': 'ওয়া মিন শাররি গাসিক্বিন ইযা ওয়াক্বাব', 'focus': 'সূরা ফালাক্ব আয়াত ৩'},
        {'ar': 'وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ', 'bn': 'ওয়া মিন শাররিন নাফ্ফাসাতি ফিল উক্বাফ', 'focus': 'সূরা ফালাক্ব আয়াত ৪'},
        {'ar': 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ', 'bn': 'ওয়া মিন শাররি হাসিদিন ইযা হাসাদ', 'focus': 'সূরা ফালাক্ব আয়াত ৫'},
        {'ar': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ', 'bn': 'ক্বুল আউযু বিরাব্বিন নাস', 'focus': 'সূরা নাস আয়াত ১'},
        {'ar': 'مَلِكِ النَّاسِ', 'bn': 'মালিকিন নাস', 'focus': 'সূরা নাস আয়াত ২'},
        {'ar': 'إِلَٰهِ النَّاسِ', 'bn': 'ইলাহিন নাস', 'focus': 'সূরা নাস আয়াত ৩'},
        {'ar': 'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ', 'bn': 'মিন শাররিল ওয়াসওয়াসিল খান্নাস', 'focus': 'সূরা নাস আয়াত ৪'},
        {'ar': 'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ', 'bn': 'আল্লাযী ইউওয়াসবিসু ফী সুদূরিন নাস', 'focus': 'সূরা নাস আয়াত ৫'},
        {'ar': 'مِنَ الْجِنَّةِ وَالنَّاسِ', 'bn': 'মিনাল জিন্নাতি ওয়ান নাস', 'focus': 'সূরা নাস আয়াত ৬'},
        {'ar': 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ', 'bn': 'ইন্না আ’তাইনা-কাল কাওছার', 'focus': 'সূরা কাওসার আয়াত ১'},
        {'ar': 'فَصَلِّ لِرَبِّكَ وَانْحَرْ', 'bn': 'ফাসাল্লি লিরাব্বিকা ওয়ানহার', 'focus': 'সূরা কাওসার আয়াত ২'},
        {'ar': 'إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ', 'bn': 'ইন্না শানিয়াকা হুয়াল আবতার', 'focus': 'সূরা কাওসার আয়াত ৩'},
        {'ar': 'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ', 'bn': 'ইযা জা-আ নাসরুল্লাহি ওয়াল ফাতহ', 'focus': 'সূরা নাসর আয়াত ১'},
        {'ar': 'وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا', 'bn': 'ওয়া রাইতান নাসা ইয়াদখুলূনা ফী দীনিল্লাহি আফওয়াজা', 'focus': 'সূরা নাসর আয়াত ২'},
        {'ar': 'فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ', 'bn': 'ফাসাব্বিহ বিহামদি রাব্বিকা ওয়াসতাগফিরহু', 'focus': 'সূরা নাসর আয়াত ৩'},
        {'ar': 'إِنَّهُ كَانَ تَوَّابًا', 'bn': 'ইন্নাহু কানা তাউওয়াবা', 'focus': 'সূরা নাসর সমাপনী'},
        {'ar': 'تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ', 'bn': 'তাব্বাত ইয়াদা আবী লাহাবিওঁ ওয়াতাব্ব', 'focus': 'সূরা লাহাব আয়াত ১'},
        {'ar': 'مَا أَغْنَىٰ عَنْهُ مَالُهُ وَمَا كَسَبَ', 'bn': 'মা আগনা আনহু মালুহু ওয়ামা কাসাব', 'focus': 'সূরা লাহাব আয়াত ২'},
        {'ar': 'سَيَصْلَىٰ نَارًا ذَاتَ لَهَبٍ', 'bn': 'সাইয়াসলা নারান যাতা লাহাব', 'focus': 'সূরা লাহাব আয়াত ৩'},
        {'ar': 'وَامْرَأَتُهُ حَمَّالَةَ الْحَطَبِ', 'bn': 'ওয়ামরাআতুহু হাম্মা-লাতাল হাতাব', 'focus': 'সূরা লাহাব আয়াত ৪'},
        {'ar': 'فِي جِيدِهَا حَبْلٌ مِّن مَّسَدٍ', 'bn': 'ফী জীদিহা হাবলুম মিম মাসাদ', 'focus': 'সূরা লাহাব আয়াত ৫'},
        {'ar': 'لِإِيلَافِ قُرَيْشٍ', 'bn': 'লি ঈলাফি কুরাইশ', 'focus': 'সূরা কুরাইশ আয়াত ১'},
        {'ar': 'إِيلَافِهِمْ رِحْلَةَ الشِّتَاءِ وَالصَّيْفِ', 'bn': 'ঈলাফিহিম রিহলাতাশ শিতা-ই ওয়াস সাইফ', 'focus': 'সূরা কুরাইশ আয়াত ২'},
        {'ar': 'فَلْيَعْبُدُوا رَبَّ هَٰذَا الْبَيْتِ', 'bn': 'ফালইয়া’বুদূ রাব্বা হাযাল বাইত', 'focus': 'সূরা কুরাইশ আয়াত ৩'},
        {'ar': 'الَّذِي أَطْعَمَهُم مِّن جُوعٍ', 'bn': 'আল্লাযী আত’আমাহুম মিন জূ’', 'focus': 'সূরা কুরাইশ আয়াত ৪'},
        {'ar': 'وَآمَنَهُم مِّنْ خَوْفٍ', 'bn': 'ওয়া আমানাহুম মিন খাওফ', 'focus': 'সূরা কুরাইশ আয়াত ৫'},
      ];
      final item = ayahs[index % ayahs.length];

      return QaidaLessonInfo(
        id: 'qaida_sentence_$index',
        trackId: 'track_8_sentences',
        lessonNumber: index + 1,
        title: 'আয়াত পাঠ: ${item['focus']}',
        subtitle: item['bn']!,
        arabicDisplay: item['ar']!,
        description: 'সহীহ মাখরাজ ও তাজবীদের নিয়মানুযায়ী আয়াত পাঠ অনুশীলন।',
        activities: [
          QaidaActivity(
            id: 's_${index}_intro',
            type: QaidaActivityType.letterIntro,
            prompt: 'আয়াতটি স্পষ্টভাবে দেখুন এবং তিলাওয়াত করুন',
            arabicTarget: item['ar']!,
            explanation: '${item['bn']} (${item['focus']})',
          ),
          QaidaActivity(
            id: 's_${index}_read',
            type: QaidaActivityType.readWordByWord,
            prompt: 'আয়াতের শেষ হরফে ওয়াকফ (থামার) নিয়ম লক্ষ্য করুন',
            arabicTarget: item['ar']!,
            explanation: 'আয়াতের শেষে থামলে শেষ হরফের হরকত সাকিন হয়ে যায়।',
          ),
          QaidaActivity(
            id: 's_${index}_check',
            type: QaidaActivityType.lessonCheck,
            prompt: '“${item['focus']}”-এর সঠিক আয়াত কোনটি?',
            arabicTarget: item['ar']!,
            options: [item['ar']!, 'بِسْمِ اللَّهِ', 'الْحَمْدُ لِلَّهِ'],
            correctIndex: 0,
            explanation: 'আলহামদুলিল্লাহ! আপনি আয়াতটি সহীহভাবে চিহ্নিত করেছেন।',
          ),
        ],
      );
    }),
  );
}
