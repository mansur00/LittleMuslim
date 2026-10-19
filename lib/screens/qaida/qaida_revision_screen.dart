import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/nurani_qaida_data.dart';
import '../../l10n/app_localizations.dart';
import '../../data/qaida_curriculum_data.dart';
import '../../models/qaida/qaida_models.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/quran_book_mascot.dart';
import '../../widgets/vector_icons.dart';
import 'qaida_activity_screen.dart';

/// Screen for Smart Revision and "Fix My Mistakes" (ভুল সংশোধন)
class QaidaRevisionScreen extends StatefulWidget {
  const QaidaRevisionScreen({super.key});

  @override
  State<QaidaRevisionScreen> createState() => _QaidaRevisionScreenState();
}

class _QaidaRevisionScreenState extends State<QaidaRevisionScreen> {
  int _selectedFilter = 0; // 0: All / Smart, 1: Mistakes, 2: Completed

  QaidaLessonInfo? _resolveLesson(String skillId, List<QaidaLessonInfo> fallbackLessons) {
    for (final s in NuraniQaidaData.steps) {
      for (final l in s.lessons) {
        if (l.id == skillId || l.arabicDisplay == skillId || l.id.contains(skillId)) {
          return l;
        }
      }
    }
    return QaidaCurriculumData.getLessonById(skillId) ??
        fallbackLessons.cast<QaidaLessonInfo?>().firstWhere(
              (l) => l?.arabicDisplay == skillId || (l?.id.contains(skillId) ?? false),
              orElse: () => null,
            );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    final allLessons = NuraniQaidaData.steps.isNotEmpty
        ? NuraniQaidaData.steps.expand((s) => s.lessons).toList()
        : QaidaCurriculumData.tracks.expand((t) => t.lessons).toList();

    final completedLessons = allLessons
        .where((l) => state.hasCompletedLesson(l.id))
        .toList();

    // Map skill progress with mistakes
    final mistakeSkills = state.allSkillProgress.values
        .where((s) => s.incorrectAttempts > 0)
        .toList()
      ..sort((a, b) => b.incorrectAttempts.compareTo(a.incorrectAttempts));

    // Lessons corresponding to mistakes or falling back to recent lessons
    final mistakeLessons = <QaidaLessonInfo>[];
    for (final s in mistakeSkills) {
      final lesson = _resolveLesson(s.skillId, allLessons);
      if (lesson != null && !mistakeLessons.contains(lesson)) {
        mistakeLessons.add(lesson);
      }
    }

    // Due for spaced repetition review
    final dueSkills = state.skillsDueForReview;
    final dueLessons = <QaidaLessonInfo>[];
    for (final s in dueSkills) {
      final lesson = _resolveLesson(s.skillId, allLessons);
      if (lesson != null && !dueLessons.contains(lesson)) {
        dueLessons.add(lesson);
      }
    }

    // Fallback recommendation queue if fresh learner
    final recommendedQueue = completedLessons.isNotEmpty
        ? completedLessons.take(6).toList()
        : allLessons.take(6).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              children: [
                DuolingoHeader(
                  title: 'অনুশীলন ও ভুল সংশোধন',
                  subtitle: 'ভুল হওয়া অক্ষর ও পাঠগুলো আবার অনুশীলন করো',
                  iconType: VectorIconType.shield,
                  gradientColors: const [Color(0xFF58CC02), Color(0xFF46A302)],
                  onBack: () => Navigator.of(context).pop(),
                ),
                // Top Banner with Quran Mascot
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20), // DS.rXl
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const LocalizedText(
                                'স্মার্ট রিভিশন ও সংশোধন',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            LocalizedText(
                              'স্মরণ করি ও ভুল শোধরাই',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LocalizedText(
                              'ভুলগুলো বারবার চর্চা করলে তিলাওয়াত খাঁটি ও সুন্দর হয়। চলো আবার চেষ্টা করি!',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.92),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const QuranBookMascot(
                        size: 72,
                        mood: QuranMascotMood.encouraging,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterTab(
                        label: 'সব রিভিশন',
                        count: dueLessons.isNotEmpty
                            ? dueLessons.length
                            : recommendedQueue.length,
                        isSelected: _selectedFilter == 0,
                        onTap: () => setState(() => _selectedFilter = 0),
                      ),
                      const SizedBox(width: 8),
                      _FilterTab(
                        label: 'ভুল শোধরাই',
                        count: mistakeLessons.length,
                        isAlert: mistakeLessons.isNotEmpty,
                        isSelected: _selectedFilter == 1,
                        onTap: () => setState(() => _selectedFilter = 1),
                      ),
                      const SizedBox(width: 8),
                      _FilterTab(
                        label: 'পড়া পাঠসমূহ',
                        count: completedLessons.length,
                        isSelected: _selectedFilter == 2,
                        onTap: () => setState(() => _selectedFilter = 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Content based on filter
                if (_selectedFilter == 1) ...[
                  if (mistakeLessons.isEmpty)
                    _NoMistakesCelebrationCard()
                  else ...[
                    Row(
                      children: [
                        const Icon(Icons.published_with_changes_rounded,
                            size: 18, color: Color(0xFFEF4444)),
                        const SizedBox(width: 6),
                        LocalizedText(
                          'সংশোধন প্রয়োজন এমন পাঠ (${mistakeLessons.length}টি)',
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    for (final lesson in mistakeLessons) ...[
                      _RevisionLessonCard(
                        lesson: lesson,
                        badgeText: context.uiText('ভুল সংশোধন'),
                        badgeColor: const Color(0xFFEF4444),
                        accentColor: const Color(0xFFEF4444),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ] else if (_selectedFilter == 2) ...[
                  if (completedLessons.isEmpty)
                    _NoCompletedLessonsCard()
                  else ...[
                    LocalizedText(
                      'তোমার সম্পন্ন করা পাঠসমূহ (${completedLessons.length}টি)',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final lesson in completedLessons) ...[
                      _RevisionLessonCard(
                        lesson: lesson,
                        badgeText: context.uiText('পুনরাবৃত্তি'),
                        badgeColor: AppTheme.duoGreen,
                        accentColor: AppTheme.duoGreen,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ] else ...[
                  // Mixed Smart Queue
                  if (dueLessons.isNotEmpty) ...[
                    LocalizedText(
                      'স্মার্ট রিভিশন কিউ (এখন চর্চা আবশ্যক)',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final lesson in dueLessons) ...[
                      _RevisionLessonCard(
                        lesson: lesson,
                        badgeText: context.uiText('রিভিশন বাকি'),
                        badgeColor: const Color(0xFFF59E0B),
                        accentColor: const Color(0xFFF59E0B),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 14),
                  ],

                  if (mistakeLessons.isNotEmpty) ...[
                    LocalizedText(
                      'ভুল শোধরাই (Mistakes to Fix)',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final lesson in mistakeLessons.take(3)) ...[
                      _RevisionLessonCard(
                        lesson: lesson,
                        badgeText: context.uiText('ভুল হয়েছে'),
                        badgeColor: const Color(0xFFEF4444),
                        accentColor: const Color(0xFFEF4444),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 14),
                  ],

                  LocalizedText(
                    'প্রস্তাবিত রিভিশন পাঠ',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final lesson in recommendedQueue) ...[
                    _RevisionLessonCard(
                      lesson: lesson,
                      badgeText: 'চর্চা',
                      badgeColor: const Color(0xFF4F46E5),
                      accentColor: const Color(0xFF4F46E5),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.isAlert = false,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isAlert;

  @override
  Widget build(BuildContext context) {
    final activeBg = isAlert ? const Color(0xFFFEE2E2) : const Color(0xFFEEF2FF);
    final activeTextColor =
        isAlert ? const Color(0xFFDC2626) : const Color(0xFF4338CA);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isAlert ? const Color(0xFFF87171) : const Color(0xFF6366F1))
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? activeTextColor : const Color(0xFF475569),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isAlert
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF4F46E5))
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoMistakesCelebrationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          const QuranBookMascot(
            size: 80,
            mood: QuranMascotMood.celebrating,
          ),
          const SizedBox(height: 14),
          LocalizedText(
            'মাশাআল্লাহ! কোনো ভুল জমা নেই!',
            style: GoogleFonts.hindSiliguri(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          LocalizedText(
            'তুমি খুব সুন্দর ও মনোযোগ দিয়ে শিখছ। যখনই কোনো ভুল হবে, তা স্বয়ংক্রিয়ভাবে এখানে অনুশীলনের জন্য জমা হবে।',
            textAlign: TextAlign.center,
            style: GoogleFonts.hindSiliguri(
              fontSize: 13,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoCompletedLessonsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          const Icon(Icons.school_outlined, size: 50, color: Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          LocalizedText(
            'এখনো কোনো পাঠ সম্পন্ন হয়নি',
            style: GoogleFonts.hindSiliguri(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          LocalizedText(
            'ক্বায়দা রোডম্যাপ থেকে নতুন পাঠ সম্পন্ন করলেই তা এখানে রিভিশন করার সুবিধা পাবে।',
            textAlign: TextAlign.center,
            style: GoogleFonts.hindSiliguri(
              fontSize: 13,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _RevisionLessonCard extends StatelessWidget {
  const _RevisionLessonCard({
    required this.lesson,
    required this.badgeText,
    required this.badgeColor,
    required this.accentColor,
  });

  final QaidaLessonInfo lesson;
  final String badgeText;
  final Color badgeColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => QaidaActivityScreen(lesson: lesson),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.25),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    lesson.arabicDisplay,
                    style: TextStyle(
                      fontFamily: AppTheme.arabicFontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              lesson.title,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lesson.subtitle,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.3),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.play_arrow_rounded,
                          size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      LocalizedText(
                        'চর্চা',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
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

