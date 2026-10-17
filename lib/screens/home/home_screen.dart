import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';

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
                _QuranSpeechCard(
                  message: todayQaidaLessons > 0
                      ? 'মাশাআল্লাহ! আজকের মিশন সম্পূর্ণ করেছ।'
                      : 'আসসালামু আলাইকুম! চলো আজ নতুন পাঠ শিখি!',
                  isTablet: isTablet,
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
        // 3D Mascot Avatar
        Container(
          width: isTablet ? 48 : 42,
          height: isTablet ? 48 : 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFFFD700), width: 2.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF58CC02).withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/mascot_happy.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const IconBadge(
                type: VectorIconType.crescent,
                bgColor: Color(0xFFD4F0EC),
                size: 42,
                iconColor: AppTheme.primaryGreen,
              ),
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
              'assets/images/quran_3d.jpg',
              width: isTablet ? 68 : 58,
              height: isTablet ? 68 : 58,
              fit: BoxFit.cover,
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
          badgeAsset: 'assets/images/badge_qaida_3d.jpg',
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
          badgeAsset: 'assets/images/badge_quran_3d.jpg',
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
          badgeAsset: 'assets/images/badge_prayer_3d.jpg',
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
          badgeAsset: 'assets/images/badge_dua_3d.jpg',
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
          badgeAsset: 'assets/images/badge_seerah_3d.jpg',
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
          badgeAsset: 'assets/images/badge_basics_3d.jpg',
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
              navType: Real3DNavType.path,
              label: 'শেখার পথ',
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              navType: Real3DNavType.modules,
              label: 'মডিউল',
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F8D8) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: const Color(0xFF58CC02).withValues(alpha: 0.4), width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Real3DNavIcon(
              type: navType,
              size: isSelected ? 30 : 26,
              isSelected: isSelected,
            ),
            const SizedBox(height: 3),
            LocalizedText(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                color: isSelected ? const Color(0xFF2D6A00) : const Color(0xFF9CA3AF),
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
