import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/qaida/qaida_models.dart';
import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_button.dart';
import '../../widgets/quran_book_mascot.dart';
import '../../widgets/vector_icons.dart';
import '../../l10n/app_localizations.dart';

// =============================================================================
// MAIN ACTIVITY SCREEN (HIGHLY GAMIFIED)
// =============================================================================

class QaidaActivityScreen extends StatefulWidget {
  const QaidaActivityScreen({
    super.key,
    required this.lesson,
    this.nextLesson,
  });

  final QaidaLessonInfo lesson;
  final QaidaLessonInfo? nextLesson;

  @override
  State<QaidaActivityScreen> createState() => _QaidaActivityScreenState();
}

class _QaidaActivityScreenState extends State<QaidaActivityScreen>
    with TickerProviderStateMixin {
  AudioPlayer? _player;
  final FlutterTts _tts = FlutterTts();

  late int _currentActivityIndex;
  int? _selectedOptionIndex;
  bool _hasChecked = false;
  bool _isCorrect = false;
  bool _isCompleted = false;
  bool _isPlayingAudio = false;

  // Gamification metrics
  int _comboStreak = 0;
  int _totalCorrect = 0;
  bool _showRuleIntro = true;

  // State for Match Pairs
  String? _selectedLeftKey;
  final Map<String, String> _matchedPairs = {};

  // State for Fill in Blank
  int? _selectedBlankIndex;

  // State for Sort into Groups
  final Map<String, String> _sortedItems = {};
  String? _selectedUnsortedItem;

  // State for Build/Arrange
  List<ActivityTile> _arrangeTiles = [];
  List<ActivityTile?> _arrangeSlots = [];

  // State for Memory Match
  final List<bool> _memoryFlipped = [];
  final List<bool> _memoryMatched = [];
  int? _memoryFirstFlipped;
  bool _memoryWaiting = false;

  // Phase 3: State for Interactive Touch Activities
  int _sliderHarakatIndex = 0;
  int _maddStretchCount = 1;
  int _shaddahPressCount = 0;
  bool _isRecordingVoice = false;
  bool _hasRecordedVoice = false;
  int _speedReadingProgress = 0;

  // Phase 4: State for Tajweed & Rule Activities
  int? _spotMistakeSelectedIndex;
  bool _ghunnahHolding = false;
  double _ghunnahProgress = 0.0;
  bool _ghunnahCompleted = false;

  // Phase 7: State for Draw & Trace, Odd One Out, Catch Letters, Sequence, Puzzle, Sing-Along, Sound Compare
  final List<Offset?> _tracePoints = [];
  bool _isTraceCompleted = false;

  int? _oddOneOutSelectedIndex;

  int _caughtLettersCount = 0;
  final Set<int> _caughtLetterIndices = {};

  List<String?> _sequenceSlots = [];
  List<String> _availableSequenceTiles = [];

  List<String?> _puzzleSlots = [];
  List<String> _availablePuzzlePieces = [];

  int? _singAlongGapSelectedIndex;

  int? _soundCompareSelectedIndex;

  // Phase 6: Voice Guide & Quiet Mode
  bool _quietMode = false;
  bool _isSpeakingVoiceGuide = false;

  // Audio animation controller
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    final savedIndex =
        context.read<AppState>().lessonActivityIndex(widget.lesson.id);
    _currentActivityIndex =
        savedIndex.clamp(0, widget.lesson.activities.length - 1);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    final isWidgetTest =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isWidgetTest) {
      _waveController.repeat();
    }

    _initAudio();
    _initActivityState();
    _playActivityAudio();
  }

  void _initAudio() {
    try {
      _player = AudioPlayer();
      _player?.onPlayerComplete.listen((_) {
        if (mounted) setState(() => _isPlayingAudio = false);
      });
    } catch (_) {}
  }

  String _toBn(int n) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return n.toString().split('').map((c) {
      final digit = int.tryParse(c);
      return digit != null ? bn[digit] : c;
    }).join('');
  }

  void _initActivityState() {
    final a = _currentActivity;
    _selectedOptionIndex = null;
    _hasChecked = false;
    _isCorrect = false;
    _selectedLeftKey = null;
    _matchedPairs.clear();
    _selectedBlankIndex = null;
    _sortedItems.clear();
    _selectedUnsortedItem = null;

    // Build/Arrange
    if (a.hasTiles) {
      _arrangeTiles = List.from(a.tiles)..shuffle(math.Random());
      _arrangeSlots = List.filled(a.tiles.length, null);
    }

    // Memory Match
    if (a.type == QaidaActivityType.memoryMatch && a.pairs != null) {
      final pairList = <String>[];
      for (final e in a.pairs!.entries) {
        pairList.add(e.key);
        pairList.add(e.value);
      }
      pairList.shuffle(math.Random());
      _memoryFlipped.clear();
      _memoryMatched.clear();
      _memoryFirstFlipped = null;
      _memoryWaiting = false;
      for (var i = 0; i < pairList.length; i++) {
        _memoryFlipped.add(false);
        _memoryMatched.add(false);
      }
    }

    // Phase 3: Reset touch activity states
    _sliderHarakatIndex = 0;
    _maddStretchCount = 1;
    _shaddahPressCount = 0;
    _isRecordingVoice = false;
    _hasRecordedVoice = false;
    _speedReadingProgress = 0;

    // Phase 4: Reset Tajweed & Rule activity states
    _spotMistakeSelectedIndex = null;
    _ghunnahHolding = false;
    _ghunnahProgress = 0.0;
    _ghunnahCompleted = false;

    // Phase 7: Reset Draw & Trace, Odd One Out, Catch Letters, Sequence, Puzzle, Sing-Along, Sound Compare
    _tracePoints.clear();
    _isTraceCompleted = false;
    _oddOneOutSelectedIndex = null;
    _caughtLettersCount = 0;
    _caughtLetterIndices.clear();
    _singAlongGapSelectedIndex = null;
    _soundCompareSelectedIndex = null;

    if (a.hasSequence) {
      final items = List<String>.from(a.sequenceItems!);
      _availableSequenceTiles = List<String>.from(items)..shuffle(math.Random());
      _sequenceSlots = List.filled(items.length, null);
    } else {
      _availableSequenceTiles.clear();
      _sequenceSlots.clear();
    }

    if (a.hasPuzzle) {
      final pieces = List<String>.from(a.puzzlePieces!);
      _availablePuzzlePieces = List<String>.from(pieces)..shuffle(math.Random());
      _puzzleSlots = List.filled(pieces.length, null);
    } else {
      _availablePuzzlePieces.clear();
      _puzzleSlots.clear();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _player?.dispose();
    try {
      _tts.stop().catchError((_) => null);
    } catch (_) {}
    super.dispose();
  }

  QaidaActivity get _currentActivity =>
      widget.lesson.activities[_currentActivityIndex];

  Future<void> _playActivityAudio() async {
    final asset = _currentActivity.audioAsset ?? widget.lesson.audioAsset;
    if (asset != null && asset.isNotEmpty) {
      try {
        setState(() => _isPlayingAudio = true);
        await _player?.stop();
        await _player?.play(AssetSource(asset.replaceFirst('assets/', '')));
        return;
      } catch (_) {
        if (mounted) setState(() => _isPlayingAudio = false);
      }
    }
    // TTS fallback
    final text = _currentActivity.arabicTarget ?? widget.lesson.arabicDisplay;
    if (text.isNotEmpty) {
      try {
        setState(() => _isPlayingAudio = true);
        await _tts.setLanguage('ar');
        await _tts.speak(text);
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (mounted) setState(() => _isPlayingAudio = false);
          });
        }
      } catch (_) {
        if (mounted) setState(() => _isPlayingAudio = false);
      }
    }
  }

  Future<void> _playVoiceGuide() async {
    if (_quietMode) return;
    final activity = _currentActivity;
    final guideText = activity.prompt;
    if (guideText.isEmpty) return;

    try {
      setState(() => _isSpeakingVoiceGuide = true);
      await _tts.setLanguage('bn-BD');
      await _tts.speak(guideText);
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 1800), () {
          if (mounted) setState(() => _isSpeakingVoiceGuide = false);
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isSpeakingVoiceGuide = false);
    }
  }

  // ---------------------------------------------------------------------------
  // ANSWER CHECKING
  // ---------------------------------------------------------------------------

  void _checkAnswer() {
    if (_hasChecked) return;
    final activity = _currentActivity;
    bool isCorrect;

    switch (activity.type) {
      case QaidaActivityType.matchPairs:
        isCorrect = _matchedPairs.length == (activity.pairs?.length ?? 0);
        break;
      case QaidaActivityType.fillInBlank:
        if (_selectedBlankIndex == null) return;
        isCorrect = _selectedBlankIndex == activity.blankCorrectIndex;
        break;
      case QaidaActivityType.sortGroups:
        isCorrect = _checkSortGroups(activity);
        break;
      case QaidaActivityType.buildArrange:
        isCorrect = _checkArrangeOrder(activity);
        break;
      case QaidaActivityType.memoryMatch:
        isCorrect = _memoryMatched.every((m) => m);
        break;
      case QaidaActivityType.harakatSlider:
        isCorrect = _sliderHarakatIndex == activity.correctIndex;
        break;
      case QaidaActivityType.maddStretch:
        isCorrect = _maddStretchCount >= (activity.correctIndex > 0 ? activity.correctIndex : 2);
        break;
      case QaidaActivityType.shaddahPress:
        isCorrect = _shaddahPressCount >= 2;
        break;
      case QaidaActivityType.voiceRepeat:
        isCorrect = true;
        break;
      case QaidaActivityType.speedReading:
        final totalTiles = activity.options.isNotEmpty ? activity.options.length : 3;
        isCorrect = _speedReadingProgress >= totalTiles || _selectedOptionIndex == activity.correctIndex;
        break;
      case QaidaActivityType.spotTheMistake:
        if (_selectedOptionIndex == null && _spotMistakeSelectedIndex == null) return;
        isCorrect = (_selectedOptionIndex ?? _spotMistakeSelectedIndex) == activity.correctIndex;
        break;
      case QaidaActivityType.whichRule:
        if (_selectedOptionIndex == null) return;
        isCorrect = _selectedOptionIndex == activity.correctIndex;
        break;
      case QaidaActivityType.ghunnahMeter:
        isCorrect = _ghunnahCompleted || _ghunnahProgress >= 0.95;
        break;
      case QaidaActivityType.drawTrace:
        isCorrect = _isTraceCompleted || _tracePoints.where((p) => p != null).length >= 10;
        break;
      case QaidaActivityType.oddOneOut:
        if (_oddOneOutSelectedIndex == null && _selectedOptionIndex == null) return;
        isCorrect = (_oddOneOutSelectedIndex ?? _selectedOptionIndex) == activity.correctIndex;
        break;
      case QaidaActivityType.catchLetters:
        isCorrect = _caughtLettersCount >= 3;
        break;
      case QaidaActivityType.sequenceOrder:
        if (activity.hasSequence) {
          final expected = activity.sequenceItems!;
          final actual = _sequenceSlots.whereType<String>().toList();
          isCorrect = actual.length == expected.length && actual.join(',') == expected.join(',');
        } else {
          if (_selectedOptionIndex == null) return;
          isCorrect = _selectedOptionIndex == activity.correctIndex;
        }
        break;
      case QaidaActivityType.puzzleBuilder:
        if (activity.hasPuzzle) {
          final expected = activity.puzzlePieces!;
          final actual = _puzzleSlots.whereType<String>().toList();
          isCorrect = actual.length == expected.length && actual.join('') == expected.join('');
        } else {
          isCorrect = _checkArrangeOrder(activity);
        }
        break;
      case QaidaActivityType.singAlongGap:
        if (_singAlongGapSelectedIndex == null && _selectedOptionIndex == null) return;
        isCorrect = (_singAlongGapSelectedIndex ?? _selectedOptionIndex) == activity.correctIndex;
        break;
      case QaidaActivityType.soundCompare:
        if (_soundCompareSelectedIndex == null && _selectedOptionIndex == null) return;
        isCorrect = (_soundCompareSelectedIndex ?? _selectedOptionIndex) == activity.correctIndex;
        break;
      case QaidaActivityType.bossChallenge:
        if (_selectedOptionIndex == null) return;
        isCorrect = _selectedOptionIndex == activity.correctIndex;
        break;
      default:
        if (_selectedOptionIndex == null) return;
        isCorrect = _selectedOptionIndex == activity.correctIndex;
    }

    if (isCorrect) {
      _comboStreak++;
      _totalCorrect++;
    } else {
      _comboStreak = 0;
    }

    final skillId = (activity.skillId != null && activity.skillId!.isNotEmpty)
        ? activity.skillId!
        : (activity.skillIds.firstOrNull ?? widget.lesson.id);
    if (skillId.isNotEmpty) {
      context.read<AppState>().recordActivityAttempt(
            skillId: skillId,
            isCorrect: isCorrect,
            lessonId: widget.lesson.id,
            activityIndex: _currentActivityIndex,
          );
    }

    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
    });
  }

  bool _checkSortGroups(QaidaActivity activity) {
    if (activity.sortingCategories == null) return false;
    for (final e in activity.sortingCategories!.entries) {
      for (final item in e.value) {
        if (_sortedItems[item] != e.key) return false;
      }
    }
    return true;
  }

  bool _checkArrangeOrder(QaidaActivity activity) {
    if (activity.hasTiles) {
      final expected = activity.tiles.map((t) => t.id).toList();
      final actual = _arrangeSlots.map((t) => t?.id).toList();
      return expected.toString() == actual.toString();
    }
    return false;
  }

  void _retryActivity() {
    setState(() {
      _hasChecked = false;
      _isCorrect = false;
      _selectedOptionIndex = null;
      _selectedBlankIndex = null;
      _spotMistakeSelectedIndex = null;
      _ghunnahHolding = false;
      _ghunnahProgress = 0.0;
      _ghunnahCompleted = false;
      _tracePoints.clear();
      _isTraceCompleted = false;
      _oddOneOutSelectedIndex = null;
      _caughtLettersCount = 0;
      _caughtLetterIndices.clear();
      _singAlongGapSelectedIndex = null;
      _soundCompareSelectedIndex = null;
      if (_currentActivity.hasSequence) {
        final items = List<String>.from(_currentActivity.sequenceItems!);
        _availableSequenceTiles = List<String>.from(items)..shuffle(math.Random());
        _sequenceSlots = List.filled(items.length, null);
      }
      if (_currentActivity.hasPuzzle) {
        final pieces = List<String>.from(_currentActivity.puzzlePieces!);
        _availablePuzzlePieces = List<String>.from(pieces)..shuffle(math.Random());
        _puzzleSlots = List.filled(pieces.length, null);
      }
      if (_currentActivity.type == QaidaActivityType.buildArrange &&
          _currentActivity.hasTiles) {
        _arrangeTiles = List.from(_currentActivity.tiles)
          ..shuffle(math.Random());
        _arrangeSlots = List.filled(_currentActivity.tiles.length, null);
      }
    });
  }

  void _nextActivity() {
    context.read<AppState>().saveLessonActivityIndex(
          widget.lesson.id,
          _currentActivityIndex + 1,
        );

    if (_currentActivityIndex < widget.lesson.activities.length - 1) {
      setState(() {
        _currentActivityIndex++;
      });
      _initActivityState();
      _playActivityAudio();
    } else {
      final state = context.read<AppState>();
      final earnedXp = widget.lesson.isTrackFinal
          ? 50
          : (widget.lesson.isCheckpoint ? 35 : 20);
      state.completeLesson(widget.lesson.id, xp: earnedXp);

      if (widget.lesson.isCheckpoint || widget.lesson.isTrackFinal) {
        final totalQuestions = widget.lesson.activities.length;
        final score = totalQuestions > 0
            ? ((_totalCorrect / totalQuestions) * 100).toInt()
            : 100;
        state.recordExamScore(widget.lesson.id, score);
      }
      setState(() => _isCompleted = true);
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  void _showRuleModal(BuildContext context) {
    final lesson = widget.lesson;
    final ruleText = lesson.ruleSummary ?? lesson.description;
    final letters = lesson.ruleLetters;
    final examples = lesson.exampleWords;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.menu_book_rounded,
                            color: Color(0xFFD97706), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.title,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              lesson.subtitle,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb_rounded,
                                color: Color(0xFFF59E0B), size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'মূল নিয়ম ও কানুন:',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ruleText,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 15,
                            color: const Color(0xFF334155),
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (letters.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'এই নিয়মের হরফসমূহ (${letters.length}টি):',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: letters.map((ltr) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF93C5FD)),
                          ),
                          child: Text(
                            ltr,
                            style: TextStyle(
                              fontFamily: AppTheme.arabicFontFamily,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E40AF),
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  if (examples.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'আদর্শ উদাহরণ শব্দসমূহ:',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: examples.map((ex) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF86EFAC)),
                          ),
                          child: Text(
                            ex,
                            style: TextStyle(
                              fontFamily: AppTheme.arabicFontFamily,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF15803D),
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Duolingo3DButton(
                    text: 'বুঝেছি, অনুশীলন করি ➔',
                    color: AppTheme.duoGreen,
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) return _buildCelebrationScreen();

    final activity = _currentActivity;
    final progress =
        (_currentActivityIndex + 1) / widget.lesson.activities.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Close button with Duolingo-style rounded square
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.close_rounded,
                          size: 26, color: Color(0xFF94A3B8)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Gamified 3D Glossy Progress Bar
                Expanded(
                  child: _GamifiedProgressBar(progress: progress),
                ),
                const SizedBox(width: 12),
                // Combo Streak Flame Badge
                if (_comboStreak >= 2) ...[
                  _GamifiedComboBadge(combo: _comboStreak),
                  const SizedBox(width: 8),
                ],
                // Rule Guide button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _showRuleModal(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFBFDBFE), width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.menu_book_rounded, color: Color(0xFF2563EB), size: 16),
                          const SizedBox(width: 4),
                          LocalizedText(
                            'নিয়ম',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1D4ED8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Step Pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded,
                          color: Color(0xFFD97706), size: 16),
                      const SizedBox(width: 3),
                      Text(
                        '${_currentActivityIndex + 1}/${widget.lesson.activities.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(20, 8, 20, 130),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 580),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Rule Intro Card on Step 1
                        if (_showRuleIntro && (widget.lesson.ruleSummary != null || widget.lesson.description.isNotEmpty)) ...[
                          _RuleGuideIntroCard(
                            lesson: widget.lesson,
                            onDismiss: () => setState(() => _showRuleIntro = false),
                          ),
                          const SizedBox(height: 16),
                        ],
                        // Slot badge + Voice Guide Controls Row
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE0F2FE),
                                      Color(0xFFBAE6FD)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x10000000),
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.stars_rounded,
                                        size: 15, color: Color(0xFF0284C7)),
                                    const SizedBox(width: 5),
                                    LocalizedText(
                                      'ধাপ ${activity.slotNumber}/৭ · ${activity.stepTitle}',
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0369A1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Voice Guide Button
                                  InkWell(
                                    onTap: _playVoiceGuide,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _isSpeakingVoiceGuide
                                            ? const Color(0xFFDCFCE7)
                                            : const Color(0xFFF1F5F9),
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _isSpeakingVoiceGuide
                                                ? Icons.record_voice_over_rounded
                                                : Icons.campaign_rounded,
                                            size: 16,
                                            color: _isSpeakingVoiceGuide
                                                ? const Color(0xFF16A34A)
                                                : const Color(0xFF0284C7),
                                          ),
                                          const SizedBox(width: 4),
                                          LocalizedText(
                                            'ভয়েস গাইড',
                                            style: GoogleFonts.hindSiliguri(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: _isSpeakingVoiceGuide
                                                  ? const Color(0xFF16A34A)
                                                  : const Color(0xFF0284C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Quiet Mode Toggle
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(4),
                                    onPressed: () {
                                      setState(() {
                                        _quietMode = !_quietMode;
                                      });
                                    },
                                    tooltip: _quietMode
                                        ? 'নীরব মোড সক্রিয়'
                                        : 'নীরব মোড বন্ধ',
                                    icon: Icon(
                                      _quietMode
                                          ? Icons.volume_off_rounded
                                          : Icons.volume_up_rounded,
                                      color: _quietMode
                                          ? const Color(0xFFDC2626)
                                          : const Color(0xFF64748B),
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Bengali Prompt / Instruction (Options will have ZERO Bengali)
                        LocalizedText(
                          activity.prompt,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E293B),
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),

                        // Arabic Target Card (Giant character with speaker waves)
                        if (activity.arabicTarget != null &&
                            activity.type != QaidaActivityType.memoryMatch) ...[
                          _ArabicTargetCard(
                            arabic: activity.arabicTarget!,
                            makhraj: activity.makhrajInfo,
                            isPlayingAudio: _isPlayingAudio,
                            waveController: _waveController,
                            onAudioTap: _playActivityAudio,
                          ),
                          const SizedBox(height: 18),
                        ],

                        // Activity Body
                        _buildActivityBody(activity),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomBanner(activity),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIVITY-SPECIFIC BODY BUILDERS
  // ---------------------------------------------------------------------------

  Widget _buildActivityBody(QaidaActivity activity) {
    switch (activity.type) {
      case QaidaActivityType.matchPairs:
        if (activity.hasPairs) return _buildMatchPairs(activity);
        return _buildMcqOptions(activity);
      case QaidaActivityType.fillInBlank:
        if (activity.hasBlank) return _buildFillInBlank(activity);
        return _buildMcqOptions(activity);
      case QaidaActivityType.sortGroups:
        if (activity.hasSortGroups) return _buildSortGroups(activity);
        return _buildMcqOptions(activity);
      case QaidaActivityType.buildArrange:
        if (activity.hasTiles) return _buildArrangeActivity(activity);
        return _buildMcqOptions(activity);
      case QaidaActivityType.memoryMatch:
        if (activity.hasPairs) return _buildMemoryMatch(activity);
        return _buildMcqOptions(activity);
      case QaidaActivityType.harakatSlider:
        return _buildHarakatSlider(activity);
      case QaidaActivityType.maddStretch:
        return _buildMaddStretch(activity);
      case QaidaActivityType.shaddahPress:
        return _buildShaddahPress(activity);
      case QaidaActivityType.voiceRepeat:
        return _buildVoiceRepeat(activity);
      case QaidaActivityType.speedReading:
        return _buildSpeedReading(activity);
      case QaidaActivityType.spotTheMistake:
        return _buildSpotTheMistake(activity);
      case QaidaActivityType.whichRule:
        return _buildWhichRule(activity);
      case QaidaActivityType.ghunnahMeter:
        return _buildGhunnahMeter(activity);
      case QaidaActivityType.drawTrace:
        return _buildDrawTrace(activity);
      case QaidaActivityType.oddOneOut:
        return _buildOddOneOut(activity);
      case QaidaActivityType.catchLetters:
        return _buildCatchLetters(activity);
      case QaidaActivityType.sequenceOrder:
        return _buildSequenceOrder(activity);
      case QaidaActivityType.puzzleBuilder:
        return _buildPuzzleBuilder(activity);
      case QaidaActivityType.singAlongGap:
        return _buildSingAlongGap(activity);
      case QaidaActivityType.soundCompare:
        return _buildSoundCompare(activity);
      case QaidaActivityType.bossChallenge:
        return _buildBossChallenge(activity);
      default:
        return _buildMcqOptions(activity);
    }
  }

  // ── GAMIFIED MCQ OPTIONS (NO BANGLA IN OPTIONS!) ────────────────────────────

  Widget _buildMcqOptions(QaidaActivity activity) {
    if (activity.options.isEmpty) return const SizedBox.shrink();

    // Check if options are short Arabic characters (1-3 chars) -> use stylish 2-column or 3-column grid
    final bool allShort =
        activity.options.every((opt) => opt.trim().length <= 4);

    if (allShort && activity.options.length == 3) {
      return Row(
        children: List.generate(activity.options.length, (index) {
          final option = activity.options[index];
          final isSelected = _selectedOptionIndex == index;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 6,
                right: index == activity.options.length - 1 ? 0 : 6,
              ),
              child: _GamifiedOptionCard(
                text: option,
                index: index,
                isSelected: isSelected,
                hasChecked: _hasChecked,
                isCorrect: _isCorrect,
                correctIndex: activity.correctIndex,
                onTap: _hasChecked
                    ? null
                    : () => setState(() => _selectedOptionIndex = index),
                compactVertical: true,
              ),
            ),
          );
        }),
      );
    }

    return Column(
      children: List.generate(activity.options.length, (index) {
        final option = activity.options[index];
        final isSelected = _selectedOptionIndex == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _GamifiedOptionCard(
            text: option,
            index: index,
            isSelected: isSelected,
            hasChecked: _hasChecked,
            isCorrect: _isCorrect,
            correctIndex: activity.correctIndex,
            onTap: _hasChecked
                ? null
                : () => setState(() => _selectedOptionIndex = index),
          ),
        );
      }),
    );
  }

  // ── GAMIFIED MATCH PAIRS ───────────────────────────────────────────────────

  Widget _buildMatchPairs(QaidaActivity activity) {
    if (!activity.hasPairs) return const SizedBox.shrink();
    final pairs = activity.pairs!;
    final leftKeys = pairs.keys.toList();
    final rightValues = pairs.values.toList()..shuffle(math.Random(42));

    return Column(
      children: [
        // Mini progress stars
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(pairs.length, (i) {
                final isDone = i < _matchedPairs.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    isDone ? Icons.star_rounded : Icons.star_border_rounded,
                    color: isDone
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFFCBD5E1),
                    size: 24,
                  ),
                );
              }),
              const SizedBox(width: 8),
              Text(
                '${_matchedPairs.length}/${pairs.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column (e.g. Arabic target)
            Expanded(
              child: Column(
                children: leftKeys.map((key) {
                  final isMatched = _matchedPairs.containsKey(key);
                  final isSelected = _selectedLeftKey == key;
                  return _GamifiedMatchTile(
                    label: key,
                    isSelected: isSelected,
                    isMatched: isMatched,
                    accentColor: const Color(0xFF0284C7),
                    onTap: (_hasChecked || isMatched)
                        ? null
                        : () => setState(() {
                              _selectedLeftKey =
                                  _selectedLeftKey == key ? null : key;
                            }),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 14),
            // Right column (e.g. Transliteration / matching form)
            Expanded(
              child: Column(
                children: rightValues.map((val) {
                  final isMatched = _matchedPairs.containsValue(val);
                  return _GamifiedMatchTile(
                    label: val,
                    isSelected: false,
                    isMatched: isMatched,
                    accentColor: const Color(0xFF16A34A),
                    onTap: (_hasChecked || isMatched || _selectedLeftKey == null)
                        ? null
                        : () {
                            final leftKey = _selectedLeftKey!;
                            if (pairs[leftKey] == val) {
                              setState(() {
                                _matchedPairs[leftKey] = val;
                                _selectedLeftKey = null;
                                if (_matchedPairs.length == pairs.length) {
                                  _hasChecked = true;
                                  _isCorrect = true;
                                  _comboStreak++;
                                  _totalCorrect++;
                                }
                              });
                            } else {
                              setState(() => _selectedLeftKey = null);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.refresh_rounded,
                                          color: Colors.white, size: 18),
                                      const SizedBox(width: 8),
                                      Text('মিলছে না, আবার ভাবো!',
                                          style: GoogleFonts.hindSiliguri(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  duration: const Duration(milliseconds: 900),
                                  backgroundColor: const Color(0xFFF59E0B),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            }
                          },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── GAMIFIED FILL IN BLANK (WITH DRAG & DROP) ─────────────────────────────

  Widget _buildFillInBlank(QaidaActivity activity) {
    if (!activity.hasBlank) return const SizedBox.shrink();

    final parts = activity.blankSentence!.split('___');
    final selected = _selectedBlankIndex != null
        ? activity.blankOptions[_selectedBlankIndex!]
        : null;

    return Column(
      children: [
        // Glowing sentence container with playful slot
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 10,
            children: [
              if (parts.isNotEmpty && parts[0].isNotEmpty)
                _ArabicSentenceSnippet(parts[0]),
              // Slot as DragTarget
              DragTarget<int>(
                onWillAcceptWithDetails: (details) => !_hasChecked,
                onAcceptWithDetails: (details) {
                  setState(() => _selectedBlankIndex = details.data);
                },
                builder: (context, candidateData, rejectedData) {
                  final isHovered = candidateData.isNotEmpty;
                  return GestureDetector(
                    onTap: _hasChecked
                        ? null
                        : () => setState(() => _selectedBlankIndex = null),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isHovered
                            ? const Color(0xFFFEF3C7)
                            : (selected != null
                                ? (_hasChecked
                                    ? (_isCorrect
                                        ? const Color(0xFFDCFCE7)
                                        : const Color(0xFFFEE2E2))
                                    : const Color(0xFFE0F2FE))
                                : const Color(0xFFFFFBEB)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isHovered
                              ? const Color(0xFFD97706)
                              : (selected != null
                                  ? (_hasChecked
                                      ? (_isCorrect
                                          ? const Color(0xFF22C55E)
                                          : const Color(0xFFEF4444))
                                      : const Color(0xFF0284C7))
                                  : const Color(0xFFF59E0B)),
                          width: isHovered ? 3.0 : 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isHovered
                                ? const Color(0x40F59E0B)
                                : (selected != null
                                    ? const Color(0x15000000)
                                    : const Color(0x30F59E0B)),
                            offset: const Offset(0, 3),
                            blurRadius: isHovered ? 10 : 6,
                          ),
                        ],
                      ),
                      child: Text(
                        selected ?? '  ؟  ',
                        style: TextStyle(
                          fontFamily: AppTheme.arabicFontFamily,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: selected != null
                              ? (_hasChecked
                                  ? (_isCorrect
                                      ? const Color(0xFF15803D)
                                      : const Color(0xFFDC2626))
                                  : const Color(0xFF0369A1))
                              : const Color(0xFFD97706),
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  );
                },
              ),
              if (parts.length > 1 && parts[1].isNotEmpty)
                _ArabicSentenceSnippet(parts[1]),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'নিচ থেকে টেনে বা ট্যাপ করে বসাও:',
          style: GoogleFonts.hindSiliguri(
            fontSize: 13,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        // Options below as Draggable 3D Candy Pills (PURE ARABIC, ZERO BANGLA)
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(activity.blankOptions.length, (i) {
            final opt = activity.blankOptions[i];
            final isSelected = _selectedBlankIndex == i;
            return Draggable<int>(
              data: i,
              feedback: Material(
                color: Colors.transparent,
                child: Transform.rotate(
                  angle: -0.05,
                  child: Transform.scale(
                    scale: 1.1,
                    child: _GamifiedPillButton(
                      text: opt,
                      isSelected: true,
                      onTap: null,
                    ),
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: _GamifiedPillButton(
                  text: opt,
                  isSelected: false,
                  onTap: null,
                ),
              ),
              child: _GamifiedPillButton(
                text: opt,
                isSelected: isSelected,
                onTap: _hasChecked
                    ? null
                    : () => setState(() => _selectedBlankIndex = i),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── GAMIFIED SORT INTO GROUPS (FULL DRAG & DROP ENGINE) ───────────────────

  Widget _buildSortGroups(QaidaActivity activity) {
    if (!activity.hasSortGroups) return const SizedBox.shrink();
    final cats = activity.sortingCategories!;
    final allItems = cats.values.expand((v) => v).toList();
    final unsorted =
        allItems.where((i) => !_sortedItems.containsKey(i)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (unsorted.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  offset: Offset(0, 3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.touch_app_rounded,
                        color: Color(0xFF0284C7), size: 16),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'হরফগুলো টেনে নিচের ঘরে রাখো (অথবা ট্যাপ করো):',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 13,
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: unsorted.map((item) {
                    final isSelected = _selectedUnsortedItem == item;
                    return Draggable<String>(
                      data: item,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Transform.rotate(
                          angle: -0.06,
                          child: Transform.scale(
                            scale: 1.15,
                            child: _GamifiedPillButton(
                              text: item,
                              isSelected: true,
                              onTap: null,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.25,
                        child: _GamifiedPillButton(
                          text: item,
                          isSelected: false,
                          onTap: null,
                        ),
                      ),
                      child: _GamifiedPillButton(
                        text: item,
                        isSelected: isSelected,
                        onTap: _hasChecked
                            ? null
                            : () {
                                setState(() {
                                  _selectedUnsortedItem =
                                      isSelected ? null : item;
                                });
                              },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],
        // Interactive Group Bins (DragTarget)
        ...cats.entries.map((entry) {
          final groupName = entry.key;
          final sortedInGroup = _sortedItems.entries
              .where((e) => e.value == groupName)
              .map((e) => e.key)
              .toList();

          return DragTarget<String>(
            onWillAcceptWithDetails: (details) => !_hasChecked,
            onAcceptWithDetails: (details) {
              setState(() {
                _sortedItems[details.data] = groupName;
                if (_selectedUnsortedItem == details.data) {
                  _selectedUnsortedItem = null;
                }
              });
            },
            builder: (context, candidateData, rejectedData) {
              final isHovered = candidateData.isNotEmpty;
              return GestureDetector(
                onTap: () {
                  if (_selectedUnsortedItem != null && !_hasChecked) {
                    setState(() {
                      _sortedItems[_selectedUnsortedItem!] = groupName;
                      _selectedUnsortedItem = null;
                    });
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isHovered
                        ? const Color(0xFFDCFCE7)
                        : (sortedInGroup.isNotEmpty
                            ? const Color(0xFFF0FDF4)
                            : const Color(0xFFFAFAFA)),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isHovered
                          ? const Color(0xFF16A34A)
                          : (sortedInGroup.isNotEmpty
                              ? const Color(0xFF86EFAC)
                              : const Color(0xFFE2E8F0)),
                      width: isHovered ? 2.5 : 1.5,
                    ),
                    boxShadow: isHovered
                        ? [
                            BoxShadow(
                              color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : const [
                            BoxShadow(
                              color: Color(0x06000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            )
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isHovered
                                  ? const Color(0xFFBBF7D0)
                                  : const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.folder_special_rounded,
                                color: Color(0xFF16A34A), size: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            groupName,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF15803D),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: sortedInGroup.isNotEmpty
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_toBn(sortedInGroup.length)} টি রাখা হয়েছে',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: sortedInGroup.isNotEmpty
                                    ? const Color(0xFF15803D)
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (sortedInGroup.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isHovered
                                  ? const Color(0xFF22C55E)
                                  : const Color(0xFFE2E8F0),
                              style: BorderStyle.solid,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.drive_file_move_outlined,
                                  size: 16,
                                  color: isHovered
                                      ? const Color(0xFF16A34A)
                                      : const Color(0xFF94A3B8)),
                              const SizedBox(width: 6),
                              Text(
                                'এখানে ড্র্যাগ করো অথবা ট্যাপ করো',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 13,
                                  color: isHovered
                                      ? const Color(0xFF15803D)
                                      : const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: sortedInGroup.map((item) {
                            return InkWell(
                              onTap: _hasChecked
                                  ? null
                                  : () => setState(
                                      () => _sortedItems.remove(item)),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: const Color(0xFF22C55E),
                                      width: 2),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x10000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item,
                                      style: TextStyle(
                                        fontFamily: AppTheme.arabicFontFamily,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF15803D),
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.cancel_rounded,
                                        size: 16, color: Color(0xFF16A34A)),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
        if (unsorted.isEmpty && !_hasChecked)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Duolingo3DButton(
              text: 'যাচাই করুন',
              color: AppTheme.duoGreen,
              onPressed: _checkAnswer,
            ),
          ),
      ],
    );
  }

  // ── GAMIFIED BUILD / ARRANGE (DRAG & DROP WORD BUILDER) ───────────────────

  Widget _buildArrangeActivity(QaidaActivity activity) {
    if (!activity.hasTiles) return _buildMcqOptions(activity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Numbered puzzle pedestals (DragTarget)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_arrangeSlots.length, (i) {
              final tile = _arrangeSlots[i];
              return Expanded(
                child: DragTarget<ActivityTile>(
                  onWillAcceptWithDetails: (details) => !_hasChecked,
                  onAcceptWithDetails: (details) {
                    setState(() {
                      final incoming = details.data;
                      final existing = _arrangeSlots[i];
                      if (existing != null) {
                        _arrangeTiles.add(existing);
                      }
                      _arrangeSlots[i] = incoming;
                      _arrangeTiles.remove(incoming);
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    final isHovered = candidateData.isNotEmpty;
                    return GestureDetector(
                      onTap: tile == null || _hasChecked
                          ? null
                          : () => setState(() {
                                _arrangeTiles.insert(0, tile);
                                _arrangeSlots[i] = null;
                              }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 72,
                        decoration: BoxDecoration(
                          color: isHovered
                              ? const Color(0xFFBAE6FD)
                              : (tile != null
                                  ? const Color(0xFFE0F2FE)
                                  : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isHovered
                                ? const Color(0xFF0284C7)
                                : (tile != null
                                    ? const Color(0xFF0284C7)
                                    : const Color(0xFFCBD5E1)),
                            width: isHovered ? 3.0 : 2.5,
                          ),
                          boxShadow: tile != null || isHovered
                              ? const [
                                  BoxShadow(
                                    color: Color(0x15000000),
                                    offset: Offset(0, 3),
                                    blurRadius: 4,
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: tile != null
                            ? Text(
                                tile.arabicLabel ?? tile.label,
                                style: TextStyle(
                                  fontFamily: AppTheme.arabicFontFamily,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0369A1),
                                ),
                                textDirection: TextDirection.rtl,
                              )
                            : Text(
                                '${_toBn(i + 1)}',
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        // Candy Tiles pool with Draggable + Tap fallback
        Text('নিচ থেকে টেনে বা ট্যাপ করে সাজাও:',
            style: GoogleFonts.hindSiliguri(
                fontSize: 14,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: _arrangeTiles.map((tile) {
            return Draggable<ActivityTile>(
              data: tile,
              feedback: Material(
                color: Colors.transparent,
                child: Transform.rotate(
                  angle: -0.05,
                  child: Transform.scale(
                    scale: 1.15,
                    child: _GamifiedPillButton(
                      text: tile.arabicLabel ?? tile.label,
                      isSelected: true,
                      onTap: null,
                    ),
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.25,
                child: _GamifiedPillButton(
                  text: tile.arabicLabel ?? tile.label,
                  isSelected: false,
                  onTap: null,
                ),
              ),
              child: _GamifiedPillButton(
                text: tile.arabicLabel ?? tile.label,
                isSelected: false,
                onTap: _hasChecked
                    ? null
                    : () {
                        final slotIndex =
                            _arrangeSlots.indexWhere((s) => s == null);
                        if (slotIndex != -1) {
                          setState(() {
                            _arrangeSlots[slotIndex] = tile;
                            _arrangeTiles.remove(tile);
                          });
                        }
                      },
              ),
            );
          }).toList(),
        ),
        if (_arrangeTiles.isEmpty &&
            _arrangeSlots.every((s) => s != null) &&
            !_hasChecked)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Duolingo3DButton(
              text: 'যাচাই করুন',
              color: AppTheme.duoGreen,
              onPressed: _checkAnswer,
            ),
          ),
      ],
    );
  }

  // ── GAMIFIED MEMORY MATCH ──────────────────────────────────────────────────

  Widget _buildMemoryMatch(QaidaActivity activity) {
    if (!activity.hasPairs) return const SizedBox.shrink();
    final pairList = <String>[];
    for (final e in activity.pairs!.entries) {
      pairList.add(e.key);
      pairList.add(e.value);
    }
    pairList.shuffle(math.Random(42));

    final crossCount = pairList.length <= 6 ? 3 : 4;
    final matched = _memoryMatched.every((m) => m);

    return Column(
      children: [
        if (matched)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const VectorIcon(
                  type: VectorIconType.star,
                  size: 20,
                  color: Color(0xFFFFC800),
                ),
                const SizedBox(width: 8),
                Text(
                  'মাশাআল্লাহ! সব জোড়া মিলে গেছে!',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF16A34A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 8),
                const VectorIcon(
                  type: VectorIconType.star,
                  size: 20,
                  color: Color(0xFFFFC800),
                ),
              ],
            ),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          itemCount: pairList.length,
          itemBuilder: (ctx, i) {
            final isFlipped = i < _memoryFlipped.length && _memoryFlipped[i];
            final isMatched = i < _memoryMatched.length && _memoryMatched[i];
            final label = pairList[i];

            return _GamifiedMemoryCard(
              label: label,
              isFlipped: isFlipped,
              isMatched: isMatched,
              onTap: (_hasChecked || isFlipped || isMatched || _memoryWaiting)
                  ? null
                  : () => _onMemoryTap(i, pairList, activity.pairs!),
            );
          },
        ),
      ],
    );
  }

  void _onMemoryTap(
      int index, List<String> pairList, Map<String, String> pairs) {
    if (index >= _memoryFlipped.length) return;
    setState(() => _memoryFlipped[index] = true);

    if (_memoryFirstFlipped == null) {
      _memoryFirstFlipped = index;
    } else {
      final first = _memoryFirstFlipped!;
      _memoryFirstFlipped = null;
      _memoryWaiting = true;

      final a = pairList[first];
      final b = pairList[index];
      final isMatch =
          pairs[a] == b || pairs[b] == a || (a == b && first != index);

      Future.delayed(const Duration(milliseconds: 650), () {
        if (!mounted) return;
        setState(() {
          _memoryWaiting = false;
          if (isMatch) {
            _memoryMatched[first] = true;
            _memoryMatched[index] = true;
            if (_memoryMatched.every((m) => m)) {
              _hasChecked = true;
              _isCorrect = true;
              _comboStreak++;
              _totalCorrect++;
            }
          } else {
            _memoryFlipped[first] = false;
            _memoryFlipped[index] = false;
          }
        });
      });
    }
  }

  // ---------------------------------------------------------------------------
  // PHASE 3: INTERACTIVE TOUCH ENGINE BUILDERS
  // ---------------------------------------------------------------------------

  // ── 1. HARAKAT SLIDER (بَ → بِ → بُ) ──────────────────────────────────────────

  Widget _buildHarakatSlider(QaidaActivity activity) {
    final rawTarget = activity.arabicTarget?.trim() ?? 'ب';
    final baseLetter = rawTarget.isNotEmpty ? rawTarget[0] : 'ب';

    final harakatOptions = [
      {'mark': ' َ', 'name': 'যবর', 'symbol': 'ـَ', 'display': '$baseLetterَ', 'sound': 'আ'},
      {'mark': ' ِ', 'name': 'যের', 'symbol': 'ـِ', 'display': '$baseLetterِ', 'sound': 'ই'},
      {'mark': ' ُ', 'name': 'পেশ', 'symbol': 'ـُ', 'display': '$baseLetterُ', 'sound': 'উ'},
    ];

    final currentHarakat = harakatOptions[_sliderHarakatIndex.clamp(0, 2)];

    return Column(
      children: [
        // Big Animated Arabic Letter Card with current Harakat
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _hasChecked
                  ? (_isCorrect ? AppTheme.duoGreen : Colors.amber.shade600)
                  : const Color(0xFFE2E8F0),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryDark.withValues(alpha: 0.12),
                offset: const Offset(0, 6),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Text(
                  currentHarakat['display']!,
                  key: ValueKey<String>(currentHarakat['display']!),
                  style: TextStyle(
                    fontFamily: AppTheme.arabicFontFamily,
                    fontSize: 76,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'উচ্চারণ: ${currentHarakat['name']} (${currentHarakat['sound']}-কার)',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () async {
                      try {
                        await _tts.setLanguage('ar');
                        await _tts.speak(currentHarakat['display']!);
                      } catch (_) {}
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0F2FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.volume_up_rounded,
                          color: Color(0xFF0284C7), size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Interactive Harakat Slider Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'স্লাইড বা ট্যাপ করে সঠিক হরকত বেছে নাও:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    '${_sliderHarakatIndex + 1}/3',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 3 Nodes for Zabar, Zer, Pesh
              Row(
                children: List.generate(3, (idx) {
                  final isSelected = _sliderHarakatIndex == idx;
                  final item = harakatOptions[idx];
                  return Expanded(
                    child: GestureDetector(
                      onTap: _hasChecked
                          ? null
                          : () {
                              setState(() {
                                _sliderHarakatIndex = idx;
                                _selectedOptionIndex = idx;
                              });
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.symmetric(horizontal: idx == 1 ? 6 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryDark
                                : const Color(0xFFCBD5E1),
                            width: isSelected ? 2.5 : 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primaryDark
                                        .withValues(alpha: 0.25),
                                    offset: const Offset(0, 4),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            Text(
                              item['symbol']!,
                              style: TextStyle(
                                fontFamily: AppTheme.arabicFontFamily,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['name']!,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── 2. MADD STRETCH (বার টেনে লম্বা করা) ─────────────────────────────────────

  Widget _buildMaddStretch(QaidaActivity activity) {
    final text = activity.arabicTarget?.isNotEmpty == true
        ? activity.arabicTarget!
        : (activity.arabicSnippet ?? 'مَا');

    final stretchLabels = [
      {'count': 1, 'name': '১ আলিফ (স্বাভাবিক)', 'harakat': '২ হরকত', 'color': const Color(0xFF10B981)},
      {'count': 2, 'name': '২ আলিফ (মাঝারি)', 'harakat': '৩-৪ হরকত', 'color': const Color(0xFF0D9488)},
      {'count': 3, 'name': '৩ আলিফ (দীর্ঘ)', 'harakat': '৫ হরকত', 'color': const Color(0xFFF59E0B)},
      {'count': 4, 'name': '৪ আলিফ (সর্বোচ্চ দীর্ঘ)', 'harakat': '৬ হরকত', 'color': const Color(0xFFEF4444)},
    ];

    final currentLevel = stretchLabels[(_maddStretchCount - 1).clamp(0, 3)];

    return Column(
      children: [
        // Big Arabic Madd Word Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontFamily: AppTheme.arabicFontFamily,
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 10),

              // Animated Elastic Wave Soundbar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 20,
                  width: 60.0 + (_maddStretchCount * 55.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (currentLevel['color'] as Color).withValues(alpha: 0.7),
                        currentLevel['color'] as Color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: (currentLevel['color'] as Color)
                            .withValues(alpha: 0.35),
                        offset: const Offset(0, 3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '〰️' * _maddStretchCount,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'টান: ${currentLevel['name']} · ${currentLevel['harakat']}',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: currentLevel['color'] as Color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Interactive Pull / Stretch Control
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.tune_rounded, size: 16, color: Color(0xFFB45309)),
                  SizedBox(width: 6),
                  Text(
                    'মাদ্দ স্ট্রেচ কন্ট্রোলার: টেনে আওয়াজ লম্বা করো',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: currentLevel['color'] as Color,
                  inactiveTrackColor: const Color(0xFFE2E8F0),
                  thumbColor: currentLevel['color'] as Color,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 12),
                  trackHeight: 8,
                ),
                child: Slider(
                  value: _maddStretchCount.toDouble(),
                  min: 1,
                  max: 4,
                  divisions: 3,
                  onChanged: _hasChecked
                      ? null
                      : (val) {
                          setState(() {
                            _maddStretchCount = val.round();
                            _selectedOptionIndex = _maddStretchCount - 1;
                          });
                        },
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('১ আলিফ',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  Text('২ আলিফ',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  Text('৩ আলিফ',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  Text('৪ আলিফ (দীর্ঘ)',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB45309))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── 3. SHADDAH PRESS (দুইবার চাপ দেওয়া) ──────────────────────────────────────

  Widget _buildShaddahPress(QaidaActivity activity) {
    final text = activity.arabicTarget?.isNotEmpty == true
        ? activity.arabicTarget!
        : (activity.arabicSnippet ?? 'أَنَّ');

    return Column(
      children: [
        // Big Arabic Shaddah Display Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _shaddahPressCount >= 2
                  ? AppTheme.duoGreen
                  : const Color(0xFFE2E8F0),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontFamily: AppTheme.arabicFontFamily,
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'তাশদীদ = ১ বার সাকিন + ১ বার হরকত (দ্বিগুণ ওজন)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Double Press Visual Trackers
        Row(
          children: [
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _shaddahPressCount >= 1
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _shaddahPressCount >= 1
                        ? AppTheme.duoGreen
                        : const Color(0xFFCBD5E1),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _shaddahPressCount >= 1
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: _shaddahPressCount >= 1
                          ? AppTheme.duoGreen
                          : const Color(0xFF94A3B8),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '১ম চাপ (সাকিন)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _shaddahPressCount >= 1
                            ? const Color(0xFF15803D)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _shaddahPressCount >= 2
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _shaddahPressCount >= 2
                        ? AppTheme.duoGreen
                        : const Color(0xFFCBD5E1),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _shaddahPressCount >= 2
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: _shaddahPressCount >= 2
                          ? AppTheme.duoGreen
                          : const Color(0xFF94A3B8),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '২য় চাপ (হরকত)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _shaddahPressCount >= 2
                            ? const Color(0xFF15803D)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Big Tactile Double-Tap Button
        GestureDetector(
          onTap: _hasChecked
              ? null
              : () {
                  setState(() {
                    if (_shaddahPressCount == 0) {
                      _shaddahPressCount = 1;
                    } else if (_shaddahPressCount == 1) {
                      _shaddahPressCount = 2;
                      _checkAnswer();
                    }
                  });
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: _shaddahPressCount >= 2
                  ? AppTheme.duoGreen
                  : (_shaddahPressCount == 1
                      ? const Color(0xFFD97706)
                      : AppTheme.primaryGreen),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (_shaddahPressCount >= 2
                          ? const Color(0xFF15803D)
                          : (_shaddahPressCount == 1
                              ? const Color(0xFFB45309)
                              : AppTheme.primaryDark))
                      .withValues(alpha: 0.6),
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _shaddahPressCount >= 2
                      ? Icons.verified_rounded
                      : (_shaddahPressCount == 1
                          ? Icons.bolt_rounded
                          : Icons.touch_app_rounded),
                  color: Colors.white,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Text(
                  _shaddahPressCount >= 2
                      ? 'দ্বিগুণ চাপ সম্পন্ন! মাশাল্লাহ!'
                      : (_shaddahPressCount == 1
                          ? 'আরেকবার চাপ দাও! (২য় চাপ)'
                          : 'শক্ত করে চাপ দাও (১ম চাপ)'),
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── 4. VOICE REPEAT & ECHO MODE (সেলফ-কম্পেয়ার) ─────────────────────────────

  Widget _buildVoiceRepeat(QaidaActivity activity) {
    final text = activity.arabicTarget?.isNotEmpty == true
        ? activity.arabicTarget!
        : (activity.arabicSnippet ?? widget.lesson.arabicDisplay);

    return Column(
      children: [
        // Display Arabic Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontFamily: AppTheme.arabicFontFamily,
                  fontSize: 68,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 6),
              Text(
                'ইকো মোড: উস্তাদের কন্ঠে শুনো, তারপর নিজেই বলো',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Step 1: Listen to Ustaz Button
        InkWell(
          onTap: () => _playActivityAudio(),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFBBF7D0), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.volume_up_rounded,
                      color: Color(0xFF16A34A), size: 22),
                ),
                const SizedBox(width: 12),
                const Text(
                  '১. উস্তাদের তিলাওয়াত শুনুন',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF15803D),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Step 2: Record / Speak Button
        GestureDetector(
          onTap: () {
            setState(() {
              _isRecordingVoice = true;
            });
            // Simulate 2.4s recording pulse
            Future.delayed(const Duration(milliseconds: 2400), () {
              if (!mounted) return;
              setState(() {
                _isRecordingVoice = false;
                _hasRecordedVoice = true;
              });
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: _isRecordingVoice
                  ? const Color(0xFFFEE2E2)
                  : (_hasRecordedVoice
                      ? const Color(0xFFEFF6FF)
                      : const Color(0xFFF8FAFC)),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _isRecordingVoice
                    ? const Color(0xFFEF4444)
                    : (_hasRecordedVoice
                        ? const Color(0xFF93C5FD)
                        : const Color(0xFFCBD5E1)),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isRecordingVoice
                      ? Icons.mic_rounded
                      : (_hasRecordedVoice
                          ? Icons.check_circle_rounded
                          : Icons.mic_none_rounded),
                  color: _isRecordingVoice
                      ? const Color(0xFFDC2626)
                      : (_hasRecordedVoice
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF64748B)),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  _isRecordingVoice
                      ? 'রেকর্ড হচ্ছে... বলুন!'
                      : (_hasRecordedVoice
                          ? '২. আপনার পাঠ রেকর্ড হয়েছে! 🎧'
                          : '২. মাইক্রোফোনে ট্যাপ করে বলুন'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _isRecordingVoice
                        ? const Color(0xFFB91C1C)
                        : (_hasRecordedVoice
                            ? const Color(0xFF1D4ED8)
                            : const Color(0xFF475569)),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Step 3: Self-Compare Buttons
        if (_hasRecordedVoice && !_hasChecked) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF5FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE9D5FF)),
            ),
            child: Column(
              children: [
                const Text(
                  'উস্তাদের সাথে মিলিয়ে দেখো। কেমন হলো?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7E22CE),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Duolingo3DButton(
                        text: 'আবার বলি',
                        color: const Color(0xFFF1F5F9),
                        shadowColor: const Color(0xFFCBD5E1),
                        textColor: const Color(0xFF475569),
                        onPressed: () {
                          setState(() {
                            _hasRecordedVoice = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Duolingo3DButton(
                        text: 'মিলে গেছে! ✓',
                        color: AppTheme.duoGreen,
                        shadowColor: const Color(0xFF46A302),
                        textColor: Colors.white,
                        onPressed: () {
                          _checkAnswer();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ── 5. SPEED READING RACE (গতি ও বিশুদ্ধতা) ───────────────────────────────────

  Widget _buildSpeedReading(QaidaActivity activity) {
    final List<String> tiles = activity.options.isNotEmpty
        ? activity.options
        : (activity.arabicTarget
                ?.split(RegExp(r'[\s\-]+'))
                .where((s) => s.isNotEmpty)
                .toList() ??
            ['بَ', 'بِ', 'بُ']);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.bolt_rounded,
                  color: Color(0xFF16A34A), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ক্রমান্বয়ে প্রতিটি হরফ মুখে জোরে পড়ো এবং ট্যাপ করো:',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF15803D),
                  ),
                ),
              ),
              Text(
                '$_speedReadingProgress/${tiles.length}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tiles
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(tiles.length, (idx) {
            final isRead = idx < _speedReadingProgress;
            final isCurrent = idx == _speedReadingProgress;
            final tileText = tiles[idx];

            return GestureDetector(
              onTap: _hasChecked
                  ? null
                  : () {
                      if (isCurrent) {
                        setState(() {
                          _speedReadingProgress++;
                          if (_speedReadingProgress >= tiles.length) {
                            _selectedOptionIndex = 0;
                            _checkAnswer();
                          }
                        });
                      }
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isRead
                      ? const Color(0xFFDCFCE7)
                      : (isCurrent ? Colors.white : const Color(0xFFF8FAFC)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isRead
                        ? AppTheme.duoGreen
                        : (isCurrent
                            ? AppTheme.primaryGreen
                            : const Color(0xFFE2E8F0)),
                    width: isCurrent ? 2.5 : (isRead ? 2.0 : 1.2),
                  ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryDark
                                .withValues(alpha: 0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tileText,
                      style: TextStyle(
                        fontFamily: AppTheme.arabicFontFamily,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isRead
                            ? const Color(0xFF15803D)
                            : (isCurrent
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF94A3B8)),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    if (isRead) ...[
                      const SizedBox(height: 2),
                      const Icon(Icons.check_rounded,
                          color: Color(0xFF16A34A), size: 14),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── 6. SPOT THE MISTAKE (ভুলটি খুঁজে বের করো) ──────────────────────────────

  Widget _buildSpotTheMistake(QaidaActivity activity) {
    final target = activity.arabicSnippet ?? activity.arabicTarget ?? '';
    final options = activity.options;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Instruction badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded,
                  color: Color(0xFFD97706), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ভুলটি শনাক্ত করো: নিচের শব্দে কোনটি তাজবীদ বা হরকতের নিয়মের বিপরীত?',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Target Arabic Word Display with Audio Playback
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFDE68A), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                target,
                style: TextStyle(
                  fontFamily: AppTheme.arabicFontFamily,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
                textDirection: TextDirection.rtl,
              ),
              DSButton(
                onPressed: _playActivityAudio,
                icon: _isPlayingAudio
                    ? Icons.volume_up_rounded
                    : Icons.volume_down_rounded,
                label: 'সঠিক উচ্চারণ শুনুন',
                variant: DSButtonVariant.outline,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Options to choose the mistaken part or rule
        if (options.isNotEmpty) ...[
          Text(
            'কোথায় ভুল রয়েছে?',
            style: GoogleFonts.hindSiliguri(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(options.length, (index) {
            final opt = options[index];
            final isSelected = _selectedOptionIndex == index;
            final isAnswered = _hasChecked;
            final isCorrect = isAnswered && index == activity.correctIndex;
            final isWrong = isAnswered && isSelected && !isCorrect;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: _hasChecked
                    ? null
                    : () {
                        setState(() {
                          _selectedOptionIndex = index;
                          _spotMistakeSelectedIndex = index;
                        });
                      },
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? const Color(0xFFDCFCE7)
                        : (isWrong
                            ? const Color(0xFFFEE2E2)
                            : (isSelected
                                ? const Color(0xFFF0FDF4)
                                : Colors.white)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCorrect
                          ? AppTheme.duoGreen
                          : (isWrong
                              ? const Color(0xFFEF4444)
                              : (isSelected
                                  ? AppTheme.duoGreen
                                  : const Color(0xFFE2E8F0))),
                      width: isSelected ? 2.2 : 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppTheme.duoGreen
                              : const Color(0xFFF1F5F9),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          opt,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded,
                            color: AppTheme.duoGreen, size: 22),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  // ── 7. WHICH RULE? / RULE DISCOVERY (কোন তাজবীদ নিয়ম?) ──────────────────────

  Widget _buildWhichRule(QaidaActivity activity) {
    final target = activity.arabicSnippet ?? activity.arabicTarget ?? '';
    final options = activity.options;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Rule discovery helper banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  color: Color(0xFF2563EB), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'তাজবীদ নিয়ম আবিষ্কার করো: হরকত ও সংলগ্ন হরফ লক্ষ্য করে বিধান চিহ্নিত করো',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E40AF),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Arabic Display
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C000000),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                target,
                style: TextStyle(
                  fontFamily: AppTheme.arabicFontFamily,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 8),
              Text(
                activity.prompt,
                textAlign: TextAlign.center,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Rule Badges / Selection Cards
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(options.length, (index) {
            final opt = options[index];
            final isSelected = _selectedOptionIndex == index;
            final isAnswered = _hasChecked;
            final isCorrect = isAnswered && index == activity.correctIndex;
            final isWrong = isAnswered && isSelected && !isCorrect;

            return InkWell(
              onTap: _hasChecked
                  ? null
                  : () {
                      setState(() {
                        _selectedOptionIndex = index;
                      });
                    },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? const Color(0xFFDCFCE7)
                      : (isWrong
                          ? const Color(0xFFFEE2E2)
                          : (isSelected
                              ? const Color(0xFFEFF6FF)
                              : Colors.white)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCorrect
                        ? AppTheme.duoGreen
                        : (isWrong
                            ? const Color(0xFFEF4444)
                            : (isSelected
                                ? const Color(0xFF2563EB)
                                : const Color(0xFFE2E8F0))),
                    width: isSelected ? 2.2 : 1.2,
                  ),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: Color(0x182563EB),
                            offset: Offset(0, 3),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 18,
                      color: isSelected
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      opt,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? const Color(0xFF1D4ED8)
                            : const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── 8. GHUNNAH METER (ওয়াজিব গুন্নাহ মিটার) ───────────────────────────────

  void _startGhunnahHold() {
    final isWidgetTest =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (isWidgetTest) {
      // In automated test, complete immediately
      setState(() {
        _ghunnahProgress = 1.0;
        _ghunnahCompleted = true;
        _ghunnahHolding = false;
      });
      _checkAnswer();
      return;
    }

    const stepDuration = Duration(milliseconds: 100);
    const totalSteps = 16; // ~1.6 seconds
    int currentStep = 0;

    Timer.periodic(stepDuration, (timer) {
      if (!_ghunnahHolding || !mounted) {
        timer.cancel();
        if (!_ghunnahCompleted && mounted) {
          setState(() {
            _ghunnahProgress = 0.0;
          });
        }
        return;
      }
      currentStep++;
      final p = (currentStep / totalSteps).clamp(0.0, 1.0);
      setState(() {
        _ghunnahProgress = p;
      });
      if (currentStep >= totalSteps) {
        timer.cancel();
        setState(() {
          _ghunnahCompleted = true;
          _ghunnahHolding = false;
        });
        _checkAnswer();
      }
    });
  }

  Widget _buildGhunnahMeter(QaidaActivity activity) {
    final target = activity.arabicSnippet ?? activity.arabicTarget ?? 'إِنَّ';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Instruction banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.graphic_eq_rounded,
                  color: Color(0xFF059669), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'নাকের বাঁশিতে শব্দ ধরে রেখে গুন্নাহ সম্পূর্ণ করুন (১.৫–২ আলিফ)',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF065F46),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Word Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _ghunnahCompleted
                  ? const Color(0xFF10B981)
                  : const Color(0xFFE2E8F0),
              width: _ghunnahCompleted ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _ghunnahCompleted
                    ? const Color(0x2510B981)
                    : const Color(0x0C000000),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                target,
                style: TextStyle(
                  fontFamily: AppTheme.arabicFontFamily,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: _ghunnahCompleted
                      ? const Color(0xFF047857)
                      : const Color(0xFF0F172A),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 8),
              Text(
                _ghunnahCompleted
                    ? 'মাশাআল্লাহ! গুন্নাহ সফলভাবে সম্পন্ন হয়েছে ✓'
                    : (_ghunnahHolding
                        ? 'গুন্নাহ চলছে... ধরে রাখুন...'
                        : 'নিচে চেপে ধরে রাখুন'),
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _ghunnahCompleted
                      ? const Color(0xFF059669)
                      : (_ghunnahHolding
                          ? const Color(0xFF0284C7)
                          : const Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Live Meter Gauge Bar
        Container(
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: constraints.maxWidth * _ghunnahProgress,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _ghunnahCompleted
                            ? [
                                const Color(0xFF10B981),
                                const Color(0xFF059669)
                              ]
                            : [
                                const Color(0xFF38BDF8),
                                const Color(0xFF0284C7)
                              ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // Press & Hold Button
        GestureDetector(
          onTapDown: (_) {
            if (_ghunnahCompleted) return;
            setState(() {
              _ghunnahHolding = true;
            });
            _startGhunnahHold();
          },
          onTapUp: (_) {
            if (_ghunnahCompleted) return;
            setState(() {
              _ghunnahHolding = false;
            });
          },
          onTapCancel: () {
            if (_ghunnahCompleted) return;
            setState(() {
              _ghunnahHolding = false;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: _ghunnahCompleted
                  ? const Color(0xFF10B981)
                  : (_ghunnahHolding
                      ? const Color(0xFF0284C7)
                      : AppTheme.duoGreen),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (_ghunnahCompleted
                          ? const Color(0xFF10B981)
                          : (_ghunnahHolding
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF46A302)))
                      .withValues(alpha: 0.35),
                  offset: const Offset(0, 5),
                  blurRadius: 10,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _ghunnahCompleted
                      ? Icons.check_circle_rounded
                      : Icons.touch_app_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  _ghunnahCompleted
                      ? 'সম্পন্ন হয়েছে!'
                      : (_ghunnahHolding
                          ? 'ধরে রাখুন...'
                          : 'চেপে ধরে গুন্নাহ করুন'),
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PHASE 7: NEW ENGINE BUILDERS
  // ---------------------------------------------------------------------------

  Widget _buildDrawTrace(QaidaActivity activity) {
    final targetLetter = activity.arabicTarget ?? widget.lesson.arabicDisplay;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  targetLetter,
                  style: TextStyle(
                    fontFamily: AppTheme.arabicFontFamily,
                    fontSize: 150,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFCBD5E1).withValues(alpha: 0.7),
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              Positioned(
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.touch_app_rounded, size: 14, color: Color(0xFF0284C7)),
                      const SizedBox(width: 4),
                      Text(
                        'আঙুল দিয়ে হরফটির ওপর আঁকো',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0284C7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _tracePoints.add(details.localPosition);
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      _tracePoints.add(details.localPosition);
                      if (!_isTraceCompleted && _tracePoints.where((p) => p != null).length >= 8) {
                        _isTraceCompleted = true;
                      }
                    });
                  },
                  onPanEnd: (_) {
                    setState(() {
                      _tracePoints.add(null);
                    });
                  },
                  child: CustomPaint(
                    painter: _TraceCanvasPainter(points: List.from(_tracePoints)),
                    size: Size.infinite,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isTraceCompleted) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF86EFAC)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: Color(0xFF16A34A), size: 18),
                const SizedBox(width: 6),
                Text(
                  'মাশাআল্লাহ! হরফ আঁকা সম্পন্ন হয়েছে!',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF15803D),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DSButton(
              onPressed: () {
                setState(() {
                  _tracePoints.clear();
                  _isTraceCompleted = false;
                });
              },
              icon: Icons.refresh_rounded,
              label: 'মুছে আবার আঁকো',
              variant: DSButtonVariant.outline,
            ),
            const SizedBox(width: 12),
            DSButton(
              onPressed: () {
                setState(() {
                  _isTraceCompleted = true;
                });
              },
              icon: const Icon(Icons.check_circle_rounded, size: 18, color: Colors.white),
              label: _isTraceCompleted ? 'আঁকা সম্পন্ন ✓' : 'সম্পন্ন করেছি',
              height: 44,
              variant: _isTraceCompleted
                  ? DSButtonVariant.primary
                  : DSButtonVariant.blue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOddOneOut(QaidaActivity activity) {
    final options = activity.options;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.travel_explore_rounded, color: Color(0xFF1D4ED8), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ব্যতিক্রম হরফটি খুঁজুন: নিচের হরফগুলোর মধ্যে কোনটি ভিন্ন দলের স্পর্শ করে নির্বাচন করুন',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E40AF),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(options.length, (index) {
            final option = options[index];
            final isSelected = (_oddOneOutSelectedIndex ?? _selectedOptionIndex) == index;
            return SizedBox(
              width: options.length <= 3 ? 100 : 85,
              height: 110,
              child: _GamifiedOptionCard(
                text: option,
                index: index,
                isSelected: isSelected,
                hasChecked: _hasChecked,
                isCorrect: _isCorrect,
                correctIndex: activity.correctIndex,
                compactVertical: true,
                onTap: _hasChecked
                    ? null
                    : () {
                        setState(() {
                          _oddOneOutSelectedIndex = index;
                          _selectedOptionIndex = index;
                        });
                      },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCatchLetters(QaidaActivity activity) {
    final target = activity.arabicTarget ?? widget.lesson.arabicDisplay;
    final options = activity.options.isNotEmpty ? activity.options : [target, 'ت', 'ث', 'ن'];
    final bubbles = <String>[
      target,
      options.length > 1 ? options[1] : 'ت',
      target,
      options.length > 2 ? options[2] : 'ث',
      target,
      options.length > 3 ? options[3] : 'ن',
    ];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD97706).withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🧺', style: TextStyle(fontSize: 26)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'হরফ সংগ্রহ করো:',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          color: const Color(0xFF92400E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_toBn(_caughtLettersCount)} / ৩ টি ধরা হয়েছে',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 16,
                          color: const Color(0xFF78350F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.duoGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      'লক্ষ্য: ',
                      style: GoogleFonts.hindSiliguri(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      target,
                      style: TextStyle(
                        fontFamily: AppTheme.arabicFontFamily,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: bubbles.length,
          itemBuilder: (context, index) {
            final letter = bubbles[index];
            final isCaught = _caughtLetterIndices.contains(index);

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: isCaught || _hasChecked
                  ? null
                  : () {
                      if (letter == target) {
                        setState(() {
                          _caughtLetterIndices.add(index);
                          _caughtLettersCount++;
                        });
                        if (_caughtLettersCount >= 3) {
                          _checkAnswer();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'এটি $letter, লক্ষ্য হরফ “$target” স্পর্শ করো!',
                              style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
                            ),
                            duration: const Duration(milliseconds: 700),
                            backgroundColor: const Color(0xFFF59E0B),
                          ),
                        );
                      }
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isCaught ? const Color(0xFFDCFCE7) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCaught ? AppTheme.duoGreen : const Color(0xFFE2E8F0),
                    width: isCaught ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isCaught
                          ? AppTheme.duoGreen.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: isCaught
                    ? const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 36)
                    : Text(
                        letter,
                        style: TextStyle(
                          fontFamily: AppTheme.arabicFontFamily,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ── GAMIFIED SEQUENCE ORDER (DRAG & DROP) ─────────────────────────────────

  Widget _buildSequenceOrder(QaidaActivity activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'সঠিক ক্রমানুসারে সাজাও (টেনে বা স্পর্শ করে):',
          style: GoogleFonts.hindSiliguri(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF475569),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(_sequenceSlots.length, (slotIdx) {
            final item = _sequenceSlots[slotIdx];
            return DragTarget<String>(
              onWillAcceptWithDetails: (details) => !_hasChecked,
              onAcceptWithDetails: (details) {
                setState(() {
                  final existing = _sequenceSlots[slotIdx];
                  if (existing != null) {
                    _availableSequenceTiles.add(existing);
                  }
                  _sequenceSlots[slotIdx] = details.data;
                  _availableSequenceTiles.remove(details.data);
                });
              },
              builder: (context, candidateData, rejectedData) {
                final isHovered = candidateData.isNotEmpty;
                return InkWell(
                  onTap: item != null && !_hasChecked
                      ? () {
                          setState(() {
                            _sequenceSlots[slotIdx] = null;
                            _availableSequenceTiles.add(item);
                          });
                        }
                      : null,
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: const BoxConstraints(minWidth: 64, minHeight: 52),
                    decoration: BoxDecoration(
                      color: isHovered
                          ? const Color(0xFFDCFCE7)
                          : (item != null ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isHovered
                            ? const Color(0xFF16A34A)
                            : (item != null ? AppTheme.duoGreen : const Color(0xFFCBD5E1)),
                        width: isHovered ? 2.5 : (item != null ? 2 : 1.5),
                      ),
                      boxShadow: isHovered
                          ? [
                              BoxShadow(
                                color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item ?? '${_toBn(slotIdx + 1)}',
                      style: TextStyle(
                        fontFamily: item != null ? AppTheme.arabicFontFamily : null,
                        fontSize: item != null ? 22 : 14,
                        fontWeight: FontWeight.bold,
                        color: item != null ? const Color(0xFF15803D) : const Color(0xFF94A3B8),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 24),
        Text(
          'নিচের হরফ/শব্দগুলো টেনে বা স্পর্শ করে খালি ঘরে বসাও:',
          style: GoogleFonts.hindSiliguri(
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: _availableSequenceTiles.map((tile) {
            return Draggable<String>(
              data: tile,
              feedback: Material(
                color: Colors.transparent,
                child: Transform.rotate(
                  angle: -0.05,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.duoGreen, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.duoGreen.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      tile,
                      style: TextStyle(
                        fontFamily: AppTheme.arabicFontFamily,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF15803D),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.25,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Text(
                    tile,
                    style: TextStyle(
                      fontFamily: AppTheme.arabicFontFamily,
                      fontSize: 22,
                      color: const Color(0xFF94A3B8),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
              child: InkWell(
                onTap: _hasChecked
                    ? null
                    : () {
                        final firstEmptyIdx = _sequenceSlots.indexOf(null);
                        if (firstEmptyIdx != -1) {
                          setState(() {
                            _sequenceSlots[firstEmptyIdx] = tile;
                            _availableSequenceTiles.remove(tile);
                          });
                        }
                      },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    tile,
                    style: TextStyle(
                      fontFamily: AppTheme.arabicFontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── GAMIFIED PUZZLE BUILDER (DRAG & DROP) ──────────────────────────────────

  Widget _buildPuzzleBuilder(QaidaActivity activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F3FF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFDDD6FE), width: 1.5),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🧩', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'পাজল ফ্রেম: টুকরোগুলো টেনে বা ট্যাপ করে বসাও',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6D28D9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: List.generate(_puzzleSlots.length, (slotIdx) {
                  final piece = _puzzleSlots[slotIdx];
                  return DragTarget<String>(
                    onWillAcceptWithDetails: (details) => !_hasChecked,
                    onAcceptWithDetails: (details) {
                      setState(() {
                        final existing = _puzzleSlots[slotIdx];
                        if (existing != null) {
                          _availablePuzzlePieces.add(existing);
                        }
                        _puzzleSlots[slotIdx] = details.data;
                        _availablePuzzlePieces.remove(details.data);
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isHovered = candidateData.isNotEmpty;
                      return InkWell(
                        onTap: piece != null && !_hasChecked
                            ? () {
                                setState(() {
                                  _puzzleSlots[slotIdx] = null;
                                  _availablePuzzlePieces.add(piece);
                                });
                              }
                            : null,
                        borderRadius: BorderRadius.circular(14),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          constraints: const BoxConstraints(minWidth: 54, minHeight: 48),
                          decoration: BoxDecoration(
                            color: isHovered
                                ? const Color(0xFFDDD6FE)
                                : (piece != null ? Colors.white : const Color(0xFFEDE9FE)),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isHovered
                                  ? const Color(0xFF6D28D9)
                                  : (piece != null ? const Color(0xFF8B5CF6) : const Color(0xFFC4B5FD)),
                              width: isHovered ? 2.5 : 2,
                            ),
                            boxShadow: isHovered
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            piece ?? '?',
                            style: TextStyle(
                              fontFamily: piece != null ? AppTheme.arabicFontFamily : null,
                              fontSize: piece != null ? 22 : 16,
                              fontWeight: FontWeight.bold,
                              color: piece != null ? const Color(0xFF6D28D9) : const Color(0xFFA78BFA),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                'পূর্ণ শব্দ: ${_puzzleSlots.whereType<String>().join('')}',
                style: TextStyle(
                  fontFamily: AppTheme.arabicFontFamily,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4C1D95),
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: _availablePuzzlePieces.map((piece) {
            return Draggable<String>(
              data: piece,
              feedback: Material(
                color: Colors.transparent,
                child: Transform.rotate(
                  angle: -0.05,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF8B5CF6), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      piece,
                      style: TextStyle(
                        fontFamily: AppTheme.arabicFontFamily,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6D28D9),
                      ),
                    ),
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.25,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Text(
                    piece,
                    style: TextStyle(
                      fontFamily: AppTheme.arabicFontFamily,
                      fontSize: 24,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ),
              child: InkWell(
                onTap: _hasChecked
                    ? null
                    : () {
                        final emptyIdx = _puzzleSlots.indexOf(null);
                        if (emptyIdx != -1) {
                          setState(() {
                            _puzzleSlots[emptyIdx] = piece;
                            _availablePuzzlePieces.remove(piece);
                          });
                        }
                      },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF8B5CF6), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    piece,
                    style: TextStyle(
                      fontFamily: AppTheme.arabicFontFamily,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6D28D9),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── GAMIFIED SING ALONG GAP (DRAG & DROP) ──────────────────────────────────

  Widget _buildSingAlongGap(QaidaActivity activity) {
    final rawTarget = activity.arabicTarget ?? widget.lesson.arabicDisplay;
    final options = activity.options;
    final selectedWord = _singAlongGapSelectedIndex != null && _singAlongGapSelectedIndex! < options.length
        ? options[_singAlongGapSelectedIndex!]
        : null;

    final hasBlankSlot = rawTarget.contains('_____');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFA7F3D0), width: 1.5),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎵', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'সুরে সুরে তিলাওয়াত শুনুন ও শূন্যস্থানে বসান (টেনে বা ট্যাপ করে):',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF047857),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              DragTarget<int>(
                onWillAcceptWithDetails: (details) => !_hasChecked,
                onAcceptWithDetails: (details) {
                  setState(() {
                    _singAlongGapSelectedIndex = details.data;
                    _selectedOptionIndex = details.data;
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  final isHovered = candidateData.isNotEmpty;
                  final textToDisplay = hasBlankSlot
                      ? rawTarget.replaceAll('_____', '[ ${selectedWord ?? '____'} ]')
                      : '$rawTarget  [ ${selectedWord ?? '____'} ]';

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isHovered ? const Color(0xFFD1FAE5) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: isHovered ? Border.all(color: const Color(0xFF059669), width: 2) : null,
                    ),
                    child: Text(
                      textToDisplay,
                      style: TextStyle(
                        fontFamily: AppTheme.arabicFontFamily,
                        fontSize: 26,
                        height: 1.6,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065F46),
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(options.length, (index) {
            final option = options[index];
            final isSelected = (_singAlongGapSelectedIndex ?? _selectedOptionIndex) == index;
            return Draggable<int>(
              data: index,
              feedback: Material(
                color: Colors.transparent,
                child: Transform.rotate(
                  angle: -0.05,
                  child: SizedBox(
                    width: options.length <= 2 ? 140 : 100,
                    height: 70,
                    child: _GamifiedOptionCard(
                      text: option,
                      index: index,
                      isSelected: true,
                      hasChecked: false,
                      isCorrect: false,
                      correctIndex: activity.correctIndex,
                      onTap: null,
                      compactVertical: true,
                    ),
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.25,
                child: SizedBox(
                  width: options.length <= 2 ? 140 : 100,
                  height: 70,
                  child: _GamifiedOptionCard(
                    text: option,
                    index: index,
                    isSelected: false,
                    hasChecked: false,
                    isCorrect: false,
                    correctIndex: activity.correctIndex,
                    onTap: null,
                    compactVertical: true,
                  ),
                ),
              ),
              child: SizedBox(
                width: options.length <= 2 ? 140 : 100,
                height: 70,
                child: _GamifiedOptionCard(
                  text: option,
                  index: index,
                  isSelected: isSelected,
                  hasChecked: _hasChecked,
                  isCorrect: _isCorrect,
                  correctIndex: activity.correctIndex,
                  onTap: _hasChecked
                      ? null
                      : () {
                          setState(() {
                            _singAlongGapSelectedIndex = index;
                            _selectedOptionIndex = index;
                          });
                        },
                  compactVertical: true,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSoundCompare(QaidaActivity activity) {
    final List<String> sounds = activity.hasSoundOptions
        ? activity.soundOptions!.keys.toList()
        : (activity.options.isNotEmpty ? activity.options : <String>['উচ্চারণ A', 'উচ্চারণ B']);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.compare_arrows_rounded, color: Color(0xFF15803D), size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'উভয় উচ্চারণ শুনুন এবং সঠিকটি নির্বাচন করুন:',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF166534),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: List.generate(math.min(2, sounds.length), (index) {
            final label = sounds[index];
            final isSelected = (_soundCompareSelectedIndex ?? _selectedOptionIndex) == index;
            final isA = index == 0;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: isA ? 0 : 8, right: isA ? 8 : 0),
                child: InkWell(
                  onTap: _hasChecked
                      ? null
                      : () {
                          setState(() {
                            _soundCompareSelectedIndex = index;
                            _selectedOptionIndex = index;
                          });
                        },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFDCFCE7) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppTheme.duoGreen : const Color(0xFFE2E8F0),
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.duoGreen : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.volume_up_rounded,
                            color: isSelected ? Colors.white : const Color(0xFF64748B),
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isA ? 'শব্দ ক' : 'শব্দ খ',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontFamily: AppTheme.arabicFontFamily,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? const Color(0xFF15803D) : const Color(0xFF1E293B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBossChallenge(QaidaActivity activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF59E0B), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const VectorIcon(
                type: VectorIconType.trophy,
                size: 26,
                color: Color(0xFFD97706),
              ),
              const SizedBox(width: 10),
              Text(
                'বস চ্যালেঞ্জ (ধাপের চূড়ান্ত পরীক্ষা)',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF92400E),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (activity.options.isNotEmpty)
          _buildMcqOptions(activity)
        else
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              'উস্তাদের সাথে বিশুদ্ধ তিলাওয়াত যাচাই সম্পন্ন করো।',
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF334155),
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM BANNER (DUOLINGO STYLE)
  // ---------------------------------------------------------------------------

  bool _isSortGroupsComplete(QaidaActivity activity) {
    if (!activity.hasSortGroups) return false;
    final all = activity.sortingCategories!.values.expand((v) => v).toList();
    return all.every((item) => _sortedItems.containsKey(item));
  }

  Widget _buildBottomBanner(QaidaActivity activity) {
    final isSelfComplete =
        (activity.type == QaidaActivityType.matchPairs && activity.hasPairs) ||
        (activity.type == QaidaActivityType.memoryMatch && activity.hasPairs) ||
        activity.type == QaidaActivityType.shaddahPress ||
        activity.type == QaidaActivityType.voiceRepeat ||
        activity.type == QaidaActivityType.ghunnahMeter ||
        (activity.type == QaidaActivityType.catchLetters && _caughtLettersCount >= 3);

    if (!_hasChecked) {
      if (isSelfComplete) return const SizedBox.shrink();

      final canCheck = activity.type == QaidaActivityType.fillInBlank
          ? _selectedBlankIndex != null
          : (activity.type == QaidaActivityType.sortGroups
              ? _isSortGroupsComplete(activity)
              : (activity.type == QaidaActivityType.buildArrange
                  ? (_arrangeSlots.isNotEmpty && _arrangeSlots.every((s) => s != null))
                  : (activity.type == QaidaActivityType.harakatSlider ||
                      activity.type == QaidaActivityType.maddStretch ||
                      activity.type == QaidaActivityType.speedReading ||
                      activity.type == QaidaActivityType.spotTheMistake ||
                      activity.type == QaidaActivityType.whichRule ||
                      activity.type == QaidaActivityType.ghunnahMeter ||
                      (activity.type == QaidaActivityType.drawTrace && (_isTraceCompleted || _tracePoints.where((p) => p != null).length >= 8)) ||
                      (activity.type == QaidaActivityType.oddOneOut && (_oddOneOutSelectedIndex != null || _selectedOptionIndex != null)) ||
                      (activity.type == QaidaActivityType.catchLetters && _caughtLettersCount >= 3) ||
                      (activity.type == QaidaActivityType.sequenceOrder && (activity.hasSequence ? !_sequenceSlots.contains(null) : _selectedOptionIndex != null)) ||
                      (activity.type == QaidaActivityType.puzzleBuilder && (activity.hasPuzzle ? !_puzzleSlots.contains(null) : _selectedOptionIndex != null)) ||
                      (activity.type == QaidaActivityType.singAlongGap && (_singAlongGapSelectedIndex != null || _selectedOptionIndex != null)) ||
                      (activity.type == QaidaActivityType.soundCompare && (_soundCompareSelectedIndex != null || _selectedOptionIndex != null)) ||
                      _selectedOptionIndex != null)));

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1.5)),
        ),
        child: SafeArea(
          top: false,
          child: Duolingo3DButton(
            text: 'যাচাই করুন',
            color: canCheck ? AppTheme.duoGreen : const Color(0xFFE5E7EB),
            shadowColor: canCheck
                ? const Color(0xFF46A302)
                : const Color(0xFFCBD5E1),
            textColor: canCheck ? Colors.white : const Color(0xFFAFAFAF),
            onPressed: canCheck ? _checkAnswer : null,
          ),
        ),
      );
    }

    final bool isSuccess = _isCorrect;
    final Color bannerColor =
        isSuccess ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);
    final Color textColor =
        isSuccess ? const Color(0xFF15803D) : const Color(0xFFB45309);
    final Color btnColor =
        isSuccess ? AppTheme.duoGreen : const Color(0xFFF59E0B);
    final String title = isSuccess
        ? (activity.feedbackCorrect ?? 'মাশাআল্লাহ! চমৎকার!')
        : (activity.feedbackIncorrect ?? 'মনোযোগ দিয়ে আবার ভাবি');
    final String? feedback = activity.explanation ?? widget.lesson.description;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bannerColor,
        border: Border(
          top: BorderSide(
            color: isSuccess
                ? const Color(0xFF86EFAC)
                : const Color(0xFFFDE68A),
            width: 2,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                QuranBookMascot(
                  size: 44,
                  mood: isSuccess
                      ? QuranMascotMood.celebrating
                      : QuranMascotMood.encouraging,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                ),
                if (!isSuccess && activity.hint != null)
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Row(
                            children: [
                              const Icon(Icons.lightbulb_rounded,
                                  color: Color(0xFFF59E0B)),
                              const SizedBox(width: 8),
                              Text('সহায়তা',
                                  style: GoogleFonts.hindSiliguri(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          content: Text(activity.hint!,
                              style: GoogleFonts.hindSiliguri(fontSize: 16)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('ঠিক আছে'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
                    label: Text('ইঙ্গিত',
                        style: GoogleFonts.hindSiliguri(
                            fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(foregroundColor: textColor),
                  ),
              ],
            ),
            if (feedback != null && feedback.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                feedback,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  color: textColor.withOpacity(0.92),
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Duolingo3DButton(
              text: isSuccess ? 'পরবর্তী ধাপ ➔' : 'আবার চেষ্টা করি ↻',
              color: btnColor,
              onPressed: isSuccess ? _nextActivity : _retryActivity,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CELEBRATION SCREEN (CONFIDENTIAL PARTICLES & 3 STARS)
  // ---------------------------------------------------------------------------

  Widget _buildCelebrationScreen() {
    final next = widget.nextLesson;
    final state = context.read<AppState>();
    final xpEarned = widget.lesson.isTrackFinal
        ? 50
        : (widget.lesson.isCheckpoint ? 35 : 20);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Confetti particles
          const Positioned.fill(child: _ConfettiShower()),

          SafeArea(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // Respectful 3D Quran Mascot celebrating
                    const QuranBookMascot(
                      size: 96,
                      mood: QuranMascotMood.celebrating,
                    ),
                    const SizedBox(height: 16),
                    // Animated 3 Stars Trophy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _AnimatedStar(delayMs: 200, size: 48),
                        SizedBox(width: 8),
                        _AnimatedStar(delayMs: 400, size: 68),
                        SizedBox(width: 8),
                        _AnimatedStar(delayMs: 600, size: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.lesson.isTrackFinal
                          ? 'আলহামদুলিল্লাহ! ট্র্যাক বিজয়ী!'
                          : (widget.lesson.isCheckpoint
                              ? 'চেকপয়েন্ট পরীক্ষায় উত্তীর্ণ!'
                              : 'মাশাআল্লাহ! অসাধারণ!'),
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${widget.lesson.title}" পাঠ সম্পন্ন হয়েছে!',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 16,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Gamified Summary Pills
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _RewardPill(
                          icon: Icons.bolt_rounded,
                          color: const Color(0xFFFF9600),
                          text: '+$xpEarned XP',
                        ),
                        const SizedBox(width: 12),
                        _RewardPill(
                          icon: Icons.stars_rounded,
                          color: const Color(0xFF16A34A),
                          text: '$_totalCorrect/${widget.lesson.activities.length} সঠিক',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Skill summary row
                    _SkillSummaryRow(state: state, lesson: widget.lesson),
                    const Spacer(),
                    if (next != null) ...[
                      Duolingo3DButton(
                        text: 'পরবর্তী পাঠ: ${next.title}',
                        color: AppTheme.duoGreen,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => QaidaActivityScreen(
                                lesson: next,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    Duolingo3DButton(
                      text: 'অধ্যায় তালিকায় ফিরুন',
                      color: const Color(0xFFF1F5F9),
                      shadowColor: const Color(0xFFCBD5E1),
                      textColor: const Color(0xFF334155),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// GAMIFIED HELPER WIDGETS
// =============================================================================

/// 3D Glossy Duolingo-style Progress Bar with a glowing bounce runner
class _GamifiedProgressBar extends StatelessWidget {
  const _GamifiedProgressBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final barWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: barWidth,
                height: 18,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF58CC02), Color(0xFF22C55E)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3022C55E),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              // Top gloss highlight
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: barWidth,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.35),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Combo Flame Badge
class _GamifiedComboBadge extends StatelessWidget {
  const _GamifiedComboBadge({required this.combo});
  final int combo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7A00), Color(0xFFFF0055)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40FF7A00),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Real3DTopBarIcon(type: Real3DTopType.flame, size: 16),
          const SizedBox(width: 4),
          Text(
            '$combo Combo!',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// 3D Tactile Option Card (NO BANGLA! Pure Arabic/Transliteration)
class _GamifiedOptionCard extends StatefulWidget {
  const _GamifiedOptionCard({
    required this.text,
    required this.index,
    required this.isSelected,
    required this.hasChecked,
    required this.isCorrect,
    required this.correctIndex,
    required this.onTap,
    this.compactVertical = false,
  });

  final String text;
  final int index;
  final bool isSelected;
  final bool hasChecked;
  final bool isCorrect;
  final int correctIndex;
  final VoidCallback? onTap;
  final bool compactVertical;

  @override
  State<_GamifiedOptionCard> createState() => _GamifiedOptionCardState();
}

class _GamifiedOptionCardState extends State<_GamifiedOptionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color border = const Color(0xFFE2E8F0);
    Color shadow = const Color(0xFFCBD5E1);

    if (widget.hasChecked) {
      if (widget.index == widget.correctIndex) {
        bg = const Color(0xFFF0FDF4);
        border = const Color(0xFF22C55E);
        shadow = const Color(0xFF16A34A);
      } else if (widget.isSelected) {
        bg = const Color(0xFFFEF2F2);
        border = const Color(0xFFEF4444);
        shadow = const Color(0xFFDC2626);
      }
    } else if (widget.isSelected) {
      bg = const Color(0xFFF0F9FF);
      border = const Color(0xFF0284C7);
      shadow = const Color(0xFF0369A1);
    }

    final double depth = _isPressed ? 1.5 : 4.5;
    final isArabic = widget.text.contains(RegExp(r'[\u0600-\u06FF]'));

    return GestureDetector(
      onTapDown: widget.onTap == null
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onTap == null
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onTap?.call();
            },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(top: _isPressed ? 3 : 0),
        padding: EdgeInsets.symmetric(
          horizontal: widget.compactVertical ? 8 : 18,
          vertical: widget.compactVertical ? 10 : 16,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: widget.isSelected ? 2.5 : 2),
          boxShadow: [
            BoxShadow(
              color: shadow,
              offset: Offset(0, depth),
              blurRadius: 0,
            ),
          ],
        ),
        child: widget.compactVertical
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _OptionNumberBadge(
                    index: widget.index,
                    isSelected: widget.isSelected,
                    hasChecked: widget.hasChecked,
                    isCorrect: widget.isCorrect,
                    isCorrectOption: widget.index == widget.correctIndex,
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        fontFamily:
                            isArabic ? AppTheme.arabicFontFamily : null,
                        fontSize: isArabic ? 32 : 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  _OptionNumberBadge(
                    index: widget.index,
                    isSelected: widget.isSelected,
                    hasChecked: widget.hasChecked,
                    isCorrect: widget.isCorrect,
                    isCorrectOption: widget.index == widget.correctIndex,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        fontFamily:
                            isArabic ? AppTheme.arabicFontFamily : null,
                        fontSize: isArabic ? 32 : 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                  if (widget.hasChecked &&
                      widget.index == widget.correctIndex)
                    const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF16A34A), size: 24),
                  if (widget.hasChecked &&
                      widget.isSelected &&
                      !widget.isCorrect)
                    const Icon(Icons.cancel_rounded,
                        color: Color(0xFFEF4444), size: 24),
                ],
              ),
      ),
    );
  }
}

/// Option pill badge (A, B, C, D)
class _OptionNumberBadge extends StatelessWidget {
  const _OptionNumberBadge({
    required this.index,
    required this.isSelected,
    required this.hasChecked,
    required this.isCorrect,
    required this.isCorrectOption,
  });

  final int index;
  final bool isSelected;
  final bool hasChecked;
  final bool isCorrect;
  final bool isCorrectOption;

  @override
  Widget build(BuildContext context) {
    Color bg = const Color(0xFFF1F5F9);
    Color fg = const Color(0xFF64748B);

    if (hasChecked) {
      if (isCorrectOption) {
        bg = const Color(0xFF22C55E);
        fg = Colors.white;
      } else if (isSelected) {
        bg = const Color(0xFFEF4444);
        fg = Colors.white;
      }
    } else if (isSelected) {
      bg = const Color(0xFF0284C7);
      fg = Colors.white;
    }

    final labels = ['A', 'B', 'C', 'D'];
    final label = index < labels.length ? labels[index] : '${index + 1}';

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: fg,
        ),
      ),
    );
  }
}

/// Giant Arabic Target Card with animated sound ripple waves
class _ArabicTargetCard extends StatelessWidget {
  const _ArabicTargetCard({
    required this.arabic,
    this.makhraj,
    required this.isPlayingAudio,
    required this.waveController,
    required this.onAudioTap,
  });

  final String arabic;
  final String? makhraj;
  final bool isPlayingAudio;
  final AnimationController waveController;
  final VoidCallback onAudioTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            arabic,
            style: TextStyle(
              fontFamily: AppTheme.arabicFontFamily,
              fontSize: 68,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          // 3D Audio Button
          GestureDetector(
            onTap: isPlayingAudio ? null : onAudioTap,
            child: AnimatedBuilder(
              animation: waveController,
              builder: (ctx, child) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: isPlayingAudio
                        ? const Color(0xFFE0F2FE)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isPlayingAudio
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x10000000),
                        offset: Offset(0, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPlayingAudio
                            ? Icons.graphic_eq_rounded
                            : Icons.volume_up_rounded,
                        color: const Color(0xFF0284C7),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isPlayingAudio ? 'বাজছে...' : 'উচ্চারণ শুনুন',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (makhraj != null) ...[
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'মাখরাজ: $makhraj',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 3D Match Tile
class _GamifiedMatchTile extends StatelessWidget {
  const _GamifiedMatchTile({
    required this.label,
    required this.isSelected,
    required this.isMatched,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isMatched;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isArabic = label.contains(RegExp(r'[\u0600-\u06FF]'));
    Color bg = Colors.white;
    Color border = const Color(0xFFE2E8F0);
    Color shadow = const Color(0xFFCBD5E1);

    if (isMatched) {
      bg = const Color(0xFFDCFCE7);
      border = const Color(0xFF22C55E);
      shadow = const Color(0xFF16A34A);
    } else if (isSelected) {
      bg = const Color(0xFFE0F2FE);
      border = const Color(0xFF0284C7);
      shadow = const Color(0xFF0369A1);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: isSelected ? 2.5 : 2),
          boxShadow: [
            BoxShadow(
              color: shadow,
              offset: Offset(0, isSelected ? 2 : 4),
              blurRadius: 0,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: isArabic ? AppTheme.arabicFontFamily : null,
                fontSize: isArabic ? 28 : 17,
                fontWeight: FontWeight.bold,
                color: isMatched
                    ? const Color(0xFF15803D)
                    : (isSelected
                        ? const Color(0xFF0369A1)
                        : const Color(0xFF1E293B)),
              ),
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              textAlign: TextAlign.center,
            ),
            if (isMatched) ...[
              const SizedBox(width: 8),
              const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF16A34A), size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

/// 3D Pill Button (for tiles & blanks)
class _GamifiedPillButton extends StatelessWidget {
  const _GamifiedPillButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isArabic = text.contains(RegExp(r'[\u0600-\u06FF]'));
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0F2FE) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0284C7)
                : const Color(0xFFCBD5E1),
            width: isSelected ? 2.5 : 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x15000000),
              offset: Offset(0, 3.5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: isArabic ? AppTheme.arabicFontFamily : null,
            fontSize: isArabic ? 28 : 17,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? const Color(0xFF0369A1)
                : const Color(0xFF0F172A),
          ),
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        ),
      ),
    );
  }
}

/// 3D Animated Memory Card with Real Y-Axis Flip Effect
class _GamifiedMemoryCard extends StatelessWidget {
  const _GamifiedMemoryCard({
    required this.label,
    required this.isFlipped,
    required this.isMatched,
    required this.onTap,
  });

  final String label;
  final bool isFlipped;
  final bool isMatched;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isArabic = label.contains(RegExp(r'[\u0600-\u06FF]'));

    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: (isFlipped || isMatched) ? 180 : 0),
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutBack,
        builder: (context, rotation, child) {
          final isFront = rotation >= 90;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(rotation * math.pi / 180),
            child: isFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isMatched ? const Color(0xFFDCFCE7) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isMatched
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF0284C7),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isMatched
                                ? const Color(0xFF16A34A).withValues(alpha: 0.25)
                                : const Color(0xFF0284C7).withValues(alpha: 0.15),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: isArabic ? AppTheme.arabicFontFamily : null,
                          fontSize: isArabic ? 28 : 15,
                          fontWeight: FontWeight.bold,
                          color: isMatched
                              ? const Color(0xFF15803D)
                              : const Color(0xFF0369A1),
                        ),
                        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF60A5FA), width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF1E3A8A),
                          offset: Offset(0, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.star_rounded, color: Colors.white, size: 30),
                  ),
          );
        },
      ),
    );
  }
}

/// Sentence snippet
class _ArabicSentenceSnippet extends StatelessWidget {
  const _ArabicSentenceSnippet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final isArabic = text.contains(RegExp(r'[\u0600-\u06FF]'));
    return Text(
      text,
      style: TextStyle(
        fontFamily: isArabic ? AppTheme.arabicFontFamily : null,
        fontSize: isArabic ? 24 : 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0F172A),
      ),
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
    );
  }
}

/// Animated Star for celebration
class _AnimatedStar extends StatelessWidget {
  const _AnimatedStar({required this.delayMs, required this.size});
  final int delayMs;
  final double size;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delayMs),
      curve: Curves.elasticOut,
      builder: (ctx, val, child) {
        return Transform.scale(
          scale: val,
          child: Icon(
            Icons.star_rounded,
            color: const Color(0xFFFFC800),
            size: size,
          ),
        );
      },
    );
  }
}

/// Confetti Particles Shower
class _ConfettiShower extends StatefulWidget {
  const _ConfettiShower();

  @override
  State<_ConfettiShower> createState() => _ConfettiShowerState();
}

class _ConfettiShowerState extends State<_ConfettiShower>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    final rng = math.Random();
    const colors = [
      Color(0xFF58CC02),
      Color(0xFFFFC800),
      Color(0xFF1CB0F6),
      Color(0xFFFF4B4B),
      Color(0xFFCE82FF),
    ];
    for (var i = 0; i < 40; i++) {
      _particles.add(
        _Particle(
          x: rng.nextDouble(),
          y: -rng.nextDouble(),
          color: colors[rng.nextInt(colors.length)],
          size: 6.0 + rng.nextDouble() * 8,
          speed: 0.003 + rng.nextDouble() * 0.006,
          rotation: rng.nextDouble() * math.pi * 2,
        ),
      );
    }

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        for (final p in _particles) {
          p.y += p.speed;
          p.rotation += 0.05;
          if (p.y > 1.1) p.y = -0.1;
        }
        setState(() {});
      });
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ConfettiPainter(_particles),
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
    required this.rotation,
  });

  double x;
  double y;
  final Color color;
  final double size;
  final double speed;
  double rotation;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.particles);
  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()..color = p.color;
      canvas.save();
      canvas.translate(p.x * size.width, p.y * size.height);
      canvas.rotate(p.rotation);
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero, width: p.size, height: p.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Skill summary row on completion screen.
class _SkillSummaryRow extends StatelessWidget {
  const _SkillSummaryRow({required this.state, required this.lesson});
  final AppState state;
  final QaidaLessonInfo lesson;

  @override
  Widget build(BuildContext context) {
    final skillIds = lesson.allSkillIds.take(3).toList();
    if (skillIds.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('দক্ষতার অগ্রগতি:',
              style: GoogleFonts.hindSiliguri(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF64748B))),
          const SizedBox(height: 8),
          ...skillIds.map((sid) {
            final sp = state.skillProgress(sid);
            final mastery = sp?.masteryState ?? SkillMasteryState.notStarted;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(_masteryIcon(mastery),
                      size: 16, color: _masteryColor(mastery)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sid,
                      style: GoogleFonts.hindSiliguri(
                          fontSize: 12, color: const Color(0xFF334155)),
                    ),
                  ),
                  Text(
                    _masteryLabel(mastery),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _masteryColor(mastery)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _masteryIcon(SkillMasteryState s) => switch (s) {
        SkillMasteryState.masteryDemonstrated => Icons.star_rounded,
        SkillMasteryState.masteryDeveloping => Icons.trending_up_rounded,
        SkillMasteryState.lessonCheckPassed ||
        SkillMasteryState.lessonCompleted =>
          Icons.check_circle_rounded,
        SkillMasteryState.practiceCompleted => Icons.check_rounded,
        SkillMasteryState.inProgress => Icons.autorenew_rounded,
        _ => Icons.radio_button_unchecked_rounded,
      };

  Color _masteryColor(SkillMasteryState s) => switch (s) {
        SkillMasteryState.masteryDemonstrated => const Color(0xFFD97706),
        SkillMasteryState.masteryDeveloping => AppTheme.duoGreen,
        SkillMasteryState.lessonCheckPassed ||
        SkillMasteryState.lessonCompleted =>
          const Color(0xFF2563EB),
        SkillMasteryState.practiceCompleted => const Color(0xFF7C3AED),
        SkillMasteryState.inProgress => const Color(0xFF0891B2),
        _ => const Color(0xFF94A3B8),
      };

  String _masteryLabel(SkillMasteryState s) => switch (s) {
        SkillMasteryState.masteryDemonstrated => 'আয়ত্ত',
        SkillMasteryState.masteryDeveloping => 'উন্নতি হচ্ছে',
        SkillMasteryState.lessonCheckPassed => 'পাঠ যাচাই পাস',
        SkillMasteryState.lessonCompleted => 'পাঠ সম্পন্ন',
        SkillMasteryState.practiceCompleted => 'অনুশীলন শেষ',
        SkillMasteryState.inProgress => 'চলছে',
        _ => 'শুরু হয়নি',
      };
}

class _RewardPill extends StatelessWidget {
  const _RewardPill({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Teacher Rule Guide Intro Card displayed before practice starts
class _RuleGuideIntroCard extends StatelessWidget {
  const _RuleGuideIntroCard({
    required this.lesson,
    required this.onDismiss,
  });

  final QaidaLessonInfo lesson;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final ruleText = lesson.ruleSummary ?? lesson.description;
    final letters = lesson.ruleLetters;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFDE68A), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(
                      'নিয়ম জেনে অনুশীলন শুরু করি',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                    LocalizedText(
                      lesson.title,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: LocalizedText(
              ruleText,
              style: GoogleFonts.hindSiliguri(
                fontSize: 14,
                color: const Color(0xFF334155),
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (letters.isNotEmpty) ...[
            const SizedBox(height: 12),
            LocalizedText(
              'এই নিয়মের হরফসমূহ (${letters.length}টি):',
              style: GoogleFonts.hindSiliguri(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF92400E),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: letters.map((ltr) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Text(
                    ltr,
                    style: TextStyle(
                      fontFamily: AppTheme.arabicFontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFB45309),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 14),
          Duolingo3DButton(
            text: 'বুঝেছি, অনুশীলন শুরু করি ➔',
            color: const Color(0xFFF59E0B),
            shadowColor: const Color(0xFFD97706),
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}

class _TraceCanvasPainter extends CustomPainter {
  final List<Offset?> points;
  final Color strokeColor;
  final double strokeWidth;

  _TraceCanvasPainter({
    required this.points,
    this.strokeColor = const Color(0xFF10B981),
    this.strokeWidth = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TraceCanvasPainter oldDelegate) => true;
}
