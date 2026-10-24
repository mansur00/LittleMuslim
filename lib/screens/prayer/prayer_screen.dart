import '../../core/core.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../services/alert_sound_service.dart';
import '../../services/notification_service.dart';
import 'prayer_times.dart';

class _PrayerChapter {
  const _PrayerChapter(
      {required this.title,
      required this.subtitle,
      required this.rakat,
      required this.time,
      required this.note,
      required this.icon,
      required this.color,
      this.rule = 'prayer.default_rule',
      this.virtue = 'prayer.default_virtue',
      this.reference = ''});
  final String title, subtitle, rakat, time, note, rule, virtue, reference;
  final IconData icon;
  final Color color;
}

class PrayerScreen extends StatelessWidget {
  const PrayerScreen(
      {super.key, this.repository, this.settingsStore, this.locationProvider});
  final PrayerTimesRepository? repository;
  final PrayerSettingsStore? settingsStore;
  final PrayerDeviceLocationProvider? locationProvider;

  static List<_PrayerChapter> _getFardChapters(BuildContext context) {
    final defaultRule = context.t('prayer.chapter.default_rule');
    return [
      _PrayerChapter(
        title: context.t('prayer.fard.fajr.title'),
        subtitle: context.t('prayer.fard.fajr.subtitle'),
        rakat: context.t('prayer.fard.fajr.rakat'),
        time: context.t('prayer.fard.fajr.time'),
        note: context.t('prayer.fard.fajr.note'),
        virtue: context.t('prayer.fard.fajr.virtue'),
        reference: context.t('prayer.fard.fajr.reference'),
        rule: defaultRule,
        icon: Icons.wb_twilight_rounded,
        color: const Color(0xFF6D75BC),
      ),
      _PrayerChapter(
        title: context.t('prayer.fard.dhuhr.title'),
        subtitle: context.t('prayer.fard.dhuhr.subtitle'),
        rakat: context.t('prayer.fard.dhuhr.rakat'),
        time: context.t('prayer.fard.dhuhr.time'),
        note: context.t('prayer.fard.dhuhr.note'),
        virtue: context.t('prayer.fard.dhuhr.virtue'),
        reference: context.t('prayer.fard.dhuhr.reference'),
        rule: defaultRule,
        icon: Icons.wb_sunny_rounded,
        color: const Color(0xFFE39C4D),
      ),
      _PrayerChapter(
        title: context.t('prayer.fard.asr.title'),
        subtitle: context.t('prayer.fard.asr.subtitle'),
        rakat: context.t('prayer.fard.asr.rakat'),
        time: context.t('prayer.fard.asr.time'),
        note: context.t('prayer.fard.asr.note'),
        virtue: context.t('prayer.fard.asr.virtue'),
        reference: context.t('prayer.fard.asr.reference'),
        rule: defaultRule,
        icon: Icons.wb_sunny_rounded,
        color: const Color(0xFF54A8C8),
      ),
      _PrayerChapter(
        title: context.t('prayer.fard.maghrib.title'),
        subtitle: context.t('prayer.fard.maghrib.subtitle'),
        rakat: context.t('prayer.fard.maghrib.rakat'),
        time: context.t('prayer.fard.maghrib.time'),
        note: context.t('prayer.fard.maghrib.note'),
        virtue: context.t('prayer.fard.maghrib.virtue'),
        reference: context.t('prayer.fard.maghrib.reference'),
        rule: defaultRule,
        icon: Icons.wb_twilight_rounded,
        color: const Color(0xFFD97868),
      ),
      _PrayerChapter(
        title: context.t('prayer.fard.isha.title'),
        subtitle: context.t('prayer.fard.isha.subtitle'),
        rakat: context.t('prayer.fard.isha.rakat'),
        time: context.t('prayer.fard.isha.time'),
        note: context.t('prayer.fard.isha.note'),
        virtue: context.t('prayer.fard.isha.virtue'),
        reference: context.t('prayer.fard.isha.reference'),
        rule: defaultRule,
        icon: Icons.nights_stay_rounded,
        color: const Color(0xFF8D79C7),
      ),
    ];
  }

  static List<_PrayerChapter> _getOtherChapters(BuildContext context) {
    final defaultRule = context.t('prayer.chapter.default_rule');
    return [
      _PrayerChapter(
        title: context.t('prayer.other.sunnah.title'),
        subtitle: context.t('prayer.other.sunnah.subtitle'),
        rakat: context.t('prayer.other.sunnah.rakat'),
        time: context.t('prayer.other.sunnah.time'),
        note: context.t('prayer.other.sunnah.note'),
        virtue: context.t('prayer.other.sunnah.virtue'),
        reference: context.t('prayer.other.sunnah.reference'),
        rule: defaultRule,
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFFE8F8D8),
      ),
      _PrayerChapter(
        title: context.t('prayer.other.witr.title'),
        subtitle: context.t('prayer.other.witr.subtitle'),
        rakat: context.t('prayer.other.witr.rakat'),
        time: context.t('prayer.other.witr.time'),
        note: context.t('prayer.other.witr.note'),
        rule: context.t('prayer.other.witr.rule'),
        virtue: context.t('prayer.other.witr.virtue'),
        icon: Icons.star_rounded,
        color: const Color(0xFFFFF0C8),
      ),
      _PrayerChapter(
        title: context.t('prayer.other.tahajjud.title'),
        subtitle: context.t('prayer.other.tahajjud.subtitle'),
        rakat: context.t('prayer.other.tahajjud.rakat'),
        time: context.t('prayer.other.tahajjud.time'),
        note: context.t('prayer.other.tahajjud.note'),
        rule: context.t('prayer.other.tahajjud.rule'),
        virtue: context.t('prayer.other.tahajjud.virtue'),
        reference: context.t('prayer.other.tahajjud.reference'),
        icon: Icons.dark_mode_rounded,
        color: const Color(0xFFE8E2FF),
      ),
      _PrayerChapter(
        title: context.t('prayer.other.ishraq.title'),
        subtitle: context.t('prayer.other.ishraq.subtitle'),
        rakat: context.t('prayer.other.ishraq.rakat'),
        time: context.t('prayer.other.ishraq.time'),
        note: context.t('prayer.other.ishraq.note'),
        rule: context.t('prayer.other.ishraq.rule'),
        virtue: context.t('prayer.other.ishraq.virtue'),
        icon: Icons.wb_sunny_outlined,
        color: const Color(0xFFFFEBCF),
      ),
      _PrayerChapter(
        title: context.t('prayer.other.duha.title'),
        subtitle: context.t('prayer.other.duha.subtitle'),
        rakat: context.t('prayer.other.duha.rakat'),
        time: context.t('prayer.other.duha.time'),
        note: context.t('prayer.other.duha.note'),
        rule: context.t('prayer.other.duha.rule'),
        virtue: context.t('prayer.other.duha.virtue'),
        icon: Icons.light_mode_rounded,
        color: const Color(0xFFFFF6D0),
      ),
      _PrayerChapter(
        title: context.t('prayer.other.tarawih.title'),
        subtitle: context.t('prayer.other.tarawih.subtitle'),
        rakat: context.t('prayer.other.tarawih.rakat'),
        time: context.t('prayer.other.tarawih.time'),
        note: context.t('prayer.other.tarawih.note'),
        rule: context.t('prayer.other.tarawih.rule'),
        virtue: context.t('prayer.other.tarawih.virtue'),
        reference: context.t('prayer.other.tarawih.reference'),
        icon: Icons.nightlight_round,
        color: const Color(0xFFDCEBFF),
      ),
      _PrayerChapter(
        title: context.t('prayer.other.jumah.title'),
        subtitle: context.t('prayer.other.jumah.subtitle'),
        rakat: context.t('prayer.other.jumah.rakat'),
        time: context.t('prayer.other.jumah.time'),
        note: context.t('prayer.other.jumah.note'),
        rule: context.t('prayer.other.jumah.rule'),
        virtue: context.t('prayer.other.jumah.virtue'),
        reference: context.t('prayer.other.jumah.reference'),
        icon: Icons.groups_rounded,
        color: const Color(0xFFDDF4E9),
      ),
      _PrayerChapter(
        title: context.t('prayer.other.eid.title'),
        subtitle: context.t('prayer.other.eid.subtitle'),
        rakat: context.t('prayer.other.eid.rakat'),
        time: context.t('prayer.other.eid.time'),
        note: context.t('prayer.other.eid.note'),
        rule: context.t('prayer.other.eid.rule'),
        virtue: context.t('prayer.other.eid.virtue'),
        icon: Icons.celebration_rounded,
        color: const Color(0xFFFFE4E8),
      ),
      _PrayerChapter(
        title: context.t('prayer.other.janazah.title'),
        subtitle: context.t('prayer.other.janazah.subtitle'),
        rakat: context.t('prayer.other.janazah.rakat'),
        time: context.t('prayer.other.janazah.time'),
        note: context.t('prayer.other.janazah.note'),
        rule: context.t('prayer.other.janazah.rule'),
        virtue: context.t('prayer.other.janazah.virtue'),
        reference: context.t('prayer.other.janazah.reference'),
        icon: Icons.volunteer_activism_rounded,
        color: const Color(0xFFE0F1FF),
      ),
    ];
  }

  static List<(String, String, IconData)> _getPrayers(BuildContext context) => [
    (context.t('prayer.fajr'), 'الفجر', Icons.wb_twilight_rounded),
    (context.t('prayer.dhuhr'), 'الظهر', Icons.wb_sunny_rounded),
    (context.t('prayer.asr'), 'العصر', Icons.wb_sunny_rounded),
    (context.t('prayer.maghrib'), 'المغرب', Icons.wb_twilight_rounded),
    (context.t('prayer.isha'), 'العشاء', Icons.nights_stay_rounded),
  ];

  static List<(String, String, String, IconData, Color)> _getSteps(BuildContext context) => [
    (
      context.formatDigits('1'),
      context.t('prayer.step.1.title'),
      context.t('prayer.step.1.detail'),
      Icons.water_drop_rounded,
      const Color(0xFF54A8C8)
    ),
    (
      context.formatDigits('2'),
      context.t('prayer.step.2.title'),
      context.t('prayer.step.2.detail'),
      Icons.accessibility_new_rounded,
      const Color(0xFF8D79C7)
    ),
    (
      context.formatDigits('3'),
      context.t('prayer.step.3.title'),
      context.t('prayer.step.3.detail'),
      Icons.menu_book_rounded,
      const Color(0xFF58A976)
    ),
    (
      context.formatDigits('4'),
      context.t('prayer.step.4.title'),
      context.t('prayer.step.4.detail'),
      Icons.self_improvement_rounded,
      const Color(0xFFE39C4D)
    ),
    (
      context.formatDigits('5'),
      context.t('prayer.step.5.title'),
      context.t('prayer.step.5.detail'),
      Icons.waving_hand_rounded,
      const Color(0xFFD97868)
    ),
  ];

  static List<(String, String)> _getGuideDetails(BuildContext context) => [
    (
      context.t('prayer.guide.1.title'),
      context.t('prayer.guide.1.desc'),
    ),
    (
      context.t('prayer.guide.2.title'),
      context.t('prayer.guide.2.desc'),
    ),
    (
      context.t('prayer.guide.3.title'),
      context.t('prayer.guide.3.desc'),
    ),
    (
      context.t('prayer.guide.4.title'),
      context.t('prayer.guide.4.desc'),
    ),
    (
      context.t('prayer.guide.5.title'),
      context.t('prayer.guide.5.desc'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final appState = context.watch<AppState>();
    final salahCompleted = appState.isSalahCompleted;
    final salahStep = appState.salahStep;
    final steps = _getSteps(context);
    final fardChapters = _getFardChapters(context);
    final otherChapters = _getOtherChapters(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF4FF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      tablet ? 36 : 20, 16, tablet ? 36 : 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      DuolingoPageHeader(
                        title: context.t('prayer.learn_title'),
                        subtitle: context.t('prayer.learn_subtitle'),
                        customIcon: Image.asset(
                          'assets/images/badge_prayer_3d.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                        gradientColors: const [
                          Color(0xFF5B86E5),
                          Color(0xFF36D1DC)
                        ],
                        onBack: () => Navigator.pop(context),
                      ),
                      _PrayerTimesCard(
                          repository: repository,
                          settingsStore: settingsStore,
                          locationProvider: locationProvider),
                      const SizedBox(height: 22),
                      _PrayerChapterGroup(
                        number: context.formatDigits('1'),
                        title: context.t('prayer.group.1.title'),
                        subtitle: context.t('prayer.group.1.subtitle'),
                        icon: Icons.self_improvement_rounded,
                        color: const Color(0xFFE8E2FF),
                        initiallyExpanded: true,
                        children: [
                          _SalahProgressCard(
                            isCompleted: salahCompleted,
                            currentStep: salahStep,
                            onStart: () => _showStep(
                                context, salahCompleted ? 0 : salahStep),
                          ),
                          const SizedBox(height: 14),
                          LayoutBuilder(builder: (context, constraints) {
                            if (constraints.maxWidth < 640) {
                              return Column(children: [
                                for (final step in steps)
                                  _StepCard(
                                      number: step.$1,
                                      title: step.$2,
                                      detail: step.$3,
                                      icon: step.$4,
                                      color: step.$5,
                                      onTap: () => _showStep(
                                          context, steps.indexOf(step)))
                              ]);
                            }
                            return GridView.count(
                              crossAxisCount:
                                  constraints.maxWidth > 850 ? 3 : 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.55,
                              children: [
                                for (final step in steps)
                                  _StepCard(
                                      number: step.$1,
                                      title: step.$2,
                                      detail: step.$3,
                                      icon: step.$4,
                                      color: step.$5,
                                      onTap: () => _showStep(
                                          context, steps.indexOf(step)))
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _PrayerChapterGroup(
                        number: context.formatDigits('2'),
                        title: context.t('prayer.group.2.title'),
                        subtitle: context.t('prayer.group.2.subtitle'),
                        icon: Icons.wb_twilight_rounded,
                        color: const Color(0xFFDDF4E9),
                        children: [
                          for (final chapter in fardChapters)
                            _PrayerChapterTile(chapter: chapter),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _PrayerChapterGroup(
                        number: context.formatDigits('3'),
                        title: context.t('prayer.group.3.title'),
                        subtitle: context.t('prayer.group.3.subtitle'),
                        icon: Icons.nightlight_round,
                        color: const Color(0xFFFFEBCF),
                        children: [
                          for (final chapter in otherChapters)
                            _PrayerChapterTile(chapter: chapter),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStep(BuildContext context, int startIndex) {
    final appState = context.read<AppState>();
    final steps = _getSteps(context);
    final guideDetails = _getGuideDetails(context);
    var activeIndex = startIndex.clamp(0, steps.length - 1);
    appState.saveSalahStep(activeIndex);

    Future<bool> confirmExitMidway(BuildContext sheetContext) async {
      if (activeIndex == 0 ||
          activeIndex >= steps.length - 1 ||
          appState.isSalahCompleted) {
        return true;
      }
      final shouldExit = await showDialog<bool>(
        context: sheetContext,
        builder: (dialogCtx) => AlertDialog(
          title: LocalizedText(dialogCtx.t('prayer.dialog.exit_title')),
          content: LocalizedText(dialogCtx.t('prayer.dialog.exit_desc',
              params: {'step': '${activeIndex + 1}'})),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, false),
              child: LocalizedText(dialogCtx.t('prayer.dialog.btn_keep_reading')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogCtx, true),
              child: LocalizedText(dialogCtx.t('prayer.dialog.btn_exit')),
            ),
          ],
        ),
      );
      return shouldExit ?? false;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) =>
          StatefulBuilder(builder: (context, setSheetState) {
        final step = steps[activeIndex];
        final detail = guideDetails[activeIndex];
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final canLeave = await confirmExitMidway(sheetContext);
            if (canLeave && sheetContext.mounted) {
              Navigator.pop(sheetContext);
            }
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
            decoration: BoxDecoration(
              color: AppTheme.cream,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border.all(
                color: AppTheme.primaryGreen.withValues(alpha: .16),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: .22),
                  blurRadius: 0,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8))),
                const SizedBox(height: 14),
                // Educational guidance banner
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school_rounded,
                          size: 16, color: AppTheme.primaryGreen),
                      const SizedBox(width: 6),
                      LocalizedText(
                        context.t('prayer.sheet.edu_banner'),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (var i = 0; i < steps.length; i++)
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: i == activeIndex ? 28 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                            color: i == activeIndex
                                ? AppTheme.primaryGreen
                                : const Color(0xFFD9E4D5),
                            borderRadius: BorderRadius.circular(8))),
                ]),
                const SizedBox(height: 16),
                Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                        color: step.$5.withValues(alpha: .14),
                        borderRadius: BorderRadius.circular(24)),
                    child: Icon(step.$4, size: 38, color: step.$5)),
                const SizedBox(height: 13),
                LocalizedText(
                    context.t('prayer.sheet.step_header',
                        params: {'step': '${activeIndex + 1}', 'title': step.$2}),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppTheme.darkText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                LocalizedText(detail.$1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppTheme.primaryGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 9),
                LocalizedText(detail.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54, height: 1.55)),
                const SizedBox(height: 15),
                Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFF2CE),
                        borderRadius: BorderRadius.circular(15)),
                    child: LocalizedText(
                        context.t('prayer.sheet.madhab_note'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xFF735B24),
                            fontSize: 11,
                            height: 1.5))),
                const SizedBox(height: 17),
                Row(children: [
                  if (activeIndex > 0)
                    Expanded(
                        child: DSButton(
                            onPressed: () {
                              setSheetState(() => activeIndex--);
                              appState.saveSalahStep(activeIndex);
                            },
                            icon: Icons.arrow_back_rounded,
                            variant: DSButtonVariant.outline,
                            label: context.t('prayer.btn_prev_step')))
                  else
                    const Spacer(),
                  const SizedBox(width: 10),
                  Expanded(
                      child: DSButton(
                          onPressed: () async {
                            if (activeIndex < steps.length - 1) {
                              setSheetState(() => activeIndex++);
                              await appState.saveSalahStep(activeIndex);
                            } else {
                              final earned =
                                  await appState.completeSalahLesson();
                              if (!sheetContext.mounted) return;
                              Navigator.pop(sheetContext);
                              if (!context.mounted) return;
                              showDialog<void>(
                                context: context,
                                builder: (dialogCtx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  title: Row(children: [
                                    const Icon(Icons.celebration_rounded,
                                        color: AppTheme.primaryGreen, size: 28),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: LocalizedText(
                                            dialogCtx.t('prayer.dialog.completed_title'))),
                                  ]),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      LocalizedText(
                                        earned
                                            ? dialogCtx.t('prayer.dialog.completed_earned')
                                            : dialogCtx.t('prayer.dialog.completed_revisit'),
                                        style: const TextStyle(height: 1.5),
                                      ),
                                      const SizedBox(height: 10),
                                      LocalizedText(
                                        dialogCtx.t('prayer.dialog.completed_hint'),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            height: 1.4),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await appState.resetSalahProgress();
                                        if (dialogCtx.mounted) {
                                          Navigator.pop(dialogCtx);
                                        }
                                        if (context.mounted) {
                                          _showStep(context, 0);
                                        }
                                      },
                                      child: LocalizedText(
                                          dialogCtx.t('prayer.dialog.btn_revision')),
                                    ),
                                    FilledButton(
                                      onPressed: () => Navigator.pop(dialogCtx),
                                      style: FilledButton.styleFrom(
                                          backgroundColor:
                                              AppTheme.primaryGreen),
                                      child: LocalizedText(
                                          dialogCtx.t('prayer.dialog.btn_done')),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          icon: Icon(activeIndex < steps.length - 1
                              ? Icons.arrow_forward_rounded
                              : Icons.check_rounded),
                          label: activeIndex < steps.length - 1
                              ? context.t('prayer.btn_next_step')
                              : context.t('prayer.btn_finish_lesson'))),
                ]),
              ]),
            ),
          ),
        );
      }),
    );
  }
}

class _SalahProgressCard extends StatelessWidget {
  const _SalahProgressCard({
    required this.isCompleted,
    required this.currentStep,
    required this.onStart,
  });

  final bool isCompleted;
  final int currentStep;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isCompleted
                  ? AppTheme.primaryGreen.withValues(alpha: 0.3)
                  : const Color(0xFFE5E7EB),
              width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFFDDF4E9)
                    : const Color(0xFFE8E2FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.self_improvement_rounded,
                color: isCompleted
                    ? AppTheme.primaryGreen
                    : const Color(0xFF8D79C7),
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFFDDF4E9)
                              : const Color(0xFFFFF0DB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: LocalizedText(
                          isCompleted
                              ? context.t('prayer.progress.completed_badge')
                              : (currentStep > 0
                                  ? context.t('prayer.progress.step_in_progress',
                                      params: {'step': '${currentStep + 1}'})
                                  : context.t('prayer.progress.new_lesson')),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isCompleted
                                ? AppTheme.primaryGreen
                                : const Color(0xFFE8913A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LocalizedText(
                    isCompleted
                        ? context.t('prayer.progress.completed_desc')
                        : (currentStep > 0
                            ? context.t('prayer.progress.continue_desc',
                                params: {'step': '${currentStep + 1}'})
                            : context.t('prayer.progress.start_desc')),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: onStart,
              style: FilledButton.styleFrom(
                backgroundColor: isCompleted
                    ? const Color(0xFFDDF4E9)
                    : AppTheme.primaryGreen,
                foregroundColor:
                    isCompleted ? AppTheme.primaryGreen : Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              child: LocalizedText(
                isCompleted
                    ? context.t('prayer.progress.btn_review')
                    : (currentStep > 0
                        ? context.t('prayer.progress.btn_continue')
                        : context.t('prayer.progress.btn_start')),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      );
}

class _PrayerTimesCard extends StatefulWidget {
  const _PrayerTimesCard(
      {this.repository, this.settingsStore, this.locationProvider});
  final PrayerTimesRepository? repository;
  final PrayerSettingsStore? settingsStore;
  final PrayerDeviceLocationProvider? locationProvider;
  @override
  State<_PrayerTimesCard> createState() => _PrayerTimesCardState();
}

class _PrayerTimesCardState extends State<_PrayerTimesCard>
    with WidgetsBindingObserver {
  late final PrayerTimesRepository _repository =
      widget.repository ?? AlAdhanPrayerTimesRepository();
  late final PrayerSettingsStore _store =
      widget.settingsStore ?? SharedPreferencesPrayerSettingsStore();
  late final PrayerDeviceLocationProvider _location =
      widget.locationProvider ?? GeolocatorPrayerDeviceLocationProvider();
  PrayerCalculationSettings _settings = const PrayerCalculationSettings();
  PrayerTimesResult? _result;
  DateTime _date = PrayerDateTools.today();
  bool _todayMode = true, _loading = false, _ready = false;
  String? _error;
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cityController.dispose();
    _countryController.dispose();
    if (widget.repository == null &&
        _repository is AlAdhanPrayerTimesRepository) {
      _repository.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _todayMode &&
        _settings.location != null) {
      _load();
    }
  }

  Future<void> _initialize() async {
    final saved = await _store.load();
    if (!mounted) return;
    setState(() {
      _settings = saved;
      _ready = true;
    });
    if (saved.location != null) {
      _date = PrayerDateTools.today(timeZoneId: saved.location!.timeZoneId);
      await _load();
    }
  }

  Future<void> _load() async {
    final location = _settings.location;
    if (location == null) return;
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      var result = await _repository.calculate(
          location: location,
          date: _date,
          methodId: _settings.methodId,
          asrSchool: _settings.asrSchool);
      final updatedLocation = location.withTimeZone(result.timeZoneId);
      if (_todayMode &&
          !PrayerDateTools.sameDate(
              _date, PrayerDateTools.today(timeZoneId: result.timeZoneId))) {
        _date = PrayerDateTools.today(timeZoneId: result.timeZoneId);
        result = await _repository.calculate(
            location: updatedLocation,
            date: _date,
            methodId: _settings.methodId,
            asrSchool: _settings.asrSchool);
      }
      final updatedSettings = _settings.copyWith(location: updatedLocation);
      await _store.save(updatedSettings);
      if (mounted) {
        setState(() {
          _settings = updatedSettings;
          _result = result;
          _loading = false;
        });
        _schedulePrayerAlerts(result);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'prayer.err_load';
        });
      }
    }
  }

  Future<void> _saveSettings(PrayerCalculationSettings next) async {
    await _store.save(next);
    if (!mounted) return;
    setState(() {
      _settings = next;
      _date = _todayMode
          ? PrayerDateTools.today(timeZoneId: next.location?.timeZoneId)
          : _date;
    });
    if (next.location != null) await _load();
  }

  void _schedulePrayerAlerts(PrayerTimesResult result) {
    if (!mounted) return;
    final state = context.read<AppState>();
    if (!state.prayerAlertsEnabled) return;
    const prayers = [
      (0, 'Fajr', 'الفجر'),
      (1, 'Dhuhr', 'الظهر'),
      (2, 'Asr', 'العصر'),
      (3, 'Maghrib', 'المغرب'),
      (4, 'Isha', 'العشاء'),
    ];
    for (final p in prayers) {
      final time = result.times[p.$2];
      if (time != null && state.isPrayerAlertEnabled(p.$2)) {
        NotificationService.instance.schedulePrayerAlert(
          prayerIndex: p.$1,
          prayerTime: time,
          prayerName: p.$2,
          arabicName: p.$3,
        );
      } else {
        NotificationService.instance.cancelPrayerAlert(p.$1);
      }
    }
  }

  Future<void> _useDeviceLocation() async {
    final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(context.t('prayer.use_location_title')),
              content: Text(context.t('prayer.use_location_content')),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(context.t('common.cancel'))),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(context.t('common.continue_btn')))
              ],
            ));
    if (accepted != true || !mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final position = await _location.currentCoordinates();
      final next = _settings.copyWith(
          location: PrayerLocationSelection.device(
              latitude: position.latitude, longitude: position.longitude));
      await _saveSettings(next);
    } on DeviceLocationException catch (error) {
      final message = switch (error.failure) {
        DeviceLocationFailure.serviceDisabled =>
          'prayer.err_service_disabled',
        DeviceLocationFailure.denied =>
          'prayer.err_permission_denied',
        DeviceLocationFailure.deniedForever =>
          'prayer.err_permission_blocked',
        DeviceLocationFailure.unavailable =>
          'prayer.err_unavailable',
      };
      if (mounted) {
        setState(() {
          _loading = false;
          _error = message;
        });
      }
    }
  }

  Future<void> _enterCity() async {
    _cityController.text = _settings.location?.city ?? '';
    _countryController.text = _settings.location?.country ?? '';
    final values = await showDialog<(String, String)>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(context.t('prayer.enter_city_title')),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                    controller: _cityController,
                    decoration:
                        InputDecoration(labelText: context.t('prayer.city_label'))),
                TextField(
                    controller: _countryController,
                    decoration:
                        InputDecoration(labelText: context.t('prayer.country_label')))
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.t('common.cancel'))),
                FilledButton(
                    onPressed: () {
                      if (_cityController.text.trim().isNotEmpty &&
                          _countryController.text.trim().isNotEmpty) {
                        Navigator.pop(context, (
                          _cityController.text.trim(),
                          _countryController.text.trim()
                        ));
                      }
                    },
                    child: Text(context.t('common.save')))
              ],
            ));
    if (values == null || !mounted) return;
    _todayMode = true;
    _date = PrayerDateTools.today();
    await _saveSettings(_settings.copyWith(
        location:
            PrayerLocationSelection.city(city: values.$1, country: values.$2)));
  }

  String _methodLabel(int id) => context.t('prayer.method.$id');
  Future<void> _settingsDialog() async {
    var method = _settings.methodId, school = _settings.asrSchool;
    await showDialog<void>(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, update) => AlertDialog(
                  title: Text(context.t('prayer.calculation_settings')),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    DropdownButtonFormField<int>(
                        initialValue: method,
                        isExpanded: true,
                        decoration: InputDecoration(
                            labelText: context.t('prayer.calculation_method')),
                        items: supportedPrayerMethodIds
                            .map((id) => DropdownMenuItem(
                                value: id,
                                child: Text(_methodLabel(id),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) update(() => method = v);
                        }),
                    DropdownButtonFormField<int>(
                        initialValue: school,
                        decoration: InputDecoration(
                            labelText: context.t('prayer.asr_method')),
                        items: [
                          DropdownMenuItem(
                              value: 0,
                              child: Text(context.t('prayer.standard_shafi'))),
                          DropdownMenuItem(
                              value: 1, child: Text(context.t('prayer.hanafi')))
                        ],
                        onChanged: (v) {
                          if (v != null) update(() => school = v);
                        })
                  ]),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(context.t('common.cancel'))),
                    FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _saveSettings(_settings.copyWith(
                              methodId: method, asrSchool: school));
                        },
                        child: Text(context.t('common.save')))
                  ],
                )));
  }

  Future<void> _changeDate(int amount) async {
    final next = _date.add(Duration(days: amount));
    setState(() {
      _todayMode = PrayerDateTools.sameDate(next,
          PrayerDateTools.today(timeZoneId: _settings.location?.timeZoneId));
      _date = next;
    });
    await _load();
  }

  @override
  Widget build(BuildContext context) => DuolingoCard(
      accentColor: AppTheme.primaryGreen,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(17),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: const Color(0xFFE7F2E6),
                  borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.location_on_rounded,
                  color: AppTheme.primaryGreen)),
          const SizedBox(width: 11),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(context.t('prayer.title'),
                    style: const TextStyle(
                        color: AppTheme.darkText,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
                Text(
                    _settings.location == null
                        ? context.t('prayer.choose_location')
                        : _settings.location!.kind == PrayerLocationKind.device
                            ? context.t('prayer.device_location_coords', params: {
                                'lat': _settings.location!.latitude!.toStringAsFixed(3),
                                'lng': _settings.location!.longitude!.toStringAsFixed(3),
                              })
                            : context.uiText(_settings.location!.displayName),
                    style: const TextStyle(color: Colors.black54, fontSize: 11))
              ])),
          IconButton(
              tooltip: context.t('prayer.calculation_settings'),
              onPressed: _settingsDialog,
              icon: const Icon(Icons.tune_rounded))
        ]),
        Wrap(spacing: 4, children: [
          TextButton.icon(
              onPressed: _useDeviceLocation,
              icon: const Icon(Icons.my_location),
              label: Text(context.t('prayer.use_device_location'))),
          TextButton.icon(
              onPressed: _enterCity,
              icon: const Icon(Icons.location_city),
              label: Text(context.t('prayer.enter_city_btn')))
        ]),
        if (_settings.location != null) ...[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: () => _changeDate(-1),
                icon: const Icon(Icons.chevron_left)),
            Text(context.formatDate(_date, format: AppDateFormat.medium)),
            IconButton(
                onPressed: () => _changeDate(1),
                icon: const Icon(Icons.chevron_right)),
            TextButton(
                onPressed: () {
                  _todayMode = true;
                  _date = PrayerDateTools.today(
                      timeZoneId: _settings.location?.timeZoneId);
                  _load();
                },
                child: Text(context.t('prayer.today')))
          ]),
          Text(
              '${context.t('prayer.method_prefix')}: ${_methodLabel(_settings.methodId)} · ${_settings.asrSchool == 1 ? context.t('prayer.hanafi') : context.t('prayer.standard_shafi')}',
              style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ],
        const Divider(),
        if (_loading || !_ready)
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator()))
        else if (_error != null)
          Column(children: [
            Text(context.t(_error!), textAlign: TextAlign.center),
            TextButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: Text(context.t('prayer.retry'))),
            if (_error! == 'prayer.err_permission_blocked')
              TextButton(
                  onPressed: _location.openAppSettings,
                  child: Text(context.t('prayer.open_settings')))
          ])
        else if (_settings.location == null)
          Text(
              context.t('prayer.empty_location_desc'),
              style: const TextStyle(color: Colors.black54))
        else if (_result != null) ...[
          // Test Adhan Banner & Play/Stop
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF86EFAC)),
            ),
            child: Row(
              children: [
                ValueListenableBuilder<AlertSoundType?>(
                  valueListenable: AlertSoundService.instance.currentPlayingNotifier,
                  builder: (context, playingType, _) {
                    final isPlaying = playingType == AlertSoundType.adhan;
                    return InkWell(
                      onTap: () => AlertSoundService.instance.playAdhan(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isPlaying ? const Color(0xFFDC2626) : AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: (isPlaying ? const Color(0xFFDC2626) : AppTheme.primaryGreen).withValues(alpha: 0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              context.t(isPlaying ? 'prayer.stop_adhan' : 'prayer.play_adhan'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.t('prayer.adhan_banner_desc'),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF166534),
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final prayer in PrayerScreen._getPrayers(context))
              _PrayerTimeChip(
                  name: prayer.$1,
                  arabic: prayer.$2,
                  icon: prayer.$3,
                  times: _result!.times)
          ]),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.wb_sunny_outlined,
                size: 18, color: AppTheme.secondaryGold),
            const SizedBox(width: 6),
            Text(
                '${context.t('prayer.sunrise_ref')}: ' +
                _formatPrayerTime(_result!.times['Sunrise'], context))
          ]),
          if (_result!.isCached) ...[
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.offline_pin_rounded,
                  size: 16, color: Color(0xFFE39C4D)),
              const SizedBox(width: 6),
              Text(
                context.t('prayer.cached_offline'),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE39C4D)),
              ),
            ]),
          ],
        ],
      ]));
}

String _formatPrayerTime(DateTime? time, [BuildContext? context]) =>
    AppFormatters.formatPrayerTime(
      time,
      locale: context != null ? context.currentLanguageCode : null,
    );

class _PrayerTimeChip extends StatelessWidget {
  const _PrayerTimeChip(
      {required this.name,
      required this.arabic,
      required this.icon,
      this.times = const {}});
  final String name, arabic;
  final IconData icon;
  final Map<String, DateTime> times;
  String get _key => name;
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isAlertOn = appState.isPrayerAlertEnabled(_key);
    final isUpcoming = times[_key] != null && times[_key]!.isAfter(DateTime.now());

    return Container(
        width: 112,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: isAlertOn ? const Color(0xFFF7FBF6) : const Color(0xFFF7F7F1),
            border: isAlertOn
                ? Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.35), width: 1.2)
                : Border.all(color: Colors.black.withValues(alpha: 0.05)),
            borderRadius: BorderRadius.circular(15)),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: AppTheme.secondaryGold),
              InkWell(
                onTap: () {
                  context.read<AppState>().updatePrayerAlertSettings(
                        prayerKey: _key,
                        prayerEnabled: !isAlertOn,
                      );
                },
                borderRadius: BorderRadius.circular(12),
                child: Tooltip(
                  message: context.t(isAlertOn ? 'prayer.alert_disable' : 'prayer.alert_enable'),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      isAlertOn
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_off_rounded,
                      size: 16,
                      color: isAlertOn
                          ? AppTheme.primaryGreen
                          : Colors.black26,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          LocalizedText(name,
              style: const TextStyle(
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.w800,
                  fontSize: 12)),
          LocalizedText(arabic,
              textDirection: TextDirection.rtl,
              style:
                  const TextStyle(color: AppTheme.primaryGreen, fontSize: 11)),
          const SizedBox(height: 4),
          Text(
              AppFormatters.formatPrayerTime(times[_key],
                  locale: context.currentLanguageCode),
              style: TextStyle(
                  color: isUpcoming ? AppTheme.primaryGreen : Colors.black45,
                  fontWeight: FontWeight.w800,
                  fontSize: 13))
        ]),
      );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard(
      {required this.number,
      required this.title,
      required this.detail,
      required this.icon,
      required this.color,
      required this.onTap});
  final String number, title, detail;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
                padding: const EdgeInsets.all(13),
                child: Row(children: [
                  Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: color.withValues(alpha: .13),
                          borderRadius: BorderRadius.circular(14)),
                      child: Icon(icon, color: color, size: 22)),
                  const SizedBox(width: 12),
                  Container(
                      width: 23,
                      height: 23,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFF2CE),
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: LocalizedText(number,
                          style: const TextStyle(
                              color: Color(0xFFA57910),
                              fontSize: 10,
                              fontWeight: FontWeight.w800))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        LocalizedText(title,
                            style: const TextStyle(
                                color: AppTheme.darkText,
                                fontWeight: FontWeight.w800,
                                fontSize: 13)),
                        const SizedBox(height: 3),
                        LocalizedText(detail,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 10))
                      ])),
                  const Icon(Icons.chevron_right_rounded,
                      color: Colors.black38),
                ])),
          ),
        ),
      );
}

class _PrayerChapterGroup extends StatelessWidget {
  const _PrayerChapterGroup({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.children,
    this.initiallyExpanded = false,
  });
  final String number, title, subtitle;
  final IconData icon;
  final Color color;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: initiallyExpanded,
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            leading: CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: AppTheme.primaryGreen),
            ),
            title: LocalizedText(title,
                style: const TextStyle(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w900,
                    fontSize: 15)),
            subtitle: LocalizedText('$number · $subtitle',
                style: const TextStyle(color: Colors.black54, fontSize: 11)),
            children: children,
          ),
        ),
      );
}

class _PrayerChapterTile extends StatelessWidget {
  const _PrayerChapterTile({required this.chapter});
  final _PrayerChapter chapter;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 9),
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: chapter.color.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(14)),
              child: Icon(chapter.icon, color: chapter.color, size: 23),
            ),
            title: LocalizedText(chapter.title,
                style: const TextStyle(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w900,
                    fontSize: 15)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: LocalizedText(chapter.rakat,
                  style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 11,
                      height: 1.4,
                      fontWeight: FontWeight.w700)),
            ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: chapter.color.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.t('prayer.detail.waqt'),
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      LocalizedText(chapter.time,
                          style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 13,
                              height: 1.5,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 9),
                      Text(context.t('prayer.detail.how_to_pray'),
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      LocalizedText(chapter.rule,
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              height: 1.6)),
                      const SizedBox(height: 9),
                      Text(context.t('prayer.detail.time_and_rules'),
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      LocalizedText(chapter.note,
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              height: 1.6)),
                      const SizedBox(height: 10),
                      Text(context.t('prayer.detail.virtue'),
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      LocalizedText(chapter.virtue,
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              height: 1.6)),
                      if (chapter.reference.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                            context.t('prayer.detail.source',
                                params: {'reference': chapter.reference}),
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ],
                    ]),
              ),
            ],
          ),
        ),
      );
}
