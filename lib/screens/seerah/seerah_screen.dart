import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/duolingo_appbar.dart';

class _SeerahStory {
  const _SeerahStory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconType,
    required this.accent,
    required this.readTime,
    required this.reference,
    required this.body,
    required this.lesson,
    required this.color,
  });

  final String title, subtitle, readTime, reference, body, lesson;
  final String id;
  final VectorIconType iconType;
  final Color accent;
  final Color color;
}

const _stories = [
  _SeerahStory(
    id: 'abu_umair',
    title: 'আবু উমাইরের ছোট্ট বন্ধু',
    subtitle: 'শিশুদের সঙ্গে নবীজির কোমল ব্যবহার',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF58A700),
    readTime: '২ মিনিট',
    reference: 'সহিহ বুখারি ৬২০৩',
    body:
        'আনাস (রা.)-এর ছোট ভাই আবু উমাইরের একটি ছোট পাখি ছিল। নবীজি ﷺ তাদের বাড়িতে এলে স্নেহ করে ছেলেটির খোঁজ নিতেন এবং তার পাখিটির কথা জিজ্ঞেস করতেন। ছোটদের আনন্দের বিষয়ও তিনি মন দিয়ে দেখতেন।',
    lesson: 'কারও সঙ্গে ভালো সম্পর্ক গড়তে তার পছন্দের বিষয় মন দিয়ে শোনো।',
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'hasan_kindness',
    title: 'হাসান (রা.)-এর প্রতি মমতা',
    subtitle: 'দয়া দেখানো আমাদের সুন্দর অভ্যাস',
    iconType: VectorIconType.star,
    accent: Color(0xFFD4A017),
    readTime: '২ মিনিট',
    reference: 'সহিহ বুখারি ৫৯৯৭',
    body:
        'একদিন নবীজি ﷺ তাঁর নাতি হাসান (রা.)-কে স্নেহ করলেন। পাশে থাকা একজন বললেন, তিনি নিজের সন্তানদের কাউকে চুমু দেননি। নবীজি ﷺ বুঝিয়ে দিলেন—যে অন্যের প্রতি দয়া করে না, তার প্রতিও দয়া করা হয় না।',
    lesson: 'ছোট-বড় সবার সঙ্গে দয়া ও স্নেহের আচরণ করি।',
    color: Color(0xFFFFF6D0),
  ),
  _SeerahStory(
    id: 'first_revelation',
    title: 'হেরা গুহায় প্রথম ওহি',
    subtitle: 'জ্ঞান ও সত্যের এক নতুন শুরু',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF0D7377),
    readTime: '৩ মিনিট',
    reference: 'সহিহ বুখারি ৩',
    body:
        'নবুওয়াতের আগে মুহাম্মদ ﷺ হেরা গুহায় নিরিবিলি সময় কাটাতেন। সেখানে তাঁর কাছে প্রথম ওহি আসে। খাদিজা (রা.) তাঁকে সাহস ও সান্ত্বনা দেন এবং পাশে দাঁড়ান। এভাবেই কুরআনের বার্তা মানুষের কাছে পৌঁছানোর শুরু হয়।',
    lesson: 'কঠিন সময়ে পরিবারের মানুষকে সাহস দিই এবং সত্যের পাশে থাকি।',
    color: Color(0xFFD4F0EC),
  ),
];

class SeerahScreen extends StatelessWidget {
  const SeerahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final state = context.watch<AppState>();
    final completed = _stories
        .where((story) => state.hasCompletedLesson('seerah_${story.id}'))
        .length;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
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
                        title: 'নবীজির জীবন থেকে শিখি',
                        subtitle: 'ছোট গল্প, বড় শিক্ষা',
                        iconType: VectorIconType.scroll,
                        gradientColors: const [
                          Color(0xFFE05A7A),
                          Color(0xFFC44569)
                        ],
                        onBack: () => Navigator.pop(context),
                      ),

                      DuolingoSectionLabel(
                        label: 'আজ কোন গল্পটি পড়বে?',
                        badgeText: '$completed/${_stories.length}টি শেষ',
                        badgeColor: const Color(0xFFFFE4EC),
                        badgeTextColor: const Color(0xFFE05A7A),
                      ),
                      const SizedBox(height: 14),

                      for (final story in _stories)
                        _StoryCard(
                          story: story,
                          completed:
                              state.hasCompletedLesson('seerah_${story.id}'),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) =>
                                    _StoryDetailScreen(story: story)),
                          ),
                        ),

                      const SizedBox(height: 8),
                      LocalizedText(
                        'গল্পগুলো সংক্ষেপে লেখা। সূত্রের বিস্তারিত জানতে কার্ডে দেওয়া হাদিস নম্বর দেখো।',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.darkText.withValues(alpha: 0.45),
                            fontSize: 11,
                            height: 1.5),
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

class _StoryCard extends StatefulWidget {
  const _StoryCard(
      {required this.story, required this.onTap, required this.completed});
  final _SeerahStory story;
  final bool completed;
  final VoidCallback onTap;

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        margin: const EdgeInsets.only(bottom: 14),
        transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: story.accent.withValues(alpha: 0.25), width: 2),
          boxShadow: [
            BoxShadow(
                color: story.accent.withValues(alpha: _pressed ? 0.05 : 0.15),
                blurRadius: 0,
                offset: Offset(0, _pressed ? 0 : 4))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: story.color, borderRadius: BorderRadius.circular(18)),
              child: Center(
                  child: VectorIcon(
                      type: story.iconType, size: 32, color: story.accent)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(story.title,
                        style: const TextStyle(
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                    const SizedBox(height: 3),
                    LocalizedText(
                        widget.completed
                            ? 'গল্পটি শেষ · চাইলে আবার পড়ো'
                            : story.subtitle,
                        style: TextStyle(
                            color: AppTheme.darkText.withValues(alpha: 0.55),
                            fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: story.color,
                            borderRadius: BorderRadius.circular(8)),
                        child: LocalizedText(story.readTime,
                            style: TextStyle(
                                color: story.accent,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(8)),
                        child: LocalizedText(story.reference,
                            style: const TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ]),
            ),
            Container(
              width: 32,
              height: 32,
              decoration:
                  BoxDecoration(color: story.color, shape: BoxShape.circle),
              child: Icon(Icons.chevron_right_rounded,
                  color: story.accent, size: 20),
            ),
          ]),
        ),
      ),
    );
  }
}

class _StoryDetailScreen extends StatelessWidget {
  const _StoryDetailScreen({required this.story});
  final _SeerahStory story;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final completed = state.hasCompletedLesson('seerah_${story.id}');
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                DuolingoPageHeader(
                  title: story.title,
                  subtitle: '${story.readTime}  ·  ${story.reference}',
                  iconType: story.iconType,
                  gradientColors: [
                    story.accent,
                    story.accent.withValues(alpha: 0.75)
                  ],
                  onBack: () => Navigator.pop(context),
                ),

                // Story body card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: story.accent.withValues(alpha: 0.2), width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: story.accent.withValues(alpha: 0.1),
                          blurRadius: 0,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: LocalizedText(
                    story.body,
                    style: const TextStyle(
                        color: AppTheme.darkText,
                        fontSize: 16,
                        height: 1.85,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 14),

                // Lesson card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: story.color,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                        color: story.accent.withValues(alpha: 0.3), width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: story.accent.withValues(alpha: 0.12),
                          blurRadius: 0,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          VectorIcon(
                              type: VectorIconType.sparkle,
                              size: 20,
                              color: story.accent),
                          const SizedBox(width: 8),
                          LocalizedText('গল্পের শিক্ষা',
                              style: TextStyle(
                                  color: story.accent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800)),
                        ]),
                        const SizedBox(height: 10),
                        LocalizedText(story.lesson,
                            style: const TextStyle(
                                color: AppTheme.darkText,
                                fontSize: 15,
                                height: 1.55,
                                fontWeight: FontWeight.w600)),
                      ]),
                ),
                const SizedBox(height: 16),
                LocalizedText(
                  'সূত্র: ${story.reference}',
                  style: TextStyle(
                      color: AppTheme.darkText.withValues(alpha: 0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: completed
                      ? null
                      : () async {
                          final earned = await context
                              .read<AppState>()
                              .completeLesson('seerah_${story.id}', xp: 10);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: LocalizedText(earned
                                ? 'গল্প শেষ! +১০ XP পেয়েছ।'
                                : 'গল্পটি আগেই শেষ করেছ।'),
                          ));
                        },
                  icon: Icon(completed
                      ? Icons.check_circle_rounded
                      : Icons.celebration_rounded),
                  label: LocalizedText(
                      completed ? 'গল্পটি সম্পন্ন' : 'গল্প শেষ করেছি · +১০ XP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
