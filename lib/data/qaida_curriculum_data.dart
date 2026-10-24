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
  // TRACK 1: 28 Hijaiyah Letters 
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track1Letters = QaidaTrackInfo(
    id: 'track_1_letters',
    trackNumber: 1,
    title: 'qaida.track.1.title',
    subtitle: 'qaida.track.1.title',
    arabicTitle: 'حُرُوفُ الْهِجَاءِ',
    description: 'qaida.track.1.desc',
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
        title: 'qaida.track.1.title',
        subtitle: 'qaida.track.1.title',
        arabicDisplay: letter.letter,
        description: 'qaida.track.1.desc',
        audioAsset: audio,
        makhraj: letter.makhraj,
        activities: [
          // 1. Warm-up / Recall
          QaidaActivity(
            id: '${letter.id}_step1_recall',
            slotNumber: 1,
            type: QaidaActivityType.warmupRecall,
            prompt: 'qaida.track.1.act.1.prompt',
            arabicTarget: prevLetter.letter,
            options: [prevLetter.letter, letter.letter, nextLetter.letter],
            correctIndex: 0,
            explanation: 'qaida.track.1.act.1.explanation',
          ),
          // 2. Recognize
          QaidaActivity(
            id: '${letter.id}_step2_recognize',
            slotNumber: 2,
            type: QaidaActivityType.recognize,
            prompt: 'qaida.track.1.act.2.prompt',
            arabicTarget: letter.letter,
            options: [letter.letter, prevLetter.letter, nextLetter.letter],
            correctIndex: 0,
            explanation: 'qaida.track.1.act.2.explanation',
          ),
          // 3. Listen & Identify
          QaidaActivity(
            id: '${letter.id}_step3_listen',
            slotNumber: 3,
            type: QaidaActivityType.listenAndIdentify,
            prompt: 'qaida.track.1.act.3.prompt',
            arabicTarget: letter.letter,
            audioAsset: audio,
            options: [letter.letter, nextLetter.letter, prevLetter.letter],
            correctIndex: 0,
            explanation: 'qaida.track.1.act.3.explanation',
          ),
          // 4. Match Pairs — tap-to-match interactive UI
          QaidaActivity(
            id: '${letter.id}_step4_match',
            slotNumber: 4,
            type: QaidaActivityType.matchPairs,
            prompt: 'qaida.track.1.act.4.prompt',
            pairs: {
              letter.letter: letter.transliteration,
              prevLetter.letter: prevLetter.transliteration,
              nextLetter.letter: nextLetter.transliteration,
            },
            explanation: 'qaida.track.1.act.4.explanation',
            feedbackCorrect: 'qaida.activity.feedback_correct_default',
            feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
            skillId: 'letter_name_\${letter.id}',
            difficulty: QaidaActivityDifficulty.easy,
          ),
          // 5. Differentiate (similar looking)
          QaidaActivity(
            id: '${letter.id}_step5_diff',
            slotNumber: 5,
            type: QaidaActivityType.differentiate,
            prompt: 'qaida.track.1.act.5.prompt',
            arabicTarget: letter.letter,
            options: [letter.letter, similar, 'ا'],
            correctIndex: 0,
            explanation: 'qaida.track.1.act.5.explanation',
          ),
          // 6. Build / Arrange — tile-based ordering
          QaidaActivity(
            id: '${letter.id}_step6_arrange',
            slotNumber: 6,
            type: QaidaActivityType.buildArrange,
            prompt: 'qaida.track.1.act.6.prompt',
            tiles: [
              ActivityTile(id: prevLetter.id, label: prevLetter.transliteration, arabicLabel: prevLetter.letter),
              ActivityTile(id: letter.id, label: letter.transliteration, arabicLabel: letter.letter),
              ActivityTile(id: nextLetter.id, label: nextLetter.transliteration, arabicLabel: nextLetter.letter),
            ],
            explanation: 'qaida.track.1.act.6.explanation',
            feedbackCorrect: 'qaida.activity.feedback_correct_default',
            feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
            skillId: 'letter_order_\${letter.id}',
          ),
          // 7. Read in Context
          QaidaActivity(
            id: '${letter.id}_step7_context',
            slotNumber: 7,
            type: QaidaActivityType.readInContext,
            prompt: 'qaida.track.1.act.7.prompt',
            arabicTarget: 'قَالَ',
            options: [letter.letter, 'ب', 'م'],
            correctIndex: 0,
            explanation: 'qaida.track.1.act.7.explanation',
          ),
          // 8. Apply the Rule
          QaidaActivity(
            id: '${letter.id}_step8_rule',
            slotNumber: 8,
            type: QaidaActivityType.applyRule,
            prompt: 'qaida.track.1.act.8.prompt',
            arabicTarget: letter.letter,
            options: [letter.letter, nextLetter.letter, 'م'],
            correctIndex: 0,
            explanation: 'qaida.track.1.act.8.explanation',
          ),
          // 9. Mixed Practice
          QaidaActivity(
            id: '${letter.id}_step9_mixed',
            slotNumber: 9,
            type: QaidaActivityType.mixedPractice,
            prompt: 'qaida.track.1.act.9.prompt',
            arabicTarget: letter.letter,
            options: [letter.letter, prevLetter.letter, nextLetter.letter],
            correctIndex: 0,
            explanation: 'qaida.track.1.act.9.explanation',
          ),
          // 10. Lesson Check
          QaidaActivity(
            id: '${letter.id}_step10_check',
            slotNumber: 10,
            type: QaidaActivityType.lessonCheck,
            prompt: 'qaida.track.1.act.10.prompt',
            arabicTarget: letter.letter,
            options: [letter.letter, similar, prevLetter.letter],
            correctIndex: 0,
            explanation: 'qaida.track.1.act.10.explanation',
          ),
        ],
      );
    }),
  );

  // -------------------------------------------------------------
  // TRACK 2: 28 Letter Forms (  - , , )
  // -------------------------------------------------------------
  static final List<Map<String, dynamic>> _letterFormsRaw = [
    {'name': 'qaida.track.1.desc', 'iso': 'ا', 'init': 'ا', 'med': 'ـا', 'fin': 'ـا', 'join': false},
    {'name': 'qaida.track.1.desc', 'iso': 'ب', 'init': 'بـ', 'med': 'ـبـ', 'fin': 'qaida.track.1.desc', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ت', 'init': 'تـ', 'med': 'ـتـ', 'fin': 'ـت', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ث', 'init': 'ثـ', 'med': 'ـثـ', 'fin': 'ـث', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ج', 'init': 'جـ', 'med': 'ـجـ', 'fin': 'ـج', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ح', 'init': 'حـ', 'med': 'ـحـ', 'fin': 'ـح', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'خ', 'init': 'خـ', 'med': 'ـخـ', 'fin': 'ـخ', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'د', 'init': 'د', 'med': 'ـد', 'fin': 'ـد', 'join': false},
    {'name': 'qaida.track.1.desc', 'iso': 'ذ', 'init': 'ذ', 'med': 'ـذ', 'fin': 'ـذ', 'join': false},
    {'name': 'qaida.track.1.desc', 'iso': 'ر', 'init': 'ر', 'med': 'ـر', 'fin': 'ـر', 'join': false},
    {'name': 'qaida.track.1.desc', 'iso': 'ز', 'init': 'ز', 'med': 'ـز', 'fin': 'ـز', 'join': false},
    {'name': 'qaida.track.1.desc', 'iso': 'س', 'init': 'سـ', 'med': 'ـسـ', 'fin': 'ـس', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ش', 'init': 'شـ', 'med': 'ـشـ', 'fin': 'ـش', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ص', 'init': 'صـ', 'med': 'ـصـ', 'fin': 'ـص', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ض', 'init': 'ضـ', 'med': 'ـضـ', 'fin': 'ـض', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ط', 'init': 'طـ', 'med': 'ـطـ', 'fin': 'ـط', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ظ', 'init': 'ظـ', 'med': 'ـظـ', 'fin': 'ـظ', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ع', 'init': 'عـ', 'med': 'ـعـ', 'fin': 'ـع', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'غ', 'init': 'غـ', 'med': 'ـغـ', 'fin': 'ـغ', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ف', 'init': 'فـ', 'med': 'ـفـ', 'fin': 'ـف', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ق', 'init': 'قـ', 'med': 'ـقـ', 'fin': 'ـق', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ك', 'init': 'كـ', 'med': 'ـكـ', 'fin': 'ـك', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ل', 'init': 'لـ', 'med': 'ـلـ', 'fin': 'ـل', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'م', 'init': 'مـ', 'med': 'ـمـ', 'fin': 'ـم', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ن', 'init': 'نـ', 'med': 'ـنـ', 'fin': 'ـن', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'و', 'init': 'و', 'med': 'ـو', 'fin': 'ـو', 'join': false},
    {'name': 'qaida.track.1.desc', 'iso': 'ه', 'init': 'هـ', 'med': 'ـهـ', 'fin': 'ـه', 'join': true},
    {'name': 'qaida.track.1.desc', 'iso': 'ي', 'init': 'يـ', 'med': 'ـيـ', 'fin': 'ـي', 'join': true},
  ];

  static final QaidaTrackInfo _track2Forms = QaidaTrackInfo(
    id: 'track_2_forms',
    trackNumber: 2,
    title: 'qaida.track.2.title',
    subtitle: 'qaida.track.2.title',
    arabicTitle: 'أَشْكَالُ الْحُرُوفِ',
    description: 'qaida.track.2.desc',
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
        title: 'qaida.track.2.title',
        subtitle: 'qaida.track.2.title',
        arabicDisplay: '$init  $med  $fin',
        description: 'qaida.track.2.desc',
        ruleSummary: joins
            ? 'qaida.track.2.desc'
            : 'qaida.track.2.desc',
        activities: [
          // 1. Recall
          QaidaActivity(
            id: 'form_${index}_step1_recall',
            slotNumber: 1,
            type: QaidaActivityType.warmupRecall,
            prompt: 'qaida.track.2.act.1.prompt',
            arabicTarget: iso,
            options: [iso, 'د', 'ر'],
            correctIndex: 0,
            explanation: 'qaida.track.2.act.1.explanation',
          ),
          // 2. Recognize
          QaidaActivity(
            id: 'form_${index}_step2_recognize',
            slotNumber: 2,
            type: QaidaActivityType.recognize,
            prompt: 'qaida.track.2.act.2.prompt',
            arabicTarget: init,
            options: [init, med, fin],
            correctIndex: 0,
            explanation: 'qaida.track.2.act.2.explanation',
          ),
          // 3. Listen & Identify
          QaidaActivity(
            id: 'form_${index}_step3_listen',
            slotNumber: 3,
            type: QaidaActivityType.listenAndIdentify,
            prompt: 'qaida.track.2.act.3.prompt',
            arabicTarget: med,
            options: [med, init, fin],
            correctIndex: 0,
            explanation: 'qaida.track.2.act.3.explanation',
          ),
          // 4. Match Pairs
          QaidaActivity(
            id: 'form_${index}_step4_match',
            slotNumber: 4,
            type: QaidaActivityType.matchPairs,
            prompt: 'qaida.track.2.act.4.prompt',
            arabicTarget: fin,
            pairs: {
              init: med,
              iso: fin,
            },
            explanation: 'qaida.track.2.act.4.explanation',
            feedbackCorrect: 'qaida.activity.feedback_correct_default',
            feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
          ),
          // 5. Differentiate
          QaidaActivity(
            id: 'form_${index}_step5_diff',
            slotNumber: 5,
            type: QaidaActivityType.differentiate,
            prompt: 'qaida.track.2.act.5.prompt',
            arabicTarget: init,
            options: [init, fin, iso],
            correctIndex: 0,
            explanation: 'qaida.track.2.act.5.explanation',
          ),
          // 6. Build / Arrange
          QaidaActivity(
            id: 'form_${index}_step6_arrange',
            slotNumber: 6,
            type: QaidaActivityType.buildArrange,
            prompt: 'qaida.track.2.act.6.prompt',
            arabicTarget: '$init  $med  $fin',
            tiles: [
              ActivityTile(id: '1', label: '1', arabicLabel: init),
              ActivityTile(id: '2', label: '2', arabicLabel: med),
              ActivityTile(id: '3', label: '3', arabicLabel: fin),
            ],
            explanation: 'qaida.track.2.act.6.explanation',
            feedbackCorrect: 'qaida.activity.feedback_correct_default',
            feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
          ),
          // 7. Read in Context
          QaidaActivity(
            id: 'form_${index}_step7_context',
            slotNumber: 7,
            type: QaidaActivityType.readInContext,
            prompt: 'qaida.track.2.act.7.prompt',
            arabicTarget: '$initـت',
            options: [iso, 'س', 'م'],
            correctIndex: 0,
            explanation: 'qaida.track.2.act.7.explanation',
          ),
          // 8. Apply Rule
          QaidaActivity(
            id: 'form_${index}_step8_rule',
            slotNumber: 8,
            type: QaidaActivityType.applyRule,
            prompt: joins
                ? 'qaida.track.2.desc'
                : 'qaida.track.2.desc',
            arabicTarget: iso,
            options: joins
                ? ['ـ$isoـ', iso]
                : [iso, 'ـ$isoـ'],
            correctIndex: 0,
            explanation: joins
                ? 'qaida.track.2.desc'
                : 'qaida.track.2.desc',
          ),
          // 9. Mixed Practice
          QaidaActivity(
            id: 'form_${index}_step9_mixed',
            slotNumber: 9,
            type: QaidaActivityType.mixedPractice,
            prompt: 'qaida.track.2.act.9.prompt',
            arabicTarget: med,
            options: [med, 'ـسـ', 'ـعـ'],
            correctIndex: 0,
            explanation: 'qaida.track.2.act.9.explanation',
          ),
          // 10. Lesson Check
          QaidaActivity(
            id: 'form_${index}_step10_check',
            slotNumber: 10,
            type: QaidaActivityType.lessonCheck,
            prompt: 'qaida.track.2.act.10.prompt',
            arabicTarget: '$init $med $fin',
            options: [med, 'ـعـ', 'ـفـ'],
            correctIndex: 0,
            explanation: 'qaida.track.2.act.10.explanation',
          ),
        ],
      );
    }),
  );

  // -------------------------------------------------------------
  // TRACK 3: 7 Harakat, Tanwin & Sukun (,   )
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track3Harakat = QaidaTrackInfo(
    id: 'track_3_harakat',
    trackNumber: 3,
    title: 'qaida.track.3.title',
    subtitle: 'qaida.track.3.title',
    arabicTitle: 'الْحَرَكَاتُ وَالتَّنْوِينُ وَالسُّكُونُ',
    description: 'qaida.track.3.desc',
    colorHex: 0xFFFF9600, // Duo Orange
    icon: Icons.graphic_eq_rounded,
    lessons: _generateTrack3Lessons(),
  );

    static List<QaidaLessonInfo> _generateTrack3Lessons() {
    final definitions = [
      {
        'id': 'qaida_h_fatha',
        'name': 'qaida.track.3.desc',
        'sub': 'qaida.track.3.desc',
        'sym': 'بَ',
        'sound': 'qaida.track.3.desc',
        'desc': 'qaida.track.3.desc',
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
        'name': 'qaida.track.3.desc',
        'sub': 'qaida.track.3.desc',
        'sym': 'بِ',
        'sound': 'qaida.track.3.desc',
        'desc': 'qaida.track.3.desc',
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
        'name': 'qaida.track.3.desc',
        'sub': 'qaida.track.3.desc',
        'sym': 'بُ',
        'sound': 'qaida.track.3.desc',
        'desc': 'qaida.track.3.desc',
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
        'name': 'qaida.track.3.desc',
        'sub': 'qaida.track.3.desc',
        'sym': 'بًا',
        'sound': 'qaida.track.3.desc',
        'desc': 'qaida.track.3.desc',
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
        'name': 'qaida.track.3.desc',
        'sub': 'qaida.track.3.desc',
        'sym': 'بٍ',
        'sound': 'qaida.track.3.desc',
        'desc': 'qaida.track.3.desc',
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
        'name': 'qaida.track.3.desc',
        'sub': 'qaida.track.3.desc',
        'sym': 'بٌ',
        'sound': 'qaida.track.3.desc',
        'desc': 'qaida.track.3.desc',
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
        'name': 'qaida.track.3.desc',
        'sub': 'qaida.track.3.desc',
        'sym': 'أَبْ',
        'sound': 'qaida.track.3.desc',
        'desc': 'qaida.track.3.desc',
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
  // TRACK 4: 10 Madd Lessons (   - Verified Taxonomy)
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track4Madd = QaidaTrackInfo(
    id: 'track_4_madd',
    trackNumber: 4,
    title: 'qaida.track.4.title',
    subtitle: 'qaida.track.4.title',
    arabicTitle: 'أَقْسَامُ الْمُدُودِ الْعَشَرَةُ',
    description: 'qaida.track.4.desc',
    colorHex: 0xFF9069CD, // Duo Purple
    icon: Icons.waves_rounded,
    lessons: _generateTrack4Lessons(),
  );

  static List<QaidaLessonInfo> _generateTrack4Lessons() {
    final definitions = [
      {
        'id': 'madd_1_tabii',
        'name': 'qaida.track.4.desc',
        'sub': 'qaida.track.4.desc',
        'sym': 'بَا  بِي  بُو',
        'desc': 'qaida.track.4.desc',
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
        'name': 'qaida.track.4.desc',
        'sub': 'qaida.track.4.desc',
        'sym': 'ءَامَنَ',
        'desc': 'qaida.track.4.desc',
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
        'name': 'qaida.track.4.desc',
        'sub': 'qaida.track.4.desc',
        'sym': 'خَوْفٍ  بَيْتٍ',
        'desc': 'qaida.track.4.desc',
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
        'name': 'qaida.track.4.desc',
        'sub': 'qaida.track.4.desc',
        'sym': 'الْعَالَمِينَ',
        'desc': 'qaida.track.4.desc',
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
        'name': 'qaida.track.4.desc',
        'sub': 'qaida.track.4.desc',
        'sym': 'فِي أَنفُسِكُمْ',
        'desc': 'qaida.track.4.desc',
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
        'name': 'qaida.track.4.desc',
        'sub': 'qaida.track.4.desc',
        'sym': 'ص  ق  ن',
        'desc': 'qaida.track.4.desc',
        'letters': ['ص', 'ق', 'ن', 'يس', 'حم'],
        'words': ['صٓ', 'قٓ', 'نٓ', 'يٰسٓ', 'حٰمٓ', 'طٰسٓ', 'الٓرٰ', 'طٰهٰ', 'الٓمٰرٰ', 'qaida.track.4.desc'],
        'contrasts': ['الٓمٓ', 'طٰسٓمٓ', 'الٓمٓصٓ', 'جَاءَ', 'قَالَ', 'فِيهَا'],
        'pairs': {'صٓ': 'قٓ', 'نٓ': 'يٰسٓ', 'الٓمٓ': 'طٰسٓمٓ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'صٓ'), ActivityTile(id: '2', label: '2', arabicLabel: 'وَالْقُرْآنِ')],
        'blank': '___ٓ وَالْقُرْآنِ',
        'blankOpts': ['ص', 'ب', 'ت'],
      },
      {
        'id': 'madd_7_harfi_mush',
        'name': 'qaida.track.4.desc',
        'sub': 'qaida.track.4.desc',
        'sym': 'الٓمٓ',
        'desc': 'qaida.track.4.desc',
        'letters': ['الٓمٓ', 'طٰسٓمٓ', 'الٓمٓصٓ'],
        'words': ['الٓمٓ', 'طٰسٓمٓ', 'الٓمٓصٓ', 'الٓمٓرٰ', 'qaida.track.4.desc', 'qaida.track.4.desc', 'qaida.track.4.desc', 'qaida.track.4.desc', 'qaida.track.4.desc', 'qaida.track.4.desc'],
        'contrasts': ['صٓ', 'قٓ', 'نٓ', 'يٰسٓ', 'جَاءَ', 'قَالَ'],
        'pairs': {'الٓمٓ': 'طٰسٓمٓ', 'الٓمٓصٓ': 'الٓمٓرٰ', 'صٓ': 'قٓ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'الٓ'), ActivityTile(id: '2', label: '2', arabicLabel: 'مٓ')],
        'blank': 'الٓ___ٓ',
        'blankOpts': ['م', 'ب', 'د'],
      },
      {
        'id': 'madd_8_kalimi_mukh',
        'name': 'qaida.track.4.desc',
        'sub': 'qaida.track.4.desc',
        'sym': 'ءَآلْآنَ',
        'desc': 'qaida.track.4.desc',
        'letters': ['ءَآلْ'],
        'words': ['ءَآلْآنَ', 'ءَآلذَّكَرَيْنِ', 'ءَآللَّهُ', 'ءَآلْآنَ وَقَدْ', 'ءَآلْآنَ عَصَيْتَ', 'qaida.track.4.desc', 'qaida.track.4.desc', 'qaida.track.4.desc', 'qaida.track.4.desc', 'qaida.track.4.desc'],
        'contrasts': ['الضَّالِّينَ', 'الْحَاقَّةُ', 'جَاءَ', 'فِي أَنفُسِكُمْ', 'قَالَ', 'خَوْفٍ'],
        'pairs': {'ءَآلْآنَ': 'ءَآلذَّكَرَيْنِ', 'ءَآللَّهُ': 'ءَآلْآنَ', 'الضَّالِّينَ': 'الْحَاقَّةُ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'ءَآلْ'), ActivityTile(id: '2', label: '2', arabicLabel: 'آنَ')],
        'blank': '___آنَ',
        'blankOpts': ['ءَآلْ', 'أَلْ', 'إِلْ'],
      },
      {
        'id': 'madd_9_kalimi_mush',
        'name': 'qaida.track.4.desc',
        'sub': 'qaida.track.4.desc',
        'sym': 'الضَّالِّينَ',
        'desc': 'qaida.track.4.desc',
        'letters': ['ـَّ', 'ـِّ', 'ـُّ'],
        'words': ['الضَّالِّينَ', 'الْحَاقَّةُ', 'الصَّاخَّةُ', 'الطَّامَّةُ', 'دَابَّةٍ', 'تَأْمُرُونِّي', 'يُحَاجُّونَكَ', 'جَانٌّ', 'حَاجَّهُ', 'صَوَافَّ'],
        'contrasts': ['جَاءَ', 'فِي أَنفُسِكُمْ', 'قَالَ', 'خَوْفٍ', 'الْعَالَمِينَ', 'ءَامَنَ'],
        'pairs': {'الضَّالِّينَ': 'الْحَاقَّةُ', 'الصَّاخَّةُ': 'الطَّامَّةُ', 'جَاءَ': 'فِي أَنفُسِكُمْ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'الضَّا'), ActivityTile(id: '2', label: '2', arabicLabel: 'لِّينَ')],
        'blank': 'qaida.track.4.desc',
        'blankOpts': ['ل', 'م', 'ت'],
      },
      {
        'id': 'madd_10_muttasil',
        'name': 'qaida.track.4.desc',
        'sub': 'qaida.track.4.desc',
        'sym': 'جَاءَ  سُوءَ',
        'desc': 'qaida.track.4.desc',
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
  // TRACK 5: 10 Noon/Meem Sakin & Ghunnah ( ,    )
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track5Ghunnah = QaidaTrackInfo(
    id: 'track_5_ghunnah',
    trackNumber: 5,
    title: 'qaida.track.5.title',
    subtitle: 'qaida.track.5.title',
    arabicTitle: 'أَحْكَامُ النُّونِ السَّاكِنَةِ وَالْمِيمِ',
    description: 'qaida.track.5.desc',
    colorHex: 0xFF2B70C9, // Deep Blue
    icon: Icons.record_voice_over_rounded,
    lessons: _generateTrack5Lessons(),
  );

  static List<QaidaLessonInfo> _generateTrack5Lessons() {
    final definitions = [
      {
        'id': 'ghunnah_1_wajib',
        'name': 'qaida.track.5.desc',
        'sub': 'qaida.track.5.desc',
        'sym': 'إِنَّ  عَمَّ',
        'desc': 'qaida.track.5.desc',
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
        'name': 'qaida.track.5.desc',
        'sub': 'qaida.track.5.desc',
        'sym': 'مَنْ ءَامَنَ',
        'desc': 'qaida.track.5.desc',
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
        'name': 'qaida.track.5.desc',
        'sub': 'qaida.track.5.desc',
        'sym': 'مَن يَقُولُ',
        'desc': 'qaida.track.5.desc',
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
        'name': 'qaida.track.5.desc',
        'sub': 'qaida.track.5.desc',
        'sym': 'مِّن رَّبِّهِمْ',
        'desc': 'qaida.track.5.desc',
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
        'name': 'qaida.track.5.desc',
        'sub': 'qaida.track.5.desc',
        'sym': 'مِنۢ بَعْدِ',
        'desc': 'qaida.track.5.desc',
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
        'name': 'qaida.track.5.desc',
        'sub': 'qaida.track.5.desc',
        'sym': 'أَنتُمْ',
        'desc': 'qaida.track.5.desc',
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
        'name': 'qaida.track.5.desc',
        'sub': 'qaida.track.5.desc',
        'sym': 'تَرْمِيهِم بِحِجَارَةٍ',
        'desc': 'qaida.track.5.desc',
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
        'name': 'qaida.track.5.desc',
        'sub': 'qaida.track.5.desc',
        'sym': 'لَهُم مَّا',
        'desc': 'qaida.track.5.desc',
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
        'name': 'qaida.track.5.desc',
        'sub': 'qaida.track.5.desc',
        'sym': 'أَلَمْ تَرَ',
        'desc': 'qaida.track.5.desc',
        'letters': ['مْ', 'ت', 'ف', 'و'],
        'words': ['أَلَمْ تَرَ', 'هُمْ فِيهَا', 'عَلَيْهِمْ وَلَا', 'أَمْوَالُكُمْ', 'أَنفُسَكُمْ', 'لَعَلَّكُمْ تَتَّقُونَ', 'ذَٰلِكُمْ خَيْرٌ', 'أَلَمْ نَشْرَحْ', 'عَلَيْهِمْ طَيْرًا', 'فَمَهِّلْهُمْ'],
        'contrasts': ['تَرْمِيهِم بِحِجَارَةٍ', 'لَهُم مَّا', 'أَطْعَمَهُم مِّن', 'إِنَّ', 'عَمَّ', 'أَنتُمْ'],
        'pairs': {'أَلَمْ تَرَ': 'هُمْ فِيهَا', 'عَلَيْهِمْ وَلَا': 'أَمْوَالُكُمْ', 'تَرْمِيهِم بِحِجَارَةٍ': 'يَعْتَصِم بِاللَّهِ'},
        'tiles': [ActivityTile(id: '1', label: '1', arabicLabel: 'أَلَمْ'), ActivityTile(id: '2', label: '2', arabicLabel: 'تَرَ')],
        'blank': 'أَلَمْ ___َرَ',
        'blankOpts': ['ت', 'ب', 'م'],
      },
      {
        'id': 'ghunnah_10_qalqalah',
        'name': 'qaida.track.5.desc',
        'sub': 'qaida.track.5.desc',
        'sym': 'قُطْبُ جَدٍّ',
        'desc': 'qaida.track.5.desc',
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
  // TRACK 6: 20 Joined Letters 
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track6Joined = QaidaTrackInfo(
    id: 'track_6_joined',
    trackNumber: 6,
    title: 'qaida.track.6.title',
    subtitle: 'qaida.track.6.title',
    arabicTitle: 'الْحُرُوفُ الْمُرَكَّبَةُ',
    description: 'qaida.track.6.desc',
    colorHex: 0xFF10B981, // Emerald Green
    icon: Icons.extension_rounded,
    lessons: List.generate(20, (index) {
      final samples = [
        {'text': 'لا', 'parts': 'ل + ا', 'name': 'qaida.track.6.desc', 'tiles': ['ل', 'ا']},
        {'text': 'با', 'parts': 'ب + ا', 'name': 'qaida.track.6.desc', 'tiles': ['ب', 'ا']},
        {'text': 'تا', 'parts': 'ت + ا', 'name': 'qaida.track.6.desc', 'tiles': ['ت', 'ا']},
        {'text': 'ثا', 'parts': 'ث + ا', 'name': 'qaida.track.6.desc', 'tiles': ['ث', 'ا']},
        {'text': 'بل', 'parts': 'ب + ل', 'name': 'qaida.track.6.desc', 'tiles': ['ب', 'ل']},
        {'text': 'تل', 'parts': 'ت + ل', 'name': 'qaida.track.6.desc', 'tiles': ['ت', 'ل']},
        {'text': 'ثل', 'parts': 'ث + ل', 'name': 'qaida.track.6.desc', 'tiles': ['ث', 'ل']},
        {'text': 'بج', 'parts': 'ب + ج', 'name': 'qaida.track.6.desc', 'tiles': ['ب', 'ج']},
        {'text': 'تح', 'parts': 'ت + ح', 'name': 'qaida.track.6.desc', 'tiles': ['ت', 'ح']},
        {'text': 'ثخ', 'parts': 'ث + خ', 'name': 'qaida.track.6.desc', 'tiles': ['ث', 'خ']},
        {'text': 'يم', 'parts': 'ي + م', 'name': 'qaida.track.6.desc', 'tiles': ['ي', 'م']},
        {'text': 'نم', 'parts': 'ن + م', 'name': 'qaida.track.6.desc', 'tiles': ['ن', 'م']},
        {'text': 'تم', 'parts': 'ت + م', 'name': 'qaida.track.6.desc', 'tiles': ['ت', 'م']},
        {'text': 'سم', 'parts': 'س + م', 'name': 'qaida.track.6.desc', 'tiles': ['س', 'م']},
        {'text': 'شم', 'parts': 'ش + م', 'name': 'qaida.track.6.desc', 'tiles': ['ش', 'م']},
        {'text': 'صم', 'parts': 'ص + م', 'name': 'qaida.track.6.desc', 'tiles': ['ص', 'م']},
        {'text': 'ضم', 'parts': 'ض + م', 'name': 'qaida.track.6.desc', 'tiles': ['ض', 'م']},
        {'text': 'بيت', 'parts': 'ب + ي + ت', 'name': 'qaida.track.6.desc', 'tiles': ['ب', 'ي', 'ت']},
        {'text': 'نجم', 'parts': 'ن + ج + م', 'name': 'qaida.track.6.desc', 'tiles': ['ن', 'ج', 'م']},
        {'text': 'شمس', 'parts': 'ش + م + س', 'name': 'qaida.track.6.desc', 'tiles': ['ش', 'م', 'س']},
      ];
      final item = samples[index % samples.length];
      final itemTiles = (item['tiles'] as List<String>).map((t) => ActivityTile(id: t, label: t, arabicLabel: t)).toList();

      return QaidaLessonInfo(
        id: 'qaida_joined_$index',
        trackId: 'track_6_joined',
        lessonNumber: index + 1,
        title: 'qaida.track.6.title',
        subtitle: 'qaida.track.6.title',
        arabicDisplay: item['text'] as String,
        description: 'qaida.track.6.desc',
        ruleSummary: 'qaida.track.6.desc',
        activities: _buildTajweed10StepLesson(
          lessonId: 'qaida_joined_$index',
          topicName: 'qaida.track.6.title',
          ruleDescription: 'qaida.track.6.desc',
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
  // TRACK 7: 30 Word Reading Lessons 
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track7Words = QaidaTrackInfo(
    id: 'track_7_words',
    trackNumber: 7,
    title: 'qaida.track.7.title',
    subtitle: 'qaida.track.7.title',
    arabicTitle: 'قِرَاءَةُ الْكَلِمَاتِ',
    description: 'qaida.track.7.desc',
    colorHex: 0xFF2563EB, // Royal Blue
    icon: Icons.auto_stories_rounded,
    lessons: List.generate(30, (index) {
      final wordsData = [
        {'ar': 'دَرَسَ', 'bn': 'qaida.track.7.desc', 'tiles': ['دَ', 'رَ', 'سَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'كَتَبَ', 'bn': 'qaida.track.7.desc', 'tiles': ['كَ', 'تَ', 'بَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'جَلَسَ', 'bn': 'qaida.track.7.desc', 'tiles': ['جَ', 'لَ', 'سَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'خَلَقَ', 'bn': 'qaida.track.7.desc', 'tiles': ['خَ', 'لَ', 'قَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'بَلَغَ', 'bn': 'qaida.track.7.desc', 'tiles': ['بَ', 'لَ', 'غَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'سَمِعَ', 'bn': 'qaida.track.7.desc', 'tiles': ['سَ', 'مِ', 'عَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'حَمِدَ', 'bn': 'qaida.track.7.desc', 'tiles': ['حَ', 'مِ', 'دَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'فَهِمَ', 'bn': 'qaida.track.7.desc', 'tiles': ['فَ', 'هِ', 'مَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'عَلِمَ', 'bn': 'qaida.track.7.desc', 'tiles': ['عَ', 'لِ', 'مَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'غَضِبَ', 'bn': 'qaida.track.7.desc', 'tiles': ['غَ', 'ضِ', 'بَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'كُتِبَ', 'bn': 'qaida.track.7.desc', 'tiles': ['كُ', 'تِ', 'بَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'جُمِعَ', 'bn': 'qaida.track.7.desc', 'tiles': ['جُ', 'مِ', 'عَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'رُزِقَ', 'bn': 'qaida.track.7.desc', 'tiles': ['رُ', 'زِ', 'قَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'خُلِقَ', 'bn': 'qaida.track.7.desc', 'tiles': ['خُ', 'لِ', 'قَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'بُعِثَ', 'bn': 'qaida.track.7.desc', 'tiles': ['بُ', 'عِ', 'ثَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'أَحْمَدُ', 'bn': 'qaida.track.7.desc', 'tiles': ['أَحْ', 'مَ', 'دُ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'يَحْمَدُ', 'bn': 'qaida.track.7.desc', 'tiles': ['يَحْ', 'مَ', 'دُ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'يَكْتُبُ', 'bn': 'qaida.track.7.desc', 'tiles': ['يَكْ', 'تُ', 'بُ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'يَجْلِسُ', 'bn': 'qaida.track.7.desc', 'tiles': ['يَجْ', 'لِ', 'سُ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'الْحَمْدُ', 'bn': 'qaida.track.7.desc', 'tiles': ['الْ', 'حَمْ', 'دُ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'قَالَ', 'bn': 'qaida.track.7.desc', 'tiles': ['قَا', 'لَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'قِيلَ', 'bn': 'qaida.track.7.desc', 'tiles': ['قِي', 'لَ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'يَقُولُ', 'bn': 'qaida.track.7.desc', 'tiles': ['يَ', 'قُو', 'لُ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'رَبٌّ', 'bn': 'qaida.track.7.desc', 'tiles': ['رَبْ', 'بٌ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'كُلٌّ', 'bn': 'qaida.track.7.desc', 'tiles': ['كُلْ', 'لٌ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'مُحَمَّدٌ', 'bn': 'qaida.track.7.desc', 'tiles': ['مُ', 'حَمْ', 'مَ', 'دٌ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'جَنَّةٌ', 'bn': 'qaida.track.7.desc', 'tiles': ['جَنْ', 'نَ', 'ةٌ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'الْقَمَرُ', 'bn': 'qaida.track.7.desc', 'tiles': ['الْ', 'قَ', 'مَ', 'رُ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'الشَّمْسُ', 'bn': 'qaida.track.7.desc', 'tiles': ['الشَّ', 'مْ', 'سُ'], 'rule': 'qaida.track.7.desc'},
        {'ar': 'الْقُرْآنُ', 'bn': 'qaida.track.7.desc', 'tiles': ['الْ', 'قُرْ', 'آنُ'], 'rule': 'qaida.track.7.desc'},
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
        title: 'qaida.track.7.title',
        subtitle: 'qaida.track.7.title',
        arabicDisplay: target,
        description: 'qaida.track.7.desc',
        ruleSummary: 'qaida.track.7.desc',
        activities: _buildTajweed10StepLesson(
          lessonId: 'qaida_word_$index',
          topicName: 'qaida.track.7.title',
          ruleDescription: 'qaida.track.7.desc',
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
  // TRACK 8: 40 Sentence & Ayah Reading Lessons 
  // -------------------------------------------------------------
  static final QaidaTrackInfo _track8Sentences = QaidaTrackInfo(
    id: 'track_8_sentences',
    trackNumber: 8,
    title: 'qaida.track.8.title',
    subtitle: 'qaida.track.8.title',
    arabicTitle: 'قِرَاءَةُ الْجُمَلِ وَالْآيَاتِ',
    description:
        'qaida.track.8.desc',
    colorHex: 0xFFD97706, // Warm Amber
    icon: Icons.menu_book_rounded,
    lessons: List.generate(40, (index) {
      final sentencesData = [
        {'ar': 'بِسْمِ اللَّهِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'الرَّحْمَٰنِ الرَّحِيمِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'الرَّحْمَٰنِ الرَّحِيمِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'مَالِكِ يَوْمِ الدِّينِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'إِيَّاكَ نَعْبُدُ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'وَإِيَّاكَ نَسْتَعِينُ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'وَلَا الضَّالِّينَ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'قُلْ هُوَ اللَّهُ أَحَدٌ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'اللَّهُ الصَّمَدُ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'لَمْ يَلِدْ وَلَمْ يُولَدْ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'مِن شَرِّ مَا خَلَقَ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'مَلِكِ النَّاسِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'إِلَٰهِ النَّاسِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'مِنَ الْجِنَّةِ وَالنَّاسِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'فَصَلِّ لِرَبِّكَ وَانْحَرْ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'وَالْعَصْرِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'إِنَّ الْإِنسَانَ لَفِي خُسْرٍ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'أَلَمْ تَرَ كَيْفَ فَعَلَ رَبُّكَ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'بِأَصْحَابِ الْفِيلِ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'أَلَمْ يَجْعَلْ كَيْدَهُمْ فِي تَضْلِيلٍ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'وَأَرْسَلَ عَلَيْهِمْ طَيْرًا أَبَابِيلَ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'تَرْمِيهِم بِحِجَارَةٍ مِّن سِجِّيلٍ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'فَجَعَلَهُمْ كَعَصْفٍ مَّأْكُولٍ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
        {'ar': 'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ', 'bn': 'qaida.track.8.desc', 'rule': 'qaida.track.8.desc'},
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
        title: 'qaida.track.8.title',
        subtitle: 'qaida.track.8.title',
        arabicDisplay: target,
        description: 'qaida.track.8.desc',
        ruleSummary: 'qaida.track.8.desc',
        activities: _buildTajweed10StepLesson(
          lessonId: 'qaida_sentence_$index',
          topicName: 'qaida.track.8.title',
          ruleDescription: 'qaida.track.8.desc',
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
        prompt: 'qaida.track.8.act.1.prompt',
        arabicTarget: p[0],
        options: [p[0], c[0], c[1 % c.length]],
        correctIndex: 0,
        explanation: 'qaida.track.8.act.1.explanation',
        feedbackCorrect: 'qaida.activity.feedback_correct_default',
        feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
        skillId: '${lessonId}_recall',
      ),
      // 2. Recognize
      QaidaActivity(
        id: '${lessonId}_step2_recognize',
        slotNumber: 2,
        type: QaidaActivityType.recognize,
        prompt: 'qaida.track.8.act.2.prompt',
        arabicTarget: p[1],
        options: [p[1], c[2 % c.length], c[3 % c.length]],
        correctIndex: 0,
        explanation: 'qaida.track.8.act.2.explanation',
        feedbackCorrect: 'qaida.activity.feedback_correct_default',
        feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
        skillId: '${lessonId}_recognize',
      ),
      // 3. Listen & Identify
      QaidaActivity(
        id: '${lessonId}_step3_listen',
        slotNumber: 3,
        type: QaidaActivityType.listenAndIdentify,
        prompt: 'qaida.track.8.act.3.prompt',
        arabicTarget: p[2],
        options: [p[2], c[1 % c.length], c[4 % c.length]],
        correctIndex: 0,
        explanation: 'qaida.track.8.act.3.explanation',
        feedbackCorrect: 'qaida.activity.feedback_correct_default',
        feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
        skillId: '${lessonId}_listen',
      ),
      // 4. Match Pairs (Pure Arabic)
      QaidaActivity(
        id: '${lessonId}_step4_match',
        slotNumber: 4,
        type: QaidaActivityType.matchPairs,
        prompt: 'qaida.track.8.act.4.prompt',
        arabicTarget: p[3],
        pairs: matchPairs,
        explanation: 'qaida.track.8.act.4.explanation',
        feedbackCorrect: 'qaida.activity.feedback_correct_default',
        feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
        skillId: '${lessonId}_match',
      ),
      // 5. Differentiate (Odd-One-Out)
      QaidaActivity(
        id: '${lessonId}_step5_diff',
        slotNumber: 5,
        type: QaidaActivityType.differentiate,
        prompt: 'qaida.track.8.act.5.prompt',
        arabicTarget: c[0],
        options: [c[0], p[4], p[5]],
        correctIndex: 0,
        explanation: 'qaida.track.8.act.5.explanation',
        feedbackCorrect: 'qaida.activity.feedback_correct_default',
        feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
        skillId: '${lessonId}_diff',
      ),
      // 6. Build / Arrange (Puzzle Pedestals)
      QaidaActivity(
        id: '${lessonId}_step6_arrange',
        slotNumber: 6,
        type: QaidaActivityType.buildArrange,
        prompt: 'qaida.track.8.act.6.prompt',
        arabicTarget: p[6],
        tiles: arrangeTiles,
        explanation: 'qaida.track.8.act.6.explanation',
        feedbackCorrect: 'qaida.activity.feedback_correct_default',
        feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
        skillId: '${lessonId}_arrange',
      ),
      // 7. Fill in the Blank
      QaidaActivity(
        id: '${lessonId}_step7_context',
        slotNumber: 7,
        type: QaidaActivityType.fillInBlank,
        prompt: 'qaida.track.8.act.7.prompt',
        blankSentence: blankWord,
        blankOptions: blankOptions,
        blankCorrectIndex: blankCorrectIndex,
        explanation: 'qaida.track.8.act.7.explanation',
        feedbackCorrect: 'qaida.activity.feedback_correct_default',
        feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
        skillId: '${lessonId}_blank',
      ),
      // 8. Apply Rule in Context
      QaidaActivity(
        id: '${lessonId}_step8_rule',
        slotNumber: 8,
        type: QaidaActivityType.applyRule,
        prompt: 'qaida.track.8.act.8.prompt',
        arabicTarget: p[7],
        options: [p[7], c[2 % c.length], c[5 % c.length]],
        correctIndex: 0,
        explanation: 'qaida.track.8.act.8.explanation',
        feedbackCorrect: 'qaida.activity.feedback_correct_default',
        feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
        skillId: '${lessonId}_rule',
      ),
      // 9. Mixed Practice
      QaidaActivity(
        id: '${lessonId}_step9_mixed',
        slotNumber: 9,
        type: QaidaActivityType.mixedPractice,
        prompt: 'qaida.track.8.act.9.prompt',
        arabicTarget: p[8],
        options: [p[8], c[0], c[3 % c.length]],
        correctIndex: 0,
        explanation: 'qaida.track.8.act.9.explanation',
        feedbackCorrect: 'qaida.activity.feedback_correct_default',
        feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
        skillId: '${lessonId}_mixed',
      ),
      // 10. Lesson Check
      QaidaActivity(
        id: '${lessonId}_step10_check',
        slotNumber: 10,
        type: QaidaActivityType.lessonCheck,
        prompt: 'qaida.track.8.act.10.prompt',
        arabicTarget: p[9],
        options: [p[9], c[1 % c.length], c[4 % c.length]],
        correctIndex: 0,
        explanation: 'qaida.track.8.act.10.explanation',
        feedbackCorrect: 'qaida.activity.feedback_correct_default',
        feedbackIncorrect: 'qaida.activity.feedback_incorrect_default',
        skillId: '${lessonId}_check',
      ),
    ];
  }
}
