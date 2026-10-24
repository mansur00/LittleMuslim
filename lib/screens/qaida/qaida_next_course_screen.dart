import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/duolingo_button.dart';
import '../../widgets/vector_icons.dart';

const qaidaCourseTitleKeys = [
  'qaida.course.0.title',
  'qaida.course.1.title',
  'qaida.course.2.title',
  'qaida.course.3.title',
];
const qaidaCourseTitles = qaidaCourseTitleKeys;
const qaidaCourseLetters = ['بـ', 'بَ', 'مَدّ', 'آية'];
const qaidaCourseCount = 4;

String getQaidaCourseTitle(BuildContext context, int index) {
  if (index >= 0 && index < qaidaCourseCount) {
    return context.t('qaida.course.$index.title');
  }
  return context.t(qaidaCourseTitleKeys[index.clamp(0, qaidaCourseTitleKeys.length - 1)]);
}

class _Exercise {
  const _Exercise(this.stage, this.prompt, this.options, this.answer);
  final String stage, prompt;
  final List<String> options;
  final int answer;
}

class _Course {
  const _Course(this.title, this.description, this.example, this.color,
      this.icon, this.exercises);
  final String title, description, example;
  final Color color;
  final IconData icon;
  final List<_Exercise> exercises;
}

List<_Course> _getCourses(BuildContext context) => [
  _Course(
    context.t('qaida.course.0.title'),
    context.t('qaida.course.0.desc'),
    'ب + ا = با',
    const Color(0xFFDDF4E9),
    Icons.extension_rounded,
    [
      _Exercise(
        context.t('qaida.course.stage.look_learn'),
        context.t('qaida.course.0.0.prompt'),
        const ['با', 'بت', 'اب'],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.recognize_form'),
        context.t('qaida.course.0.1.prompt'),
        const ['بـ', 'ـبـ', 'ـب'],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.join'),
        context.t('qaida.course.0.2.prompt'),
        const ['تا', 'با', 'تي'],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.remember'),
        context.t('qaida.course.0.3.prompt'),
        const ['ا د ذ ر ز و', 'ب ت ث ج ح', 'س ش ص ض ط'],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.read_myself'),
        context.t('qaida.course.0.4.prompt'),
        [
          context.t('qaida.course.0.4.opt0'),
          context.t('qaida.course.0.4.opt1'),
          context.t('qaida.course.0.4.opt2'),
        ],
        0,
      ),
    ],
  ),
  _Course(
    context.t('qaida.course.1.title'),
    context.t('qaida.course.1.desc'),
    'بَ  بِ  بُ',
    const Color(0xFFFFEBCF),
    Icons.graphic_eq_rounded,
    [
      _Exercise(
        context.t('qaida.course.stage.zabar'),
        context.t('qaida.course.1.0.prompt'),
        [
          context.t('qaida.course.1.0.opt0'),
          context.t('qaida.course.1.0.opt1'),
          context.t('qaida.course.1.0.opt2'),
        ],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.zer'),
        context.t('qaida.course.1.1.prompt'),
        [
          context.t('qaida.course.1.1.opt0'),
          context.t('qaida.course.1.1.opt1'),
          context.t('qaida.course.1.1.opt2'),
        ],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.pesh'),
        context.t('qaida.course.1.2.prompt'),
        [
          context.t('qaida.course.1.2.opt0'),
          context.t('qaida.course.1.2.opt1'),
          context.t('qaida.course.1.2.opt2'),
        ],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.sequence'),
        context.t('qaida.course.1.3.prompt'),
        [
          context.t('qaida.course.1.3.opt0'),
          context.t('qaida.course.1.3.opt1'),
          context.t('qaida.course.1.3.opt2'),
        ],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.read_myself'),
        context.t('qaida.course.1.4.prompt'),
        [
          context.t('qaida.course.1.4.opt0'),
          context.t('qaida.course.1.4.opt1'),
          context.t('qaida.course.1.4.opt2'),
        ],
        0,
      ),
    ],
  ),
  _Course(
    context.t('qaida.course.2.title'),
    context.t('qaida.course.2.desc'),
    'مَدّ · غُنَّة',
    const Color(0xFFE8E2FF),
    Icons.waves_rounded,
    [
      _Exercise(
        context.t('qaida.course.stage.madd'),
        context.t('qaida.course.2.0.prompt'),
        [
          context.t('qaida.course.2.0.opt0'),
          context.t('qaida.course.2.0.opt1'),
          context.t('qaida.course.2.0.opt2'),
        ],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.madd_letters'),
        context.t('qaida.course.2.1.prompt'),
        const ['ا و ي', 'ب ت ث', 'ج ح خ'],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.ghunnah'),
        context.t('qaida.course.2.2.prompt'),
        [
          context.t('qaida.course.2.2.opt0'),
          context.t('qaida.course.2.2.opt1'),
          context.t('qaida.course.2.2.opt2'),
        ],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.listen_remember'),
        context.t('qaida.course.2.3.prompt'),
        [
          context.t('qaida.course.2.3.opt0'),
          context.t('qaida.course.2.3.opt1'),
          context.t('qaida.course.2.3.opt2'),
        ],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.read_with_teacher'),
        context.t('qaida.course.2.4.prompt'),
        [
          context.t('qaida.course.2.4.opt0'),
          context.t('qaida.course.2.4.opt1'),
          context.t('qaida.course.2.4.opt2'),
        ],
        0,
      ),
    ],
  ),
  _Course(
    context.t('qaida.course.3.title'),
    context.t('qaida.course.3.desc'),
    'قُلْ هُوَ اللَّهُ أَحَدٌ',
    const Color(0xFFDDF1FF),
    Icons.menu_book_rounded,
    [
      _Exercise(
        context.t('qaida.course.stage.look_ayah'),
        context.t('qaida.course.3.0.prompt'),
        [
          context.t('qaida.course.3.0.opt0'),
          context.t('qaida.course.3.0.opt1'),
          context.t('qaida.course.3.0.opt2'),
        ],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.join_letters'),
        context.t('qaida.course.3.1.prompt'),
        [
          context.t('qaida.course.3.1.opt0'),
          context.t('qaida.course.3.1.opt1'),
          context.t('qaida.course.3.1.opt2'),
        ],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.read_slowly'),
        context.t('qaida.course.3.2.prompt'),
        [
          context.t('qaida.course.3.2.opt0'),
          context.t('qaida.course.3.2.opt1'),
          context.t('qaida.course.3.2.opt2'),
        ],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.remember'),
        context.t('qaida.course.3.3.prompt'),
        [
          context.t('qaida.course.3.3.opt0'),
          context.t('qaida.course.3.3.opt1'),
          context.t('qaida.course.3.3.opt2'),
        ],
        0,
      ),
      _Exercise(
        context.t('qaida.course.stage.listen_verify'),
        context.t('qaida.course.3.4.prompt'),
        [
          context.t('qaida.course.3.4.opt0'),
          context.t('qaida.course.3.4.opt1'),
          context.t('qaida.course.3.4.opt2'),
        ],
        0,
      ),
    ],
  ),
];

int firstIncompleteQaidaCourse(AppState state) {
  for (var i = 0; i < qaidaCourseCount; i++) {
    if (!state.hasCompletedLesson('qaida_course_$i')) return i;
  }
  return 0;
}

class QaidaNextCourseScreen extends StatefulWidget {
  const QaidaNextCourseScreen(
      {super.key, this.initialIndex = 0, this.stopAfterIndex});
  final int initialIndex;
  final int? stopAfterIndex;
  @override
  State<QaidaNextCourseScreen> createState() => _QaidaNextCourseScreenState();
}

class _QaidaNextCourseScreenState extends State<QaidaNextCourseScreen> {
  final FlutterTts _tts = FlutterTts();
  late int _index = widget.initialIndex.clamp(0, qaidaCourseCount - 1).toInt();
  int _step = 0;
  int? _selected;
  bool _checked = false;

  @override
  void dispose() {
    try {
      _tts.stop().catchError((_) => null);
    } catch (_) {}
    super.dispose();
  }

  Future<void> _playExample() async {
    final courses = _getCourses(context);
    try {
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(.38);
      await _tts.speak(courses[_index].example);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: LocalizedText(context.t('qaida.next_course.audio_not_found')),
      ));
    }
  }

  Future<void> _advance() async {
    final courses = _getCourses(context);
    final course = courses[_index];
    if (!_checked) {
      setState(() => _checked = true);
      return;
    }
    if (_selected != course.exercises[_step].answer) {
      setState(() {
        _selected = null;
        _checked = false;
      });
      return;
    }
    if (_step < course.exercises.length - 1) {
      setState(() {
        _step++;
        _selected = null;
        _checked = false;
      });
      return;
    }
    final id = 'qaida_course_$_index';
    if (!context.read<AppState>().hasCompletedLesson(id)) {
      await context.read<AppState>().completeLesson(id, xp: 10);
    }
    if (!mounted) return;
    if (widget.stopAfterIndex == _index) {
      Navigator.pop(context);
      return;
    }
    if (_index == qaidaCourseCount - 1) {
      Navigator.pop(context);
    } else {
      setState(() {
        _index++;
        _step = 0;
        _selected = null;
        _checked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final courses = _getCourses(context);
    final course = courses[_index];
    final exercise = course.exercises[_step];
    final total = qaidaCourseCount * course.exercises.length;
    final overallStep = _index * course.exercises.length + _step + 1;
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
        backgroundColor: AppTheme.cream,
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(children: [
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(tablet ? 32 : 18, 10, 18, 0),
                        child: DuolingoPageHeader(
                          title: context.t('qaida.next_course.header_title',
                              params: {'course': course.title}),
                          subtitle: context.t(
                              'qaida.next_course.header_subtitle',
                              params: {
                                'step': '${_step + 1}',
                                'stage': exercise.stage
                              }),
                          iconType: VectorIconType.qaida,
                          gradientColors: const [
                            Color(0xFF58CC02),
                            Color(0xFF46A302)
                          ],
                          onBack: () => Navigator.pop(context),
                          trailing: LocalizedText(
                              context.t('qaida.next_course.step_counter',
                                  params: {'step': '${_step + 1}'}),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: tablet ? 36 : 20),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                  value: overallStep / total,
                                  minHeight: 10,
                                  backgroundColor: Colors.white,
                                  color: AppTheme.primaryGreen))),
                      Expanded(
                          child: ListView(
                              padding: EdgeInsets.all(tablet ? 32 : 20),
                              children: [
                            Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(tablet ? 26 : 20),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [course.color, Colors.white]),
                                    borderRadius: BorderRadius.circular(26),
                                    boxShadow: [
                                      BoxShadow(
                                          color: course.color,
                                          blurRadius: 16,
                                          offset: const Offset(0, 7))
                                    ]),
                                child: Column(children: [
                                  CircleAvatar(
                                      radius: 29,
                                      backgroundColor: Colors.white,
                                      child: Icon(course.icon,
                                          color: AppTheme.primaryGreen,
                                          size: 30)),
                                  const SizedBox(height: 12),
                                  LocalizedText(course.title,
                                      style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.darkText)),
                                  const SizedBox(height: 5),
                                  LocalizedText(course.description,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 15),
                                  Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: LocalizedText(course.example,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: _index == 3 ? 27 : 38,
                                              height: 1.7,
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.primaryGreen))),
                                  const SizedBox(height: 12),
                                  Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: .8),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(children: [
                                        LocalizedText(
                                            context.t(
                                                'qaida.next_course.step_indicator',
                                                params: {
                                                  'step': '${_step + 1}',
                                                  'stage': exercise.stage
                                                }),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: AppTheme.primaryGreen)),
                                        const SizedBox(height: 5),
                                        LocalizedText(exercise.prompt,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                height: 1.5,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.darkText))
                                      ]))
                                ])),
                            const SizedBox(height: 19),
                            Duolingo3DButton.secondary(
                                text: context
                                    .t('qaida.next_course.listen_audio'),
                                icon: const Icon(Icons.volume_up_rounded),
                                onPressed: _playExample),
                            const SizedBox(height: 12),
                            LocalizedText(
                                context.t('qaida.next_course.do_exercise'),
                                style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.darkText)),
                            const SizedBox(height: 10),
                            for (var i = 0; i < exercise.options.length; i++)
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 9),
                                  child: _AnswerTile(
                                      text: exercise.options[i],
                                      selected: _selected == i,
                                      correct: _checked && i == exercise.answer,
                                      color: course.color,
                                      onTap: _checked
                                          ? null
                                          : () =>
                                              setState(() => _selected = i))),
                            if (_checked)
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: LocalizedText(
                                      _selected == exercise.answer
                                          ? context.t(
                                              'qaida.next_course.correct_feedback')
                                          : context.t(
                                              'qaida.next_course.retry_feedback'),
                                      style: const TextStyle(
                                          color: AppTheme.primaryGreen,
                                          fontWeight: FontWeight.w800))),
                            Opacity(
                              opacity: _selected == null ? .45 : 1,
                              child: Duolingo3DButton(
                                  onPressed:
                                      _selected == null ? () {} : _advance,
                                  icon: Icon(!_checked
                                      ? Icons.check_rounded
                                      : _selected == exercise.answer
                                          ? Icons.arrow_forward_rounded
                                          : Icons.refresh_rounded),
                                  text: !_checked
                                      ? context
                                          .t('qaida.next_course.btn_check')
                                      : _selected != exercise.answer
                                          ? context.t(
                                              'qaida.next_course.btn_try_again')
                                          : _step <
                                                  course.exercises.length - 1
                                              ? context.t(
                                                  'qaida.next_course.btn_next_step')
                                              : _index < qaidaCourseCount - 1
                                                  ? context.t(
                                                      'qaida.next_course.btn_next_lesson')
                                                  : context.t(
                                                      'qaida.next_course.btn_finish'),
                                  color: AppTheme.primaryGreen),
                            ),
                          ])),
                    ])))));
  }
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile(
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
