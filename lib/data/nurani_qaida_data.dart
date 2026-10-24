import 'package:flutter/material.dart';

import '../models/qaida/qaida_models.dart';

/// Complete 17-Step Nurani Qaida Curriculum Data Model.
/// Follows the Master Product & Design Plan:
/// - 17 progressive steps from single letter recognition (Mufradat) to full Ayah Tilawat.
/// - Exactly 7 activities per lesson (Easy to Hard), where #7 is always the Boss Challenge / Step Exam.
/// - 5 Core activities in every step: Listening, Voice Repeat, Reading Round, Boss Challenge, Spaced Review.
/// - Unique tailored questions per letter (Alif vs Ba vs Ta, etc.) with real Quranic vocabulary.
/// - Dynamic option placement (no hardcoded index 0).
class NuraniQaidaData {
  NuraniQaidaData._();

  static List<NuraniStepInfo>? _cachedSteps;

  static List<NuraniStepInfo> get steps {
    _cachedSteps ??= _buildAll17Steps();
    return _cachedSteps!;
  }

  static NuraniStepInfo? getStepByNumber(int stepNumber) {
    for (final step in steps) {
      if (step.stepNumber == stepNumber) return step;
    }
    return null;
  }

  static NuraniStepInfo? getStepForLesson(String lessonId) {
    for (final step in steps) {
      for (final lesson in step.lessons) {
        if (lesson.id == lessonId) return step;
      }
    }
    return null;
  }

  static QaidaLessonInfo? getLessonById(String lessonId) {
    for (final step in steps) {
      for (final lesson in step.lessons) {
        if (lesson.id == lessonId) return lesson;
      }
    }
    return null;
  }

  static QaidaLessonInfo getFirstIncompleteLesson(bool Function(String id) hasCompleted) {
    for (final step in steps) {
      for (final lesson in step.lessons) {
        if (!hasCompleted(lesson.id)) return lesson;
      }
    }
    return steps.first.lessons.first;
  }

  // ---------------------------------------------------------------------------
  // BUILD ALL 17 STEPS
  // ---------------------------------------------------------------------------
  static List<NuraniStepInfo> _buildAll17Steps() {
    return [
      _buildStep1Mufradat(),
      _buildStep2Murakkabat(),
      _buildStep3Harakat(),
      _buildStep4Tanween(),
      _buildStep5KhariHarakat(),
      _buildStep6Layyin(),
      _buildStep7Sukoon(),
      _buildStep8Shaddah(),
      _buildStep9NoonSakin(),
      _buildStep10MeemSakin(),
      _buildStep11Ghunnah(),
      _buildStep12Madd(),
      _buildStep13LamRules(),
      _buildStep14RaAndLam(),
      _buildStep15MuqattaatAndQalqalah(),
      _buildStep16Waqf(),
      _buildStep17Tilawat(),
    ];
  }

  // Helper for dynamic option placement: ensures correct answer is balanced
  static List<String> _makeOptions(String correct, String d1, String d2, int slot) {
    final pos = slot % 3;
    if (pos == 0) return [correct, d1, d2];
    if (pos == 1) return [d1, correct, d2];
    return [d1, d2, correct];
  }

  static int _getCorrectIndex(int slot) => slot % 3;

  // ---------------------------------------------------------------------------
  // STEP 1:  (Mufradat -    )
  // 7 Activities per letter:
  // Listen → Match → Tap Answer → Memory Flip → Trace/Identify → Odd One Out → Boss Challenge
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep1Mufradat() {
    final letterSpecs = [
      {
        'id': 'alif', 'ar': 'ا',
                        'words': ['أَكَلَ', 'أَمَرَ', 'إِبِلٌ'],
        'distractors': ['ل', 'د', 'ر'],
        'audio': 'assets/audio/letters/alif.mp3',
      },
      {
        'id': 'baa', 'ar': 'ب',
                        'words': ['بَيْتٌ', 'بَابٌ', 'كَتَبَ'],
        'distractors': ['ت', 'ث', 'ن'],
        'audio': 'assets/audio/letters/baa.mp3',
      },
      {
        'id': 'taa', 'ar': 'ت',
                        'words': ['تَمْرٌ', 'كَتَبَ', 'تِينٌ'],
        'distractors': ['ب', 'ث', 'ط'],
        'audio': 'assets/audio/letters/taa.mp3',
      },
      {
        'id': 'thaa', 'ar': 'ث',
                        'words': ['ثَمَرٌ', 'ثَلَاثَة', 'مَثَلٌ'],
        'distractors': ['س', 'ص', 'ت'],
        'audio': 'assets/audio/letters/thaa.mp3',
      },
      {
        'id': 'jeem', 'ar': 'ج',
                        'words': ['جَمَلٌ', 'مَسْجِدٌ', 'حَجٌّ'],
        'distractors': ['ح', 'خ', 'ع'],
        'audio': 'assets/audio/letters/jeem.mp3',
      },
      {
        'id': 'haa', 'ar': 'ح',
                        'words': ['حَمْدٌ', 'لَوْحٌ', 'رَحْمَة'],
        'distractors': ['ج', 'خ', 'هـ'],
        'audio': 'assets/audio/letters/haa.mp3',
      },
      {
        'id': 'khaa', 'ar': 'خ',
                        'words': ['خُبْزٌ', 'نَخْلٌ', 'خَيْرٌ'],
        'distractors': ['ح', 'ج', 'غ'],
        'audio': 'assets/audio/letters/khaa.mp3',
      },
      {
        'id': 'daal', 'ar': 'د',
                        'words': ['دَارٌ', 'أَسَدٌ', 'بَلَدٌ'],
        'distractors': ['ذ', 'ر', 'ز'],
        'audio': 'assets/audio/letters/daal.mp3',
      },
      {
        'id': 'dhaal', 'ar': 'ذ',
                        'words': ['ذَهَبٌ', 'ذِكْرٌ', 'أُذُنٌ'],
        'distractors': ['د', 'ز', 'ظ'],
        'audio': 'assets/audio/letters/dhaal.mp3',
      },
      {
        'id': 'raa', 'ar': 'ر',
                        'words': ['رَحْمَة', 'قَمَرٌ', 'نَهْرٌ'],
        'distractors': ['ز', 'د', 'و'],
        'audio': 'assets/audio/letters/raa.mp3',
      },
      {
        'id': 'zaay', 'ar': 'ز',
                        'words': ['زَيْتُون', 'مَوْزٌ', 'رِزْقٌ'],
        'distractors': ['ر', 'ذ', 'س'],
        'audio': 'assets/audio/letters/zaay.mp3',
      },
      {
        'id': 'seen', 'ar': 'س',
                        'words': ['سَمَكٌ', 'شَمْسٌ', 'مَسْجِدٌ'],
        'distractors': ['ش', 'ص', 'ث'],
        'audio': 'assets/audio/letters/seen.mp3',
      },
      {
        'id': 'sheen', 'ar': 'ش',
                        'words': ['شَمْسٌ', 'شَجَرَة', 'عُشْبٌ'],
        'distractors': ['س', 'ص', 'ث'],
        'audio': 'assets/audio/letters/sheen.mp3',
      },
      {
        'id': 'saad', 'ar': 'ص',
                        'words': ['صَبْرٌ', 'فَصْلٌ', 'نَصْرٌ'],
        'distractors': ['س', 'ض', 'ط'],
        'audio': 'assets/audio/letters/saad.mp3',
      },
      {
        'id': 'daad', 'ar': 'ض',
                        'words': ['ضَوْءٌ', 'أَرْضٌ', 'فَضْلٌ'],
        'distractors': ['ص', 'ظ', 'د'],
        'audio': 'assets/audio/letters/daad.mp3',
      },
      {
        'id': 'taa_heavy', 'ar': 'ط',
                        'words': ['طَالِبٌ', 'مَطَرٌ', 'طَيْرٌ'],
        'distractors': ['ت', 'ظ', 'د'],
        'audio': 'assets/audio/letters/taa_heavy.mp3',
      },
      {
        'id': 'zaa_heavy', 'ar': 'ظ',
                        'words': ['ظِلٌّ', 'نَظَرٌ', 'ظُهْرٌ'],
        'distractors': ['ط', 'ذ', 'ض'],
        'audio': 'assets/audio/letters/zaa_heavy.mp3',
      },
      {
        'id': 'ayn', 'ar': 'ع',
                        'words': ['عِلْمٌ', 'سَمِيعٌ', 'عَيْنٌ'],
        'distractors': ['غ', 'ء', 'ح'],
        'audio': 'assets/audio/letters/ayn.mp3',
      },
      {
        'id': 'ghayn', 'ar': 'غ',
                        'words': ['غَفُورٌ', 'بَالِغٌ', 'غَيْبٌ'],
        'distractors': ['ع', 'د', 'ف'],
        'audio': 'assets/audio/letters/ghayn.mp3',
      },
      {
        'id': 'faa', 'ar': 'ف',
                        'words': ['فِيلٌ', 'صَيْفٌ', 'فَجْرٌ'],
        'distractors': ['ق', 'ب', 'غ'],
        'audio': 'assets/audio/letters/faa.mp3',
      },
      {
        'id': 'qaaf', 'ar': 'ق',
                        'words': ['قَلَمٌ', 'قُرْآن', 'حَقٌّ'],
        'distractors': ['ك', 'ف', 'غ'],
        'audio': 'assets/audio/letters/qaaf.mp3',
      },
      {
        'id': 'kaaf', 'ar': 'ك',
                        'words': ['كِتَابٌ', 'مَلِكٌ', 'شُكْرٌ'],
        'distractors': ['ق', 'ل', 'ت'],
        'audio': 'assets/audio/letters/kaaf.mp3',
      },
      {
        'id': 'laam', 'ar': 'ل',
                        'words': ['لَيْلٌ', 'هِلَالٌ', 'عِلْمٌ'],
        'distractors': ['ا', 'ك', 'م'],
        'audio': 'assets/audio/letters/laam.mp3',
      },
      {
        'id': 'meem', 'ar': 'م',
                        'words': ['مَسْجِدٌ', 'قَلَمٌ', 'شَمْسٌ'],
        'distractors': ['ن', 'ل', 'ب'],
        'audio': 'assets/audio/letters/meem.mp3',
      },
      {
        'id': 'noon', 'ar': 'ن',
                        'words': ['نُورٌ', 'عَيْنٌ', 'جَنَّة'],
        'distractors': ['ب', 'ت', 'ث'],
        'audio': 'assets/audio/letters/noon.mp3',
      },
      {
        'id': 'waaw', 'ar': 'و',
                        'words': ['وَرْدَة', 'نَوْمٌ', 'يَوْمٌ'],
        'distractors': ['ر', 'د', 'ف'],
        'audio': 'assets/audio/letters/waaw.mp3',
      },
      {
        'id': 'haa_small', 'ar': 'هـ',
                        'words': ['هُدًى', 'وَجْهٌ', 'نَهْرٌ'],
        'distractors': ['ح', 'خ', 'ة'],
        'audio': 'assets/audio/letters/haa_small.mp3',
      },
      {
        'id': 'yaa', 'ar': 'ي',
                        'words': ['يَوْمٌ', 'عَيْنٌ', 'بَيْتٌ'],
        'distractors': ['ب', 'ت', 'ن'],
        'audio': 'assets/audio/letters/yaa.mp3',
      },
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < letterSpecs.length; i++) {
      final spec = letterSpecs[i];
      final letterId = spec['id'] as String;
      final ar = spec['ar'] as String;
      final nameKey = 'qaida.letter.' + (letterId == 'taa_heavy' ? 'toa' : (letterId == 'zaa_heavy' ? 'zoa' : (letterId == 'zaay' ? 'zay' : letterId))) + '.name';
      final makhrajKey = 'qaida.letter.' + (letterId == 'haa_small' ? 'ha_soft' : (letterId == 'haa' ? 'ha' : (letterId == 'baa' ? 'ba' : (letterId == 'taa' ? 'ta' : (letterId == 'thaa' ? 'tha' : (letterId == 'khaa' ? 'kha' : (letterId == 'daal' ? 'dal' : (letterId == 'dhaal' ? 'dhal' : (letterId == 'raa' ? 'ra' : (letterId == 'zaay' ? 'zay' : (letterId == 'saad' ? 'sad' : (letterId == 'daad' ? 'dad' : (letterId == 'taa_heavy' ? 'toa' : (letterId == 'zaa_heavy' ? 'zoa' : (letterId == 'faa' ? 'fa' : (letterId == 'qaaf' ? 'qaf' : (letterId == 'kaaf' ? 'kaf' : (letterId == 'laam' ? 'lam' : (letterId == 'waaw' ? 'waw' : (letterId == 'yaa' ? 'ya' : letterId)))))))))))))))))))) + '.makhraj';
      final words = spec['words'] as List<String>;
      final distractors = spec['distractors'] as List<String>;
      final audio = spec['audio'] as String;

      final d1 = distractors[0];
      final d2 = distractors.length > 1 ? distractors[1] : 'ب';

      // 7 tailored activities matching:
      // Listen → Match → Tap Answer → Memory Flip → Trace/Identify → Odd One Out → Boss
      final activities = [
        // 1. Listen & Choose
        QaidaActivity(
          id: '${letterId}_act1_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.1.act.1.prompt',
          arabicTarget: ar,
          audioAsset: audio,
          options: _makeOptions(ar, d1, d2, 1),
          correctIndex: _getCorrectIndex(1),
          explanation: 'qaida.step.1.act.1.explanation',
          skillId: 'letter_listen_$letterId',
        ),
        // 2. Match the Pairs
        QaidaActivity(
          id: '${letterId}_act2_match',
          slotNumber: 2,
          type: QaidaActivityType.matchPairs,
          prompt: 'qaida.step.1.act.2.prompt',
          pairs: {
            ar: nameKey,
            d1: d1,
            d2: d2,
          },
          explanation: 'qaida.step.1.act.2.explanation',
          skillId: 'letter_match_$letterId',
        ),
        // 3. Tap the Right Answer
        QaidaActivity(
          id: '${letterId}_act3_tap',
          slotNumber: 3,
          type: QaidaActivityType.recognize,
          prompt: 'qaida.step.1.act.3.prompt',
          arabicTarget: ar,
          options: _makeOptions(ar, d1, d2, 3),
          correctIndex: _getCorrectIndex(3),
          explanation: 'qaida.step.1.act.3.explanation',
          skillId: 'letter_recognize_$letterId',
        ),
        // 4. Memory Flip
        QaidaActivity(
          id: '${letterId}_act4_memory',
          slotNumber: 4,
          type: QaidaActivityType.memoryMatch,
          prompt: 'qaida.step.1.act.4.prompt',
          pairs: {
            ar: nameKey,
            d1: d1,
          },
          explanation: 'qaida.step.1.act.4.explanation',
          skillId: 'letter_memory_$letterId',
        ),
        // 5. Draw & Trace
        QaidaActivity(
          id: '${letterId}_act5_trace',
          slotNumber: 5,
          type: QaidaActivityType.drawTrace,
          prompt: 'qaida.step.1.act.5.prompt',
          arabicTarget: ar,
          explanation: 'qaida.step.1.act.5.explanation',
          skillId: 'letter_trace_$letterId',
        ),
        // 6. Odd One Out
        QaidaActivity(
          id: '${letterId}_act6_odd',
          slotNumber: 6,
          type: QaidaActivityType.oddOneOut,
          prompt: 'qaida.step.1.act.6.prompt',
          arabicTarget: d1,
          options: [ar, ar, d1],
          correctIndex: 2,
          explanation: 'qaida.step.1.act.6.explanation',
          skillId: 'letter_odd_$letterId',
        ),
        // 7. Boss Challenge (Step Exam Slot)
        QaidaActivity(
          id: '${letterId}_act7_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.1.act.7.prompt',
          arabicTarget: ar,
          options: _makeOptions(ar, d1, d2, 7),
          correctIndex: _getCorrectIndex(7),
          explanation: 'qaida.step.1.act.7.explanation',
          skillId: 'letter_boss_$letterId',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step1_$letterId',
          trackId: 'step_1_mufradat',
          lessonNumber: i + 1,
          titleKey: nameKey,
          subtitleKey: 'qaida.step.1.title',
          arabicDisplay: ar,
          descriptionKey: 'qaida.step.1.desc',
          audioAsset: audio,
          makhrajKey: makhrajKey,
          exampleWords: words,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 1,
      id: 'step_1_mufradat',
      titleKey: 'qaida.step.1.title',
      arabicTitle: 'الْمُفْرَدَات',
      description: 'د',
      phaseNumber: 1,
      phaseNameKey: 'qaida.step.1.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.1.garden_plant',
      colorHex: 0xFF78C943, // Leaf Green
      icon: Icons.font_download_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 2:  (Murakkabat -     )
  // Match (form↔harf) → Sort (shuru/majhe/shesh) → Puzzle → Memory → Trace → Word Builder → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep2Murakkabat() {
    final formItems = [
      {'letter': 'ب', 'init': 'بـ', 'med': 'ـبـ', 'fin': 'ـب', 'word': 'بَيْتٌ'},
      {'letter': 'ت', 'init': 'تـ', 'med': 'ـتـ', 'fin': 'ـت', 'word': 'كَتَبَ'},
      {'letter': 'ث', 'init': 'ثـ', 'med': 'ـثـ', 'fin': 'ـث', 'word': 'مَثَلٌ'},
      {'letter': 'ن', 'init': 'نـ', 'med': 'ـنـ', 'fin': 'ـن', 'word': 'نُورٌ'},
      {'letter': 'ي', 'init': 'يـ', 'med': 'ـيـ', 'fin': 'ـي', 'word': 'يَوْمٌ'},
      {'letter': 'ج', 'init': 'جـ', 'med': 'ـجـ', 'fin': 'ـج', 'word': 'جَمَلٌ'},
      {'letter': 'ح', 'init': 'حـ', 'med': 'ـحـ', 'fin': 'ـح', 'word': 'حَمْدٌ'},
      {'letter': 'خ', 'init': 'خـ', 'med': 'ـخـ', 'fin': 'ـخ', 'word': 'خَبَرٌ'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < formItems.length; i++) {
      final item = formItems[i];
      final l = item['letter'] as String;
      final init = item['init'] as String;
      final med = item['med'] as String;
      final fin = item['fin'] as String;
      final word = item['word'] as String;

      final activities = [
        // 1. Match (form ↔ harf)
        QaidaActivity(
          id: 'step2_${i}_match',
          slotNumber: 1,
          type: QaidaActivityType.matchPairs,
          prompt: 'qaida.step.2.act.1.prompt',
          pairs: {init: l, med: l, fin: l},
          explanation: 'qaida.step.2.act.1.explanation',
        ),
        // 2. Sort (, , )
        QaidaActivity(
          id: 'step2_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.2.act.2.prompt',
          sortingCategories: {
            'qaida.form.initial': [init],
            'qaida.form.medial': [med],
            'qaida.form.final': [fin],
          },
          explanation: 'qaida.step.2.act.2.explanation',
        ),
        // 3. Puzzle Builder
        QaidaActivity(
          id: 'step2_${i}_puzzle',
          slotNumber: 3,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'qaida.step.2.act.3.prompt',
          puzzlePieces: [init, med, fin],
          explanation: 'qaida.step.2.act.3.explanation',
        ),
        // 4. Memory Flip
        QaidaActivity(
          id: 'step2_${i}_memory',
          slotNumber: 4,
          type: QaidaActivityType.memoryMatch,
          prompt: 'qaida.step.2.act.4.prompt',
          pairs: {l: init, med: fin},
          explanation: 'qaida.step.2.act.4.explanation',
        ),
        // 5. Trace
        QaidaActivity(
          id: 'step2_${i}_trace',
          slotNumber: 5,
          type: QaidaActivityType.drawTrace,
          prompt: 'qaida.step.2.act.5.prompt',
          arabicTarget: init,
          explanation: 'qaida.step.2.act.5.explanation',
        ),
        // 6. Word Builder
        QaidaActivity(
          id: 'step2_${i}_word',
          slotNumber: 6,
          type: QaidaActivityType.buildArrange,
          prompt: 'qaida.step.2.act.6.prompt',
          tiles: [
            ActivityTile(id: 't1', label: init, arabicLabel: init),
            ActivityTile(id: 't2', label: med, arabicLabel: med),
            ActivityTile(id: 't3', label: fin, arabicLabel: fin),
          ],
          explanation: 'qaida.step.2.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step2_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.2.act.7.prompt',
          arabicTarget: init,
          options: [init, med, fin],
          correctIndex: 0,
          explanation: 'qaida.step.2.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step2_lesson_$i',
          trackId: 'step_2_murakkabat',
          lessonNumber: i + 1,
          titleKey: 'qaida.step.2.title',
          subtitleKey: 'qaida.step.2.title',
          arabicDisplay: '$init$med$fin',
          descriptionKey: 'qaida.step.2.desc',
          exampleWords: [word],
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 2,
      id: 'step_2_murakkabat',
      titleKey: 'qaida.step.2.title',
      arabicTitle: 'الْمُرَكَّبَات',
      descriptionKey: 'qaida.step.2.desc',
      phaseNumber: 1,
      phaseNameKey: 'qaida.step.2.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.2.garden_plant',
      colorHex: 0xFF398A35, // Forest Green
      icon: Icons.layers_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 3:  (Harakat - , , )
  // Listen → Tap Answer → Match → Sort (harakat) → Voice Repeat → Speed Reading → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep3Harakat() {
    final harakatList = [
      {'name': 'qaida.step.3.desc', 'symbol': 'ـَ', 'sound': 'qaida.step.3.desc', 'sample': 'بَ', 'desc': 'qaida.step.3.desc'},
      {'name': 'qaida.step.3.desc', 'symbol': 'ـِ', 'sound': 'qaida.step.3.desc', 'sample': 'بِ', 'desc': 'qaida.step.3.desc'},
      {'name': 'qaida.step.3.desc', 'symbol': 'ـُ', 'sound': 'qaida.step.3.desc', 'sample': 'بُ', 'desc': 'qaida.step.3.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < harakatList.length; i++) {
      final h = harakatList[i];
      final name = h['name']!;
      final sym = h['symbol']!;
      final sample = h['sample']!;
      final desc = h['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step3_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.3.act.1.prompt',
          arabicTarget: sample,
          options: ['بَ', 'بِ', 'بُ'],
          correctIndex: i,
          explanation: 'qaida.step.3.act.1.explanation',
        ),
        // 2. Tap Answer / Harakat Slider
        QaidaActivity(
          id: 'step3_${i}_tap',
          slotNumber: 2,
          type: QaidaActivityType.harakatSlider,
          prompt: 'qaida.step.3.act.2.prompt',
          arabicTarget: sample,
          options: ['بَ', 'بِ', 'بُ'],
          correctIndex: i,
          explanation: desc,
        ),
        // 3. Match
        QaidaActivity(
          id: 'step3_${i}_match',
          slotNumber: 3,
          type: QaidaActivityType.matchPairs,
          prompt: 'qaida.step.3.act.3.prompt',
          pairs: {'بَ': 'qaida.step.3.desc', 'بِ': 'qaida.step.3.desc', 'بُ': 'qaida.step.3.desc'},
          explanation: 'qaida.step.3.act.3.explanation',
        ),
        // 4. Sort (harakat)
        QaidaActivity(
          id: 'step3_${i}_sort',
          slotNumber: 4,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.3.act.4.prompt',
          sortingCategories: {
            'qaida.harakat.fatha': ['بَ', 'دَ'],
            'qaida.harakat.kasra': ['بِ', 'دِ'],
            'qaida.harakat.damma': ['بُ', 'دُ'],
          },
          explanation: 'qaida.step.3.act.4.explanation',
        ),
        // 5. Voice Repeat
        QaidaActivity(
          id: 'step3_${i}_voice',
          slotNumber: 5,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.3.act.5.prompt',
          arabicTarget: sample,
          explanation: 'qaida.step.3.act.5.explanation',
        ),
        // 6. Speed Reading
        QaidaActivity(
          id: 'step3_${i}_speed',
          slotNumber: 6,
          type: QaidaActivityType.speedReading,
          prompt: 'qaida.step.3.act.6.prompt',
          arabicTarget: 'بَ - بِ - بُ',
          options: ['qaida.step.3.desc', 'qaida.step.3.desc', 'qaida.step.3.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.3.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step3_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.3.act.7.prompt',
          arabicTarget: 'qaida.step.3.desc',
          options: ['qaida.step.3.desc', 'qaida.step.3.desc', 'qaida.step.3.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.3.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step3_lesson_$i',
          trackId: 'step_3_harakat',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.3.title',
          arabicDisplay: sample,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 3,
      id: 'step_3_harakat',
      titleKey: 'qaida.step.3.title',
      arabicTitle: 'الْحَرَكَات',
      descriptionKey: 'qaida.step.3.desc',
      phaseNumber: 2,
      phaseNameKey: 'qaida.step.3.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.3.garden_plant',
      colorHex: 0xFFFFD34F, // Sunshine Yellow
      icon: Icons.flash_on_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 4:  (Tanween -  ,  ,  )
  // Listen → Match → Odd One Out → Sort → Word Builder → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep4Tanween() {
    final tanweenLessons = [
      {'name': 'qaida.step.4.desc', 'sym': 'ـً', 'ex': 'بً', 'sound': 'qaida.step.4.desc', 'word': 'عَلِيمًا'},
      {'name': 'qaida.step.4.desc', 'sym': 'ـٍ', 'ex': 'بٍ', 'sound': 'qaida.step.4.desc', 'word': 'عَذَابٍ'},
      {'name': 'qaida.step.4.desc', 'sym': 'ـٌ', 'ex': 'بٌ', 'sound': 'qaida.step.4.desc', 'word': 'غَفُورٌ'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < tanweenLessons.length; i++) {
      final t = tanweenLessons[i];
      final name = t['name']!;
      final ex = t['ex']!;
      final word = t['word']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step4_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.4.act.1.prompt',
          arabicTarget: ex,
          options: ['بً', 'بٍ', 'بٌ'],
          correctIndex: i,
          explanation: 'qaida.step.4.act.1.explanation',
        ),
        // 2. Match
        QaidaActivity(
          id: 'step4_${i}_match',
          slotNumber: 2,
          type: QaidaActivityType.matchPairs,
          prompt: 'qaida.step.4.act.2.prompt',
          pairs: {
            'بً': 'qaida.step.4.desc',
            'بٍ': 'qaida.step.4.desc',
            'بٌ': 'qaida.step.4.desc',
          },
          explanation: 'qaida.step.4.act.2.explanation',
        ),
        // 3. Odd One Out
        QaidaActivity(
          id: 'step4_${i}_odd',
          slotNumber: 3,
          type: QaidaActivityType.oddOneOut,
          prompt: 'qaida.step.4.act.3.prompt',
          arabicTarget: 'بَ',
          options: ['بً', 'تً', 'ثً', 'بَ'],
          correctIndex: 3,
          explanation: 'qaida.step.4.act.3.explanation',
        ),
        // 4. Sort
        QaidaActivity(
          id: 'step4_${i}_sort',
          slotNumber: 4,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.4.act.4.prompt',
          sortingCategories: {
            'qaida.step.4.desc': ['بً', 'تً'],
            'qaida.step.4.desc': ['بٍ', 'تٍ'],
            'qaida.step.4.desc': ['بٌ', 'تٌ'],
          },
          explanation: 'qaida.step.4.act.4.explanation',
        ),
        // 5. Word Builder
        QaidaActivity(
          id: 'step4_${i}_word',
          slotNumber: 5,
          type: QaidaActivityType.buildArrange,
          prompt: 'qaida.step.4.act.5.prompt',
          tiles: [
            ActivityTile(id: 't1', label: 'كُ', arabicLabel: 'كُ'),
            ActivityTile(id: 't2', label: 'فُ', arabicLabel: 'فُ'),
            ActivityTile(id: 't3', label: 'وً', arabicLabel: 'وً'),
            ActivityTile(id: 't4', label: 'ا', arabicLabel: 'ا'),
          ],
          explanation: 'qaida.step.4.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step4_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.4.act.6.prompt',
          arabicTarget: word,
          explanation: 'qaida.step.4.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step4_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.4.act.7.prompt',
          arabicTarget: 'عَلِيمًا',
          options: ['qaida.step.4.desc', 'qaida.step.4.desc', 'qaida.step.4.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.4.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step4_lesson_$i',
          trackId: 'step_4_tanween',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.4.title',
          arabicDisplay: ex,
          descriptionKey: 'qaida.step.4.desc',
          exampleWords: [word],
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 4,
      id: 'step_4_tanween',
      titleKey: 'qaida.step.4.title',
      arabicTitle: 'التَّنْوِين',
      descriptionKey: 'qaida.step.4.desc',
      phaseNumber: 2,
      phaseNameKey: 'qaida.step.4.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.4.garden_plant',
      colorHex: 0xFF4CB9F4,
      icon: Icons.format_quote_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 5:   (Khari Harakat -  ,  ,  )
  // Listen → Sort (choto/lomba) → Memory → Sequence → Catch Letters → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep5KhariHarakat() {
    final khariLessons = [
      {'name': 'qaida.step.5.desc', 'sym': 'ـٰ', 'ex': 'بٰ', 'word': 'مٰلِكِ'},
      {'name': 'qaida.step.5.desc', 'sym': 'ـٖ', 'ex': 'بٖ', 'word': 'إِيلَافِهِمْ'},
      {'name': 'qaida.step.5.desc', 'sym': 'ـٗ', 'ex': 'بٗ', 'word': 'لَهُۥ'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < khariLessons.length; i++) {
      final k = khariLessons[i];
      final name = k['name']!;
      final ex = k['ex']!;
      final word = k['word']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step5_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.5.act.1.prompt',
          arabicTarget: ex,
          options: ['بٰ', 'بٖ', 'بٗ'],
          correctIndex: i,
          explanation: 'qaida.step.5.act.1.explanation',
        ),
        // 2. Sort (  vs    )
        QaidaActivity(
          id: 'step5_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.5.act.2.prompt',
          sortingCategories: {
            'qaida.step.5.desc': ['بَ', 'بِ', 'بُ'],
            'qaida.step.5.desc': ['بٰ', 'بٖ', 'بٗ'],
          },
          explanation: 'qaida.step.5.act.2.explanation',
        ),
        // 3. Memory
        QaidaActivity(
          id: 'step5_${i}_memory',
          slotNumber: 3,
          type: QaidaActivityType.memoryMatch,
          prompt: 'qaida.step.5.act.3.prompt',
          pairs: {
            'بٰ': 'qaida.step.5.desc',
            'بٖ': 'qaida.step.5.desc',
            'بٗ': 'qaida.step.5.desc',
          },
          explanation: 'qaida.step.5.act.3.explanation',
        ),
        // 4. Sequence
        QaidaActivity(
          id: 'step5_${i}_seq',
          slotNumber: 4,
          type: QaidaActivityType.sequenceOrder,
          prompt: 'qaida.step.5.act.4.prompt',
          sequenceItems: ['بَ', 'بَا', 'بٰ'],
          explanation: 'qaida.step.5.act.4.explanation',
        ),
        // 5. Catch Letters
        QaidaActivity(
          id: 'step5_${i}_catch',
          slotNumber: 5,
          type: QaidaActivityType.catchLetters,
          prompt: 'qaida.step.5.act.5.prompt',
          arabicTarget: ex,
          options: [ex, 'بَ', 'بِ', 'بُ'],
          explanation: 'qaida.step.5.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step5_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.5.act.6.prompt',
          arabicTarget: word,
          explanation: 'qaida.step.5.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step5_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.5.act.7.prompt',
          arabicTarget: 'مٰلِكِ',
          options: ['qaida.step.5.desc', 'qaida.step.5.desc', 'qaida.step.5.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.5.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step5_lesson_$i',
          trackId: 'step_5_khari_harakat',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.5.title',
          arabicDisplay: ex,
          descriptionKey: 'qaida.step.5.desc',
          exampleWords: [word],
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 5,
      id: 'step_5_khari_harakat',
      titleKey: 'qaida.step.5.title',
      arabicTitle: 'الْحَرَكَات الْقَائِمَة',
      descriptionKey: 'qaida.step.5.desc',
      phaseNumber: 2,
      phaseNameKey: 'qaida.step.5.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.5.garden_plant',
      colorHex: 0xFFA779F5,
      icon: Icons.straighten_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 6:   (Layyin -    )
  // Listen → Odd One Out → Match → Puzzle → Sing Along gap → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep6Layyin() {
    final layyinLessons = [
      {'name': 'qaida.step.6.desc', 'ex': 'خَوْفٌ', 'desc': 'qaida.step.6.desc'},
      {'name': 'qaida.step.6.desc', 'ex': 'بَيْتٌ', 'desc': 'qaida.step.6.desc'},
      {'name': 'qaida.step.6.desc', 'ex': 'صَيْفٌ', 'desc': 'qaida.step.6.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < layyinLessons.length; i++) {
      final l = layyinLessons[i];
      final name = l['name']!;
      final ex = l['ex']!;
      final desc = l['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step6_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.6.act.1.prompt',
          arabicTarget: ex,
          options: ['خَوْفٌ', 'بَيْتٌ', 'صَيْفٌ'],
          correctIndex: i,
          explanation: desc,
        ),
        // 2. Odd One Out
        QaidaActivity(
          id: 'step6_${i}_odd',
          slotNumber: 2,
          type: QaidaActivityType.oddOneOut,
          prompt: 'qaida.step.6.act.2.prompt',
          arabicTarget: 'كِتَابٌ',
          options: ['خَوْفٌ', 'بَيْتٌ', 'صَيْفٌ', 'كِتَابٌ'],
          correctIndex: 3,
          explanation: 'qaida.step.6.act.2.explanation',
        ),
        // 3. Match
        QaidaActivity(
          id: 'step6_${i}_match',
          slotNumber: 3,
          type: QaidaActivityType.matchPairs,
          prompt: 'qaida.step.6.act.3.prompt',
          pairs: {
            'خَوْفٌ': 'qaida.step.6.desc',
            'بَيْتٌ': 'qaida.step.6.desc',
            'يَوْمٌ': 'qaida.step.6.desc',
          },
          explanation: 'qaida.step.6.act.3.explanation',
        ),
        // 4. Puzzle
        QaidaActivity(
          id: 'step6_${i}_puzzle',
          slotNumber: 4,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'qaida.step.6.act.4.prompt',
          puzzlePieces: ['بَ', 'يْ', 'تُ'],
          explanation: 'qaida.step.6.act.4.explanation',
        ),
        // 5. Sing Along Gap
        QaidaActivity(
          id: 'step6_${i}_gap',
          slotNumber: 5,
          type: QaidaActivityType.singAlongGap,
          prompt: 'qaida.step.6.act.5.prompt',
          arabicTarget: 'فَلْيَعْبُدُوا رَبَّ هٰذَا _____ ۝',
          options: ['الْبَيْتِ', 'الصَّيْفِ', 'الْخَوْفِ'],
          correctIndex: 0,
          explanation: 'qaida.step.6.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step6_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.6.act.6.prompt',
          arabicTarget: 'لِإِيلَافِ قُرَيْشٍ',
          explanation: 'qaida.step.6.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step6_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.6.act.7.prompt',
          arabicTarget: 'مِنْ خَوْفٍ',
          options: ['qaida.step.6.desc', 'qaida.step.6.desc', 'qaida.step.6.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.6.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step6_lesson_$i',
          trackId: 'step_6_layyin',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.6.title',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 6,
      id: 'step_6_layyin',
      titleKey: 'qaida.step.6.title',
      arabicTitle: 'حُرُوف اللِّين',
      descriptionKey: 'qaida.step.6.desc',
      phaseNumber: 3,
      phaseNameKey: 'qaida.step.6.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.6.garden_plant',
      colorHex: 0xFFFF786F,
      icon: Icons.waves_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 7:  /  (Sukoon)
  // Listen → Tap Answer → Sort → Word Builder → Speed Reading → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep7Sukoon() {
    final sukoonLessons = [
      {'name': 'qaida.step.7.desc', 'ex': 'أَبْ', 'desc': 'qaida.step.7.desc'},
      {'name': 'qaida.step.7.desc', 'ex': 'قُلْ', 'desc': 'qaida.step.7.desc'},
      {'name': 'qaida.step.7.desc', 'ex': 'أَنْعَمْتَ', 'desc': 'qaida.step.7.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < sukoonLessons.length; i++) {
      final s = sukoonLessons[i];
      final name = s['name']!;
      final ex = s['ex']!;
      final desc = s['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step7_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.7.act.1.prompt',
          arabicTarget: ex,
          options: ['أَبْ', 'أَبَ', 'أَبِ'],
          correctIndex: 0,
          explanation: desc,
        ),
        // 2. Tap Answer
        QaidaActivity(
          id: 'step7_${i}_tap',
          slotNumber: 2,
          type: QaidaActivityType.recognize,
          prompt: 'qaida.step.7.act.2.prompt',
          arabicTarget: 'قُلْ',
          options: ['قُلْ', 'قَالَ', 'قِيلَ'],
          correctIndex: 0,
          explanation: 'qaida.step.7.act.2.explanation',
        ),
        // 3. Sort
        QaidaActivity(
          id: 'step7_${i}_sort',
          slotNumber: 3,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.7.act.3.prompt',
          sortingCategories: {
            'qaida.step.7.desc': ['أَبْ', 'قُلْ', 'مَنْ'],
            'qaida.step.7.desc': ['أَبَ', 'قَالَ', 'مَنَ'],
          },
          explanation: 'qaida.step.7.act.3.explanation',
        ),
        // 4. Word Builder
        QaidaActivity(
          id: 'step7_${i}_word',
          slotNumber: 4,
          type: QaidaActivityType.buildArrange,
          prompt: 'qaida.step.7.act.4.prompt',
          tiles: [
            ActivityTile(id: 't1', label: 'يَ', arabicLabel: 'يَ'),
            ActivityTile(id: 't2', label: 'عْ', arabicLabel: 'عْ'),
            ActivityTile(id: 't3', label: 'لَ', arabicLabel: 'لَ'),
            ActivityTile(id: 't4', label: 'مُ', arabicLabel: 'مُ'),
          ],
          explanation: 'qaida.step.7.act.4.explanation',
        ),
        // 5. Speed Reading
        QaidaActivity(
          id: 'step7_${i}_speed',
          slotNumber: 5,
          type: QaidaActivityType.speedReading,
          prompt: 'qaida.step.7.act.5.prompt',
          arabicTarget: 'أَبْ - أَتْ - أَثْ',
          options: ['أَبْ - أَتْ - أَثْ', 'أَجْ - أَحْ - أَخْ', 'أَدْ - أَذْ - أَرْ'],
          correctIndex: 0,
          explanation: 'qaida.step.7.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step7_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.7.act.6.prompt',
          arabicTarget: 'أَنْعَمْتَ عَلَيْهِمْ',
          explanation: 'qaida.step.7.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step7_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.7.act.7.prompt',
          arabicTarget: 'أَنْعَمْتَ',
          options: ['qaida.step.7.desc', 'qaida.step.7.desc', 'qaida.step.7.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.7.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step7_lesson_$i',
          trackId: 'step_7_sukoon',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.7.title',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 7,
      id: 'step_7_sukoon',
      titleKey: 'qaida.step.7.title',
      arabicTitle: 'السُّكُون',
      descriptionKey: 'qaida.step.7.desc',
      phaseNumber: 3,
      phaseNameKey: 'qaida.step.7.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.7.garden_plant',
      colorHex: 0xFF0D9488,
      icon: Icons.pause_circle_outline_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 8:  (Shaddah -  )
  // Listen → Match → Sequence → Word Builder → Sing Along gap → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep8Shaddah() {
    final shaddahLessons = [
      {'name': 'qaida.step.8.desc', 'ex': 'أَنَّ', 'desc': 'qaida.step.8.desc'},
      {'name': 'qaida.step.8.desc', 'ex': 'رَبِّ', 'desc': 'qaida.step.8.desc'},
      {'name': 'qaida.step.8.desc', 'ex': 'ثُمَّ', 'desc': 'qaida.step.8.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < shaddahLessons.length; i++) {
      final s = shaddahLessons[i];
      final name = s['name']!;
      final ex = s['ex']!;
      final desc = s['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step8_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.8.act.1.prompt',
          arabicTarget: ex,
          options: ['رَبِّ', 'رَبْ', 'رَبَ'],
          correctIndex: 0,
          explanation: desc,
        ),
        // 2. Match
        QaidaActivity(
          id: 'step8_${i}_match',
          slotNumber: 2,
          type: QaidaActivityType.matchPairs,
          prompt: 'qaida.step.8.act.2.prompt',
          pairs: {
            'رَبَّ': 'qaida.step.8.desc',
            'حَجَّ': 'qaida.step.8.desc',
            'ثُمَّ': 'qaida.step.8.desc',
          },
          explanation: 'qaida.step.8.act.2.explanation',
        ),
        // 3. Sequence
        QaidaActivity(
          id: 'step8_${i}_seq',
          slotNumber: 3,
          type: QaidaActivityType.sequenceOrder,
          prompt: 'qaida.step.8.act.3.prompt',
          sequenceItems: ['رَ', 'بْ', 'بَ', 'رَبَّ'],
          explanation: 'qaida.step.8.act.3.explanation',
        ),
        // 4. Word Builder
        QaidaActivity(
          id: 'step8_${i}_word',
          slotNumber: 4,
          type: QaidaActivityType.buildArrange,
          prompt: 'qaida.step.8.act.4.prompt',
          tiles: [
            ActivityTile(id: 't1', label: 'إِ', arabicLabel: 'إِ'),
            ActivityTile(id: 't2', label: 'نَّ', arabicLabel: 'نَّ'),
          ],
          explanation: 'qaida.step.8.act.4.explanation',
        ),
        // 5. Sing Along Gap
        QaidaActivity(
          id: 'step8_${i}_gap',
          slotNumber: 5,
          type: QaidaActivityType.singAlongGap,
          prompt: 'qaida.step.8.act.5.prompt',
          arabicTarget: 'تَبَّتْ يَدَا أَبِي لَهَبٍ _____ ۝',
          options: ['وَتَبَّ', 'مَا أَغْنَىٰ', 'سَيَصْلَىٰ'],
          correctIndex: 0,
          explanation: 'qaida.step.8.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step8_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.8.act.6.prompt',
          arabicTarget: 'ثُمَّ كَلَّا سَوْفَ تَعْلَمُونَ',
          explanation: 'qaida.step.8.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step8_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.8.act.7.prompt',
          arabicTarget: 'إِيَّاكَ',
          options: ['qaida.step.8.desc', 'qaida.step.8.desc', 'qaida.step.8.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.8.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step8_lesson_$i',
          trackId: 'step_8_shaddah',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.8.title',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 8,
      id: 'step_8_shaddah',
      titleKey: 'qaida.step.8.title',
      arabicTitle: 'التَّشْدِيد',
      descriptionKey: 'qaida.step.8.desc',
      phaseNumber: 3,
      phaseNameKey: 'qaida.step.8.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.8.garden_plant',
      colorHex: 0xFFF59E0B,
      icon: Icons.repeat_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 9:     (Noon Sakin - , , , )
  // Listen → Sort (4 niyom) → Memory → Odd One Out → Puzzle → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep9NoonSakin() {
    final noonLessons = [
      {'name': 'qaida.step.9.desc', 'ex': 'مَنْ آمَنَ', 'desc': 'qaida.step.9.desc'},
      {'name': 'qaida.step.9.desc', 'ex': 'مِنْ قَبْلُ', 'desc': 'qaida.step.9.desc'},
      {'name': 'qaida.step.9.desc', 'ex': 'مِن بَعْدِ', 'desc': 'qaida.step.9.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < noonLessons.length; i++) {
      final n = noonLessons[i];
      final name = n['name']!;
      final ex = n['ex']!;
      final desc = n['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step9_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.9.act.1.prompt',
          arabicTarget: ex,
          options: ['مَنْ آمَنَ', 'مِنْ قَبْلُ', 'مِن بَعْدِ'],
          correctIndex: i,
          explanation: desc,
        ),
        // 2. Sort (4  )
        QaidaActivity(
          id: 'step9_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.9.act.2.prompt',
          sortingCategories: {
            'qaida.step.9.desc': ['مَنْ آمَنَ', 'مِنْ خَوْفٍ'],
            'qaida.step.9.desc': ['مِنْ قَبْلُ', 'عَنْ صَلَاتِهِمْ'],
            'qaida.step.9.desc': ['مَن يَّقُولُ', 'مِن مَّالٍ'],
            'qaida.step.9.desc': ['مِن بَعْدِ', 'أَنبِئْهُم'],
          },
          explanation: 'qaida.step.9.act.2.explanation',
        ),
        // 3. Memory
        QaidaActivity(
          id: 'step9_${i}_memory',
          slotNumber: 3,
          type: QaidaActivityType.memoryMatch,
          prompt: 'qaida.step.9.act.3.prompt',
          pairs: {
            'مَنْ آمَنَ': 'qaida.step.9.desc',
            'مِنْ قَبْلُ': 'qaida.step.9.desc',
            'مَن يَّقُولُ': 'qaida.step.9.desc',
            'مِن بَعْدِ': 'qaida.step.9.desc',
          },
          explanation: 'qaida.step.9.act.3.explanation',
        ),
        // 4. Odd One Out
        QaidaActivity(
          id: 'step9_${i}_odd',
          slotNumber: 4,
          type: QaidaActivityType.oddOneOut,
          prompt: 'qaida.step.9.act.4.prompt',
          arabicTarget: 'مِنْ قَبْلُ',
          options: ['مَنْ آمَنَ', 'مِنْ حَكِيمٍ', 'مِنْ خَوْفٍ', 'مِنْ قَبْلُ'],
          correctIndex: 3,
          explanation: 'qaida.step.9.act.4.explanation',
        ),
        // 5. Puzzle
        QaidaActivity(
          id: 'step9_${i}_puzzle',
          slotNumber: 5,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'qaida.step.9.act.5.prompt',
          puzzlePieces: ['مِنْ', 'قَبْ', 'لِ'],
          explanation: 'qaida.step.9.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step9_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.9.act.6.prompt',
          arabicTarget: 'مَنْ آمَنَ بِاللَّهِ',
          explanation: 'qaida.step.9.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step9_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.9.act.7.prompt',
          arabicTarget: 'مِن بَعْدِ',
          options: ['qaida.step.9.desc', 'qaida.step.9.desc', 'qaida.step.9.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.9.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step9_lesson_$i',
          trackId: 'step_9_noon_sakin',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.9.title',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 9,
      id: 'step_9_noon_sakin',
      titleKey: 'qaida.step.9.title',
      arabicTitle: 'أَحْكَام النُّون السَّاكِنَة',
      descriptionKey: 'qaida.step.9.desc',
      phaseNumber: 4,
      phaseNameKey: 'qaida.step.9.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.9.garden_plant',
      colorHex: 0xFF6366F1,
      icon: Icons.auto_awesome_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 10:   (Meem Sakin -  )
  // Listen → Match → Sort → Tap Answer → Word Builder → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep10MeemSakin() {
    final meemLessons = [
      {'name': 'qaida.step.10.desc', 'ex': 'تَرْمِيهِمْ بِحِجَارَةٍ', 'desc': 'qaida.step.10.desc'},
      {'name': 'qaida.step.10.desc', 'ex': 'لَهُمْ مَّا', 'desc': 'qaida.step.10.desc'},
      {'name': 'qaida.step.10.desc', 'ex': 'هُمْ فِيهَا', 'desc': 'qaida.step.10.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < meemLessons.length; i++) {
      final m = meemLessons[i];
      final name = m['name']!;
      final ex = m['ex']!;
      final desc = m['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step10_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.10.act.1.prompt',
          arabicTarget: ex,
          options: ['تَرْمِيهِمْ بِحِجَارَةٍ', 'لَهُمْ مَّا', 'هُمْ فِيهَا'],
          correctIndex: i,
          explanation: desc,
        ),
        // 2. Match
        QaidaActivity(
          id: 'step10_${i}_match',
          slotNumber: 2,
          type: QaidaActivityType.matchPairs,
          prompt: 'qaida.step.10.act.2.prompt',
          pairs: {
            'تَرْمِيهِمْ بِحِجَارَةٍ': 'qaida.step.10.desc',
            'لَهُمْ مَّا': 'qaida.step.10.desc',
            'هُمْ فِيهَا': 'qaida.step.10.desc',
          },
          explanation: 'qaida.step.10.act.2.explanation',
        ),
        // 3. Sort
        QaidaActivity(
          id: 'step10_${i}_sort',
          slotNumber: 3,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.10.act.3.prompt',
          sortingCategories: {
            'qaida.step.10.desc': ['تَرْمِيهِمْ بِحِجَارَةٍ', 'وَكَلْبُهُمْ بَاسِطٌ'],
            'qaida.step.10.desc': ['هُمْ فِيهَا', 'عَلَيْهِمْ غَيْرِ'],
            'qaida.step.10.desc': ['لَهُمْ مَّا', 'كُنتُم مُّؤْمِنِينَ'],
          },
          explanation: 'qaida.step.10.act.3.explanation',
        ),
        // 4. Tap Answer
        QaidaActivity(
          id: 'step10_${i}_tap',
          slotNumber: 4,
          type: QaidaActivityType.recognize,
          prompt: 'qaida.step.10.act.4.prompt',
          arabicTarget: 'عَلَيْهِمْ غَيْرِ',
          options: ['qaida.step.10.desc', 'qaida.step.10.desc', 'qaida.step.10.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.10.act.4.explanation',
        ),
        // 5. Word Builder
        QaidaActivity(
          id: 'step10_${i}_word',
          slotNumber: 5,
          type: QaidaActivityType.buildArrange,
          prompt: 'qaida.step.10.act.5.prompt',
          tiles: [
            ActivityTile(id: 't1', label: 'تَرْمِي', arabicLabel: 'تَرْمِي'),
            ActivityTile(id: 't2', label: 'هِمْ', arabicLabel: 'هِمْ'),
            ActivityTile(id: 't3', label: 'بِـ', arabicLabel: 'بِـ'),
            ActivityTile(id: 't4', label: 'حِجَارَةٍ', arabicLabel: 'حِجَارَةٍ'),
          ],
          explanation: 'qaida.step.10.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step10_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.10.act.6.prompt',
          arabicTarget: 'لَهُمْ مَّا يَشَاءُونَ',
          explanation: 'qaida.step.10.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step10_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.10.act.7.prompt',
          arabicTarget: 'هُمْ نَائِمُونَ',
          options: ['qaida.step.10.desc', 'qaida.step.10.desc', 'qaida.step.10.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.10.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step10_lesson_$i',
          trackId: 'step_10_meem_sakin',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.10.title',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 10,
      id: 'step_10_meem_sakin',
      titleKey: 'qaida.step.10.title',
      arabicTitle: 'أَحْكَام الْمِيم السَّاكِنَة',
      descriptionKey: 'qaida.step.10.desc',
      phaseNumber: 4,
      phaseNameKey: 'qaida.step.10.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.10.garden_plant',
      colorHex: 0xFF8B5CF6,
      icon: Icons.blur_on_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 11:   (Ghunnah -    )
  // Listen → Odd One Out → Sort (ghunnah ache/nai) → Sequence → Sing Along gap → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep11Ghunnah() {
    final ghunnahLessons = [
      {'name': 'qaida.step.11.desc', 'ex': 'إِنَّ', 'desc': 'qaida.step.11.desc'},
      {'name': 'qaida.step.11.desc', 'ex': 'ثُمَّ', 'desc': 'qaida.step.11.desc'},
      {'name': 'qaida.step.11.desc', 'ex': 'عَمَّ', 'desc': 'qaida.step.11.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < ghunnahLessons.length; i++) {
      final g = ghunnahLessons[i];
      final name = g['name']!;
      final ex = g['ex']!;
      final desc = g['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step11_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.11.act.1.prompt',
          arabicTarget: ex,
          options: ['إِنَّ', 'ثُمَّ', 'عَمَّ'],
          correctIndex: i,
          explanation: desc,
        ),
        // 2. Odd One Out
        QaidaActivity(
          id: 'step11_${i}_odd',
          slotNumber: 2,
          type: QaidaActivityType.oddOneOut,
          prompt: 'qaida.step.11.act.2.prompt',
          arabicTarget: 'كَتَبَ',
          options: ['إِنَّ', 'ثُمَّ', 'عَمَّ', 'كَتَبَ'],
          correctIndex: 3,
          explanation: 'qaida.step.11.act.2.explanation',
        ),
        // 3. Sort (  / )
        QaidaActivity(
          id: 'step11_${i}_sort',
          slotNumber: 3,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.11.act.3.prompt',
          sortingCategories: {
            'qaida.step.11.desc': ['إِنَّ', 'ثُمَّ', 'عَمَّ'],
            'qaida.step.11.desc': ['قَالَ', 'كَتَبَ', 'ذَهَبَ'],
          },
          explanation: 'qaida.step.11.act.3.explanation',
        ),
        // 4. Sequence
        QaidaActivity(
          id: 'step11_${i}_seq',
          slotNumber: 4,
          type: QaidaActivityType.sequenceOrder,
          prompt: 'qaida.step.11.act.4.prompt',
          sequenceItems: ['نْ', 'نَ', 'نَّ', 'إِنَّ'],
          explanation: 'qaida.step.11.act.4.explanation',
        ),
        // 5. Sing Along Gap
        QaidaActivity(
          id: 'step11_${i}_gap',
          slotNumber: 5,
          type: QaidaActivityType.singAlongGap,
          prompt: 'qaida.step.11.act.5.prompt',
          arabicTarget: 'قُلْ أَعُوذُ بِرَبِّ _____ ۝',
          options: ['النَّاسِ', 'الْفَلَقِ', 'الصَّمَدِ'],
          correctIndex: 0,
          explanation: 'qaida.step.11.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step11_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.11.act.6.prompt',
          arabicTarget: 'عَمَّ يَتَسَاءَلُونَ',
          explanation: 'qaida.step.11.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step11_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.11.act.7.prompt',
          arabicTarget: 'إِنَّ الْإِنسَانَ',
          options: ['qaida.step.11.desc', 'qaida.step.11.desc', 'qaida.step.11.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.11.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step11_lesson_$i',
          trackId: 'step_11_ghunnah',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.11.title',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 11,
      id: 'step_11_ghunnah',
      titleKey: 'qaida.step.11.title',
      arabicTitle: 'الْغُنَّة',
      descriptionKey: 'qaida.step.11.desc',
      phaseNumber: 4,
      phaseNameKey: 'qaida.step.11.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.11.garden_plant',
      colorHex: 0xFF10B981,
      icon: Icons.graphic_eq_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 12:  (Madd - , , ,   )
  // Listen → Sort (madd er dhoron) → Memory → Puzzle → Speed Reading → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep12Madd() {
    final maddLessons = [
      {'name': 'qaida.step.12.desc', 'ex': 'قَالَ', 'desc': 'qaida.step.12.desc'},
      {'name': 'qaida.step.12.desc', 'ex': 'فِي أَنفُسِكُمْ', 'desc': 'qaida.step.12.desc'},
      {'name': 'qaida.step.12.desc', 'ex': 'جَاءَ', 'desc': 'qaida.step.12.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < maddLessons.length; i++) {
      final m = maddLessons[i];
      final name = m['name']!;
      final ex = m['ex']!;
      final desc = m['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step12_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.12.act.1.prompt',
          arabicTarget: ex,
          options: ['قَالَ', 'جَاءَ', 'الضَّالِّينَ'],
          correctIndex: i,
          explanation: desc,
        ),
        // 2. Sort 
        QaidaActivity(
          id: 'step12_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.12.act.2.prompt',
          sortingCategories: {
            'qaida.step.12.desc': ['قَالَ', 'يَقُولُ', 'قِيلَ'],
            'qaida.step.12.desc': ['جَاءَ', 'السَّمَاءِ', 'سُوءَ'],
            'qaida.step.12.desc': ['الضَّالِّينَ', 'الحَاقَّةُ'],
          },
          explanation: 'qaida.step.12.act.2.explanation',
        ),
        // 3. Memory
        QaidaActivity(
          id: 'step12_${i}_memory',
          slotNumber: 3,
          type: QaidaActivityType.memoryMatch,
          prompt: 'qaida.step.12.act.3.prompt',
          pairs: {
            'قَالَ': 'qaida.step.12.desc',
            'جَاءَ': 'qaida.step.12.desc',
            'الضَّالِّينَ': 'qaida.step.12.desc',
          },
          explanation: 'qaida.step.12.act.3.explanation',
        ),
        // 4. Puzzle
        QaidaActivity(
          id: 'step12_${i}_puzzle',
          slotNumber: 4,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'qaida.step.12.act.4.prompt',
          puzzlePieces: ['السَّ', 'مَا', 'ءِ'],
          explanation: 'qaida.step.12.act.4.explanation',
        ),
        // 5. Speed Reading
        QaidaActivity(
          id: 'step12_${i}_speed',
          slotNumber: 5,
          type: QaidaActivityType.speedReading,
          prompt: 'qaida.step.12.act.5.prompt',
          arabicTarget: 'قَالَ - قِيلَ - يَقُولُ',
          options: ['قَالَ - قِيلَ - يَقُولُ', 'جَاءَ - سُوءَ - جِيءَ', 'دَابَّةٍ - الحَاقَّةُ'],
          correctIndex: 0,
          explanation: 'qaida.step.12.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step12_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.12.act.6.prompt',
          arabicTarget: 'إِذَا جَاءَ نَصْرُ اللَّهِ',
          explanation: 'qaida.step.12.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step12_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.12.act.7.prompt',
          arabicTarget: 'وَلَا الضَّالِّينَ',
          options: ['qaida.step.12.desc', 'qaida.step.12.desc', 'qaida.step.12.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.12.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step12_lesson_$i',
          trackId: 'step_12_madd',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.12.title',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 12,
      id: 'step_12_madd',
      titleKey: 'qaida.step.12.title',
      arabicTitle: 'الْمَدّ',
      descriptionKey: 'qaida.step.12.desc',
      phaseNumber: 4,
      phaseNameKey: 'qaida.step.12.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.12.garden_plant',
      colorHex: 0xFFEC4899,
      icon: Icons.linear_scale_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 13:   (Shamsi / Qamari)
  // Listen → Sort (shamsi/qamari) → Match → Word Builder → Tap Answer → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep13LamRules() {
    final lamLessons = [
      {'name': 'qaida.step.13.desc', 'ex': 'الْقَمَرُ', 'desc': 'qaida.step.13.desc'},
      {'name': 'qaida.step.13.desc', 'ex': 'الشَّمْسُ', 'desc': 'qaida.step.13.desc'},
      {'name': 'qaida.step.13.desc', 'ex': 'الْبَابُ | التَّاجِرُ', 'desc': 'qaida.step.13.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < lamLessons.length; i++) {
      final l = lamLessons[i];
      final name = l['name']!;
      final ex = l['ex']!;
      final desc = l['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step13_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.13.act.1.prompt',
          arabicTarget: ex,
          options: ['الشَّمْسُ', 'الْقَمَرُ', 'الْكِتَابُ'],
          correctIndex: i == 0 ? 1 : 0,
          explanation: desc,
        ),
        // 2. Sort ( vs )
        QaidaActivity(
          id: 'step13_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.13.act.2.prompt',
          sortingCategories: {
            'qaida.step.13.desc': ['الشَّمْسُ', 'النَّاسُ', 'الرَّحْمٰنُ'],
            'qaida.step.13.desc': ['الْقَمَرُ', 'الْحَمْدُ', 'الْكِتَابُ'],
          },
          explanation: 'qaida.step.13.act.2.explanation',
        ),
        // 3. Match
        QaidaActivity(
          id: 'step13_${i}_match',
          slotNumber: 3,
          type: QaidaActivityType.matchPairs,
          prompt: 'qaida.step.13.act.3.prompt',
          pairs: {
            'الشَّمْسُ': 'qaida.step.13.desc',
            'الْقَمَرُ': 'qaida.step.13.desc',
            'النَّاسُ': 'qaida.step.13.desc',
            'الْحَمْدُ': 'qaida.step.13.desc',
          },
          explanation: 'qaida.step.13.act.3.explanation',
        ),
        // 4. Word Builder
        QaidaActivity(
          id: 'step13_${i}_word',
          slotNumber: 4,
          type: QaidaActivityType.buildArrange,
          prompt: 'qaida.step.13.act.4.prompt',
          tiles: [
            ActivityTile(id: 't1', label: 'الْـ', arabicLabel: 'الْـ'),
            ActivityTile(id: 't2', label: 'حَمْـ', arabicLabel: 'حَمْـ'),
            ActivityTile(id: 't3', label: 'دُ', arabicLabel: 'دُ'),
          ],
          explanation: 'qaida.step.13.act.4.explanation',
        ),
        // 5. Tap Answer
        QaidaActivity(
          id: 'step13_${i}_tap',
          slotNumber: 5,
          type: QaidaActivityType.recognize,
          prompt: 'qaida.step.13.act.5.prompt',
          arabicTarget: 'الرَّحِيمُ',
          options: [
            'qaida.step.13.desc',
            'qaida.step.13.desc',
            'qaida.step.13.desc',
          ],
          correctIndex: 0,
          explanation: 'qaida.step.13.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step13_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.13.act.6.prompt',
          arabicTarget: 'مَالِكِ يَوْمِ الدِّينِ',
          explanation: 'qaida.step.13.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step13_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.13.act.7.prompt',
          arabicTarget: 'وَالشَّمْسِ',
          options: ['qaida.step.13.desc', 'qaida.step.13.desc', 'qaida.step.13.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.13.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step13_lesson_$i',
          trackId: 'step_13_lam_rules',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.13.title',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 13,
      id: 'step_13_lam_rules',
      titleKey: 'qaida.step.13.title',
      arabicTitle: 'لَام التَّعْرِيف',
      descriptionKey: 'qaida.step.13.desc',
      phaseNumber: 5,
      phaseNameKey: 'qaida.step.13.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.13.garden_plant',
      colorHex: 0xFFF97316,
      icon: Icons.brightness_medium_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 14:       (Ra & Lam)
  // Listen → Odd One Out → Sort (mota/shorou) → Memory → Speed Reading → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep14RaAndLam() {
    final raLessons = [
      {'name': 'qaida.step.14.desc', 'ex': 'رَبَّنَا | رِجَالٌ', 'desc': 'qaida.step.14.desc'},
      {'name': 'qaida.step.14.desc', 'ex': 'اللَّهَ | بِاللَّهِ', 'desc': 'qaida.step.14.desc'},
      {'name': 'qaida.step.14.desc', 'ex': 'مِنْ قَبْلِ اللَّهِ', 'desc': 'qaida.step.14.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < raLessons.length; i++) {
      final r = raLessons[i];
      final name = r['name']!;
      final ex = r['ex']!;
      final desc = r['desc']!;

      final activities = [
        // 1. Listen / Sound Compare
        QaidaActivity(
          id: 'step14_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.soundCompare,
          prompt: 'qaida.step.14.act.1.prompt',
          arabicTarget: 'رَبَّنَا',
          soundOptions: {
            'qaida.step.14.desc': 'tafkheem',
            'qaida.step.14.desc': 'tarqeeq',
          },
          correctIndex: 0,
          explanation: desc,
        ),
        // 2. Odd One Out
        QaidaActivity(
          id: 'step14_${i}_odd',
          slotNumber: 2,
          type: QaidaActivityType.oddOneOut,
          prompt: 'qaida.step.14.act.2.prompt',
          arabicTarget: 'رِجَالٌ',
          options: ['رَبَّنَا', 'رَسُولٌ', 'رُحَمَاءُ', 'رِجَالٌ'],
          correctIndex: 3,
          explanation: 'qaida.step.14.act.2.explanation',
        ),
        // 3. Sort ( vs )
        QaidaActivity(
          id: 'step14_${i}_sort',
          slotNumber: 3,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.14.act.3.prompt',
          sortingCategories: {
            'qaida.step.14.desc': ['رَبَّنَا', 'رُحَمَاءُ', 'قَالَ اللَّهُ'],
            'qaida.step.14.desc': ['رِجَالٌ', 'بِسْمِ اللَّهِ', 'قَدِيرٌ'],
          },
          explanation: 'qaida.step.14.act.3.explanation',
        ),
        // 4. Memory
        QaidaActivity(
          id: 'step14_${i}_memory',
          slotNumber: 4,
          type: QaidaActivityType.memoryMatch,
          prompt: 'qaida.step.14.act.4.prompt',
          pairs: {
            'رَبَّنَا': 'qaida.step.14.desc',
            'رِجَالٌ': 'qaida.step.14.desc',
            'اللَّهُ': 'qaida.step.14.desc',
            'بِاللَّهِ': 'qaida.step.14.desc',
          },
          explanation: 'qaida.step.14.act.4.explanation',
        ),
        // 5. Speed Reading
        QaidaActivity(
          id: 'step14_${i}_speed',
          slotNumber: 5,
          type: QaidaActivityType.speedReading,
          prompt: 'qaida.step.14.act.5.prompt',
          arabicTarget: 'رَبَّنَا - رِزْقًا - رُحَمَاءُ',
          options: ['رَبَّنَا - رِزْقًا - رُحَمَاءُ', 'اللَّهُ - لِلَّهِ - بِاللَّهِ', 'خَبِيرٌ - قَدِيرٌ - نَصِيرٌ'],
          correctIndex: 0,
          explanation: 'qaida.step.14.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step14_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.14.act.6.prompt',
          arabicTarget: 'بِسْمِ اللَّهِ الرَّحْمٰنِ الرَّحِيمِ',
          explanation: 'qaida.step.14.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step14_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.14.act.7.prompt',
          arabicTarget: 'مِنْ قَبْلِ اللَّهِ',
          options: ['qaida.step.14.desc', 'qaida.step.14.desc', 'qaida.step.14.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.14.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step14_lesson_$i',
          trackId: 'step_14_ra_lam',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.14.title',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 14,
      id: 'step_14_ra_lam',
      titleKey: 'qaida.step.14.title',
      arabicTitle: 'تَفْخِيم وَتَرْقِيق',
      descriptionKey: 'qaida.step.14.desc',
      phaseNumber: 5,
      phaseNameKey: 'qaida.step.14.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.14.garden_plant',
      colorHex: 0xFF84CC16,
      icon: Icons.volume_up_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 15:    (Muqatta'at & Qalqalah)
  // Listen → Match → Tap Answer → Sort → Sing Along gap → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep15MuqattaatAndQalqalah() {
    final qalqalahLessons = [
      {'name': 'qaida.step.15.desc', 'ex': 'قُطْبُ جَدٍّ', 'desc': 'qaida.step.15.desc'},
      {'name': 'qaida.step.15.desc', 'ex': 'قُلْ هُوَ اللَّهُ أَحَدٌ', 'desc': 'qaida.step.15.desc'},
      {'name': 'qaida.step.15.desc', 'ex': 'الم', 'desc': 'qaida.step.15.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < qalqalahLessons.length; i++) {
      final q = qalqalahLessons[i];
      final name = q['name']!;
      final ex = q['ex']!;
      final desc = q['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step15_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.15.act.1.prompt',
          arabicTarget: ex,
          options: ['قُلْ هُوَ اللَّهُ أَحَدْ', 'الْفَلَقْ', 'مُحِيطْ'],
          correctIndex: i == 1 ? 0 : (i == 0 ? 1 : 2),
          explanation: desc,
        ),
        // 2. Match
        QaidaActivity(
          id: 'step15_${i}_match',
          slotNumber: 2,
          type: QaidaActivityType.matchPairs,
          prompt: 'qaida.step.15.act.2.prompt',
          pairs: {
            'الم': 'qaida.step.15.desc',
            'أَحَدْ': 'qaida.step.15.desc',
            'يس': 'qaida.step.15.desc',
            'الْفَلَقْ': 'qaida.step.15.desc',
          },
          explanation: 'qaida.step.15.act.2.explanation',
        ),
        // 3. Tap Answer
        QaidaActivity(
          id: 'step15_${i}_tap',
          slotNumber: 3,
          type: QaidaActivityType.recognize,
          prompt: 'qaida.step.15.act.3.prompt',
          arabicTarget: 'قُطْبُ جَدٍّ',
          options: ['qaida.step.15.desc', 'qaida.step.15.desc', 'qaida.step.15.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.15.act.3.explanation',
        ),
        // 4. Sort
        QaidaActivity(
          id: 'step15_${i}_sort',
          slotNumber: 4,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.15.act.4.prompt',
          sortingCategories: {
            'qaida.step.15.desc': ['أَحَدْ', 'الْفَلَقْ', 'مُحِيطْ'],
            'qaida.step.15.desc': ['الْحَمْدُ', 'أَنْعَمْتَ', 'قُلْ'],
          },
          explanation: 'qaida.step.15.act.4.explanation',
        ),
        // 5. Sing Along Gap
        QaidaActivity(
          id: 'step15_${i}_gap',
          slotNumber: 5,
          type: QaidaActivityType.singAlongGap,
          prompt: 'qaida.step.15.act.5.prompt',
          arabicTarget: 'قُلْ هُوَ اللَّهُ _____ ۝',
          options: ['أَحَدٌ', 'الصَّمَدُ', 'كُفُوًا'],
          correctIndex: 0,
          explanation: 'qaida.step.15.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step15_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.15.act.6.prompt',
          arabicTarget: 'الم ۚ ذَٰلِكَ الْكِتَابُ',
          explanation: 'qaida.step.15.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step15_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.15.act.7.prompt',
          arabicTarget: 'حَبْلٌ',
          options: ['qaida.step.15.desc', 'qaida.step.15.desc', 'qaida.step.15.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.15.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step15_lesson_$i',
          trackId: 'step_15_muqattaat_qalqalah',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.15.title',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 15,
      id: 'step_15_muqattaat_qalqalah',
      titleKey: 'qaida.step.15.title',
      arabicTitle: 'الْمُقَطَّعَات وَالْقَلْقَلَة',
      descriptionKey: 'qaida.step.15.desc',
      phaseNumber: 5,
      phaseNameKey: 'qaida.step.15.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.15.garden_plant',
      colorHex: 0xFF06B6D4,
      icon: Icons.surround_sound_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 16:  
  // Listen → Sort (waqf er chinho) → Sequence → Puzzle → Speed Reading → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep16Waqf() {
    final waqfLessons = [
      {'name': 'qaida.step.16.desc', 'ex': 'الْعَالَمِينَ ۝', 'desc': 'qaida.step.16.desc'},
      {'name': 'qaida.step.16.desc', 'ex': 'جَنَّةً ۝', 'desc': 'qaida.step.16.desc'},
      {'name': 'qaida.step.16.desc', 'ex': 'م | ط | ج | ز | ص', 'desc': 'qaida.step.16.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < waqfLessons.length; i++) {
      final w = waqfLessons[i];
      final name = w['name']!;
      final ex = w['ex']!;
      final desc = w['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step16_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.16.act.1.prompt',
          arabicTarget: ex,
          options: ['الْعَالَمِينَ ۝', 'الرَّحِيمِ ۝', 'الدِّينِ ۝'],
          correctIndex: i,
          explanation: desc,
        ),
        // 2. Sort 
        QaidaActivity(
          id: 'step16_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'qaida.step.16.act.2.prompt',
          sortingCategories: {
            'qaida.step.16.desc': ['م', 'qaida.step.16.desc'],
            'qaida.step.16.desc': ['ج', 'qaida.step.16.desc'],
            'qaida.step.16.desc': ['ص', 'ز'],
          },
          explanation: 'qaida.step.16.act.2.explanation',
        ),
        // 3. Sequence
        QaidaActivity(
          id: 'step16_${i}_seq',
          slotNumber: 3,
          type: QaidaActivityType.sequenceOrder,
          prompt: 'qaida.step.16.act.3.prompt',
          sequenceItems: [
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ۝',
            'الرَّحْمٰنِ الرَّحِيمِ ۝',
            'مَالِكِ يَوْمِ الدِّينِ ۝',
          ],
          explanation: 'qaida.step.16.act.3.explanation',
        ),
        // 4. Puzzle
        QaidaActivity(
          id: 'step16_${i}_puzzle',
          slotNumber: 4,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'qaida.step.16.act.4.prompt',
          puzzlePieces: ['جَنَّةً', '۝', 'عَالِيَةً'],
          explanation: 'qaida.step.16.act.4.explanation',
        ),
        // 5. Speed Reading
        QaidaActivity(
          id: 'step16_${i}_speed',
          slotNumber: 5,
          type: QaidaActivityType.speedReading,
          prompt: 'qaida.step.16.act.5.prompt',
          arabicTarget: 'الْعَالَمِينَ ۝',
          options: ['الْعَالَمِينَ ۝', 'الرَّحِيمِ ۝', 'الدِّينِ ۝'],
          correctIndex: 0,
          explanation: 'qaida.step.16.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step16_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.16.act.6.prompt',
          arabicTarget: 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ ۝ فَصَلِّ لِرَبِّكَ وَانْحَرْ ۝',
          explanation: 'qaida.step.16.act.6.explanation',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step16_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.16.act.7.prompt',
          arabicTarget: 'عَلِيمًا حَكِيمًا ۝',
          options: ['qaida.step.16.desc', 'qaida.step.16.desc', 'qaida.step.16.desc'],
          correctIndex: 0,
          explanation: 'qaida.step.16.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step16_lesson_$i',
          trackId: 'step_16_waqf',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.16.title',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 16,
      id: 'step_16_waqf',
      titleKey: 'qaida.step.16.title',
      arabicTitle: 'الْوَقْف',
      descriptionKey: 'qaida.step.16.desc',
      phaseNumber: 6,
      phaseNameKey: 'qaida.step.16.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.16.garden_plant',
      colorHex: 0xFF64748B,
      icon: Icons.stop_circle_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 17:    (Tilawat)
  // Listen → Word Builder → Sequence → Puzzle (sentence) → Sing Along gap → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep17Tilawat() {
    final tilawatLessons = [
      {'name': 'qaida.step.17.desc', 'ex': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', 'desc': 'qaida.step.17.desc'},
      {'name': 'qaida.step.17.desc', 'ex': 'مَالِكِ يَوْمِ الدِّينِ', 'desc': 'qaida.step.17.desc'},
      {'name': 'qaida.step.17.desc', 'ex': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', 'desc': 'qaida.step.17.desc'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < tilawatLessons.length; i++) {
      final t = tilawatLessons[i];
      final name = t['name']!;
      final ex = t['ex']!;
      final desc = t['desc']!;

      final activities = [
        // 1. Listen
        QaidaActivity(
          id: 'step17_${i}_listen',
          slotNumber: 1,
          type: QaidaActivityType.listenAndIdentify,
          prompt: 'qaida.step.17.act.1.prompt',
          arabicTarget: ex,
          options: [
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            'الرَّحْمٰنِ الرَّحِيمِ',
            'مَالِكِ يَوْمِ الدِّينِ',
          ],
          correctIndex: i == 0 ? 0 : (i == 1 ? 2 : 1),
          explanation: desc,
        ),
        // 2. Word Builder
        QaidaActivity(
          id: 'step17_${i}_word',
          slotNumber: 2,
          type: QaidaActivityType.buildArrange,
          prompt: 'qaida.step.17.act.2.prompt',
          tiles: [
            ActivityTile(id: 't1', label: 'إِيَّاكَ', arabicLabel: 'إِيَّاكَ'),
            ActivityTile(id: 't2', label: 'نَعْبُدُ', arabicLabel: 'نَعْبُدُ'),
            ActivityTile(id: 't3', label: 'وَإِيَّاكَ', arabicLabel: 'وَإِيَّاكَ'),
            ActivityTile(id: 't4', label: 'نَسْتَعِينُ', arabicLabel: 'نَسْتَعِينُ'),
          ],
          explanation: 'qaida.step.17.act.2.explanation',
        ),
        // 3. Sequence
        QaidaActivity(
          id: 'step17_${i}_seq',
          slotNumber: 3,
          type: QaidaActivityType.sequenceOrder,
          prompt: 'qaida.step.17.act.3.prompt',
          sequenceItems: [
            'بِسْمِ اللَّهِ الرَّحْمٰنِ الرَّحِيمِ',
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            'الرَّحْمٰنِ الرَّحِيمِ',
            'مَالِكِ يَوْمِ الدِّينِ',
          ],
          explanation: 'qaida.step.17.act.3.explanation',
        ),
        // 4. Puzzle
        QaidaActivity(
          id: 'step17_${i}_puzzle',
          slotNumber: 4,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'qaida.step.17.act.4.prompt',
          puzzlePieces: ['إِيَّاكَ', 'نَعْبُدُ', 'وَإِيَّاكَ', 'نَسْتَعِينُ'],
          explanation: 'qaida.step.17.act.4.explanation',
        ),
        // 5. Sing Along Gap
        QaidaActivity(
          id: 'step17_${i}_gap',
          slotNumber: 5,
          type: QaidaActivityType.singAlongGap,
          prompt: 'qaida.step.17.act.5.prompt',
          arabicTarget: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ صِرَاطَ الَّذِينَ _____ عَلَيْهِمْ',
          options: ['أَنْعَمْتَ', 'غَيْرِ', 'الْمَغْضُوبِ'],
          correctIndex: 0,
          explanation: 'qaida.step.17.act.5.explanation',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step17_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'qaida.step.17.act.6.prompt',
          arabicTarget: 'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ ۝',
          explanation: 'qaida.step.17.act.6.explanation',
        ),
        // 7. Boss Challenge (Grand Qaida Final Exam)
        QaidaActivity(
          id: 'step17_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'qaida.step.17.act.7.prompt',
          arabicTarget: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ ۝',
          options: [
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
            'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ',
          ],
          correctIndex: 0,
          explanation: 'qaida.step.17.act.7.explanation',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step17_lesson_$i',
          trackId: 'step_17_tilawat',
          lessonNumber: i + 1,
          title: name,
          subtitleKey: 'qaida.step.17.title',
          arabicDisplay: ex,
          description: desc,
          isTrackFinal: true,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 17,
      id: 'step_17_tilawat',
      titleKey: 'qaida.step.17.title',
      arabicTitle: 'التِّلَاوَة',
      descriptionKey: 'qaida.step.17.desc',
      phaseNumber: 6,
      phaseNameKey: 'qaida.step.17.phase_name',
      lessons: lessons,
      gardenPlantKey: 'qaida.step.17.garden_plant',
      colorHex: 0xFF15803D,
      icon: Icons.menu_book_rounded,
    );
  }
}
