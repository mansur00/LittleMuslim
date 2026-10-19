import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/duolingo_appbar.dart';

class _BadgeInfo {
  const _BadgeInfo({
    required this.title,
    required this.description,
    required this.emblem,
    required this.primaryColor,
    required this.bevelColor,
    required this.unlocked,
    this.ribbonText,
  });
  final String title, description;
  final BadgeEmblem emblem;
  final Color primaryColor, bevelColor;
  final bool unlocked;
  final String? ribbonText;
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
    final (xp, lessonCount) = context.select<AppState, (int, int)>(
        (state) => (state.xp, state.completedQaidaLessons));
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final levelIndex = _levels.lastIndexWhere((level) => xp >= level.threshold);
    final level = _levels[levelIndex < 0 ? 0 : levelIndex];
    final nextLevel =
        levelIndex + 1 < _levels.length ? _levels[levelIndex + 1] : null;
    final progress = nextLevel == null
        ? 1.0
        : ((xp - level.threshold) / (nextLevel.threshold - level.threshold))
            .clamp(0.0, 1.0);

    final badges = [
      _BadgeInfo(
          title: 'প্রথম পাঠ',
          description: '১টি ক্বায়দা পাঠ শেষ করো',
          emblem: BadgeEmblem.star,
          primaryColor: const Color(0xFF10B981),
          bevelColor: const Color(0xFF047857),
          ribbonText: '১ম ধাপ',
          unlocked: lessonCount >= 1),
      _BadgeInfo(
          title: 'তিন ধাপ এগিয়ে',
          description: '৩টি ক্বায়দা পাঠ শেষ করো',
          emblem: BadgeEmblem.lightning,
          primaryColor: const Color(0xFFF59E0B),
          bevelColor: const Color(0xFFB45309),
          ribbonText: 'গতিশীল',
          unlocked: lessonCount >= 3),
      _BadgeInfo(
          title: 'পাঁচ পাঠের বন্ধু',
          description: '৫টি ক্বায়দা পাঠ শেষ করো',
          emblem: BadgeEmblem.diamond,
          primaryColor: const Color(0xFF3B82F6),
          bevelColor: const Color(0xFF1D4ED8),
          ribbonText: 'হিরক',
          unlocked: lessonCount >= 5),
      _BadgeInfo(
          title: 'XP সংগ্রাহক',
          description: '১০০ XP অর্জন করো',
          emblem: BadgeEmblem.trophy,
          primaryColor: const Color(0xFF8B5CF6),
          bevelColor: const Color(0xFF6D28D9),
          ribbonText: 'মাস্টার',
          unlocked: xp >= 100),
    ];
    final unlocked = badges.where((b) => b.unlocked).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
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
                      // ── Duolingo Header ──
                      DuolingoPageHeader(
                        title: 'আমার অর্জন',
                        subtitle: 'XP ও ব্যাজ সংগ্রহ দেখো',
                        iconType: VectorIconType.trophy,
                        gradientColors: const [
                          Color(0xFFF59E0B),
                          Color(0xFFD97706)
                        ],
                        onBack: () => Navigator.pop(context),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFFAE5),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFD97706).withValues(alpha: 0.3),
                                width: 1.5,
                              )),
                          child: LocalizedText('$xp XP',
                              style: const TextStyle(
                                  color: Color(0xFFB45309),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900)),
                        ),
                      ),

                      // ── Level progress card ──
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20), // DS.rXl
                          border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFD97706).withValues(alpha: 0.12),
                                blurRadius: 0,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(14)),
                                  child: const Center(
                                      child: VectorIcon(
                                          type: VectorIconType.shield,
                                          size: 26,
                                          color: Color(0xFFD97706))),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const LocalizedText(
                                            'তোমার বর্তমান লেভেল',
                                            style: TextStyle(
                                                color: Color(0xFF6B7280),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600)),
                                        LocalizedText(level.name,
                                            style: const TextStyle(
                                                color: AppTheme.darkText,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900)),
                                      ]),
                                ),
                              ]),
                              const SizedBox(height: 14),
                              Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 14,
                                    backgroundColor: const Color(0xFFE5E7EB),
                                    color: const Color(0xFF58CC02),
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 8),
                              LocalizedText(
                                nextLevel == null
                                    ? 'সব লেভেল শেষ! শেখা চালিয়ে যাও।'
                                    : 'পরের লেভেল: ${context.uiText(nextLevel.name)} · আর ${nextLevel.threshold - xp} XP',
                                style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ]),
                      ),

                      // ── Badges ──
                      DuolingoSectionLabel(
                        label: 'ব্যাজ সংগ্রহ',
                        badgeText: '$unlocked / ${badges.length} পাওয়া',
                      ),
                      const SizedBox(height: 14),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: badges.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: tablet ? 4 : 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: tablet ? 0.82 : 0.76,
                        ),
                        itemBuilder: (context, index) =>
                            _BadgeCard(badge: badges[index]),
                      ),
                      const SizedBox(height: 18),

                      // ── Lesson stats ──
                      DuolingoCard(
                        accentColor: const Color(0xFF58A700),
                        showAccentStripe: true,
                        child: Row(children: [
                          const IconBadge(
                              type: VectorIconType.qaida,
                              bgColor: Color(0xFFE8F8D8),
                              size: 44,
                              iconColor: Color(0xFF58A700)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LocalizedText('সম্পন্ন ক্বায়দা পাঠ',
                                      style: TextStyle(
                                          color: AppTheme.darkText
                                              .withValues(alpha: 0.6),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600)),
                                  LocalizedText('$lessonCount টি পাঠ',
                                      style: const TextStyle(
                                          color: AppTheme.darkText,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18)),
                                ]),
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

class _BadgeCard extends StatefulWidget {
  const _BadgeCard({required this.badge});
  final _BadgeInfo badge;

  @override
  State<_BadgeCard> createState() => _BadgeCardState();
}

class _BadgeCardState extends State<_BadgeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final badge = widget.badge;
    return GestureDetector(
      onTapDown: badge.unlocked ? (_) => setState(() => _pressed = true) : null,
      onTapUp: badge.unlocked ? (_) => setState(() => _pressed = false) : null,
      onTapCancel:
          badge.unlocked ? () => setState(() => _pressed = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: badge.unlocked
                ? badge.bevelColor.withValues(alpha: 0.35)
                : const Color(0xFFE2E8F0),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: badge.unlocked
                  ? badge.bevelColor.withValues(alpha: _pressed ? 0.05 : 0.20)
                  : const Color(0xFFE2E8F0),
              blurRadius: 0,
              offset: Offset(0, _pressed ? 0 : 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DSGamifyBadge(
              emblem: badge.emblem,
              primaryColor: badge.primaryColor,
              bevelColor: badge.bevelColor,
              ribbonColor: const Color(0xFFFFD700),
              ribbonText: badge.ribbonText,
              size: 82,
              isLocked: !badge.unlocked,
            ),
            const SizedBox(height: 8),
            LocalizedText(
              badge.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: badge.unlocked ? AppTheme.darkText : const Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            LocalizedText(
              badge.unlocked ? 'আনলক!' : badge.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: badge.unlocked
                    ? badge.bevelColor
                    : const Color(0xFF94A3B8),
                fontSize: 10,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
