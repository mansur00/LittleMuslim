import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
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
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 40 : 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'আসসালামু আলাইকুম',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            color: AppTheme.darkText.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: isTablet ? 28 : 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: isTablet ? 56 : 48,
                    height: isTablet ? 56 : 48,
                    decoration: BoxDecoration(
                      color: AppTheme.softGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🌙', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ],
              ),

              SizedBox(height: isTablet ? 32 : 24),

              // Streak / XP card (placeholder)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isTablet ? 24 : 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryGreen, Color(0xFF14919B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryGreen.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'আজকের স্ট্রিক',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '0 দিন',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '${appState.xp} XP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isTablet ? 36 : 28),

              _DailyMissionCard(isTablet: isTablet),

              SizedBox(height: isTablet ? 22 : 18),

              _LearningTrail(isTablet: isTablet),

              SizedBox(height: isTablet ? 32 : 24),

              Text(
                'আরও শিখি',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),

              SizedBox(height: isTablet ? 20 : 16),

              // Modules grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isTablet ? 3 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isTablet ? 1.1 : 1.0,
                children: [
                  _ModuleCard(
                    emoji: '🔤',
                    title: 'ক্বায়দা',
                    subtitle: 'বর্ণমালা শেখো',
                    color: const Color(0xFFE8F5E9),
                    isTablet: isTablet,
                    onTap: () => _openQaidaLesson(
                      context,
                      letterIndex: 0,
                    ),
                  ),
                  _ModuleCard(
                    emoji: '📖',
                    title: 'কুরআন',
                    subtitle: 'তিলাওয়াত করো',
                    color: const Color(0xFFFFF3E0),
                    isTablet: isTablet,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const QuranScreen()),
                    ),
                  ),
                  _ModuleCard(
                    emoji: '🕌',
                    title: 'নামাজ',
                    subtitle: 'সময় + নিয়ম',
                    color: const Color(0xFFE3F2FD),
                    isTablet: isTablet,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const PrayerScreen()),
                    ),
                  ),
                  _ModuleCard(
                    emoji: '✨',
                    title: 'দোয়া',
                    subtitle: 'মাসনুন দোয়া',
                    color: const Color(0xFFF3E5F5),
                    isTablet: isTablet,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const DuasScreen()),
                    ),
                  ),
                  _ModuleCard(
                    emoji: '📜',
                    title: 'সীরাত',
                    subtitle: 'নবীর গল্প',
                    color: const Color(0xFFFFEBEE),
                    isTablet: isTablet,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const SeerahScreen()),
                    ),
                  ),
                  _ModuleCard(
                    emoji: '🏆',
                    title: 'অর্জন',
                    subtitle: 'ব্যাজ ও লেভেল',
                    color: const Color(0xFFFFF8E1),
                    isTablet: isTablet,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const AchievementsScreen()),
                    ),
                  ),
                ],
              ),

              SizedBox(height: isTablet ? 40 : 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyMissionCard extends StatelessWidget {
  const _DailyMissionCard({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final done = context.watch<AppState>().todayQaidaLessons > 0;
    return Material(
      color: const Color(0xFFFFF4D7),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => const DailyMissionsScreen(),
        )),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 18 : 15),
          child: Row(children: [
            const Text('🎯', style: TextStyle(fontSize: 30)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text('আজকের মিশন',
                      style: TextStyle(
                          color: AppTheme.darkText,
                          fontWeight: FontWeight.w800,
                          fontSize: 14)),
                  const SizedBox(height: 3),
                  Text(
                      done ? 'আজকের পাঠ সম্পন্ন ✓' : '১টি পাঠ শেষ করো · +১০ XP',
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 11)),
                ])),
            const Icon(Icons.chevron_right_rounded,
                color: AppTheme.primaryGreen),
          ]),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final bool isTablet;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isTablet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: TextStyle(fontSize: isTablet ? 40 : 34)),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 17 : 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  color: AppTheme.darkText.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearningTrail extends StatelessWidget {
  const _LearningTrail({required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final progressState = context.watch<AppState>();
    const nodeColors = [
      Color(0xFFFFC94F),
      Color(0xFF56B6D9),
      Color(0xFF9A7AD1),
      Color(0xFFFF906A),
      Color(0xFF69B77B),
      Color(0xFFE17B9B),
    ];
    const lessons = qaidaLetters;
    final progress = lessons
        .where((lesson) => progressState.hasCompletedLesson(lesson.id))
        .length;
    return Container(
      padding: EdgeInsets.all(isTablet ? 22 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
            colors: [Color(0xFFBFE58A), Color(0xFF91CC70)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        boxShadow: const [
          BoxShadow(
              color: Color(0x244A7D43), blurRadius: 12, offset: Offset(0, 5))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('তোমার শেখার পথ',
                    style: TextStyle(
                        color: AppTheme.darkText,
                        fontSize: 19,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 3),
                Text('প্রতিদিন একটু করে এগিয়ে চলো',
                    style: TextStyle(color: Color(0xBB1A3C34), fontSize: 12)),
              ])),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .8),
                  borderRadius: BorderRadius.circular(16)),
              child: Text('$progress / ${lessons.length} ⭐',
                  style: TextStyle(
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w800,
                      fontSize: 12))),
        ]),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, constraints) {
          const nodeWidth = 94.0;
          final contentWidth = nodeWidth * lessons.length;
          return SizedBox(
            height: isTablet ? 145 : 137,
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: contentWidth,
                  child: Stack(children: [
                    Positioned(
                        left: nodeWidth / 2,
                        right: nodeWidth / 2,
                        top: 35,
                        child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .65),
                                borderRadius: BorderRadius.circular(10)))),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < lessons.length; i++)
                            SizedBox(
                              width: nodeWidth,
                              child: _TrailNode(
                                letter: lessons[i].letter,
                                title: lessons[i].name,
                                subtitle: progressState
                                        .hasCompletedLesson(lessons[i].id)
                                    ? 'সম্পন্ন'
                                    : i > 0 &&
                                            !progressState.hasCompletedLesson(
                                                lessons[i - 1].id)
                                        ? 'লক করা'
                                        : i == 0
                                            ? 'শুরু করো'
                                            : 'পরের পাঠ',
                                color: progressState
                                        .hasCompletedLesson(lessons[i].id)
                                    ? AppTheme.primaryGreen
                                    : nodeColors[i % nodeColors.length],
                                locked: i > 0 &&
                                    !progressState
                                        .hasCompletedLesson(lessons[i - 1].id),
                                onTap: () =>
                                    _openQaidaLesson(context, letterIndex: i),
                              ),
                            ),
                        ]),
                  ]),
                ),
              ),
            ),
          );
        }),
        const Padding(
          padding: EdgeInsets.only(top: 3, bottom: 9),
          child: Text('আলিফ থেকে ইয়া পর্যন্ত ২৮টি হরফ · পথটি পাশে টেনে দেখো',
              style: TextStyle(color: Color(0xBB1A3C34), fontSize: 10)),
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .78),
                borderRadius: BorderRadius.circular(15)),
            child: const Row(children: [
              Icon(Icons.auto_awesome_rounded,
                  color: AppTheme.secondaryGold, size: 18),
              SizedBox(width: 8),
              Expanded(
                  child: Text('আজকের মিশন: ৩টি নতুন বর্ণ শেখো',
                      style: TextStyle(
                          color: AppTheme.darkText,
                          fontWeight: FontWeight.w700,
                          fontSize: 12))),
              Text('+১০ XP',
                  style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: 12))
            ])),
      ]),
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

class _TrailNode extends StatelessWidget {
  const _TrailNode(
      {required this.letter,
      required this.title,
      required this.subtitle,
      required this.color,
      required this.locked,
      required this.onTap});
  final String letter, title, subtitle;
  final Color color;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: locked ? null : onTap,
        child: Column(children: [
          Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x33436A37),
                        offset: Offset(0, 4),
                        blurRadius: 0)
                  ]),
              child: Center(
                  child: locked
                      ? const Icon(Icons.lock_rounded, color: Colors.white)
                      : Text(letter,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 29,
                              fontWeight: FontWeight.w800)))),
          const SizedBox(height: 7),
          Text(title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppTheme.darkText,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: const TextStyle(color: Color(0xAA1A3C34), fontSize: 10)),
        ]),
      );
}
