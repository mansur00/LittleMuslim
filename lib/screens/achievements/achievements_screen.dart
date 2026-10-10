import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';

class _BadgeInfo {
  const _BadgeInfo({
    required this.title,
    required this.description,
    required this.iconType,
    required this.color,
    required this.accent,
    required this.unlocked,
  });
  final String title, description;
  final VectorIconType iconType;
  final Color color, accent;
  final bool unlocked;
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  static const _levels = [
    (name: 'নতুন শিক্ষার্থী', threshold: 0),
    (name: 'কৌতূহলী পাঠক', threshold: 50),
    (name: 'জ্ঞান অন্বেষী', threshold: 120),
    (name: 'আলোকিত শিক্ষার্থী', threshold: 250),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final lessonCount = state.completedQaidaLessons;
    final levelIndex =
        _levels.lastIndexWhere((level) => state.xp >= level.threshold);
    final level = _levels[levelIndex < 0 ? 0 : levelIndex];
    final nextLevel =
        levelIndex + 1 < _levels.length ? _levels[levelIndex + 1] : null;
    final progress = nextLevel == null
        ? 1.0
        : ((state.xp - level.threshold) /
                (nextLevel.threshold - level.threshold))
            .clamp(0.0, 1.0);

    final badges = [
      _BadgeInfo(
        title: 'প্রথম পাঠ',
        description: '১টি ক্বায়দা পাঠ শেষ করো',
        iconType: VectorIconType.qaida,
        color: const Color(0xFFE8F8D8),
        accent: const Color(0xFF58A700),
        unlocked: lessonCount >= 1,
      ),
      _BadgeInfo(
        title: 'তিন ধাপ এগিয়ে',
        description: '৩টি ক্বায়দা পাঠ শেষ করো',
        iconType: VectorIconType.star,
        color: const Color(0xFFFFF6D0),
        accent: const Color(0xFFD4A017),
        unlocked: lessonCount >= 3,
      ),
      _BadgeInfo(
        title: 'পাঁচ পাঠের বন্ধু',
        description: '৫টি ক্বায়দা পাঠ শেষ করো',
        iconType: VectorIconType.book,
        color: const Color(0xFFDCEBFF),
        accent: const Color(0xFF3B82C4),
        unlocked: lessonCount >= 5,
      ),
      _BadgeInfo(
        title: 'XP সংগ্রাহক',
        description: '১০০ XP অর্জন করো',
        iconType: VectorIconType.trophy,
        color: const Color(0xFFF3E8FF),
        accent: const Color(0xFF9B6BC9),
        unlocked: state.xp >= 100,
      ),
    ];
    final unlocked = badges.where((b) => b.unlocked).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      tablet ? 36 : 18, 12, tablet ? 36 : 18, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Row(children: [
                        IconButton.filledTonal(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded),
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'আমার অর্জন',
                          style: TextStyle(
                            color: AppTheme.darkText,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0D7377), Color(0xFF14919B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: VectorIcon(
                                    type: VectorIconType.shield,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'তোমার বর্তমান লেভেল',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      level.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD66B),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  '${state.xp} XP',
                                  style: const TextStyle(
                                    color: Color(0xFF8A6A00),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 12,
                                backgroundColor: Colors.white24,
                                color: const Color(0xFFFFD66B),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              nextLevel == null
                                  ? 'সব লেভেল শেষ! শেখা চালিয়ে যাও।'
                                  : 'পরের লেভেল: ${nextLevel.name} · আর ${nextLevel.threshold - state.xp} XP',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(children: [
                        const Expanded(
                          child: Text(
                            'ব্যাজ সংগ্রহ',
                            style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F8D8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$unlocked / ${badges.length}',
                            style: const TextStyle(
                              color: Color(0xFF58A700),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 14),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: badges.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: tablet ? 4 : 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: tablet ? 0.88 : 0.9,
                        ),
                        itemBuilder: (context, index) =>
                            _BadgeCard(badge: badges[index]),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: const Color(0xFFE5E5E5), width: 2),
                        ),
                        child: Row(children: [
                          IconBadge(
                            type: VectorIconType.qaida,
                            bgColor: const Color(0xFFE8F8D8),
                            size: 42,
                            iconColor: const Color(0xFF58A700),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'সম্পন্ন ক্বায়দা পাঠ: $lessonCount',
                              style: const TextStyle(
                                color: AppTheme.darkText,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ]),
                      ),
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
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge});
  final _BadgeInfo badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: badge.unlocked ? badge.accent.withValues(alpha: 0.4) : const Color(0xFFE5E5E5),
          width: 2.5,
        ),
        boxShadow: badge.unlocked
            ? [
                BoxShadow(
                  color: badge.accent.withValues(alpha: 0.15),
                  blurRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: badge.unlocked ? 1 : 0.4,
            child: IconBadge(
              type: badge.unlocked ? badge.iconType : VectorIconType.lock,
              bgColor: badge.unlocked ? badge.color : const Color(0xFFF0F0F0),
              size: 56,
              iconColor:
                  badge.unlocked ? badge.accent : const Color(0xFFAFAFAF),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            badge.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: badge.unlocked ? AppTheme.darkText : Colors.black38,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            badge.unlocked ? 'আনলক!' : badge.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: badge.unlocked
                  ? badge.accent
                  : AppTheme.darkText.withValues(alpha: 0.4),
              fontSize: 10,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
