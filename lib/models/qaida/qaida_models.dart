import 'package:flutter/material.dart';

/// Supported activity types in the Qaida Activity Engine.
enum QaidaActivityType {
  letterIntro,
  identifyLetter,
  listenAndIdentify,
  shapeMatching,
  oddOneOut,
  matchPairs,
  fillInBlank,
  buildWord,
  sortGroups,
  ruleInContext,
  readWordByWord,
  lessonCheck,
}

/// A single interactive activity within a Qaida lesson.
class QaidaActivity {
  const QaidaActivity({
    required this.id,
    required this.type,
    required this.prompt,
    this.arabicTarget,
    this.arabicSnippet,
    this.audioAsset,
    this.options = const [],
    this.correctIndex = 0,
    this.explanation,
    this.pairs,
    this.sortingCategories,
    this.makhrajInfo,
    this.transliteration,
  });

  final String id;
  final QaidaActivityType type;
  final String prompt;
  final String? arabicTarget;
  final String? arabicSnippet;
  final String? audioAsset;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
  final Map<String, String>? pairs;
  final Map<String, List<String>>? sortingCategories;
  final String? makhrajInfo;
  final String? transliteration;
}

/// A structured lesson within a Qaida track.
class QaidaLessonInfo {
  const QaidaLessonInfo({
    required this.id,
    required this.trackId,
    required this.lessonNumber,
    required this.title,
    required this.subtitle,
    required this.arabicDisplay,
    required this.description,
    this.ruleSummary,
    this.audioAsset,
    this.makhraj,
    required this.activities,
  });

  final String id;
  final String trackId;
  final int lessonNumber;
  final String title;
  final String subtitle;
  final String arabicDisplay;
  final String description;
  final String? ruleSummary;
  final String? audioAsset;
  final String? makhraj;
  final List<QaidaActivity> activities;
}

/// A Track (or chapter) in the Qaida curriculum.
class QaidaTrackInfo {
  const QaidaTrackInfo({
    required this.id,
    required this.trackNumber,
    required this.title,
    required this.subtitle,
    required this.arabicTitle,
    required this.description,
    required this.colorHex,
    required this.icon,
    required this.lessons,
  });

  final String id;
  final int trackNumber;
  final String title;
  final String subtitle;
  final String arabicTitle;
  final String description;
  final int colorHex;
  final IconData icon;
  final List<QaidaLessonInfo> lessons;

  Color get color => Color(colorHex);
  int get totalLessons => lessons.length;
}
