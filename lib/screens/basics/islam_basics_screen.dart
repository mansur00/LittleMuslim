import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/duolingo_button.dart';
import '../../widgets/vector_icons.dart';

typedef _QuizItem = ({String questionKey, String answerKey});

class _Chapter {
  const _Chapter({
    required this.id,
    required this.titleKey,
    required this.definitionKey,
    required this.storyKey,
    required this.icon,
    required this.color,
    required this.quiz,
  });
  final int id;
  final String titleKey, definitionKey, storyKey;
  String get title => titleKey;
  String get definition => definitionKey;
  String get story => storyKey;
  final IconData icon;
  final Color color;
  final List<_QuizItem> quiz;
}

const _chapters = <_Chapter>[
  _Chapter(
    id: 1,
    titleKey: 'basics.chapter.1.title',
    definitionKey: 'basics.chapter.1.definition',
    storyKey: 'basics.chapter.1.story',
    icon: Icons.auto_awesome_rounded,
    color: Color(0xFFDDF4E9),
    quiz: [
      (questionKey: 'basics.chapter.1.quiz.1.q', answerKey: 'basics.chapter.1.quiz.1.a'),
      (questionKey: 'basics.chapter.1.quiz.2.q', answerKey: 'basics.chapter.1.quiz.2.a'),
      (questionKey: 'basics.chapter.1.quiz.3.q', answerKey: 'basics.chapter.1.quiz.3.a'),
      (questionKey: 'basics.chapter.1.quiz.4.q', answerKey: 'basics.chapter.1.quiz.4.a'),
      (questionKey: 'basics.chapter.1.quiz.5.q', answerKey: 'basics.chapter.1.quiz.5.a'),
      (questionKey: 'basics.chapter.1.quiz.6.q', answerKey: 'basics.chapter.1.quiz.6.a'),
      (questionKey: 'basics.chapter.1.quiz.7.q', answerKey: 'basics.chapter.1.quiz.7.a'),
      (questionKey: 'basics.chapter.1.quiz.8.q', answerKey: 'basics.chapter.1.quiz.8.a'),
      (questionKey: 'basics.chapter.1.quiz.9.q', answerKey: 'basics.chapter.1.quiz.9.a'),
      (questionKey: 'basics.chapter.1.quiz.10.q', answerKey: 'basics.chapter.1.quiz.10.a'),
    ],
  ),
  _Chapter(
    id: 2,
    titleKey: 'basics.chapter.2.title',
    definitionKey: 'basics.chapter.2.definition',
    storyKey: 'basics.chapter.2.story',
    icon: Icons.lightbulb_rounded,
    color: Color(0xFFE8E2FF),
    quiz: [
      (questionKey: 'basics.chapter.2.quiz.1.q', answerKey: 'basics.chapter.2.quiz.1.a'),
      (questionKey: 'basics.chapter.2.quiz.2.q', answerKey: 'basics.chapter.2.quiz.2.a'),
      (questionKey: 'basics.chapter.2.quiz.3.q', answerKey: 'basics.chapter.2.quiz.3.a'),
      (questionKey: 'basics.chapter.2.quiz.4.q', answerKey: 'basics.chapter.2.quiz.4.a'),
      (questionKey: 'basics.chapter.2.quiz.5.q', answerKey: 'basics.chapter.2.quiz.5.a'),
      (questionKey: 'basics.chapter.2.quiz.6.q', answerKey: 'basics.chapter.2.quiz.6.a'),
      (questionKey: 'basics.chapter.2.quiz.7.q', answerKey: 'basics.chapter.2.quiz.7.a'),
      (questionKey: 'basics.chapter.2.quiz.8.q', answerKey: 'basics.chapter.2.quiz.8.a'),
      (questionKey: 'basics.chapter.2.quiz.9.q', answerKey: 'basics.chapter.2.quiz.9.a'),
      (questionKey: 'basics.chapter.2.quiz.10.q', answerKey: 'basics.chapter.2.quiz.10.a'),
    ],
  ),
  _Chapter(
    id: 3,
    titleKey: 'basics.chapter.3.title',
    definitionKey: 'basics.chapter.3.definition',
    storyKey: 'basics.chapter.3.story',
    icon: Icons.mosque_rounded,
    color: Color(0xFFFFF0CE),
    quiz: [
      (questionKey: 'basics.chapter.3.quiz.1.q', answerKey: 'basics.chapter.3.quiz.1.a'),
      (questionKey: 'basics.chapter.3.quiz.2.q', answerKey: 'basics.chapter.3.quiz.2.a'),
      (questionKey: 'basics.chapter.3.quiz.3.q', answerKey: 'basics.chapter.3.quiz.3.a'),
      (questionKey: 'basics.chapter.3.quiz.4.q', answerKey: 'basics.chapter.3.quiz.4.a'),
      (questionKey: 'basics.chapter.3.quiz.5.q', answerKey: 'basics.chapter.3.quiz.5.a'),
      (questionKey: 'basics.chapter.3.quiz.6.q', answerKey: 'basics.chapter.3.quiz.6.a'),
      (questionKey: 'basics.chapter.3.quiz.7.q', answerKey: 'basics.chapter.3.quiz.7.a'),
      (questionKey: 'basics.chapter.3.quiz.8.q', answerKey: 'basics.chapter.3.quiz.8.a'),
      (questionKey: 'basics.chapter.3.quiz.9.q', answerKey: 'basics.chapter.3.quiz.9.a'),
      (questionKey: 'basics.chapter.3.quiz.10.q', answerKey: 'basics.chapter.3.quiz.10.a'),
    ],
  ),
  _Chapter(
    id: 4,
    titleKey: 'basics.chapter.4.title',
    definitionKey: 'basics.chapter.4.definition',
    storyKey: 'basics.chapter.4.story',
    icon: Icons.rule_rounded,
    color: Color(0xFFDDF1FF),
    quiz: [
      (questionKey: 'basics.chapter.4.quiz.1.q', answerKey: 'basics.chapter.4.quiz.1.a'),
      (questionKey: 'basics.chapter.4.quiz.2.q', answerKey: 'basics.chapter.4.quiz.2.a'),
      (questionKey: 'basics.chapter.4.quiz.3.q', answerKey: 'basics.chapter.4.quiz.3.a'),
      (questionKey: 'basics.chapter.4.quiz.4.q', answerKey: 'basics.chapter.4.quiz.4.a'),
      (questionKey: 'basics.chapter.4.quiz.5.q', answerKey: 'basics.chapter.4.quiz.5.a'),
      (questionKey: 'basics.chapter.4.quiz.6.q', answerKey: 'basics.chapter.4.quiz.6.a'),
      (questionKey: 'basics.chapter.4.quiz.7.q', answerKey: 'basics.chapter.4.quiz.7.a'),
      (questionKey: 'basics.chapter.4.quiz.8.q', answerKey: 'basics.chapter.4.quiz.8.a'),
      (questionKey: 'basics.chapter.4.quiz.9.q', answerKey: 'basics.chapter.4.quiz.9.a'),
      (questionKey: 'basics.chapter.4.quiz.10.q', answerKey: 'basics.chapter.4.quiz.10.a'),
    ],
  ),
  _Chapter(
    id: 5,
    titleKey: 'basics.chapter.5.title',
    definitionKey: 'basics.chapter.5.definition',
    storyKey: 'basics.chapter.5.story',
    icon: Icons.checkroom_rounded,
    color: Color(0xFFFFE0EB),
    quiz: [
      (questionKey: 'basics.chapter.5.quiz.1.q', answerKey: 'basics.chapter.5.quiz.1.a'),
      (questionKey: 'basics.chapter.5.quiz.2.q', answerKey: 'basics.chapter.5.quiz.2.a'),
      (questionKey: 'basics.chapter.5.quiz.3.q', answerKey: 'basics.chapter.5.quiz.3.a'),
      (questionKey: 'basics.chapter.5.quiz.4.q', answerKey: 'basics.chapter.5.quiz.4.a'),
      (questionKey: 'basics.chapter.5.quiz.5.q', answerKey: 'basics.chapter.5.quiz.5.a'),
      (questionKey: 'basics.chapter.5.quiz.6.q', answerKey: 'basics.chapter.5.quiz.6.a'),
      (questionKey: 'basics.chapter.5.quiz.7.q', answerKey: 'basics.chapter.5.quiz.7.a'),
      (questionKey: 'basics.chapter.5.quiz.8.q', answerKey: 'basics.chapter.5.quiz.8.a'),
      (questionKey: 'basics.chapter.5.quiz.9.q', answerKey: 'basics.chapter.5.quiz.9.a'),
      (questionKey: 'basics.chapter.5.quiz.10.q', answerKey: 'basics.chapter.5.quiz.10.a'),
    ],
  ),
  _Chapter(
    id: 6,
    titleKey: 'basics.chapter.6.title',
    definitionKey: 'basics.chapter.6.definition',
    storyKey: 'basics.chapter.6.story',
    icon: Icons.chat_bubble_rounded,
    color: Color(0xFFE5F9DB),
    quiz: [
      (questionKey: 'basics.chapter.6.quiz.1.q', answerKey: 'basics.chapter.6.quiz.1.a'),
      (questionKey: 'basics.chapter.6.quiz.2.q', answerKey: 'basics.chapter.6.quiz.2.a'),
      (questionKey: 'basics.chapter.6.quiz.3.q', answerKey: 'basics.chapter.6.quiz.3.a'),
      (questionKey: 'basics.chapter.6.quiz.4.q', answerKey: 'basics.chapter.6.quiz.4.a'),
      (questionKey: 'basics.chapter.6.quiz.5.q', answerKey: 'basics.chapter.6.quiz.5.a'),
      (questionKey: 'basics.chapter.6.quiz.6.q', answerKey: 'basics.chapter.6.quiz.6.a'),
      (questionKey: 'basics.chapter.6.quiz.7.q', answerKey: 'basics.chapter.6.quiz.7.a'),
      (questionKey: 'basics.chapter.6.quiz.8.q', answerKey: 'basics.chapter.6.quiz.8.a'),
      (questionKey: 'basics.chapter.6.quiz.9.q', answerKey: 'basics.chapter.6.quiz.9.a'),
      (questionKey: 'basics.chapter.6.quiz.10.q', answerKey: 'basics.chapter.6.quiz.10.a'),
    ],
  ),
  _Chapter(
    id: 7,
    titleKey: 'basics.chapter.7.title',
    definitionKey: 'basics.chapter.7.definition',
    storyKey: 'basics.chapter.7.story',
    icon: Icons.favorite_rounded,
    color: Color(0xFFFFECE5),
    quiz: [
      (questionKey: 'basics.chapter.7.quiz.1.q', answerKey: 'basics.chapter.7.quiz.1.a'),
      (questionKey: 'basics.chapter.7.quiz.2.q', answerKey: 'basics.chapter.7.quiz.2.a'),
      (questionKey: 'basics.chapter.7.quiz.3.q', answerKey: 'basics.chapter.7.quiz.3.a'),
      (questionKey: 'basics.chapter.7.quiz.4.q', answerKey: 'basics.chapter.7.quiz.4.a'),
      (questionKey: 'basics.chapter.7.quiz.5.q', answerKey: 'basics.chapter.7.quiz.5.a'),
      (questionKey: 'basics.chapter.7.quiz.6.q', answerKey: 'basics.chapter.7.quiz.6.a'),
      (questionKey: 'basics.chapter.7.quiz.7.q', answerKey: 'basics.chapter.7.quiz.7.a'),
      (questionKey: 'basics.chapter.7.quiz.8.q', answerKey: 'basics.chapter.7.quiz.8.a'),
      (questionKey: 'basics.chapter.7.quiz.9.q', answerKey: 'basics.chapter.7.quiz.9.a'),
      (questionKey: 'basics.chapter.7.quiz.10.q', answerKey: 'basics.chapter.7.quiz.10.a'),
    ],
  ),
  _Chapter(
    id: 8,
    titleKey: 'basics.chapter.8.title',
    definitionKey: 'basics.chapter.8.definition',
    storyKey: 'basics.chapter.8.story',
    icon: Icons.people_rounded,
    color: Color(0xFFEAE5FF),
    quiz: [
      (questionKey: 'basics.chapter.8.quiz.1.q', answerKey: 'basics.chapter.8.quiz.1.a'),
      (questionKey: 'basics.chapter.8.quiz.2.q', answerKey: 'basics.chapter.8.quiz.2.a'),
      (questionKey: 'basics.chapter.8.quiz.3.q', answerKey: 'basics.chapter.8.quiz.3.a'),
      (questionKey: 'basics.chapter.8.quiz.4.q', answerKey: 'basics.chapter.8.quiz.4.a'),
      (questionKey: 'basics.chapter.8.quiz.5.q', answerKey: 'basics.chapter.8.quiz.5.a'),
      (questionKey: 'basics.chapter.8.quiz.6.q', answerKey: 'basics.chapter.8.quiz.6.a'),
      (questionKey: 'basics.chapter.8.quiz.7.q', answerKey: 'basics.chapter.8.quiz.7.a'),
      (questionKey: 'basics.chapter.8.quiz.8.q', answerKey: 'basics.chapter.8.quiz.8.a'),
      (questionKey: 'basics.chapter.8.quiz.9.q', answerKey: 'basics.chapter.8.quiz.9.a'),
      (questionKey: 'basics.chapter.8.quiz.10.q', answerKey: 'basics.chapter.8.quiz.10.a'),
    ],
  ),
  _Chapter(
    id: 9,
    titleKey: 'basics.chapter.9.title',
    definitionKey: 'basics.chapter.9.definition',
    storyKey: 'basics.chapter.9.story',
    icon: Icons.restaurant_rounded,
    color: Color(0xFFE0F7F4),
    quiz: [
      (questionKey: 'basics.chapter.9.quiz.1.q', answerKey: 'basics.chapter.9.quiz.1.a'),
      (questionKey: 'basics.chapter.9.quiz.2.q', answerKey: 'basics.chapter.9.quiz.2.a'),
      (questionKey: 'basics.chapter.9.quiz.3.q', answerKey: 'basics.chapter.9.quiz.3.a'),
      (questionKey: 'basics.chapter.9.quiz.4.q', answerKey: 'basics.chapter.9.quiz.4.a'),
      (questionKey: 'basics.chapter.9.quiz.5.q', answerKey: 'basics.chapter.9.quiz.5.a'),
      (questionKey: 'basics.chapter.9.quiz.6.q', answerKey: 'basics.chapter.9.quiz.6.a'),
      (questionKey: 'basics.chapter.9.quiz.7.q', answerKey: 'basics.chapter.9.quiz.7.a'),
      (questionKey: 'basics.chapter.9.quiz.8.q', answerKey: 'basics.chapter.9.quiz.8.a'),
      (questionKey: 'basics.chapter.9.quiz.9.q', answerKey: 'basics.chapter.9.quiz.9.a'),
      (questionKey: 'basics.chapter.9.quiz.10.q', answerKey: 'basics.chapter.9.quiz.10.a'),
    ],
  ),
  _Chapter(
    id: 10,
    titleKey: 'basics.chapter.10.title',
    definitionKey: 'basics.chapter.10.definition',
    storyKey: 'basics.chapter.10.story',
    icon: Icons.no_food_rounded,
    color: Color(0xFFFFE8E8),
    quiz: [
      (questionKey: 'basics.chapter.10.quiz.1.q', answerKey: 'basics.chapter.10.quiz.1.a'),
      (questionKey: 'basics.chapter.10.quiz.2.q', answerKey: 'basics.chapter.10.quiz.2.a'),
      (questionKey: 'basics.chapter.10.quiz.3.q', answerKey: 'basics.chapter.10.quiz.3.a'),
      (questionKey: 'basics.chapter.10.quiz.4.q', answerKey: 'basics.chapter.10.quiz.4.a'),
      (questionKey: 'basics.chapter.10.quiz.5.q', answerKey: 'basics.chapter.10.quiz.5.a'),
      (questionKey: 'basics.chapter.10.quiz.6.q', answerKey: 'basics.chapter.10.quiz.6.a'),
      (questionKey: 'basics.chapter.10.quiz.7.q', answerKey: 'basics.chapter.10.quiz.7.a'),
      (questionKey: 'basics.chapter.10.quiz.8.q', answerKey: 'basics.chapter.10.quiz.8.a'),
      (questionKey: 'basics.chapter.10.quiz.9.q', answerKey: 'basics.chapter.10.quiz.9.a'),
      (questionKey: 'basics.chapter.10.quiz.10.q', answerKey: 'basics.chapter.10.quiz.10.a'),
    ],
  ),
];

enum _Stage { intro, story, reflect, quiz, result }

class IslamBasicsScreen extends StatefulWidget {
  const IslamBasicsScreen({super.key});
  @override
  State<IslamBasicsScreen> createState() => _IslamBasicsScreenState();
}

class _IslamBasicsScreenState extends State<IslamBasicsScreen> {
  int? _chapterIndex;
  _Stage _stage = _Stage.intro;
  int _itemIndex = 0;
  int? _selected;
  bool _checked = false;

  int _correctAnswers = 0;
  int _unansweredCount = 0;
  final Map<int, bool> _firstAttemptStatus = {};
  bool _lastCompletionEarnedXp = false;

  void _startChapter(int index) {
    final chapterId = 'basics_chapter_$index';
    final saved = context.read<AppState>().basicsProgress(chapterId);
    final stageIndex = saved == 0 ? 0 : ((saved - 1) ~/ 100).clamp(0, 3);
    final itemIndex = saved == 0 ? 0 : ((saved - 1) % 100).clamp(0, 9);
    setState(() {
      _chapterIndex = index;
      _stage = _Stage.values[stageIndex];
      _itemIndex = itemIndex;
      _selected = null;
      _checked = false;
      _correctAnswers = 0;
      _unansweredCount = 0;
      _firstAttemptStatus.clear();
      _lastCompletionEarnedXp = false;
    });
  }

  Future<void> _saveCurrentProgress() async {
    final index = _chapterIndex;
    if (index == null || _stage == _Stage.result) return;
    await context.read<AppState>().saveBasicsProgress(
          'basics_chapter_$index',
          _stage.index * 100 + _itemIndex + 1,
        );
  }

  void _nextStage() {
    setState(() {
      _selected = null;
      _checked = false;
      _itemIndex = 0;
      _stage = switch (_stage) {
        _Stage.intro => _Stage.story,
        _Stage.story => _Stage.reflect,
        _Stage.reflect => _Stage.quiz,
        _Stage.quiz => _Stage.result,
        _Stage.result => _Stage.result,
      };
    });
    _saveCurrentProgress();
  }

  Future<void> _finishChapter() async {
    final index = _chapterIndex!;
    final score = _correctAnswers;
    final appState = context.read<AppState>();
    await appState.recordQuizResult('basics_chapter_$index', score);
    final earned = await appState.completeLesson('basics_chapter_$index', xp: 25);
    await appState.clearBasicsProgress('basics_chapter_$index');
    if (!mounted) return;
    setState(() {
      _lastCompletionEarnedXp = earned;
      _stage = _Stage.result;
    });
  }

  void _retryQuiz() {
    setState(() {
      _stage = _Stage.quiz;
      _itemIndex = 0;
      _selected = null;
      _checked = false;
      _correctAnswers = 0;
      _unansweredCount = 0;
      _firstAttemptStatus.clear();
    });
    _saveCurrentProgress();
  }

  void _restartChapter() {
    setState(() {
      _stage = _Stage.intro;
      _itemIndex = 0;
      _selected = null;
      _checked = false;
      _correctAnswers = 0;
      _unansweredCount = 0;
      _firstAttemptStatus.clear();
    });
    _saveCurrentProgress();
  }

  Future<void> _handleExit() async {
    if (_chapterIndex == null) {
      Navigator.pop(context);
      return;
    }
    if (_stage == _Stage.intro || _stage == _Stage.result) {
      setState(() => _chapterIndex = null);
      return;
    }
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(context.t('basics.pause.title')),
        content: Text(context.t('basics.pause.body')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.t('basics.pause.continue')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE05A7A)),
            child: Text(context.t('basics.pause.exit')),
          ),
        ],
      ),
    );
    if (shouldExit == true && mounted) {
      await _saveCurrentProgress();
      setState(() => _chapterIndex = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    if (_chapterIndex == null) return _buildChapterList(tablet);
    final chapter = _chapters[_chapterIndex!];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _handleExit();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.cream,
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(children: [
            _topBar(chapter, tablet),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: tablet ? 36 : 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 10,
                        backgroundColor: Colors.white,
                        color: AppTheme.primaryGreen))),
            Expanded(child: _stageContent(chapter, tablet)),
          ]),
        ))),
      ),
    );
  }

  double get _progress => switch (_stage) {
        _Stage.intro => .08,
        _Stage.story => .18,
        _Stage.reflect => .2 + .3 * (_itemIndex + 1) / 10,
        _Stage.quiz => .5 + .5 * (_itemIndex + (_checked ? 1 : 0)) / 10,
        _Stage.result => 1.0,
      };

  Widget _topBar(_Chapter chapter, bool tablet) => Padding(
        padding: EdgeInsets.fromLTRB(tablet ? 32 : 18, 8, 18, 10),
        child: Row(children: [
          IconButton.filledTonal(
              onPressed: _handleExit,
              icon: const Icon(Icons.arrow_back_rounded),
              style: IconButton.styleFrom(backgroundColor: Colors.white)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(context.t(chapter.titleKey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.darkText))),
          LocalizedText(
              switch (_stage) {
                _Stage.intro => context.t('basics.stage.intro'),
                _Stage.story => context.t('basics.stage.story'),
                _Stage.reflect => context.t('basics.stage.reflect', params: {'current': '${_itemIndex + 1}'}),
                _Stage.quiz => context.t('basics.stage.quiz', params: {'current': '${_itemIndex + 1}'}),
                _Stage.result => context.t('basics.stage.result'),
              },
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: AppTheme.primaryGreen)),
        ]),
      );

  Widget _buildChapterList(bool tablet) {
    final state = context.watch<AppState>();
    // Lessons unlock in order; completed chapter ids are saved by AppState.
    final firstIncomplete = List.generate(_chapters.length, (i) => i)
        .firstWhere((i) => !state.hasCompletedLesson('basics_chapter_$i'),
            orElse: () => _chapters.length);
    final completedCount = List.generate(_chapters.length, (i) => i)
        .where((i) => state.hasCompletedLesson('basics_chapter_$i'))
        .length;
    return Scaffold(
        backgroundColor: AppTheme.cream,
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: ListView(
                        padding: EdgeInsets.all(tablet ? 32 : 18),
                        children: [
                          DuolingoPageHeader(
                            title: context.t('basics.header.title'),
                            subtitle: context.t('basics.header.subtitle'),
                            customIcon: Image.asset(
                              'assets/images/badge_basics_3d.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                            gradientColors: [
                              Color(0xFF58CC02),
                              Color(0xFF46A302)
                            ],
                            onBack: () => Navigator.pop(context),
                            trailing: LocalizedText(
                                '$completedCount/${_chapters.length}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900)),
                          ),
                          const SizedBox(height: 20),
                          for (var i = 0; i < _chapters.length; i++) ...[
                            _ChapterCard(
                                chapter: _chapters[i],
                                index: i,
                                completed: state
                                    .hasCompletedLesson('basics_chapter_$i'),
                                quizScore:
                                    state.quizResult('basics_chapter_$i'),
                                inProgress:
                                    state.basicsProgress('basics_chapter_$i') >
                                        0,
                                locked: !state.isAdmin &&
                                    i > firstIncomplete &&
                                    !state.hasCompletedLesson(
                                        'basics_chapter_$i'),
                                onTap: () => _startChapter(i)),
                            const SizedBox(height: 11),
                          ],
                        ])))));
  }

  Widget _stageContent(_Chapter chapter, bool tablet) {
    final pad = EdgeInsets.all(tablet ? 32 : 20);
    if (_stage == _Stage.intro) {
      return ListView(padding: pad, children: [
        _IllustrationCard(chapter: chapter),
        const SizedBox(height: 18),
        Text(context.t('basics.intro.know_easily'),
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: AppTheme.darkText)),
        const SizedBox(height: 8),
        Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(context.t(chapter.definitionKey),
                style: const TextStyle(
                    fontSize: 16, height: 1.7, color: AppTheme.darkText))),
        const SizedBox(height: 17),
        _primaryButton(
            context.t('basics.intro.next_story'), Icons.auto_stories_rounded, _nextStage),
      ]);
    }
    if (_stage == _Stage.story) {
      return ListView(padding: pad, children: [
        _IllustrationCard(chapter: chapter, compact: true),
        const SizedBox(height: 17),
        Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(22)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(context.t('basics.story.short_story'),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.darkText)),
              const SizedBox(height: 12),
              Text(context.t(chapter.storyKey),
                  style: const TextStyle(
                      fontSize: 16, height: 1.85, color: AppTheme.darkText))
            ])),
        const SizedBox(height: 16),
        _primaryButton(
            context.t('basics.story.think_story'), Icons.psychology_alt_rounded, _nextStage),
      ]);
    }
    if (_stage == _Stage.reflect) {
      return ListView(padding: pad, children: [
        _StageLabel(
            color: chapter.color,
            icon: Icons.psychology_alt_rounded,
            title: context.t('basics.reflect.title'),
            subtitle: context.t('basics.reflect.subtitle')),
        const SizedBox(height: 18),
        Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(22)),
            child: Column(children: [
              LocalizedText('${_itemIndex + 1}',
                  style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryGreen)),
              const SizedBox(height: 8),
              LocalizedText(_reflectionQuestion(chapter, _itemIndex),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 19,
                      height: 1.6,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkText)),
              const SizedBox(height: 16),
              LocalizedText(
                  context.t('basics.reflect.hint'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.darkText.withValues(alpha: .65),
                      height: 1.5))
            ])),
        const SizedBox(height: 18),
        _primaryButton(
            _itemIndex == 9 ? context.t('basics.reflect.take_quiz') : context.t('basics.reflect.next_question'),
            _itemIndex == 9 ? Icons.quiz_rounded : Icons.arrow_forward_rounded,
            () {
          if (_itemIndex < 9) {
            setState(() => _itemIndex++);
          } else {
            _nextStage();
          }
          _saveCurrentProgress();
        }),
      ]);
    }
    if (_stage == _Stage.quiz) {
      return _quizContent(chapter, tablet);
    }
    return _resultContent(chapter, tablet);
  }

  Widget _quizContent(_Chapter chapter, bool tablet) {
    final item = chapter.quiz[_itemIndex];
    final options = _optionsFor(chapter, _itemIndex);
    final isCorrect =
        _selected != null && options[_selected!] == context.t(item.answerKey);

    return ListView(padding: EdgeInsets.all(tablet ? 32 : 20), children: [
      _StageLabel(
          color: chapter.color,
          icon: Icons.quiz_rounded,
          title: context.t('basics.quiz.title'),
          subtitle: context.t('basics.quiz.subtitle')),
      const SizedBox(height: 18),
      Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(22)),
          child: Column(children: [
            Text(context.t('basics.quiz.question_counter', params: {'current': '${_itemIndex + 1}', 'total': '10'}),
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: AppTheme.primaryGreen)),
            const SizedBox(height: 10),
            Text(context.t(item.questionKey),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    height: 1.5,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.darkText))
          ])),
      const SizedBox(height: 15),
      for (var i = 0; i < options.length; i++)
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _QuizOption(
                text: options[i],
                selected: _selected == i,
                correct: _checked && options[i] == context.t(item.answerKey),
                color: chapter.color,
                onTap: _checked ? null : () => setState(() => _selected = i))),
      if (_checked) ...[
        Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LocalizedText(
                isCorrect
                    ? context.t('basics.quiz.correct_feedback')
                    : context.t('basics.quiz.wrong_feedback', params: {'correct': context.t(item.answerKey)}),
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isCorrect
                        ? AppTheme.primaryGreen
                        : const Color(0xFFD63031)))),
      ],
      _primaryButton(
          !_checked
              ? context.t('basics.quiz.check_answer')
              : (_itemIndex == 9 ? context.t('basics.quiz.see_result') : context.t('basics.quiz.next_question')),
          !_checked
              ? Icons.check_rounded
              : Icons.arrow_forward_rounded, () {
        if (_selected == null) return;
        if (!_checked) {
          final correct = options[_selected!] == context.t(item.answerKey);
          if (!_firstAttemptStatus.containsKey(_itemIndex)) {
            _firstAttemptStatus[_itemIndex] = correct;
            if (correct) {
              _correctAnswers++;
            }
          }
          setState(() => _checked = true);
          return;
        }
        if (_itemIndex < 9) {
          setState(() {
            _itemIndex++;
            _selected = null;
            _checked = false;
          });
          _saveCurrentProgress();
          return;
        }
        _finishChapter();
      }, enabled: _checked || _selected != null),
      if (!_checked) ...[
        const SizedBox(height: 10),
        Center(
          child: TextButton.icon(
            onPressed: () {
              if (!_firstAttemptStatus.containsKey(_itemIndex)) {
                _firstAttemptStatus[_itemIndex] = false;
                _unansweredCount++;
              }
              if (_itemIndex < 9) {
                setState(() {
                  _itemIndex++;
                  _selected = null;
                  _checked = false;
                });
                _saveCurrentProgress();
              } else {
                _finishChapter();
              }
            },
            icon: const Icon(Icons.skip_next_rounded, size: 18),
            label: Text(context.t('basics.quiz.skip_question')),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.darkText.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    ]);
  }

  Widget _resultContent(_Chapter chapter, bool tablet) {
    final score = _correctAnswers;
    final total = chapter.quiz.length;
    final incorrect = total - score - _unansweredCount;
    final earned = _lastCompletionEarnedXp;

    return ListView(
      padding: EdgeInsets.all(tablet ? 32 : 20),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.primaryGreen.withValues(alpha: 0.25),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: score >= 7
                      ? const Color(0xFFDDF4E9)
                      : const Color(0xFFFFF4D4),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    score >= 7
                        ? Icons.emoji_events_rounded
                        : Icons.stars_rounded,
                    color: score >= 7
                        ? AppTheme.primaryGreen
                        : const Color(0xFFD4A017),
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.t('basics.result.title'),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 8),
              LocalizedText(
                '$score / $total',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: score >= 7
                      ? AppTheme.primaryGreen
                      : const Color(0xFFD4A017),
                ),
              ),
              const SizedBox(height: 8),
              LocalizedText(
                score == 10
                    ? context.t('basics.result.perfect')
                    : score >= 7
                        ? context.t('basics.result.good')
                        : context.t('basics.result.retry_advice'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: earned
                      ? const Color(0xFFE8F8D8)
                      : const Color(0xFFF1EEE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      earned
                          ? Icons.add_circle_rounded
                          : Icons.check_circle_rounded,
                      size: 18,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(width: 6),
                    LocalizedText(
                      earned
                          ? context.t('basics.result.xp_earned')
                          : context.t('basics.result.xp_already'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ResultStat(
                    label: context.t('basics.result.correct_label'),
                    value: '$score',
                    color: const Color(0xFF58A700),
                  ),
                  _ResultStat(
                    label: context.t('basics.result.wrong_label'),
                    value: '$incorrect',
                    color: const Color(0xFFD63031),
                  ),
                  if (_unansweredCount > 0)
                    _ResultStat(
                      label: context.t('basics.result.skipped_label'),
                      value: '$_unansweredCount',
                      color: const Color(0xFF888888),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _primaryButton(
          context.t('basics.result.retry_btn'),
          Icons.refresh_rounded,
          _retryQuiz,
        ),
        const SizedBox(height: 10),
        Duolingo3DButton(
          text: context.t('basics.result.back_to_list'),
          icon: const Icon(Icons.list_rounded),
          color: AppTheme.primaryGreen,
          onPressed: () => setState(() => _chapterIndex = null),
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton.icon(
            onPressed: _restartChapter,
            icon: const Icon(Icons.auto_stories_rounded, size: 18),
            label: Text(context.t('basics.result.read_from_start')),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.darkText.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }

  List<String> _optionsFor(_Chapter chapter, int index) {
    final correct = context.t(chapter.quiz[index].answerKey);
    final wrong = <String>[];
    for (var offset = 1;
        wrong.length < 2 && offset < chapter.quiz.length;
        offset++) {
      final value =
          context.t(chapter.quiz[(index + offset) % chapter.quiz.length].answerKey);
      if (value != correct && !wrong.contains(value)) wrong.add(value);
    }
    final list = [correct, ...wrong];
    // Stable per-question shuffle so the answer position isn't always first.
    final shift = index % list.length;
    return [...list.skip(shift), ...list.take(shift)];
  }

  String _reflectionQuestion(_Chapter chapter, int index) {
    final prompts = [
      context.t('basics.reflect.q1'),
      context.t('basics.reflect.q2'),
      context.t('basics.reflect.q3'),
      context.t('basics.reflect.q4'),
      context.t('basics.reflect.q5'),
      context.t('basics.reflect.q6'),
      context.t('basics.reflect.q7'),
      context.t('basics.reflect.q8'),
      context.t('basics.reflect.q9'),
      context.t('basics.reflect.q10'),
    ];
    return '${context.t(chapter.quiz[index].questionKey)} ${prompts[index]}';
  }

  Widget _primaryButton(String label, IconData icon, VoidCallback onPressed,
          {bool enabled = true}) =>
      Opacity(
        opacity: enabled ? 1 : .45,
        child: Duolingo3DButton(
          text: label,
          icon: Icon(icon),
          color: AppTheme.primaryGreen,
          onPressed: enabled ? onPressed : () {},
        ),
      );
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard(
      {required this.chapter,
      required this.index,
      required this.completed,
      required this.inProgress,
      required this.quizScore,
      required this.locked,
      required this.onTap});
  final _Chapter chapter;
  final int index;
  final bool completed, inProgress, locked;
  final int? quizScore;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => DuolingoCard(
      onTap: locked ? null : onTap,
      accentColor: completed ? AppTheme.primaryGreen : AppTheme.primaryDark,
      backgroundColor: locked ? const Color(0xFFF1EEE7) : Colors.white,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(15),
      child: Row(children: [
        CircleAvatar(
            radius: 25,
            backgroundColor: chapter.color,
            child: Icon(locked ? Icons.lock_rounded : chapter.icon,
                color: AppTheme.primaryGreen)),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(context.t('basics.card.chapter_n', params: {'number': '${index + 1}'}),
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryGreen)),
          const SizedBox(height: 2),
          LocalizedText(chapter.title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkText)),
          const SizedBox(height: 3),
          Text(
              completed
                  ? context.t('basics.card.completed_status', params: {'score': '${quizScore ?? 10}'})
                  : locked
                      ? context.t('basics.card.locked_status')
                      : inProgress
                          ? context.t('basics.card.resume_status')
                          : context.t('basics.card.default_status'),
              style: const TextStyle(fontSize: 11, color: Colors.black54))
        ])),
        Icon(
            completed
                ? Icons.check_circle_rounded
                : locked
                    ? Icons.lock_rounded
                    : Icons.arrow_forward_ios_rounded,
            color: completed ? AppTheme.primaryGreen : Colors.black38,
            size: 19)
      ]));
}

class _IllustrationCard extends StatelessWidget {
  const _IllustrationCard({required this.chapter, this.compact = false});
  final _Chapter chapter;
  final bool compact;
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 15 : 22),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [chapter.color, Colors.white]),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
                color: chapter.color.withValues(alpha: .9),
                blurRadius: 15,
                offset: const Offset(0, 7))
          ]),
      child: Row(children: [
        Container(
            width: compact ? 62 : 84,
            height: compact ? 62 : 84,
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .82),
                shape: BoxShape.circle),
            child: Icon(chapter.icon,
                size: compact ? 34 : 48, color: AppTheme.primaryGreen)),
        const SizedBox(width: 16),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LocalizedText(chapter.title,
              style: TextStyle(
                  fontSize: compact ? 18 : 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkText)),
          const SizedBox(height: 5),
          Text(compact ? context.t('basics.card.remember_story') : context.t('basics.card.see_understand_learn'),
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryGreen))
        ]))
      ]));
}

class _StageLabel extends StatelessWidget {
  const _StageLabel(
      {required this.color,
      required this.icon,
      required this.title,
      required this.subtitle});
  final Color color;
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(17),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(21)),
      child: Row(children: [
        CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: AppTheme.primaryGreen)),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LocalizedText(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkText)),
          LocalizedText(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54))
        ]))
      ]));
}

class _QuizOption extends StatelessWidget {
  const _QuizOption(
      {required this.text,
      required this.selected,
      required this.correct,
      required this.color,
      required this.onTap});
  final String text;
  final bool selected, correct;
  final Color color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: correct
                      ? const Color(0xFFDDF4E9)
                      : selected
                          ? color
                          : Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                      color: correct || selected
                          ? AppTheme.primaryGreen
                          : Colors.white,
                      width: 2)),
              child: Row(children: [
                Icon(
                    correct
                        ? Icons.check_circle_rounded
                        : selected
                            ? Icons.radio_button_checked_rounded
                            : Icons.circle_outlined,
                    color: AppTheme.primaryGreen),
                const SizedBox(width: 11),
                Expanded(
                    child: LocalizedText(text,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.darkText)))
              ]))));
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocalizedText(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        LocalizedText(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

