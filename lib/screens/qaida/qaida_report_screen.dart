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
import '../../widgets/quran_book_mascot.dart';
import '../../widgets/vector_icons.dart';
import 'qaida_letters.dart';
import 'qaida_revision_screen.dart';
import 'qaida_track_lessons_screen.dart';

/// Child-friendly & Guardian Learning Progress Report Screen (Section 5.6)
class QaidaReportScreen extends StatelessWidget {
  const QaidaReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tracks = NuraniQaidaData.steps.map((s) => s.toTrackInfo()).toList();
    final allLessons = tracks.expand((t) => t.lessons).toList();

    final completedLessonsCount =
        allLessons.where((l) => state.hasCompletedLesson(l.id)).length;
    final totalLessonsCount = allLessons.length;

    final completedTracksCount = tracks.where((t) {
      return t.lessons.every((l) => state.hasCompletedLesson(l.id));
    }).length;

    // Checkpoint exams passed
    final passedExamsCount = tracks.fold<int>(0, (acc, t) {
      var count = 0;
      final checkpoints = (t.lessons.length / 5).floor();
      for (var i = 1; i <= checkpoints; i++) {
        if (state.hasCompletedLesson('${t.id}_checkpoint_$i')) count++;
      }
      if (state.hasCompletedLesson('${t.id}_final')) count++;
      return acc + count;
    });

    final overallProgress = totalLessonsCount > 0
        ? completedLessonsCount / totalLessonsCount
        : 0.0;

    final skills = state.allSkillProgress.values.toList();
    final avgAccuracy = skills.isNotEmpty
        ? (skills.fold<double>(0.0, (acc, s) => acc + s.accuracy) /
                skills.length *
                100)
            .toInt()
        : 100;
    final dueCount = state.skillsDueForReview.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              children: [
                DuolingoHeader(
                  title: context.t('report.title'),
                  subtitle: context.t('report.subtitle'),
                  iconType: VectorIconType.trophy,
                  gradientColors: const [Color(0xFF58CC02), Color(0xFF46A302)],
                  onBack: () => Navigator.of(context).pop(),
                ),
                // Top overview card with Mascot
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF58CC02), Color(0xFF46A302)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20), // DS.rXl
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF46A302).withValues(alpha: 0.28),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            child: const Icon(Icons.person_rounded,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.userName.isNotEmpty
                                      ? state.userName
                                      : context.t('report.default_child_learner'),
                                  style: AppFonts.getTextStyle(context, 
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  state.isAdmin
                                      ? context.t('report.role_admin')
                                      : context.t('report.learner_age_desc', params: {'age': '${state.age}'}),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          QuranBookMascot(
                            size: 58,
                            mood: overallProgress >= 1.0
                                ? QuranMascotMood.celebrating
                                : QuranMascotMood.glowing,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.bolt_rounded,
                                    color: Color(0xFFFFC800), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  context.t('report.xp_earned', params: {'xp': '${state.xp}'}),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            context.t('report.lessons_completed_summary', params: {
                              'completed': '$completedLessonsCount',
                              'total': '$totalLessonsCount',
                              'percent': (overallProgress * 100).toStringAsFixed(0),
                            }),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: overallProgress,
                          minHeight: 10,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFFC800)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Key metrics 3-col grid
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.auto_stories_rounded,
                        color: const Color(0xFF58CC02),
                        title: context.t('report.metric_lessons_completed'),
                        value: '$completedLessonsCount',
                        subtitle: context.t('report.metric_total_lessons', params: {'total': '$totalLessonsCount'}),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.layers_rounded,
                        color: const Color(0xFF6366F1),
                        title: context.t('report.metric_steps_finished'),
                        value: '$completedTracksCount',
                        subtitle: context.t('report.metric_total_steps'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.workspace_premium_rounded,
                        color: const Color(0xFFF59E0B),
                        title: context.t('report.metric_exams_passed'),
                        value: '$passedExamsCount',
                        subtitle: context.t('report.metric_pass_mark'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick Spaced Repetition / Accuracy Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.psychology_rounded,
                            color: Color(0xFF4F46E5), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.t('report.accuracy_rate', params: {'accuracy': '$avgAccuracy'}),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              dueCount > 0
                                  ? context.t('report.revision_due', params: {'count': '$dueCount'})
                                  : context.t('report.all_fresh'),
                              style: TextStyle(
                                fontSize: 12,
                                color: dueCount > 0
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const QaidaRevisionScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.replay_rounded, size: 14),
                        label: Text(
                          context.t('report.practice_btn'),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 28-Letter Weak Letter Heatmap (Section 10/16)
                _WeakLetterHeatmapWidget(state: state),
                const SizedBox(height: 18),

                // 3-Tier Exam Audit Card (Section 13)
                _ExamAuditCard(state: state),
                const SizedBox(height: 18),

                // Guardian Teach Back & Family Listening Card (Section 8/14)
                _GuardianTeachBackCard(state: state),
                const SizedBox(height: 24),

                // Track by Track breakdown
                Text(
                  context.t('report.track_breakdown_title'),
                  style: AppFonts.getTextStyle(context, 
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),

                for (final track in tracks) ...[
                  _TrackProgressReportTile(track: track, state: state),
                  const SizedBox(height: 10),
                ],

                const SizedBox(height: 20),
                // Guardian / Pedagogical Note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(

                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.verified_user_rounded,
                          color: Color(0xFFD97706), size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.t('report.guardian_guidance_title'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF92400E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.t('report.guardian_guidance_body'),
                              style: AppFonts.getTextStyle(context, 
                                fontSize: 13,
                                color: const Color(0xFF78350F),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackProgressReportTile extends StatelessWidget {
  const _TrackProgressReportTile({
    required this.track,
    required this.state,
  });

  final QaidaTrackInfo track;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final done = track.lessons
        .where((l) => state.hasCompletedLesson(l.id))
        .length;
    final total = track.totalLessons;
    final pct = total > 0 ? (done / total * 100).toInt() : 0;
    final isDone = done == total && total > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone
              ? AppTheme.duoGreen.withValues(alpha: 0.4)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => QaidaTrackLessonsScreen(track: track),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: track.color.withValues(alpha: 0.12),
                  child: Icon(
                    isDone ? Icons.check_circle_rounded : track.icon,
                    color: track.color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              context.uiText(track.title),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${context.formatDigits('$done')}/${context.formatDigits('$total')} (${context.formatDigits('$pct')}%)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDone
                                  ? AppTheme.duoGreen
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: total > 0 ? done / total : 0,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(track.color),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 28-LETTER WEAK LETTER HEATMAP
// ─────────────────────────────────────────────────────────────────────────────

class _WeakLetterHeatmapWidget extends StatelessWidget {
  const _WeakLetterHeatmapWidget({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.grid_view_rounded,
                    color: Color(0xFFD97706), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('report.heatmap_title'),
                      style: AppFonts.getTextStyle(context, 
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      context.t('report.heatmap_legend'),
                      style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 7 columns x 4 rows grid = 28 letters
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: qaidaLetters.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final letter = qaidaLetters[index];
              final ar = letter.letter;
              final name = context.t(letter.nameKey);
              final makhraj = context.t(letter.makhrajKey);

              // Skill resolution
              final skill = state.allSkillProgress[ar] ??
                  state.allSkillProgress.values.cast<SkillProgress?>().firstWhere(
                        (s) => s?.skillId.contains(ar) ?? false,
                        orElse: () => null,
                      );

              Color bgColor;
              Color borderColor;
              Color textColor;

              if (skill == null || skill.totalAttempts == 0) {
                // Not yet practiced
                bgColor = const Color(0xFFF8FAFC);
                borderColor = const Color(0xFFE2E8F0);
                textColor = const Color(0xFF94A3B8);
              } else if (skill.accuracy >= 0.8) {
                // Mastered
                bgColor = const Color(0xFFDCFCE7);
                borderColor = const Color(0xFF86EFAC);
                textColor = const Color(0xFF15803D);
              } else if (skill.accuracy >= 0.5) {
                // Developing
                bgColor = const Color(0xFFFEF3C7);
                borderColor = const Color(0xFFFDE68A);
                textColor = const Color(0xFFB45309);
              } else {
                // Weak letter
                bgColor = const Color(0xFFFEE2E2);
                borderColor = const Color(0xFFFCA5A5);
                textColor = const Color(0xFFB91C1C);
              }

              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: Row(
                        children: [
                          Text(
                            ar,
                            style: TextStyle(
                              fontFamily: AppTheme.arabicFontFamily,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            context.t('report.letter_title', params: {'name': name}),
                            style: AppFonts.getTextStyle(context, 
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.t('report.makhraj_label'),
                            style: AppFonts.getTextStyle(context, 
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: const Color(0xFF475569),
                            ),
                          ),
                          Text(
                            makhraj,
                            style: AppFonts.getTextStyle(context, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            skill != null
                                ? context.t('report.letter_accuracy_stats', params: {
                                    'accuracy': '${(skill.accuracy * 100).toInt()}',
                                    'errors': '${skill.incorrectAttempts}',
                                  })
                                : context.t('report.letter_no_practice'),
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(context.t('common.ok')),
                        ),
                        DSButton(
                          label: context.t('report.practice_now_btn'),
                          height: 42,
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const QaidaRevisionScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    ar,
                    style: TextStyle(
                      fontFamily: AppTheme.arabicFontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3-TIER EXAM AUDIT CARD
// ─────────────────────────────────────────────────────────────────────────────

class _ExamAuditCard extends StatelessWidget {
  const _ExamAuditCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    // Count passed step boss exams
    int passedBossCount = 0;
    for (var i = 1; i <= 17; i++) {
      if (state.examPassed('step_${i}_boss', passingThreshold: 80)) {
        passedBossCount++;
      }
    }

    // Weekly exams passed
    int passedWeeklyCount = 0;
    for (var i = 1; i <= 26; i++) {
      if (state.examPassed('weekly_exam_$i', passingThreshold: 80)) {
        passedWeeklyCount++;
      }
    }

    // Monthly exams passed
    int passedMonthlyCount = 0;
    for (var i = 1; i <= 6; i++) {
      if (state.examPassed('monthly_exam_$i', passingThreshold: 80)) {
        passedMonthlyCount++;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.military_tech_rounded,
                    color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('report.exam_audit_title'),
                      style: AppFonts.getTextStyle(context, 
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      context.t('report.exam_audit_subtitle'),
                      style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ExamMiniBadge(
                  label: context.t('report.step_boss'),
                  value: context.formatDigits('$passedBossCount/17'),
                  color: const Color(0xFF58CC02),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ExamMiniBadge(
                  label: context.t('report.weekly_exam'),
                  value: context.t('report.count_suffix', params: {'count': '$passedWeeklyCount'}),
                  color: const Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ExamMiniBadge(
                  label: context.t('report.monthly_mega_exam'),
                  value: context.t('report.count_suffix', params: {'count': '$passedMonthlyCount'}),
                  color: const Color(0xFF9333EA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExamMiniBadge extends StatelessWidget {
  const _ExamMiniBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GUARDIAN TEACH BACK & FAMILY LISTENING
// ─────────────────────────────────────────────────────────────────────────────

class _GuardianTeachBackCard extends StatefulWidget {
  const _GuardianTeachBackCard({required this.state});

  final AppState state;

  @override
  State<_GuardianTeachBackCard> createState() => _GuardianTeachBackCardState();
}

class _GuardianTeachBackCardState extends State<_GuardianTeachBackCard> {
  bool _checkedToday = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBBF7D0), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.family_restroom_rounded,
                    color: Color(0xFF15803D), size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('report.guardian_checkin_title'),
                      style: AppFonts.getTextStyle(context, 
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF166534),
                      ),
                    ),
                    Text(
                      context.t('report.guardian_checkin_sub'),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF15803D)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.t('report.guardian_checkin_body'),
            style: AppFonts.getTextStyle(context, 
              fontSize: 13,
              color: const Color(0xFF14532D),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: _checkedToday
                ? null
                : () {
                    setState(() {
                      _checkedToday = true;
                    });
                    widget.state.addXp(15);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            context.t('report.guardian_checkin_snack')),
                        backgroundColor: const Color(0xFF16A34A),
                      ),
                    );
                  },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color:
                    _checkedToday ? const Color(0xFFDCFCE7) : AppTheme.duoGreen,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _checkedToday
                      ? const Color(0xFF86EFAC)
                      : const Color(0xFF46A302),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _checkedToday
                        ? Icons.check_circle_rounded
                        : Icons.record_voice_over_rounded,
                    color:
                        _checkedToday ? const Color(0xFF15803D) : Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _checkedToday
                        ? context.t('report.checked_done')
                        : context.t('report.check_listen_action'),
                    style: AppFonts.getTextStyle(context, 
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _checkedToday
                          ? const Color(0xFF15803D)
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


