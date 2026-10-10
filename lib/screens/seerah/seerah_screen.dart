import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class _SeerahStory {
  const _SeerahStory({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.readTime,
    required this.reference,
    required this.body,
    required this.lesson,
    required this.color,
  });

  final String title, subtitle, emoji, readTime, reference, body, lesson;
  final Color color;
}

const _stories = [
  _SeerahStory(
    title: 'আবু উমাইরের ছোট্ট বন্ধু',
    subtitle: 'শিশুদের সঙ্গে নবীজির কোমল ব্যবহার',
    emoji: '🐦',
    readTime: '২ মিনিট',
    reference: 'সহিহ বুখারি ৬২০৩',
    body:
        'আনাস (রা.)-এর ছোট ভাই আবু উমাইরের একটি ছোট পাখি ছিল। নবীজি ﷺ তাদের বাড়িতে এলে স্নেহ করে ছেলেটির খোঁজ নিতেন এবং তার পাখিটির কথা জিজ্ঞেস করতেন। ছোটদের আনন্দের বিষয়ও তিনি মন দিয়ে দেখতেন।',
    lesson: 'কারও সঙ্গে ভালো সম্পর্ক গড়তে তার পছন্দের বিষয় মন দিয়ে শোনো।',
    color: Color(0xFFE4F2E7),
  ),
  _SeerahStory(
    title: 'হাসান (রা.)-এর প্রতি মমতা',
    subtitle: 'দয়া দেখানো আমাদের সুন্দর অভ্যাস',
    emoji: '💛',
    readTime: '২ মিনিট',
    reference: 'সহিহ বুখারি ৫৯৯৭',
    body:
        'একদিন নবীজি ﷺ তাঁর নাতি হাসান (রা.)-কে স্নেহ করলেন। পাশে থাকা একজন বললেন, তিনি নিজের সন্তানদের কাউকে চুমু দেননি। নবীজি ﷺ বুঝিয়ে দিলেন—যে অন্যের প্রতি দয়া করে না, তার প্রতিও দয়া করা হয় না।',
    lesson: 'ছোট-বড় সবার সঙ্গে দয়া ও স্নেহের আচরণ করি।',
    color: Color(0xFFFFF1D1),
  ),
  _SeerahStory(
    title: 'হেরা গুহায় প্রথম ওহি',
    subtitle: 'জ্ঞান ও সত্যের এক নতুন শুরু',
    emoji: '🌙',
    readTime: '৩ মিনিট',
    reference: 'সহিহ বুখারি ৩',
    body:
        'নবুওয়াতের আগে মুহাম্মদ ﷺ হেরা গুহায় নিরিবিলি সময় কাটাতেন। সেখানে তাঁর কাছে প্রথম ওহি আসে। খাদিজা (রা.) তাঁকে সাহস ও সান্ত্বনা দেন এবং পাশে দাঁড়ান। এভাবেই কুরআনের বার্তা মানুষের কাছে পৌঁছানোর শুরু হয়।',
    lesson: 'কঠিন সময়ে পরিবারের মানুষকে সাহস দিই এবং সত্যের পাশে থাকি।',
    color: Color(0xFFE9E8F5),
  ),
];

class SeerahScreen extends StatelessWidget {
  const SeerahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      tablet ? 36 : 20, 16, tablet ? 36 : 20, 32),
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
                        const Text('সীরাতের গল্প',
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
                          gradient: const LinearGradient(colors: [
                            AppTheme.primaryGreen,
                            Color(0xFF16877B)
                          ]),
                        ),
                        child: const Row(children: [
                          Text('📜', style: TextStyle(fontSize: 38)),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('নবীজির জীবন থেকে শিখি',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800)),
                                  SizedBox(height: 5),
                                  Text('ছোট গল্প, সুন্দর শিক্ষা',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 13)),
                                ]),
                          )
                        ]),
                      ),
                      const SizedBox(height: 22),
                      const Text('আজ কোন গল্পটি পড়বে?',
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
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
                      const Text(
                          'গল্পগুলো সংক্ষেপে লেখা। সূত্রের বিস্তারিত জানতে কার্ডে দেওয়া হাদিস নম্বর দেখো।',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 11,
                              height: 1.5)),
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

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.story, required this.onTap});
  final _SeerahStory story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                    color: story.color,
                    borderRadius: BorderRadius.circular(18)),
                alignment: Alignment.center,
                child: Text(story.emoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(story.title,
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontWeight: FontWeight.w800,
                              fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(story.subtitle,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 12)),
                      const SizedBox(height: 7),
                      Text('${story.readTime}  •  ${story.reference}',
                          style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ]),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.primaryGreen),
            ]),
          ),
        ),
      );
}

class _StoryDetailScreen extends StatelessWidget {
  const _StoryDetailScreen({required this.story});
  final _SeerahStory story;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppTheme.cream,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(padding: const EdgeInsets.all(20), children: [
                Row(children: [
                  IconButton.filledTonal(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                      style:
                          IconButton.styleFrom(backgroundColor: Colors.white)),
                  const SizedBox(width: 8),
                  const Text('গল্প পড়ি',
                      style: TextStyle(
                          color: AppTheme.darkText,
                          fontWeight: FontWeight.w800,
                          fontSize: 17)),
                ]),
                const SizedBox(height: 28),
                Container(
                  height: 145,
                  decoration: BoxDecoration(
                      color: story.color,
                      borderRadius: BorderRadius.circular(28)),
                  alignment: Alignment.center,
                  child:
                      Text(story.emoji, style: const TextStyle(fontSize: 68)),
                ),
                const SizedBox(height: 24),
                Text(story.title,
                    style: const TextStyle(
                        color: AppTheme.darkText,
                        fontWeight: FontWeight.w900,
                        fontSize: 25)),
                const SizedBox(height: 18),
                Text(story.body,
                    style: const TextStyle(
                        color: AppTheme.darkText, fontSize: 17, height: 1.9)),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('গল্পের শিক্ষা',
                            style: TextStyle(
                                color: AppTheme.primaryGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 7),
                        Text(story.lesson,
                            style: const TextStyle(
                                color: AppTheme.darkText,
                                fontSize: 15,
                                height: 1.6)),
                      ]),
                ),
                const SizedBox(height: 18),
                Text('সূত্র: ${story.reference}',
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),
      );
}
