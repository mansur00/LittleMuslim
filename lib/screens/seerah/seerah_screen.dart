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
                          inProgress:
                              !state.hasCompletedLesson('seerah_${story.id}') &&
                                  state.seerahProgress(story.id) > 0,
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
  const _StoryCard({
    required this.story,
    required this.onTap,
    required this.completed,
    this.inProgress = false,
  });
  final _SeerahStory story;
  final bool completed;
  final bool inProgress;
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
                            : widget.inProgress
                                ? 'চলমান · শিক্ষা অংশে আছো'
                                : story.subtitle,
                        style: TextStyle(
                            color: widget.completed
                                ? const Color(0xFF58A700)
                                : widget.inProgress
                                    ? const Color(0xFFD4A017)
                                    : AppTheme.darkText.withValues(alpha: 0.55),
                            fontWeight: (widget.completed || widget.inProgress)
                                ? FontWeight.w700
                                : FontWeight.normal,
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
              child: Icon(
                  widget.completed
                      ? Icons.check_rounded
                      : Icons.chevron_right_rounded,
                  color: story.accent,
                  size: 20),
            ),
          ]),
        ),
      ),
    );
  }
}

class _StoryDetailScreen extends StatefulWidget {
  const _StoryDetailScreen({required this.story});
  final _SeerahStory story;

  @override
  State<_StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<_StoryDetailScreen> {
  late _SeerahStory _currentStory;
  late int _step;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _currentStory = widget.story;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final appState = context.read<AppState>();
      final isComp = appState.hasCompletedLesson('seerah_${_currentStory.id}');
      final saved = appState.seerahProgress(_currentStory.id);
      _step = isComp ? 2 : (saved > 0 ? saved : 0);
      _initialized = true;
    }
  }

  void _goToStory(_SeerahStory nextStory) {
    final appState = context.read<AppState>();
    final isComp = appState.hasCompletedLesson('seerah_${nextStory.id}');
    final saved = appState.seerahProgress(nextStory.id);
    setState(() {
      _currentStory = nextStory;
      _step = isComp ? 2 : (saved > 0 ? saved : 0);
    });
  }

  Future<void> _advanceStep(int newStep) async {
    setState(() => _step = newStep);
    await context.read<AppState>().saveSeerahProgress(_currentStory.id, newStep);
  }

  Future<void> _finishStory() async {
    final appState = context.read<AppState>();
    final earned =
        await appState.completeLesson('seerah_${_currentStory.id}', xp: 10);
    await appState.saveSeerahProgress(_currentStory.id, 2);
    if (!mounted) return;
    setState(() => _step = 2);

    final currentIndex = _stories.indexWhere((s) => s.id == _currentStory.id);
    final hasNext = currentIndex < _stories.length - 1;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.celebration_rounded,
                color: Color(0xFF58A700), size: 28),
            SizedBox(width: 10),
            Expanded(child: LocalizedText('মাশাআল্লাহ!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocalizedText(
              earned
                  ? 'গল্পটি সম্পন্ন হয়েছে! তুমি পেয়েছ +১০ XP।'
                  : 'গল্পটি আবার পড়ে শেষ করেছ! (+১০ XP আগেই পেয়েছ)',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            if (hasNext)
              LocalizedText(
                'পরবর্তী গল্প: ${_stories[currentIndex + 1].title}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D7377),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const LocalizedText('এখানেই থাকি'),
          ),
          if (hasNext)
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _goToStory(_stories[currentIndex + 1]);
              },
              style: FilledButton.styleFrom(
                backgroundColor: _stories[currentIndex + 1].accent,
              ),
              child: const LocalizedText('পরের গল্প পড়ুন'),
            )
          else
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen),
              child: const LocalizedText('তালিকায় ফেরো'),
            ),
        ],
      ),
    );
  }

  Future<void> _handleExit() async {
    final isComp = context
        .read<AppState>()
        .hasCompletedLesson('seerah_${_currentStory.id}');
    if (!isComp && _step == 1) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const LocalizedText('পড়া থেকে বিরতি নেবে?'),
          content: const LocalizedText(
              'তোমার পড়ার অগ্রগতি সেভ থাকবে। পরে শিক্ষা অংশ থেকে শুরু করতে পারবে।'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const LocalizedText('চালিয়ে যাই'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE05A7A)),
              child: const LocalizedText('বিরতি নিই'),
            ),
          ],
        ),
      );
      if (shouldExit == true && mounted) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final completed =
        state.hasCompletedLesson('seerah_${_currentStory.id}') || _step == 2;
    final currentIndex = _stories.indexWhere((s) => s.id == _currentStory.id);
    final hasPrev = currentIndex > 0;
    final hasNext = currentIndex < _stories.length - 1;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _handleExit();
        }
      },
      child: Scaffold(
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
                    title: _currentStory.title,
                    subtitle:
                        '${_currentStory.readTime}  ·  ${_currentStory.reference}',
                    iconType: _currentStory.iconType,
                    gradientColors: [
                      _currentStory.accent,
                      _currentStory.accent.withValues(alpha: 0.75)
                    ],
                    onBack: _handleExit,
                  ),

                  // Reading progress indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: _currentStory.accent.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StepIndicatorPill(
                          label: '১. মূল ঘটনা',
                          active: _step >= 0,
                          current: _step == 0,
                          accent: _currentStory.accent,
                        ),
                        Icon(Icons.chevron_right_rounded,
                            size: 16,
                            color: _currentStory.accent.withValues(alpha: 0.4)),
                        _StepIndicatorPill(
                          label: '২. শিক্ষা ও আমল',
                          active: _step >= 1,
                          current: _step == 1,
                          accent: _currentStory.accent,
                        ),
                        Icon(Icons.chevron_right_rounded,
                            size: 16,
                            color: _currentStory.accent.withValues(alpha: 0.4)),
                        _StepIndicatorPill(
                          label: '৩. সমাপ্তি',
                          active: completed,
                          current: _step == 2,
                          accent: _currentStory.accent,
                        ),
                      ],
                    ),
                  ),

                  // Completed Banner if finished
                  if (completed && _step == 2) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F8D8),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: const Color(0xFF58A700).withValues(alpha: 0.4),
                            width: 1.5),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: Color(0xFF58A700), size: 24),
                          SizedBox(width: 10),
                          Expanded(
                            child: LocalizedText(
                              'গল্পটি পড়া শেষ হয়েছে! মাশাআল্লাহ।',
                              style: TextStyle(
                                  color: Color(0xFF3B7A00),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Story body card
                  if (_step == 0 || _step == 2) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: _currentStory.accent.withValues(alpha: 0.2),
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: _currentStory.accent
                                  .withValues(alpha: 0.1),
                              blurRadius: 0,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: LocalizedText(
                        _currentStory.body,
                        style: const TextStyle(
                            color: AppTheme.darkText,
                            fontSize: 16,
                            height: 1.85,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Step 0 forward action
                  if (_step == 0) ...[
                    FilledButton.icon(
                      onPressed: () => _advanceStep(1),
                      style: FilledButton.styleFrom(
                        backgroundColor: _currentStory.accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const LocalizedText('গল্পের শিক্ষা পড়ি →',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15)),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Lesson card (visible during Step 1 and Step 2)
                  if (_step >= 1) ...[
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _currentStory.color,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: _currentStory.accent.withValues(alpha: 0.3),
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: _currentStory.accent
                                  .withValues(alpha: 0.12),
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
                                  color: _currentStory.accent),
                              const SizedBox(width: 8),
                              LocalizedText('গল্পের শিক্ষা',
                                  style: TextStyle(
                                      color: _currentStory.accent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800)),
                            ]),
                            const SizedBox(height: 10),
                            LocalizedText(_currentStory.lesson,
                                style: const TextStyle(
                                    color: AppTheme.darkText,
                                    fontSize: 15,
                                    height: 1.55,
                                    fontWeight: FontWeight.w600)),
                          ]),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Step 1 controls
                  if (_step == 1) ...[
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _advanceStep(0),
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const LocalizedText('ঘটনা আবার দেখি'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _currentStory.accent,
                            side: BorderSide(
                                color: _currentStory.accent
                                    .withValues(alpha: 0.4)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _finishStory,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF58A700),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                            ),
                            icon: const Icon(Icons.celebration_rounded),
                            label: const LocalizedText(
                                'গল্প শেষ করেছি · +১০ XP',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Reference footnote
                  LocalizedText(
                    'সূত্র: ${_currentStory.reference}',
                    style: TextStyle(
                        color: AppTheme.darkText.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),

                  // Review restart action in step 2
                  if (_step == 2) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _advanceStep(0),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const LocalizedText('প্রথম থেকে আবার পড়ো'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.darkText,
                        side: BorderSide(
                            color: AppTheme.darkText.withValues(alpha: 0.2)),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFE8E8E8)),
                  const SizedBox(height: 12),

                  // Previous / Next Story Navigation
                  Row(
                    children: [
                      if (hasPrev)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _goToStory(_stories[currentIndex - 1]),
                            icon: const Icon(Icons.chevron_left_rounded),
                            label: LocalizedText(
                              'আগের গল্প\n${_stories[currentIndex - 1].title}',
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, height: 1.3),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        )
                      else
                        const Spacer(),
                      const SizedBox(width: 10),
                      if (hasNext)
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: () =>
                                _goToStory(_stories[currentIndex + 1]),
                            icon: const Icon(Icons.chevron_right_rounded),
                            iconAlignment: IconAlignment.end,
                            label: LocalizedText(
                              'পরের গল্প\n${_stories[currentIndex + 1].title}',
                              textAlign: TextAlign.end,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, height: 1.3),
                            ),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        )
                      else
                        const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepIndicatorPill extends StatelessWidget {
  const _StepIndicatorPill({
    required this.label,
    required this.active,
    required this.current,
    required this.accent,
  });

  final String label;
  final bool active;
  final bool current;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: current
            ? accent
            : active
                ? accent.withValues(alpha: 0.15)
                : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: LocalizedText(
        label,
        style: TextStyle(
          color: current
              ? Colors.white
              : active
                  ? accent
                  : const Color(0xFF999999),
          fontWeight: current ? FontWeight.w800 : FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
