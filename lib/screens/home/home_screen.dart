import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/faceless_silhouette.dart';
import '../../widgets/duolingo_appbar.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Pinned Duolingo-style Top Bar
            Padding(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 36 : 18,
                10,
                isTablet ? 36 : 18,
                10,
              ),
              child: _HomeTopBar(
                isTablet: isTablet,
                onSettings: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
              ),
            ),
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

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({required this.isTablet, required this.onSettings});

  final bool isTablet;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final (userName, xp, streakDays) =
        context.select<AppState, (String, int, int)>(
            (state) => (state.userName, state.xp, state.streakDays));
    return _TopBar(
      name: userName.isNotEmpty ? userName : 'বন্ধু',
      xp: xp,
      streakDays: streakDays,
      isTablet: isTablet,
      onSettings: onSettings,
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
            padding: EdgeInsets.fromLTRB(
              isTablet ? 36 : 18,
              8,
              isTablet ? 36 : 18,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (context.select<AppState, bool>((s) => s.isAdmin)) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.admin_panel_settings_rounded,
                            color: Color(0xFFD97706), size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: LocalizedText(
                            '🛠️ অ্যাডমিন মোড: সব লেভেল ও ধাপ আনলক',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => context.read<AppState>().setUserRole('child'),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFF59E0B)),
                            ),
                            child: const LocalizedText(
                              'শিক্ষার্থী মোড',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFB45309),
                              ),
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
                      ? 'মাশাআল্লাহ! আজকের মিশন সম্পূর্ণ করেছ।'
                      : 'আসসালামু আলাইকুম! চলো আজ নতুন পাঠ শিখি!',
                  isTablet: isTablet,
                ),
                SizedBox(height: isTablet ? 14 : 10),
                // ── Smart Review Recommendation ──
                _ReviewRecommendationCard(isTablet: isTablet),
                _ContinueLearningCard(isTablet: isTablet),
                SizedBox(height: isTablet ? 14 : 10),

                // Playful category selector pills
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _QuickPill(
                        label: 'ক্বায়দা',
                        icon: VectorIconType.qaida,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const QaidaChaptersScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _QuickPill(
                        label: 'কুরআন',
                        icon: VectorIconType.book,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const QuranScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _QuickPill(
                        label: 'নামাজ',
                        icon: VectorIconType.mosque,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const PrayerScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _QuickPill(
                        label: 'দোয়া',
                        icon: VectorIconType.dua,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const DuasScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _QuickPill(
                        label: 'সীরাত',
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
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        // Explore Modules Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isTablet ? 36 : 18,
              16,
              isTablet ? 36 : 18,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(
                  title: 'মডিউল',
                  subtitle: 'যেখান থেকে খুশি শুরু করো',
                  isTablet: isTablet,
                ),
                SizedBox(height: isTablet ? 16 : 12),
                _ModulesGrid(isTablet: isTablet),
                const SizedBox(height: 20),
                _TeacherLearningBanner(isTablet: isTablet),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String _formatTime(String value) {
  final parts = value.split(':');
  final hour = int.tryParse(parts.first) ?? 17;
  final minute = int.tryParse(parts.last) ?? 30;
  final period = hour >= 12 ? 'PM' : 'AM';
  final shownHour = hour % 12 == 0 ? 12 : hour % 12;
  return '$shownHour:${minute.toString().padLeft(2, '0')} $period';
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
      padding: EdgeInsets.fromLTRB(
        isTablet ? 36 : 18,
        14,
        isTablet ? 36 : 18,
        36,
      ),
      children: [
        // ── 1. Personalized Header Banner ──
        Container(
          padding: const EdgeInsets.all(18),
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
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: isTablet ? 64 : 54,
                height: isTablet ? 64 : 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.auto_stories_rounded,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(
                      'আমার পড়ার ড্যাশবোর্ড',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 20 : 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const LocalizedText(
                      'যেখান থেকে শেষ করেছিলে, সেখান থেকেই পড়া চালিয়ে যাও!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── 2. Primary 1-Tap Qaida Resume Card ──
        _SectionTitle(
          title: 'চলমান কায়দা পাঠ',
          subtitle: 'ধাপ ${step.stepNumber}: ${step.title}',
          isTablet: isTablet,
        ),
        const SizedBox(height: 10),
        DuolingoCard(
          accentColor: AppTheme.primaryGreen,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'স্টেপ ${step.stepNumber}: ${step.title}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt_rounded,
                            size: 14, color: Color(0xFFFF9600)),
                        const SizedBox(width: 3),
                        Text(
                          'পাঠ ${nextLesson.lessonNumber}/${step.lessons.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: isTablet ? 66 : 56,
                    height: isTablet ? 66 : 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      nextLesson.arabicDisplay,
                      style: TextStyle(
                        fontFamily: AppTheme.arabicFontFamily,
                        fontSize: isTablet ? 32 : 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nextLesson.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          nextLesson.subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Big 3D Duolingo Action Button
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QaidaActivityScreen(lesson: nextLesson),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.duoGreen,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: AppTheme.duoGreenDark,
                        offset: Offset(0, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'কায়দা পড়া চালিয়ে যাই',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map_rounded, size: 14, color: Color(0xFF2563EB)),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                '১৭টি ধাপের মানচিত্র',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D4ED8),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const QaidaReportScreen(),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF5FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE9D5FF)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.insights_rounded, size: 14, color: Color(0xFF9333EA)),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                'পড়ার রিপোর্ট (হিটম্যাপ)',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7E22CE),
                                ),
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
        const SizedBox(height: 18),

        // ── 3. Spaced Repetition / Smart Review ──
        if (hasDue || hasMistakes) ...[
          _SectionTitle(
            title: 'স্মার্ট রিভিশন',
            subtitle: hasMistakes
                ? 'কিছু হরফে ভুল হয়েছিল, পুনরায় ঝালিয়ে নাও'
                : 'পরবর্তী পড়ার আগে রিভিশন করে নাও',
            isTablet: isTablet,
          ),
          const SizedBox(height: 10),
          _ReviewRecommendationCard(isTablet: isTablet),
          const SizedBox(height: 18),
        ],

        // ── 4. Quran Bookmark Resume Card ──
        _SectionTitle(
          title: 'পবিত্র কুরআন তিলাওয়াত',
          subtitle: quranPos != null
              ? 'সূরা নম্বর ${quranPos.surahNumber} · আয়াত ${quranPos.ayahNumber}'
              : 'সূরা আল-ফাতিহা থেকে শুরু করো',
          isTablet: isTablet,
        ),
        const SizedBox(height: 10),
        DuolingoCard(
          accentColor: const Color(0xFFF97316),
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(isTablet ? 18 : 14),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFDBA74)),
                ),
                child: const Icon(Icons.menu_book_rounded,
                    color: Color(0xFFEA580C), size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(
                      quranPos != null
                          ? 'সূরা নম্বর ${quranPos.surahNumber} · আয়াত ${quranPos.ayahNumber}'
                          : 'সূরা আল-ফাতিহা (১ম আয়াত)',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14.5,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const LocalizedText(
                      'উচ্চারণ ও অর্থসহ সুন্দর তিলাওয়াত',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const QuranScreen()),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF97316),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                child: const LocalizedText('পড়ি ›'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // ── 5. Prayer Adhan & Learning Alarm Audio Panel ──
        _SectionTitle(
          title: 'আযান ও পড়ার অ্যালার্ম',
          subtitle: 'সুমধুর আযান ও আউযুবিল্লাহ-বিসমিল্লাহ শুনুন',
          isTablet: isTablet,
        ),
        const SizedBox(height: 10),
        DuolingoCard(
          accentColor: const Color(0xFF3B82F6),
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(14),
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
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            decoration: BoxDecoration(
                              color: isAdhanPlaying
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: (isAdhanPlaying
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFF10B981))
                                      .withValues(alpha: 0.25),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isAdhanPlaying
                                      ? Icons.stop_rounded
                                      : Icons.volume_up_rounded,
                                  color: Colors.white,
                                  size: 17,
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    isAdhanPlaying ? 'আযান থামান' : 'আযান শুনুন',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Learning Alarm Button
                      Expanded(
                        child: InkWell(
                          onTap: () => AlertSoundService.instance.playLearningAlarm(),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            decoration: BoxDecoration(
                              color: isAlarmPlaying
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFFF59E0B),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: (isAlarmPlaying
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFFF59E0B))
                                      .withValues(alpha: 0.25),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isAlarmPlaying
                                      ? Icons.stop_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    isAlarmPlaying ? 'অ্যালার্ম থামান' : 'পড়ার অ্যালার্ম শুনুন',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'পড়ার অ্যালার্ম: ${_formatTime(state.learningAlarmTime)}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const PrayerScreen()),
                    ),
                    child: const Text(
                      'নামাজের সময়সূচি ›',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // ── 6. Compact Subject Directory (All Modules) ──
        _SectionTitle(
          title: 'সব মডিউল',
          subtitle: 'কুরআন, নামাজ, দোয়া ও ইসলামিক গল্প শিখি',
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 16 : 12),
        _ModulesGrid(isTablet: isTablet),
        const SizedBox(height: 20),
        _TeacherLearningBanner(isTablet: isTablet),
      ],
    );
  }
}

/// Tactile, modern top header bar (Streak, XP, Settings)
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.name,
    required this.xp,
    required this.streakDays,
    required this.isTablet,
    required this.onSettings,
  });

  final String name;
  final int xp;
  final int streakDays;
  final bool isTablet;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Faceless Silhouette Avatar (Tap to change avatar & color)
        GestureDetector(
          onTap: () => showAvatarCustomizerModal(context),
          child: Tooltip(
            message: 'অবতার ও রঙ পরিবর্তন করুন',
            child: FacelessSilhouette(
              size: isTablet ? 48 : 42,
              circleBackground: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocalizedText(
                'আসসালামু আলাইকুম',
                style: TextStyle(
                  fontSize: isTablet ? 12 : 11,
                  color: AppTheme.darkText.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w600,
                ),
              ),
              LocalizedText(
                name,
                style: TextStyle(
                  fontSize: isTablet ? 19 : 16,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
        ),
        // 3D Streak counter chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEAD6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFF9600), width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x15EA580C),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Real3DTopBarIcon(
                type: Real3DTopType.flame,
                size: 18,
              ),
              const SizedBox(width: 5),
              LocalizedText(
                '$streakDays',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                  color: Color(0xFFD45100),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // 3D XP Chip
        _XpChip(xp: xp),
        const SizedBox(width: 6),
        IconButton.filledTonal(
          onPressed: onSettings,
          tooltip: context.uiText('সেটিংস'),
          icon: const Icon(Icons.settings_rounded, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primaryGreen,
            elevation: 1,
            shadowColor: Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}

class _XpChip extends StatelessWidget {
  const _XpChip({required this.xp});
  final int xp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15D97706),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Real3DTopBarIcon(
            type: Real3DTopType.xp,
            size: 18,
          ),
          const SizedBox(width: 5),
          LocalizedText(
            '$xp XP',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12.5,
              color: Color(0xFF8A6A00),
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF58CC02).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 3D Quran book image — no face, no limbs
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/quran_3d.png',
              width: isTablet ? 68 : 58,
              height: isTablet ? 68 : 58,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF58CC02),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const LocalizedText(
                    'কুরআন বলছে',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                LocalizedText(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                    height: 1.35,
                  ),
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
        ? 'কিছু দক্ষতায় আরো মনোযোগ দরকার। ভুল সংশোধন করে এগিয়ে যাও!'
        : 'কিছু পুরনো পাঠ পুনরায় অনুশীলন করার সময় হয়েছে।';
    final icon = hasMistakes ? Icons.auto_fix_high_rounded : Icons.replay_rounded;
    final color = hasMistakes ? const Color(0xFFF59E0B) : const Color(0xFF6366F1);
    final bgColor =
        hasMistakes ? const Color(0xFFFEF3C7) : const Color(0xFFEEF2FF);
    final borderColor =
        hasMistakes ? const Color(0xFFFDE68A) : const Color(0xFFC7D2FE);
    final btnLabel =
        hasMistakes ? 'ভুল সংশোধন করি' : 'পুনরায় অনুশীলন করি';

    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 12 : 10),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const QaidaRevisionScreen(),
          ),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasMistakes ? 'ভুল সংশোধন' : 'পুনরায় অনুশীলন',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 11,
                        color: color.withValues(alpha: 0.8),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  btnLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
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
      padding: EdgeInsets.all(isTablet ? 18 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8D8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'চলমান: স্টেপ ${step.stepNumber}: ${step.title}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D6A00),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded,
                        size: 14, color: Color(0xFFFF9600)),
                    const SizedBox(width: 4),
                    Text(
                      'পাঠ ${nextLesson.lessonNumber}/${step.lessons.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                alignment: Alignment.center,
                child: Text(
                  nextLesson.arabicDisplay,
                  style: TextStyle(
                    fontFamily: AppTheme.arabicFontFamily,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nextLesson.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextLesson.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Primary Obvious Action: Continue Learning Button
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => QaidaActivityScreen(lesson: nextLesson),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: AppTheme.duoGreen,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: AppTheme.duoGreenDark,
                    offset: Offset(0, 3.5),
                    blurRadius: 0,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 6),
                  Text(
                    'পড়া চালিয়ে যাই',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_stories_rounded,
                            size: 13, color: Color(0xFF2563EB)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '১৭টি স্টেপ',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D4ED8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const LiveLearningScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF5FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE9D5FF)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.school_rounded,
                            size: 13, color: Color(0xFF9333EA)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'শিক্ষক সহায়তা',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7E22CE),
                            ),
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
          style: TextStyle(
            fontSize: isTablet ? 20 : 17,
            fontWeight: FontWeight.w900,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 2),
        LocalizedText(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.darkText.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
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
      children: [
        DSModuleCard(
          colors: DS.qaida,
          title: 'ক্বায়দা',
          subtitle: 'বর্ণমালা',
          badgeAsset: 'assets/images/badge_qaida_3d.png',
          iconPainter: const QaidaIconPainter(),
          isTablet: isTablet,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const QaidaChaptersScreen()),
          ),
        ),
        DSModuleCard(
          colors: DS.quran,
          title: 'কুরআন',
          subtitle: 'তিলাওয়াত',
          badgeAsset: 'assets/images/badge_quran_3d.png',
          iconPainter: const QuranIconPainter(),
          isTablet: isTablet,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const QuranScreen()),
          ),
        ),
        DSModuleCard(
          colors: DS.prayer,
          title: 'নামাজ',
          subtitle: 'সময় + নিয়ম',
          badgeAsset: 'assets/images/badge_prayer_3d.png',
          iconPainter: const PrayerIconPainter(),
          isTablet: isTablet,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const PrayerScreen()),
          ),
        ),
        DSModuleCard(
          colors: DS.dua,
          title: 'দোয়া',
          subtitle: 'মাসনুন',
          badgeAsset: 'assets/images/badge_dua_3d.png',
          iconPainter: const DuaIconPainter(),
          isTablet: isTablet,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const DuasScreen()),
          ),
        ),
        DSModuleCard(
          colors: DS.seerah,
          title: 'সীরাত',
          subtitle: 'নবীর গল্প',
          badgeAsset: 'assets/images/badge_seerah_3d.png',
          iconPainter: const SeerahIconPainter(),
          isTablet: isTablet,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const SeerahScreen()),
          ),
        ),
        DSModuleCard(
          colors: DS.basics,
          title: 'মৌলিক ইসলাম',
          subtitle: 'গল্পে গল্পে শিখি',
          badgeAsset: 'assets/images/badge_basics_3d.png',
          iconPainter: const BasicsIconPainter(),
          isTablet: isTablet,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const IslamBasicsScreen()),
          ),
        ),
        DSModuleCard(
          colors: DS.achievements,
          title: 'অর্জন',
          subtitle: 'ব্যাজ · লেভেল',
          customBadge: const DSGamifyBadge(
            emblem: BadgeEmblem.trophy,
            primaryColor: Color(0xFFFFC800),
            bevelColor: Color(0xFFE5A100),
            ribbonColor: Color(0xFFFFD700),
            ribbonText: 'অর্জন',
            size: 76,
          ),
          iconPainter: const TrophyIconPainter(),
          isTablet: isTablet,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const AchievementsScreen()),
          ),
        ),
      ],
    );
  }
}

class _TeacherLearningBanner extends StatelessWidget {
  const _TeacherLearningBanner({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const LiveLearningScreen(),
          ),
        ),
        child: Ink(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF58CC02), Color(0xFF46A302)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20), // DS.rXl
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withValues(alpha: .22),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: isTablet ? 56 : 50,
                height: isTablet ? 56 : 50,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.video_call_rounded,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(
                      'শিক্ষকের সাথে কুরআন ও ইসলাম শিখি',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const LocalizedText(
                      'মাসিক পরিকল্পনায় সরাসরি live class',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 11, height: 1.3),
                    ),
                    const SizedBox(height: 6),
                    const LocalizedText(
                      'ক্লাস ও পরিকল্পনা দেখো  ›',
                      style: TextStyle(
                        color: Color(0xFFFFE39A),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
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
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 36 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _NavBarItem(
                navType: Real3DNavType.path,
                label: 'শেখার পথ',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
            ),
            Expanded(
              child: _NavBarItem(
                navType: Real3DNavType.modules,
                label: 'আমার পড়া',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
            ),
            Expanded(
              child: _NavBarItem(
                navType: Real3DNavType.missions,
                label: 'মিশন',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ),
            Expanded(
              child: _NavBarItem(
                navType: Real3DNavType.achievements,
                label: 'অর্জন',
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
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F8D8) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF58CC02).withValues(alpha: 0.45),
                  width: 1.5,
                )
              : Border.all(color: Colors.transparent, width: 1.5),
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
            const SizedBox(height: 3),
            LocalizedText(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                color: isSelected
                    ? const Color(0xFF2D6A00)
                    : const Color(0xFF9CA3AF),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF58CC02) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF46A302) : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF58CC02).withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VectorIcon(
              type: icon,
              size: 16,
              color: isSelected ? Colors.white : AppTheme.primaryGreen,
            ),
            const SizedBox(width: 6),
            LocalizedText(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : AppTheme.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
