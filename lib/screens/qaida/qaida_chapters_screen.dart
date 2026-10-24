import '../../core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/nurani_qaida_data.dart';
import '../../l10n/app_localizations.dart';
import '../../models/qaida/qaida_models.dart';
import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/qaida/garden_progress_widget.dart';
import 'qaida_exam_screen.dart';
import 'qaida_report_screen.dart';
import 'qaida_revision_screen.dart';
import 'qaida_track_lessons_screen.dart';

int _stepCompletedCount(AppState state, NuraniStepInfo step) {
  return step.lessons
      .where((lesson) => state.hasCompletedLesson(lesson.id))
      .length;
}

bool _isStepCompleted(AppState state, NuraniStepInfo step) {
  final count = _stepCompletedCount(state, step);
  return count == step.totalLessons && step.totalLessons > 0;
}

bool _isStepUnlocked(AppState state, int stepIndex, List<NuraniStepInfo> allSteps) {
  if (state.isAdmin) return true;
  if (stepIndex == 0) return true;
  final prevStep = allSteps[stepIndex - 1];
  
  // Unlocked if previous step's lessons are all completed
  if (_isStepCompleted(state, prevStep)) return true;

  // Or if previous step's Boss Challenge passed with >= 80%
  final stepExamId = 'step_${prevStep.stepNumber}_boss';
  if (state.examPassed(stepExamId, passingThreshold: 80)) return true;

  return false;
}

(int, int) _findCurrentStepAndLesson(AppState state, List<NuraniStepInfo> allSteps) {
  for (final step in allSteps) {
    for (var i = 0; i < step.lessons.length; i++) {
      if (!state.hasCompletedLesson(step.lessons[i].id)) {
        return (step.stepNumber, i + 1);
      }
    }
  }
  return (allSteps.length, allSteps.last.totalLessons);
}

void _openStep(BuildContext context, NuraniStepInfo step) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => QaidaTrackLessonsScreen(track: step.toTrackInfo()),
    ),
  );
}

/// 17-Island Treasure Map Learning Roadmap with Garden Progress Widget
/// Follows Master Design Plan:
/// - 17 progressive steps (Mufradat to Tilawat)
/// - Grouped into 6 natural Levels (Harf Chena to Tilawat)
/// - Animated Islamic Garden Progress at the top ("Step X, Lesson Y" labeling)
/// - 80% passing gate per step
/// - Dedicated Review Island & Progress Report portals
/// - Shari'ah-compliant respectful aesthetics (no animal mascots)
class QaidaChaptersScreen extends StatelessWidget {
  const QaidaChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final allSteps = NuraniQaidaData.steps;

    final completedStepsCount = allSteps
        .where((step) => _isStepCompleted(state, step))
        .length;
    final (currStep, currLesson) = _findCurrentStepAndLesson(state, allSteps);

    // Group steps by Phase/Level
    final Map<int, List<NuraniStepInfo>> phaseMap = {};
    for (final step in allSteps) {
      phaseMap.putIfAbsent(step.phaseNumber, () => []).add(step);
    }

    final phaseTitles = {
      1: context.t('qaida.phase_1_title'),
      2: context.t('qaida.phase_2_title'),
      3: context.t('qaida.phase_3_title'),
      4: context.t('qaida.phase_4_title'),
      5: context.t('qaida.phase_5_title'),
      6: context.t('qaida.phase_6_title'),
    };

    final phaseSubtitles = {
      1: context.t('qaida.phase_1_subtitle'),
      2: context.t('qaida.phase_2_subtitle'),
      3: context.t('qaida.phase_3_subtitle'),
      4: context.t('qaida.phase_4_subtitle'),
      5: context.t('qaida.phase_5_subtitle'),
      6: context.t('qaida.phase_6_subtitle'),
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: ListView(
              padding: EdgeInsets.all(tablet ? 32 : 18),
              children: [
                // Header
                _QaidaHeader(
                  onBack: () => Navigator.pop(context),
                  completedCount: completedStepsCount,
                  totalCount: allSteps.length,
                ),
                const SizedBox(height: 16),

                // Islamic Garden Progress Widget
                IslamicGardenWidget(
                  completedStepsCount: completedStepsCount,
                  totalStepsCount: allSteps.length,
                  currentStepNumber: currStep,
                  currentLessonNumber: currLesson,
                  totalStars: (state.xp / 10).round(),
                ),
                const SizedBox(height: 16),

                // Quick Action Bar: Review Island & Progress Report
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const QaidaRevisionScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: const Color(0xFFC7D2FE), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1)
                                    .withValues(alpha: 0.08),
                                offset: const Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const VectorIcon(
                                    type: VectorIconType.plant,
                                    size: 20,
                                    color: Color(0xFF4F46E5)),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LocalizedText(
                                      context.t('qaida.revision_island'),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4338CA),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    LocalizedText(
                                      state.hasSkillsDueForReview
                                          ? context.t('qaida.letters_due_for_review', params: {
                                              'count': context.formatDigits('${state.skillsDueForReview.length}'),
                                            })
                                          : context.t('qaida.weak_letters_practice'),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: state.hasSkillsDueForReview
                                            ? Colors.amber.shade900
                                            : const Color(0xFF6366F1),
                                        fontWeight: state.hasSkillsDueForReview
                                            ? FontWeight.bold
                                            : FontWeight.normal,
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const QaidaReportScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: const Color(0xFFBBF7D0), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF16A34A)
                                    .withValues(alpha: 0.08),
                                offset: const Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const VectorIcon(
                                    type: VectorIconType.target,
                                    size: 20,
                                    color: Color(0xFF16A34A)),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LocalizedText(
                                      context.t('qaida.progress_report'),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF15803D),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    LocalizedText(
                                      context.t('qaida.mastery_and_performance'),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF16A34A),
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
                  ],
                ),
                const SizedBox(height: 12),

                // 3-Tier Exam Center (Weekly & Monthly Exams)
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const QaidaExamScreen(
                                tier: QaidaExamTier.weekly,
                                weekNumber: 1,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: const Color(0xFFFDE68A), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD97706)
                                    .withValues(alpha: 0.08),
                                offset: const Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFBEB),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const VectorIcon(
                                    type: VectorIconType.scroll,
                                    size: 20,
                                    color: Color(0xFFD97706)),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LocalizedText(
                                      context.t('qaida.weekly_exam'),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF92400E),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    LocalizedText(
                                      context.t('qaida.weekly_exam_reward'),
                                      style: const TextStyle(
                                        fontSize: 10,
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const QaidaExamScreen(
                                tier: QaidaExamTier.monthly,
                                monthNumber: 1,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: const Color(0xFFE9D5FF), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF9333EA)
                                    .withValues(alpha: 0.08),
                                offset: const Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAF5FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const VectorIcon(
                                    type: VectorIconType.trophy,
                                    size: 20,
                                    color: Color(0xFF9333EA)),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LocalizedText(
                                      context.t('qaida.monthly_exam'),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6B21A8),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    LocalizedText(
                                      context.t('qaida.monthly_exam_reward'),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF7E22CE),
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
                  ],
                ),
                const SizedBox(height: 18),

                // Admin Tester Mode Banner & Quick Toggle
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: state.isAdmin ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: state.isAdmin ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        state.isAdmin ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                        size: 20,
                        color: state.isAdmin ? const Color(0xFFB45309) : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LocalizedText(
                              state.isAdmin
                                  ? context.t('qaida.admin_mode_active')
                                  : context.t('qaida.student_mode_active'),
                              style: TextStyle(
                                fontSize: 13,
                                color: state.isAdmin ? const Color(0xFF92400E) : const Color(0xFF334155),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            LocalizedText(
                              state.isAdmin
                                  ? context.t('qaida.admin_all_unlocked_desc')
                                  : context.t('qaida.admin_enable_desc'),
                              style: TextStyle(
                                fontSize: 11,
                                color: state.isAdmin ? const Color(0xFFB45309) : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      DSButton(
                        label: state.isAdmin ? context.t('qaida.lock_mode_button') : context.t('qaida.unlock_all_button'),
                        height: 38,
                        fontSize: 12,
                        borderRadius: 12,
                        variant: state.isAdmin
                            ? DSButtonVariant.gold
                            : DSButtonVariant.primary,
                        onPressed: () async {
                          await state.toggleAdminMode();
                        },
                      ),
                    ],
                  ),
                ),

                // 17-Island Treasure Map Levels & Steps
                for (final phaseEntry in phaseMap.entries) ...[
                  _PhaseSectionHeader(
                    title: phaseTitles[phaseEntry.key] ?? context.t('qaida.level_number', params: {'number': context.formatDigits('${phaseEntry.key}')}),
                    subtitle: phaseSubtitles[phaseEntry.key] ?? '',
                    phaseNumber: phaseEntry.key,
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < phaseEntry.value.length; i++) ...[
                    _StepIslandCard(
                      step: phaseEntry.value[i],
                      allSteps: allSteps,
                      state: state,
                      isUnlocked: _isStepUnlocked(
                        state,
                        allSteps.indexOf(phaseEntry.value[i]),
                        allSteps,
                      ),
                      isCompleted: _isStepCompleted(state, phaseEntry.value[i]),
                      onTap: () => _openStep(context, phaseEntry.value[i]),
                    ),
                    if (i < phaseEntry.value.length - 1 || phaseEntry.key < phaseMap.length)
                      const _SteppingPathDivider(),
                  ],
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SUB-WIDGETS
// ---------------------------------------------------------------------------

class _QaidaHeader extends StatelessWidget {
  const _QaidaHeader({
    required this.onBack,
    required this.completedCount,
    required this.totalCount,
  });

  final VoidCallback onBack;
  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) => DuolingoPageHeader(
        title: context.t('qaida.title'),
        subtitle: context.t('qaida.full_map_subtitle'),
        customIcon: Image.asset(
          'assets/images/badge_qaida_3d.png',
          width: 36,
          height: 36,
          fit: BoxFit.contain,
        ),
        gradientColors: const [Color(0xFF58CC02), Color(0xFF46A302)],
        onBack: onBack,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: LocalizedText(
            context.t('qaida.steps_progress_badge', params: {
              'completed': context.formatDigits('$completedCount'),
              'total': context.formatDigits('$totalCount'),
            }),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ),
      );
}

class _PhaseSectionHeader extends StatelessWidget {
  const _PhaseSectionHeader({
    required this.title,
    required this.subtitle,
    required this.phaseNumber,
  });

  final String title;
  final String subtitle;
  final int phaseNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryGreen,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$phaseNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppFonts.getTextStyle(context, 
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepIslandCard extends StatelessWidget {
  const _StepIslandCard({
    required this.step,
    required this.allSteps,
    required this.state,
    required this.isUnlocked,
    required this.isCompleted,
    required this.onTap,
  });

  final NuraniStepInfo step;
  final List<NuraniStepInfo> allSteps;
  final AppState state;
  final bool isUnlocked;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final doneCount = _stepCompletedCount(state, step);
    final total = step.totalLessons;
    final progress = total > 0 ? (doneCount / total).clamp(0.0, 1.0) : 0.0;
    final bossPassed = state.examPassed('step_${step.stepNumber}_boss', passingThreshold: 80);

    return Container(
      decoration: BoxDecoration(
        color: !isUnlocked ? const Color(0xFFF8FAFC) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isCompleted
              ? AppTheme.duoGreen
              : (isUnlocked ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9)),
          width: isCompleted ? 2.2 : 1.5,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isUnlocked
              ? onTap
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: LocalizedText(context.t('qaida.step_locked_snack', params: {
                        'step': context.formatDigits('${step.stepNumber}'),
                        'title': context.uiText(step.title),
                      })),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: context.t('qaida.admin_unlock_action'),
                        textColor: Colors.amber,
                        onPressed: () async {
                          await state.setUserRole('admin');
                        },
                      ),
                    ),
                  );
                },
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step Number & Plant/Icon Badge
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? step.color.withValues(alpha: 0.12)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isUnlocked
                              ? step.color.withValues(alpha: 0.3)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.check_circle_rounded
                                : (!isUnlocked ? Icons.lock_rounded : step.icon),
                            color: isCompleted
                                ? AppTheme.duoGreen
                                : (!isUnlocked
                                    ? const Color(0xFF94A3B8)
                                    : step.color),
                            size: 22,
                          ),
                          const SizedBox(height: 1),
                          LocalizedText(
                            context.t('qaida.step_badge', params: {
                              'number': context.formatDigits('${step.stepNumber}'),
                            }),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: !isUnlocked
                                  ? const Color(0xFF94A3B8)
                                  : step.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Title & Description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: LocalizedText(
                                  step.title,
                                  style: AppFonts.getTextStyle(context, 
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isUnlocked
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              Text(
                                step.arabicTitle,
                                style: TextStyle(
                                  fontFamily: AppTheme.arabicFontFamily,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: !isUnlocked
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF475569),
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            step.description,
                            style: AppFonts.getTextStyle(context, 
                              fontSize: 12,
                              color: !isUnlocked
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF64748B),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),

                          // Garden Flora Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFFEF3C7)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const VectorIcon(type: VectorIconType.plant, size: 14),
                                const SizedBox(width: 4),
                                LocalizedText(
                                  context.t('qaida.garden_reward', params: {'plant': context.uiText(step.gardenPlant)}),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Progress Bar & Info
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 7,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCompleted ? AppTheme.duoGreen : step.color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    LocalizedText(
                      !isUnlocked
                          ? context.t('qaida.locked_threshold')
                          : (isCompleted
                              ? context.t('qaida.mastered_completed')
                              : context.t('qaida.lessons_progress', params: {
                                  'done': context.formatDigits('$doneCount'),
                                  'total': context.formatDigits('$total'),
                                })),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: !isUnlocked
                            ? const Color(0xFF94A3B8)
                            : (isCompleted
                                ? AppTheme.duoGreen
                                : const Color(0xFF475569)),
                      ),
                    ),
                  ],
                ),

                // Boss Challenge badge indicator
                if (isUnlocked) ...[
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => QaidaExamScreen(
                            tier: QaidaExamTier.stepBoss,
                            step: step,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: bossPassed
                            ? const Color(0xFFFEF3C7)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: bossPassed
                              ? const Color(0xFFFDE68A)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            bossPassed
                                ? Icons.verified_rounded
                                : Icons.military_tech_rounded,
                            size: 16,
                            color: bossPassed
                                ? Colors.amber.shade700
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          LocalizedText(
                            bossPassed
                                ? context.t('qaida.step_boss_passed')
                                : context.t('qaida.step_boss_take_exam'),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: bossPassed
                                  ? Colors.amber.shade900
                                  : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 10,
                            color: bossPassed
                                ? Colors.amber.shade900
                                : const Color(0xFF64748B),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SteppingPathDivider extends StatelessWidget {
  const _SteppingPathDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFFCBD5E1),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF94A3B8),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFFCBD5E1),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact chapter list shown directly on Home as the Qaida learning path.
class QaidaChapterPath extends StatelessWidget {
  const QaidaChapterPath({super.key, required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final allSteps = NuraniQaidaData.steps;
    final completed = allSteps
        .where((step) => _isStepCompleted(state, step))
        .length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 36 : 18),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: LocalizedText(
                  context.t('qaida.curriculum_subtitle'),
                  style: AppFonts.getTextStyle(context, 
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LocalizedText(
                  context.t('qaida.steps_progress_badge', params: {
                    'completed': context.formatDigits('$completed'),
                    'total': context.formatDigits('${allSteps.length}'),
                  }),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: allSteps.isNotEmpty ? completed / allSteps.length : 0,
              minHeight: 9,
              backgroundColor: const Color(0xFFE2E8F0),
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allSteps.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) => SizedBox(
                width: isTablet ? 200 : 170,
                child: _CompactStepCard(
                  step: allSteps[i],
                  index: i,
                  state: state,
                  locked: !_isStepUnlocked(state, i, allSteps),
                  onTap: () => _openStep(context, allSteps[i]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          LocalizedText(
            context.t('qaida.learning_stages_flow'),
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _CompactStepCard extends StatelessWidget {
  const _CompactStepCard({
    required this.step,
    required this.index,
    required this.state,
    required this.locked,
    required this.onTap,
  });

  final NuraniStepInfo step;
  final int index;
  final AppState state;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final done = _stepCompletedCount(state, step);
    final total = step.totalLessons;
    final complete = done == total && total > 0;

    return Container(
      decoration: BoxDecoration(
        color: locked ? const Color(0xFFF1F5F9) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: complete
              ? AppTheme.duoGreen
              : (locked ? const Color(0xFFE2E8F0) : const Color(0xFFCBD5E1)),
          width: complete ? 2 : 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: step.color.withValues(alpha: 0.15),
                      child: Icon(
                        locked
                            ? Icons.lock_rounded
                            : (complete ? Icons.check_rounded : step.icon),
                        color: locked ? const Color(0xFF94A3B8) : step.color,
                        size: 16,
                      ),
                    ),
                    Text(
                      step.arabicTitle,
                      style: TextStyle(
                        fontFamily: AppTheme.arabicFontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: locked
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF475569),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                const Spacer(),
                LocalizedText(
                  context.t('qaida.compact_step_title', params: {
                    'number': context.formatDigits('${step.stepNumber}'),
                    'title': context.uiText(step.title),
                  }),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.getTextStyle(context, 
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: locked ? const Color(0xFF94A3B8) : AppTheme.darkText,
                  ),
                ),
                LocalizedText(
                  locked
                      ? context.t('qaida.locked_threshold')
                      : context.t('qaida.lessons_completed', params: {
                          'done': context.formatDigits('$done'),
                          'total': context.formatDigits('$total'),
                        }),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: locked ? const Color(0xFF94A3B8) : AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
