import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';

class _BadgeInfo {
  const _BadgeInfo(
      this.title, this.description, this.emoji, this.color, this.unlocked);
  final String title, description, emoji;
  final Color color;
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
    final level = _levels[levelIndex];
    final nextLevel =
        levelIndex + 1 < _levels.length ? _levels[levelIndex + 1] : null;
    final progress = nextLevel == null
        ? 1.0
        : ((state.xp - level.threshold) /
                (nextLevel.threshold - level.threshold))
            .clamp(0.0, 1.0);
    final badges = [
      _BadgeInfo('প্রথম পাঠ', 'একটি ক্বায়দা পাঠ শেষ করো', '🌱',
          const Color(0xFFE3F1D4), lessonCount >= 1),
      _BadgeInfo('তিন ধাপ এগিয়ে', '৩টি ক্বায়দা পাঠ শেষ করো', '🌟',
          const Color(0xFFFFE7A8), lessonCount >= 3),
      _BadgeInfo('পাঁচ পাঠের বন্ধু', '৫টি ক্বায়দা পাঠ শেষ করো', '📚',
          const Color(0xFFDCEFFA), lessonCount >= 5),
      _BadgeInfo('XP সংগ্রাহক', '১০০ XP অর্জন করো', '🏅',
          const Color(0xFFF4DDF0), state.xp >= 100),
    ];
    final unlocked = badges.where((badge) => badge.unlocked).length;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: CustomScrollView(slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    tablet ? 36 : 20, 16, tablet ? 36 : 20, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(children: [
                      IconButton.filledTonal(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                        style:
                            IconButton.styleFrom(backgroundColor: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Text('আমার অর্জন',
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                    ]),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                            colors: [AppTheme.primaryGreen, Color(0xFF16877B)]),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Text('🌙', style: TextStyle(fontSize: 34)),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    const Text('তোমার বর্তমান লেভেল',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12)),
                                    Text(level.name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w800)),
                                  ])),
                              Text('${state.xp} XP',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800)),
                            ]),
                            const SizedBox(height: 18),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                backgroundColor: Colors.white24,
                                color: const Color(0xFFFFD66B),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                                nextLevel == null
                                    ? 'সব লেভেল শেষ! শেখা চালিয়ে যাও।'
                                    : 'পরের লেভেল: ${nextLevel.name} · আর ${nextLevel.threshold - state.xp} XP',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11)),
                          ]),
                    ),
                    const SizedBox(height: 24),
                    Row(children: [
                      const Expanded(
                          child: Text('ব্যাজ সংগ্রহ',
                              style: TextStyle(
                                  color: AppTheme.darkText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800))),
                      Text('$unlocked / ${badges.length} পাওয়া',
                          style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: badges.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: tablet ? 4 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: tablet ? 0.9 : 0.92,
                      ),
                      itemBuilder: (context, index) => _BadgeCard(
                        badge: badges[index],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18)),
                      child: Row(children: [
                        const Icon(Icons.menu_book_rounded,
                            color: AppTheme.primaryGreen),
                        const SizedBox(width: 11),
                        Expanded(
                            child: Text('সম্পন্ন ক্বায়দা পাঠ: $lessonCount',
                                style: const TextStyle(
                                    color: AppTheme.darkText,
                                    fontWeight: FontWeight.w700))),
                      ]),
                    ),
                  ]),
                ),
              ),
            ]),
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
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
              color: badge.unlocked ? badge.color : const Color(0xFFE9E8DF),
              width: 2),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: badge.unlocked ? badge.color : const Color(0xFFF1F0EB),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(badge.unlocked ? badge.emoji : '🔒',
                style: const TextStyle(fontSize: 29)),
          ),
          const SizedBox(height: 10),
          Text(badge.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: badge.unlocked ? AppTheme.darkText : Colors.black45,
                  fontSize: 13,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text(badge.unlocked ? 'পেয়ে গেছ!' : badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black54, fontSize: 10, height: 1.4)),
        ]),
      );
}
