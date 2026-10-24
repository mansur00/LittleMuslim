import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/duolingo_button.dart';
import '../qaida/qaida_lesson_screen.dart';
import '../qaida/qaida_letters.dart';

class DailyMissionsScreen extends StatelessWidget {
  const DailyMissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final (done, missionLessonId) = context.select<AppState, (bool, String)>(
        (state) =>
            (state.todayQaidaLessons > 0, state.todayQaidaMissionLessonId));
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(tablet ? 32 : 18),
              children: [
                // ── Duolingo Header ──
                DuolingoPageHeader(
                  title: context.t('daily_mission.title'),
                  subtitle: context.t('daily_mission.subtitle'),
                  iconType: VectorIconType.target,
                  gradientColors: const [Color(0xFFFF9600), Color(0xFFFF6B00)],
                  onBack: () => Navigator.pop(context),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      done
                          ? context.t('status.completed')
                          : context.t('daily_mission.in_progress'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12),
                    ),
                  ),
                ),

                // ── Progress card ──
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: const Color(0xFFFF9600).withValues(alpha: 0.3),
                        width: 2),
                    boxShadow: [
                      BoxShadow(
                          color:
                              const Color(0xFFFF9600).withValues(alpha: 0.15),
                          blurRadius: 0,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Real3DTopBarIcon(
                            type: Real3DTopType.flame,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              done
                                  ? context.t('daily_mission.target_achieved')
                                  : context.t('daily_mission.finish_new_lesson'),
                              style: TextStyle(
                                  color: done
                                      ? const Color(0xFF58A700)
                                      : AppTheme.darkText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            value: done ? 1 : 0,
                            minHeight: 14,
                            backgroundColor: const Color(0xFFE5E7EB),
                            color: const Color(0xFF58CC02),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          done
                              ? context.t('daily_mission.progress_completed')
                              : context.t('daily_mission.progress_zero'),
                          style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ]),
                ),

                DuolingoSectionLabel(
                    label: context.t('daily_mission.today_task'),
                    badgeText: done
                        ? context.t('status.completed')
                        : context.t('daily_mission.remaining'),
                    badgeColor: done
                        ? const Color(0xFFE8F8D8)
                        : const Color(0xFFFFF3CD),
                    badgeTextColor: done
                        ? const Color(0xFF58A700)
                        : const Color(0xFFCC8800)),
                const SizedBox(height: 12),

                // ── Mission task card ──
                DuolingoCard(
                  accentColor: const Color(0xFF58CC02),
                  showAccentStripe: true,
                  child: Row(children: [
                    DSGamifyBadge(
                      emblem: done ? BadgeEmblem.check : BadgeEmblem.star,
                      primaryColor: done
                          ? const Color(0xFF10B981)
                          : const Color(0xFF3B82F6),
                      bevelColor: done
                          ? const Color(0xFF047857)
                          : const Color(0xFF1D4ED8),
                      ribbonText: done
                          ? context.t('status.completed')
                          : context.t('daily_mission.daily_badge'),
                      size: 58,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.t('daily_mission.one_qaida_lesson'),
                                style: const TextStyle(
                                    color: AppTheme.darkText,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text(context.t('daily_mission.complete_10_xp'),
                                style: const TextStyle(
                                    color: Color(0xFF58A700),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ]),
                    ),
                    if (done)
                      const VectorIcon(
                          type: VectorIconType.check,
                          size: 32,
                          color: Color(0xFF58CC02))
                    else
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFD0D0D0), width: 3)),
                      ),
                  ]),
                ),

                if (!done) ...[
                  const SizedBox(height: 20),
                  Duolingo3DButton(
                    text: context.t('daily_mission.start_mission'),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => QaidaLessonScreen(
                          lessonId: missionLessonId,
                          lessonTitle:
                              context.t('daily_mission.today_alif_lesson'),
                          letter: 'ا',
                          letterName: context.t('daily_mission.alif_letter'),
                          makhrajNote: qaidaLetters.first.makhraj,
                          options: const ['ب', 'ا', 'ت'],
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 24),
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F8D8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF58A700).withValues(alpha: 0.3),
                          width: 2),
                    ),
                    child: Row(children: [
                      const VectorIcon(
                          type: VectorIconType.star,
                          size: 28,
                          color: Color(0xFFFFC800)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          context.t('daily_mission.goal_achieved_cheer'),
                          style: const TextStyle(
                              color: Color(0xFF2D7A00),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 1.4),
                        ),
                      ),
                    ]),
                  ),
                ],

                const SizedBox(height: 20),
                Text(
                  context.t('daily_mission.device_storage_notice'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.darkText.withValues(alpha: 0.45),
                      fontSize: 11,
                      height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
