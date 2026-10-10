import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/vector_icons.dart';

class _SeerahStory {
  const _SeerahStory({
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
  final VectorIconType iconType;
  final Color accent;
  final Color color;
}

const _stories = [
  _SeerahStory(
    title: 'আবু উমাইরের ছোট্ট বন্ধু',
    subtitle: 'শিশুদের সঙ্গে নবীজির কোমল ব্যবহার',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF58A700),
    readTime: '২ মিনিট',
    reference: 'সহিহ বুখারি ৬২০৩',
    body:
        'আনাস (রা.)-এর ছোট ভাই আবু উমাইরের একটি ছোট পাখি ছিল। নবীজি ﷺ তাদের বাড়িতে এলে স্নেহ করে ছেলেটির খোঁজ নিতেন এবং তার পাখিটির কথা জিজ্ঞেস করতেন। ছোটদের আনন্দের বিষয়ও তিনি মন দিয়ে দেখতেন।',
    lesson: 'কারও সঙ্গে ভালো সম্পর্ক গড়তে তার পছন্দের বিষয় মন দিয়ে শোনো।',
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    title: 'হাসান (রা.)-এর প্রতি মমতা',
    subtitle: 'দয়া দেখানো আমাদের সুন্দর অভ্যাস',
    iconType: VectorIconType.star,
    accent: Color(0xFFD4A017),
    readTime: '২ মিনিট',
    reference: 'সহিহ বুখারি ৫৯৯৭',
    body:
        'একদিন নবীজি ﷺ তাঁর নাতি হাসান (রা.)-কে স্নেহ করলেন। পাশে থাকা একজন বললেন, তিনি নিজের সন্তানদের কাউকে চুমু দেননি। নবীজি ﷺ বুঝিয়ে দিলেন—যে অন্যের প্রতি দয়া করে না, তার প্রতিও দয়া করা হয় না।',
    lesson: 'ছোট-বড় সবার সঙ্গে দয়া ও স্নেহের আচরণ করি।',
    color: Color(0xFFFFF6D0),
  ),
  _SeerahStory(
    title: 'হেরা গুহায় প্রথম ওহি',
    subtitle: 'জ্ঞান ও সত্যের এক নতুন শুরু',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF0D7377),
    readTime: '৩ মিনিট',
    reference: 'সহিহ বুখারি ৩',
    body:
        'নবুওয়াতের আগে মুহাম্মদ ﷺ হেরা গুহায় নিরিবিলি সময় কাটাতেন। সেখানে তাঁর কাছে প্রথম ওহি আসে। খাদিজা (রা.) তাঁকে সাহস ও সান্ত্বনা দেন এবং পাশে দাঁড়ান। এভাবেই কুরআনের বার্তা মানুষের কাছে পৌঁছানোর শুরু হয়।',
    lesson: 'কঠিন সময়ে পরিবারের মানুষকে সাহস দিই এবং সত্যের পাশে থাকি।',
    color: Color(0xFFD4F0EC),
  ),
];

class SeerahScreen extends StatelessWidget {
  const SeerahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
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
                      _Header(onBack: () => Navigator.pop(context)),
                      const SizedBox(height: 18),
                      Container(
                        padding: EdgeInsets.all(tablet ? 22 : 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE05A7A), Color(0xFFC44569)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE05A7A).withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: VectorIcon(
                                type: VectorIconType.scroll,
                                size: 34,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'নবীজির জীবন থেকে শিখি',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'ছোট গল্প, সুন্দর শিক্ষা',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'আজ কোন গল্পটি পড়বে?',
                        style: TextStyle(
                          color: AppTheme.darkText,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final story in _stories)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _StoryCard(
                            story: story,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    _StoryDetailScreen(story: story),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'গল্পগুলো সংক্ষেপে লেখা। সূত্রের বিস্তারিত জানতে কার্ডে দেওয়া হাদিস নম্বর দেখো।',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.darkText.withValues(alpha: 0.45),
                          fontSize: 11,
                          height: 1.5,
                        ),
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

class _Header extends StatelessWidget {
  const _Header({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton.filledTonal(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_rounded),
        style: IconButton.styleFrom(backgroundColor: Colors.white),
      ),
      const SizedBox(width: 8),
      const Text(
        'সীরাতের গল্প',
        style: TextStyle(
          color: AppTheme.darkText,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    ]);
  }
}

class _StoryCard extends StatefulWidget {
  const _StoryCard({required this.story, required this.onTap});
  final _SeerahStory story;
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
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
            boxShadow: [
              BoxShadow(
                color: story.accent.withValues(alpha: 0.12),
                blurRadius: 0,
                offset: Offset(0, _pressed ? 2 : 5),
              ),
            ],
          ),
          child: Row(children: [
            IconBadge(
              type: story.iconType,
              bgColor: story.color,
              size: 56,
              iconColor: story.accent,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: const TextStyle(
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    story.subtitle,
                    style: TextStyle(
                      color: AppTheme.darkText.withValues(alpha: 0.55),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${story.readTime}  ·  ${story.reference}',
                    style: TextStyle(
                      color: story.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: story.accent),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                Row(children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'গল্প পড়ি',
                    style: TextStyle(
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                ]),
                const SizedBox(height: 24),
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: story.color,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: story.accent.withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: VectorIcon(
                    type: story.iconType,
                    size: 64,
                    color: story.accent,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  story.title,
                  style: const TextStyle(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  story.body,
                  style: const TextStyle(
                    color: AppTheme.darkText,
                    fontSize: 16,
                    height: 1.85,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        VectorIcon(
                          type: VectorIconType.sparkle,
                          size: 20,
                          color: story.accent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'গল্পের শিক্ষা',
                          style: TextStyle(
                            color: story.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      Text(
                        story.lesson,
                        style: const TextStyle(
                          color: AppTheme.darkText,
                          fontSize: 15,
                          height: 1.55,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'সূত্র: ${story.reference}',
                  style: TextStyle(
                    color: AppTheme.darkText.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
