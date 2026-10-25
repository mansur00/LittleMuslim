import '../../core/core.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/faceless_silhouette.dart';
import '../../widgets/ds/ds.dart';

import '../../data/qaida_curriculum_data.dart';
import '../../data/nurani_qaida_data.dart';
import '../qaida/qaida_chapters_screen.dart';
import '../qaida/qaida_activity_screen.dart';
import '../prayer/prayer_screen.dart';
import '../quran/quran_screen.dart';
import '../duas/duas_screen.dart';
import '../seerah/seerah_screen.dart';
import '../achievements/achievements_screen.dart';
import '../missions/daily_missions_screen.dart';
import '../basics/islam_basics_screen.dart';
import '../live_learning/live_learning_screen.dart';
import '../settings/settings_screen.dart';
import '../qaida/qaida_revision_screen.dart';
import '../qaida/qaida_report_screen.dart';
import '../../services/alert_sound_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(showWordmark: true),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Main content area based on selected tab
            Expanded(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  _HomePathTab(
                    isTablet: isTablet,
                    isActive: _currentTabIndex == 0,
                  ),
                  _HomeContinueTab(isTablet: isTablet),
                  const DailyMissionsScreen(),
                  const AchievementsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _DuolingoBottomNavBar(
        currentIndex: _currentTabIndex,
        isTablet: isTablet,
        onTap: (index) => setState(() => _currentTabIndex = index),
      ),
    );
  }
}


/// The Main Learning Path tab (Duolingo-style roadmap & interactive journey)
class _HomePathTab extends StatelessWidget {
  const _HomePathTab({required this.isTablet, required this.isActive});
  final bool isTablet;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final todayQaidaLessons =
        context.select<AppState, int>((state) => state.todayQaidaLessons);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.fromLTRB(
              isTablet ? 36 : 18,
              AppSpacing.sm,
              isTablet ? 36 : 18,
              AppSpacing.none,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.only(bottom: AppSpacing.md, top: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t('home.greeting'),
                        style: AppTextStyles.caption(context),
                      ),
                      AppSpacing.gapHXs,
                      Text(
                        context.select<AppState, String>((s) => s.userName.isNotEmpty ? s.userName : context.t('common.friend')),
                        style: AppTextStyles.title(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (context.select<AppState, bool>((s) => s.isAdmin)) ...[
                  Container(
                    margin: AppSpacing.only(bottom: AppSpacing.md),
                    padding: AppSpacing.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.amber100,
                      borderRadius: AppRadius.borderLg,
                      border: AppBorders.custom(color: AppColors.amber500, width: AppStroke.regular),
                      boxShadow: AppElevation.shadow(color: AppColors.black06),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.admin_panel_settings_rounded,
                            color: AppColors.amber600, size: AppSizes.iconMd),
                        AppSpacing.gapWSm,
                        Expanded(
                          child: LocalizedText(
                            context.t('home.admin_mode_notice'),
                            style: AppTextStyles.adminBanner(context),
                          ),
                        ),
                        InkWell(
                          onTap: () => context.read<AppState>().setUserRole('child'),
                          borderRadius: AppRadius.borderSm,
                          child: Container(
                            padding: AppSpacing.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: AppRadius.borderSm,
                              border: AppBorders.custom(color: AppColors.amber500),
                            ),
                            child: LocalizedText(
                              context.t('home.student_mode'),
                              style: AppTextStyles.badge(context, color: AppColors.amber700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Cheerful mascot speech banner (Noor encouraging the child)
                _QuranSpeechCard(
                  message: todayQaidaLessons > 0
                      ? context.t('home.mission_done_encouragement')
                      : context.t('home.start_new_lesson_encouragement'),
                  isTablet: isTablet,
                ),
                SizedBox(height: isTablet ? 14 : 10),
                // ── Smart Review Recommendation ──
                _ReviewRecommendationCard(isTablet: isTablet),
                _ContinueLearningCard(isTablet: isTablet),
                SizedBox(height: isTablet ? 14 : 10),

                // Playful category selector pills
                SizedBox(
                  height: AppSizes.pillHeight,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _QuickPill(
                        label: context.t('nav.qaida'),
                        icon: VectorIconType.qaida,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const QaidaChaptersScreen(),
                          ),
                        ),
                      ),
                      AppSpacing.gapWSm,
                      _QuickPill(
                        label: context.t('nav.quran'),
                        icon: VectorIconType.book,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const QuranScreen(),
                          ),
                        ),
                      ),
                      AppSpacing.gapWSm,
                      _QuickPill(
                        label: context.t('nav.prayer'),
                        icon: VectorIconType.mosque,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const PrayerScreen(),
                          ),
                        ),
                      ),
                      AppSpacing.gapWSm,
                      _QuickPill(
                        label: context.t('nav.dua'),
                        icon: VectorIconType.dua,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const DuasScreen(),
                          ),
                        ),
                      ),
                      AppSpacing.gapWSm,
                      _QuickPill(
                        label: context.t('nav.seerah'),
                        icon: VectorIconType.scroll,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SeerahScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapHMd,
              ],
            ),
          ),
        ),

        // Explore Modules Section
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.fromLTRB(
              isTablet ? 36 : 18,
              AppSpacing.lg,
              isTablet ? 36 : 18,
              AppSpacing.xxxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(
                  title: context.t('home.all_modules'),
                  subtitle: context.t('home.modules_subtitle'),
                  isTablet: isTablet,
                ),
                SizedBox(height: isTablet ? 16 : 12),
                _ModulesGrid(isTablet: isTablet),
                AppSpacing.gapHXl,
                _TeacherLearningBanner(isTablet: isTablet),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String _formatTime(String value, [BuildContext? context]) {
  final parts = value.split(':');
  final hour = int.tryParse(parts.first) ?? 17;
  final minute = int.tryParse(parts.last) ?? 30;
  return AppFormatters.formatTime(
    TimeOfDay(hour: hour, minute: minute),
    locale: context != null ? context.currentLanguageCode : null,
  );
}

/// My Learning Journey Tab ("আমার পড়া" / Continue Learning Hub)
/// Acts as the child's personal dashboard to resume right where they left off.
class _HomeContinueTab extends StatelessWidget {
  const _HomeContinueTab({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    // 1. Determine next Qaida lesson to resume
    final allNuraniLessons =
        NuraniQaidaData.steps.expand((s) => s.lessons).toList();
    final nextLesson = allNuraniLessons.firstWhere(
      (l) => !state.hasCompletedLesson(l.id),
      orElse: () => allNuraniLessons.first,
    );
    final step = NuraniQaidaData.getStepForLesson(nextLesson.id) ??
        NuraniQaidaData.steps.first;

    final quranPos = state.quranReadingPosition;
    final hasDue = state.hasSkillsDueForReview;
    final hasMistakes = state.hasRecentMistakes;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: AppSpacing.fromLTRB(
        isTablet ? 36 : 18,
        14,
        isTablet ? 36 : 18,
        36,
      ),
      children: [
        // ── 1. Personalized Header Banner ──
        Container(
          padding: AppSpacing.all(18),
          decoration: BoxDecoration(
            gradient: AppGradients.brand,
            borderRadius: AppRadius.borderXl,
            boxShadow: AppElevation.shadow(
              color: AppColors.brandDark.withValues(alpha: 0.28),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: isTablet ? 64 : 54,
                height: isTablet ? 64 : 54,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: AppRadius.radius(18),
                ),
                child: Image.asset(
                  'assets/images/quran_3d_open.png',
                  width: isTablet ? 46 : 38,
                  height: isTablet ? 46 : 38,
                  fit: BoxFit.contain,
                ),
              ),
              AppSpacing.gapWMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(
                      context.t('dashboard.my_learning_title'),
                      style: AppTextStyles.title(context, color: AppColors.white),
                    ),
                    AppSpacing.gapHXs,
                    LocalizedText(
                      context.t('dashboard.resume_subtitle'),
                      style: AppTextStyles.caption(context, color: AppColors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapHLg,

        // ── 2. Primary 1-Tap Qaida Resume Card ──
        _SectionTitle(
          title: context.t('dashboard.current_qaida_title'),
          subtitle: '${context.t("qaida.step", params: {"stepNumber": step.stepNumber})}: ${context.t(step.title)}',
          isTablet: isTablet,
        ),
        AppSpacing.gapHSm,
        AppCard(
          accentColor: AppColors.brandPrimary,
          margin: AppSpacing.insetNone,
          padding: isTablet ? AppSpacing.all(20) : AppSpacing.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: AppSpacing.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary.withValues(alpha: 0.12),
                      borderRadius: AppRadius.borderSm,
                    ),
                    child: LocalizedText(
                      context.t('qaida.step_with_title', params: {
                        'stepNumber': context.formatDigits(step.stepNumber.toString()),
                        'title': context.t(step.titleKey),
                      }),
                      style: AppTextStyles.badge(context, color: AppColors.brandPrimary),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: AppSpacing.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.slate100,
                      borderRadius: AppRadius.borderSm,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt_rounded,
                            size: AppSizes.iconSm, color: AppColors.orange),
                        AppSpacing.gapWXs,
                        LocalizedText(
                          context.t('qaida.lesson_progress', params: {
                            'current': context.formatDigits(nextLesson.lessonNumber.toString()),
                            'total': context.formatDigits(step.lessons.length.toString()),
                          }),
                          style: AppTextStyles.badge(context, color: AppColors.slate600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.gapHMd,
              Row(
                children: [
                  Container(
                    width: isTablet ? 66 : 56,
                    height: isTablet ? 66 : 56,
                    decoration: BoxDecoration(
                      color: AppColors.green50,
                      borderRadius: AppRadius.radius(18),
                      border: AppBorders.custom(color: AppColors.green300, width: AppStroke.regular),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      nextLesson.arabicDisplay,
                      style: AppTextStyles.arabic(
                        context,
                        fontSize: isTablet ? 32 : 28,
                        color: AppColors.slate900,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  AppSpacing.gapWMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocalizedText(
                          nextLesson.trackId == 'step_1_mufradat'
                              ? context.t('qaida.lesson.letter_title',
                                  params: {'letter': context.t(nextLesson.titleKey)})
                              : context.t(nextLesson.titleKey),
                          style: AppTextStyles.titleSmall(context, color: AppColors.slate900),
                        ),
                        AppSpacing.gapHXs,
                        LocalizedText(
                          nextLesson.trackId == 'step_1_mufradat'
                              ? context.t('qaida.lesson.letter_sub',
                                  params: {'letter': nextLesson.arabicDisplay})
                              : context.t(nextLesson.subtitleKey),
                          style: AppTextStyles.caption(context, color: AppColors.slate500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.gapHMd,
              // Big 3D Duolingo Action Button
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QaidaActivityScreen(lesson: nextLesson),
                    ),
                  );
                },
                borderRadius: AppRadius.borderLg,
                child: Container(
                  padding: AppSpacing.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimary,
                    borderRadius: AppRadius.borderLg,
                    boxShadow: AppElevation.shadow(
                      color: AppColors.brandDark,
                      offset: const Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow_rounded, color: AppColors.white, size: AppSizes.iconLg),
                      AppSpacing.gapWSm,
                      LocalizedText(
                        context.t('qaida.continue_lesson'),
                        style: AppTextStyles.button(context, color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapHMd,
              // Secondary shortcuts
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const QaidaChaptersScreen(),
                        ),
                      ),
                      borderRadius: AppRadius.borderMd,
                      child: Container(
                        padding: AppSpacing.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.blue50,
                          borderRadius: AppRadius.borderMd,
                          border: AppBorders.custom(color: AppColors.blue200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.map_rounded, size: AppSizes.iconSm, color: AppColors.blue600),
                            AppSpacing.gapWXs,
                            Flexible(
                              child: LocalizedText(
                                context.t('dashboard.seventeen_steps_map'),
                                style: AppTextStyles.badge(context, color: AppColors.blue700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.gapWSm,
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const QaidaReportScreen(),
                        ),
                      ),
                      borderRadius: AppRadius.borderMd,
                      child: Container(
                        padding: AppSpacing.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.purple50,
                          borderRadius: AppRadius.borderMd,
                          border: AppBorders.custom(color: AppColors.purple200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.insights_rounded, size: AppSizes.iconSm, color: AppColors.purple600),
                            AppSpacing.gapWXs,
                            Flexible(
                              child: LocalizedText(
                                context.t('dashboard.progress_report_heatmap'),
                                style: AppTextStyles.badge(context, color: AppColors.purple700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AppSpacing.gapHLg,

        // ── 3. Spaced Repetition / Smart Review ──
        if (hasDue || hasMistakes) ...[
          _SectionTitle(
            title: context.t('dashboard.smart_revision'),
            subtitle: hasMistakes
                ? context.t('dashboard.revision_mistakes_hint')
                : context.t('dashboard.revision_routine_hint'),
            isTablet: isTablet,
          ),
          AppSpacing.gapHSm,
          _ReviewRecommendationCard(isTablet: isTablet),
          AppSpacing.gapHLg,
        ],

        // ── 4. Quran Bookmark Resume Card ──
        _SectionTitle(
          title: context.t('quran.title'),
          subtitle: quranPos != null
              ? context.t('quran.surah_ayah_info', params: {
                  'surah': context.formatNumber(quranPos.surahNumber),
                  'ayah': context.formatNumber(quranPos.ayahNumber),
                })
              : context.t('quran.start_from_fatihah'),
          isTablet: isTablet,
        ),
        AppSpacing.gapHSm,
        AppCard(
          accentColor: AppColors.orange500,
          margin: AppSpacing.insetNone,
          padding: isTablet ? AppSpacing.all(18) : AppSpacing.all(14),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.orange50,
                  borderRadius: AppRadius.radius(14),
                  border: AppBorders.custom(color: AppColors.orange200),
                ),
                child: Image.asset(
                  'assets/images/quran_3d_open.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
              AppSpacing.gapWMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(
                      quranPos != null
                          ? context.t('quran.surah_ayah_info', params: {
                              'surah': context.formatNumber(quranPos.surahNumber),
                              'ayah': context.formatNumber(quranPos.ayahNumber),
                            })
                          : context.t('quran.fatihah_first_ayah'),
                      style: AppTextStyles.subtitle(context, color: AppColors.slate800),
                    ),
                    AppSpacing.gapHXs,
                    LocalizedText(
                      context.t('quran.recitation_meaning_subtitle'),
                      style: AppTextStyles.caption(context, color: AppColors.slate500),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapWSm,
              DSButton(
                label: context.t('common.read'),
                variant: DSButtonVariant.orange,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const QuranScreen()),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapHLg,

        // ── 5. Prayer Adhan & Learning Alarm Audio Panel ──
        _SectionTitle(
          title: context.t('dashboard.adhan_alarm_title'),
          subtitle: context.t('dashboard.adhan_alarm_subtitle'),
          isTablet: isTablet,
        ),
        AppSpacing.gapHSm,
        AppCard(
          accentColor: AppColors.blue500,
          margin: AppSpacing.insetNone,
          padding: AppSpacing.all(14),
          child: Column(
            children: [
              ValueListenableBuilder<AlertSoundType?>(
                valueListenable: AlertSoundService.instance.currentPlayingNotifier,
                builder: (context, playingType, _) {
                  final isAdhanPlaying = playingType == AlertSoundType.adhan;
                  final isAlarmPlaying = playingType == AlertSoundType.learningAlarm;

                  return Row(
                    children: [
                      // Adhan Button
                      Expanded(
                        child: InkWell(
                          onTap: () => AlertSoundService.instance.playAdhan(),
                          borderRadius: AppRadius.radius(14),
                          child: Container(
                            padding: AppSpacing.symmetric(vertical: AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: isAdhanPlaying
                                  ? AppColors.error
                                  : AppColors.emerald500,
                              borderRadius: AppRadius.radius(14),
                              boxShadow: AppElevation.shadow(
                                color: isAdhanPlaying ? AppColors.error.withValues(alpha: 0.25) : AppColors.emerald500.withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isAdhanPlaying
                                      ? Icons.stop_rounded
                                      : Icons.volume_up_rounded,
                                  color: AppColors.white,
                                  size: AppSizes.iconSm,
                                ),
                                AppSpacing.gapWXs,
                                Flexible(
                                  child: LocalizedText(
                                    isAdhanPlaying
                                        ? context.t('prayer.stop_adhan')
                                        : context.t('prayer.play_adhan'),
                                    style: AppTextStyles.badge(context, color: AppColors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AppSpacing.gapWSm,
                      // Learning Alarm Button
                      Expanded(
                        child: InkWell(
                          onTap: () => AlertSoundService.instance.playLearningAlarm(),
                          borderRadius: AppRadius.radius(14),
                          child: Container(
                            padding: AppSpacing.symmetric(vertical: AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: isAlarmPlaying
                                  ? AppColors.error
                                  : AppColors.amber500,
                              borderRadius: AppRadius.radius(14),
                              boxShadow: AppElevation.shadow(
                                color: isAlarmPlaying ? AppColors.error.withValues(alpha: 0.25) : AppColors.amber500.withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isAlarmPlaying
                                      ? Icons.stop_rounded
                                      : Icons.play_arrow_rounded,
                                  color: AppColors.white,
                                  size: AppSizes.iconSm,
                                ),
                                AppSpacing.gapWXs,
                                Flexible(
                                  child: LocalizedText(
                                    isAlarmPlaying
                                        ? context.t('settings.stop_alarm')
                                        : context.t('settings.test_alarm'),
                                    style: AppTextStyles.badge(context, color: AppColors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              AppSpacing.gapHSm,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LocalizedText(
                    context.t('settings.alarm_time', params: {
                      'time': _formatTime(state.learningAlarmTime, context),
                    }),
                    style: AppTextStyles.badge(context, color: AppColors.slate600),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const PrayerScreen()),
                    ),
                    child: LocalizedText(
                      context.t('prayer.view_schedule'),
                      style: AppTextStyles.badge(context, color: AppColors.blue600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AppSpacing.gapHXl,

        // ── 6. Compact Subject Directory (All Modules) ──
        _SectionTitle(
          title: context.t('home.all_modules'),
          subtitle: context.t('home.modules_subtitle'),
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 16 : 12),
        _ModulesGrid(isTablet: isTablet),
        AppSpacing.gapHXl,
        _TeacherLearningBanner(isTablet: isTablet),
      ],
    );
  }
}


/// Duolingo-style speech card using the respectful 3D Quran book image mascot.
/// Strictly no face, no limbs — just the holy book radiating light.
class _QuranSpeechCard extends StatelessWidget {
  const _QuranSpeechCard({
    required this.message,
    required this.isTablet,
  });

  final String message;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.borderXl,
        border: AppBorders.custom(color: AppColors.gray200, width: AppStroke.regular),
        boxShadow: AppElevation.shadow(
          color: AppColors.brandPrimary.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 3D Quran book image — no face, no limbs
          ClipRRect(
            borderRadius: AppRadius.borderMd,
            child: Image.asset(
              'assets/images/quran_3d.png',
              width: isTablet ? 68 : 58,
              height: isTablet ? 68 : 58,
              fit: BoxFit.contain,
            ),
          ),
          AppSpacing.gapWMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: AppSpacing.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimary,
                    borderRadius: AppRadius.borderSm,
                  ),
                  child: LocalizedText(
                    context.t('home.quran_says'),
                    style: AppTextStyles.badge(context, color: AppColors.white),
                  ),
                ),
                AppSpacing.gapHXs,
                LocalizedText(
                  message,
                  style: AppTextStyles.subtitle(context, color: AppColors.gray800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Smart review recommendation — shown when skills are due for spaced review
/// or when the learner has recent mistakes. Hidden when nothing to review.
class _ReviewRecommendationCard extends StatelessWidget {
  const _ReviewRecommendationCard({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final hasDue = state.hasSkillsDueForReview;
    final hasMistakes = state.hasRecentMistakes;

    if (!hasDue && !hasMistakes) return const SizedBox.shrink();

    final message = hasMistakes
        ? context.t('home.review_mistakes_desc')
        : context.t('home.review_spaced_desc');
    final icon = hasMistakes ? Icons.auto_fix_high_rounded : Icons.replay_rounded;
    final color = hasMistakes ? AppColors.amber500 : AppColors.indigo500;
    final bgColor =
        hasMistakes ? AppColors.amber100 : AppColors.indigo50;
    final borderColor =
        hasMistakes ? AppColors.amber200 : AppColors.indigo200;
    final btnLabel =
        hasMistakes ? context.t('home.fix_mistakes') : context.t('home.practice_again');
    final iconBgColor = hasMistakes ? AppColors.amber500.withValues(alpha: 0.15) : AppColors.indigo500.withValues(alpha: 0.15);

    return Padding(
      padding: AppSpacing.only(bottom: isTablet ? 12 : 10),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const QaidaRevisionScreen(),
          ),
        ),
        borderRadius: AppRadius.borderLg,
        child: Container(
          padding: AppSpacing.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppRadius.borderLg,
            border: AppBorders.custom(color: borderColor, width: AppStroke.regular),
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.avatarMd,
                height: AppSizes.avatarMd,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: AppSizes.iconButtonSm),
              ),
              AppSpacing.gapWMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(
                      hasMistakes
                          ? context.t('home.fix_mistakes')
                          : context.t('home.practice_again'),
                      style: AppTextStyles.subtitle(context, color: color),
                    ),
                    AppSpacing.gapHXs,
                    LocalizedText(
                      message,
                      style: AppTextStyles.caption(context, color: color),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapWSm,
              Container(
                padding:
                    AppSpacing.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadius.borderSm,
                ),
                child: LocalizedText(
                  btnLabel,
                  style: AppTextStyles.badge(context, color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (state.completedQaidaLessons == 0) {
      return const SizedBox.shrink();
    }
    final allNuraniLessons =
        NuraniQaidaData.steps.expand((s) => s.lessons).toList();
    final nextLesson = allNuraniLessons.firstWhere(
      (l) => !state.hasCompletedLesson(l.id),
      orElse: () => allNuraniLessons.first,
    );
    final step = NuraniQaidaData.getStepForLesson(nextLesson.id) ??
        NuraniQaidaData.steps.first;

    return Container(
      padding: isTablet ? AppSpacing.all(18) : AppSpacing.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.borderXxl,
        border: AppBorders.custom(color: AppColors.slate200, width: AppStroke.strong),
        boxShadow: AppElevation.shadow(
          color: AppColors.black.withValues(alpha: 0.04),
          offset: const Offset(0, 4),
          blurRadius: 10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: AppSpacing.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.brandLight,
                  borderRadius: AppRadius.borderSm,
                ),
                child: LocalizedText(
                  '${context.t('common.in_progress')}: ${context.t('qaida.step_with_title', params: {
                    'stepNumber': context.formatDigits(step.stepNumber.toString()),
                    'title': context.t(step.titleKey),
                  })}',
                  style: AppTextStyles.badge(context, color: AppColors.textBrand),
                ),
              ),
              const Spacer(),
              Container(
                padding: AppSpacing.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.slate100,
                  borderRadius: AppRadius.borderSm,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded,
                        size: AppSizes.iconSm, color: AppColors.orange),
                    AppSpacing.gapWXs,
                    LocalizedText(
                      context.t('qaida.lesson_progress', params: {
                        'current': context.formatDigits(nextLesson.lessonNumber.toString()),
                        'total': context.formatDigits(step.lessons.length.toString()),
                      }),
                      style: AppTextStyles.badge(context, color: AppColors.slate600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapHSm,
          Row(
            children: [
              Container(
                width: AppSizes.lessonIconBox,
                height: AppSizes.lessonIconBox,
                decoration: BoxDecoration(
                  color: AppColors.slate50,
                  borderRadius: AppRadius.radius(14),
                  border: AppBorders.custom(color: AppColors.slate200),
                ),
                alignment: Alignment.center,
                child: Text(
                  nextLesson.arabicDisplay,
                  style: AppTextStyles.arabic(
                    context,
                    color: AppColors.slate900,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              AppSpacing.gapWMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(
                      nextLesson.title,
                      style: AppTextStyles.titleSmall(context, color: AppColors.slate900),
                    ),
                    AppSpacing.gapHXs,
                    LocalizedText(
                      nextLesson.subtitle,
                      style: AppTextStyles.caption(context, color: AppColors.slate500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapHMd,
          // Primary Obvious Action: Continue Learning Button
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => QaidaActivityScreen(lesson: nextLesson),
                ),
              );
            },
            borderRadius: AppRadius.radius(14),
            child: Container(
              padding: AppSpacing.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.brandPrimary,
                borderRadius: AppRadius.radius(14),
                boxShadow: AppElevation.shadow(
                  color: AppColors.brandDark,
                  offset: const Offset(0, 3.5),
                  blurRadius: 0,
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow_rounded, color: AppColors.white, size: AppSizes.iconButtonSm),
                  AppSpacing.gapWXs,
                  LocalizedText(
                    context.t('qaida.continue_lesson'),
                    style: AppTextStyles.button(context, color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.gapHSm,
          // Secondary row: 8 Tracks & Teacher Help
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const QaidaChaptersScreen(),
                      ),
                    );
                  },
                  borderRadius: AppRadius.borderSm,
                  child: Container(
                    padding:
                        AppSpacing.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.blue50,
                      borderRadius: AppRadius.borderSm,
                      border: AppBorders.custom(color: AppColors.blue200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_stories_rounded,
                            size: AppSizes.iconXs, color: AppColors.blue600),
                        AppSpacing.gapWXs,
                        Flexible(
                          child: LocalizedText(
                            context.t('qaida.seventeen_steps'),
                            style: AppTextStyles.badge(context, color: AppColors.blue700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppSpacing.gapWSm,
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const LiveLearningScreen(),
                      ),
                    );
                  },
                  borderRadius: AppRadius.borderSm,
                  child: Container(
                    padding:
                        AppSpacing.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.purple50,
                      borderRadius: AppRadius.borderSm,
                      border: AppBorders.custom(color: AppColors.purple200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.school_rounded,
                            size: AppSizes.iconXs, color: AppColors.purple600),
                        AppSpacing.gapWXs,
                        Flexible(
                          child: LocalizedText(
                            context.t('live.teacher_help'),
                            style: AppTextStyles.badge(context, color: AppColors.purple700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.isTablet,
  });
  final String title;
  final String subtitle;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocalizedText(
          title,
          style: AppTextStyles.title(context, color: AppColors.textPrimary),
        ),
        AppSpacing.gapHXs,
        LocalizedText(
          subtitle,
          style: AppTextStyles.caption(context, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _ModulesGrid extends StatelessWidget {
  const _ModulesGrid({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 3 : 2,
      mainAxisSpacing: DS.s4,
      crossAxisSpacing: DS.s4,
      childAspectRatio: isTablet ? 1.05 : 0.88,
      children: AppModuleRegistry.activeModules.map((module) {
        return DSModuleCard(
          colors: module.colors,
          title: module.getLocalizedTitle(context),
          subtitle: module.getLocalizedSubtitle(context),
          badgeAsset: module.badgeAsset,
          customBadge: module.customBadge,
          iconPainter: module.iconPainter,
          isTablet: isTablet,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: module.routeBuilder),
          ),
        );
      }).toList(),
    );
  }
}

class _TeacherLearningBanner extends StatelessWidget {
  const _TeacherLearningBanner({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadius.borderXxl,
      child: InkWell(
        borderRadius: AppRadius.borderXxl,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const LiveLearningScreen(),
          ),
        ),
        child: Ink(
          padding: isTablet ? AppSpacing.all(AppSpacing.xl) : AppSpacing.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: AppGradients.brand,
            borderRadius: AppRadius.borderXl,
            boxShadow: AppElevation.shadow(
              color: AppColors.brandPrimary.withValues(alpha: .22),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: isTablet ? 56 : 50,
                height: isTablet ? 56 : 50,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: .18),
                  borderRadius: AppRadius.borderLg,
                ),
                child: const Icon(Icons.video_call_rounded,
                    color: AppColors.white, size: AppSizes.iconXl),
              ),
              AppSpacing.gapWMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(
                      context.t('live.banner_title'),
                      style: AppTextStyles.titleSmall(context, color: AppColors.white),
                    ),
                    AppSpacing.gapHXs,
                    LocalizedText(
                      context.t('live.banner_subtitle'),
                      style: AppTextStyles.caption(context, color: AppColors.white70),
                    ),
                    AppSpacing.gapHSm,
                    LocalizedText(
                      context.t('live.view_schedule_btn'),
                      style: AppTextStyles.label(context, color: AppColors.goldLight),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Duolingo-style floating rounded bottom navigation bar
class _DuolingoBottomNavBar extends StatelessWidget {
  const _DuolingoBottomNavBar({
    required this.currentIndex,
    required this.isTablet,
    required this.onTap,
  });

  final int currentIndex;
  final bool isTablet;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: AppSpacing.symmetric(
          horizontal: isTablet ? 36 : 12,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: AppBorders.borderTop(color: AppColors.gray200, width: AppStroke.regular),
          boxShadow: AppElevation.shadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _NavBarItem(
                navType: Real3DNavType.path,
                label: context.t('nav.learn_path'),
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
            ),
            Expanded(
              child: _NavBarItem(
                navType: Real3DNavType.modules,
                label: context.t('nav.my_learning'),
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
            ),
            Expanded(
              child: _NavBarItem(
                navType: Real3DNavType.missions,
                label: context.t('nav.missions'),
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ),
            Expanded(
              child: _NavBarItem(
                navType: Real3DNavType.achievements,
                label: context.t('nav.achievements'),
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.navType,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final Real3DNavType navType;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: AppSpacing.symmetric(horizontal: AppSpacing.xs, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandLight : AppColors.transparent,
          borderRadius: AppRadius.borderLg,
          border: isSelected
              ? AppBorders.custom(
                  color: AppColors.brandPrimary.withValues(alpha: 0.45),
                  width: AppStroke.regular,
                )
              : AppBorders.custom(color: AppColors.transparent, width: AppStroke.regular),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                child: Center(
                  child: Real3DNavIcon(
                    type: navType,
                    size: 26,
                    isSelected: isSelected,
                  ),
                ),
              ),
            ),
            AppSpacing.gapHXs,
            LocalizedText(
              label,
              style: AppTextStyles.navItem(
                context,
                color: isSelected
                    ? AppColors.greenDarkText
                    : AppColors.gray400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickPill extends StatelessWidget {
  const _QuickPill({
    required this.label,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  });

  final String label;
  final VectorIconType icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.symmetric(horizontal: AppSpacing.md, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandPrimary : AppColors.white,
          borderRadius: AppRadius.borderXl,
          border: AppBorders.custom(
            color: isSelected ? AppColors.brandDark : AppColors.gray200,
            width: AppStroke.regular,
          ),
          boxShadow: AppElevation.shadow(
            color: isSelected
                ? AppColors.brandPrimary.withValues(alpha: 0.3)
                : AppColors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VectorIcon(
              type: icon,
              size: AppSizes.iconSm,
              color: isSelected ? AppColors.white : AppColors.brandPrimary,
            ),
            AppSpacing.gapWXs,
            LocalizedText(
              label,
              style: AppTextStyles.label(
                context,
                color: isSelected ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
