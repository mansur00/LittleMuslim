import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/duolingo_appbar.dart';

class _SeerahStory {
  const _SeerahStory({
    required this.id,
    required this.iconType,
    required this.accent,
    required this.color,
  });

  final String id;
  final VectorIconType iconType;
  final Color accent;
  final Color color;

  String getLocalizedTitle(BuildContext context) =>
      context.t('seerah.story.' + id + '.title');

  String getLocalizedSubtitle(BuildContext context) =>
      context.t('seerah.story.' + id + '.subtitle');

  String getLocalizedReadTime(BuildContext context) =>
      context.t('seerah.story.' + id + '.read_time');

  String getLocalizedReference(BuildContext context) =>
      context.t('seerah.story.' + id + '.reference');

  String getLocalizedBody(BuildContext context) =>
      context.t('seerah.story.' + id + '.body');

  String getLocalizedLesson(BuildContext context) =>
      context.t('seerah.story.' + id + '.lesson');
}

const _stories = [
  _SeerahStory(
    id: 'abu_umair',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF58A700),
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'hasan_kindness',
    iconType: VectorIconType.star,
    accent: Color(0xFFD4A017),
    color: Color(0xFFFFF6D0),
  ),
  _SeerahStory(
    id: 'first_revelation',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF46A302),
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'zamzam_baby',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF3B82C4),
    color: Color(0xFFDCEBFF),
  ),
  _SeerahStory(
    id: 'kaaba_corner',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF9B6BC9),
    color: Color(0xFFF3E8FF),
  ),
  _SeerahStory(
    id: 'khadija_trust',
    iconType: VectorIconType.star,
    accent: Color(0xFFE05A7A),
    color: Color(0xFFFFEBCF),
  ),
  _SeerahStory(
    id: 'bilal_patience',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF58A700),
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'anas_servant',
    iconType: VectorIconType.star,
    accent: Color(0xFFD4A017),
    color: Color(0xFFFFF6D0),
  ),
  _SeerahStory(
    id: 'migration_madina',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF46A302),
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'badr_dua',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF3B82C4),
    color: Color(0xFFDCEBFF),
  ),
  _SeerahStory(
    id: 'conquest_mercy',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF9B6BC9),
    color: Color(0xFFF3E8FF),
  ),
  _SeerahStory(
    id: 'taif_patience',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFFE8913A),
    color: Color(0xFFFFEBCF),
  ),
  _SeerahStory(
    id: 'suleiman_wisdom',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF58A700),
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'madinah_brotherhood',
    iconType: VectorIconType.star,
    accent: Color(0xFFD4A017),
    color: Color(0xFFFFF6D0),
  ),
  _SeerahStory(
    id: 'uhud_wound',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF46A302),
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'marriage_khadija',
    iconType: VectorIconType.star,
    accent: Color(0xFFE05A7A),
    color: Color(0xFFFFEBCF),
  ),
  _SeerahStory(
    id: 'isra_miraj',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF9B6BC9),
    color: Color(0xFFF3E8FF),
  ),
  _SeerahStory(
    id: 'arqam_house',
    iconType: VectorIconType.scroll,
    accent: Color(0xFF3B82C4),
    color: Color(0xFFDCEBFF),
  ),
  _SeerahStory(
    id: 'farewell_sermon',
    iconType: VectorIconType.scroll,
    accent: Color(0xFF46A302),
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'hadith_smile',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF58A700),
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'food_sharing',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFFD4A017),
    color: Color(0xFFFFF6D0),
  ),
  _SeerahStory(
    id: 'muadh_kindness',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF46A302),
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'ashab_suffa',
    iconType: VectorIconType.scroll,
    accent: Color(0xFF9B6BC9),
    color: Color(0xFFF3E8FF),
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
                        title: context.t('seerah.header_title'),
                        subtitle: context.t('seerah.header_subtitle'),
                        customIcon: Image.asset(
                          'assets/images/badge_seerah_3d.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                        gradientColors: const [
                          Color(0xFFE05A7A),
                          Color(0xFFC44569)
                        ],
                        onBack: () => Navigator.pop(context),
                      ),

                      DuolingoSectionLabel(
                        label: context.t('seerah.section_title'),
                        badgeText: context.t('seerah.completed_badge', params: {
                          'completed': context.formatDigits('$completed'),
                          'total': context.formatDigits('${_stories.length}'),
                        }),
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
                      Text(
                        context.t('seerah.disclaimer'),
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
                    Text(story.getLocalizedTitle(context),
                        style: const TextStyle(
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                    const SizedBox(height: 3),
                    Text(
                        widget.completed
                            ? context.t('seerah.status_completed')
                            : widget.inProgress
                                ? context.t('seerah.status_in_progress')
                                : story.getLocalizedSubtitle(context),
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
                        child: Text(story.getLocalizedReadTime(context),
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
                        child: Text(story.getLocalizedReference(context),
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
        title: Row(
          children: [
            const Icon(Icons.celebration_rounded,
                color: Color(0xFF58A700), size: 28),
            const SizedBox(width: 10),
            Expanded(child: Text(context.t('seerah.dialog.mashaallah'))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              earned
                  ? context.t('seerah.dialog.completed_earned')
                  : context.t('seerah.dialog.completed_reopened'),
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            if (hasNext)
              Text(
                context.t('seerah.dialog.next_story', params: {'title': _stories[currentIndex + 1].getLocalizedTitle(context)}),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryGreen,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.t('seerah.dialog.stay')),
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
              child: Text(context.t('seerah.dialog.read_next')),
            )
          else
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen),
              child: Text(context.t('seerah.dialog.back_to_list')),
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
          title: Text(context.t('seerah.exit.title')),
          content: Text(context.t('seerah.exit.desc')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(context.t('seerah.exit.btn_continue')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE05A7A)),
              child: Text(context.t('seerah.exit.btn_break')),
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
                    title: _currentStory.getLocalizedTitle(context),
                    subtitle:
                        '${_currentStory.getLocalizedReadTime(context)}  ·  ${_currentStory.getLocalizedReference(context)}',
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
                          label: context.t('seerah.step.1'),
                          active: _step >= 0,
                          current: _step == 0,
                          accent: _currentStory.accent,
                        ),
                        Icon(Icons.chevron_right_rounded,
                            size: 16,
                            color: _currentStory.accent.withValues(alpha: 0.4)),
                        _StepIndicatorPill(
                          label: context.t('seerah.step.2'),
                          active: _step >= 1,
                          current: _step == 1,
                          accent: _currentStory.accent,
                        ),
                        Icon(Icons.chevron_right_rounded,
                            size: 16,
                            color: _currentStory.accent.withValues(alpha: 0.4)),
                        _StepIndicatorPill(
                          label: context.t('seerah.step.3'),
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
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Color(0xFF58A700), size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              context.t('seerah.banner_finished'),
                              style: const TextStyle(
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
                      child: Text(
                        _currentStory.getLocalizedBody(context),
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
                      label: Text(context.t('seerah.btn_read_lesson'),
                          style: const TextStyle(
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
                              Text(context.t('seerah.lesson_title'),
                                  style: TextStyle(
                                      color: _currentStory.accent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800)),
                            ]),
                            const SizedBox(height: 10),
                            Text(_currentStory.getLocalizedLesson(context),
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
                        DSButton(
                          label: context.t('seerah.btn_review_story'),
                          variant: DSButtonVariant.outline,
                          icon: Icons.arrow_back_rounded,
                          onPressed: () => _advanceStep(0),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DSButton(
                            label: context.t('seerah.btn_finish_xp'),
                            variant: DSButtonVariant.primary,
                            icon: Icons.celebration_rounded,
                            onPressed: _finishStory,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Reference footnote
                  Text(
                    context.t('seerah.source', params: {'reference': _currentStory.getLocalizedReference(context)}),
                    style: TextStyle(
                        color: AppTheme.darkText.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),

                  // Review restart action in step 2
                  if (_step == 2) ...[
                    const SizedBox(height: 12),
                    DSButton(
                      label: context.t('seerah.btn_restart'),
                      variant: DSButtonVariant.outline,
                      icon: Icons.refresh_rounded,
                      onPressed: () => _advanceStep(0),
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
                          child: DSButton(
                            label: context.t('seerah.btn_prev'),
                            icon: Icons.chevron_left_rounded,
                            variant: DSButtonVariant.outline,
                            onPressed: () =>
                                _goToStory(_stories[currentIndex - 1]),
                          ),
                        )
                      else
                        const Spacer(),
                      const SizedBox(width: 10),
                      if (hasNext)
                        Expanded(
                          child: DSButton(
                            label: context.t('seerah.btn_next'),
                            icon: Icons.chevron_right_rounded,
                            variant: DSButtonVariant.secondary,
                            onPressed: () =>
                                _goToStory(_stories[currentIndex + 1]),
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
      child: Text(
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
