import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/vector_mascot.dart';
import '../../widgets/duolingo_path_view.dart';
import '../qaida/qaida_letters.dart';
import '../qaida/qaida_chapters_screen.dart';
import '../prayer/prayer_screen.dart';
import '../quran/quran_screen.dart';
import '../duas/duas_screen.dart';
import '../seerah/seerah_screen.dart';
import '../achievements/achievements_screen.dart';
import '../missions/daily_missions_screen.dart';
import '../basics/islam_basics_screen.dart';
import '../live_learning/live_learning_screen.dart';
import '../settings/settings_screen.dart';

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
      backgroundColor: const Color(0xFFFBF8F2),
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
                  _HomeModulesTab(isTablet: isTablet),
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
    const lessons = qaidaLetters;
    final (
      todayQaidaLessons,
      letterProgress
    ) = context.select<AppState, (int, int)>((state) => (
          state.todayQaidaLessons,
          lessons.where((lesson) => state.hasCompletedLesson(lesson.id)).length,
        ));

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
                // Cheerful mascot speech banner (Noor encouraging the child)
                MascotSpeechBanner(
                  title: 'নুর বলছে',
                  message: todayQaidaLessons > 0
                      ? 'মাশাআল্লাহ! আজকের মিশন সম্পূর্ণ করেছ।'
                      : 'আসসালামু আলাইকুম! চলো আজ নতুন পাঠ শিখি!',
                  mood: todayQaidaLessons > 0
                      ? MascotMood.celebrating
                      : MascotMood.waving,
                  mascotSize: isTablet ? 72 : 60,
                ),
                SizedBox(height: isTablet ? 14 : 10),

                // Section header: 'তোমার শেখার পথ' with progress chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LocalizedText(
                            'তোমার শেখার পথ',
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.darkText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          LocalizedText(
                            'প্রতিটি নোডে ট্যাপ করে শেখো',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.darkText.withValues(alpha: 0.55),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F8D8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF58CC02).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const VectorIcon(
                            type: VectorIconType.star,
                            size: 14,
                            color: Color(0xFF58A700),
                          ),
                          const SizedBox(width: 5),
                          LocalizedText(
                            '$letterProgress / ${lessons.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              color: Color(0xFF58A700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Reference 2: Playful category selector pills
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _QuickPill(
                        label: 'ক্বায়দা',
                        icon: VectorIconType.qaida,
                        isSelected: true,
                        onTap: () {},
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

        // The flagship vertical Duolingo serpentine winding path
        SliverToBoxAdapter(
          child: DuolingoPathView(isTablet: isTablet, isActive: isActive),
        ),

        // Explore Modules Section below the road
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isTablet ? 36 : 18,
              28,
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

/// Standalone Modules Tab
class _HomeModulesTab extends StatelessWidget {
  const _HomeModulesTab({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        isTablet ? 36 : 18,
        14,
        isTablet ? 36 : 18,
        32,
      ),
      children: [
        _SectionTitle(
          title: 'সব মডিউল',
          subtitle: 'কুরআন, নামাজ, দোয়া ও ইসলামিক গল্প শিখি',
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 18 : 14),
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
        IconBadge(
          type: VectorIconType.crescent,
          bgColor: const Color(0xFFD4F0EC),
          size: isTablet ? 50 : 42,
          iconColor: AppTheme.primaryGreen,
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
        // Streak counter chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEAD6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFF9600), width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const VectorIcon(
                type: VectorIconType.flame,
                size: 16,
                color: Color(0xFFFF6B00),
              ),
              const SizedBox(width: 4),
              LocalizedText(
                '$streakDays',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  color: Color(0xFFD45100),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // XP Chip
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const VectorIcon(
            type: VectorIconType.star,
            size: 16,
            color: Color(0xFFE6A800),
          ),
          const SizedBox(width: 4),
          LocalizedText(
            '$xp XP',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              color: Color(0xFF8A6A00),
            ),
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
    final modules = [
      _ModuleData(
        type: VectorIconType.qaida,
        title: 'ক্বায়দা',
        subtitle: 'বর্ণমালা',
        bg: const Color(0xFFE8F8D8),
        accent: const Color(0xFF58A700),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const QaidaChaptersScreen()),
        ),
      ),
      _ModuleData(
        type: VectorIconType.book,
        title: 'কুরআন',
        subtitle: 'তিলাওয়াত',
        bg: const Color(0xFFFFF0DB),
        accent: const Color(0xFFE8913A),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const QuranScreen()),
        ),
      ),
      _ModuleData(
        type: VectorIconType.mosque,
        title: 'নামাজ',
        subtitle: 'সময় + নিয়ম',
        bg: const Color(0xFFDCEBFF),
        accent: const Color(0xFF3B82C4),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const PrayerScreen()),
        ),
      ),
      _ModuleData(
        type: VectorIconType.dua,
        title: 'দোয়া',
        subtitle: 'মাসনুন',
        bg: const Color(0xFFF3E8FF),
        accent: const Color(0xFF9B6BC9),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const DuasScreen()),
        ),
      ),
      _ModuleData(
        type: VectorIconType.scroll,
        title: 'সীরাত',
        subtitle: 'নবীর গল্প',
        bg: const Color(0xFFFFE8EE),
        accent: const Color(0xFFE05A7A),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const SeerahScreen()),
        ),
      ),
      _ModuleData(
        type: VectorIconType.crescent,
        title: 'মৌলিক ইসলাম',
        subtitle: 'গল্পে গল্পে শিখি',
        bg: const Color(0xFFDDF4E9),
        accent: const Color(0xFF0D7377),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const IslamBasicsScreen()),
        ),
      ),
      _ModuleData(
        type: VectorIconType.trophy,
        title: 'অর্জন',
        subtitle: 'ব্যাজ · লেভেল',
        bg: const Color(0xFFFFF6D0),
        accent: const Color(0xFFD4A017),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const AchievementsScreen()),
        ),
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 3 : 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: isTablet ? 1.15 : 1.05,
      children: [
        for (final m in modules) _ModuleCard(data: m, isTablet: isTablet),
      ],
    );
  }
}

class _ModuleData {
  const _ModuleData({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.bg,
    required this.accent,
    required this.onTap,
  });
  final VectorIconType type;
  final String title;
  final String subtitle;
  final Color bg;
  final Color accent;
  final VoidCallback onTap;
}

class _ModuleCard extends StatefulWidget {
  const _ModuleCard({required this.data, required this.isTablet});
  final _ModuleData data;
  final bool isTablet;

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        d.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: Stack(
        children: [
          Positioned.fill(
            top: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: HSLColor.fromColor(d.accent)
                    .withLightness(
                      (HSLColor.fromColor(d.accent).lightness - .16)
                          .clamp(0.0, 1.0),
                    )
                    .toColor(),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOut,
            top: _pressed ? 6 : 0,
            bottom: _pressed ? 0 : 6,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white.withValues(alpha: .28), d.bg],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: d.accent.withValues(alpha: .35),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconBadge(
                    type: d.type,
                    size: widget.isTablet ? 58 : 50,
                    iconSize: widget.isTablet ? 34 : 30,
                    bgColor: Colors.white.withValues(alpha: .72),
                    iconColor: d.accent,
                  ),
                  SizedBox(height: widget.isTablet ? 9 : 7),
                  LocalizedText(
                    d.title,
                    style: TextStyle(
                      fontSize: widget.isTablet ? 16 : 14,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  LocalizedText(
                    d.subtitle,
                    style: TextStyle(
                      fontSize: widget.isTablet ? 12 : 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkText.withValues(alpha: 0.58),
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
              colors: [Color(0xFF0D7377), Color(0xFF159A8C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40 : 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _NavBarItem(
              iconType: VectorIconType.compass,
              label: 'শেখার পথ',
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              iconType: VectorIconType.book,
              label: 'মডিউল',
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              iconType: VectorIconType.target,
              label: 'মিশন',
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              iconType: VectorIconType.trophy,
              label: 'অর্জন',
              isSelected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.iconType,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final VectorIconType iconType;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF58CC02); // Duolingo signature vibrant green
    const inactiveColor = Color(0xFF9CA3AF);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F8D8) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VectorIcon(
              type: iconType,
              size: 26,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 3),
            LocalizedText(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                color: isSelected ? const Color(0xFF46A302) : inactiveColor,
              ),
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
