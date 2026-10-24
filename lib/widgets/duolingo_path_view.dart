import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../utils/app_state.dart';
import '../screens/qaida/qaida_letters.dart';
import '../screens/qaida/qaida_lesson_screen.dart';
import '../screens/qaida/qaida_next_course_screen.dart';
import 'vector_icons.dart';
import 'vector_mascot.dart';
import 'duolingo_button.dart';

/// Item on the Duolingo gamified winding learning path.
enum PathItemType {
  lesson,
  chest,
  unitHeader,
}

class PathItemData {
  const PathItemData({
    required this.type,
    this.lessonIndex,
    this.courseIndex,
    this.chestId,
    this.chestRewardXp = 25,
    this.unitNumber,
    this.unitTitle,
    this.unitSubtitle,
  });

  final PathItemType type;
  final int? lessonIndex;
  final int? courseIndex;
  final String? chestId;
  final int chestRewardXp;
  final int? unitNumber;
  final String? unitTitle;
  final String? unitSubtitle;

  bool get isLetterLesson => lessonIndex != null;
  bool get isCourseLesson => courseIndex != null;
}

/// The full Duolingo-style vertical winding roadmap.
class DuolingoPathView extends StatefulWidget {
  const DuolingoPathView({
    super.key,
    this.isTablet = false,
    this.isActive = true,
  });

  final bool isTablet;
  final bool isActive;

  @override
  State<DuolingoPathView> createState() => _DuolingoPathViewState();
}

class _DuolingoPathViewState extends State<DuolingoPathView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final List<PathItemData> _items;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _items = _generatePathItems();
    _syncPulseAnimation();
  }

  @override
  void didUpdateWidget(covariant DuolingoPathView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) _syncPulseAnimation();
  }

  void _syncPulseAnimation() {
    final isWidgetTest =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!widget.isActive || isWidgetTest) {
      _pulseController.stop();
    } else {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  static List<PathItemData> _generatePathItems() {
    final list = <PathItemData>[];

    // Unit 1: Alif to Khaa (Lessons 0 to 6)
    list.add(const PathItemData(
      type: PathItemType.unitHeader,
      unitNumber: 1,
      unitTitle: 'path.unit_1_title',
      unitSubtitle: 'path.unit_1_subtitle',
    ));
    for (var i = 0; i <= 6; i++) {
      list.add(PathItemData(type: PathItemType.lesson, lessonIndex: i));
    }
    list.add(const PathItemData(
      type: PathItemType.chest,
      chestId: 'chest_unit_1',
      chestRewardXp: 30,
    ));

    // Unit 2: Dal to Saad (Lessons 7 to 13)
    list.add(const PathItemData(
      type: PathItemType.unitHeader,
      unitNumber: 2,
      unitTitle: 'path.unit_2_title',
      unitSubtitle: 'path.unit_2_subtitle',
    ));
    for (var i = 7; i <= 13; i++) {
      list.add(PathItemData(type: PathItemType.lesson, lessonIndex: i));
    }
    list.add(const PathItemData(
      type: PathItemType.chest,
      chestId: 'chest_unit_2',
      chestRewardXp: 35,
    ));

    // Unit 3: Daad to Kaaf (Lessons 14 to 21)
    list.add(const PathItemData(
      type: PathItemType.unitHeader,
      unitNumber: 3,
      unitTitle: 'path.unit_3_title',
      unitSubtitle: 'path.unit_3_subtitle',
    ));
    for (var i = 14; i <= 21; i++) {
      list.add(PathItemData(type: PathItemType.lesson, lessonIndex: i));
    }
    list.add(const PathItemData(
      type: PathItemType.chest,
      chestId: 'chest_unit_3',
      chestRewardXp: 40,
    ));

    // Unit 4: Laam to Yaa (Lessons 22 to 27)
    list.add(const PathItemData(
      type: PathItemType.unitHeader,
      unitNumber: 4,
      unitTitle: 'path.unit_4_title',
      unitSubtitle: 'path.unit_4_subtitle',
    ));
    for (var i = 22; i <= 27; i++) {
      list.add(PathItemData(type: PathItemType.lesson, lessonIndex: i));
    }
    list.add(const PathItemData(
      type: PathItemType.chest,
      chestId: 'chest_unit_4',
      chestRewardXp: 50,
    ));

    // Unit 5: Higher Qaida Courses
    list.add(const PathItemData(
      type: PathItemType.unitHeader,
      unitNumber: 5,
      unitTitle: 'path.unit_5_title',
      unitSubtitle: 'path.unit_5_subtitle',
    ));
    for (var c = 0; c < qaidaCourseCount; c++) {
      list.add(PathItemData(type: PathItemType.lesson, courseIndex: c));
      if (c == 1 || c == 3) {
        list.add(PathItemData(
          type: PathItemType.chest,
          chestId: 'chest_course_$c',
          chestRewardXp: 50,
        ));
      }
    }

    return list;
  }

  int _findCurrentItemIndex(AppState state) {
    // Return index of the first incomplete and unlocked lesson
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (item.type != PathItemType.lesson) continue;

      if (item.isLetterLesson) {
        final lesson = qaidaLetters[item.lessonIndex!];
        if (!state.hasCompletedLesson(lesson.id)) {
          return i;
        }
      } else if (item.isCourseLesson) {
        final courseId = 'qaida_course_${item.courseIndex}';
        if (!state.hasCompletedLesson(courseId)) {
          return i;
        }
      }
    }
    return -1; // All completed!
  }

  bool _isItemUnlocked(AppState state, PathItemData item, int itemIndex) {
    if (state.isAdmin) return true; // All lessons, quizzes and chests unlocked for admin
    if (item.type == PathItemType.unitHeader) return true;

    if (item.type == PathItemType.chest) {
      // Unlocked if all previous lessons are completed
      for (var i = itemIndex - 1; i >= 0; i--) {
        final prev = _items[i];
        if (prev.type == PathItemType.unitHeader) break;
        if (prev.type == PathItemType.lesson) {
          if (prev.isLetterLesson &&
              !state.hasCompletedLesson(qaidaLetters[prev.lessonIndex!].id)) {
            return false;
          }
          if (prev.isCourseLesson &&
              !state.hasCompletedLesson('qaida_course_${prev.courseIndex}')) {
            return false;
          }
        }
      }
      return true;
    }

    // For lesson nodes:
    if (item.isLetterLesson) {
      final index = item.lessonIndex!;
      if (index == 0) return true;
      return state.hasCompletedLesson(qaidaLetters[index - 1].id);
    }

    if (item.isCourseLesson) {
      final courseIdx = item.courseIndex!;
      // Need all 28 letters complete
      final allLettersDone =
          qaidaLetters.every((l) => state.hasCompletedLesson(l.id));
      if (!allLettersDone) return false;
      if (courseIdx == 0) return true;
      return state.hasCompletedLesson('qaida_course_${courseIdx - 1}');
    }

    return false;
  }

  bool _isItemCompleted(AppState state, PathItemData item) {
    if (item.type == PathItemType.unitHeader) return false;
    if (item.type == PathItemType.chest) {
      return state.hasOpenedChest(item.chestId!);
    }
    if (item.isLetterLesson) {
      return state.hasCompletedLesson(qaidaLetters[item.lessonIndex!].id);
    }
    if (item.isCourseLesson) {
      return state.hasCompletedLesson('qaida_course_${item.courseIndex}');
    }
    return false;
  }

  void _onNodeTapped(BuildContext context, PathItemData item, bool isUnlocked) {
    if (!isUnlocked) {
      _showLockedDialog(context);
      return;
    }

    if (item.type == PathItemType.chest) {
      _openChestDialog(context, item);
      return;
    }

    if (item.isLetterLesson) {
      _openQaidaLesson(context, letterIndex: item.lessonIndex!);
      return;
    }

    if (item.isCourseLesson) {
      _openCourseLesson(context, item.courseIndex!);
      return;
    }
  }

  void _showLockedDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFBF8F2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconBadge(
              type: VectorIconType.lock,
              bgColor: Color(0xFFE5E7EB),
              iconColor: Color(0xFF6B7280),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              context.t('path.step_locked'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.t('path.step_locked_desc'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Duolingo3DButton(
              text: context.t('path.got_it'),
              onPressed: () => Navigator.pop(ctx),
              color: const Color(0xFF58CC02),
              shadowColor: const Color(0xFF46A302),
              height: 46,
            ),
          ],
        ),
      ),
    );
  }

  void _openChestDialog(BuildContext context, PathItemData item) {
    final state = context.read<AppState>();
    final alreadyOpened = state.hasOpenedChest(item.chestId!);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFBEB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFFFDE68A), width: 2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VectorMascot(
              size: 90,
              mood: alreadyOpened ? MascotMood.happy : MascotMood.celebrating,
            ),
            const SizedBox(height: 12),
            VectorIcon(
              type: alreadyOpened
                  ? VectorIconType.chestOpen
                  : VectorIconType.chest,
              size: 64,
            ),
            const SizedBox(height: 12),
            Text(
              alreadyOpened
                  ? context.t('path.gift_claimed')
                  : context.t('path.milestone_congrats'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              alreadyOpened
                  ? context.t('path.chest_collected_xp', params: {'xp': item.chestRewardXp})
                  : context.t('path.chest_reward_xp', params: {'xp': item.chestRewardXp}),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5D4037),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            if (!alreadyOpened)
              Duolingo3DButton.gold(
                text: context.t('path.claim_xp', params: {'xp': item.chestRewardXp}),
                onPressed: () {
                  state.openChest(item.chestId!, xp: item.chestRewardXp);
                  Navigator.pop(ctx);
                },
              )
            else
              Duolingo3DButton(
                text: context.t('path.continue'),
                onPressed: () => Navigator.pop(ctx),
                height: 48,
              ),
          ],
        ),
      ),
    );
  }

  void _openQaidaLesson(BuildContext context, {required int letterIndex}) {
    final lesson = qaidaLetters[letterIndex];
    final nextIndex = letterIndex + 1;
    final next =
        nextIndex < qaidaLetters.length ? qaidaLetters[nextIndex] : null;

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

  void _openCourseLesson(BuildContext context, int courseIndex) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => QaidaNextCourseScreen(
        initialIndex: courseIndex,
        stopAfterIndex: courseIndex,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final selectedState = context.select<AppState, (AppState, String)>(
      (state) => (state, _progressSignature(state)),
    );
    final state = selectedState.$1;
    final currentIndex = _findCurrentItemIndex(state);
    final isTablet = widget.isTablet;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        children: [
          // Background winding stone road custom painter
          Positioned.fill(
            child: CustomPaint(
              painter: _PathCobblestonePainter(
                itemCount: _items.length,
                isTablet: isTablet,
              ),
            ),
          ),
          // Path Items ListView
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: _items.length,
            itemBuilder: (context, i) {
              final item = _items[i];
              final isUnlocked = _isItemUnlocked(state, item, i);
              final isCompleted = _isItemCompleted(state, item);
              final isCurrent = i == currentIndex && !isCompleted && isUnlocked;

              // Sinusoidal wave X offset
              final double waveOffset = math.sin(i * 0.95);
              final double maxSpread = isTablet ? 110 : 80;
              final double xShift = waveOffset * maxSpread;

              if (item.type == PathItemType.unitHeader) {
                return _UnitSignboard(
                  unitNumber: item.unitNumber ?? 1,
                  title: item.unitTitle ?? '',
                  subtitle: item.unitSubtitle ?? '',
                  isTablet: isTablet,
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Transform.translate(
                  offset: Offset(xShift, 0),
                  child: Center(
                    child: item.type == PathItemType.chest
                        ? _MilestoneChestNode(
                            item: item,
                            isUnlocked: isUnlocked,
                            isOpened: isCompleted,
                            onTap: () =>
                                _onNodeTapped(context, item, isUnlocked),
                          )
                        : _DuolingoNodeWidget(
                            item: item,
                            isUnlocked: isUnlocked,
                            isCompleted: isCompleted,
                            isCurrent: isCurrent,
                            pulseController: _pulseController,
                            onTap: () =>
                                _onNodeTapped(context, item, isUnlocked),
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _progressSignature(AppState state) => _items
      .asMap()
      .entries
      .map((entry) =>
          '${_isItemUnlocked(state, entry.value, entry.key) ? 1 : 0}${_isItemCompleted(state, entry.value) ? 1 : 0}')
      .join();
}

/// The wooden signboard dividing units on the path (Reference 1: "第1单元")
class _UnitSignboard extends StatelessWidget {
  const _UnitSignboard({
    required this.unitNumber,
    required this.title,
    required this.subtitle,
    required this.isTablet,
  });

  final int unitNumber;
  final String title;
  final String subtitle;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 48 : 24,
        vertical: 24,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF58CC02),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF46A302),
            offset: Offset(0, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t('path.section_unit', params: {'section': unitNumber, 'unit': unitNumber}),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.t(title),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const VectorIcon(
              type: VectorIconType.book,
              size: 22,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular tactile 3D node on the Duolingo path.
class _DuolingoNodeWidget extends StatelessWidget {
  const _DuolingoNodeWidget({
    required this.item,
    required this.isUnlocked,
    required this.isCompleted,
    required this.isCurrent,
    required this.pulseController,
    required this.onTap,
  });

  final PathItemData item;
  final bool isUnlocked;
  final bool isCompleted;
  final bool isCurrent;
  final AnimationController pulseController;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const double nodeSize = 68;

    // Node colors
    Color faceColor;
    Color shadowColor;

    if (!isUnlocked) {
      faceColor = const Color(0xFFE5E5E5);
      shadowColor = const Color(0xFFAFAFAF);
    } else if (isCompleted) {
      faceColor = const Color(0xFFFFC800);
      shadowColor = const Color(0xFFE5A100);
    } else {
      faceColor = const Color(0xFF58CC02);
      shadowColor = const Color(0xFF46A302);
    }

    String letterDisplay = '';
    if (item.isLetterLesson) {
      letterDisplay = qaidaLetters[item.lessonIndex!].letter;
    } else if (item.isCourseLesson) {
      letterDisplay = qaidaCourseLetters[item.courseIndex!];
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Duolingo speech bubble flag pointer above the active node
          if (isCurrent)
            AnimatedBuilder(
              animation: pulseController,
              builder: (context, child) {
                final bounce = math.sin(pulseController.value * math.pi) * 6;
                return Transform.translate(
                  offset: Offset(0, -bounce),
                  child: child,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFFE5E7EB), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const LocalizedText(
                      'START',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF58CC02),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  CustomPaint(
                    size: const Size(14, 8),
                    painter: _TrianglePointerPainter(),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),

          // 3D Pressable Node Circle
          SizedBox(
            width: nodeSize,
            height: nodeSize + 8,
            child: Stack(
              children: [
                // Bottom bevel shadow
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: nodeSize,
                  child: Container(
                    decoration: BoxDecoration(
                      color: shadowColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Top circle face
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: nodeSize,
                  child: Container(
                    decoration: BoxDecoration(
                      color: faceColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        if (isCurrent)
                          BoxShadow(
                            color:
                                const Color(0xFF58CC02).withValues(alpha: 0.5),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                      ],
                    ),
                    child: Center(
                      child: !isUnlocked
                          ? const VectorIcon(
                              type: VectorIconType.lock,
                              size: 26,
                              color: Color(0xFF9CA3AF),
                            )
                          : isCompleted
                              ? const VectorIcon(
                                  type: VectorIconType.star,
                                  size: 30,
                                  color: Colors.white,
                                )
                              : LocalizedText(
                                  letterDisplay,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1.1,
                                  ),
                                ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Star rating badge underneath completed nodes
          if (isCompleted) ...[
            const SizedBox(height: 4),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                VectorIcon(
                  type: VectorIconType.star,
                  size: 13,
                  color: Color(0xFFFFC800),
                ),
                SizedBox(width: 2),
                VectorIcon(
                  type: VectorIconType.star,
                  size: 15,
                  color: Color(0xFFFFC800),
                ),
                SizedBox(width: 2),
                VectorIcon(
                  type: VectorIconType.star,
                  size: 13,
                  color: Color(0xFFFFC800),
                ),
              ],
            ),
          ],
          if (item.isLetterLesson) ...[
            const SizedBox(height: 3),
            LocalizedText(
              qaidaLetters[item.lessonIndex!].name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isUnlocked ? AppTheme.darkText : const Color(0xFF9CA3AF),
              ),
            ),
          ] else if (item.isCourseLesson) ...[
            const SizedBox(height: 3),
            LocalizedText(
              getQaidaCourseTitle(context, item.courseIndex!),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isUnlocked ? AppTheme.darkText : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Milestone Treasure Chest sitting on the path.
class _MilestoneChestNode extends StatelessWidget {
  const _MilestoneChestNode({
    required this.item,
    required this.isUnlocked,
    required this.isOpened,
    required this.onTap,
  });

  final PathItemData item;
  final bool isUnlocked;
  final bool isOpened;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isOpened
                  ? const Color(0xFFFFF9C4)
                  : isUnlocked
                      ? const Color(0xFFFFE082)
                      : const Color(0xFFE0E0E0),
              shape: BoxShape.circle,
              border: Border.all(
                color: isOpened
                    ? const Color(0xFFFFD54F)
                    : isUnlocked
                        ? const Color(0xFFFFB300)
                        : const Color(0xFFBDBDBD),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isUnlocked ? const Color(0xFFFFB300) : Colors.grey)
                      .withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: VectorIcon(
              type: isOpened ? VectorIconType.chestOpen : VectorIconType.chest,
              size: 44,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              isOpened
                  ? context.t('path.gift_completed')
                  : isUnlocked
                      ? context.t('path.gift_xp', params: {'xp': item.chestRewardXp})
                      : context.t('path.locked_chest'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isOpened
                    ? const Color(0xFF58A700)
                    : isUnlocked
                        ? const Color(0xFFE6A800)
                        : const Color(0xFF9E9E9E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clean, minimal connector painter — subtle thin curved line on white.
class _PathCobblestonePainter extends CustomPainter {
  _PathCobblestonePainter({
    required this.itemCount,
    required this.isTablet,
  });

  final int itemCount;
  final bool isTablet;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.height <= 0 || itemCount <= 0) return;

    final centerX = size.width / 2;
    final double maxSpread = isTablet ? 110 : 80;
    final rowHeight = size.height / itemCount;

    // Subtle thin connector line between nodes
    final linePaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    for (var i = 0; i < itemCount; i++) {
      final y = (i * rowHeight) + (rowHeight / 2);
      final wave = math.sin(i * 0.95);
      final x = centerX + (wave * maxSpread);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevY = ((i - 1) * rowHeight) + (rowHeight / 2);
        final prevWave = math.sin((i - 1) * 0.95);
        final prevX = centerX + (prevWave * maxSpread);
        final midY = (prevY + y) / 2;
        path.cubicTo(prevX, midY, x, midY, x, y);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _PathCobblestonePainter oldDelegate) =>
      oldDelegate.itemCount != itemCount || oldDelegate.isTablet != isTablet;
}

/// Downward triangle pointer for the START tooltip bubble.
class _TrianglePointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
