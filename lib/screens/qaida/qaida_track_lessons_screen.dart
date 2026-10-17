import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/qaida/qaida_models.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import 'qaida_activity_screen.dart';

class QaidaTrackLessonsScreen extends StatelessWidget {
  const QaidaTrackLessonsScreen({
    super.key,
    required this.track,
  });

  final QaidaTrackInfo track;

  bool _isLessonUnlocked(AppState state, int lessonIndex) {
    if (state.isAdmin) return true;
    if (lessonIndex == 0) return true;
    final prevLessonId = track.lessons[lessonIndex - 1].id;
    return state.hasCompletedLesson(prevLessonId);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final completedCount = track.lessons
        .where((lesson) => state.hasCompletedLesson(lesson.id))
        .length;
    final progress = track.totalLessons > 0
        ? completedCount / track.totalLessons
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          track.title,
          style: GoogleFonts.hindSiliguri(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: const Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE2E8F0)),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              children: [
                // Track Banner Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        track.color,
                        track.color.withOpacity(0.85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: track.color.withOpacity(0.3),
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
                              color: Colors.white.withOpacity(0.2),
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
                          Text(
                            track.arabicTitle,
                            style: TextStyle(
                              fontFamily: AppTheme.arabicFontFamily,
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
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
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.92),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Progress Bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                backgroundColor: Colors.white.withOpacity(0.25),
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
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      if (state.isAdmin) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.admin_panel_settings,
                                  size: 16, color: Colors.black87),
                              SizedBox(width: 4),
                              Text(
                                'এডমিন মোড — সকল পাঠ আনলকড',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'পাঠ তালিকা (${track.totalLessons}টি পাঠ)',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),

                // Lessons list
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
                ],
              ],
            ),
          ),
        ),
      ),
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
              : null,
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
