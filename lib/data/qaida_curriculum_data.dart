import 'package:flutter/material.dart';
import '../models/qaida/qaida_models.dart';
import '../screens/qaida/qaida_letters.dart';

/// Master curriculum data for the 8 tracks of the Qaida system.
/// Every standard lesson contains exactly 10 mandatory practice activities.
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

  // Helper to find the next incomplete lesson for "Continue Learning"
  static QaidaLessonInfo getFirstIncompleteLesson(bool Function(String id) hasCompleted) {
    for (final track in tracks) {
      for (final lesson in track.lessons) {
        if (!hasCompleted(lesson.id)) return lesson;
      }
    }
    return tracks.first.lessons.first;
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
      final prevLetter = index > 0 ? qaidaLetters[index - 1] : qaidaLetters.last;
      final nextLetter = index < qaidaLetters.length - 1 ? qaidaLetters[index + 1] : qaidaLetters.first;

      // Group similar-looking letters for Differentiate step
      final similarGroups = [
        ['ب', 'ت', 'ث'],
        ['ج', 'ح', 'خ'],
        ['د', 'ذ'],
        ['ر', 'ز'],
        ['س', 'ش'],
        ['ص', 'ض'],
        ['ط', 'ظ'],
        ['ع', 'غ'],
        ['ف', 'ق'],
      ];
      String similar = prevLetter.letter;
      for (final g in similarGroups) {
        if (g.contains(letter.letter)) {
          final others = g.where((c) => c != letter.letter).toList();
          if (others.isNotEmpty) similar = others.first;
          break;
        }
      }

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
          // 1. Warm-up / Recall
          QaidaActivity(
            id: '${letter.id}_step1_recall',
            slotNumber: 1,
            type: QaidaActivityType.warmupRecall,
            prompt: 'পূর্ববর্তী পাঠ স্মরণ: হরফ “${prevLetter.letter}”-এর নাম কী?',
            arabicTarget: prevLetter.letter,
            options: [prevLetter.letter, letter.letter, nextLetter.letter],
            correctIndex: 0,
            explanation: 'মাশাআল্লাহ! এটি পূর্বের হরফ “${prevLetter.name}” (${prevLetter.letter})।',
          ),
          // 2. Recognize
          QaidaActivity(
            id: '${letter.id}_step2_recognize',
            slotNumber: 2,
            type: QaidaActivityType.recognize,
            prompt: 'আজকের নতুন হরফ চিনে নিই: কোনটি “${letter.name}” (${letter.letter})?',
            arabicTarget: letter.letter,
            options: [letter.letter, prevLetter.letter, nextLetter.letter],
            correctIndex: 0,
            explanation: 'সঠিক! এটি “${letter.letter}” (${letter.name})।',
          ),
          // 3. Listen & Identify
          QaidaActivity(
            id: '${letter.id}_step3_listen',
            slotNumber: 3,
            type: QaidaActivityType.listenAndIdentify,
            prompt: 'উচ্চারণ শুনুন এবং সঠিক হরফটি বাছাই করুন',
            arabicTarget: letter.letter,
            audioAsset: audio,
            options: [letter.letter, nextLetter.letter, prevLetter.letter],
            correctIndex: 0,
            explanation: 'চমৎকার! আপনি শুনে সঠিক হরফ নির্বাচন করেছেন।',
          ),
          // 4. Match Pairs — tap-to-match interactive UI
          QaidaActivity(
            id: '${letter.id}_step4_match',
            slotNumber: 4,
            type: QaidaActivityType.matchPairs,
            prompt: 'হরফ ও তার নামের জোড়া মিলাও',
            pairs: {
              letter.letter: letter.transliteration,
              prevLetter.letter: prevLetter.transliteration,
              nextLetter.letter: nextLetter.transliteration,
            },
            explanation: 'চমৎকার! প্রতিটি হরফের আরবি নাম আলাদা ও অনন্য।',
            feedbackCorrect: 'মাশাআল্লাহ! সব জোড়া সঠিক!',
            feedbackIncorrect: 'আবার চেষ্টা করো — হরফের আকৃতি দেখে মিলাও।',
            skillId: 'letter_name_\${letter.id}',
            difficulty: QaidaActivityDifficulty.easy,
          ),
          // 5. Differentiate (similar looking)
          QaidaActivity(
            id: '${letter.id}_step5_diff',
            slotNumber: 5,
            type: QaidaActivityType.differentiate,
            prompt: 'সদৃশ হরফের পার্থক্য: নিচের কোনটি “${letter.name}” (${letter.letter}), “$similar” নয়?',
            arabicTarget: letter.letter,
            options: [letter.letter, similar, 'ا'],
            correctIndex: 0,
            explanation: 'খুব ভালো! নুকতা বা আকৃতি খেয়াল করে আপনি “${letter.letter}” আলাদা করেছেন।',
          ),
          // 6. Build / Arrange — tile-based ordering
          QaidaActivity(
            id: '${letter.id}_step6_arrange',
            slotNumber: 6,
            type: QaidaActivityType.buildArrange,
            prompt: 'হরফমালার ক্রমে সাজাও: "${prevLetter.letter}"-এর পরে কোনটি আসে?',
            tiles: [
              ActivityTile(id: prevLetter.id, label: prevLetter.transliteration, arabicLabel: prevLetter.letter),
              ActivityTile(id: letter.id, label: letter.transliteration, arabicLabel: letter.letter),
              ActivityTile(id: nextLetter.id, label: nextLetter.transliteration, arabicLabel: nextLetter.letter),
            ],
            explanation: 'ঠিক তাই! "${prevLetter.letter}"-এর পরের ক্রম হলো "${letter.letter}"।',
            feedbackCorrect: 'চমৎকার! সঠিক ক্রম মনে রেখো।',
            feedbackIncorrect: 'হরফমালার ক্রম আবার দেখো।',
            skillId: 'letter_order_\${letter.id}',
          ),
          // 7. Read in Context
          QaidaActivity(
            id: '${letter.id}_step7_context',
            slotNumber: 7,
            type: QaidaActivityType.readInContext,
            prompt: 'শব্দের মাঝে লক্ষ্য করুন: “${letter.letter}” হরফটি চিহ্নিত করুন',
            arabicTarget: 'قَالَ',
            options: [letter.letter, 'ب', 'م'],
            correctIndex: 0,
            explanation: 'হরফটি বিভিন্ন শব্দের মধ্যে সহীহভাবে পড়া যায়।',
          ),
          // 8. Apply the Rule
          QaidaActivity(
            id: '${letter.id}_step8_rule',
            slotNumber: 8,
            type: QaidaActivityType.applyRule,
            prompt: 'মাখরাজ লক্ষ্য করি: এই স্থান থেকে কোন হরফটি উচ্চারিত হয়? (${letter.makhraj})',
            arabicTarget: letter.letter,
            options: [letter.letter, nextLetter.letter, 'م'],
            correctIndex: 0,
            explanation: 'মাখরাজ: ${letter.makhraj}',
          ),
          // 9. Mixed Practice
          QaidaActivity(
            id: '${letter.id}_step9_mixed',
            slotNumber: 9,
            type: QaidaActivityType.mixedPractice,
            prompt: 'মিশ্র যাচাই: “${prevLetter.letter}”, “${letter.letter}”, “${nextLetter.letter}” এর মধ্যে “${letter.name}” কোনটি?',
            arabicTarget: letter.letter,
            options: [letter.letter, prevLetter.letter, nextLetter.letter],
            correctIndex: 0,
            explanation: 'মাশাআল্লাহ! আপনি সঠিক হরফ বাছাই করেছেন।',
          ),
          // 10. Lesson Check
          QaidaActivity(
            id: '${letter.id}_step10_check',
            slotNumber: 10,
            type: QaidaActivityType.lessonCheck,
            prompt: 'চূড়ান্ত পাঠ যাচাই: হরফ “${letter.name}” চিহ্নিত করুন',
            arabicTarget: letter.letter,
            options: [letter.letter, similar, prevLetter.letter],
            correctIndex: 0,
            explanation: 'অভিনন্দন! আপনি “${letter.name}” পাঠের ১০টি ধাপ সফলভাবে শেষ করেছেন!',
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
    {'name': 'বা', 'iso': 'ب', 'init': 'بـ', 'med': 'ـبـ', 'fin': 'ـব', 'join': true},
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
          // 1. Recall
          QaidaActivity(
            id: 'form_${index}_step1_recall',
            slotNumber: 1,
            type: QaidaActivityType.warmupRecall,
            prompt: '$name-এর একাকী (মূল) রূপ কোনটি?',
            arabicTarget: iso,
            options: [iso, 'د', 'ر'],
            correctIndex: 0,
            explanation: 'সঠিক! এটি $name-এর মূল রূপ: $iso',
          ),
          // 2. Recognize
          QaidaActivity(
            id: 'form_${index}_step2_recognize',
            slotNumber: 2,
            type: QaidaActivityType.recognize,
            prompt: 'শব্দের শুরুতে $name দেখতে কেমন?',
            arabicTarget: init,
            options: [init, med, fin],
            correctIndex: 0,
            explanation: 'শব্দের শুরুতে $name রূপ ধারণ করে: $init',
          ),
          // 3. Listen & Identify
          QaidaActivity(
            id: 'form_${index}_step3_listen',
            slotNumber: 3,
            type: QaidaActivityType.listenAndIdentify,
            prompt: 'উচ্চারণ লক্ষ্য করে $name-এর মাঝের রূপটি বাছুন',
            arabicTarget: med,
            options: [med, init, fin],
            correctIndex: 0,
            explanation: 'মাঝের রূপ হলো: $med',
          ),
          // 4. Match Pairs
          QaidaActivity(
            id: 'form_${index}_step4_match',
            slotNumber: 4,
            type: QaidaActivityType.matchPairs,
            prompt: '$name-এর রূপের জোড়া মিলাও',
            arabicTarget: fin,
            pairs: {
              init: med,
              iso: fin,
            },
            explanation: 'সঠিক জোড়া: শুরু ($init) ও মধ্য ($med); মূল ($iso) ও শেষ ($fin)।',
            feedbackCorrect: 'মাশাআল্লাহ! রূপের জোড়া মিলেছে!',
            feedbackIncorrect: 'আবার চেষ্টা করো — রূপ দুটি খেয়াল করো।',
          ),
          // 5. Differentiate
          QaidaActivity(
            id: 'form_${index}_step5_diff',
            slotNumber: 5,
            type: QaidaActivityType.differentiate,
            prompt: 'শুরু ($init) এবং শেষের ($fin) রূপের পার্থক্য করুন — কোনটি শুরুর রূপ?',
            arabicTarget: init,
            options: [init, fin, iso],
            correctIndex: 0,
            explanation: 'শুরুতে ডানপাশে খোলা থাকে এবং বামে যুক্ত হয়: $init',
          ),
          // 6. Build / Arrange
          QaidaActivity(
            id: 'form_${index}_step6_arrange',
            slotNumber: 6,
            type: QaidaActivityType.buildArrange,
            prompt: '$name-এর রূপের ক্রম (শুরু ➔ মধ্য ➔ শেষ) সাজাও',
            arabicTarget: '$init  $med  $fin',
            tiles: [
              ActivityTile(id: '1', label: '1', arabicLabel: init),
              ActivityTile(id: '2', label: '2', arabicLabel: med),
              ActivityTile(id: '3', label: '3', arabicLabel: fin),
            ],
            explanation: 'সঠিক ক্রম: শুরু ($init) ➔ মধ্য ($med) ➔ শেষ ($fin)।',
            feedbackCorrect: 'চমৎকার! রূপের ধারাবাহিক ক্রম সঠিক!',
            feedbackIncorrect: 'শুরু থেকে শেষ পর্যন্ত আবার সাজাও।',
          ),
          // 7. Read in Context
          QaidaActivity(
            id: 'form_${index}_step7_context',
            slotNumber: 7,
            type: QaidaActivityType.readInContext,
            prompt: 'শব্দে $name-এর রূপটি লক্ষ্য করুন',
            arabicTarget: '$initـت',
            options: [iso, 'س', 'م'],
            correctIndex: 0,
            explanation: 'শব্দের শুরুতে $name স্পষ্টভাবে চেনা যায়।',
          ),
          // 8. Apply Rule
          QaidaActivity(
            id: 'form_${index}_step8_rule',
            slotNumber: 8,
            type: QaidaActivityType.applyRule,
            prompt: joins
                ? '$name কি পরের অক্ষরের সাথে জোড়া লাগে?'
                : '$name কি নিজের পরের অক্ষরের সাথে জোড়া লাগে?',
            arabicTarget: iso,
            options: joins
                ? ['ـ$isoـ', iso]
                : [iso, 'ـ$isoـ'],
            correctIndex: 0,
            explanation: joins
                ? '$name সংযোগকারী হরফ।'
                : 'মনে রাখুন: (ا د ذ ر ز و) পরের অক্ষরের সাথে জোড়া লাগে না!',
          ),
          // 9. Mixed Practice
          QaidaActivity(
            id: 'form_${index}_step9_mixed',
            slotNumber: 9,
            type: QaidaActivityType.mixedPractice,
            prompt: 'নিচের কোনটিতে $name-এর মাঝের রূপ রয়েছে?',
            arabicTarget: med,
            options: [med, 'ـسـ', 'ـعـ'],
            correctIndex: 0,
            explanation: 'মাশাআল্লাহ! আপনি সঠিক রূপ চিনেছেন।',
          ),
          // 10. Lesson Check
          QaidaActivity(
            id: 'form_${index}_step10_check',
            slotNumber: 10,
            type: QaidaActivityType.lessonCheck,
            prompt: 'পাঠ যাচাই: $name-এর ৩টি রূপ ($init · $med · $fin) আয়ত্ত হয়েছে?',
            arabicTarget: '$init $med $fin',
            options: [med, 'ـعـ', 'ـفـ'],
            correctIndex: 0,
            explanation: 'আলহামদুলিল্লাহ! $name-এর রূপভেদের ১০টি ধাপ সফল হয়েছে!',
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
    lessons: _generateTrack3Lessons(),
  );

    static List<QaidaLessonInfo> _generateTrack3Lessons() {
    final definitions = [
      {
        'id': 'qaida_h_fatha',
        'name': 'যবর (ফাতহাহ)',
        'sub': 'আ-কার ধ্বনি · ১ হারাকাত',
        'sym': 'بَ',
        'sound': 'বা (আ)',
        'desc': 'হরফের উপরে এক দাগকে যবর (ফাতহাহ) বলে। যবরযুক্ত হরফকে না টেনে দ্রুত পড়তে হয়।',
        'letters': ['ـَ'],
        'words': ['دَرَجَ', 'زَرَعَ', 'طَلَبَ', 'وَجَدَ', 'كَتَبَ', 'نَظَرَ', 'صَبَرَ', 'فَتَحَ', 'ذَهَبَ', 'عَبَدَ'],
        'contrasts': ['كُتِبَ', 'شَرِبَ', 'عَلِمَ', 'سَمِعَ', 'ظُلِمَ', 'قُتِلَ'],
        'pairs': {'دَرَجَ': 'زَرَعَ', 'طَلَبَ': 'وَجَدَ', 'كُتِبَ': 'شَرِبَ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'كَ'), ActivityTile(id: '2', label: '2', arabicLabel: 'تَ'), ActivityTile(id: '3', label: '3', arabicLabel: 'بَ')],
        'blank': 'كَتَ___َ',
        'blankOpts': ['ب', 'ت', 'م'],
      },
      {
        'id': 'qaida_h_kasra',
        'name': 'যের (কাসরাহ)',
        'sub': 'ই-কার ধ্বনি · ১ হারাকাত',
        'sym': 'بِ',
        'sound': 'বি (ই)',
        'desc': 'হরফের নিচে এক দাগকে যের (কাসরাহ) বলে। যেরযুক্ত হরফকে না টেনে দ্রুত পড়তে হয়।',
        'letters': ['ـِ'],
        'words': ['شَرِبَ', 'سَمِعَ', 'عَلِمَ', 'رَحِمَ', 'حَمِدَ', 'لَعِبَ', 'غَضِبَ', 'خَسِرَ', 'بَرِقَ', 'فَهِمَ'],
        'contrasts': ['دَرَجَ', 'كَتَبَ', 'كُتِبَ', 'ظُلِمَ', 'نَظَرَ', 'صَبَرَ'],
        'pairs': {'شَرِبَ': 'سَمِعَ', 'عَلِمَ': 'رَحِمَ', 'دَرَجَ': 'كَتَبَ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'عَ'), ActivityTile(id: '2', label: '2', arabicLabel: 'لِ'), ActivityTile(id: '3', label: '3', arabicLabel: 'مَ')],
        'blank': 'عَ___مَ',
        'blankOpts': ['لِ', 'لَ', 'لُ'],
      },
      {
        'id': 'qaida_h_damma',
        'name': 'পেশ (দাম্মাহ)',
        'sub': 'উ-কার ধ্বনি · ঠোঁট গোল করে',
        'sym': 'بُ',
        'sound': 'বু (উ)',
        'desc': 'হরফের উপরে ছোট ওয়াও-এর মতো চিহ্নকে পেশ (দাম্মাহ) বলে। ঠোঁট গোল করে না টেনে পড়তে হয়।',
        'letters': ['ـُ'],
        'words': ['كُتِبَ', 'ظُلِمَ', 'قُتِلَ', 'ضُرِبَ', 'جُمِعَ', 'حُشِرَ', 'رُفِعَ', 'خُلِقَ', 'نُصِرَ', 'بُعِثَ'],
        'contrasts': ['دَرَجَ', 'شَرِبَ', 'كَتَبَ', 'سَمِعَ', 'فَتَحَ', 'عَلِمَ'],
        'pairs': {'كُتِبَ': 'ظُلِمَ', 'قُتِلَ': 'ضُرِبَ', 'دَرَجَ': 'شَرِبَ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'كُ'), ActivityTile(id: '2', label: '2', arabicLabel: 'تِ'), ActivityTile(id: '3', label: '3', arabicLabel: 'بَ')],
        'blank': '___تِبَ',
        'blankOpts': ['كُ', 'كَ', 'كِ'],
      },
      {
        'id': 'qaida_t_fatha',
        'name': 'দুই যবর (তানউইন)',
        'sub': 'আন ধ্বনি · নূন সাকিন সমতুল্য',
        'sym': 'بًا',
        'sound': 'বান্',
        'desc': 'হরফের উপরে দুই দাগকে দুই যবর (তানউইন) বলে। এর ভেতরে একটি অপ্রকাশিত নূন সাকিন থাকে।',
        'letters': ['ـً'],
        'words': ['أَحَدًا', 'عَمَلًا', 'رَحْمَةً', 'كِتَابًا', 'بَصِيرًا', 'عَلِيمًا', 'حَكِيمًا', 'قَرِيبًا', 'شَكُورًا', 'غَفُورًا'],
        'contrasts': ['أَحَدٌ', 'لَهَبٍ', 'عَمَلٍ', 'خَوْفٍ', 'رَحْمَةٌ', 'كِتَابٌ'],
        'pairs': {'أَحَدًا': 'عَمَلًا', 'بَصِيرًا': 'عَلِيمًا', 'أَحَدٌ': 'لَهَبٍ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'أَ'), ActivityTile(id: '2', label: '2', arabicLabel: 'حَ'), ActivityTile(id: '3', label: '3', arabicLabel: 'دًا')],
        'blank': 'أَحَ___',
        'blankOpts': ['دًا', 'دٌ', 'دٍ'],
      },
      {
        'id': 'qaida_t_kasra',
        'name': 'দুই যের (তানউইন)',
        'sub': 'ইন ধ্বনি · নূন সাকিন সমতুল্য',
        'sym': 'بٍ',
        'sound': 'বিন্',
        'desc': 'হরফের নিচে দুই দাগকে দুই যের (তানউইন) বলে। দ্রুত ইন ধ্বনি দিয়ে পড়তে হয়।',
        'letters': ['ـٍ'],
        'words': ['لَهَبٍ', 'مَسَدٍ', 'خَوْفٍ', 'بَيْتٍ', 'حَسَدٍ', 'عَلَقٍ', 'قَدَرٍ', 'شَيْءٍ', 'كُلٍّ', 'يَوْمٍ'],
        'contrasts': ['أَحَدًا', 'أَحَدٌ', 'عَمَلًا', 'عَلِيمًا', 'شَكُورٌ', 'غَفُورًا'],
        'pairs': {'لَهَبٍ': 'مَسَدٍ', 'خَوْفٍ': 'بَيْتٍ', 'أَحَدًا': 'أَحَدٌ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'لَ'), ActivityTile(id: '2', label: '2', arabicLabel: 'هَ'), ActivityTile(id: '3', label: '3', arabicLabel: 'بٍ')],
        'blank': 'لَهَ___',
        'blankOpts': ['بٍ', 'بًا', 'بٌ'],
      },
      {
        'id': 'qaida_t_damma',
        'name': 'দুই পেশ (তানউইন)',
        'sub': 'উন ধ্বনি · নূন সাকিন সমতুল্য',
        'sym': 'بٌ',
        'sound': 'বুন',
        'desc': 'হরফের উপরে দুই পেশকে তানউইন বলে। ঠোঁট গোল করে উন ধ্বনি দিয়ে পড়তে হয়।',
        'letters': ['ـٌ'],
        'words': ['أَحَدٌ', 'صَمَدٌ', 'نَارٌ', 'عَذَابٌ', 'غَفُورٌ', 'رَحِيمٌ', 'سَمِيعٌ', 'عَلِيمٌ', 'حَسِيبٌ', 'قَرِيبٌ'],
        'contrasts': ['أَحَدًا', 'لَهَبٍ', 'مَسَدٍ', 'عَمَلًا', 'خَوْفٍ', 'بَيْتٍ'],
        'pairs': {'أَحَدٌ': 'صَمَدٌ', 'غَفُورٌ': 'رَحِيمٌ', 'أَحَدًا': 'لَهَبٍ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'أَ'), ActivityTile(id: '2', label: '2', arabicLabel: 'حَ'), ActivityTile(id: '3', label: '3', arabicLabel: 'دٌ')],
        'blank': 'أَحَ___',
        'blankOpts': ['دٌ', 'دًا', 'دٍ'],
      },
      {
        'id': 'qaida_s_sukun',
        'name': 'জযম বা সুকুন',
        'sub': 'স্থির থামা রূপ · পূর্বের হরকতের সাথে যুক্ত',
        'sym': 'أَبْ',
        'sound': 'আব্',
        'desc': 'হরফের উপরে ছোট বৃত্ত বা চাঁদের মতো চিহ্নকে জযম/সুকুন বলে। সুকুনযুক্ত হরফ নিজে উচ্চারিত হতে পারে না, পূর্বের হরকতের সাথে মিলিত হয়ে থামে।',
        'letters': ['ـْ'],
        'words': ['أَبْ', 'يَعْلَمُ', 'يَذْهَبُ', 'نَعْبُدُ', 'نَسْتَعِينُ', 'يَسْمَعُ', 'يَفْعَلُ', 'يَشْرَبُ', 'يَكْتُبُ', 'يَدْخُلُ'],
        'contrasts': ['كَتَبَ', 'شَرِبَ', 'دَرَجَ', 'عَلِمَ', 'ظُلِمَ', 'قُتِلَ'],
        'pairs': {'نَعْبُدُ': 'نَسْتَعِينُ', 'يَعْلَمُ': 'يَذْهَبُ', 'كَتَبَ': 'شَرِبَ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'نَعْ'), ActivityTile(id: '2', label: '2', arabicLabel: 'بُ'), ActivityTile(id: '3', label: '3', arabicLabel: 'دُ')],
        'blank': 'نَ___ْبُدُ',
        'blankOpts': ['ع', 'م', 'ت'],
      },
    ];

    return definitions.map((d) {
      final words = d['words'] as List<String>;
      final contrasts = d['contrasts'] as List<String>;
      final letters = d['letters'] as List<String>;
      return QaidaLessonInfo(
        id: d['id'] as String,
        trackId: 'track_3_harakat',
        lessonNumber: definitions.indexOf(d) + 1,
        title: d['name'] as String,
        subtitle: d['sub'] as String,
        arabicDisplay: d['sym'] as String,
        description: d['desc'] as String,
        ruleSummary: d['desc'] as String,
        ruleLetters: letters,
        exampleWords: words.take(4).toList(),
        activities: _buildTajweed10StepLesson(
          lessonId: d['id'] as String,
          topicName: d['name'] as String,
          ruleDescription: d['desc'] as String,
          practiceWords: words,
          contrastWords: contrasts,
          ruleLetters: letters,
          matchPairs: d['pairs'] as Map<String, String>,
          arrangeTiles: d['tiles'] as List<ActivityTile>,
          blankWord: d['blank'] as String,
          blankOptions: d['blankOpts'] as List<String>,
          blankCorrectIndex: 0,
        ),
      );
    }).toList();
  }

  // -------------------------------------------------------------
  // TRACK 4: 10 Madd Lessons (১০ প্রকার মাদ্দ - Verified Taxonomy)
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
    lessons: _generateTrack4Lessons(),
  );

  static List<QaidaLessonInfo> _generateTrack4Lessons() {
    final definitions = [
      {
        'id': 'madd_1_tabii',
        'name': '১. মাদ্দে তাবি’ঈ',
        'sub': '১ আলিফ টান · আসল মাদ্দ',
        'sym': 'بَا  بِي  بُو',
        'desc': 'যবরের বামে খালি আলিফ, পেশের বামে জযমওয়ালা ওয়াও এবং যেরের বামে জযমওয়ালা ইয়া আসলে তাকে মাদ্দে তাবি’ঈ বলে। একে ১ আলিফ পরিমাণ টেনে পড়তে হয়।',
        'letters': ['ا', 'و', 'ي'],
        'words': ['قَالَ', 'قِيلَ', 'يَقُولُ', 'نُوحِيهَا', 'فِيهَا', 'أُوتِينَا', 'تَجْرِي', 'الَّذِينَ', 'يَعْلَمُونَ', 'كَانُوا'],
        'contrasts': ['قَلَّ', 'كَتَبَ', 'شَرِبَ', 'دَرَجَ', 'عَلِمَ', 'قَلَمٌ'],
        'pairs': {'قَالَ': 'قِيلَ', 'يَقُولُ': 'نُوحِيهَا', 'قَلَّ': 'كَتَبَ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'قَا'), ActivityTile(id: '2', label: '2', arabicLabel: 'لَ')],
        'blank': 'قَ___لَ',
        'blankOpts': ['ا', 'و', 'ي'],
      },
      {
        'id': 'madd_2_badal',
        'name': '২. মাদ্দে বাদাল',
        'sub': '১ আলিফ টান · হামযার পর মাদ্দ',
        'sym': 'ءَامَنَ',
        'desc': 'হামযার পর মাদ্দের হরফ আসলে তাকে মাদ্দে বাদাল বলে। এটি মূলত দুটি হামযা একত্র হয়ে সৃষ্টি হয় এবং ১ আলিফ পরিমাণ টেনে পড়তে হয়।',
        'letters': ['ءَا', 'إِي', 'أُو'],
        'words': ['ءَامَنَ', 'إِيمَانًا', 'أُوتُوا', 'ءَاتَىٰ', 'ءَادَمُ', 'ءَالِهَتُنَا', 'ءَامِنِينَ', 'أُوتِيَ', 'إِيلَافِهِمْ', 'ءَايَاتٍ'],
        'contrasts': ['أَمَرَ', 'أَكَلَ', 'إِنَّ', 'أَنْعَمْتَ', 'أَحَدٌ', 'أَنْتُمْ'],
        'pairs': {'ءَامَنَ': 'إِيمَانًا', 'أُوتُوا': 'ءَاتَىٰ', 'أَمَرَ': 'أَكَلَ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'ءَا'), ActivityTile(id: '2', label: '2', arabicLabel: 'مَ'), ActivityTile(id: '3', label: '3', arabicLabel: 'نَ')],
        'blank': '___مَنَ',
        'blankOpts': ['ءَا', 'أَ', 'إِ'],
      },
      {
        'id': 'madd_3_leen',
        'name': '৩. মাদ্দে লীন',
        'sub': '১ আলিফ নরমভাবে পড়া',
        'sym': 'خَوْفٍ  بَيْتٍ',
        'desc': 'যবরের বামে জযমওয়ালা ওয়াও বা জযমওয়ালা ইয়া আসলে লীন হয়। ওয়াকফ করলে ১ থেকে ৩ আলিফ নরম সুরে টেনে পড়তে হয়।',
        'letters': ['وْ', 'يْ'],
        'words': ['خَوْفٍ', 'بَيْتٍ', 'الصَّيْفِ', 'قُرَيْشٍ', 'عَيْنَيْنِ', 'شَيْءٍ', 'يَوْمِ', 'سَوْءَةَ', 'الْغَيْبِ', 'خَيْرٌ'],
        'contrasts': ['قَالَ', 'قِيلَ', 'نُوحِيهَا', 'فِيهَا', 'يَقُولُ', 'تَجْرِي'],
        'pairs': {'خَوْفٍ': 'بَيْتٍ', 'الصَّيْفِ': 'قُرَيْشٍ', 'قَالَ': 'قِيلَ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'خَوْ'), ActivityTile(id: '2', label: '2', arabicLabel: 'فٍ')],
        'blank': 'خَ___فٍ',
        'blankOpts': ['وْ', 'ا', 'ي'],
      },
      {
        'id': 'madd_4_aridi',
        'name': '৪. মাদ্দে আরিদী',
        'sub': '৩ আলিফ টান · ওয়াকফের কারণে সাকিন',
        'sym': 'الْعَالَمِينَ',
        'desc': 'মাদ্দের হরফের পরের হরফে ওয়াকফের (থামার) কারণে অস্থায়ী সাকিন তৈরি হলে তাকে মাদ্দে আরিদী বলে। একে ৩ আলিফ পরিমাণ টেনে পড়তে হয়।',
        'letters': ['ـينَ', 'ـونَ', 'ـيمُ'],
        'words': ['الْعَالَمِينَ', 'الرَّحِيمِ', 'الدِّينِ', 'نَسْتَعِينُ', 'الْمُسْتَقِيمَ', 'الْمُفْلِحُونَ', 'يَعْلَمُونَ', 'خَالِدُونَ', 'عَظِيمٌ', 'كَرِيمٌ'],
        'contrasts': ['قَالَ', 'فِيهَا', 'نُوحِيهَا', 'قَلَّ', 'كَتَبَ', 'شَرِبَ'],
        'pairs': {'الْعَالَمِينَ': 'الرَّحِيمِ', 'الدِّينِ': 'نَسْتَعِينُ', 'قَالَ': 'فِيهَا'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'الْعَا'), ActivityTile(id: '2', label: '2', arabicLabel: 'لَ'), ActivityTile(id: '3', label: '3', arabicLabel: 'مِينَ')],
        'blank': 'الْعَالَ___',
        'blankOpts': ['مِينَ', 'مَ', 'مُ'],
      },
      {
        'id': 'madd_5_munfasil',
        'name': '৫. মাদ্দে মুনফাসিল',
        'sub': '৩ আলিফ টান · পৃথক শব্দে হামযা',
        'sym': 'فِي أَنفُسِكُمْ',
        'desc': 'মাদ্দের হরফ এক শব্দের শেষে এবং হামযা (ء) পরবর্তী শব্দের শুরুতে আসলে তাকে মাদ্দে মুনফাসিল বলে। একে ৩ আলিফ পরিমাণ টেনে পড়তে হয়।',
        'letters': ['يَا أَيُّـ', 'فِي أَ', 'قُولُوا آ'],
        'words': ['فِي أَنفُسِكُمْ', 'يَا أَيُّهَا', 'إِنَّا أَعْطَيْنَاكَ', 'قُولُوا آمَنَّا', 'بِمَا أُنزِلَ', 'إِلَىٰ أَهْلِهِ', 'تُوبُوا إِلَى اللَّهِ', 'إِنَّمَا أَمْرُهُ', 'عَلَىٰ أَنفُسِهِمْ', 'وَمَا أَدْرَاكَ'],
        'contrasts': ['جَاءَ', 'سُوءَ', 'السَّمَاءِ', 'قَالَ', 'فِيهَا', 'نُوحِيهَا'],
        'pairs': {'فِي أَنفُسِكُمْ': 'يَا أَيُّهَا', 'إِنَّا أَعْطَيْنَاكَ': 'قُولُوا آمَنَّا', 'جَاءَ': 'سُوءَ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'فِي'), ActivityTile(id: '2', label: '2', arabicLabel: 'أَنفُسِكُمْ')],
        'blank': 'فِي ___نفُسِكُمْ',
        'blankOpts': ['أَ', 'عَ', 'هَ'],
      },
      {
        'id': 'madd_6_harfi_mukh',
        'name': '৬. মাদ্দে লাযিম হরফী মুখাফফাফ',
        'sub': '৪ আলিফ টান · মুকাত্তা’আত হরফে হালকা সাকিন',
        'sym': 'ص  ق  ن',
        'desc': 'হুরুফে মুকাত্তা’আতের মধ্যে মাদ্দের হরফের পর এমন সাকিন আসলে যা পরবর্তীতে তাশদীদযুক্ত নয়, তাকে হরফী মুখাফফাফ বলে। ৪ আলিফ টেনে পড়তে হয়।',
        'letters': ['ص', 'ق', 'ن', 'يس', 'حم'],
        'words': ['صٓ', 'قٓ', 'نٓ', 'يٰسٓ', 'حٰمٓ', 'طٰسٓ', 'الٓرٰ', 'طٰهٰ', 'الٓمٰرٰ', 'ক্বাফ'],
        'contrasts': ['الٓمٓ', 'طٰسٓمٓ', 'الٓمٓصٓ', 'جَاءَ', 'قَالَ', 'فِيهَا'],
        'pairs': {'صٓ': 'قٓ', 'نٓ': 'يٰسٓ', 'الٓمٓ': 'طٰسٓمٓ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'صٓ'), ActivityTile(id: '2', label: '2', arabicLabel: 'وَالْقُرْآنِ')],
        'blank': '___ٓ وَالْقُرْآنِ',
        'blankOpts': ['ص', 'ب', 'ت'],
      },
      {
        'id': 'madd_7_harfi_mush',
        'name': '৭. মাদ্দে লাযিম হরফী মুসাক্কাল',
        'sub': '৪ আলিফ টান · মুকাত্তা’আত হরফে ভারী তাশদীদ',
        'sym': 'الٓمٓ',
        'desc': 'হুরুফে মুকাত্তা’আতের মধ্যে মাদ্দের পর ইদগামের কারণে তাশদীদ হলে তাকে হরফী মুসাক্কাল বলে। পূর্ণ ৪ আলিফ ভারী টেনে পড়তে হয়।',
        'letters': ['الٓمٓ', 'طٰسٓمٓ', 'الٓمٓصٓ'],
        'words': ['الٓمٓ', 'طٰسٓمٓ', 'الٓمٓصٓ', 'الٓمٓرٰ', 'ক্বাফ তাশদীদ', 'লাম-মীম', 'মুকাত্তা’আত', 'ভারী মাদ্দ', '৪ আলিফ লাযিম', 'তাশদীদযুক্ত'],
        'contrasts': ['صٓ', 'قٓ', 'نٓ', 'يٰسٓ', 'جَاءَ', 'قَالَ'],
        'pairs': {'الٓمٓ': 'طٰسٓمٓ', 'الٓمٓصٓ': 'الٓمٓرٰ', 'صٓ': 'قٓ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'الٓ'), ActivityTile(id: '2', label: '2', arabicLabel: 'مٓ')],
        'blank': 'الٓ___ٓ',
        'blankOpts': ['م', 'ب', 'د'],
      },
      {
        'id': 'madd_8_kalimi_mukh',
        'name': '৮. মাদ্দে লাযিম কালিমী মুখাফফাফ',
        'sub': '৪ আলিফ টান · শব্দে মাদ্দের পর আসল সাকিন',
        'sym': 'ءَآلْآنَ',
        'desc': 'একই শব্দের ভেতরে মাদ্দের হরফের পর আসল সাকিন (জযম) আসলে তাকে কালিমী মুখাফফাফ বলে। কুরআনে এটি “ءَآلْآنَ” শব্দে রয়েছে এবং ৪ আলিফ টানতে হয়।',
        'letters': ['ءَآلْ'],
        'words': ['ءَآلْآنَ', 'ءَآلذَّكَرَيْنِ', 'ءَآللَّهُ', 'ءَآلْآنَ وَقَدْ', 'ءَآلْآنَ عَصَيْتَ', 'কালিমী ১', 'কালিমী ২', 'মুখাফফাফ', 'আসল সাকিন', '৪ আলিফ টান'],
        'contrasts': ['الضَّالِّينَ', 'الْحَاقَّةُ', 'جَاءَ', 'فِي أَنفُسِكُمْ', 'قَالَ', 'خَوْفٍ'],
        'pairs': {'ءَآلْآنَ': 'ءَآلذَّكَرَيْنِ', 'ءَآللَّهُ': 'ءَآلْآنَ', 'الضَّالِّينَ': 'الْحَاقَّةُ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'ءَآلْ'), ActivityTile(id: '2', label: '2', arabicLabel: 'آنَ')],
        'blank': '___آنَ',
        'blankOpts': ['ءَآلْ', 'أَلْ', 'إِلْ'],
      },
      {
        'id': 'madd_9_kalimi_mush',
        'name': '৯. মাদ্দে লাযিম কালিমী মুসাক্কাল',
        'sub': '৪ আলিফ টান · শব্দে মাদ্দের পর তাশদীদ',
        'sym': 'الضَّالِّينَ',
        'desc': 'একই শব্দের ভেতরে মাদ্দের হরফের পর তাশদীদযুক্ত হরফ আসলে তাকে কালিমী মুসাক্কাল বলে। একে পূর্ণ ৪ আলিফ ভারী সুরে টেনে পড়তে হয়।',
        'letters': ['ـَّ', 'ـِّ', 'ـُّ'],
        'words': ['الضَّالِّينَ', 'الْحَاقَّةُ', 'الصَّاخَّةُ', 'الطَّامَّةُ', 'دَابَّةٍ', 'تَأْمُرُونِّي', 'يُحَاجُّونَكَ', 'جَانٌّ', 'حَاجَّهُ', 'صَوَافَّ'],
        'contrasts': ['جَاءَ', 'فِي أَنفُسِكُمْ', 'قَالَ', 'خَوْفٍ', 'الْعَالَمِينَ', 'ءَامَنَ'],
        'pairs': {'الضَّالِّينَ': 'الْحَاقَّةُ', 'الصَّاخَّةُ': 'الطَّامَّةُ', 'جَاءَ': 'فِي أَنفُسِكُمْ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'الضَّا'), ActivityTile(id: '2', label: '2', arabicLabel: 'لِّينَ')],
        'blank': 'الضَّা___ِّينَ',
        'blankOpts': ['ل', 'م', 'ت'],
      },
      {
        'id': 'madd_10_muttasil',
        'name': '১০. মাদ্দে মুত্তাসিল',
        'sub': '৪ আলিফ টান · একই শব্দে হামযা',
        'sym': 'جَاءَ  سُوءَ',
        'desc': 'একই শব্দের ভেতরে মাদ্দের হরফের ঠিক পরেই হামযা (ء) আসলে তাকে মাদ্দে মুত্তাসিল বলে। একে ওয়াজিবভাবে ৪ আলিফ পরিমাণ টেনে পড়তে হয়।',
        'letters': ['ـَاءَ', 'ـِيءَ', 'ـُوءَ'],
        'words': ['جَاءَ', 'سُوءَ', 'السَّمَاءِ', 'هَنِيئًا', 'مَرِيئًا', 'جِيءَ', 'سِيئَتْ', 'أُولَٰئِكَ', 'شَاءَ', 'الصَّاخَّةُ'],
        'contrasts': ['فِي أَنفُسِكُمْ', 'يَا أَيُّهَا', 'قَالَ', 'خَوْفٍ', 'الْعَالَمِينَ', 'ءَامَنَ'],
        'pairs': {'جَاءَ': 'سُوءَ', 'السَّمَاءِ': 'هَنِيئًا', 'فِي أَنفُسِكُمْ': 'يَا أَيُّهَا'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'جَا'), ActivityTile(id: '2', label: '2', arabicLabel: 'ءَ')],
        'blank': 'جَا___',
        'blankOpts': ['ءَ', 'عَ', 'هَ'],
      },
    ];

    return definitions.map((d) {
      final words = d['words'] as List<String>;
      final contrasts = d['contrasts'] as List<String>;
      final letters = d['letters'] as List<String>;
      return QaidaLessonInfo(
        id: d['id'] as String,
        trackId: 'track_4_madd',
        lessonNumber: definitions.indexOf(d) + 1,
        title: d['name'] as String,
        subtitle: d['sub'] as String,
        arabicDisplay: d['sym'] as String,
        description: d['desc'] as String,
        ruleSummary: d['desc'] as String,
        ruleLetters: letters,
        exampleWords: words.take(4).toList(),
        activities: _buildTajweed10StepLesson(
          lessonId: d['id'] as String,
          topicName: d['name'] as String,
          ruleDescription: d['desc'] as String,
          practiceWords: words,
          contrastWords: contrasts,
          ruleLetters: letters,
          matchPairs: d['pairs'] as Map<String, String>,
          arrangeTiles: d['tiles'] as List<ActivityTile>,
          blankWord: d['blank'] as String,
          blankOptions: d['blankOpts'] as List<String>,
          blankCorrectIndex: 0,
        ),
      );
    }).toList();
  }

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
    lessons: _generateTrack5Lessons(),
  );

  static List<QaidaLessonInfo> _generateTrack5Lessons() {
    final definitions = [
      {
        'id': 'ghunnah_1_wajib',
        'name': '১. ওয়াজিব গুন্নাহ',
        'sub': 'নূন ও মীম তাশদীদ · ১ আলিফ গুন্নাহ',
        'sym': 'إِنَّ  عَمَّ',
        'desc': 'হরকতযুক্ত হরফের পর নূন (نّ) বা মীম (مّ) এ তাশদীদ থাকলে ওয়াজিবভাবে ১ আলিফ গুন্নাহ করে পড়তে হয়। একে ওয়াজিব গুন্নাহ বলে।',
        'letters': ['نّ', 'مّ'],
        'words': ['إِنَّ', 'عَمَّ', 'النَّاسِ', 'ثُمَّ', 'جَنَّاتٍ', 'مِمَّا', 'إِنَّمَا', 'الْجِنَّةِ', 'مُحَمَّدٌ', 'كَأَنَّهُمْ'],
        'contrasts': ['رَبَّنَا', 'الصَّلَاةَ', 'الَّذِينَ', 'وَالصَّابِرِينَ', 'كُلَّ', 'الرَّحْمَٰنِ'],
        'pairs': {'إِنَّ': 'النَّاسِ', 'ثُمَّ': 'عَمَّ', 'رَبَّنَا': 'الصَّلَاةَ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'إِنَّ'), ActivityTile(id: '2', label: '2', arabicLabel: 'مَا')],
        'blank': 'إِ___َّ',
        'blankOpts': ['ن', 'ل', 'ر'],
      },
      {
        'id': 'ghunnah_2_izhar',
        'name': '২. ইযহার (স্পষ্ট পড়া)',
        'sub': 'হলক্বী ৬ হরফ · গুন্নাহ ছাড়া স্পষ্ট',
        'sym': 'مَنْ ءَامَنَ',
        'desc': 'নূন সাকিন (نْ) বা তানভীন (ً ٍ ٌ)-এর পর হলক্বী ৬ হরফ (ء ه ع ح غ خ) আসলে কোনো গুন্নাহ ছাড়া স্পষ্ট করে পড়তে হয়।',
        'letters': ['ء', 'ه', 'ع', 'ح', 'غ', 'خ'],
        'words': ['مَنْ ءَامَنَ', 'عَنْهُ', 'مِنْ حَكِيمٍ', 'أَنْعَمْتَ', 'فَرِيقًا هَدَى', 'مِنْ خَوْفٍ', 'مِنْ عِلْمٍ', 'سَلَامٌ هِيَ', 'عَذَابٌ أَلِيمٌ', 'غَفُورٌ حَلِيمٌ'],
        'contrasts': ['أَنتُمْ', 'مِن قَبْلُ', 'مَن يَقُولُ', 'مِّن رَّبِّهِمْ', 'مِنۢ بَعْدِ', 'خَيْرًا يَرَهُ'],
        'pairs': {'مَنْ ءَامَنَ': 'عَنْهُ', 'مِنْ حَكِيمٍ': 'أَنْعَمْتَ', 'أَنتُمْ': 'مِن قَبْلُ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'مَنْ'), ActivityTile(id: '2', label: '2', arabicLabel: 'ءَامَنَ')],
        'blank': 'مِنْ ___َوْفٍ',
        'blankOpts': ['خ', 'ت', 'ي'],
      },
      {
        'id': 'ghunnah_3_idgham_ghunnah',
        'name': '৩. ইদগামে বাগুন্নাহ',
        'sub': 'গুন্নাহসহ মেলানো (ي ن م و)',
        'sym': 'مَن يَقُولُ',
        'desc': 'নূন সাকিন বা তানভীনের পর ইদগামে বাগুন্নাহর ৪টি হরফ (ي ن م و - ইয়ানমূ) আসলে মিলিয়ে ১ আলিফ গুন্নাহসহ পড়তে হয়।',
        'letters': ['ي', 'ن', 'م', 'و'],
        'words': ['مَن يَقُولُ', 'مِن مَّالٍ', 'مِن وَالٍ', 'مِّن نِّعْمَةٍ', 'خَيْرًا يَرَهُ', 'يَوْمَئِذٍ نَّاعِمَةٌ', 'مِن مَّسَدٍ', 'لَهَبٍ وَتَبَّ', 'أَمْشَاجٍ نَّبْتَلِيهِ', 'وُجُوهٌ يَوْمَئِذٍ'],
        'contrasts': ['مِّن رَّبِّهِمْ', 'مِن لَّدُنْهُ', 'مَنْ ءَامَنَ', 'عَنْهُ', 'أَنتُمْ', 'مِنۢ بَعْدِ'],
        'pairs': {'مَن يَقُولُ': 'مِن مَّالٍ', 'مِن وَالٍ': 'مِّن نِّعْمَةٍ', 'مِّن رَّبِّهِمْ': 'مِن لَّدُنْهُ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'مَن'), ActivityTile(id: '2', label: '2', arabicLabel: 'يَقُولُ')],
        'blank': 'مَن ___َقُولُ',
        'blankOpts': ['ي', 'ل', 'ح'],
      },
      {
        'id': 'ghunnah_4_idgham_bila',
        'name': '৪. ইদগামে বেলাগুন্নাহ',
        'sub': 'গুন্নাহ ছাড়া মেলানো (ل ও ر)',
        'sym': 'مِّن رَّبِّهِمْ',
        'desc': 'নূন সাকিন বা তানভীনের পর লাম (ل) বা রা (ر) আসলে কোনো গুন্নাহ ছাড়া সরাসরি মিলিয়ে পড়তে হয়।',
        'letters': ['ل', 'ر'],
        'words': ['مِّن رَّبِّهِمْ', 'مِن لَّدُنْهُ', 'غَفُورٌ رَّحِيمٌ', 'هُدًى لِّلْمُتَّقِينَ', 'وَيْلٌ لِّكُلِّ', 'رَّحْمَةً مِّن رَّبِّكَ', 'عِيشَةٍ رَّاضِيَةٍ', 'مَالًا لُّبَدًا', 'لَّطِيفًا خَبِيرًا', 'خَيْرٌ لَّكُمْ'],
        'contrasts': ['مَن يَقُولُ', 'مِن مَّالٍ', 'مَنْ ءَامَنَ', 'عَنْهُ', 'أَنتُمْ', 'مِن قَبْلُ'],
        'pairs': {'مِّن رَّبِّهِمْ': 'مِن لَّدُنْهُ', 'غَفُورٌ رَّحِيمٌ': 'هُدًى لِّلْمُتَّقِينَ', 'مَن يَقُولُ': 'مِن مَّالٍ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'مِّن'), ActivityTile(id: '2', label: '2', arabicLabel: 'رَّبِّهِمْ')],
        'blank': 'مِّن ___َّبِّهِمْ',
        'blankOpts': ['ر', 'ي', 'ه'],
      },
      {
        'id': 'ghunnah_5_iqlab',
        'name': '৫. ইক্বলাব (পরিবর্তন)',
        'sub': 'বা (ب) আসলে মীম দিয়ে গুন্নাহ',
        'sym': 'مِنۢ بَعْدِ',
        'desc': 'নূন সাকিন বা তানভীনের পর একমাত্র হরফ বা (ب) আসলে নূন সাকিনকে ছোট মীম (ۢ) দ্বারা পরিবর্তন করে ১ আলিফ গুন্নাহ করে পড়তে হয়।',
        'letters': ['ب'],
        'words': ['مِنۢ بَعْدِ', 'أَنۢبِئْهُم', 'عَلِيمٌۢ بِذَاتِ', 'کِرَامٍۢ بَرَرَةٍ', 'سَمِيعٌۢ بَصِيرٌ', 'أَنۢبَتَتْ', 'ذَنۢبٍ', 'مِنۢ بَيْنِ', 'خَبِيرٌۢ بِمَا', 'مَنۢ بَخِلَ'],
        'contrasts': ['أَنتُمْ', 'مَنْ ءَامَنَ', 'مَن يَقُولُ', 'مِّن رَّبِّهِمْ', 'عَنْهُ', 'مِن قَبْلُ'],
        'pairs': {'مِنۢ بَعْدِ': 'أَنۢبِئْهُم', 'عَلِيمٌۢ بِذَاتِ': 'سَمِيعٌۢ بَصِيرٌ', 'مَنْ ءَامَنَ': 'عَنْهُ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'مِنۢ'), ActivityTile(id: '2', label: '2', arabicLabel: 'بَعْدِ')],
        'blank': 'مِنۢ ___َعْدِ',
        'blankOpts': ['ب', 'ت', 'ي'],
      },
      {
        'id': 'ghunnah_6_ikhfa',
        'name': '৬. ইখফা (গোপন করে পড়া)',
        'sub': '১৫টি হরফে নাকের বাঁশিতে লুকানো',
        'sym': 'أَنتُمْ',
        'desc': 'নূন সাকিন বা তানভীনের পর ইখফার ১৫টি হরফের (ت ث ج د ذ ز س ش ص ض ط ظ ف ق ك) যেকোনো একটি আসলে নূন বা তানভীনকে নাকের বাঁশিতে লুকিয়ে ১ আলিফ গুন্নাহসহ পড়তে হয়।',
        'letters': ['ت', 'ث', 'ج', 'د', 'ذ', 'ز', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ف', 'ق', 'ك'],
        'words': ['أَنتُمْ', 'مِن قَبْلُ', 'مَن ذَا الَّذِي', 'عَن سَبِيلِهِ', 'كِتَابٌ كَرِيمٌ', 'يَنتَهُوا', 'أَنزَلْنَا', 'مِن طِينٍ', 'إِنسَانٌ', 'مِن فَضْلِهِ'],
        'contrasts': ['مَنْ ءَامَنَ', 'عَنْهُ', 'مَن يَقُولُ', 'مِّن رَّبِّهِمْ', 'مِنۢ بَعْدِ', 'خَيْرًا يَرَهُ'],
        'pairs': {'أَنتُمْ': 'مِن قَبْلُ', 'عَن سَبِيلِهِ': 'كِتَابٌ كَرِيمٌ', 'مَنْ ءَامَنَ': 'عَنْهُ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'مِن'), ActivityTile(id: '2', label: '2', arabicLabel: 'قَبْلُ')],
        'blank': 'أَن___ُمْ',
        'blankOpts': ['ت', 'ع', 'ل'],
      },
      {
        'id': 'ghunnah_7_meem_ikhfa',
        'name': '৭. মীম সাকিন - ইখফায়ে শাফাবী',
        'sub': 'মীম সাকিনের পর বা (ب) · ঠোঁট মিলিয়ে গুন্নাহ',
        'sym': 'تَرْمِيهِم بِحِجَارَةٍ',
        'desc': 'মীম সাকিন (مْ)-এর পর একমাত্র হরফ বা (ب) আসলে ঠোঁট আলতো মিলিয়ে ১ আলিফ গুন্নাহ সহকারে গোপন করে পড়তে হয়।',
        'letters': ['ب'],
        'words': ['تَرْمِيهِم بِحِجَارَةٍ', 'يَعْتَصِم بِاللَّهِ', 'أَنفُسَهُم بِأَنَّ', 'فَاحْكُم بَيْنَهُم', 'إِلَيْكُم بِهَدِيَّةٍ', 'وَهُم بِالْآخِرَةِ', 'عَلَيْهِم بِوَكِيلٍ', 'جِئْتُكُم بِآيَةٍ', 'أَنبَأَهُم بِأَسْمَائِهِمْ', 'رَبُّهُم بِهِمْ'],
        'contrasts': ['لَهُم مَّثَلًا', 'أَلَمْ تَرَ', 'عَلَيْهِمْ وَلَا', 'أَنْتُمْ', 'عَنْهُمْ', 'أَمْوَالُكُمْ'],
        'pairs': {'تَرْمِيهِم بِحِجَارَةٍ': 'يَعْتَصِم بِاللَّهِ', 'فَاحْكُم بَيْنَهُم': 'وَهُم بِالْآخِرَةِ', 'أَلَمْ تَرَ': 'عَلَيْهِمْ وَلَا'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'تَرْمِيهِم'), ActivityTile(id: '2', label: '2', arabicLabel: 'بِحِجَارَةٍ')],
        'blank': 'تَرْمِيهِم ___ِحِجَارَةٍ',
        'blankOpts': ['ب', 'م', 'و'],
      },
      {
        'id': 'ghunnah_8_meem_idgham',
        'name': '৮. মীম সাকিন - ইদগামে শাফাবী',
        'sub': 'মীম সাকিনের পর মীম (م) · মিলিয়ে গুন্নাহ',
        'sym': 'لَهُم مَّا',
        'desc': 'মীম সাকিনের পর আরেকটি মীম (م) আসলে উভয় মীম মিলিয়ে তাশদীদ দিয়ে ১ আলিফ গুন্নাহসহ পড়তে হয়।',
        'letters': ['م'],
        'words': ['لَهُم مَّا', 'أَطْعَمَهُم مِّن', 'عَلَيْهِم مُّؤْصَدَةٌ', 'فِي قُلُوبِهِم مَّرَضٌ', 'كُنتُم مُّؤْمِنِينَ', 'أَم مَّنْ', 'خَلَقَكُم مِّن', 'لَّكُم مَّا', 'مِّنْهُم مَّن', 'وَلَكُم مَّا'],
        'contrasts': ['تَرْمِيهِم بِحِجَارَةٍ', 'أَلَمْ تَرَ', 'عَلَيْهِمْ وَلَا', 'أَنْتُمْ', 'عَنْهُمْ', 'أَمْوَالُكُمْ'],
        'pairs': {'لَهُم مَّا': 'أَطْعَمَهُم مِّن', 'عَلَيْهِم مُّؤْصَدَةٌ': 'كُنتُم مُّؤْمِنِينَ', 'تَرْمِيهِم بِحِجَارَةٍ': 'يَعْتَصِم بِاللَّهِ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'لَهُم'), ActivityTile(id: '2', label: '2', arabicLabel: 'مَّا')],
        'blank': 'لَهُم ___َّا',
        'blankOpts': ['م', 'ب', 'ف'],
      },
      {
        'id': 'ghunnah_9_meem_izhar',
        'name': '৯. মীম সাকিন - ইযহারে শাফাবী',
        'sub': 'বা ও মীম ছাড়া বাকি ২৬ হরফে স্পষ্ট',
        'sym': 'أَلَمْ تَرَ',
        'desc': 'মীম সাকিনের পর বা (ب) ও মীম (م) ছাড়া বাকি ২৬ হরফে কোনো গুন্নাহ ছাড়া মীম সাকিন স্পষ্ট করে পড়তে হয়।',
        'letters': ['বাকি ২৬ হরফ'],
        'words': ['أَلَمْ تَرَ', 'هُمْ فِيهَا', 'عَلَيْهِمْ وَلَا', 'أَمْوَالُكُمْ', 'أَنفُسَكُمْ', 'لَعَلَّكُمْ تَتَّقُونَ', 'ذَٰلِكُمْ خَيْرٌ', 'أَلَمْ نَشْرَحْ', 'عَلَيْهِمْ طَيْرًا', 'فَمَهِّلْهُمْ'],
        'contrasts': ['تَرْمِيهِم بِحِجَارَةٍ', 'لَهُم مَّا', 'أَطْعَمَهُم مِّن', 'إِنَّ', 'عَمَّ', 'أَنتُمْ'],
        'pairs': {'أَلَمْ تَرَ': 'هُمْ فِيهَا', 'عَلَيْهِمْ وَلَا': 'أَمْوَالُكُمْ', 'تَرْمِيهِم بِحِجَارَةٍ': 'يَعْتَصِم بِاللَّهِ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'أَلَمْ'), ActivityTile(id: '2', label: '2', arabicLabel: 'تَرَ')],
        'blank': 'أَلَمْ ___َرَ',
        'blankOpts': ['ت', 'ب', 'م'],
      },
      {
        'id': 'ghunnah_10_qalqalah',
        'name': '১০. ক্বলক্বলাহ (প্রতিধ্বনি)',
        'sub': '৫টি হরফে সাকিনে ধাক্কা (ق ط ب ج د)',
        'sym': 'قُطْبُ جَدٍّ',
        'desc': 'ক্বলক্বলাহর হরফ ৫টি (ق ط ب ج د - ক্বুতবু জাদ)। এই হরফগুলোতে জযম (সাকিন) হলে উচ্চারণে সজোরে ধাক্কা বা প্রতিধ্বনি সৃষ্টি করে পড়তে হয়।',
        'letters': ['ق', 'ط', 'ب', 'ج', 'د'],
        'words': ['الْفَلَقِ', 'أَحَدٌ', 'مُحِيطٌ', 'يَجْعَلُونَ', 'يَدْخُلُونَ', 'يَقْطَعُونَ', 'أَطْعَمَهُم', 'سُبْحَانَ', 'أَبْصَارِهِمْ', 'وَتَبَّ'],
        'contrasts': ['يَسْتَمِعُونَ', 'يَعْلَمُونَ', 'أَنْتُمْ', 'الْحَمْدُ', 'مَنْ', 'إِنَّ'],
        'pairs': {'الْفَلَقِ': 'أَحَدٌ', 'يَجْعَلُونَ': 'يَدْخُلُونَ', 'يَسْتَمِعُونَ': 'يَعْلَمُونَ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'يَجْ'), ActivityTile(id: '2', label: '2', arabicLabel: 'عَلُونَ')],
        'blank': 'يَ___ْعَلُونَ',
        'blankOpts': ['ج', 'س', 'ن'],
      },
    ];

    return definitions.map((d) {
      final words = d['words'] as List<String>;
      final contrasts = d['contrasts'] as List<String>;
      final letters = d['letters'] as List<String>;
      return QaidaLessonInfo(
        id: d['id'] as String,
        trackId: 'track_5_ghunnah',
        lessonNumber: definitions.indexOf(d) + 1,
        title: d['name'] as String,
        subtitle: d['sub'] as String,
        arabicDisplay: d['sym'] as String,
        description: d['desc'] as String,
        ruleSummary: d['desc'] as String,
        ruleLetters: letters,
        exampleWords: words.take(4).toList(),
        activities: _buildTajweed10StepLesson(
          lessonId: d['id'] as String,
          topicName: d['name'] as String,
          ruleDescription: d['desc'] as String,
          practiceWords: words,
          contrastWords: contrasts,
          ruleLetters: letters,
          matchPairs: d['pairs'] as Map<String, String>,
          arrangeTiles: d['tiles'] as List<ActivityTile>,
          blankWord: d['blank'] as String,
          blankOptions: d['blankOpts'] as List<String>,
          blankCorrectIndex: 0,
        ),
      );
    }).toList();
  }

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
    colorHex: 0xFF10B981, // Emerald Green
    icon: Icons.extension_rounded,
    lessons: List.generate(20, (index) {
      final samples = [
        {'text': 'لا', 'parts': 'ل + ا', 'name': 'লাম-আলিফ', 'tiles': ['ل', 'ا']},
        {'text': 'با', 'parts': 'ب + ا', 'name': 'বা-আলিফ', 'tiles': ['ب', 'ا']},
        {'text': 'تا', 'parts': 'ت + ا', 'name': 'তা-আলিফ', 'tiles': ['ت', 'ا']},
        {'text': 'ثا', 'parts': 'ث + ا', 'name': 'ছা-আলিফ', 'tiles': ['ث', 'ا']},
        {'text': 'بل', 'parts': 'ب + ل', 'name': 'বা-লাম', 'tiles': ['ب', 'ل']},
        {'text': 'تل', 'parts': 'ت + ل', 'name': 'তা-লাম', 'tiles': ['ت', 'ل']},
        {'text': 'ثل', 'parts': 'ث + ل', 'name': 'ছা-লাম', 'tiles': ['ث', 'ل']},
        {'text': 'بج', 'parts': 'ب + ج', 'name': 'বা-জীম', 'tiles': ['ب', 'ج']},
        {'text': 'تح', 'parts': 'ت + ح', 'name': 'তা-হা', 'tiles': ['ت', 'ح']},
        {'text': 'ثخ', 'parts': 'ث + خ', 'name': 'ছা-খা', 'tiles': ['ث', 'خ']},
        {'text': 'يم', 'parts': 'ي + م', 'name': 'ইয়া-মীম', 'tiles': ['ي', 'م']},
        {'text': 'نم', 'parts': 'ن + م', 'name': 'নূন-মীম', 'tiles': ['ن', 'م']},
        {'text': 'تم', 'parts': 'ت + م', 'name': 'তা-মীম', 'tiles': ['ت', 'م']},
        {'text': 'سم', 'parts': 'س + م', 'name': 'সীন-মীম', 'tiles': ['س', 'م']},
        {'text': 'شم', 'parts': 'ش + م', 'name': 'শীন-মীম', 'tiles': ['ش', 'م']},
        {'text': 'صم', 'parts': 'ص + م', 'name': 'সোয়াদ-মীম', 'tiles': ['ص', 'م']},
        {'text': 'ضم', 'parts': 'ض + م', 'name': 'দোয়াদ-মীম', 'tiles': ['ض', 'م']},
        {'text': 'بيت', 'parts': 'ب + ي + ت', 'name': 'বা-ইয়া-তা', 'tiles': ['ب', 'ي', 'ت']},
        {'text': 'نجم', 'parts': 'ن + ج + م', 'name': 'নূন-জীম-মীম', 'tiles': ['ن', 'ج', 'م']},
        {'text': 'شمس', 'parts': 'ش + م + س', 'name': 'শীন-মীম-সীন', 'tiles': ['ش', 'م', 'س']},
      ];
      final item = samples[index % samples.length];
      final itemTiles = (item['tiles'] as List<String>).map((t) => ActivityTile(id: t, label: t, arabicLabel: t)).toList();

      return QaidaLessonInfo(
        id: 'qaida_joined_$index',
        trackId: 'track_6_joined',
        lessonNumber: index + 1,
        title: 'যুক্তাক্ষর: ${item['name']}',
        subtitle: '${item['parts']} = ${item['text']}',
        arabicDisplay: item['text'] as String,
        description: 'হরফ সংযুক্ত করে পড়ার অনুশীলন: ${item['parts']}',
        ruleSummary: 'যুক্তাক্ষর পড়ার সময় মূল হরফগুলোকে পৃথকভাবে চিনে সহীহ উচ্চারণে পাঠ করতে হয়।',
        activities: _buildTajweed10StepLesson(
          lessonId: 'qaida_joined_$index',
          topicName: item['name'] as String,
          ruleDescription: 'হরফ সংযুক্ত করে পড়ার নিয়ম: ${item['parts']}',
          practiceWords: [item['text'] as String, 'بل', 'تل', 'ثل', 'بج', 'تح', 'ثخ', 'يم', 'نم', 'تم'],
          contrastWords: ['لا', 'با', 'تا', 'ثا', 'سم', 'شم'],
          ruleLetters: (item['tiles'] as List<String>),
          matchPairs: {item['text'] as String: 'بل', 'تل': 'ثل', 'بج': 'تح'},
          arrangeTiles: itemTiles,
          blankWord: '${item['text']} = ___',
          blankOptions: [item['text'] as String, 'ب', 'م'],
          blankCorrectIndex: 0,
        ),
      );
    }),
  );

  // -------------------------------------------------------------
  // TRACK 7: 30 Word Reading Lessons (শব্দ পাঠ)
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track7Words = QaidaTrackInfo(
    id: 'track_7_words',
    trackNumber: 7,
    title: 'শব্দ পাঠ',
    subtitle: 'হরকত, সুকুন, তানভীন ও তাশদীদযুক্ত পূর্ণাঙ্গ শব্দ পাঠ',
    arabicTitle: 'قِرَاءَةُ الْكَلِمَاتِ',
    description: 'ছোট ও মাঝারি আরবি শব্দ নির্ভুল মাখরাজ ও তাজবীদে পড়ার পূর্ণাঙ্গ অনুশীলন।',
    colorHex: 0xFF2563EB, // Royal Blue
    icon: Icons.auto_stories_rounded,
    lessons: List.generate(30, (index) {
      final wordsData = [
        {'ar': 'دَرَسَ', 'bn': 'দারাসা (পড়ল)', 'tiles': ['دَ', 'رَ', 'سَ'], 'rule': '৩ হরফের জবর'},
        {'ar': 'كَتَبَ', 'bn': 'কাতাবা (লিখল)', 'tiles': ['كَ', 'تَ', 'بَ'], 'rule': '৩ হরফের জবর'},
        {'ar': 'جَلَسَ', 'bn': 'জালাসা (বসল)', 'tiles': ['جَ', 'لَ', 'سَ'], 'rule': '৩ হরফের জবর'},
        {'ar': 'خَلَقَ', 'bn': 'খালাক্বা (সৃষ্টি করল)', 'tiles': ['خَ', 'لَ', 'قَ'], 'rule': '৩ হরফের জবর'},
        {'ar': 'بَلَغَ', 'bn': 'বালাগা (পৌঁছল)', 'tiles': ['بَ', 'لَ', 'غَ'], 'rule': '৩ হরফের জবর'},
        {'ar': 'سَمِعَ', 'bn': 'সামিআ (শুনল)', 'tiles': ['سَ', 'مِ', 'عَ'], 'rule': 'যের ও জবর'},
        {'ar': 'حَمِدَ', 'bn': 'হামিদা (প্রশংসা করল)', 'tiles': ['حَ', 'مِ', 'دَ'], 'rule': 'যের ও জবর'},
        {'ar': 'فَهِمَ', 'bn': 'ফাহিমা (বুঝল)', 'tiles': ['فَ', 'هِ', 'مَ'], 'rule': 'যের ও জবর'},
        {'ar': 'عَلِمَ', 'bn': 'আলিমা (জানল)', 'tiles': ['عَ', 'لِ', 'مَ'], 'rule': 'যের ও জবর'},
        {'ar': 'غَضِبَ', 'bn': 'গাদিবা (রাগ করল)', 'tiles': ['غَ', 'ضِ', 'بَ'], 'rule': 'যের ও জবর'},
        {'ar': 'كُتِبَ', 'bn': 'কুতিবা (লেখা হলো)', 'tiles': ['كُ', 'تِ', 'بَ'], 'rule': 'পেশ, যের ও জবর'},
        {'ar': 'جُمِعَ', 'bn': 'জুমিআ (একত্রিত হলো)', 'tiles': ['جُ', 'مِ', 'عَ'], 'rule': 'পেশ, যের ও জবর'},
        {'ar': 'رُزِقَ', 'bn': 'রুযিক্বা (রিযিক দেওয়া হলো)', 'tiles': ['رُ', 'زِ', 'قَ'], 'rule': 'পেশ, যের ও জবর'},
        {'ar': 'خُلِقَ', 'bn': 'খুলিক্বা (সৃষ্টি হলো)', 'tiles': ['خُ', 'لِ', 'قَ'], 'rule': 'পেশ, যের ও জবর'},
        {'ar': 'بُعِثَ', 'bn': 'বুইছা (প্রেরিত হলো)', 'tiles': ['بُ', 'عِ', 'ثَ'], 'rule': 'পেশ, যের ও জবর'},
        {'ar': 'أَحْمَدُ', 'bn': 'আহমাদু', 'tiles': ['أَحْ', 'مَ', 'دُ'], 'rule': 'সুকুন / জযম'},
        {'ar': 'يَحْمَدُ', 'bn': 'ইয়াহমাদু', 'tiles': ['يَحْ', 'مَ', 'دُ'], 'rule': 'সুকুন / জযম'},
        {'ar': 'يَكْتُبُ', 'bn': 'ইয়াক্তুবু', 'tiles': ['يَكْ', 'تُ', 'بُ'], 'rule': 'সুকুন / জযম'},
        {'ar': 'يَجْلِسُ', 'bn': 'ইয়াজলিসু', 'tiles': ['يَجْ', 'لِ', 'سُ'], 'rule': 'সুকুন / জযম'},
        {'ar': 'الْحَمْدُ', 'bn': 'আল-হামদু', 'tiles': ['الْ', 'حَمْ', 'دُ'], 'rule': 'সুকুন ও তাশদীদ'},
        {'ar': 'قَالَ', 'bn': 'ক্ব-লা (মাদ্দে তাবি’ঈ)', 'tiles': ['قَا', 'لَ'], 'rule': 'আলিফ মাদ্দ'},
        {'ar': 'قِيلَ', 'bn': 'কী-লা (ইয়া মাদ্দ)', 'tiles': ['قِي', 'لَ'], 'rule': 'ইয়া মাদ্দ'},
        {'ar': 'يَقُولُ', 'bn': 'ইয়াক্বূলু (ওয়াও মাদ্দ)', 'tiles': ['يَ', 'قُو', 'لُ'], 'rule': 'ওয়াও মাদ্দ'},
        {'ar': 'رَبٌّ', 'bn': 'রাব্বুন (তাশদীদ)', 'tiles': ['رَبْ', 'بٌ'], 'rule': 'তাশদীদ ও তানভীন'},
        {'ar': 'كُلٌّ', 'bn': 'কুল্লুন', 'tiles': ['كُلْ', 'لٌ'], 'rule': 'তাশদীদ ও তানভীন'},
        {'ar': 'مُحَمَّدٌ', 'bn': 'মুহাম্মাদুন', 'tiles': ['مُ', 'حَمْ', 'مَ', 'دٌ'], 'rule': 'তাশদীদ ও গুন্নাহ'},
        {'ar': 'جَنَّةٌ', 'bn': 'জান্নাতুন', 'tiles': ['جَنْ', 'نَ', 'ةٌ'], 'rule': 'ওয়াজিব গুন্নাহ'},
        {'ar': 'الْقَمَرُ', 'bn': 'আল-ক্বামারু', 'tiles': ['الْ', 'قَ', 'مَ', 'رُ'], 'rule': 'হরফে ক্বামারিয়্যাহ'},
        {'ar': 'الشَّمْسُ', 'bn': 'আশ-শামসু', 'tiles': ['الشَّ', 'مْ', 'سُ'], 'rule': 'হরফে শামসিয়্যাহ'},
        {'ar': 'الْقُرْآنُ', 'bn': 'আল-কুরআন', 'tiles': ['الْ', 'قُرْ', 'آنُ'], 'rule': 'পূর্ণাঙ্গ শব্দ'},
      ];
      final item = wordsData[index];
      final tiles = (item['tiles'] as List<String>)
          .map((t) => ActivityTile(id: t, label: t, arabicLabel: t))
          .toList();
      final target = item['ar'] as String;
      final others = wordsData
          .map((w) => w['ar'] as String)
          .where((w) => w != target)
          .toList();

      return QaidaLessonInfo(
        id: 'qaida_word_$index',
        trackId: 'track_7_words',
        lessonNumber: index + 1,
        title: 'শব্দ: $target',
        subtitle: '${item['bn']} • ${item['rule']}',
        arabicDisplay: target,
        description: 'আরবি শব্দ পাঠ ও গঠন অনুশীলন: $target',
        ruleSummary: 'হরকত, সুকুন ও মাদ্দ বজায় রেখে শব্দ নির্ভুলভাবে পড়া।',
        activities: _buildTajweed10StepLesson(
          lessonId: 'qaida_word_$index',
          topicName: 'শব্দ পাঠ: $target',
          ruleDescription:
              '${item['rule']} — হরকত ও সুকুন বজায় রেখে শব্দটি সহীহভাবে পাঠ করতে হয়।',
          practiceWords: [
            target,
            others[0 % others.length],
            others[1 % others.length],
            others[2 % others.length],
            others[3 % others.length],
            others[4 % others.length],
            others[5 % others.length],
            others[6 % others.length],
            others[7 % others.length],
            others[8 % others.length],
          ],
          contrastWords: [
            others[9 % others.length],
            others[10 % others.length],
            others[11 % others.length],
            others[12 % others.length],
            others[13 % others.length],
          ],
          ruleLetters: (item['tiles'] as List<String>),
          matchPairs: {
            target: item['bn'] as String,
            others[0 % others.length]: wordsData.firstWhere(
                (w) => w['ar'] == others[0 % others.length])['bn'] as String,
            others[1 % others.length]: wordsData.firstWhere(
                (w) => w['ar'] == others[1 % others.length])['bn'] as String,
          },
          arrangeTiles: tiles,
          blankWord: '$target = ___',
          blankOptions: [
            target,
            others[0 % others.length],
            others[1 % others.length]
          ],
          blankCorrectIndex: 0,
        ),
      );
    }),
  );

  // -------------------------------------------------------------
  // TRACK 8: 40 Sentence & Ayah Reading Lessons (বাক্য ও ধারাবাহিক পাঠ)
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track8Sentences = QaidaTrackInfo(
    id: 'track_8_sentences',
    trackNumber: 8,
    title: 'বাক্য ও আয়াত পাঠ',
    subtitle: 'ধারাবাহিক বাক্য, ছোট ছোট আয়াত ও ওয়াকফের কায়দা',
    arabicTitle: 'قِرَاءَةُ الْجُمَلِ وَالْآيَاتِ',
    description:
        'সংযুক্ত শব্দমালা, পূর্ণাঙ্গ বাক্য ও ছোট ছোট আয়াত সহীহ তাজবীদে পাঠের চূড়ান্ত প্রস্তুতি।',
    colorHex: 0xFFD97706, // Warm Amber
    icon: Icons.menu_book_rounded,
    lessons: List.generate(40, (index) {
      final sentencesData = [
        {'ar': 'بِسْمِ اللَّهِ', 'bn': 'বিসমিল্লাহ', 'rule': 'শুরু করার আদব'},
        {'ar': 'الرَّحْمَٰنِ الرَّحِيمِ', 'bn': 'আর-রহমানির রাহিম', 'rule': 'মাদ্দে আরিদী ও ওয়াকফ'},
        {'ar': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', 'bn': 'আলহামদু লিল্লাহি রাব্বিল আলামিন', 'rule': 'সূরা আল-ফাতিহা ১'},
        {'ar': 'الرَّحْمَٰنِ الرَّحِيمِ', 'bn': 'আর-রহমানির রাহিম', 'rule': 'সূরা আল-ফাতিহা ২'},
        {'ar': 'مَالِكِ يَوْمِ الدِّينِ', 'bn': 'মালিকি ইয়াওমিদ দিন', 'rule': 'সূরা আল-ফাতিহা ৩'},
        {'ar': 'إِيَّاكَ نَعْبُدُ', 'bn': 'ইয়্যাকা নাবুদু', 'rule': 'তাশদীদ ও সুকুন'},
        {'ar': 'وَإِيَّاكَ نَسْتَعِينُ', 'bn': 'ওয়া ইয়্যাকা নাস্তাঈন', 'rule': 'সূরা আল-ফাতিহা ৪'},
        {'ar': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', 'bn': 'ইহদিনাস সিরাতাল মুস্তাকিম', 'rule': 'মোটা হরফ ও ওয়াকফ'},
        {'ar': 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ', 'bn': 'সিরাতাল্লাযিনা আনআমতা আলাইহিম', 'rule': 'ইযহারে হলক্বী'},
        {'ar': 'غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ', 'bn': 'গাইরিল মাগদুবি আলাইহিম', 'rule': 'মাদ্দে লীন ও গাইন'},
        {'ar': 'وَلَا الضَّالِّينَ', 'bn': 'ওয়ালাদ দোয়াল্লিন', 'rule': 'মাদ্দে লাযিম মুসাক্কাল'},
        {'ar': 'قُلْ هُوَ اللَّهُ أَحَدٌ', 'bn': 'কুল হুয়াল্লাহু আহাদ', 'rule': 'সূরা আল-ইখলাস ১'},
        {'ar': 'اللَّهُ الصَّمَدُ', 'bn': 'আল্লাহুস সামাদ', 'rule': 'সূরা আল-ইখলাস ২'},
        {'ar': 'لَمْ يَلِدْ وَلَمْ يُولَدْ', 'bn': 'লাম ইয়ালিদ ওয়া লাম ইউলাদ', 'rule': 'ক্বলক্বলাহর নিয়ম'},
        {'ar': 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ', 'bn': 'ওয়া লাম ইয়াকুল্লাহু কুফুওয়ান আহাদ', 'rule': 'ইদগামে বেলাগুন্নাহ'},
        {'ar': 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ', 'bn': 'কুল আউযু বিরাব্বিল ফালাক্ব', 'rule': 'সূরা আল-ফালাক্ব ১'},
        {'ar': 'مِن شَرِّ مَا خَلَقَ', 'bn': 'মিন শাররি মা খালাক্ব', 'rule': 'ইখফা ও ক্বলক্বলাহ'},
        {'ar': 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ', 'bn': 'ওয়া মিন শাররি গাসিক্বিন ইযা ওয়াক্বাব', 'rule': 'সূরা আল-ফালাক্ব ৩'},
        {'ar': 'وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ', 'bn': 'ওয়া মিন শাররিন নাফ্ফাছাতি ফিল উক্বাদ', 'rule': 'ওয়াজিব গুন্নাহ'},
        {'ar': 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ', 'bn': 'ওয়া মিন শাররি হাসিদিন ইযা হাসাদ', 'rule': 'সূরা আল-ফালাক্ব ৫'},
        {'ar': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ', 'bn': 'কুল আউযু বিরাব্বিন নাস', 'rule': 'সূরা আন-নাস ১'},
        {'ar': 'مَلِكِ النَّاسِ', 'bn': 'মালিকিন নাস', 'rule': 'সূরা আন-নাস ২'},
        {'ar': 'إِلَٰهِ النَّاسِ', 'bn': 'ইলাহিন নাস', 'rule': 'সূরা আন-নাস ৩'},
        {'ar': 'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ', 'bn': 'মিন শাররিল ওয়াসওয়াসিল খান্নাস', 'rule': 'ইখফা ও ওয়াজিব গুন্নাহ'},
        {'ar': 'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ', 'bn': 'আল্লাযী ইউওয়াসউইসু ফী সুদূরিন নাস', 'rule': 'সূরা আন-নাস ৫'},
        {'ar': 'مِنَ الْجِنَّةِ وَالنَّاسِ', 'bn': 'মিনাল জিন্নাতি ওয়ান নাস', 'rule': 'সূরা আন-নাস ৬'},
        {'ar': 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ', 'bn': 'ইন্না আতায়নাকাল কাওছার', 'rule': 'মাদ্দে মুনফাসিল'},
        {'ar': 'فَصَلِّ لِرَبِّكَ وَانْحَرْ', 'bn': 'ফাসাল্লি লিরাব্বিকা ওয়ানহার', 'rule': 'ইযহার ও তাশদীদ'},
        {'ar': 'إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ', 'bn': 'ইন্না শানিয়াকা হুয়াল আবতার', 'rule': 'সূরা আল-কাওছার ৩'},
        {'ar': 'وَالْعَصْرِ', 'bn': 'ওয়াল আসর', 'rule': 'সূরা আল-আসর ১'},
        {'ar': 'إِنَّ الْإِنسَانَ لَفِي خُسْرٍ', 'bn': 'ইন্নাল ইনসানা লাফী খুসর', 'rule': 'ইখফা ও গুন্নাহ'},
        {'ar': 'إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ', 'bn': 'ইল্লাল্লাযিনা আমানু ওয়া আমিলুস সালিহাত', 'rule': 'সূরা আল-আসর ৩ (অংশ ১)'},
        {'ar': 'وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ', 'bn': 'ওয়া তাওয়াসাও বিলহাক্বক্বি ওয়া তাওয়াসাও বিসবর', 'rule': 'সূরা আল-আসর ৩ (অংশ ২)'},
        {'ar': 'أَلَمْ تَرَ كَيْفَ فَعَلَ رَبُّكَ', 'bn': 'আলাম তারা কাইফা ফাআলা রাব্বুকা', 'rule': 'ইযহারে শাফাবী'},
        {'ar': 'بِأَصْحَابِ الْفِيلِ', 'bn': 'বি আসহাবিল ফিল', 'rule': 'সূরা আল-ফীল ১'},
        {'ar': 'أَلَمْ يَجْعَلْ كَيْدَهُمْ فِي تَضْلِيلٍ', 'bn': 'আলাম ইয়াজআল কায়দাহুম ফী তাদলীল', 'rule': 'ক্বলক্বলাহ ও ইযহার'},
        {'ar': 'وَأَرْسَلَ عَلَيْهِمْ طَيْرًا أَبَابِيلَ', 'bn': 'ওয়া আরসালা আলাইহিম তাইরান আবাবিল', 'rule': 'মাদ্দে বদল ও আরিদী'},
        {'ar': 'تَرْمِيهِم بِحِجَارَةٍ مِّن سِجِّيلٍ', 'bn': 'তারমীহিম বিহিজারাতিম মিন সিজ্জিল', 'rule': 'ইখফায়ে শাফাবী ও ইদগাম'},
        {'ar': 'فَجَعَلَهُمْ كَعَصْفٍ مَّأْكُولٍ', 'bn': 'ফাজাআলাহুম কা আসফিম মাকূল', 'rule': 'সূরা আল-ফীল ৫'},
        {'ar': 'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ', 'bn': 'ইযা জাআ নাসরুল্লাহি ওয়াল ফাতহ', 'rule': 'মাদ্দে মুত্তাসিল ও ওয়াকফ'},
      ];
      final item = sentencesData[index];
      final target = item['ar'] as String;
      final others = sentencesData
          .map((s) => s['ar'] as String)
          .where((s) => s != target)
          .toList();

      return QaidaLessonInfo(
        id: 'qaida_sentence_$index',
        trackId: 'track_8_sentences',
        lessonNumber: index + 1,
        title: 'আয়াত: ${item['rule']}',
        subtitle: item['bn'] as String,
        arabicDisplay: target,
        description: 'আয়াত তিলাওয়াত ও ওয়াকফ অনুশীলন: $target',
        ruleSummary: 'ধারাবাহিক বাক্য পাঠ ও ওয়াকফের সঠিক কায়দা।',
        activities: _buildTajweed10StepLesson(
          lessonId: 'qaida_sentence_$index',
          topicName: item['rule'] as String,
          ruleDescription:
              '${item['rule']} — ধারাবাহিক আয়াত পাঠ ও সঠিক ওয়াকফের কায়দা।',
          practiceWords: [
            target,
            others[0 % others.length],
            others[1 % others.length],
            others[2 % others.length],
            others[3 % others.length],
            others[4 % others.length],
            others[5 % others.length],
            others[6 % others.length],
            others[7 % others.length],
            others[8 % others.length],
          ],
          contrastWords: [
            others[9 % others.length],
            others[10 % others.length],
            others[11 % others.length],
            others[12 % others.length],
            others[13 % others.length],
          ],
          ruleLetters: ['ا', 'ل', 'م'],
          matchPairs: {
            target: item['bn'] as String,
            others[0 % others.length]: sentencesData.firstWhere(
                (s) => s['ar'] == others[0 % others.length])['bn'] as String,
            others[1 % others.length]: sentencesData.firstWhere(
                (s) => s['ar'] == others[1 % others.length])['bn'] as String,
          },
          arrangeTiles: [
            ActivityTile(
                id: '1',
                label: '1',
                arabicLabel: target.split(' ').first),
            ActivityTile(
                id: '2',
                label: '2',
                arabicLabel: target.split(' ').length > 1
                    ? target.split(' ')[1]
                    : target),
          ],
          blankWord: '$target ___',
          blankOptions: [target, 'آمِينَ', 'صَدَقَ'],
          blankCorrectIndex: 0,
        ),
      );
    }),
  );

  // -------------------------------------------------------------
  // DEDICATED TAJWEED 10-STEP ACTIVITY BUILDER
  // Uses 10 distinct authentic practice words, genuine contrasting
  // Tajweed rules (Izhar, Idgham, etc.), and ZERO Bangla in options!
  // -------------------------------------------------------------
  static List<QaidaActivity> _buildTajweed10StepLesson({
    required String lessonId,
    required String topicName,
    required String ruleDescription,
    required List<String> practiceWords,
    required List<String> contrastWords,
    required List<String> ruleLetters,
    required Map<String, String> matchPairs,
    required List<ActivityTile> arrangeTiles,
    required String blankWord,
    required List<String> blankOptions,
    required int blankCorrectIndex,
  }) {
    final p = practiceWords;
    final c = contrastWords;

    return [
      // 1. Warm-up / Recall
      QaidaActivity(
        id: '${lessonId}_step1_recall',
        slotNumber: 1,
        type: QaidaActivityType.warmupRecall,
        prompt: 'স্মরণ করি: “$topicName”-এর নিয়ম অনুযায়ী কোন শব্দটি পড়া হয়?',
        arabicTarget: p[0],
        options: [p[0], c[0], c[1 % c.length]],
        correctIndex: 0,
        explanation: 'মাশাআল্লাহ! “${p[0]}” হলো $topicName-এর উদাহরণ।',
        feedbackCorrect: 'মাশাআল্লাহ! নিয়মটি সঠিকভাবে স্মরণ করতে পেরেছ!',
        feedbackIncorrect: 'নিয়মটি আবার লক্ষ্য করো — হরফ ও গুন্নাহ খেয়াল করো।',
        skillId: '${lessonId}_recall',
      ),
      // 2. Recognize
      QaidaActivity(
        id: '${lessonId}_step2_recognize',
        slotNumber: 2,
        type: QaidaActivityType.recognize,
        prompt: 'আজকের পাঠ “$topicName”: নিচের কোনটি এই নিয়মের সঠিক শব্দ?',
        arabicTarget: p[1],
        options: [p[1], c[2 % c.length], c[3 % c.length]],
        correctIndex: 0,
        explanation: 'সঠিক! “${p[1]}” শব্দে $topicName কার্যকর হয়েছে।',
        feedbackCorrect: 'চমৎকার! সঠিক শব্দটি চিনে নিয়েছ!',
        feedbackIncorrect: 'আবার ভাবো — হরকত ও পরের হরফটি মেলাও।',
        skillId: '${lessonId}_recognize',
      ),
      // 3. Listen & Identify
      QaidaActivity(
        id: '${lessonId}_step3_listen',
        slotNumber: 3,
        type: QaidaActivityType.listenAndIdentify,
        prompt: 'উচ্চারণ শুনুন এবং “$topicName”-এর শব্দটি নির্বাচন করুন',
        arabicTarget: p[2],
        options: [p[2], c[1 % c.length], c[4 % c.length]],
        correctIndex: 0,
        explanation: 'মাশাআল্লাহ! শুনে আপনি সঠিক শব্দটি চিহ্নিত করেছেন।',
        feedbackCorrect: 'চমৎকার শ্রবণ দক্ষতা! সহীহ উচ্চারণ চিহ্নিত হয়েছে।',
        feedbackIncorrect: 'উচ্চারণটি আবার মনোযোগ দিয়ে শুনে নির্বাচন করো।',
        skillId: '${lessonId}_listen',
      ),
      // 4. Match Pairs (Pure Arabic)
      QaidaActivity(
        id: '${lessonId}_step4_match',
        slotNumber: 4,
        type: QaidaActivityType.matchPairs,
        prompt: 'একই নিয়মভুক্ত শব্দের জোড়া মিলাও',
        arabicTarget: p[3],
        pairs: matchPairs,
        explanation: 'চমৎকার! প্রতিটি জোড়ায় একই তাজবীদ নিয়ম কার্যকর হয়েছে।',
        feedbackCorrect: 'মাশাআল্লাহ! সব জোড়া সঠিক হয়েছে!',
        feedbackIncorrect: 'একই বিধানের শব্দগুলো আবার মিলিয়ে দেখো।',
        skillId: '${lessonId}_match',
      ),
      // 5. Differentiate (Odd-One-Out)
      QaidaActivity(
        id: '${lessonId}_step5_diff',
        slotNumber: 5,
        type: QaidaActivityType.differentiate,
        prompt: 'পার্থক্য চিহ্নিত করুন: নিচের কোনটি “$topicName”-এর ব্যতিক্রম? (অন্য নিয়ম)',
        arabicTarget: c[0],
        options: [c[0], p[4], p[5]],
        correctIndex: 0,
        explanation: 'খুব ভালো! “${c[0]}” হলো ভিন্ন নিয়ম, এটি $topicName নয়।',
        feedbackCorrect: 'অসাধারণ! আপনি সূক্ষ্ম পার্থক্য ধরতে পেরেছেন।',
        feedbackIncorrect: 'নিয়মটি আবার মনে করে ভিন্ন শব্দটি আলাদা করো।',
        skillId: '${lessonId}_diff',
      ),
      // 6. Build / Arrange (Puzzle Pedestals)
      QaidaActivity(
        id: '${lessonId}_step6_arrange',
        slotNumber: 6,
        type: QaidaActivityType.buildArrange,
        prompt: 'হরফ/অংশগুলো ক্রমানুসারে সাজিয়ে শব্দটি গঠন করো: “${p[6]}”',
        arabicTarget: p[6],
        tiles: arrangeTiles,
        explanation: 'সঠিক গঠন ও ক্রম নিশ্চিত করা হয়েছে: “${p[6]}”।',
        feedbackCorrect: 'মাশাআল্লাহ! সঠিক ক্রমে সাজানো সম্পন্ন হয়েছে!',
        feedbackIncorrect: 'শুরু থেকে শেষ পর্যন্ত ধারাবাহিকতা আবার মেলাও।',
        skillId: '${lessonId}_arrange',
      ),
      // 7. Fill in the Blank
      QaidaActivity(
        id: '${lessonId}_step7_context',
        slotNumber: 7,
        type: QaidaActivityType.fillInBlank,
        prompt: 'শব্দে সঠিক হরফটি বসিয়ে “$topicName” সম্পন্ন করুন',
        blankSentence: blankWord,
        blankOptions: blankOptions,
        blankCorrectIndex: blankCorrectIndex,
        explanation: 'সঠিক! উপযুক্ত হরফটি বসিয়ে বিধান সম্পন্ন হয়েছে।',
        feedbackCorrect: 'চমৎকার! প্রয়োগ সঠিক হয়েছে।',
        feedbackIncorrect: 'এই নিয়মের হরফসমূহ আবার মনে করো।',
        skillId: '${lessonId}_blank',
      ),
      // 8. Apply Rule in Context
      QaidaActivity(
        id: '${lessonId}_step8_rule',
        slotNumber: 8,
        type: QaidaActivityType.applyRule,
        prompt: 'নিয়ম প্রয়োগ: নিচের কোন শব্দে “$topicName” কার্যকর হয়েছে?',
        arabicTarget: p[7],
        options: [p[7], c[2 % c.length], c[5 % c.length]],
        correctIndex: 0,
        explanation: 'নিয়ম: $ruleDescription',
        feedbackCorrect: 'মাশাআল্লাহ! নিয়ম প্রয়োগ সফল হয়েছে।',
        feedbackIncorrect: 'নিয়মটি ভালো করে লক্ষ্য করে উত্তর দিন।',
        skillId: '${lessonId}_rule',
      ),
      // 9. Mixed Practice
      QaidaActivity(
        id: '${lessonId}_step9_mixed',
        slotNumber: 9,
        type: QaidaActivityType.mixedPractice,
        prompt: 'মিশ্র অনুশীলন: বিভিন্ন নিয়মের শব্দ থেকে “$topicName” আলাদা করুন',
        arabicTarget: p[8],
        options: [p[8], c[0], c[3 % c.length]],
        correctIndex: 0,
        explanation: 'মাশাআল্লাহ! আপনি মিশ্র শব্দ থেকে সঠিক বিধান চিনেছেন।',
        feedbackCorrect: 'চমৎকার প্রস্তুতি! মিশ্র যাচাই সফল।',
        feedbackIncorrect: 'হরকত ও সাকিনের পরের হরফ দেখে বাছুন।',
        skillId: '${lessonId}_mixed',
      ),
      // 10. Lesson Check
      QaidaActivity(
        id: '${lessonId}_step10_check',
        slotNumber: 10,
        type: QaidaActivityType.lessonCheck,
        prompt: 'চূড়ান্ত পাঠ যাচাই: “$topicName” এর নির্ভুল উদাহরণটি নিশ্চিত করুন',
        arabicTarget: p[9],
        options: [p[9], c[1 % c.length], c[4 % c.length]],
        correctIndex: 0,
        explanation: 'অভিনন্দন! আপনি “$topicName” পাঠের ১০টি ধাপ সফলভাবে শেষ করেছেন!',
        feedbackCorrect: 'অভিনন্দন! ১০/১০ দক্ষতা অর্জিত হয়েছে!',
        feedbackIncorrect: 'মনোযোগ দিয়ে চূড়ান্ত শব্দটি নির্বাচন করো।',
        skillId: '${lessonId}_check',
      ),
    ];
  }
}
