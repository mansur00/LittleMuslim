import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../qaida/qaida_lesson_screen.dart';
import '../qaida/qaida_letters.dart';
import '../prayer/prayer_screen.dart';
import '../quran/quran_screen.dart';
import '../duas/duas_screen.dart';
import '../seerah/seerah_screen.dart';
import '../achievements/achievements_screen.dart';
import '../missions/daily_missions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final name = appState.userName.isNotEmpty ? appState.userName : 'বন্ধু';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 36 : 18,
                  12,
                  isTablet ? 36 : 18,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopBar(name: name, xp: appState.xp, isTablet: isTablet),
                    SizedBox(height: isTablet ? 22 : 16),
                    _StreakBanner(
                      streakDays: 0,
                      xp: appState.xp,
                      isTablet: isTablet,
                    ),
                    SizedBox(height: isTablet ? 20 : 14),
                    _MissionTile(isTablet: isTablet),
                    SizedBox(height: isTablet ? 24 : 18),
                    _SectionTitle(
                      title: 'শেখার পথ',
                      subtitle: 'প্রতিটি নোডে ট্যাপ করে শেখো',
                      isTablet: isTablet,
                    ),
                    SizedBox(height: isTablet ? 14 : 10),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _LearningPath(isTablet: isTablet),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 36 : 18,
                  isTablet ? 28 : 22,
                  isTablet ? 36 : 18,
                  isTablet ? 40 : 28,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.name,
    required this.xp,
    required this.isTablet,
  });
  final String name;
  final int xp;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconBadge(
          type: VectorIconType.crescent,
          bgColor: const Color(0xFFD4F0EC),
          size: isTablet ? 54 : 46,
          iconColor: AppTheme.primaryGreen,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'আসসালামু আলাইকুম',
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  color: AppTheme.darkText.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
        ),
        _XpChip(xp: xp),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD54F), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VectorIcon(
            type: VectorIconType.star,
            size: 18,
            color: const Color(0xFFE6A800),
          ),
          const SizedBox(width: 6),
          Text(
            '$xp XP',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: Color(0xFF8A6A00),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakBanner extends StatelessWidget {
  const _StreakBanner({
    required this.streakDays,
    required this.xp,
    required this.isTablet,
  });
  final int streakDays;
  final int xp;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9600), Color(0xFFFF6B00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B00).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isTablet ? 64 : 56,
            height: isTablet ? 64 : 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: VectorIcon(
                type: VectorIconType.flame,
                size: isTablet ? 36 : 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'স্ট্রিক',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$streakDays দিন',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 26 : 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '$xp',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'XP',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
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

class _MissionTile extends StatelessWidget {
  const _MissionTile({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final done = context.watch<AppState>().todayQaidaLessons > 0;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const DailyMissionsScreen()),
        ),
        child: Container(
          padding: EdgeInsets.all(isTablet ? 18 : 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
          ),
          child: Row(
            children: [
              IconBadge(
                type: VectorIconType.target,
                bgColor: const Color(0xFFFFE8DE),
                size: isTablet ? 52 : 46,
                iconColor: const Color(0xFFFF6B4A),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'আজকের মিশন',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      done ? 'সম্পন্ন — দারুণ কাজ!' : '১টি পাঠ শেষ করো · +১০ XP',
                      style: TextStyle(
                        color: done
                            ? const Color(0xFF58A700)
                            : AppTheme.darkText.withValues(alpha: 0.55),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (done)
                const VectorIcon(
                  type: VectorIconType.check,
                  size: 28,
                  color: Color(0xFF58CC02),
                )
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFAFAFAF),
                  size: 28,
                ),
            ],
          ),
        ),
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
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 20 : 17,
            fontWeight: FontWeight.w900,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
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
        onTap: () => _openQaidaLesson(context, letterIndex: 0),
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
      childAspectRatio: isTablet ? 1.05 : 0.95,
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
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: d.bg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: d.accent.withValues(alpha: 0.25),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: d.accent.withValues(alpha: 0.18),
                blurRadius: 0,
                offset: Offset(0, _pressed ? 2 : 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VectorIcon(
                type: d.type,
                size: widget.isTablet ? 52 : 44,
                color: d.accent,
              ),
              SizedBox(height: widget.isTablet ? 14 : 10),
              Text(
                d.title,
                style: TextStyle(
                  fontSize: widget.isTablet ? 17 : 15,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                d.subtitle,
                style: TextStyle(
                  fontSize: widget.isTablet ? 13 : 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearningPath extends StatelessWidget {
  const _LearningPath({required this.isTablet});
  final bool isTablet;

  static const _nodeColors = [
    Color(0xFFFFC800),
    Color(0xFF1CB0F6),
    Color(0xFFCE82FF),
    Color(0xFFFF9600),
    Color(0xFF58CC02),
    Color(0xFFFF4B4B),
  ];

  @override
  Widget build(BuildContext context) {
    final progressState = context.watch<AppState>();
    const lessons = qaidaLetters;
    final progress = lessons
        .where((l) => progressState.hasCompletedLesson(l.id))
        .length;

    // Find first unlocked incomplete index for "current" highlight
    var currentIndex = 0;
    for (var i = 0; i < lessons.length; i++) {
      if (!progressState.hasCompletedLesson(lessons[i].id)) {
        currentIndex = i;
        break;
      }
      currentIndex = i;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 36 : 18),
      padding: EdgeInsets.fromLTRB(
        isTablet ? 20 : 14,
        isTablet ? 20 : 16,
        isTablet ? 20 : 14,
        isTablet ? 16 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'ক্বায়দা পথ',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.darkText,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8D8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VectorIcon(
                      type: VectorIconType.star,
                      size: 14,
                      color: const Color(0xFF58A700),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$progress / ${lessons.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: Color(0xFF58A700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: lessons.isEmpty ? 0 : progress / lessons.length,
              minHeight: 10,
              backgroundColor: const Color(0xFFE5E5E5),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF58CC02)),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: isTablet ? 130 : 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: lessons.length,
              itemBuilder: (context, i) {
                final lesson = lessons[i];
                final done = progressState.hasCompletedLesson(lesson.id);
                final locked = i > 0 &&
                    !progressState.hasCompletedLesson(lessons[i - 1].id);
                final isCurrent = i == currentIndex && !done;
                final color = done
                    ? const Color(0xFF58CC02)
                    : _nodeColors[i % _nodeColors.length];

                return Padding(
                  padding: EdgeInsets.only(
                    right: 8,
                    left: i == 0 ? 4 : 0,
                  ),
                  child: _PathNode(
                    letter: lesson.letter,
                    name: lesson.name,
                    color: color,
                    locked: locked,
                    done: done,
                    isCurrent: isCurrent,
                    onTap: locked
                        ? null
                        : () => _openQaidaLesson(context, letterIndex: i),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'আলিফ → ইয়া · পাশে স্ক্রল করো',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.darkText.withValues(alpha: 0.45),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PathNode extends StatefulWidget {
  const _PathNode({
    required this.letter,
    required this.name,
    required this.color,
    required this.locked,
    required this.done,
    required this.isCurrent,
    required this.onTap,
  });

  final String letter;
  final String name;
  final Color color;
  final bool locked;
  final bool done;
  final bool isCurrent;
  final VoidCallback? onTap;

  @override
  State<_PathNode> createState() => _PathNodeState();
}

class _PathNodeState extends State<_PathNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isCurrent) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _PathNode old) {
    super.didUpdateWidget(old);
    if (widget.isCurrent && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.isCurrent && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) {
                final scale =
                    widget.isCurrent ? 1.0 + (_pulse.value * 0.08) : 1.0;
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: widget.locked
                      ? const Color(0xFFE5E5E5)
                      : widget.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: widget.locked
                      ? null
                      : [
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.45),
                            blurRadius: 0,
                            offset: const Offset(0, 5),
                          ),
                        ],
                ),
                child: Center(
                  child: widget.locked
                      ? VectorIcon(
                          type: VectorIconType.lock,
                          size: 24,
                          color: const Color(0xFFAFAFAF),
                        )
                      : widget.done
                          ? VectorIcon(
                              type: VectorIconType.check,
                              size: 28,
                              color: Colors.white,
                            )
                          : Text(
                              widget.letter,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: widget.locked
                    ? const Color(0xFFAFAFAF)
                    : AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.done
                  ? 'সম্পন্ন'
                  : widget.locked
                      ? 'লক'
                      : widget.isCurrent
                          ? 'এখন'
                          : 'খোলা',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: widget.done
                    ? const Color(0xFF58A700)
                    : widget.isCurrent
                        ? widget.color
                        : const Color(0xFFAFAFAF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openQaidaLesson(
  BuildContext context, {
  required int letterIndex,
}) {
  final lesson = qaidaLetters[letterIndex];
  final nextIndex = letterIndex + 1;
  final next = nextIndex < qaidaLetters.length ? qaidaLetters[nextIndex] : null;
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => QaidaLessonScreen(
      lessonId: lesson.id,
      lessonTitle: lesson.title,
      letter: lesson.letter,
      letterName: lesson.name,
      makhrajNote: lesson.makhraj,
      options: qaidaLetterOptions(letterIndex),
      nextLesson: next == null
          ? null
          : QaidaNextLesson(
              lessonId: next.id,
              lessonTitle: next.title,
              letter: next.letter,
              letterName: next.name,
              options: qaidaLetterOptions(nextIndex),
              makhrajNote: next.makhraj,
            ),
    ),
  ));
}
