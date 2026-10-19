import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/qaida/qaida_models.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/quran_book_mascot.dart';
import '../../widgets/vector_icons.dart';
import 'qaida_activity_screen.dart';

enum TrackViewMode { roadmap, list }

class QaidaTrackLessonsScreen extends StatefulWidget {
  const QaidaTrackLessonsScreen({
    super.key,
    required this.track,
  });

  final QaidaTrackInfo track;

  @override
  State<QaidaTrackLessonsScreen> createState() =>
      _QaidaTrackLessonsScreenState();
}

class _QaidaTrackLessonsScreenState extends State<QaidaTrackLessonsScreen>
    with SingleTickerProviderStateMixin {
  TrackViewMode _viewMode = TrackViewMode.roadmap;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    final isWidgetTest =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isWidgetTest) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  bool _isLessonUnlocked(AppState state, int lessonIndex) {
    if (state.isAdmin) return true;
    if (lessonIndex == 0) return true;
    final prevLessonId = widget.track.lessons[lessonIndex - 1].id;
    return state.hasCompletedLesson(prevLessonId);
  }

  int _findCurrentLessonIndex(AppState state) {
    for (var i = 0; i < widget.track.lessons.length; i++) {
      if (!state.hasCompletedLesson(widget.track.lessons[i].id)) {
        return i;
      }
    }
    return widget.track.lessons.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final track = widget.track;
    final completedCount = track.lessons
        .where((lesson) => state.hasCompletedLesson(lesson.id))
        .length;
    final progress = track.totalLessons > 0
        ? completedCount / track.totalLessons
        : 0.0;
    final currentIndex = _findCurrentLessonIndex(state);

    final modeSwitcher = Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewModeButton(
            icon: Icons.alt_route_rounded,
            label: 'ম্যাপ',
            isSelected: _viewMode == TrackViewMode.roadmap,
            onTap: () => setState(() => _viewMode = TrackViewMode.roadmap),
          ),
          _ViewModeButton(
            icon: Icons.list_alt_rounded,
            label: 'তালিকা',
            isSelected: _viewMode == TrackViewMode.list,
            onTap: () => setState(() => _viewMode = TrackViewMode.list),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              children: [
                DuolingoHeader(
                  title: track.title,
                  subtitle: 'ধাপ ${track.trackNumber} · মোট ${track.totalLessons}টি পাঠ',
                  iconType: VectorIconType.book,
                  gradientColors: const [Color(0xFF58CC02), Color(0xFF46A302)],
                  onBack: () => Navigator.of(context).pop(),
                  trailing: modeSwitcher,
                ),
                // ── Track Banner Header with Respectful Quran Mascot ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        track.color,
                        track.color.withValues(alpha: 0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20), // DS.rXl
                    boxShadow: [
                      BoxShadow(
                        color: track.color.withValues(alpha: 0.3),
                        offset: const Offset(0, 6),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'ট্র্যাক ${track.trackNumber}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                track.arabicTitle,
                                style: TextStyle(
                                  fontFamily: AppTheme.arabicFontFamily,
                                  color: Colors.white.withValues(alpha: 0.95),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(width: 10),
                              const QuranBookMascot(
                                size: 48,
                                mood: QuranMascotMood.idle,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        track.title,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        track.subtitle,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Progress Bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 9,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.25),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            '$completedCount/${track.totalLessons} সম্পন্ন',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: state.isAdmin
                              ? Colors.amber.shade400
                              : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: state.isAdmin
                                ? Colors.amber.shade600
                                : Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  state.isAdmin
                                      ? Icons.lock_open_rounded
                                      : Icons.lock_outline_rounded,
                                  size: 16,
                                  color: state.isAdmin ? Colors.black87 : Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  state.isAdmin
                                      ? 'এডমিন মোড: সকল পাঠ উন্মুক্ত'
                                      : 'লক মোড: ক্রমান্বয়ে আনলক',
                                  style: TextStyle(
                                    color: state.isAdmin ? Colors.black87 : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () async {
                                await state.toggleAdminMode();
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: state.isAdmin ? Colors.black87 : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  state.isAdmin ? 'লক মোড' : 'সব আনলক',
                                  style: TextStyle(
                                    color: state.isAdmin ? Colors.white : const Color(0xFF0F766E),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── ROADMAP VIEW (Winding Path) ──
                if (_viewMode == TrackViewMode.roadmap) ...[
                  _WindingTrackRoad(
                    track: track,
                    state: state,
                    currentIndex: currentIndex,
                    pulseController: _pulseController,
                    isTablet: tablet,
                  ),
                ] else ...[
                  // ── LIST VIEW (Classic Tabular) ──
                  Text(
                    'পাঠ তালিকা (${track.totalLessons}টি পাঠ)',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < track.lessons.length; i++) ...[
                    _LessonTile(
                      lesson: track.lessons[i],
                      nextLesson: i < track.lessons.length - 1
                          ? track.lessons[i + 1]
                          : null,
                      isUnlocked: _isLessonUnlocked(state, i),
                      isCompleted: state.hasCompletedLesson(track.lessons[i].id),
                      trackColor: track.color,
                    ),
                    const SizedBox(height: 10),
                    if ((i + 1) % 5 == 0 && (i + 1) < track.lessons.length) ...[
                      _CheckpointExamTile(
                        blockNumber: (i + 1) ~/ 5,
                        track: track,
                        isUnlocked: state.isAdmin ||
                            state.hasCompletedLesson(track.lessons[i].id),
                        isPassed: state.hasCompletedLesson(
                            '${track.id}_checkpoint_${(i + 1) ~/ 5}'),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                  const SizedBox(height: 6),
                  _TrackFinalExamTile(
                    track: track,
                    isUnlocked: state.isAdmin ||
                        track.lessons.every((l) => state.hasCompletedLesson(l.id)),
                    isPassed: state.hasCompletedLesson('${track.id}_final'),
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  const _ViewModeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? const Color(0xFF0F172A)
                  : const Color(0xFF64748B),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// WINDING TRACK ROAD COMPONENT (Duolingo-style curving path)
// =============================================================================

class _WindingTrackRoad extends StatelessWidget {
  const _WindingTrackRoad({
    required this.track,
    required this.state,
    required this.currentIndex,
    required this.pulseController,
    required this.isTablet,
  });

  final QaidaTrackInfo track;
  final AppState state;
  final int currentIndex;
  final AnimationController pulseController;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    // Generate combined path entries (Lessons + Checkpoints + Track Final)
    final items = <_RoadItem>[];
    for (var i = 0; i < track.lessons.length; i++) {
      items.add(_RoadItem.lesson(track.lessons[i], i));
      if ((i + 1) % 5 == 0 && (i + 1) < track.lessons.length) {
        items.add(_RoadItem.checkpoint((i + 1) ~/ 5));
      }
    }
    items.add(_RoadItem.finalExam());

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        // Keep node (radius ~43px) safely inside boundaries with at least 16px padding on both sides
        final safeSpread =
            ((availableWidth / 2) - 62.0).clamp(24.0, isTablet ? 95.0 : 64.0);

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            // Background Cobblestone Line Connector
            Positioned.fill(
              child: CustomPaint(
                painter: _WindingRoadPainter(
                  itemCount: items.length,
                  maxSpread: safeSpread,
                  trackColor: track.color,
                ),
              ),
            ),

            // Nodes (Each row is full-width centered so (centerX + xShift) matches the painter exactly)
            SizedBox(
              width: availableWidth,
              child: Column(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    _buildRoadNode(
                        context, items[i], i, safeSpread, availableWidth),
                    const SizedBox(height: 18),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRoadNode(BuildContext context, _RoadItem item, int index,
      double maxSpread, double totalWidth) {
    final xShift = math.sin(index * 0.95) * maxSpread;

    Widget nodeWidget;
    if (item.isCheckpoint) {
      final block = item.checkpointBlock!;
      final isUnlocked = state.isAdmin ||
          (block * 5 - 1 < track.lessons.length &&
              state.hasCompletedLesson(track.lessons[block * 5 - 1].id));
      final isPassed =
          state.hasCompletedLesson('${track.id}_checkpoint_$block');

      nodeWidget = _CheckpointRoadNode(
        blockNumber: block,
        track: track,
        isUnlocked: isUnlocked,
        isPassed: isPassed,
      );
    } else if (item.isFinalExam) {
      final isUnlocked = state.isAdmin ||
          track.lessons.every((l) => state.hasCompletedLesson(l.id));
      final isPassed = state.hasCompletedLesson('${track.id}_final');

      nodeWidget = _FinalExamRoadNode(
        track: track,
        isUnlocked: isUnlocked,
        isPassed: isPassed,
      );
    } else {
      // Regular Lesson Node
      final lesson = item.lesson!;
      final lessonIdx = item.lessonIndex!;
      final isUnlocked = state.isAdmin ||
          lessonIdx == 0 ||
          state.hasCompletedLesson(track.lessons[lessonIdx - 1].id);
      final isCompleted = state.hasCompletedLesson(lesson.id);
      final isCurrent = lessonIdx == currentIndex && isUnlocked && !isCompleted;

      nodeWidget = _LessonRoadNode(
        lesson: lesson,
        nextLesson: lessonIdx < track.lessons.length - 1
            ? track.lessons[lessonIdx + 1]
            : null,
        trackColor: track.color,
        isUnlocked: isUnlocked,
        isCompleted: isCompleted,
        isCurrent: isCurrent,
        pulseController: pulseController,
      );
    }

    return SizedBox(
      width: totalWidth,
      child: Center(
        child: Transform.translate(
          offset: Offset(xShift, 0),
          child: nodeWidget,
        ),
      ),
    );
  }
}

class _RoadItem {
  _RoadItem._({
    this.lesson,
    this.lessonIndex,
    this.checkpointBlock,
    this.isFinalExam = false,
  });

  factory _RoadItem.lesson(QaidaLessonInfo lesson, int index) =>
      _RoadItem._(lesson: lesson, lessonIndex: index);

  factory _RoadItem.checkpoint(int block) =>
      _RoadItem._(checkpointBlock: block);

  factory _RoadItem.finalExam() => _RoadItem._(isFinalExam: true);

  final QaidaLessonInfo? lesson;
  final int? lessonIndex;
  final int? checkpointBlock;
  final bool isFinalExam;

  bool get isCheckpoint => checkpointBlock != null;
}

// ── Cobblestone Road Painter ──
class _WindingRoadPainter extends CustomPainter {
  _WindingRoadPainter({
    required this.itemCount,
    required this.maxSpread,
    required this.trackColor,
  });

  final int itemCount;
  final double maxSpread;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (itemCount <= 1) return;

    final roadPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final dashPaint = Paint()
      ..color = trackColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final itemHeight = size.height / itemCount;
    final centerX = size.width / 2;

    for (var i = 0; i < itemCount; i++) {
      final x = centerX + (math.sin(i * 0.95) * maxSpread);
      final y = (i * itemHeight) + (itemHeight * 0.38);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = centerX + (math.sin((i - 1) * 0.95) * maxSpread);
        final prevY = ((i - 1) * itemHeight) + (itemHeight * 0.38);
        final midY = (prevY + y) / 2;
        path.cubicTo(prevX, midY, x, midY, x, y);
      }
    }

    canvas.drawPath(path, roadPaint);
    canvas.drawPath(path, dashPaint);
  }

  @override
  bool shouldRepaint(covariant _WindingRoadPainter oldDelegate) =>
      oldDelegate.itemCount != itemCount ||
      oldDelegate.maxSpread != maxSpread ||
      oldDelegate.trackColor != trackColor;
}

// ── 3D Lesson Circular Node on Road ──
class _LessonRoadNode extends StatelessWidget {
  const _LessonRoadNode({
    required this.lesson,
    this.nextLesson,
    required this.trackColor,
    required this.isUnlocked,
    required this.isCompleted,
    required this.isCurrent,
    required this.pulseController,
  });

  final QaidaLessonInfo lesson;
  final QaidaLessonInfo? nextLesson;
  final Color trackColor;
  final bool isUnlocked;
  final bool isCompleted;
  final bool isCurrent;
  final AnimationController pulseController;

  @override
  Widget build(BuildContext context) {
    const nodeSize = 72.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current Node: mini mascot floating indicator
        if (isCurrent) ...[
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              final bob = math.sin(pulseController.value * math.pi) * 4;
              return Transform.translate(
                offset: Offset(0, bob),
                child: child,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF0F766E),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QuranBookMascot(size: 20, mood: QuranMascotMood.glowing),
                  SizedBox(width: 4),
                  Text(
                    'শুরু করো!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // 3D Circular Button Node
        GestureDetector(
          onTap: isUnlocked
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QaidaActivityScreen(
                        lesson: lesson,
                        nextLesson: nextLesson,
                      ),
                    ),
                  );
                }
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('আগের পাঠ সফলভাবে শেষ করে এই পাঠে পৌঁছাও।'),
                      duration: const Duration(seconds: 4),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'অ্যাডমিন আনলক',
                        textColor: Colors.amber,
                        onPressed: () async {
                          await context.read<AppState>().setUserRole('admin');
                        },
                      ),
                    ),
                  );
                },
          child: Container(
            width: nodeSize,
            height: nodeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? AppTheme.duoGreen
                  : (isUnlocked ? trackColor : const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: isCompleted
                      ? AppTheme.duoGreenDark
                      : (isUnlocked
                          ? trackColor.withValues(alpha: 0.75)
                          : const Color(0xFFCBD5E1)),
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                ),
                if (isCurrent)
                  BoxShadow(
                    color: trackColor.withValues(alpha: 0.35),
                    offset: const Offset(0, 0),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
              ],
            ),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Completed: 3 small golden stars on top
                if (isCompleted)
                  const Positioned(
                    top: 6,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded,
                            size: 11, color: Color(0xFFFFD700)),
                        Icon(Icons.star_rounded,
                            size: 13, color: Color(0xFFFFD700)),
                        Icon(Icons.star_rounded,
                            size: 11, color: Color(0xFFFFD700)),
                      ],
                    ),
                  ),

                // Center Arabic / Icon
                if (isUnlocked)
                  Padding(
                    padding: EdgeInsets.only(top: isCompleted ? 8 : 0),
                    child: Text(
                      lesson.arabicDisplay,
                      style: const TextStyle(
                        fontFamily: AppTheme.arabicFontFamily,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  )
                else
                  const Icon(
                    Icons.lock_rounded,
                    color: Color(0xFF94A3B8),
                    size: 26,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Title Label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Text(
            'পাঠ ${lesson.lessonNumber}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isUnlocked
                  ? const Color(0xFF1E293B)
                  : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Helper builders for Checkpoint and Track Final exams ──
QaidaLessonInfo _buildCheckpointExamLesson(
    QaidaTrackInfo track, int blockNumber) {
  final startIdx = (blockNumber - 1) * 5;
  final endIdx = (blockNumber * 5).clamp(0, track.lessons.length);
  final blockLessons = track.lessons.sublist(startIdx, endIdx);

  return QaidaLessonInfo(
    id: '${track.id}_checkpoint_$blockNumber',
    trackId: track.id,
    lessonNumber: blockNumber,
    title: 'চেকপয়েন্ট পরীক্ষা $blockNumber',
    subtitle: 'পাঠ ${startIdx + 1} থেকে $endIdx এর মূল্যায়ন',
    arabicDisplay: 'امْتِحَان',
    description:
        'পূর্ববর্তী ৫টি পাঠের অর্জিত জ্ঞান যাচাই করুন। পাস নম্বর: ৮০/১০০।',
    isCheckpoint: true,
    activities: List.generate(10, (qIdx) {
      final refLesson = blockLessons[qIdx % blockLessons.length];
      final otherLessons = track.lessons
          .where((l) => l.arabicDisplay != refLesson.arabicDisplay)
          .toList();
      final d1 = otherLessons.isNotEmpty
          ? otherLessons[(qIdx * 2 + 1) % otherLessons.length].arabicDisplay
          : 'ب';
      final d2 = otherLessons.length > 1
          ? otherLessons[(qIdx * 2 + 2) % otherLessons.length].arabicDisplay
          : 'ت';

      final correctPos = qIdx % 3;
      final options = <String>[];
      if (correctPos == 0) {
        options.addAll([refLesson.arabicDisplay, d1, d2]);
      } else if (correctPos == 1) {
        options.addAll([d1, refLesson.arabicDisplay, d2]);
      } else {
        options.addAll([d1, d2, refLesson.arabicDisplay]);
      }

      return QaidaActivity(
        id: '${track.id}_cp_${blockNumber}_q$qIdx',
        slotNumber: qIdx + 1,
        type: QaidaActivityType.checkpointExam,
        prompt:
            'চেকপয়েন্ট প্রশ্ন ${qIdx + 1}: ${refLesson.title}-এর সঠিক আরবি রূপ কোনটি?',
        arabicTarget: refLesson.arabicDisplay,
        options: options,
        correctIndex: correctPos,
        explanation: 'সঠিক! এটি ${refLesson.title}।',
      );
    }),
  );
}

QaidaLessonInfo _buildTrackFinalExamLesson(QaidaTrackInfo track) {
  return QaidaLessonInfo(
    id: '${track.id}_final',
    trackId: track.id,
    lessonNumber: track.totalLessons + 1,
    title: '${track.title} - চূড়ান্ত পরীক্ষা',
    subtitle: 'ট্র্যাক ${track.trackNumber} সমাপনী মূল্যায়ন',
    arabicDisplay: 'النِّهَايَة',
    description:
        'সম্পূর্ণ ট্র্যাকের সকল পাঠ থেকে সমন্বিত প্রশ্ন। পাস করলে পরবর্তী ট্র্যাক উন্মুক্ত হবে।',
    isTrackFinal: true,
    activities: List.generate(10, (qIdx) {
      final refLesson = track.lessons[qIdx % track.lessons.length];
      final otherLessons = track.lessons
          .where((l) => l.arabicDisplay != refLesson.arabicDisplay)
          .toList();
      final d1 = otherLessons.isNotEmpty
          ? otherLessons[(qIdx * 3 + 1) % otherLessons.length].arabicDisplay
          : 'ل';
      final d2 = otherLessons.length > 1
          ? otherLessons[(qIdx * 3 + 2) % otherLessons.length].arabicDisplay
          : 'م';

      final correctPos = qIdx % 3;
      final options = <String>[];
      if (correctPos == 0) {
        options.addAll([refLesson.arabicDisplay, d1, d2]);
      } else if (correctPos == 1) {
        options.addAll([d1, refLesson.arabicDisplay, d2]);
      } else {
        options.addAll([d1, d2, refLesson.arabicDisplay]);
      }

      return QaidaActivity(
        id: '${track.id}_final_q$qIdx',
        slotNumber: qIdx + 1,
        type: QaidaActivityType.trackFinalExam,
        prompt:
            'চূড়ান্ত প্রশ্ন ${qIdx + 1}: ${refLesson.title}-এর সঠিক রূপ/বিধান কোনটি?',
        arabicTarget: refLesson.arabicDisplay,
        options: options,
        correctIndex: correctPos,
        explanation: 'মাশাআল্লাহ! আপনি সঠিক উত্তর দিয়েছেন।',
      );
    }),
  );
}

// ── Checkpoint Chest Node on Road ──
class _CheckpointRoadNode extends StatelessWidget {
  const _CheckpointRoadNode({
    required this.blockNumber,
    required this.track,
    required this.isUnlocked,
    required this.isPassed,
  });

  final int blockNumber;
  final QaidaTrackInfo track;
  final bool isUnlocked;
  final bool isPassed;

  @override
  Widget build(BuildContext context) {
    final examLesson = _buildCheckpointExamLesson(track, blockNumber);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isUnlocked
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QaidaActivityScreen(lesson: examLesson),
                    ),
                  );
                }
              : null,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isPassed
                    ? [const Color(0xFF10B981), const Color(0xFF059669)]
                    : (isUnlocked
                        ? [const Color(0xFFF59E0B), const Color(0xFFD97706)]
                        : [const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)]),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: isPassed
                      ? const Color(0xFF047857)
                      : (isUnlocked
                          ? const Color(0xFFB45309)
                          : const Color(0xFF94A3B8)),
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              isPassed
                  ? Icons.workspace_premium_rounded
                  : (isUnlocked
                      ? Icons.redeem_rounded
                      : Icons.lock_rounded),
              color: isUnlocked ? Colors.white : const Color(0xFF94A3B8),
              size: 34,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isPassed ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isPassed ? const Color(0xFF86EFAC) : const Color(0xFFFDE68A),
            ),
          ),
          child: Text(
            isPassed ? 'চেকপয়েন্ট $blockNumber ✓' : 'চেকপয়েন্ট পরীক্ষা $blockNumber',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color:
                  isPassed ? const Color(0xFF15803D) : const Color(0xFFB45309),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Track Final Exam Castle/Trophy Node ──
class _FinalExamRoadNode extends StatelessWidget {
  const _FinalExamRoadNode({
    required this.track,
    required this.isUnlocked,
    required this.isPassed,
  });

  final QaidaTrackInfo track;
  final bool isUnlocked;
  final bool isPassed;

  @override
  Widget build(BuildContext context) {
    final finalExamLesson = _buildTrackFinalExamLesson(track);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isUnlocked
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          QaidaActivityScreen(lesson: finalExamLesson),
                    ),
                  );
                }
              : null,

          child: Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isPassed
                    ? [const Color(0xFFF59E0B), const Color(0xFFD97706)]
                    : (isUnlocked
                        ? [const Color(0xFF6366F1), const Color(0xFF4F46E5)]
                        : [const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)]),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: isPassed
                      ? const Color(0xFFB45309)
                      : (isUnlocked
                          ? const Color(0xFF3730A3)
                          : const Color(0xFF94A3B8)),
                  offset: const Offset(0, 6),
                  blurRadius: 0,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              isPassed
                  ? Icons.emoji_events_rounded
                  : (isUnlocked
                      ? Icons.military_tech_rounded
                      : Icons.lock_rounded),
              color: Colors.white,
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isPassed ? const Color(0xFFFEF3C7) : const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  isPassed ? const Color(0xFFFDE68A) : const Color(0xFFC7D2FE),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPassed) ...[
                const VectorIcon(
                  type: VectorIconType.trophy,
                  size: 14,
                  color: Color(0xFFB45309),
                ),
                const SizedBox(width: 5),
              ],
              Text(
                isPassed ? 'ট্র্যাক ${track.trackNumber} সমাপনী উত্তীর্ণ!' : 'চূড়ান্ত পরীক্ষা',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color:
                      isPassed ? const Color(0xFFB45309) : const Color(0xFF4338CA),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.lesson,
    this.nextLesson,
    required this.isUnlocked,
    required this.isCompleted,
    required this.trackColor,
  });

  final QaidaLessonInfo lesson;
  final QaidaLessonInfo? nextLesson;
  final bool isUnlocked;
  final bool isCompleted;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? AppTheme.duoGreen.withOpacity(0.5)
              : (isUnlocked
                  ? const Color(0xFFE2E8F0)
                  : const Color(0xFFCBD5E1)),
          width: isCompleted ? 2 : 1.5,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isUnlocked
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QaidaActivityScreen(
                        lesson: lesson,
                        nextLesson: nextLesson,
                      ),
                    ),
                  );
                }
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('পাঠটি লক করা রয়েছে।'),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'অ্যাডমিন আনলক',
                        textColor: Colors.amber,
                        onPressed: () async {
                          await context.read<AppState>().setUserRole('admin');
                        },
                      ),
                    ),
                  );
                },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Status icon circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.duoGreen
                        : (isUnlocked
                            ? trackColor.withOpacity(0.12)
                            : const Color(0xFFE2E8F0)),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: isCompleted
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 26)
                      : (isUnlocked
                          ? Icon(Icons.play_arrow_rounded,
                              color: trackColor, size: 28)
                          : const Icon(Icons.lock_rounded,
                              color: Color(0xFF94A3B8), size: 20)),
                ),
                const SizedBox(width: 14),

                // Lesson details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'পাঠ ${lesson.lessonNumber}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                          if (isCompleted) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'সম্পন্ন',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lesson.title,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      Text(
                        lesson.subtitle,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 13,
                          color: isUnlocked
                              ? const Color(0xFF64748B)
                              : const Color(0xFFA1A1AA),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Arabic snippet chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? const Color(0xFFF8FAFC)
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isUnlocked
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: Text(
                    lesson.arabicDisplay,
                    style: TextStyle(
                      fontFamily: AppTheme.arabicFontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked
                          ? const Color(0xFF1E293B)
                          : const Color(0xFF94A3B8),
                    ),
                    textDirection: TextDirection.rtl,
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

class _CheckpointExamTile extends StatelessWidget {
  const _CheckpointExamTile({
    required this.blockNumber,
    required this.track,
    required this.isUnlocked,
    required this.isPassed,
  });

  final int blockNumber;
  final QaidaTrackInfo track;
  final bool isUnlocked;
  final bool isPassed;

  @override
  Widget build(BuildContext context) {
    final examLesson = _buildCheckpointExamLesson(track, blockNumber);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isUnlocked ? const Color(0xFFFFFBEB) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPassed
              ? const Color(0xFF10B981)
              : (isUnlocked
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFFCBD5E1)),
          width: isPassed ? 2 : 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isUnlocked
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QaidaActivityScreen(lesson: examLesson),
                    ),
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isPassed
                        ? const Color(0xFF10B981)
                        : (isUnlocked
                            ? const Color(0xFFF59E0B).withValues(alpha: 0.15)
                            : const Color(0xFFE2E8F0)),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isPassed
                        ? Icons.workspace_premium_rounded
                        : (isUnlocked
                            ? Icons.assignment_turned_in_rounded
                            : Icons.lock_rounded),
                    color: isPassed
                        ? Colors.white
                        : (isUnlocked
                            ? const Color(0xFFD97706)
                            : const Color(0xFF94A3B8)),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isPassed
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isPassed
                                  ? 'পাস (১০০/১০০)'
                                  : 'চেকপয়েন্ট পরীক্ষা $blockNumber',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isPassed
                                    ? const Color(0xFF15803D)
                                    : const Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        examLesson.subtitle,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked
                              ? const Color(0xFF78350F)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isPassed
                      ? Icons.check_circle_rounded
                      : (isUnlocked
                          ? Icons.play_circle_fill_rounded
                          : Icons.lock_outline_rounded),
                  color: isPassed
                      ? const Color(0xFF10B981)
                      : (isUnlocked
                          ? const Color(0xFFD97706)
                          : const Color(0xFF94A3B8)),
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrackFinalExamTile extends StatelessWidget {
  const _TrackFinalExamTile({
    required this.track,
    required this.isUnlocked,
    required this.isPassed,
  });

  final QaidaTrackInfo track;
  final bool isUnlocked;
  final bool isPassed;

  @override
  Widget build(BuildContext context) {
    final finalExamLesson = _buildTrackFinalExamLesson(track);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUnlocked
              ? [const Color(0xFFFDF4FF), const Color(0xFFFAF5FF)]
              : [const Color(0xFFF1F5F9), const Color(0xFFF1F5F9)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPassed
              ? const Color(0xFF10B981)
              : (isUnlocked
                  ? const Color(0xFFC084FC)
                  : const Color(0xFFCBD5E1)),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isUnlocked
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          QaidaActivityScreen(lesson: finalExamLesson),
                    ),
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: isPassed
                      ? const Color(0xFF10B981)
                      : (isUnlocked
                          ? const Color(0xFFA855F7)
                          : const Color(0xFFCBD5E1)),
                  child: Icon(
                    isPassed
                        ? Icons.military_tech_rounded
                        : (isUnlocked
                            ? Icons.emoji_events_rounded
                            : Icons.lock_rounded),
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'ট্র্যাক ফাইনাল পরীক্ষা',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked
                                  ? const Color(0xFF9333EA)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                          if (isPassed) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'সার্টিফায়েড',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${track.title} সম্পূর্ণ মূল্যায়ন',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked
                              ? const Color(0xFF581C87)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isPassed
                      ? Icons.check_circle_rounded
                      : Icons.arrow_forward_ios_rounded,
                  color: isPassed
                      ? const Color(0xFF10B981)
                      : (isUnlocked
                          ? const Color(0xFFA855F7)
                          : const Color(0xFFCBD5E1)),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

