import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/vector_icons.dart';
import 'qaida_letters.dart';
import 'qaida_lesson_screen.dart';
import 'qaida_next_course_screen.dart';

class _QaidaChapter {
  const _QaidaChapter(this.title, this.subtitle, this.color, this.icon,
      {this.letterStart, this.letterEnd, this.courseIndex});
  final String title, subtitle;
  final Color color;
  final IconData icon;
  final int? letterStart, letterEnd, courseIndex;
  bool get isLetters => letterStart != null;
}

const _chapters = <_QaidaChapter>[
  _QaidaChapter(
      'হরফ পরিচয় · ১', 'আলিফ থেকে ছা', Color(0xFFDDF4E9), Icons.abc_rounded,
      letterStart: 0, letterEnd: 6),
  _QaidaChapter('হরফ পরিচয় · ২', 'জীম থেকে যাল', Color(0xFFFFEBCF),
      Icons.text_fields_rounded,
      letterStart: 7, letterEnd: 13),
  _QaidaChapter('হরফ পরিচয় · ৩', 'রা থেকে আইন', Color(0xFFE8E2FF),
      Icons.translate_rounded,
      letterStart: 14, letterEnd: 20),
  _QaidaChapter('হরফ পরিচয় · ৪', 'গাইন থেকে ইয়া', Color(0xFFDDF1FF),
      Icons.menu_book_rounded,
      letterStart: 21, letterEnd: 27),
  _QaidaChapter('যুক্ত বর্ণ', 'হরফ জুড়ে শব্দের রূপ চিনি', Color(0xFFDDF4E9),
      Icons.extension_rounded,
      courseIndex: 0),
  _QaidaChapter(
      'হরকত', 'যবর · যের · পেশ', Color(0xFFFFEBCF), Icons.graphic_eq_rounded,
      courseIndex: 1),
  _QaidaChapter('মাদ ও গুন্নাহ', 'টেনে পড়া ও নাকের অনুরণন', Color(0xFFE8E2FF),
      Icons.waves_rounded,
      courseIndex: 2),
  _QaidaChapter('আয়াত পড়া', 'শেখা নিয়ম দিয়ে আয়াত পড়ি', Color(0xFFDDF1FF),
      Icons.menu_book_rounded,
      courseIndex: 3),
];

int _completedCount(AppState state, _QaidaChapter chapter) {
  if (chapter.isLetters) {
    return qaidaLetters
        .sublist(chapter.letterStart!, chapter.letterEnd! + 1)
        .where((letter) => state.hasCompletedLesson(letter.id))
        .length;
  }
  return state.hasCompletedLesson('qaida_course_${chapter.courseIndex}')
      ? 1
      : 0;
}

bool _chapterUnlocked(AppState state, int index) {
  if (state.isAdmin) return true;
  if (index == 0) return true;
  final previous = _chapters[index - 1];
  final previousTotal =
      previous.isLetters ? previous.letterEnd! - previous.letterStart! + 1 : 1;
  return _completedCount(state, previous) == previousTotal;
}

void _openChapter(BuildContext context, AppState state, int index) {
  final chapter = _chapters[index];
  if (chapter.isLetters) {
    final start = chapter.letterStart!;
    final end = chapter.letterEnd!;
    var lessonIndex = start;
    for (var i = start; i <= end; i++) {
      if (!state.hasCompletedLesson(qaidaLetters[i].id)) {
        lessonIndex = i;
        break;
      }
      lessonIndex = i;
    }
    final chapterComplete =
        List.generate(end - start + 1, (offset) => start + offset)
            .every((i) => state.hasCompletedLesson(qaidaLetters[i].id));
    if (chapterComplete) lessonIndex = start;
    final letter = qaidaLetters[lessonIndex];
    final nextIndex = lessonIndex + 1;
    final next = nextIndex <= end ? qaidaLetters[nextIndex] : null;
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => QaidaLessonScreen(
              lessonId: letter.id,
              lessonTitle: letter.title,
              letter: letter.letter,
              letterName: letter.name,
              makhrajNote: letter.makhraj,
              options: qaidaLetterOptions(lessonIndex),
              chapterEndLessonId: qaidaLetters[end].id,
              nextLesson: next == null
                  ? null
                  : QaidaNextLesson(
                      lessonId: next.id,
                      lessonTitle: next.title,
                      letter: next.letter,
                      letterName: next.name,
                      makhrajNote: next.makhraj,
                      options: qaidaLetterOptions(nextIndex),
                    ),
            )));
    return;
  }
  Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => QaidaNextCourseScreen(
            initialIndex: chapter.courseIndex!,
            stopAfterIndex: chapter.courseIndex,
          )));
}

class QaidaChaptersScreen extends StatelessWidget {
  const QaidaChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final complete = _chapters
        .where((c) =>
            _completedCount(state, c) ==
            (c.isLetters ? c.letterEnd! - c.letterStart! + 1 : 1))
        .length;
    return Scaffold(
        backgroundColor: AppTheme.cream,
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: ListView(padding: EdgeInsets.all(tablet ? 32 : 18), children: [
            _ChapterHeader(
                onBack: () => Navigator.pop(context), progress: complete),
            const SizedBox(height: 16),
            _PathBanner(progress: complete),
            const SizedBox(height: 20),
            for (var i = 0; i < _chapters.length; i++) ...[
              _QaidaChapterCard(
                  chapter: _chapters[i],
                  index: i,
                  state: state,
                  locked: !_chapterUnlocked(state, i),
                  onTap: () => _openChapter(context, state, i)),
              const SizedBox(height: 11),
            ],
          ]),
        ))));
  }
}

/// Compact chapter list shown directly on Home as the Qaida learning path.
class QaidaChapterPath extends StatelessWidget {
  const QaidaChapterPath({super.key, required this.isTablet});
  final bool isTablet;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final completed = _chapters
        .where((c) =>
            _completedCount(state, c) ==
            (c.isLetters ? c.letterEnd! - c.letterStart! + 1 : 1))
        .length;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: isTablet ? 36 : 18),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 2)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Expanded(
                child: LocalizedText('ক্বায়দা · অধ্যায়ভিত্তিক পথ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.darkText))),
            LocalizedText('$completed/${_chapters.length}',
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: AppTheme.primaryGreen))
          ]),
          const SizedBox(height: 9),
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                  value: completed / _chapters.length,
                  minHeight: 9,
                  backgroundColor: const Color(0xFFE5E5E5),
                  color: AppTheme.primaryGreen)),
          const SizedBox(height: 12),
          SizedBox(
              height: 145,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _chapters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 9),
                  itemBuilder: (context, i) => SizedBox(
                      width: isTablet ? 180 : 148,
                      child: _QaidaChapterCard(
                          chapter: _chapters[i],
                          index: i,
                          state: state,
                          locked: !_chapterUnlocked(state, i),
                          compact: true,
                          onTap: () => _openChapter(context, state, i))))),
          const SizedBox(height: 7),
          const LocalizedText('হরফ → যুক্ত বর্ণ → হরকত → মাদ/গুন্নাহ → আয়াত',
              style: TextStyle(fontSize: 11, color: Colors.black54)),
        ]));
  }
}

class _ChapterHeader extends StatelessWidget {
  const _ChapterHeader({required this.onBack, required this.progress});
  final VoidCallback onBack;
  final int progress;
  @override
  Widget build(BuildContext context) => DuolingoPageHeader(
        title: 'ক্বায়দা · অধ্যায়',
        subtitle: 'ধাপে ধাপে কুরআন পড়া শিখি',
        iconType: VectorIconType.qaida,
        gradientColors: const [Color(0xFF0D7377), Color(0xFF14919B)],
        onBack: onBack,
        trailing: LocalizedText('$progress/${_chapters.length}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900)),
      );
}

class _PathBanner extends StatelessWidget {
  const _PathBanner({required this.progress});
  final int progress;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF0D7377), Color(0xFF14919B)]),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
                color: Color(0xFF096266), blurRadius: 0, offset: Offset(0, 6))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const LocalizedText('ধাপে ধাপে কুরআন পড়া শিখি',
            style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        const LocalizedText('প্রতিটি অধ্যায় শেষ হলে পরের অধ্যায় খুলবে।',
            style: TextStyle(color: Colors.white, fontSize: 13)),
        const SizedBox(height: 13),
        ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
                value: progress / _chapters.length,
                minHeight: 10,
                backgroundColor: Colors.white30,
                color: const Color(0xFFFFD66B)))
      ]));
}

class _QaidaChapterCard extends StatelessWidget {
  const _QaidaChapterCard(
      {required this.chapter,
      required this.index,
      required this.state,
      required this.locked,
      required this.onTap,
      this.compact = false});
  final _QaidaChapter chapter;
  final int index;
  final AppState state;
  final bool locked, compact;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final done = _completedCount(state, chapter);
    final total =
        chapter.isLetters ? chapter.letterEnd! - chapter.letterStart! + 1 : 1;
    final complete = done == total;
    return DuolingoCard(
        onTap: locked ? null : onTap,
        accentColor: complete ? AppTheme.primaryGreen : const Color(0xFF0D7377),
        backgroundColor: locked ? const Color(0xFFF1EEE7) : Colors.white,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(compact ? 12 : 15),
        child: compact
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CircleAvatar(
                    radius: 19,
                    backgroundColor: chapter.color,
                    child: Icon(
                        locked
                            ? Icons.lock_rounded
                            : complete
                                ? Icons.check_rounded
                                : chapter.icon,
                        color: AppTheme.primaryGreen,
                        size: 20)),
                const Spacer(),
                LocalizedText(chapter.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.darkText)),
                LocalizedText(locked ? 'লক' : '$done/$total পাঠ',
                    style: const TextStyle(fontSize: 10, color: Colors.black54))
              ])
            : Row(children: [
                CircleAvatar(
                    radius: 24,
                    backgroundColor: chapter.color,
                    child: Icon(
                        locked
                            ? Icons.lock_rounded
                            : complete
                                ? Icons.check_rounded
                                : chapter.icon,
                        color: AppTheme.primaryGreen)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      LocalizedText('অধ্যায় ${index + 1}',
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryGreen)),
                      LocalizedText(chapter.title,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.darkText)),
                      const SizedBox(height: 2),
                      LocalizedText(
                          locked
                              ? 'আগের অধ্যায় শেষ হলে খুলবে'
                              : '${chapter.subtitle} · $done/$total পাঠ',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black54))
                    ])),
                Icon(
                    locked
                        ? Icons.lock_rounded
                        : complete
                            ? Icons.check_circle_rounded
                            : Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: complete ? AppTheme.primaryGreen : Colors.black38)
              ]));
  }
}
