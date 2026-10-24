import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// ENUMS
// ---------------------------------------------------------------------------

/// Supported activity types in the 10-step Qaida Activity Engine.
enum QaidaActivityType {
  warmupRecall, // 1. Warm-up / Recall
  recognize, // 2. Recognize (Multiple Choice / MCQ)
  listenAndIdentify, // 3. Listen & Identify
  matchPairs, // 4. Match Pairs (tap-to-match)
  differentiate, // 5. Differentiate (Odd-One-Out / similar items)
  buildArrange, // 6. Build / Arrange (drag tiles into order)
  fillInBlank, // 7. Fill in the Blank (tap-to-select completion)
  sortGroups, // 8. Sort into Groups (categorize into bins)
  memoryMatch, // 9. Memory Match (flip-card pairs)
  readInContext, // 10. Read in Context
  applyRule, // 11. Apply the Rule
  mixedPractice, // 12. Mixed Practice
  lessonCheck, // 13. Lesson Check (end-of-lesson mastery check)
  checkpointExam, // 14. Checkpoint Exam (every 5 lessons)
  trackFinalExam, // 15. Track Final Exam
  voiceRepeat, // 16. Voice Repeat / Echo Mode (self-compare)
  speedReading, // 17. Speed Reading Race
  harakatSlider, // 18. Harakat Slider (بَ → بِ → بُ)
  maddStretch, // 19. Madd Stretch (animated bar)
  shaddahPress, // 20. Shaddah Press (double tap)
  spotTheMistake, // 21. Spot the Mistake
  whichRule, // 22. Which Rule? / Rule Discovery
  ghunnahMeter, // 23. Ghunnah Meter (holding nasal duration)
  bossChallenge, // 24. Boss Challenge / Step Exam
  drawTrace, // 25. Draw & Trace with finger
  oddOneOut, // 26. Odd One Out
  catchLetters, // 27. Catch Falling Letters
  sequenceOrder, // 28. Sequence Order
  puzzleBuilder, // 29. Puzzle Builder / Sentence Puzzle
  singAlongGap, // 30. Sing Along & Fill the Gap
  soundCompare, // 31. A/B Sound Compare
}

/// Difficulty level for an activity.
enum QaidaActivityDifficulty { easy, medium, hard }

/// Teacher review status for content accuracy.
enum ContentReviewStatus {
  pending, // Not yet reviewed
  inReview, // Sent for review
  approved, // Reviewed and approved by a qualified teacher
  needsRevision, // Requires changes
}

/// Mastery state for a skill.
enum SkillMasteryState {
  notStarted,
  inProgress,
  practiceCompleted,
  lessonCheckPassed,
  lessonCompleted,
  masteryDeveloping,
  masteryDemonstrated,
  teacherReviewRequired,
}

// ---------------------------------------------------------------------------
// ACTIVITY SCORING POLICY
// ---------------------------------------------------------------------------

/// Configurable scoring rules for Lesson Checks, Checkpoint Exams, etc.
class ScoringPolicy {
  const ScoringPolicy({
    this.maxScore = 100,
    this.passingThreshold = 80,
    this.xpOnPass = 15,
    this.xpOnComplete = 5,
    this.maxRetries,
    this.allowRetryOnFail = true,
  });

  final int maxScore;
  final int passingThreshold;
  final int xpOnPass;
  final int xpOnComplete;
  final int? maxRetries; // null = unlimited
  final bool allowRetryOnFail;

  static const standard = ScoringPolicy();
  static const checkpoint = ScoringPolicy(
    maxScore: 100,
    passingThreshold: 80,
    xpOnPass: 30,
    xpOnComplete: 10,
  );
  static const trackFinal = ScoringPolicy(
    maxScore: 100,
    passingThreshold: 80,
    xpOnPass: 50,
    xpOnComplete: 20,
    maxRetries: 3,
  );
}

// ---------------------------------------------------------------------------
// ACTIVITY CONTENT ITEMS (for Fill-in-Blank, Sort, Memory Match, etc.)
// ---------------------------------------------------------------------------

/// A single tile used in Build/Arrange, Sort, or Memory Match activities.
class ActivityTile {
  const ActivityTile({
    required this.id,
    String? labelKey,
    String? label,
    this.arabicLabel,
    this.audioAsset,
    this.groupKey, // used in Sort activities
  }) : labelKey = labelKey ?? label ?? id;

  final String id;
  final String labelKey;
  final String? arabicLabel;
  final String? audioAsset;
  final String? groupKey;

  String get label => labelKey;
}

// ---------------------------------------------------------------------------
// QAIDA ACTIVITY
// ---------------------------------------------------------------------------

/// A single interactive practice activity within a Qaida lesson.
/// Every field follows Section 7 of the Master Product Prompt.
class QaidaActivity {
  const QaidaActivity({
    required this.id,
    required this.slotNumber, // 1 to 10
    required this.type,
    String? promptKey,
    String? prompt,
    this.arabicTarget,
    this.arabicSnippet,
    this.audioAsset,
    this.options = const [],
    this.correctIndex = 0,
    this.acceptedAnswers = const [],
    String? explanationKey,
    String? explanation,
    String? feedbackCorrectKey,
    String? feedbackCorrect,
    String? feedbackIncorrectKey,
    String? feedbackIncorrect,
    this.pairs,
    this.tiles = const [],
    this.sortingCategories,
    this.blankSentence,
    this.blankOptions = const [],
    this.blankCorrectIndex = 0,
    this.sequenceItems,
    this.puzzlePieces,
    this.soundOptions,
    String? makhrajInfoKey,
    String? makhrajInfo,
    String? transliterationKey,
    String? transliteration,
    this.skillId,
    this.skillIds = const [],
    this.learningObjectiveIds = const [],
    String? hintKey,
    String? hint,
    this.difficulty = QaidaActivityDifficulty.medium,
    this.visualAssetReference,
    this.rtlRequired = false,
    this.estimatedDurationSeconds = 30,
    this.scoring = ScoringPolicy.standard,
    this.maxRetries,
    this.contentSource,
    this.teacherReviewStatus = ContentReviewStatus.pending,
    this.contentVersion = '1.0',
    String? instructionsBn,
    String? instructionsEn,
  })  : promptKey = promptKey ?? prompt ?? '',
        explanationKey = explanationKey ?? explanation,
        feedbackCorrectKey = feedbackCorrectKey ?? feedbackCorrect,
        feedbackIncorrectKey = feedbackIncorrectKey ?? feedbackIncorrect,
        makhrajInfoKey = makhrajInfoKey ?? makhrajInfo,
        transliterationKey = transliterationKey ?? transliteration,
        hintKey = hintKey ?? hint;

  // Core identity
  final String id;
  final int slotNumber;
  final QaidaActivityType type;

  // Translation keys for instructions and feedback
  final String promptKey;
  String get prompt => promptKey;

  // Arabic content
  final String? arabicTarget;
  final String? arabicSnippet;
  final bool rtlRequired;

  // Media
  final String? audioAsset;
  final String? visualAssetReference;

  // MCQ / Recognition options
  final List<String> options;
  final int correctIndex;
  final List<String> acceptedAnswers;

  // Feedback keys
  final String? explanationKey;
  String? get explanation => explanationKey;

  final String? feedbackCorrectKey;
  String? get feedbackCorrect => feedbackCorrectKey;

  final String? feedbackIncorrectKey;
  String? get feedbackIncorrect => feedbackIncorrectKey;

  // Match Pairs: Map<left, right>
  final Map<String, String>? pairs;

  // Build/Arrange & Sort tiles
  final List<ActivityTile> tiles;

  // Sort into Groups: Map<groupName, [items]>
  final Map<String, List<String>>? sortingCategories;

  // Fill in the Blank
  final String? blankSentence; // sentence with '_' as placeholder
  final List<String> blankOptions;
  final int blankCorrectIndex;

  // Plan Activities: Sequence, Puzzle, Sound Compare
  final List<String>? sequenceItems;
  final List<String>? puzzlePieces;
  final Map<String, String>? soundOptions;

  // Makhraj / Transliteration keys
  final String? makhrajInfoKey;
  String? get makhrajInfo => makhrajInfoKey;

  final String? transliterationKey;
  String? get transliteration => transliterationKey;

  // Skill tracking
  final String? skillId;
  final List<String> skillIds;
  final List<String> learningObjectiveIds;

  // Pedagogy
  final String? hintKey;
  String? get hint => hintKey;
  final QaidaActivityDifficulty difficulty;

  // Timing & Scoring
  final int estimatedDurationSeconds;
  final ScoringPolicy scoring;
  final int? maxRetries;

  // Content provenance
  final String? contentSource;
  final ContentReviewStatus teacherReviewStatus;
  final String contentVersion;

  // ---------------------------------------------------------------------------
  // Computed helpers
  // ---------------------------------------------------------------------------

  String get stepTitleKey => 'qaida.activity_type.${type.name}';
  String get stepTitle => stepTitleKey;

  bool get hasPairs => pairs != null && pairs!.isNotEmpty;
  bool get hasTiles => tiles.isNotEmpty;
  bool get hasSortGroups =>
      sortingCategories != null && sortingCategories!.isNotEmpty;
  bool get hasBlank => blankSentence != null && blankOptions.isNotEmpty;
  bool get hasOptions => options.isNotEmpty;
  bool get hasSequence => sequenceItems != null && sequenceItems!.isNotEmpty;
  bool get hasPuzzle => puzzlePieces != null && puzzlePieces!.isNotEmpty;
  bool get hasSoundOptions => soundOptions != null && soundOptions!.isNotEmpty;
}

// ---------------------------------------------------------------------------
// LESSON INFO
// ---------------------------------------------------------------------------

/// A structured lesson within a Qaida track with exactly 10 mandatory activities.
class QaidaLessonInfo {
  const QaidaLessonInfo({
    required this.id,
    required this.trackId,
    required this.lessonNumber,
    String? titleKey,
    String? title,
    String? subtitleKey,
    String? subtitle,
    required this.arabicDisplay,
    String? descriptionKey,
    String? description,
    this.titleEn,
    String? ruleSummaryKey,
    String? ruleSummary,
    this.audioAsset,
    String? makhrajKey,
    String? makhraj,
    this.prerequisiteSkillIds = const [],
    this.sourceReference,
    this.isCheckpoint = false,
    this.isTrackFinal = false,
    this.isReviewNode = false,
    this.scoringPolicy = ScoringPolicy.standard,
    this.contentReviewStatus = ContentReviewStatus.pending,
    this.ruleLetters = const [],
    this.exampleWords = const [],
    required this.activities,
  })  : titleKey = titleKey ?? title ?? '',
        subtitleKey = subtitleKey ?? subtitle ?? '',
        descriptionKey = descriptionKey ?? description ?? '',
        ruleSummaryKey = ruleSummaryKey ?? ruleSummary,
        makhrajKey = makhrajKey ?? makhraj,
        assert(activities.length >= 7 || isCheckpoint || isTrackFinal || isReviewNode,
            'Standard lessons must have at least 7 activities');

  final String id;
  final String trackId;
  final int lessonNumber;

  // Stable translation keys
  final String titleKey;
  String get title => titleKey;

  final String? titleEn;

  final String subtitleKey;
  String get subtitle => subtitleKey;

  final String arabicDisplay;

  final String descriptionKey;
  String get description => descriptionKey;

  final String? ruleSummaryKey;
  String? get ruleSummary => ruleSummaryKey;

  final String? audioAsset;

  final String? makhrajKey;
  String? get makhraj => makhrajKey;

  final List<String> prerequisiteSkillIds;
  final String? sourceReference;
  final bool isCheckpoint;
  final bool isTrackFinal;
  final bool isReviewNode;
  final ScoringPolicy scoringPolicy;
  final ContentReviewStatus contentReviewStatus;
  final List<String> ruleLetters;
  final List<String> exampleWords;
  final List<QaidaActivity> activities;

  int get mandatoryActivityCount => activities.length;

  /// Skill IDs collected from all activities in this lesson
  Set<String> get allSkillIds {
    final ids = <String>{};
    for (final a in activities) {
      if (a.skillId != null) ids.add(a.skillId!);
      ids.addAll(a.skillIds);
    }
    return ids;
  }
}

// ---------------------------------------------------------------------------
// TRACK INFO
// ---------------------------------------------------------------------------

/// A Track (chapter) in the Qaida curriculum.
class QaidaTrackInfo {
  const QaidaTrackInfo({
    required this.id,
    required this.trackNumber,
    String? titleKey,
    String? title,
    String? subtitleKey,
    String? subtitle,
    required this.arabicTitle,
    String? descriptionKey,
    String? description,
    required this.colorHex,
    required this.icon,
    required this.lessons,
    this.prerequisiteTrackIds = const [],
    this.contentReviewStatus = ContentReviewStatus.pending,
  })  : titleKey = titleKey ?? title ?? '',
        subtitleKey = subtitleKey ?? subtitle ?? '',
        descriptionKey = descriptionKey ?? description ?? '';

  final String id;
  final int trackNumber;

  // Stable translation keys
  final String titleKey;
  String get title => titleKey;

  final String subtitleKey;
  String get subtitle => subtitleKey;

  final String arabicTitle;

  final String descriptionKey;
  String get description => descriptionKey;

  final int colorHex;
  final IconData icon;
  final List<QaidaLessonInfo> lessons;
  final List<String> prerequisiteTrackIds;
  final ContentReviewStatus contentReviewStatus;

  Color get color => Color(colorHex);
  int get totalLessons => lessons.length;
}

// ---------------------------------------------------------------------------
// NURANI QAIDA 17 STEPS
// ---------------------------------------------------------------------------

/// Represents one of the 17 Steps in the Nurani Qaida curriculum.
class NuraniStepInfo {
  const NuraniStepInfo({
    required this.stepNumber,
    required this.id,
    String? titleKey,
    String? title,
    String? titleEn,
    required this.arabicTitle,
    String? descriptionKey,
    String? description,
    required this.phaseNumber,
    String? phaseNameKey,
    String? phaseName,
    required this.lessons,
    String? gardenPlantKey,
    String? gardenPlant,
    required this.colorHex,
    required this.icon,
  })  : titleKey = titleKey ?? title ?? '',
        descriptionKey = descriptionKey ?? description ?? '',
        phaseNameKey = phaseNameKey ?? phaseName ?? '',
        gardenPlantKey = gardenPlantKey ?? gardenPlant ?? '';

  final int stepNumber;
  final String id;

  // Stable translation keys
  final String titleKey;
  String get title => titleKey;
  String get titleEn => titleKey;

  final String arabicTitle;

  final String descriptionKey;
  String get description => descriptionKey;

  final int phaseNumber;

  final String phaseNameKey;
  String get phaseName => phaseNameKey;

  final List<QaidaLessonInfo> lessons;

  final String gardenPlantKey;
  String get gardenPlant => gardenPlantKey;

  final int colorHex;
  final IconData icon;

  Color get color => Color(colorHex);
  int get totalLessons => lessons.length;

  QaidaTrackInfo toTrackInfo() => QaidaTrackInfo(
        id: id,
        trackNumber: stepNumber,
        titleKey: titleKey,
        subtitleKey: descriptionKey,
        arabicTitle: arabicTitle,
        descriptionKey: descriptionKey,
        colorHex: colorHex,
        icon: icon,
        lessons: lessons,
      );
}

// ---------------------------------------------------------------------------
// SKILL PROGRESS RECORD
// ---------------------------------------------------------------------------

/// Tracks per-skill mastery separately from lesson completion.
class SkillProgress {
  SkillProgress({
    required this.skillId,
    this.correctAttempts = 0,
    this.incorrectAttempts = 0,
    this.masteryState = SkillMasteryState.notStarted,
    this.revisionPriority = 0,
    DateTime? lastPracticedAt,
    this.teacherReviewState = ContentReviewStatus.pending,
  }) : lastPracticedAt = lastPracticedAt ?? DateTime.now();

  final String skillId;
  int correctAttempts;
  int incorrectAttempts;
  SkillMasteryState masteryState;
  int revisionPriority; // 0 = low, 1 = medium, 2 = high
  DateTime lastPracticedAt;
  ContentReviewStatus teacherReviewState;

  int get totalAttempts => correctAttempts + incorrectAttempts;

  double get accuracy => correctAttempts + incorrectAttempts == 0
      ? 0.0
      : correctAttempts / (correctAttempts + incorrectAttempts);

  /// Returns true if this skill is due for spaced repetition review.
  bool get isDueForReview {
    final daysSince =
        DateTime.now().difference(lastPracticedAt).inDays;
    if (masteryState == SkillMasteryState.masteryDemonstrated) {
      return daysSince >= 7;
    }
    if (masteryState == SkillMasteryState.lessonCheckPassed) {
      return daysSince >= 3;
    }
    return daysSince >= 1;
  }

  SkillProgress copyWith({
    int? correctAttempts,
    int? incorrectAttempts,
    SkillMasteryState? masteryState,
    int? revisionPriority,
    DateTime? lastPracticedAt,
  }) {
    return SkillProgress(
      skillId: skillId,
      correctAttempts: correctAttempts ?? this.correctAttempts,
      incorrectAttempts: incorrectAttempts ?? this.incorrectAttempts,
      masteryState: masteryState ?? this.masteryState,
      revisionPriority: revisionPriority ?? this.revisionPriority,
      lastPracticedAt: lastPracticedAt ?? this.lastPracticedAt,
      teacherReviewState: teacherReviewState,
    );
  }

  Map<String, dynamic> toJson() => {
        'skillId': skillId,
        'correct': correctAttempts,
        'incorrect': incorrectAttempts,
        'mastery': masteryState.index,
        'priority': revisionPriority,
        'lastPracticed': lastPracticedAt.toIso8601String(),
      };

  factory SkillProgress.fromJson(Map<String, dynamic> json) {
    final idx = json['mastery'] as int? ?? 0;
    return SkillProgress(
      skillId: json['skillId'] as String,
      correctAttempts: json['correct'] as int? ?? 0,
      incorrectAttempts: json['incorrect'] as int? ?? 0,
      masteryState: SkillMasteryState.values[idx.clamp(
          0, SkillMasteryState.values.length - 1)],
      revisionPriority: json['priority'] as int? ?? 0,
      lastPracticedAt: json['lastPracticed'] != null
          ? DateTime.tryParse(json['lastPracticed'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
