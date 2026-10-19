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
  // STEP 1: মুফরাদাত (Mufradat - আলাদা আলাদা হরফ চেনা)
  // 7 Activities per letter:
  // Listen → Match → Tap Answer → Memory Flip → Trace/Identify → Odd One Out → Boss Challenge
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep1Mufradat() {
    final letterSpecs = [
      {
        'id': 'alif', 'name': 'আলিফ', 'ar': 'ا', 'trans': 'Alif',
        'makhraj': 'জাওফ (মুখের খালি জায়গা) থেকে বাতাস নির্গমন',
        'desc': 'আরবি হরফমালার প্রথম হরফ। কোনো নুকতা নেই, সোজা লাঠির মতো।',
        'words': ['أَكَلَ', 'أَمَرَ', 'إِبِلٌ'],
        'distractors': ['ل', 'د', 'ر'],
        'audio': 'assets/audio/letters/alif.mp3',
      },
      {
        'id': 'baa', 'name': 'বা', 'ar': 'ب', 'trans': 'Baa',
        'makhraj': 'উভয় ঠোঁটের ভেজা অংশ মিলিয়ে উচ্চারণ',
        'desc': 'নৌকার মতো শরীর এবং নিচে ঠিক একটি নুকতা।',
        'words': ['بَيْتٌ', 'بَابٌ', 'كَتَبَ'],
        'distractors': ['ت', 'ث', 'ن'],
        'audio': 'assets/audio/letters/baa.mp3',
      },
      {
        'id': 'taa', 'name': 'তা', 'ar': 'ت', 'trans': 'Taa',
        'makhraj': 'জিহ্বার আগা সামনের উপরের দুই দাঁতের গোড়ায় লাগিয়ে উচ্চারণ',
        'desc': 'নৌকার মতো শরীর এবং উপরে ঠিক দুটি নুকতা।',
        'words': ['تَمْرٌ', 'كَتَبَ', 'تِينٌ'],
        'distractors': ['ب', 'ث', 'ط'],
        'audio': 'assets/audio/letters/taa.mp3',
      },
      {
        'id': 'thaa', 'name': 'ছা', 'ar': 'ث', 'trans': 'Thaa',
        'makhraj': 'জিহ্বার আগা সামনের উপরের দুই দাঁতের কিনারার সাথে লাগিয়ে নরমভাবে উচ্চারণ',
        'desc': 'নৌকার মতো শরীর এবং উপরে ঠিক তিনটি নুকতা। নরম কণ্ঠে বলতে হয়।',
        'words': ['ثَمَرٌ', 'ثَلَاثَة', 'مَثَلٌ'],
        'distractors': ['س', 'ص', 'ت'],
        'audio': 'assets/audio/letters/thaa.mp3',
      },
      {
        'id': 'jeem', 'name': 'জীম', 'ar': 'ج', 'trans': 'Jeem',
        'makhraj': 'জিহ্বার মধ্যভাগ তার বরাবর উপরের তালুর সাথে লাগিয়ে উচ্চারণ',
        'desc': 'মাথার অংশ বাঁকা এবং পেটের ভেতর ঠিক একটি নুকতা।',
        'words': ['جَمَلٌ', 'مَسْجِدٌ', 'حَجٌّ'],
        'distractors': ['ح', 'خ', 'ع'],
        'audio': 'assets/audio/letters/jeem.mp3',
      },
      {
        'id': 'haa', 'name': 'হা (বড়)', 'ar': 'ح', 'trans': 'Haa',
        'makhraj': 'হলকের মধ্যভাগ (গলার মাঝখান) থেকে পরিষ্কার শিসবিহীন আওয়াজে উচ্চারণ',
        'desc': 'জীমের মতো আকৃতি কিন্তু কোনো নুকতা নেই। গলায় বাতাস চাপিয়ে উচ্চারণ।',
        'words': ['حَمْدٌ', 'لَوْحٌ', 'رَحْمَة'],
        'distractors': ['ج', 'خ', 'هـ'],
        'audio': 'assets/audio/letters/haa.mp3',
      },
      {
        'id': 'khaa', 'name': 'খা', 'ar': 'خ', 'trans': 'Khaa',
        'makhraj': 'হলকের শেষভাগ (গলার উপরিভাগ) থেকে মোটা স্বরে উচ্চারণ',
        'desc': 'জীমের মতো আকৃতি এবং মাথার উপরে ঠিক একটি নুকতা। ভারি হরফ।',
        'words': ['خُبْزٌ', 'نَخْلٌ', 'خَيْرٌ'],
        'distractors': ['ح', 'ج', 'غ'],
        'audio': 'assets/audio/letters/khaa.mp3',
      },
      {
        'id': 'daal', 'name': 'দাল', 'ar': 'د', 'trans': 'Daal',
        'makhraj': 'জিহ্বার আগা সামনের উপরের দুই দাঁতের গোড়ার সাথে লাগিয়ে উচ্চারণ',
        'desc': 'হালকা বাঁকানো খাটো আকৃতি, কোনো নুকতা নেই।',
        'words': ['دَارٌ', 'أَسَدٌ', 'بَلَدٌ'],
        'distractors': ['ذ', 'ر', 'ز'],
        'audio': 'assets/audio/letters/daal.mp3',
      },
      {
        'id': 'dhaal', 'name': 'যাল', 'ar': 'ذ', 'trans': 'Dhaal',
        'makhraj': 'জিহ্বার আগা সামনের উপরের দুই দাঁতের কিনারার সাথে লাগিয়ে নরমভাবে উচ্চারণ',
        'desc': 'দালের মতো আকৃতি এবং উপরে একটি নুকতা। নরম স্বরে বলতে হয়।',
        'words': ['ذَهَبٌ', 'ذِكْرٌ', 'أُذُنٌ'],
        'distractors': ['د', 'ز', 'ظ'],
        'audio': 'assets/audio/letters/dhaal.mp3',
      },
      {
        'id': 'raa', 'name': 'রা', 'ar': 'ر', 'trans': 'Raa',
        'makhraj': 'জিহ্বার আগার পিঠ তার বরাবর উপরের তালুর সাথে লাগিয়ে উচ্চারণ',
        'desc': 'কলার মতো ঝুলন্ত বাঁকা রেখা, কোনো নুকতা নেই।',
        'words': ['رَحْمَة', 'قَمَرٌ', 'نَهْرٌ'],
        'distractors': ['ز', 'د', 'و'],
        'audio': 'assets/audio/letters/raa.mp3',
      },
      {
        'id': 'zaay', 'name': 'যা', 'ar': 'ز', 'trans': 'Zaay',
        'makhraj': 'জিহ্বার আগা সামনের নিচের দুই দাঁতের পেটের সাথে লাগিয়ে শিস দিয়ে উচ্চারণ',
        'desc': 'র-এর মতো আকৃতি এবং উপরে একটি নুকতা। মৌমাছির গুঞ্জনের মতো শিস।',
        'words': ['زَيْتُون', 'مَوْزٌ', 'رِزْقٌ'],
        'distractors': ['ر', 'ذ', 'س'],
        'audio': 'assets/audio/letters/zaay.mp3',
      },
      {
        'id': 'seen', 'name': 'সীন', 'ar': 'س', 'trans': 'Seen',
        'makhraj': 'জিহ্বার আগা নিচের দুই দাঁতের পেটে লাগিয়ে পাতলা শিস দিয়ে উচ্চারণ',
        'desc': 'তিনটি দাঁত এবং নিচে একটি বড় বাটি। কোনো নুকতা নেই।',
        'words': ['سَمَكٌ', 'شَمْسٌ', 'مَسْجِدٌ'],
        'distractors': ['ش', 'ص', 'ث'],
        'audio': 'assets/audio/letters/seen.mp3',
      },
      {
        'id': 'sheen', 'name': 'শীন', 'ar': 'ش', 'trans': 'Sheen',
        'makhraj': 'জিহ্বার মধ্যভাগ উপরের তালুর সাথে লাগিয়ে বাতাস ছড়িয়ে উচ্চারণ',
        'desc': 'সীনের মতো তিনটি দাঁত এবং উপরে তিনটি নুকতা।',
        'words': ['شَمْسٌ', 'شَجَرَة', 'عُشْبٌ'],
        'distractors': ['س', 'ص', 'ث'],
        'audio': 'assets/audio/letters/sheen.mp3',
      },
      {
        'id': 'saad', 'name': 'সোয়াদ', 'ar': 'ص', 'trans': 'Saad',
        'makhraj': 'জিহ্বার আগা নিচের দাঁতের সাথে চেপে ভারি ও মোটা আওয়াজে উচ্চারণ',
        'desc': 'গোল চোখ ও পেছনের বাটি। কোনো নুকতা নেই। ইস্তিলা (মোটা) হরফ।',
        'words': ['صَبْرٌ', 'فَصْلٌ', 'نَصْرٌ'],
        'distractors': ['س', 'ض', 'ط'],
        'audio': 'assets/audio/letters/saad.mp3',
      },
      {
        'id': 'daad', 'name': 'দোয়াদ', 'ar': 'ض', 'trans': 'Daad',
        'makhraj': 'জিহ্বার গোড়ার কিনারা উপরের মাড়ির দাঁতের গোড়ার সাথে লাগিয়ে উচ্চারণ',
        'desc': 'সোওয়াদের মতো আকৃতি এবং উপরে একটি নুকতা। আরবি ভাষার অনন্য হরফ।',
        'words': ['ضَوْءٌ', 'أَرْضٌ', 'فَضْلٌ'],
        'distractors': ['ص', 'ظ', 'د'],
        'audio': 'assets/audio/letters/daad.mp3',
      },
      {
        'id': 'taa_heavy', 'name': 'তোয়া', 'ar': 'ط', 'trans': 'Taa',
        'makhraj': 'জিহ্বার আগা উপরের দাঁতের গোড়ার সাথে চেপে পূর্ণ মোটা স্বরে উচ্চারণ',
        'desc': 'লম্বা লাঠিযুক্ত গোল চোখ, কোনো নুকতা নেই। তা (ت) থেকে অনেক ভারি।',
        'words': ['طَالِبٌ', 'مَطَرٌ', 'طَيْرٌ'],
        'distractors': ['ت', 'ظ', 'দ'],
        'audio': 'assets/audio/letters/taa_heavy.mp3',
      },
      {
        'id': 'zaa_heavy', 'name': 'যোয়া', 'ar': 'ظ', 'trans': 'Zaa',
        'makhraj': 'জিহ্বার আগা উপরের দাঁতের কিনারার সাথে চেপে মোটা স্বরে উচ্চারণ',
        'desc': 'তোয়ার মতো আকৃতি এবং উপরে একটি নুকতা। মোটা হরফ।',
        'words': ['ظِلٌّ', 'نَظَرٌ', 'ظُهْرٌ'],
        'distractors': ['ط', 'ذ', 'ض'],
        'audio': 'assets/audio/letters/zaa_heavy.mp3',
      },
      {
        'id': 'ayn', 'name': 'আইন', 'ar': 'ع', 'trans': 'Ayn',
        'makhraj': 'হলকের মধ্যভাগ (গলার মাঝখান) থেকে পরিষ্কার চেপে উচ্চারণ',
        'desc': 'ছোট বাঁকা মাথা ও নিচে বড় অর্ধবৃত্ত। কোনো নুকতা নেই।',
        'words': ['عِلْمٌ', 'سَمِيعٌ', 'عَيْنٌ'],
        'distractors': ['غ', 'ء', 'ح'],
        'audio': 'assets/audio/letters/ayn.mp3',
      },
      {
        'id': 'ghayn', 'name': 'গাইন', 'ar': 'غ', 'trans': 'Ghayn',
        'makhraj': 'হলকের উপরিভাগ থেকে গরগর আওয়াজের মতো মোটা স্বরে উচ্চারণ',
        'desc': 'আইনের মতো আকৃতি এবং উপরে একটি নুকতা। ভারি হরফ।',
        'words': ['غَفُورٌ', 'بَالِغٌ', 'غَيْبٌ'],
        'distractors': ['ع', 'খ', 'ف'],
        'audio': 'assets/audio/letters/ghayn.mp3',
      },
      {
        'id': 'faa', 'name': 'ফা', 'ar': 'ف', 'trans': 'Faa',
        'makhraj': 'সামনের উপরের দুই দাঁতের আগা নিচের ঠোঁটের ভেজা পেটে লাগিয়ে উচ্চারণ',
        'desc': 'গোল মাথা ও সমতল শরীর, উপরে একটি নুকতা।',
        'words': ['فِيلٌ', 'صَيْفٌ', 'فَجْرٌ'],
        'distractors': ['ق', 'ب', 'غ'],
        'audio': 'assets/audio/letters/faa.mp3',
      },
      {
        'id': 'qaaf', 'name': 'ক্বাফ', 'ar': 'ق', 'trans': 'Qaaf',
        'makhraj': 'জিহ্বার গোড়া তার বরাবর উপরের নরম তালুর সাথে লাগিয়ে মোটা স্বরে উচ্চারণ',
        'desc': 'গোল মাথা ও গভীর গোল বাটি, উপরে দুটি নুকতা। মোটা হরফ।',
        'words': ['قَلَمٌ', 'قُرْآن', 'حَقٌّ'],
        'distractors': ['ك', 'ف', 'غ'],
        'audio': 'assets/audio/letters/qaaf.mp3',
      },
      {
        'id': 'kaaf', 'name': 'কাফ', 'ar': 'ك', 'trans': 'Kaaf',
        'makhraj': 'জিহ্বার গোড়া থেকে একটু নিচে তালুর সাথে লাগিয়ে পাতলা স্বরে উচ্চারণ',
        'desc': 'লম্বা খাড়া দাগ ও পেটে ছোট কাফ প্রতীক। পাতলা হরফ।',
        'words': ['كِتَابٌ', 'مَلِكٌ', 'شُكْرٌ'],
        'distractors': ['ق', 'ل', 'ت'],
        'audio': 'assets/audio/letters/kaaf.mp3',
      },
      {
        'id': 'laam', 'name': 'লাম', 'ar': 'ل', 'trans': 'Laam',
        'makhraj': 'জিহ্বার আগার কিনারা উপরের মাড়ির দাঁত ও তালুর সাথে লাগিয়ে উচ্চারণ',
        'desc': 'লম্বা ছাতার হাতলের মতো বাঁকা আকৃতি, কোনো নুকতা নেই।',
        'words': ['لَيْلٌ', 'هِلَالٌ', 'عِلْمٌ'],
        'distractors': ['ا', 'ك', 'م'],
        'audio': 'assets/audio/letters/laam.mp3',
      },
      {
        'id': 'meem', 'name': 'মীম', 'ar': 'م', 'trans': 'Meem',
        'makhraj': 'উভয় ঠোঁটের শুকনা অংশ মিলিয়ে উচ্চারণ',
        'desc': 'ছোট গোল মাথা ও নিচের দিকে নামা লেজ। কোনো নুকতা নেই।',
        'words': ['مَسْجِدٌ', 'قَلَمٌ', 'شَمْسٌ'],
        'distractors': ['ن', 'ل', 'ب'],
        'audio': 'assets/audio/letters/meem.mp3',
      },
      {
        'id': 'noon', 'name': 'নূন', 'ar': 'ن', 'trans': 'Noon',
        'makhraj': 'জিহ্বার আগা উপরের মাড়ির সাথে লাগিয়ে উচ্চারণ',
        'desc': 'গভীর গোল বাটি এবং তার পেটের ভেতর ঠিক একটি নুকতা।',
        'words': ['نُورٌ', 'عَيْنٌ', 'جَنَّة'],
        'distractors': ['ب', 'ت', 'ث'],
        'audio': 'assets/audio/letters/noon.mp3',
      },
      {
        'id': 'waaw', 'name': 'ওয়াও', 'ar': 'و', 'trans': 'Waaw',
        'makhraj': 'উভয় ঠোঁট গোল করে সামনের দিকে এনে উচ্চারণ',
        'desc': 'গোল মাথা ও র-এর মতো বাঁকা লেজ, কোনো নুকতা নেই।',
        'words': ['وَرْدَة', 'نَوْمٌ', 'يَوْمٌ'],
        'distractors': ['ر', 'د', 'ف'],
        'audio': 'assets/audio/letters/waaw.mp3',
      },
      {
        'id': 'haa_small', 'name': 'হা (গোল)', 'ar': 'هـ', 'trans': 'Haa',
        'makhraj': 'সিনার দিক থেকে হলকের শুরু (গলার তলদেশ) থেকে স্বাভাবিক নিঃশ্বাসে উচ্চারণ',
        'desc': 'গোল চোখের মতো আকৃতি, কোনো নুকতা নেই। বুকের গভীর থেকে উচ্চারণ।',
        'words': ['هُدًى', 'وَجْهٌ', 'نَهْرٌ'],
        'distractors': ['ح', 'خ', 'ة'],
        'audio': 'assets/audio/letters/haa_small.mp3',
      },
      {
        'id': 'yaa', 'name': 'ইয়া', 'ar': 'ي', 'trans': 'Yaa',
        'makhraj': 'জিহ্বার মধ্যভাগ উপরের তালুর সাথে লাগিয়ে উচ্চারণ',
        'desc': 'হাঁসের মতো বাঁকানো শরীর এবং নিচে ঠিক দুটি নুকতা।',
        'words': ['يَوْمٌ', 'عَيْنٌ', 'بَيْتٌ'],
        'distractors': ['ب', 'ت', 'ن'],
        'audio': 'assets/audio/letters/yaa.mp3',
      },
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < letterSpecs.length; i++) {
      final spec = letterSpecs[i];
      final letterId = spec['id'] as String;
      final name = spec['name'] as String;
      final ar = spec['ar'] as String;
      final trans = spec['trans'] as String;
      final makhraj = spec['makhraj'] as String;
      final desc = spec['desc'] as String;
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
          prompt: 'উচ্চারণ শুনুন এবং সঠিক হরফটিতে চাপ দিন:',
          arabicTarget: ar,
          audioAsset: audio,
          options: _makeOptions(ar, d1, d2, 1),
          correctIndex: _getCorrectIndex(1),
          explanation: 'মাশাআল্লাহ! এটি হরফ “$name” ($ar)।',
          skillId: 'letter_listen_$letterId',
        ),
        // 2. Match the Pairs
        QaidaActivity(
          id: '${letterId}_act2_match',
          slotNumber: 2,
          type: QaidaActivityType.matchPairs,
          prompt: 'হরফ ও তার নামের জোড়া মিলাও:',
          pairs: {
            ar: trans,
            d1: d1,
            d2: d2,
          },
          explanation: 'চমৎকার! প্রতিটি হরফের অনন্য রূপ মনে রেখো।',
          skillId: 'letter_match_$letterId',
        ),
        // 3. Tap the Right Answer
        QaidaActivity(
          id: '${letterId}_act3_tap',
          slotNumber: 3,
          type: QaidaActivityType.recognize,
          prompt: 'নিচের কোনটি হরফ “$name” ($ar)?',
          arabicTarget: ar,
          options: _makeOptions(ar, d1, d2, 3),
          correctIndex: _getCorrectIndex(3),
          explanation: 'সঠিক! হরফ “$ar”-এর রূপ চিনেছ।',
          skillId: 'letter_recognize_$letterId',
        ),
        // 4. Memory Flip
        QaidaActivity(
          id: '${letterId}_act4_memory',
          slotNumber: 4,
          type: QaidaActivityType.memoryMatch,
          prompt: 'কার্ড উল্টে হরফ “$ar” ও তার উচ্চারণ খুঁজে বের করো:',
          pairs: {
            ar: trans,
            d1: d1,
          },
          explanation: 'দারুন স্মৃতিশক্তি! জোড়া মিলে গেছে।',
          skillId: 'letter_memory_$letterId',
        ),
        // 5. Draw & Trace
        QaidaActivity(
          id: '${letterId}_act5_trace',
          slotNumber: 5,
          type: QaidaActivityType.drawTrace,
          prompt: 'আঙুল দিয়ে হরফ “$name” ($ar) আঁকো এবং মাখরাজ স্মরণ করো: $makhraj',
          arabicTarget: ar,
          explanation: 'মাশাআল্লাহ! হরফ “$ar”-এর আকার ও মাখরাজ ($makhraj) স্মরণ করেছ।',
          skillId: 'letter_trace_$letterId',
        ),
        // 6. Odd One Out
        QaidaActivity(
          id: '${letterId}_act6_odd',
          slotNumber: 6,
          type: QaidaActivityType.oddOneOut,
          prompt: 'কোনটি আলাদা? হরফ “$ar”-এর দলের বাইরের হরফটি বের করো:',
          arabicTarget: d1,
          options: [ar, ar, d1],
          correctIndex: 2,
          explanation: 'ঠিক ধরেছো! “$d1” হরফটি বাকি হরফগুলো থেকে আলাদা।',
          skillId: 'letter_odd_$letterId',
        ),
        // 7. Boss Challenge (Step Exam Slot)
        QaidaActivity(
          id: '${letterId}_act7_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'বস চ্যালেঞ্জ! কুরআনিক শব্দ “${words.first}”-এ “$name” ($ar) হরফটি কোথায়?',
          arabicTarget: ar,
          options: _makeOptions(ar, d1, d2, 7),
          correctIndex: _getCorrectIndex(7),
          explanation: 'মাশাআল্লাহ! তুমি “$name” ($ar) পাঠের সবকটি চ্যালেঞ্জ সফলভাবে শেষ করেছ!',
          skillId: 'letter_boss_$letterId',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step1_$letterId',
          trackId: 'step_1_mufradat',
          lessonNumber: i + 1,
          title: '$name হরফ',
          subtitle: 'হরফ: $ar',
          arabicDisplay: ar,
          description: desc,
          audioAsset: audio,
          makhraj: makhraj,
          exampleWords: words,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 1,
      id: 'step_1_mufradat',
      title: 'মুফরাদাত',
      titleEn: 'Mufradat',
      arabicTitle: 'الْمُفْرَدَات',
      description: 'আলাদা আলাদা একক হরফ চেনা ও বিশুদ্ধ উচ্চারণ',
      phaseNumber: 1,
      phaseName: 'Phase 1: Foundation',
      lessons: lessons,
      gardenPlant: 'Date Palm (খেজুর গাছ)',
      colorHex: 0xFF78C943, // Leaf Green
      icon: Icons.font_download_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 2: মুরাক্কাবাত (Murakkabat - হরফের রূপভেদ ও যুক্ত হরফ)
  // Match (form↔harf) → Sort (shuru/majhe/shesh) → Puzzle → Memory → Trace → Word Builder → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep2Murakkabat() {
    final formItems = [
      {'letter': 'ب', 'name': 'বা', 'init': 'بـ', 'med': 'ـبـ', 'fin': 'ـب', 'word': 'بَيْتٌ'},
      {'letter': 'ت', 'name': 'তা', 'init': 'تـ', 'med': 'ـتـ', 'fin': 'ـت', 'word': 'كَتَبَ'},
      {'letter': 'ث', 'name': 'ছা', 'init': 'ثـ', 'med': 'ـثـ', 'fin': 'ـث', 'word': 'مَثَلٌ'},
      {'letter': 'ن', 'name': 'নূন', 'init': 'نـ', 'med': 'ـنـ', 'fin': 'ـن', 'word': 'نُورٌ'},
      {'letter': 'ي', 'name': 'ইয়া', 'init': 'يـ', 'med': 'ـيـ', 'fin': 'ـي', 'word': 'يَوْمٌ'},
      {'letter': 'ج', 'name': 'জীম', 'init': 'جـ', 'med': 'ـجـ', 'fin': 'ـج', 'word': 'جَمَلٌ'},
      {'letter': 'ح', 'name': 'হা', 'init': 'حـ', 'med': 'ـحـ', 'fin': 'ـح', 'word': 'حَمْدٌ'},
      {'letter': 'خ', 'name': 'খা', 'init': 'خـ', 'med': 'ـخـ', 'fin': 'ـخ', 'word': 'خَبَرٌ'},
    ];

    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < formItems.length; i++) {
      final item = formItems[i];
      final l = item['letter'] as String;
      final name = item['name'] as String;
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
          prompt: 'হরফের রূপ ও মূল হরফ মিলাও:',
          pairs: {init: l, med: l, fin: l},
          explanation: 'হরফ যুক্ত হলে রূপ বদলায় কিন্তু নুকতা একই থাকে।',
        ),
        // 2. Sort (শুরু, মাঝে, শেষে)
        QaidaActivity(
          id: 'step2_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'হরফ “$name”-এর রূপগুলোকে সঠিক অবস্থানে সাজাও:',
          sortingCategories: {
            'শুরুর রূপ': [init],
            'মাঝের রূপ': [med],
            'শেষের রূপ': [fin],
          },
          explanation: 'শব্দের শুরুতে হাত ডানে খোলা, মাঝে দুই পাশে, শেষে পূর্ণাঙ্গ থাকে।',
        ),
        // 3. Puzzle Builder
        QaidaActivity(
          id: 'step2_${i}_puzzle',
          slotNumber: 3,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'হরফের টুকরোগুলো জোড়া লাগিয়ে শব্দ তৈরি করো:',
          puzzlePieces: [init, med, fin],
          explanation: 'মাশাআল্লাহ! হরফের টুকরোগুলো নিখুঁতভাবে মিলেছে।',
        ),
        // 4. Memory Flip
        QaidaActivity(
          id: 'step2_${i}_memory',
          slotNumber: 4,
          type: QaidaActivityType.memoryMatch,
          prompt: 'একই হরফের ভিন্ন রূপের জোড়া মিলাও:',
          pairs: {l: init, med: fin},
          explanation: 'চমৎকার! জোড়া খুঁজে পেয়েছ।',
        ),
        // 5. Trace
        QaidaActivity(
          id: 'step2_${i}_trace',
          slotNumber: 5,
          type: QaidaActivityType.drawTrace,
          prompt: 'আঙুল দিয়ে যুক্ত হরফের রূপ “$init” আঁকো:',
          arabicTarget: init,
          explanation: 'যুক্ত অবস্থায় $name-এর রূপ হাত দিয়ে এঁকে আয়ত্ত করেছ।',
        ),
        // 6. Word Builder
        QaidaActivity(
          id: 'step2_${i}_word',
          slotNumber: 6,
          type: QaidaActivityType.buildArrange,
          prompt: 'টুকরোগুলো সাজিয়ে “$word” শব্দ গঠন করো:',
          tiles: [
            ActivityTile(id: 't1', label: init, arabicLabel: init),
            ActivityTile(id: 't2', label: med, arabicLabel: med),
            ActivityTile(id: 't3', label: fin, arabicLabel: fin),
          ],
          explanation: 'শব্দে যুক্ত হরফের সঠিক অবস্থান চিহ্নিত হয়েছে।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step2_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'মুরাক্কাবাত বস চ্যালেঞ্জ! “$word” শব্দে “$name” হরফটির সঠিক রূপ কোনটি?',
          arabicTarget: init,
          options: [init, med, fin],
          correctIndex: 0,
          explanation: 'অভিনন্দন! মুরাক্কাবাত চ্যালেঞ্জ জয় করেছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step2_lesson_$i',
          trackId: 'step_2_murakkabat',
          lessonNumber: i + 1,
          title: '$name হরফের রূপভেদ',
          subtitle: '$init | $med | $fin',
          arabicDisplay: '$init$med$fin',
          description: 'যুক্ত হরফে $name-এর শুরু, মাঝ ও শেষের রূপ চেনা।',
          exampleWords: [word],
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 2,
      id: 'step_2_murakkabat',
      title: 'মুরাক্কাবাত',
      titleEn: 'Murakkabat',
      arabicTitle: 'الْمُرَكَّبَات',
      description: 'হরফের শুরু, মাঝ ও শেষের রূপ এবং যুক্ত হরফ চেনা',
      phaseNumber: 1,
      phaseName: 'Phase 1: Foundation',
      lessons: lessons,
      gardenPlant: 'Olive Tree (যাইতুন গাছ)',
      colorHex: 0xFF398A35, // Forest Green
      icon: Icons.layers_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 3: হরকত (Harakat - জবর, যের, পেশ)
  // Listen → Tap Answer → Match → Sort (harakat) → Voice Repeat → Speed Reading → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep3Harakat() {
    final harakatList = [
      {'name': 'যবর (ফাতহাহ)', 'symbol': 'ـَ', 'sound': 'আ-কার', 'sample': 'بَ', 'desc': 'হরফের উপরে এক দাগকে যবর বলে।'},
      {'name': 'যের (কাসরাহ)', 'symbol': 'ـِ', 'sound': 'ই-কার', 'sample': 'بِ', 'desc': 'হরফের নিচে এক দাগকে যের বলে।'},
      {'name': 'পেশ (দাম্মাহ)', 'symbol': 'ـُ', 'sound': 'উ-কার', 'sample': 'بُ', 'desc': 'হরফের উপরে গোল ওয়াও আকৃতিকে পেশ বলে।'},
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
          prompt: 'উচ্চারণ শুনুন এবং সঠিক হরকত চিহ্নিত করুন:',
          arabicTarget: sample,
          options: ['بَ', 'بِ', 'بُ'],
          correctIndex: i,
          explanation: 'হরকত দ্রুত পড়তে হয়, এক আলিফ টানা নিষেধ।',
        ),
        // 2. Tap Answer / Harakat Slider
        QaidaActivity(
          id: 'step3_${i}_tap',
          slotNumber: 2,
          type: QaidaActivityType.harakatSlider,
          prompt: 'হরকত স্লাইড বা ট্যাপ করে “$sample” তৈরি করো:',
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
          prompt: 'হরকত ও তার শব্দের জোড়া মিলাও:',
          pairs: {'بَ': 'বা', 'بِ': 'বি', 'بُ': 'বু'},
          explanation: 'যবরে আ, যের-এ ই, পেশে উ কার হয়।',
        ),
        // 4. Sort (harakat)
        QaidaActivity(
          id: 'step3_${i}_sort',
          slotNumber: 4,
          type: QaidaActivityType.sortGroups,
          prompt: 'হরকত অনুযায়ী হরফগুলোকে সঠিক ঘরে সাজাও:',
          sortingCategories: {
            'যবর ( َ )': ['بَ', 'دَ'],
            'যের ( ِ )': ['بِ', 'دِ'],
            'পেশ ( ُ )': ['بُ', 'دُ'],
          },
          explanation: 'চমৎকার! যবর, যের ও পেশ অনুযায়ী হরফ সঠিকভাবে আলাদা করেছ।',
        ),
        // 5. Voice Repeat
        QaidaActivity(
          id: 'step3_${i}_voice',
          slotNumber: 5,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে বলো: “$sample” (টান ছাড়া দ্রুত):',
          arabicTarget: sample,
          explanation: 'হরকতের উচ্চারণ এক নিঃশ্বাসে দ্রুত শেষ করতে হয়।',
        ),
        // 6. Speed Reading
        QaidaActivity(
          id: 'step3_${i}_speed',
          slotNumber: 6,
          type: QaidaActivityType.speedReading,
          prompt: 'দ্রুত পড়ে ফেলো: بَ بِ بُ — দেরি না করে সঠিক উচ্চারণ করো:',
          arabicTarget: 'بَ - بِ - بُ',
          options: ['বা-বি-বু', 'বু-বি-বা', 'বা-বা-বা'],
          correctIndex: 0,
          explanation: 'খুব ভালো! গতি ও শুদ্ধতা বজায় রেখেছ।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step3_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'হরকত বস চ্যালেঞ্জ! “دَ رَ سَ” শব্দে সবগুলো হরফে কোন হরকত আছে?',
          arabicTarget: 'যবর',
          options: ['যবর', 'যের', 'পেশ'],
          correctIndex: 0,
          explanation: 'মাশাআল্লাহ! হরকত স্টেপ সফলভাবে উত্তীর্ণ হয়েছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step3_lesson_$i',
          trackId: 'step_3_harakat',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'চিহ্ন: $sym | উদাহরণ: $sample',
          arabicDisplay: sample,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 3,
      id: 'step_3_harakat',
      title: 'হরকত',
      titleEn: 'Harakat',
      arabicTitle: 'الْحَرَكَات',
      description: 'যবর, যের, পেশ — টান ছাড়া দ্রুত পড়ার নিয়ম',
      phaseNumber: 2,
      phaseName: 'Phase 2: Harakat',
      lessons: lessons,
      gardenPlant: 'Jasmine Flower (জুঁই ফুল)',
      colorHex: 0xFFFFD34F, // Sunshine Yellow
      icon: Icons.flash_on_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 4: তানভীন (Tanween - দুই যবর, দুই যের, দুই পেশ)
  // Listen → Match → Odd One Out → Sort → Word Builder → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep4Tanween() {
    final tanweenLessons = [
      {'name': 'দুই যবর', 'sym': 'ـً', 'ex': 'بً', 'sound': 'বান্', 'word': 'عَلِيمًا'},
      {'name': 'দুই যের', 'sym': 'ـٍ', 'ex': 'بٍ', 'sound': 'বিন্', 'word': 'عَذَابٍ'},
      {'name': 'দুই পেশ', 'sym': 'ـٌ', 'ex': 'بٌ', 'sound': 'বুন্', 'word': 'غَفُورٌ'},
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
          prompt: 'উচ্চারণ শুনুন এবং সঠিক তানভীন চিহ্নিত করুন:',
          arabicTarget: ex,
          options: ['بً', 'بٍ', 'بٌ'],
          correctIndex: i,
          explanation: 'তানভীনের উচ্চারণে একটি লুকানো নূন সাকিন (ন্) উচ্চারিত হয়।',
        ),
        // 2. Match
        QaidaActivity(
          id: 'step4_${i}_match',
          slotNumber: 2,
          type: QaidaActivityType.matchPairs,
          prompt: 'তানভীন ও তার সঠিক উচ্চারণের জোড়া মিলাও:',
          pairs: {
            'بً': 'দুই যবর (বান্)',
            'بٍ': 'দুই যের (বিন্)',
            'بٌ': 'দুই পেশ (বুন্)',
          },
          explanation: 'দুই যবরে আন, দুই যের-এ ইন, দুই পেশে উন ধ্বনি হয়।',
        ),
        // 3. Odd One Out
        QaidaActivity(
          id: 'step4_${i}_odd',
          slotNumber: 3,
          type: QaidaActivityType.oddOneOut,
          prompt: 'কোনটি তানভীন নয়? আলাদা হরফটি নির্বাচন করো:',
          arabicTarget: 'بَ',
          options: ['بً', 'تً', 'ثً', 'بَ'],
          correctIndex: 3,
          explanation: 'সঠিক! “بَ” হলো সাধারণ এক যবর (হরকত), তানভীন নয়।',
        ),
        // 4. Sort
        QaidaActivity(
          id: 'step4_${i}_sort',
          slotNumber: 4,
          type: QaidaActivityType.sortGroups,
          prompt: 'হরফগুলোকে সঠিক তানভীনের ঘরে সাজাও:',
          sortingCategories: {
            'দুই যবর': ['بً', 'تً'],
            'দুই যের': ['بٍ', 'تٍ'],
            'দুই পেশ': ['بٌ', 'تٌ'],
          },
          explanation: 'চমৎকার! তানভীনের রূপভেদ সঠিকভাবে পৃথক করেছ।',
        ),
        // 5. Word Builder
        QaidaActivity(
          id: 'step4_${i}_word',
          slotNumber: 5,
          type: QaidaActivityType.buildArrange,
          prompt: 'টুকরোগুলো সাজিয়ে তানভীনযুক্ত শব্দ “كُفُوًا” গঠন করো:',
          tiles: [
            ActivityTile(id: 't1', label: 'كُ', arabicLabel: 'كُ'),
            ActivityTile(id: 't2', label: 'فُ', arabicLabel: 'فُ'),
            ActivityTile(id: 't3', label: 'وً', arabicLabel: 'وً'),
            ActivityTile(id: 't4', label: 'ا', arabicLabel: 'ا'),
          ],
          explanation: 'মাশাআল্লাহ! “كُفُوًا” শব্দ সফলভাবে তৈরি হয়েছে।',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step4_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে বলো: “$word” (নূন সাকিনের স্পষ্ট ধ্বনি):',
          arabicTarget: word,
          explanation: 'তানভীনের উচ্চারণ এক নিঃশ্বাসে পরিচ্ছন্নভাবে আদায় করো।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step4_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'তানভীন বস চ্যালেঞ্জ! “عَلِيمًا” শব্দে কোন তানভীন রয়েছে?',
          arabicTarget: 'عَلِيمًا',
          options: ['দুই যবর (তানভীন)', 'দুই যের (তানভীন)', 'দুই পেশ (তানভীন)'],
          correctIndex: 0,
          explanation: 'মাশাআল্লাহ! তানভীন ধাপের চূড়ান্ত পরীক্ষা সফলভাবে উত্তীর্ণ হয়েছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step4_lesson_$i',
          trackId: 'step_4_tanween',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'চিহ্ন: ${t['sym']} | উদাহরণ: $ex',
          arabicDisplay: ex,
          description: 'দুই যবর, দুই যের, দুই পেশকে তানভীন বলে।',
          exampleWords: [word],
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 4,
      id: 'step_4_tanween',
      title: 'তানভীন',
      titleEn: 'Tanween',
      arabicTitle: 'التَّنْوِين',
      description: 'দুই যবর, দুই যের, দুই পেশ — নূন সাকিনের ধ্বনি',
      phaseNumber: 2,
      phaseName: 'Phase 2: Harakat',
      lessons: lessons,
      gardenPlant: 'Rose (গোলাপ ফুল)',
      colorHex: 0xFF4CB9F4,
      icon: Icons.format_quote_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 5: খাড়া হরকত (Khari Harakat - খাড়া যবর, খাড়া যের, উল্টা পেশ)
  // Listen → Sort (choto/lomba) → Memory → Sequence → Catch Letters → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep5KhariHarakat() {
    final khariLessons = [
      {'name': 'খাড়া যবর', 'sym': 'ـٰ', 'ex': 'بٰ', 'word': 'مٰلِكِ'},
      {'name': 'খাড়া যের', 'sym': 'ـٖ', 'ex': 'بٖ', 'word': 'إِيلَافِهِمْ'},
      {'name': 'উল্টা পেশ', 'sym': 'ـٗ', 'ex': 'بٗ', 'word': 'لَهُۥ'},
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
          prompt: 'উচ্চারণ শুনুন এবং সঠিক খাড়া হরকত চিহ্নিত করুন:',
          arabicTarget: ex,
          options: ['بٰ', 'بٖ', 'بٗ'],
          correctIndex: i,
          explanation: 'খাড়া হরকত মাদ্দে আসলির মতো ১ আলিফ টেনে পড়তে হয়।',
        ),
        // 2. Sort (ছোট হরকত vs খাড়া হরকত ১ আলিফ)
        QaidaActivity(
          id: 'step5_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'ছোট হরকত (টান ছাড়া) ও লম্বা খাড়া হরকত (১ আলিফ মাদ্দ) আলাদা করো:',
          sortingCategories: {
            'ছোট হরকত (টান ছাড়া)': ['بَ', 'بِ', 'بُ'],
            'খাড়া হরকত (১ আলিফ মাদ্দ)': ['بٰ', 'بٖ', 'بٗ'],
          },
          explanation: 'ছোট হরকত দ্রুত পড়তে হয়, আর খাড়া হরকত ১ আলিফ টেনে পড়তে হয়।',
        ),
        // 3. Memory
        QaidaActivity(
          id: 'step5_${i}_memory',
          slotNumber: 3,
          type: QaidaActivityType.memoryMatch,
          prompt: 'খাড়া হরকত ও তার নামের জোড়া মেলাও:',
          pairs: {
            'بٰ': 'খাড়া যবর (১ আলিফ)',
            'بٖ': 'খাড়া যের (১ আলিফ)',
            'بٗ': 'উল্টা পেশ (১ আলিফ)',
          },
          explanation: 'চমৎকার স্মৃতিশক্তি! খাড়া হরকতের জোড়া মিলেছে।',
        ),
        // 4. Sequence
        QaidaActivity(
          id: 'step5_${i}_seq',
          slotNumber: 4,
          type: QaidaActivityType.sequenceOrder,
          prompt: 'হরকত থেকে মাদ্দে আসলী ক্রমানুসারে সাজাও:',
          sequenceItems: ['بَ', 'بَا', 'بٰ'],
          explanation: 'যবর দ্রুত, খালি আলিফে ১ আলিফ, খাড়া যবরেও ঠিক ১ আলিফ টান।',
        ),
        // 5. Catch Letters
        QaidaActivity(
          id: 'step5_${i}_catch',
          slotNumber: 5,
          type: QaidaActivityType.catchLetters,
          prompt: 'ঝুড়িতে খাড়া হরকত “$ex” ধরো (৩টি):',
          arabicTarget: ex,
          options: [ex, 'بَ', 'بِ', 'بُ'],
          explanation: 'দারুন! ৩টি খাড়া হরকত সফলভাবে সংগ্রহ করেছ।',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step5_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে বলো: “$word” (১ আলিফ টেনে বিশুদ্ধভাবে):',
          arabicTarget: word,
          explanation: 'খাড়া হরকতের টান নিখুঁতভাবে ১ আলিফ পরিমাণ আদায় করো।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step5_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'খাড়া হরকত বস চ্যালেঞ্জ! “مٰلِكِ” শব্দে খাড়া যবর কত আলিফ টানতে হবে?',
          arabicTarget: 'مٰلِكِ',
          options: ['১ আলিফ (মাদ্দে আসলী)', 'টান ছাড়া দ্রুত', '৪ আলিফ'],
          correctIndex: 0,
          explanation: 'অভিনন্দন! খাড়া হরকত চ্যালেঞ্জ সফলভাবে জয় করেছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step5_lesson_$i',
          trackId: 'step_5_khari_harakat',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'চিহ্ন: ${k['sym']} | উদাহরণ: $ex',
          arabicDisplay: ex,
          description: 'খাড়া যবর, খাড়া যের, উল্টা পেশ — ১ আলিফ টেনে পড়ার নিয়ম।',
          exampleWords: [word],
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 5,
      id: 'step_5_khari_harakat',
      title: 'খাড়া হরকত',
      titleEn: 'Khari Harakat',
      arabicTitle: 'الْحَرَكَات الْقَائِمَة',
      description: 'খাড়া যবর, খাড়া যের, উল্টা পেশ — ১ আলিফ টেনে পড়ার নিয়ম',
      phaseNumber: 2,
      phaseName: 'Phase 2: Harakat',
      lessons: lessons,
      gardenPlant: 'Tulip Flower (টিউলিপ ফুল)',
      colorHex: 0xFFA779F5,
      icon: Icons.straighten_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 6: হরফে লীন (Layyin - ওয়াও ও ইয়া লীন)
  // Listen → Odd One Out → Match → Puzzle → Sing Along gap → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep6Layyin() {
    final layyinLessons = [
      {'name': 'ওয়াও লীন', 'ex': 'خَوْفٌ', 'desc': 'যবরের বামে জযমওয়ালা ওয়াও নরম স্বরে পড়তে হয়।'},
      {'name': 'ইয়া লীন', 'ex': 'بَيْتٌ', 'desc': 'যবরের বামে জযমওয়ালা ইয়া নরম স্বরে পড়তে হয়।'},
      {'name': 'লীন শব্দ অনুশীলন', 'ex': 'صَيْفٌ', 'desc': 'টান ছাড়া নরমভাবে পড়ার দক্ষতা।'},
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
          prompt: 'উচ্চারণ শুনুন এবং সঠিক লীন হরফবিশিষ্ট শব্দ নির্বাচন করুন:',
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
          prompt: 'কোন শব্দটি লীন হরফের নয়? আলাদাটি চিহ্নিত করো:',
          arabicTarget: 'كِتَابٌ',
          options: ['خَوْفٌ', 'بَيْتٌ', 'صَيْفٌ', 'كِتَابٌ'],
          correctIndex: 3,
          explanation: 'সঠিক! “كِتَابٌ”-এ আলিফ মাদ্দে আসলী রয়েছে, লীন হরফ নয়।',
        ),
        // 3. Match
        QaidaActivity(
          id: 'step6_${i}_match',
          slotNumber: 3,
          type: QaidaActivityType.matchPairs,
          prompt: 'লীন হরফের শব্দের সাথে তার নিয়ম মেলাও:',
          pairs: {
            'خَوْفٌ': 'ওয়াও লীন (নরম স্বর)',
            'بَيْتٌ': 'ইয়া লীন (নরম স্বর)',
            'يَوْمٌ': 'ওয়াও লীন (নরম স্বর)',
          },
          explanation: 'লীন হরফ টান ছাড়া নরম ও দ্রুত আদায় করতে হয়।',
        ),
        // 4. Puzzle
        QaidaActivity(
          id: 'step6_${i}_puzzle',
          slotNumber: 4,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'টুকরো জোড়া লাগিয়ে লীন শব্দ “بَيْتُ” তৈরি করো:',
          puzzlePieces: ['بَ', 'يْ', 'تُ'],
          explanation: 'মাশাআল্লাহ! “بَيْتُ” পাজল নিখুঁতভাবে তৈরি হয়েছে।',
        ),
        // 5. Sing Along Gap
        QaidaActivity(
          id: 'step6_${i}_gap',
          slotNumber: 5,
          type: QaidaActivityType.singAlongGap,
          prompt: 'সুরে সুরে তিলাওয়াত শুনুন এবং শূন্যস্থানে সঠিক শব্দটি বসান:',
          arabicTarget: 'فَلْيَعْبُدُوا رَبَّ هٰذَا _____ ۝',
          options: ['الْبَيْتِ', 'الصَّيْفِ', 'الْخَوْفِ'],
          correctIndex: 0,
          explanation: 'সূরা কুরাইশের আয়াত: “فَلْيَعْبُدُوا رَبَّ هٰذَا الْبَيْتِ”',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step6_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে নরম স্বরে পড়ুন: “لِإِيلَافِ قُرَيْشٍ”',
          arabicTarget: 'لِإِيلَافِ قُرَيْشٍ',
          explanation: 'ইয়া লীন টান ছাড়া মোলায়েমভাবে উচ্চারণ করো।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step6_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'হরফে লীন বস চ্যালেঞ্জ! “مِنْ خَوْفٍ”-এ ওয়াও লীন কীভাবে পড়তে হয়?',
          arabicTarget: 'مِنْ خَوْفٍ',
          options: ['নরম স্বরে দ্রুত (টান ছাড়া)', '১ আলিফ টেনে', 'নাকের বাঁশিতে গুন্নাহ করে'],
          correctIndex: 0,
          explanation: 'অভিনন্দন! হরফে লীন চ্যালেঞ্জে সফলভাবে উত্তীর্ণ হয়েছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step6_lesson_$i',
          trackId: 'step_6_layyin',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 6,
      id: 'step_6_layyin',
      title: 'হরফে লীন',
      titleEn: 'Layyin',
      arabicTitle: 'حُرُوف اللِّين',
      description: 'যবরের পর ওয়াও সাকিন ও ইয়া সাকিন — নরমভাবে দ্রুত পড়া',
      phaseNumber: 3,
      phaseName: 'Phase 3: Sukoon-Shaddah',
      lessons: lessons,
      gardenPlant: 'Pomegranate (ডালিম গাছ)',
      colorHex: 0xFFFF786F,
      icon: Icons.waves_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 7: জযম / সাকিন (Sukoon)
  // Listen → Tap Answer → Sort → Word Builder → Speed Reading → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep7Sukoon() {
    final sukoonLessons = [
      {'name': 'জযমের পরিচয়', 'ex': 'أَبْ', 'desc': 'জযমওয়ালা হরফ পূর্বের হরকতের সাথে মিলিয়ে পড়তে হয়।'},
      {'name': 'সাকিন অনুশীলন ১', 'ex': 'قُلْ', 'desc': 'পূর্বের হরকতের সাথে সহজে মেলানো।'},
      {'name': 'সাকিন অনুশীলন ২', 'ex': 'أَنْعَمْتَ', 'desc': 'শব্দের মাঝে সাকিন বিশুদ্ধভাবে পড়া।'},
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
          prompt: 'উচ্চারণ শুনুন এবং সঠিক সাকিনযুক্ত শব্দ নির্বাচন করুন:',
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
          prompt: 'কোন শব্দটিতে সাকিন (জযম) রয়েছে?',
          arabicTarget: 'قُلْ',
          options: ['قُلْ', 'قَالَ', 'قِيلَ'],
          correctIndex: 0,
          explanation: '“قُلْ”-এ লাম হরফের উপর সাকিন রয়েছে।',
        ),
        // 3. Sort
        QaidaActivity(
          id: 'step7_${i}_sort',
          slotNumber: 3,
          type: QaidaActivityType.sortGroups,
          prompt: 'সুকূনযুক্ত ও হরকতযুক্ত শব্দ আলাদা করো:',
          sortingCategories: {
            'সুকূনযুক্ত হরফ': ['أَبْ', 'قُلْ', 'مَنْ'],
            'হরকতযুক্ত হরফ': ['أَبَ', 'قَالَ', 'مَنَ'],
          },
          explanation: 'সুকূনযুক্ত হরফ একা পড়া যায় না, পূর্বের হরকতের সাথে মেলে।',
        ),
        // 4. Word Builder
        QaidaActivity(
          id: 'step7_${i}_word',
          slotNumber: 4,
          type: QaidaActivityType.buildArrange,
          prompt: 'টুকরোগুলো সাজিয়ে “يَعْلَمُ” শব্দ গঠন করো:',
          tiles: [
            ActivityTile(id: 't1', label: 'يَ', arabicLabel: 'يَ'),
            ActivityTile(id: 't2', label: 'عْ', arabicLabel: 'عْ'),
            ActivityTile(id: 't3', label: 'لَ', arabicLabel: 'لَ'),
            ActivityTile(id: 't4', label: 'مُ', arabicLabel: 'مُ'),
          ],
          explanation: 'মাশাআল্লাহ! “يَعْلَمُ” শব্দ সফলভাবে তৈরি হয়েছে।',
        ),
        // 5. Speed Reading
        QaidaActivity(
          id: 'step7_${i}_speed',
          slotNumber: 5,
          type: QaidaActivityType.speedReading,
          prompt: 'দ্রুত ও বিশুদ্ধভাবে সাকিনের শব্দগুলো পড়ো:',
          arabicTarget: 'أَبْ - أَتْ - أَثْ',
          options: ['أَبْ - أَتْ - أَثْ', 'أَجْ - أَحْ - أَخْ', 'أَدْ - أَذْ - أَرْ'],
          correctIndex: 0,
          explanation: 'চমৎকার! সাকিনযুক্ত হরফের উচ্চারণ মসৃণভাবে সম্পন্ন করেছ।',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step7_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে স্পষ্ট সাকিনে পড়ো: “أَنْعَمْتَ عَلَيْহِمْ”',
          arabicTarget: 'أَنْعَمْتَ عَلَيْهِمْ',
          explanation: 'সাকিনের হরফে সুস্পষ্ট বিরতি দিয়ে পরবর্তী হরফে যাও।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step7_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'সুকূন বস চ্যালেঞ্জ! “أَنْعَمْتَ” শব্দে কয়টি হরফে সাকিন (জযম) রয়েছে?',
          arabicTarget: 'أَنْعَمْتَ',
          options: ['২টি (নূন ও মীম সাকিন)', '১টি হরফে', '৩টি হরফে'],
          correctIndex: 0,
          explanation: 'অভিনন্দন! জযম / সাকিনের সকল চ্যালেঞ্জ সফলভাবে সম্পন্ন করেছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step7_lesson_$i',
          trackId: 'step_7_sukoon',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 7,
      id: 'step_7_sukoon',
      title: 'জযম / সাকিন',
      titleEn: 'Sukoon',
      arabicTitle: 'السُّكُون',
      description: 'জযমযুক্ত হরফ পূর্বের হরকতের সাথে মিলিয়ে পড়া',
      phaseNumber: 3,
      phaseName: 'Phase 3: Sukoon-Shaddah',
      lessons: lessons,
      gardenPlant: 'Fig Tree (ডুমুর গাছ)',
      colorHex: 0xFF0D9488,
      icon: Icons.pause_circle_outline_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 8: তাশদীদ (Shaddah - দুইবার উচ্চারণ)
  // Listen → Match → Sequence → Word Builder → Sing Along gap → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep8Shaddah() {
    final shaddahLessons = [
      {'name': 'তাশদীদের পরিচয়', 'ex': 'أَنَّ', 'desc': 'তাশদীদযুক্ত হরফে ওজন ও শক্তি থাকে।'},
      {'name': 'তাশদীদ ও হরকত', 'ex': 'رَبِّ', 'desc': 'প্রথমে পূর্বের হরফের সাথে সাকিন, পরে নিজস্ব হরকত।'},
      {'name': 'তাশদীদ অনুশীলন', 'ex': 'ثُمَّ', 'desc': 'শব্দের মাঝে তাশদীদ বিশুদ্ধভাবে পড়া।'},
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
          prompt: 'উচ্চারণ শুনুন এবং তাশদীদযুক্ত শব্দটি চিহ্নিত করুন:',
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
          prompt: 'তাশদীদযুক্ত শব্দ ও তার ভাঙা রূপ মেলাও:',
          pairs: {
            'رَبَّ': 'رَبْ + بَ (দুইবার)',
            'حَجَّ': 'حَجْ + جَ (দুইবার)',
            'ثُمَّ': 'ثُمْ + مَ (দুইবার)',
          },
          explanation: 'তাশদীদওয়ালা হরফ দুইবার উচ্চারিত হয় — একবার সাকিন, একবার হরকত।',
        ),
        // 3. Sequence
        QaidaActivity(
          id: 'step8_${i}_seq',
          slotNumber: 3,
          type: QaidaActivityType.sequenceOrder,
          prompt: 'তাশদীদের ভাঙা রূপ থেকে যুক্ত রূপে সাজাও:',
          sequenceItems: ['رَ', 'بْ', 'بَ', 'رَبَّ'],
          explanation: 'প্রথমে সাকিন দিয়ে বাঁধা, তারপর হরকতে ছাড়া।',
        ),
        // 4. Word Builder
        QaidaActivity(
          id: 'step8_${i}_word',
          slotNumber: 4,
          type: QaidaActivityType.buildArrange,
          prompt: 'হরফ সাজিয়ে তাশদীদযুক্ত শব্দ “إِنَّ” তৈরি করো:',
          tiles: [
            ActivityTile(id: 't1', label: 'إِ', arabicLabel: 'إِ'),
            ActivityTile(id: 't2', label: 'نَّ', arabicLabel: 'نَّ'),
          ],
          explanation: 'সঠিক! “إِنَّ” শব্দ সফলভাবে গঠিত হয়েছে।',
        ),
        // 5. Sing Along Gap
        QaidaActivity(
          id: 'step8_${i}_gap',
          slotNumber: 5,
          type: QaidaActivityType.singAlongGap,
          prompt: 'সুরে সুরে তিলাওয়াত শুনুন এবং সঠিক তাশদীদযুক্ত শব্দটি বসান:',
          arabicTarget: 'تَبَّتْ يَدَا أَبِي لَهَبٍ _____ ۝',
          options: ['وَتَبَّ', 'مَا أَغْنَىٰ', 'سَيَصْلَىٰ'],
          correctIndex: 0,
          explanation: 'সূরা লাহাবের আয়াত: “تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ”',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step8_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে ওজনের সাথে দুইবার উচ্চারণ করো: “ثُمَّ كَلَّا سَوْفَ تَعْلَمُونَ”',
          arabicTarget: 'ثُمَّ كَلَّا سَوْفَ تَعْلَمُونَ',
          explanation: 'তাশদীদের হরফে পূর্ণ ওজন দিয়ে উচ্চারণ সম্পন্ন করো।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step8_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'তাশদীদ বস চ্যালেঞ্জ! “إِيَّاكَ” শব্দে তাশদীদযুক্ত হরফটি কোনটি?',
          arabicTarget: 'إِيَّاكَ',
          options: ['ইয়া হরফে (يَّ)', 'আলিফ হরফে (إِ)', 'কাফ হরফে (كَ)'],
          correctIndex: 0,
          explanation: 'মাশাআল্লাহ! তাশদীদের চ্যালেঞ্জে চমৎকার কৃতিত্ব দেখিয়েছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step8_lesson_$i',
          trackId: 'step_8_shaddah',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 8,
      id: 'step_8_shaddah',
      title: 'তাশদীদ',
      titleEn: 'Shaddah',
      arabicTitle: 'التَّشْدِيد',
      description: 'তাশদীদওয়ালা হরফ দুইবার উচ্চারিত হয় — একবার সাকিন, একবার হরকত',
      phaseNumber: 3,
      phaseName: 'Phase 3: Sukoon-Shaddah',
      lessons: lessons,
      gardenPlant: 'Citrus Tree (লেবু গাছ)',
      colorHex: 0xFFF59E0B,
      icon: Icons.repeat_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 9: নূন সাকিন ও তানভীন (Noon Sakin - ইযহার, ইদগাম, ইক্বলাব, ইখফা)
  // Listen → Sort (4 niyom) → Memory → Odd One Out → Puzzle → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep9NoonSakin() {
    final noonLessons = [
      {'name': 'ইযহার (স্পষ্ট)', 'ex': 'مَنْ آمَنَ', 'desc': 'হলক্বী হরফ আসলে গুন্নাহ ছাড়া স্পষ্ট পড়া।'},
      {'name': 'ইখফা (গোপন)', 'ex': 'مِنْ قَبْلُ', 'desc': 'নাকের বাঁশিতে শব্দ গোপন করে গুন্নাহ করা।'},
      {'name': 'ইদগাম ও ইক্বলাব', 'ex': 'مِن بَعْدِ', 'desc': 'পরবর্তী হরফের সাথে মিলিয়ে বা মীমে বদলে পড়া।'},
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
          prompt: 'উচ্চারণ শুনুন এবং সঠিক উদাহরণটি চিহ্নিত করুন:',
          arabicTarget: ex,
          options: ['مَنْ آمَنَ', 'مِنْ قَبْلُ', 'مِن بَعْدِ'],
          correctIndex: i,
          explanation: desc,
        ),
        // 2. Sort (4 নিয়মের বাস্কেট)
        QaidaActivity(
          id: 'step9_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'নূন সাকিনের ৪টি নিয়মে উদাহরণগুলোকে সাজাও:',
          sortingCategories: {
            'ইযহার (স্পষ্ট)': ['مَنْ آمَنَ', 'مِنْ خَوْفٍ'],
            'ইখফা (গোপন গুন্নাহ)': ['مِنْ قَبْلُ', 'عَنْ صَلَاتِهِمْ'],
            'ইদগাম (মিলিয়ে)': ['مَن يَّقُولُ', 'مِن مَّالٍ'],
            'ইকলাব (মীম দিয়ে বদল)': ['مِن بَعْدِ', 'أَنبِئْهُم'],
          },
          explanation: 'ইযহার, ইদগাম, ইকলাব ও ইখফা — নূন সাকিনের মূল ৪টি তাজবীদ বিধান।',
        ),
        // 3. Memory
        QaidaActivity(
          id: 'step9_${i}_memory',
          slotNumber: 3,
          type: QaidaActivityType.memoryMatch,
          prompt: 'নূন সাকিনের উদাহরণ ও নিয়মের জোড়া মেলাও:',
          pairs: {
            'مَنْ آمَنَ': 'ইযহার (হলক্বী হরফ)',
            'مِنْ قَبْلُ': 'ইখফা (১৫ হরফ)',
            'مَن يَّقُولُ': 'ইদগাম (ইয়ারমালূন)',
            'مِن بَعْدِ': 'ইকলাব (বা হরফ)',
          },
          explanation: 'দারুন তাজবীদ জ্ঞান! জোড়াগুলো সফলভাবে মিলেছে।',
        ),
        // 4. Odd One Out
        QaidaActivity(
          id: 'step9_${i}_odd',
          slotNumber: 4,
          type: QaidaActivityType.oddOneOut,
          prompt: 'কোনটি ভিন্ন তাজবীদ নিয়ম? বের করো:',
          arabicTarget: 'مِنْ قَبْلُ',
          options: ['مَنْ آمَنَ', 'مِنْ حَكِيمٍ', 'مِنْ خَوْفٍ', 'مِنْ قَبْلُ'],
          correctIndex: 3,
          explanation: 'সঠিক! প্রথম ৩টি ইযহার (হলক্বী হরফ), কিন্তু “مِنْ قَبْلُ” হলো ইখফা।',
        ),
        // 5. Puzzle
        QaidaActivity(
          id: 'step9_${i}_puzzle',
          slotNumber: 5,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'টুকরো জোড়া লাগিয়ে ইখফার শব্দ “مِنْ قَبْلِ” তৈরি করো:',
          puzzlePieces: ['مِنْ', 'قَبْ', 'لِ'],
          explanation: 'মাশাআল্লাহ! নূন সাকিনের ইখফা শব্দ গঠিত হয়েছে।',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step9_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে বিশুদ্ধ তাজবীদে পড়ো: “مَنْ آمَنَ بِاللَّهِ وَالْيَوْمِ الْآخِرِ”',
          arabicTarget: 'مَنْ آمَنَ بِاللَّهِ',
          explanation: 'হলক্বী হরফের পূর্বে নূন সাকিন গুন্নাহ ছাড়া স্পষ্ট পড়তে হয়।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step9_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'নূন সাকিন বস চ্যালেঞ্জ! “مِن بَعْدِ”-এ নূন সাকিনের পর বা (ب) আসলে কোন বিধান প্রযোজ্য?',
          arabicTarget: 'مِن بَعْدِ',
          options: ['ইকলাব (নূনকে মীমে বদলে গুন্নাহ)', 'ইযহার (স্পষ্ট পড়া)', 'ইদগাম (মিলিয়ে পড়া)'],
          correctIndex: 0,
          explanation: 'মাশাআল্লাহ! নূন সাকিনের সকল নিয়ম নির্ভুলভাবে সম্পন্ন করেছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step9_lesson_$i',
          trackId: 'step_9_noon_sakin',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 9,
      id: 'step_9_noon_sakin',
      title: 'নূন সাকিন ও তানভীন',
      titleEn: 'Noon Sakin',
      arabicTitle: 'أَحْكَام النُّون السَّاكِنَة',
      description: 'ইযহার (স্পষ্ট), ইদগাম (মিলিয়ে), ইক্বলাব (বদলিয়ে), ইখফা (গোপন)',
      phaseNumber: 4,
      phaseName: 'Phase 4: Tajweed Core',
      lessons: lessons,
      gardenPlant: 'Golden Lantern (সোনালী লণ্ঠন)',
      colorHex: 0xFF6366F1,
      icon: Icons.auto_awesome_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 10: মীম সাকিন (Meem Sakin - ৩টি নিয়ম)
  // Listen → Match → Sort → Tap Answer → Word Builder → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep10MeemSakin() {
    final meemLessons = [
      {'name': 'ইখফায়ে শাফাবী', 'ex': 'تَرْمِيهِمْ بِحِجَارَةٍ', 'desc': 'মীম সাকিনের পর বা আসলে গুন্নাহসহ ঠোঁট নরম রাখা।'},
      {'name': 'ইদগামে শাফাবী', 'ex': 'لَهُمْ مَّا', 'desc': 'মীম সাকিনের পর মীম আসলে মিলিয়ে গুন্নাহ করা।'},
      {'name': 'ইযহারে শাফাবী', 'ex': 'هُمْ فِيهَا', 'desc': 'বা ও মীম ছাড়া বাকি হরফে স্পষ্ট পড়া।'},
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
          prompt: 'মীম সাকিনের উচ্চারণ শুনুন এবং সঠিক উদাহরণ নির্বাচন করুন:',
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
          prompt: 'মীম সাকিনের বিধান ও উদাহরণের জোড়া মেলাও:',
          pairs: {
            'تَرْمِيهِمْ بِحِجَارَةٍ': 'ইখফায়ে শাফাবী (বা আসলে)',
            'لَهُمْ مَّا': 'ইদগামে শাফাবী (মীম আসলে)',
            'هُمْ فِيهَا': 'ইযহারে শাফাবী (অন্য হরফে)',
          },
          explanation: 'মীম সাকিনের ৩টি নিয়ম: ইখফায়ে শাফাবী, ইদগামে শাফাবী, ইযহারে শাফাবী।',
        ),
        // 3. Sort
        QaidaActivity(
          id: 'step10_${i}_sort',
          slotNumber: 3,
          type: QaidaActivityType.sortGroups,
          prompt: 'মীম সাকিনের ৩টি নিয়মে উদাহরণগুলোকে সাজাও:',
          sortingCategories: {
            'ইখফায়ে শাফাবী': ['تَرْمِيهِمْ بِحِجَارَةٍ', 'وَكَلْبُهُمْ بَاسِطٌ'],
            'ইযহারে শাফাবী': ['هُمْ فِيهَا', 'عَلَيْهِمْ غَيْرِ'],
            'ইদগামে শাফাবী': ['لَهُمْ مَّا', 'كُنتُم مُّؤْمِنِينَ'],
          },
          explanation: 'মীম সাকিনের পর বা আসলে ইখফা, মীম আসলে ইদগাম, অন্য হরফে ইযহার।',
        ),
        // 4. Tap Answer
        QaidaActivity(
          id: 'step10_${i}_tap',
          slotNumber: 4,
          type: QaidaActivityType.recognize,
          prompt: '“عَلَيْهِمْ غَيْرِ”-এ মীম সাকিনের পর গাইন (غ) আসলে কীভাবে পড়তে হবে?',
          arabicTarget: 'عَلَيْهِمْ غَيْرِ',
          options: ['ইযহারে শাফাবী (স্পষ্ট গুন্নাহ ছাড়া)', 'ইখফায়ে শাফাবী (গুন্নাহসহ)', 'ইদগামে শাফাবী (মিলিয়ে)'],
          correctIndex: 0,
          explanation: 'সঠিক! বা ও মীম ছাড়া বাকি ২৬ হরফে মীম সাকিন স্পষ্ট পড়তে হয়।',
        ),
        // 5. Word Builder
        QaidaActivity(
          id: 'step10_${i}_word',
          slotNumber: 5,
          type: QaidaActivityType.buildArrange,
          prompt: 'টুকরোগুলো সাজিয়ে “تَرْمِيهِمْ بِحِجَارَةٍ” গঠন করো:',
          tiles: [
            ActivityTile(id: 't1', label: 'تَرْمِي', arabicLabel: 'تَرْمِي'),
            ActivityTile(id: 't2', label: 'هِمْ', arabicLabel: 'هِمْ'),
            ActivityTile(id: 't3', label: 'بِـ', arabicLabel: 'بِـ'),
            ActivityTile(id: 't4', label: 'حِجَارَةٍ', arabicLabel: 'حِجَارَةٍ'),
          ],
          explanation: 'মাশাআল্লাহ! বাক্য সফলভাবে তৈরি হয়েছে।',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step10_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে বলো: “لَهُمْ مَّا يَشَاءُونَ فِيهَا”',
          arabicTarget: 'لَهُمْ مَّا يَشَاءُونَ',
          explanation: 'মীম সাকিন পরবর্তী মীমে মিলিয়ে সুন্দর গুন্নাহ আদায় করো।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step10_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'মীম সাকিন বস চ্যালেঞ্জ! “هُمْ نَائِمُونَ” শব্দে মীম সাকিনের বিধান কোনটি?',
          arabicTarget: 'هُمْ نَائِمُونَ',
          options: ['ইযহারে শাফাবী', 'ইখফায়ে শাফাবী', 'ইদগামে শাফাবী'],
          correctIndex: 0,
          explanation: 'অভিনন্দন! মীম সাকিন বস চ্যালেঞ্জ সফলভাবে সম্পন্ন করেছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step10_lesson_$i',
          trackId: 'step_10_meem_sakin',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 10,
      id: 'step_10_meem_sakin',
      title: 'মীম সাকিন',
      titleEn: 'Meem Sakin',
      arabicTitle: 'أَحْكَام الْمِيم السَّاكِنَة',
      description: 'ইখফায়ে শাফাবী, ইদগামে শাফাবী, ইযহারে শাফাবী',
      phaseNumber: 4,
      phaseName: 'Phase 4: Tajweed Core',
      lessons: lessons,
      gardenPlant: 'Silver Lantern (রুপালী লণ্ঠন)',
      colorHex: 0xFF8B5CF6,
      icon: Icons.blur_on_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 11: ওয়াজিব গুন্নাহ (Ghunnah - নাকের বাঁশি দিয়ে টানা)
  // Listen → Odd One Out → Sort (ghunnah ache/nai) → Sequence → Sing Along gap → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep11Ghunnah() {
    final ghunnahLessons = [
      {'name': 'নূন তাশদীদ গুন্নাহ', 'ex': 'إِنَّ', 'desc': 'নূন মুশাদদাদ ওয়াজিব গুন্নাহ।'},
      {'name': 'মীম তাশদীদ গুন্নাহ', 'ex': 'ثُمَّ', 'desc': 'মীম মুশাদদাদ ওয়াজিব গুন্নাহ।'},
      {'name': 'গুন্নাহ অনুশীলন', 'ex': 'عَمَّ', 'desc': 'নাকের সুর ঠিক রেখে ১ আলিফ পরিমাণ টানা।'},
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
          prompt: 'গুন্নাহর মধুর ধ্বনি শুনুন এবং শব্দটি নির্বাচন করুন:',
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
          prompt: 'কোনটিতে ওয়াজিব গুন্নাহ নেই? আলাদাটি বের করো:',
          arabicTarget: 'كَتَبَ',
          options: ['إِنَّ', 'ثُمَّ', 'عَمَّ', 'كَتَبَ'],
          correctIndex: 3,
          explanation: 'সঠিক! “كَتَبَ”-তে কোনো তাশদীদযুক্ত নূন বা মীম নেই, তাই গুন্নাহ হবে না।',
        ),
        // 3. Sort (গুন্নাহ আছে / নেই)
        QaidaActivity(
          id: 'step11_${i}_sort',
          slotNumber: 3,
          type: QaidaActivityType.sortGroups,
          prompt: 'ওয়াজিব গুন্নাহযুক্ত ও সাধারণ শব্দ আলাদা করো:',
          sortingCategories: {
            'ওয়াজিব গুন্নাহ হবে': ['إِنَّ', 'ثُمَّ', 'عَمَّ'],
            'গুন্নাহ হবে না': ['قَالَ', 'كَتَبَ', 'ذَهَبَ'],
          },
          explanation: 'নূন ও মীমে তাশদীদ থাকলে অবশ্যই ১ আলিফ পরিমাণ গুন্নাহ করতে হয়।',
        ),
        // 4. Sequence
        QaidaActivity(
          id: 'step11_${i}_seq',
          slotNumber: 4,
          type: QaidaActivityType.sequenceOrder,
          prompt: 'সাকিন ও হরকত থেকে ওয়াজিব গুন্নাহর ক্রম সাজাও:',
          sequenceItems: ['نْ', 'نَ', 'نَّ', 'إِنَّ'],
          explanation: 'তাশদীদে দুইবার উচ্চারণের সাথে নাকের সুর যুক্ত হয়।',
        ),
        // 5. Sing Along Gap
        QaidaActivity(
          id: 'step11_${i}_gap',
          slotNumber: 5,
          type: QaidaActivityType.singAlongGap,
          prompt: 'সুরে সুরে তিলাওয়াত শুনুন এবং সঠিক শব্দটি বসান:',
          arabicTarget: 'قُلْ أَعُوذُ بِرَبِّ _____ ۝',
          options: ['النَّاسِ', 'الْفَلَقِ', 'الصَّمَدِ'],
          correctIndex: 0,
          explanation: 'সূরা নাসের আয়াত: “قُلْ أَعُوذُ بِرَبِّ النَّاسِ” (নূন তাশদীদে ওয়াজিব গুন্নাহ)।',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step11_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে ১ আলিফ পরিমাণ নাকের বাঁশিতে টেনে বলো: “عَمَّ يَتَسَاءَلُونَ”',
          arabicTarget: 'عَمَّ يَتَسَاءَلُونَ',
          explanation: 'ওয়াজিব গুন্নাহ অত্যন্ত পরিচ্ছন্ন ও আকর্ষণীয় করে আদায় করো।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step11_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'গুন্নাহ বস চ্যালেঞ্জ! “إِنَّ الْإِنسَانَ”-এ নূন তাশদীদে গুন্নাহ করার হুকুম কী?',
          arabicTarget: 'إِنَّ الْإِنسَانَ',
          options: ['ওয়াজিব গুন্নাহ (অবশ্যই ১ আলিফ)', 'মুস্তাহাব গুন্নাহ', 'গুন্নাহ ছাড়া দ্রুত পড়া'],
          correctIndex: 0,
          explanation: 'মাশাআল্লাহ! গুন্নাহ ধাপের বস চ্যালেঞ্জ সফলভাবে উত্তীর্ণ হয়েছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step11_lesson_$i',
          trackId: 'step_11_ghunnah',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 11,
      id: 'step_11_ghunnah',
      title: 'ওয়াজিব গুন্নাহ',
      titleEn: 'Ghunnah',
      arabicTitle: 'الْغُنَّة',
      description: 'নূন ও মীমে তাশদীদ থাকলে নাকের বাঁশিতে ১ আলিফ গুন্নাহ আবশ্যক',
      phaseNumber: 4,
      phaseName: 'Phase 4: Tajweed Core',
      lessons: lessons,
      gardenPlant: 'Emerald Fountain (মরকত ফোয়ারা)',
      colorHex: 0xFF10B981,
      icon: Icons.graphic_eq_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 12: মাদ্দ (Madd - ১, ৩, ৪, ৬ আলিফ টানা)
  // Listen → Sort (madd er dhoron) → Memory → Puzzle → Speed Reading → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep12Madd() {
    final maddLessons = [
      {'name': 'মাদ্দে আসলী (১ আলিফ)', 'ex': 'قَالَ', 'desc': 'মাদ্দের হরফের পর কারণ না থাকলে স্বাভাবিক ১ আলিফ টানা।'},
      {'name': 'মাদ্দে মুনফাসিল (৩/৪ আলিফ)', 'ex': 'فِي أَنفُسِكُمْ', 'desc': 'পরের শব্দে হামযাহ আসলে ৩ বা ৪ আলিফ টানা।'},
      {'name': 'মাদ্দে মুত্তাসিল ও লাযিম (৪/৬ আলিফ)', 'ex': 'جَاءَ', 'desc': 'একই শব্দে হামযাহ আসলে ৪ আলিফ, আর সাকিন বা তাশদীদ আসলে ৬ আলিফ টানা।'},
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
          prompt: 'টেনে পড়ার ধ্বনি শুনুন এবং সঠিক মাদ্দযুক্ত শব্দ বেছে নিন:',
          arabicTarget: ex,
          options: ['قَالَ', 'جَاءَ', 'الضَّالِّينَ'],
          correctIndex: i,
          explanation: desc,
        ),
        // 2. Sort (মাদ্দের প্রকার)
        QaidaActivity(
          id: 'step12_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'মাদ্দের প্রকার অনুযায়ী শব্দগুলোকে আলাদা ঘরে রাখো:',
          sortingCategories: {
            '১ আলিফ (মাদ্দে আসলী)': ['قَالَ', 'يَقُولُ', 'قِيلَ'],
            '৪ আলিফ (মাদ্দে মুত্তাসিল)': ['جَاءَ', 'السَّمَاءِ', 'سُوءَ'],
            '৬ আলিফ (মাদ্দে লাযিম)': ['الضَّالِّينَ', 'الحَاقَّةُ'],
          },
          explanation: 'মাদ্দে আসলীতে ১ আলিফ, মুত্তাসিলে ৪ আলিফ, লাযিমে ৬ আলিফ টানতে হয়।',
        ),
        // 3. Memory
        QaidaActivity(
          id: 'step12_${i}_memory',
          slotNumber: 3,
          type: QaidaActivityType.memoryMatch,
          prompt: 'শব্দ ও তার মাদ্দের পরিমাণের জোড়া মেলাও:',
          pairs: {
            'قَالَ': '১ আলিফ (মাদ্দে আসলী)',
            'جَاءَ': '৪ আলিফ (মাদ্দে মুত্তাসিল)',
            'الضَّالِّينَ': '৬ আলিফ (মাদ্দে লাযিম)',
          },
          explanation: 'চমৎকার! মাদ্দের সঠিক মাত্রা স্মরণ রেখেছ।',
        ),
        // 4. Puzzle
        QaidaActivity(
          id: 'step12_${i}_puzzle',
          slotNumber: 4,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'মাদ্দের টুকরোগুলো সাজিয়ে “السَّمَاءِ” গঠন করো:',
          puzzlePieces: ['السَّ', 'مَا', 'ءِ'],
          explanation: 'মাশাআল্লাহ! মাদ্দে মুত্তাসিলযুক্ত শব্দ তৈরি হয়েছে।',
        ),
        // 5. Speed Reading
        QaidaActivity(
          id: 'step12_${i}_speed',
          slotNumber: 5,
          type: QaidaActivityType.speedReading,
          prompt: 'মাদ্দের পরিমাণ বজায় রেখে দ্রুত শব্দগুলো পড়ো:',
          arabicTarget: 'قَالَ - قِيلَ - يَقُولُ',
          options: ['قَالَ - قِيلَ - يَقُولُ', 'جَاءَ - سُوءَ - جِيءَ', 'دَابَّةٍ - الحَاقَّةُ'],
          correctIndex: 0,
          explanation: 'মাদ্দের মাত্রা নিখুঁত রেখে দ্রুত পড়ার অনুশীলন সম্পন্ন হলো।',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step12_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে ৪ আলিফ টেনে বলো: “إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ”',
          arabicTarget: 'إِذَا جَاءَ نَصْرُ اللَّهِ',
          explanation: 'মাদ্দে মুত্তাসিল ৪ আলিফ পরিমাণ সুন্দরভাবে টেনে সম্পন্ন করো।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step12_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'মাদ্দ বস চ্যালেঞ্জ! “وَلَا الضَّالِّينَ”-এ মাদ্দের হরফের পর তাশদীদ থাকায় কত আলিফ টানতে হবে?',
          arabicTarget: 'وَلَا الضَّالِّينَ',
          options: ['৬ আলিফ (মাদ্দে লাযিম)', '১ আলিফ (মাদ্দে আসলী)', '২ আলিফ'],
          correctIndex: 0,
          explanation: 'অভিনন্দন! মাদ্দের কঠিন নিয়মগুলো সফলভাবে আয়ত্ত করেছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step12_lesson_$i',
          trackId: 'step_12_madd',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 12,
      id: 'step_12_madd',
      title: 'মাদ্দের নিয়ম',
      titleEn: 'Madd',
      arabicTitle: 'الْمَدّ',
      description: 'আওয়াজকে টেনে লম্বা করা — আসলী, মুত্তাসিল, মুনফাসিল, লাযিম',
      phaseNumber: 4,
      phaseName: 'Phase 4: Tajweed Core',
      lessons: lessons,
      gardenPlant: 'Crystal Pavillion (স্ফটিক চত্বর)',
      colorHex: 0xFFEC4899,
      icon: Icons.linear_scale_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 13: লামের নিয়ম (Shamsi / Qamari)
  // Listen → Sort (shamsi/qamari) → Match → Word Builder → Tap Answer → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep13LamRules() {
    final lamLessons = [
      {'name': 'হুরুফে ক্বামারিইয়াহ', 'ex': 'الْقَمَرُ', 'desc': 'আলিফ লাম স্পষ্ট পড়া হয়।'},
      {'name': 'হুরুফে শামসিয়াহ', 'ex': 'الشَّمْسُ', 'desc': 'লাম বাদ দিয়ে পরের হরফে তাশদীদ দিয়ে পড়া হয়।'},
      {'name': 'শামসী-ক্বামারী তুলনা', 'ex': 'الْبَابُ | التَّاجِرُ', 'desc': 'দুই নিয়মের স্পষ্ট পার্থক্যকরণ।'},
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
          prompt: 'উচ্চারণ শুনুন এবং সঠিক শব্দটি নির্বাচন করুন:',
          arabicTarget: ex,
          options: ['الشَّمْسُ', 'الْقَمَرُ', 'الْكِتَابُ'],
          correctIndex: i == 0 ? 1 : 0,
          explanation: desc,
        ),
        // 2. Sort (শামসী vs ক্বামারী)
        QaidaActivity(
          id: 'step13_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'শামসী (লাম অনুচ্চারিত) ও ক্বামারী (লাম উচ্চারিত) শব্দ আলাদা করো:',
          sortingCategories: {
            'হুরুফে শামসিয়াহ (লাম অনুচ্চারিত)': ['الشَّمْسُ', 'النَّاسُ', 'الرَّحْمٰنُ'],
            'হুরুফে ক্বামারিইয়াহ (লাম উচ্চারিত)': ['الْقَمَرُ', 'الْحَمْدُ', 'الْكِتَابُ'],
          },
          explanation: 'শামসী হরফের পূর্বে লাম উচ্চারিত হয় না, ক্বামারী হরফের পূর্বে লাম স্পষ্ট উচ্চারিত হয়।',
        ),
        // 3. Match
        QaidaActivity(
          id: 'step13_${i}_match',
          slotNumber: 3,
          type: QaidaActivityType.matchPairs,
          prompt: 'শব্দ ও তার লামের নিয়মের জোড়া মেলাও:',
          pairs: {
            'الشَّمْسُ': 'শামসী (লাম অনুচ্চারিত)',
            'الْقَمَرُ': 'ক্বামারী (লাম উচ্চারিত)',
            'النَّاسُ': 'শামসী (লাম অনুচ্চারিত)',
            'الْحَمْدُ': 'ক্বামারী (লাম উচ্চারিত)',
          },
          explanation: 'চমৎকার! শামসী ও ক্বামারী নিয়ম নির্ভুলভাবে চিহ্নিত করেছ।',
        ),
        // 4. Word Builder
        QaidaActivity(
          id: 'step13_${i}_word',
          slotNumber: 4,
          type: QaidaActivityType.buildArrange,
          prompt: 'টুকরোগুলো সাজিয়ে ক্বামারী শব্দ “الْحَمْدُ” গঠন করো:',
          tiles: [
            ActivityTile(id: 't1', label: 'الْـ', arabicLabel: 'الْـ'),
            ActivityTile(id: 't2', label: 'حَمْـ', arabicLabel: 'حَمْـ'),
            ActivityTile(id: 't3', label: 'دُ', arabicLabel: 'دُ'),
          ],
          explanation: 'মাশাআল্লাহ! ক্বামারী শব্দ সঠিকভাবে তৈরি হয়েছে।',
        ),
        // 5. Tap Answer
        QaidaActivity(
          id: 'step13_${i}_tap',
          slotNumber: 5,
          type: QaidaActivityType.recognize,
          prompt: '“الرَّحِيمُ” শব্দে “লাম” উচ্চারিত হয় না কেন?',
          arabicTarget: 'الرَّحِيمُ',
          options: [
            'র (ر) শামসী হরফ হওয়ায় লাম অনুচ্চারিত',
            'র (ر) ক্বামারী হরফ হওয়ায় লাম উচ্চারিত',
            'র (ر) মাদ্দের হরফ হওয়ায়',
          ],
          correctIndex: 0,
          explanation: 'সঠিক! র হলো হুরুফে শামসিয়াহ, তাই লাম বাদ দিয়ে র-তে তাশদীদ হয়।',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step13_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে বলো: “مَالِكِ يَوْمِ الدِّينِ” (লাম বাদ দিয়ে ডালে তাশদীদ)',
          arabicTarget: 'مَالِكِ يَوْمِ الدِّينِ',
          explanation: 'ইদগামে শামসীর বিশুদ্ধ উচ্চারণ উস্তাদের সাথে মিলিয়ে নাও।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step13_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'লাম বস চ্যালেঞ্জ! “وَالشَّمْسِ وَضُحَاهَا”-এ আলিফ লামের বিধান কোনটি?',
          arabicTarget: 'وَالشَّمْسِ',
          options: ['ইদগামে শামসী (লাম অনুচ্চারিত)', 'ইযহারে ক্বামারী (লাম উচ্চারিত)', 'মাদ্দে আসলী'],
          correctIndex: 0,
          explanation: 'অভিনন্দন! লামের নিয়মের সকল পরীক্ষা সফলভাবে শেষ করেছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step13_lesson_$i',
          trackId: 'step_13_lam_rules',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 13,
      id: 'step_13_lam_rules',
      title: 'লামের নিয়ম',
      titleEn: 'Lam Rules',
      arabicTitle: 'لَام التَّعْرِيف',
      description: 'হুরুফে শামসিয়াহ (লাম অনুচ্চারিত) ও হুরুফে ক্বামারিইয়াহ (লাম উচ্চারিত)',
      phaseNumber: 5,
      phaseName: 'Phase 5: Advanced',
      lessons: lessons,
      gardenPlant: 'Sun & Moon Arch (সূর্য-চন্দ্র তোরণ)',
      colorHex: 0xFFF97316,
      icon: Icons.brightness_medium_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 14: র ও লামের পুর ও বারিক (Ra & Lam)
  // Listen → Odd One Out → Sort (mota/shorou) → Memory → Speed Reading → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep14RaAndLam() {
    final raLessons = [
      {'name': 'র হরফের পুর ও বারিক', 'ex': 'رَبَّنَا | رِجَالٌ', 'desc': 'যবর/পেশে মোটা, যের-এ পাতলা উচ্চারণ।'},
      {'name': 'আল্লাহ শব্দের লাম', 'ex': 'اللَّهَ | بِاللَّهِ', 'desc': 'পূর্বে যবর/পেশে মোটা, যের-এ পাতলা।'},
      {'name': 'পুর-বারিক অনুশীলন', 'ex': 'مِنْ قَبْلِ اللَّهِ', 'desc': 'বাক্যের মাঝে বিশুদ্ধ স্বর নির্বাচন।'},
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
          prompt: 'উভয় উচ্চারণ শুনুন এবং মোটা (পুর) স্বরের শব্দটি নির্বাচন করুন:',
          arabicTarget: 'رَبَّنَا',
          soundOptions: {
            'رَبَّنَا (মোটা স্বর)': 'tafkheem',
            'رِجَالٌ (পাতলা স্বর)': 'tarqeeq',
          },
          correctIndex: 0,
          explanation: desc,
        ),
        // 2. Odd One Out
        QaidaActivity(
          id: 'step14_${i}_odd',
          slotNumber: 2,
          type: QaidaActivityType.oddOneOut,
          prompt: 'কোন শব্দে র-এর উচ্চারণ পাতলা (বারিক)? বের করো:',
          arabicTarget: 'رِجَالٌ',
          options: ['رَبَّنَا', 'رَسُولٌ', 'رُحَمَاءُ', 'رِجَالٌ'],
          correctIndex: 3,
          explanation: 'সঠিক! “رِجَالٌ”-এ র-এর নিচে যের থাকায় পাতলা (বারিক) হবে।',
        ),
        // 3. Sort (মোটা vs পাতলা)
        QaidaActivity(
          id: 'step14_${i}_sort',
          slotNumber: 3,
          type: QaidaActivityType.sortGroups,
          prompt: 'মোটা (তাফখীম) ও পাতলা (তারক্বীক্ব) শব্দগুলো আলাদা করো:',
          sortingCategories: {
            'মোটা হবে (তাফখীম / পুর)': ['رَبَّنَا', 'رُحَمَاءُ', 'قَالَ اللَّهُ'],
            'পাতলা হবে (তারক্বীক্ব / বারিক)': ['رِجَالٌ', 'بِسْمِ اللَّهِ', 'قَدِيرٌ'],
          },
          explanation: 'যবর বা পেশ থাকলে মোটা, আর যের থাকলে পাতলা করে পড়তে হয়।',
        ),
        // 4. Memory
        QaidaActivity(
          id: 'step14_${i}_memory',
          slotNumber: 4,
          type: QaidaActivityType.memoryMatch,
          prompt: 'শব্দ ও তার মোটা/পাতলা নিয়মের জোড়া মেলাও:',
          pairs: {
            'رَبَّنَا': 'মোটা র (যবর থাকায়)',
            'رِجَالٌ': 'পাতলা র (যের থাকায়)',
            'اللَّهُ': 'মোটা লাম (যবর থাকায়)',
            'بِاللَّهِ': 'পাতলা লাম (যের থাকায়)',
          },
          explanation: 'দারুন স্মৃতিশক্তি! পুর ও বারিকের নিয়ম মিলে গেছে।',
        ),
        // 5. Speed Reading
        QaidaActivity(
          id: 'step14_${i}_speed',
          slotNumber: 5,
          type: QaidaActivityType.speedReading,
          prompt: 'মোটা ও পাতলা স্বর ঠিক রেখে দ্রুত পড়ো:',
          arabicTarget: 'رَبَّنَا - رِزْقًا - رُحَمَاءُ',
          options: ['رَبَّنَا - رِزْقًا - رُحَمَاءُ', 'اللَّهُ - لِلَّهِ - بِاللَّهِ', 'خَبِيرٌ - قَدِيرٌ - نَصِيرٌ'],
          correctIndex: 0,
          explanation: 'পুর ও বারিকের পার্থক্য নিখুঁত বজায় রেখে পাঠ শেষ হলো।',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step14_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে পড়ো: “بِسْمِ اللَّهِ الرَّحْمٰنِ الرَّحِيمِ” (লিল্লাহি পাতলা ও র মোটা)',
          arabicTarget: 'بِسْمِ اللَّهِ الرَّحْمٰنِ الرَّحِيمِ',
          explanation: 'আল্লাহ শব্দের লাম ও র হরফের স্বর নিখুঁতভাবে আদায় করো।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step14_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'র ও লাম বস চ্যালেঞ্জ! “مِنْ قَبْلِ اللَّهِ”-তে “আল্লাহ” শব্দের লাম কীভাবে পড়তে হবে?',
          arabicTarget: 'مِنْ قَبْلِ اللَّهِ',
          options: ['পাতলা / বারিক (পূর্বে যের থাকায়)', 'মোটা / পুর (পূর্বে পেশ থাকায়)', 'ওয়াজিব গুন্নাহসহ'],
          correctIndex: 0,
          explanation: 'অভিনন্দন! র ও লামের পুর-বারিক ধাপ সফলভাবে উত্তীর্ণ হয়েছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step14_lesson_$i',
          trackId: 'step_14_ra_lam',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 14,
      id: 'step_14_ra_lam',
      title: 'র ও লামের পুর-বারিক',
      titleEn: 'Ra and Lam',
      arabicTitle: 'تَفْخِيم وَتَرْقِيق',
      description: 'মোটা (তাফখীম) ও পাতলা (তারক্বীক্ব) স্বরে উচ্চারণ',
      phaseNumber: 5,
      phaseName: 'Phase 5: Advanced',
      lessons: lessons,
      gardenPlant: 'Cedar Tree (সুরভিত বৃক্ষ)',
      colorHex: 0xFF84CC16,
      icon: Icons.volume_up_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 15: মুক্বাত্তায়াত ও কলক্বলাহ (Muqatta'at & Qalqalah)
  // Listen → Match → Tap Answer → Sort → Sing Along gap → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep15MuqattaatAndQalqalah() {
    final qalqalahLessons = [
      {'name': 'কলক্বলাহর ৫টি হরফ', 'ex': 'قُطْبُ جَدٍّ', 'desc': 'ক্বাফ, তোয়া, বা, জীম, দাল সাকিন হলে আওয়াজ প্রতিধ্বনিত হয়।'},
      {'name': 'কলক্বলাহ অনুশীলন', 'ex': 'قُلْ هُوَ اللَّهُ أَحَدٌ', 'desc': 'থামার সময় স্পষ্ট কলক্বলাহ করা।'},
      {'name': 'হুরুফে মুক্বাত্তায়াত', 'ex': 'الم', 'desc': 'সূরার শুরুর হরফগুলো আলাদা আলাদা নামে পড়া।'},
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
          prompt: 'ক্বলক্বলাহর প্রতিধ্বনি শুনুন এবং সঠিক শব্দটি নির্বাচন করুন:',
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
          prompt: 'মুক্বাত্তায়াত ও ক্বলক্বলাহর হরফ ও শব্দের জোড়া মেলাও:',
          pairs: {
            'الم': 'আলিফ-লাম-মীম (মুক্বাত্তায়াত)',
            'أَحَدْ': 'দাল ক্বলক্বলাহ (প্রতিধ্বনি)',
            'يس': 'ইয়া-সীন (মুক্বাত্তায়াত)',
            'الْفَلَقْ': 'ক্বাফ ক্বলক্বলাহ (প্রতিধ্বনি)',
          },
          explanation: 'ক্বলক্বলাহর ৫ হরফ: ক্বাফ, তোয়া, বা, জীম, দাল (قُطْبُ جَدٍّ)।',
        ),
        // 3. Tap Answer
        QaidaActivity(
          id: 'step15_${i}_tap',
          slotNumber: 3,
          type: QaidaActivityType.recognize,
          prompt: 'ক্বলক্বলাহর হরফ কয়টি ও কী কী?',
          arabicTarget: 'قُطْبُ جَدٍّ',
          options: ['৫টি (ق, ط, ب, ج, د)', '৬টি হলক্বী হরফ', '৪টি মাদ্দের হরফ'],
          correctIndex: 0,
          explanation: 'সঠিক! ক্বলক্বলাহর হরফ ৫টি, একত্রে ক্বুতবু জাদ্দিন বলা হয়।',
        ),
        // 4. Sort
        QaidaActivity(
          id: 'step15_${i}_sort',
          slotNumber: 4,
          type: QaidaActivityType.sortGroups,
          prompt: 'ক্বলক্বলাহর হরফযুক্ত ও সাধারণ সাকিনযুক্ত শব্দ আলাদা করো:',
          sortingCategories: {
            'ক্বলক্বলাহর হরফ (ق ط ب ج د)': ['أَحَدْ', 'الْفَلَقْ', 'مُحِيطْ'],
            'সাধারণ সাকিনযুক্ত হরফ': ['الْحَمْدُ', 'أَنْعَمْتَ', 'قُلْ'],
          },
          explanation: 'ক্বলক্বলাহর হরফে সাকিন হলে স্পষ্ট প্রতিধ্বনি সৃষ্টি করে পড়তে হয়।',
        ),
        // 5. Sing Along Gap
        QaidaActivity(
          id: 'step15_${i}_gap',
          slotNumber: 5,
          type: QaidaActivityType.singAlongGap,
          prompt: 'সুরে সুরে তিলাওয়াত শুনুন এবং সঠিক ক্বলক্বলাহ শব্দ বসান:',
          arabicTarget: 'قُلْ هُوَ اللَّهُ _____ ۝',
          options: ['أَحَدٌ', 'الصَّمَدُ', 'كُفُوًا'],
          correctIndex: 0,
          explanation: 'সূরা ইখলাসের প্রথম আয়াত: “قُلْ هُوَ اللَّهُ أَحَدٌ” (দাল ক্বলক্বলাহ)।',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step15_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে বলো: “الم ۚ ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ”',
          arabicTarget: 'الم ۚ ذَٰلِكَ الْكِتَابُ',
          explanation: 'হুরুফে মুক্বাত্তায়াতের প্রতিটি হরফের নাম পূর্ণ মাদ্দের সাথে উচ্চারণ করো।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step15_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'কলক্বলাহ বস চ্যালেঞ্জ! “حَبْلٌ مِّن مَّسَدٍ”-এ বা (بْ) সাকিন হওয়ায় কোন তাজবীদ নিয়ম প্রযোজ্য?',
          arabicTarget: 'حَبْلٌ',
          options: ['ক্বলক্বলাহ (প্রতিধ্বনি সৃষ্টি করা)', 'ওয়াজিব গুন্নাহ করা', 'ইখফা করা'],
          correctIndex: 0,
          explanation: 'মাশাআল্লাহ! ক্বলক্বলাহ ও মুক্বাত্তায়াত ধাপ সফলভাবে সম্পন্ন করেছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step15_lesson_$i',
          trackId: 'step_15_muqattaat_qalqalah',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 15,
      id: 'step_15_muqattaat_qalqalah',
      title: 'মুক্বাত্তায়াত ও কলক্বলাহ',
      titleEn: 'Muqattaat & Qalqalah',
      arabicTitle: 'الْمُقَطَّعَات وَالْقَلْقَلَة',
      description: 'ক্বাফ, তোয়া, বা, জীম, দাল সাকিন হলে প্রতিধ্বনি এবং সূরার শুরুর হরফ',
      phaseNumber: 5,
      phaseName: 'Phase 5: Advanced',
      lessons: lessons,
      gardenPlant: 'Echoing Spring (প্রতিধ্বনিময় ঝর্ণা)',
      colorHex: 0xFF06B6D4,
      icon: Icons.surround_sound_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 16: ওয়াক্বফ (থামার নিয়ম)
  // Listen → Sort (waqf er chinho) → Sequence → Puzzle → Speed Reading → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep16Waqf() {
    final waqfLessons = [
      {'name': 'সাধারণ ওয়াক্বফ', 'ex': 'الْعَالَمِينَ ۝', 'desc': 'শেষ হরফের হরকত সাকিন হয়ে যায়।'},
      {'name': 'গোল তা ও তানভীনে ওয়াক্বফ', 'ex': 'جَنَّةً ۝', 'desc': 'গোল তা হা সাকিন হয়, দুই যবর ১ আলিফ হয়।'},
      {'name': 'ওয়াক্বফের বিভিন্ন চিহ্ন', 'ex': 'م | ط | ج | ز | ص', 'desc': 'চিহ্ন দেখে থামা বা না থামার সিদ্ধান্ত।'},
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
          prompt: 'আয়াতের শেষভাগে থামার উচ্চারণ শুনুন ও সঠিক বাক্য চিহ্নিত করুন:',
          arabicTarget: ex,
          options: ['الْعَالَمِينَ ۝', 'الرَّحِيمِ ۝', 'الدِّينِ ۝'],
          correctIndex: i,
          explanation: desc,
        ),
        // 2. Sort (ওয়াকফের চিহ্ন)
        QaidaActivity(
          id: 'step16_${i}_sort',
          slotNumber: 2,
          type: QaidaActivityType.sortGroups,
          prompt: 'ওয়াকফের চিহ্নগুলোকে তাদের বিধান অনুযায়ী সাজাও:',
          sortingCategories: {
            'ওয়াকফে লাযিম (م - অবশ্যই থামতে হবে)': ['م', 'لا (থামা নিষেধ)'],
            'ওয়াকফে জায়িয (ج - থামা ভালো)': ['ج', 'ط (ওয়াকফে মুতলাক্ব)'],
            'ওয়াকফে মুরাখখাস (ص/ز)': ['ص', 'ز'],
          },
          explanation: 'চিহ্ন অনুযায়ী ওয়াকফের নিয়ম মেনে সুন্দর কুরআন পাঠ নিশ্চিত হয়।',
        ),
        // 3. Sequence
        QaidaActivity(
          id: 'step16_${i}_seq',
          slotNumber: 3,
          type: QaidaActivityType.sequenceOrder,
          prompt: 'সূরা ফাতিহার প্রথম ৩টি আয়াত ক্রমানুসারে সাজাও:',
          sequenceItems: [
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ۝',
            'الرَّحْمٰنِ الرَّحِيمِ ۝',
            'مَالِكِ يَوْمِ الدِّينِ ۝',
          ],
          explanation: 'আয়াত শেষে ওয়াকফ করে ধারাবাহিকভাবে পড়ার দক্ষতা।',
        ),
        // 4. Puzzle
        QaidaActivity(
          id: 'step16_${i}_puzzle',
          slotNumber: 4,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'টুকরো সাজিয়ে ওয়াকফসহ বাক্য “جَنَّةً ۝ عَالِيَةً” তৈরি করো:',
          puzzlePieces: ['جَنَّةً', '۝', 'عَالِيَةً'],
          explanation: 'মাশাআল্লাহ! ওয়াকফ চিহ্নের বাক্য গঠিত হয়েছে।',
        ),
        // 5. Speed Reading
        QaidaActivity(
          id: 'step16_${i}_speed',
          slotNumber: 5,
          type: QaidaActivityType.speedReading,
          prompt: 'সাকিন করে সুন্দরভাবে ওয়াকফ করে পড়ো:',
          arabicTarget: 'الْعَالَمِينَ ۝',
          options: ['الْعَالَمِينَ ۝', 'الرَّحِيمِ ۝', 'الدِّينِ ۝'],
          correctIndex: 0,
          explanation: 'ওয়াকফ করার সময় শেষ অক্ষরে নিঃশ্বাস ছেড়ে সাকিন করা সম্পন্ন হলো।',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step16_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে আয়াতের শেষে শ্বাস ছেড়ে সুন্দর ওয়াকফ করো:',
          arabicTarget: 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ ۝ فَصَلِّ لِرَبِّكَ وَانْحَرْ ۝',
          explanation: 'আয়াতের সমাপ্তিতে শান্তভাবে বিরতি নাও।',
        ),
        // 7. Boss Challenge
        QaidaActivity(
          id: 'step16_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'ওয়াক্বফ বস চ্যালেঞ্জ! দুই যবরের (ً) উপর ওয়াকফ করলে কীভাবে পড়তে হয়?',
          arabicTarget: 'عَلِيمًا حَكِيمًا ۝',
          options: ['১ আলিফ টেনে পড়তে হয় (হাকীমা)', 'সাকিন করে পড়তে হয় (হাকীম)', 'দুই পেশ দিয়ে পড়তে হয়'],
          correctIndex: 0,
          explanation: 'অভিনন্দন! ওয়াকফের যাবতীয় নিয়ম চমৎকারভাবে সম্পন্ন করেছ!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step16_lesson_$i',
          trackId: 'step_16_waqf',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
          arabicDisplay: ex,
          description: desc,
          activities: activities,
        ),
      );
    }

    return NuraniStepInfo(
      stepNumber: 16,
      id: 'step_16_waqf',
      title: 'ওয়াক্বফ (থামার নিয়ম)',
      titleEn: 'Waqf',
      arabicTitle: 'الْوَقْف',
      description: 'আয়াতের শেষে বা চিহ্নে শ্বাস ছেড়ে সাকিন করে থামা',
      phaseNumber: 6,
      phaseName: 'Phase 6: Reading',
      lessons: lessons,
      gardenPlant: 'Resting Bower (বিশ্রাম কুটির)',
      colorHex: 0xFF64748B,
      icon: Icons.stop_circle_rounded,
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 17: পূর্ণাঙ্গ আয়াত তিলাওয়াত (Tilawat)
  // Listen → Word Builder → Sequence → Puzzle (sentence) → Sing Along gap → Voice Repeat → Boss
  // ---------------------------------------------------------------------------
  static NuraniStepInfo _buildStep17Tilawat() {
    final tilawatLessons = [
      {'name': 'ছোট বাক্য পঠন', 'ex': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', 'desc': 'প্রতিটি শব্দ তাজবীদসহ মেলানো।'},
      {'name': 'সূরা ফাতিহা তিলাওয়াত', 'ex': 'مَالِكِ يَوْمِ الدِّينِ', 'desc': 'মাখরাজ ও ওয়াক্বফ বজায় রাখা।'},
      {'name': 'ক্বায়দা সমাপনী তিলাওয়াত', 'ex': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', 'desc': 'কুরআনুল কারীম তিলাওয়াতের পূর্ণ যোগ্যতা অর্জন।'},
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
          prompt: 'পবিত্র তিলাওয়াত শুনুন এবং সঠিক পবিত্র আয়াতটি নির্বাচন করুন:',
          arabicTarget: ex,
          options: [
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            'الرَّحْمٰنِ الرَّحِيمِ',
            'مَالِكِ يَوْমِ الدِّينِ',
          ],
          correctIndex: i == 0 ? 0 : (i == 1 ? 2 : 1),
          explanation: desc,
        ),
        // 2. Word Builder
        QaidaActivity(
          id: 'step17_${i}_word',
          slotNumber: 2,
          type: QaidaActivityType.buildArrange,
          prompt: 'শব্দগুলো ক্রমানুসারে সাজিয়ে পূর্ণাঙ্গ আয়াত গঠন করো:',
          tiles: [
            ActivityTile(id: 't1', label: 'إِيَّاكَ', arabicLabel: 'إِيَّاكَ'),
            ActivityTile(id: 't2', label: 'نَعْبُدُ', arabicLabel: 'نَعْبُدُ'),
            ActivityTile(id: 't3', label: 'وَإِيَّاكَ', arabicLabel: 'وَإِيَّاكَ'),
            ActivityTile(id: 't4', label: 'نَسْتَعِينُ', arabicLabel: 'نَسْتَعِينُ'),
          ],
          explanation: 'মাশাআল্লাহ! পবিত্র আয়াত “إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ” গঠিত হয়েছে।',
        ),
        // 3. Sequence
        QaidaActivity(
          id: 'step17_${i}_seq',
          slotNumber: 3,
          type: QaidaActivityType.sequenceOrder,
          prompt: 'পবিত্র সূরা ফাতিহার আয়াতগুলো ক্রমানুসারে সাজাও:',
          sequenceItems: [
            'بِسْمِ اللَّهِ الرَّحْمٰنِ الرَّحِيمِ',
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            'الرَّحْمٰنِ الرَّحِيمِ',
            'مَالِكِ يَوْমِ الدِّينِ',
          ],
          explanation: 'চমৎকার! পবিত্র সূরা ফাতিহার ক্রম নিখুঁতভাবে সাজিয়েছ।',
        ),
        // 4. Puzzle
        QaidaActivity(
          id: 'step17_${i}_puzzle',
          slotNumber: 4,
          type: QaidaActivityType.puzzleBuilder,
          prompt: 'বাক্যের টুকরোগুলো জোড়া লাগিয়ে আয়াতটি সম্পূর্ণ করো:',
          puzzlePieces: ['إِيَّاكَ', 'نَعْبُدُ', 'وَإِيَّاكَ', 'نَسْتَعِينُ'],
          explanation: 'মাশাআল্লাহ! আয়াত পাজল সম্পূর্ণ হয়েছে।',
        ),
        // 5. Sing Along Gap
        QaidaActivity(
          id: 'step17_${i}_gap',
          slotNumber: 5,
          type: QaidaActivityType.singAlongGap,
          prompt: 'সুরে সুরে তিলাওয়াত শুনুন এবং শূন্যস্থানে সঠিক শব্দটি বসান:',
          arabicTarget: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ صِرَاطَ الَّذِينَ _____ عَلَيْهِمْ',
          options: ['أَنْعَمْتَ', 'غَيْرِ', 'الْمَغْضُوبِ'],
          correctIndex: 0,
          explanation: 'পবিত্র আয়াত: “صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ”',
        ),
        // 6. Voice Repeat
        QaidaActivity(
          id: 'step17_${i}_voice',
          slotNumber: 6,
          type: QaidaActivityType.voiceRepeat,
          prompt: 'উস্তাদের সাথে পূর্ণাঙ্গ সূরা ইখলাস বিশুদ্ধ তিলাওয়াত করো:',
          arabicTarget: 'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ ۝',
          explanation: 'প্রতিটি হরফের মাখরাজ ও তাজবীদ পূর্ণ করে পাঠ শেষ করো।',
        ),
        // 7. Boss Challenge (Grand Qaida Final Exam)
        QaidaActivity(
          id: 'step17_${i}_boss',
          slotNumber: 7,
          type: QaidaActivityType.bossChallenge,
          prompt: 'নূরানী ক্বায়দা সমাপনী চূড়ান্ত পরীক্ষা! পুরো সূরায় সকল মাখরাজ, গুন্নাহ, মাদ্দ ও ওয়াক্বফ সঠিকভাবে আদায় হয়েছে?',
          arabicTarget: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ ۝',
          options: [
            'আলহামদুলিল্লাহ, পূর্ণাঙ্গ বিশুদ্ধ তিলাওয়াত সম্পন্ন',
            'আবার উস্তাদের সাথে মশক করব',
            'কিছু হরফ পুনরাবৃত্তি করব',
          ],
          correctIndex: 0,
          explanation: 'মুবারকবাদ! আপনি নূরানী ক্বায়দার ১৭টি ধাপ সফলভাবে সম্পন্ন করে পবিত্র কুরআন তিলাওয়াতের যোগ্যতা অর্জন করেছেন!',
        ),
      ];

      lessons.add(
        QaidaLessonInfo(
          id: 'step17_lesson_$i',
          trackId: 'step_17_tilawat',
          lessonNumber: i + 1,
          title: name,
          subtitle: 'উদাহরণ: $ex',
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
      title: 'পূর্ণাঙ্গ তিলাওয়াত',
      titleEn: 'Tilawat',
      arabicTitle: 'التِّلَاوَة',
      description: 'নূরানী ক্বায়দার সকল নিয়ম একীভূত করে ছোট ছোট বাক্য ও সূরা তিলাওয়াত',
      phaseNumber: 6,
      phaseName: 'Phase 6: Reading',
      lessons: lessons,
      gardenPlant: 'Eternal Paradise Garden (জান্নাতের বাগান)',
      colorHex: 0xFF15803D,
      icon: Icons.menu_book_rounded,
    );
  }
}
