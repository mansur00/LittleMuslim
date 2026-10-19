import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/nurani_qaida_data.dart';
import '../../models/qaida/qaida_models.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_button.dart';
import '../../widgets/quran_book_mascot.dart';
import 'qaida_revision_screen.dart';

/// The 3 Tiers of the Nurani Qaida Examination System.
enum QaidaExamTier {
  stepBoss, // End of Step Exam (Boss Challenge) - unlocks next step
  weekly, // Weekly Exam (every 7 sessions) - current + ~20% spaced review
  monthly, // Monthly Exam (every 30 sessions) - comprehensive review + weak letters
}

/// A single standardized question inside an exam.
class QaidaExamQuestion {
  const QaidaExamQuestion({
    required this.id,
    required this.prompt,
    required this.arabicDisplay,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.topicName,
    this.audioAsset,
  });

  final String id;
  final String prompt;
  final String arabicDisplay;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String? topicName;
  final String? audioAsset;
}

class QaidaExamScreen extends StatefulWidget {
  const QaidaExamScreen({
    super.key,
    required this.tier,
    this.step,
    this.weekNumber = 1,
    this.monthNumber = 1,
    this.isRetake = false,
  });

  final QaidaExamTier tier;
  final NuraniStepInfo? step;
  final int weekNumber;
  final int monthNumber;
  final bool isRetake;

  @override
  State<QaidaExamScreen> createState() => _QaidaExamScreenState();
}

class _QaidaExamScreenState extends State<QaidaExamScreen> {
  late List<QaidaExamQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _hasAnswered = false;
  int _correctCount = 0;
  bool _examFinished = false;
  final List<QaidaExamQuestion> _missedQuestions = [];

  String get _examId {
    switch (widget.tier) {
      case QaidaExamTier.stepBoss:
        final num = widget.step?.stepNumber ?? 1;
        return 'step_${num}_boss';
      case QaidaExamTier.weekly:
        return 'weekly_exam_${widget.weekNumber}';
      case QaidaExamTier.monthly:
        return 'monthly_exam_${widget.monthNumber}';
    }
  }

  String get _examTitle {
    switch (widget.tier) {
      case QaidaExamTier.stepBoss:
        return 'স্টেপ ${widget.step?.stepNumber ?? 1} বস পরীক্ষা';
      case QaidaExamTier.weekly:
        return 'সাপ্তাহিক মূল্যায়ন ${widget.weekNumber}';
      case QaidaExamTier.monthly:
        return 'মাসিক মেগা পরীক্ষা ${widget.monthNumber}';
    }
  }

  int get _xpReward {
    switch (widget.tier) {
      case QaidaExamTier.stepBoss:
        return 30;
      case QaidaExamTier.weekly:
        return 25;
      case QaidaExamTier.monthly:
        return 40;
    }
  }

  @override
  void initState() {
    super.initState();
    _buildQuestions();
  }

  void _buildQuestions() {
    final allSteps = NuraniQaidaData.steps;
    final rng = math.Random();
    final list = <QaidaExamQuestion>[];

    if (widget.tier == QaidaExamTier.stepBoss && widget.step != null) {
      final s = widget.step!;
      for (final lesson in s.lessons) {
        for (final act in lesson.activities) {
          if (act.options.length >= 2) {
            list.add(
              QaidaExamQuestion(
                id: act.id,
                prompt: act.prompt,
                arabicDisplay: act.arabicTarget ?? lesson.arabicDisplay,
                options: act.options,
                correctIndex: act.correctIndex.clamp(0, act.options.length - 1),
                explanation: act.explanation ?? lesson.description,
                topicName: lesson.title,
                audioAsset: act.audioAsset,
              ),
            );
          }
        }
      }
    } else if (widget.tier == QaidaExamTier.weekly) {
      // Current week steps (~3 steps) + 20% past steps
      final targetSteps = allSteps.take(widget.weekNumber * 3).toList();
      for (final s in targetSteps) {
        for (final l in s.lessons) {
          final act = l.activities.firstOrNull;
          if (act != null && act.options.length >= 2) {
            list.add(
              QaidaExamQuestion(
                id: act.id,
                prompt: act.prompt,
                arabicDisplay: act.arabicTarget ?? l.arabicDisplay,
                options: act.options,
                correctIndex: act.correctIndex.clamp(0, act.options.length - 1),
                explanation: act.explanation ?? l.description,
                topicName: s.title,
              ),
            );
          }
        }
      }
    } else {
      // Monthly exam: all steps up to current month
      for (final s in allSteps) {
        for (final l in s.lessons) {
          final act = l.activities.firstOrNull;
          if (act != null && act.options.length >= 2) {
            list.add(
              QaidaExamQuestion(
                id: act.id,
                prompt: act.prompt,
                arabicDisplay: act.arabicTarget ?? l.arabicDisplay,
                options: act.options,
                correctIndex: act.correctIndex.clamp(0, act.options.length - 1),
                explanation: act.explanation ?? l.description,
                topicName: s.title,
              ),
            );
          }
        }
      }
    }

    list.shuffle(rng);
    // Standard exam length: 10 questions for focused experience
    _questions = list.take(10).toList();

    // Fallback if empty
    if (_questions.isEmpty) {
      _questions = [
        const QaidaExamQuestion(
          id: 'fb_1',
          prompt: 'সঠিক হরফটি নির্বাচন করুন: আলিফ',
          arabicDisplay: 'ا',
          options: ['ا', 'ب', 'ت'],
          correctIndex: 0,
          explanation: 'আলিফ খালি এবং মুখ থেকে নিঃশ্বাসের সাথে উচ্চারিত হয়।',
          topicName: 'মুফরাদাত',
        ),
      ];
    }
  }

  void _submitAnswer() {
    if (_hasAnswered || _selectedOptionIndex == null) return;
    final q = _questions[_currentIndex];
    final isCorrect = _selectedOptionIndex == q.correctIndex;

    setState(() {
      _hasAnswered = true;
      if (isCorrect) {
        _correctCount++;
      } else {
        _missedQuestions.add(q);
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _hasAnswered = false;
      });
    } else {
      _finishExam();
    }
  }

  void _finishExam() {
    final score = ((_correctCount / _questions.length) * 100).round();
    final passed = score >= 80;
    final state = context.read<AppState>();

    // Record score
    state.recordExamScore(_examId, score);

    if (passed) {
      state.completeLesson(_examId, xp: _xpReward);
    }

    setState(() {
      _examFinished = true;
    });
  }

  void _retakeExam() {
    setState(() {
      _currentIndex = 0;
      _selectedOptionIndex = null;
      _hasAnswered = false;
      _correctCount = 0;
      _examFinished = false;
      _missedQuestions.clear();
      _buildQuestions(); // fresh randomized questions
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_examFinished) {
      return _buildResultScreen();
    }

    final q = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text('পরীক্ষা থেকে বের হবেন?',
                    style: GoogleFonts.hindSiliguri(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                content: Text(
                  'এখন বের হলে এই পরীক্ষার অগ্রগতি সংরক্ষিত হবে না।',
                  style: GoogleFonts.hindSiliguri(fontSize: 14),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('চালিয়ে যান'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626)),
                    child: const Text('বের হন'),
                  ),
                ],
              ),
            );
          },
        ),
        title: Column(
          children: [
            Text(
              _examTitle,
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'প্রশ্ন ${_currentIndex + 1} / ${_questions.length}  (পাস মার্ক ৮০%)',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.duoGreen),
            minHeight: 6,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Exam Tier Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.stars_rounded,
                              color: Color(0xFF2563EB), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '৮০% মার্কস পেলে পরবর্তী ধাপ উন্মুক্ত হবে • নেগেটিভ মার্কিং নেই',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E40AF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Target Arabic Display
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 28, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: const Color(0xFFE2E8F0), width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            q.arabicDisplay,
                            style: TextStyle(
                              fontFamily: AppTheme.arabicFontFamily,
                              fontSize: 54,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            q.prompt,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Options List
                    ...List.generate(q.options.length, (idx) {
                      final opt = q.options[idx];
                      final isSelected = _selectedOptionIndex == idx;
                      final isCorrect = _hasAnswered && idx == q.correctIndex;
                      final isWrong =
                          _hasAnswered && isSelected && !isCorrect;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: _hasAnswered
                              ? null
                              : () =>
                                  setState(() => _selectedOptionIndex = idx),
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 15),
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
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFFF1F5F9),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${idx + 1}',
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
                                      color: Color(0xFF2563EB), size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Color(0xFFE2E8F0), width: 1.5)),
              ),
              child: SafeArea(
                top: false,
                child: Duolingo3DButton(
                  text: !_hasAnswered
                      ? 'যাচাই করুন'
                      : (_currentIndex < _questions.length - 1
                          ? 'পরবর্তী প্রশ্ন ➔'
                          : 'ফলাফল দেখুন ➔'),
                  color: !_hasAnswered
                      ? (_selectedOptionIndex != null
                          ? AppTheme.duoGreen
                          : const Color(0xFFE5E7EB))
                      : AppTheme.duoGreen,
                  textColor: !_hasAnswered && _selectedOptionIndex == null
                      ? const Color(0xFFAFAFAF)
                      : Colors.white,
                  onPressed: !_hasAnswered
                      ? (_selectedOptionIndex != null ? _submitAnswer : null)
                      : _nextQuestion,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── RESULT SCREEN (80% GATE WITH REVISION RETRY FLOW) ─────────────────────

  Widget _buildResultScreen() {
    final score = ((_correctCount / _questions.length) * 100).round();
    final passed = score >= 80;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: QuranBookMascot(
                  size: 96,
                  mood: passed
                      ? QuranMascotMood.celebrating
                      : QuranMascotMood.encouraging,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                passed ? 'মাশাআল্লাহ! অভিনন্দন!' : 'একটু আরও অনুশীলন করি!',
                textAlign: TextAlign.center,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: passed
                      ? const Color(0xFF15803D)
                      : const Color(0xFFB45309),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                passed
                    ? 'তুমি সফলভাবে পরীক্ষায় উত্তীর্ণ হয়েছ! (+$_xpReward XP)'
                    : 'মন খারাপের কিছু নেই! চলো ভুলগুলো রিভিশন দ্বীপে আবার শিখি।',
                textAlign: TextAlign.center,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 15,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 28),

              // Score Circle
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: passed
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEF3C7),
                    border: Border.all(
                      color: passed
                          ? const Color(0xFF86EFAC)
                          : const Color(0xFFFDE68A),
                      width: 4,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$score%',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: passed
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFD97706),
                        ),
                      ),
                      Text(
                        passed ? 'উত্তীর্ণ ✓' : '৮০% প্রয়োজন',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: passed
                              ? const Color(0xFF15803D)
                              : const Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Effort Badge if passed on retake
              if (passed && widget.isRetake) ...[
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🏅', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        '“আবার চেষ্টা ব্যাজ” অর্জিত হয়েছে!',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Action Buttons
              if (passed) ...[
                Duolingo3DButton(
                  text: 'পরবর্তী ধাপ ➔',
                  color: AppTheme.duoGreen,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ] else ...[
                Duolingo3DButton(
                  text: 'রিভিশন দ্বীপে অনুশীলন ➔',
                  color: const Color(0xFF3B82F6),
                  shadowColor: const Color(0xFF1D4ED8),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const QaidaRevisionScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Duolingo3DButton.secondary(
                  text: 'আবার পরীক্ষা দিন',
                  icon: const Icon(Icons.refresh_rounded, size: 20, color: Color(0xFF374151)),
                  onPressed: _retakeExam,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
