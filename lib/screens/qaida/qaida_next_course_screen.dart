import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/duolingo_button.dart';
import '../../widgets/vector_icons.dart';

const qaidaCourseTitles = ['যুক্ত বর্ণ', 'হরকত', 'মাদ ও গুন্নাহ', 'আয়াত পড়া'];
const qaidaCourseLetters = ['بـ', 'بَ', 'مَدّ', 'آية'];
const qaidaCourseCount = 4;

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

const _courses = <_Course>[
  _Course('যুক্ত বর্ণ', 'আলাদা হরফ জুড়ে শব্দের রূপ চিনি', 'ب + ا = با',
      Color(0xFFDDF4E9), Icons.extension_rounded, [
    _Exercise(
        'দেখে শিখি', 'ب + ا একসাথে লিখলে কোন রূপ হবে?', ['با', 'بت', 'اب'], 0),
    _Exercise(
        'রূপ চিনি', 'শব্দের শুরুতে ب দেখতে কেমন?', ['بـ', 'ـبـ', 'ـب'], 0),
    _Exercise(
        'জোড়া লাগাই', 'ت + ا যুক্ত হলে কোনটি হবে?', ['تا', 'با', 'تي'], 0),
    _Exercise('মনে রাখি', 'কোন অক্ষরগুলো পরের অক্ষরের সঙ্গে যুক্ত হয় না?',
        ['ا د ذ ر ز و', 'ب ت ث ج ح', 'س ش ص ض ط'], 0),
    _Exercise('নিজে পড়ে দেখি', 'با-তে কোন দুই হরফ আছে?',
        ['ب এবং ا', 'ب এবং ت', 'ا এবং ت'], 0),
  ]),
  _Course('হরকত', 'যবর, যের ও পেশ দিয়ে ছোট স্বর পড়ি', 'بَ  بِ  بُ',
      Color(0xFFFFEBCF), Icons.graphic_eq_rounded, [
    _Exercise('যবর চিনি', 'বর্ণের ওপরে যবর (َ) থাকলে কী ধ্বনি?',
        ['ছোট “আ/অ” ধ্বনি', 'ছোট “ই” ধ্বনি', 'ছোট “উ” ধ্বনি'], 0),
    _Exercise('যের চিনি', 'বর্ণের নিচে যের (ِ) থাকলে কী ধ্বনি?',
        ['ছোট “ই” ধ্বনি', 'ছোট “উ” ধ্বনি', 'টেনে “আ”'], 0),
    _Exercise('পেশ চিনি', 'بُ কোনভাবে পড়ি?', ['বু', 'বি', 'বা'], 0),
    _Exercise('ক্রম মিলাই', 'بَ بِ بُ এর সঠিক ক্রম কোনটি?',
        ['বা · বি · বু', 'বি · বু · বা', 'বু · বা · বি'], 0),
    _Exercise('নিজে পড়ে দেখি', 'একটি হরকত সাধারণত কেমন স্বর দেয়?',
        ['ছোট স্বর', 'দুই হারাকাত টান', 'পুরো থামা'], 0),
  ]),
  _Course('মাদ ও গুন্নাহ', 'টেনে পড়া ও নাকের অনুরণন চিনি', 'مَدّ · غُنَّة',
      Color(0xFFE8E2FF), Icons.waves_rounded, [
    _Exercise('মাদ চিনি', 'মাদ হলে ধ্বনি কীভাবে পড়ি?',
        ['নিয়ম অনুযায়ী টেনে', 'একেবারে বাদ দিয়ে', 'যত দ্রুত সম্ভব'], 0),
    _Exercise('মাদের হরফ', 'সাধারণ মাদের হরফ কোনগুলো?',
        ['ا و ي', 'ب ت ث', 'ج ح خ'], 0),
    _Exercise('গুন্নাহ চিনি', 'গুন্নাহর অনুরণন কোথা দিয়ে হয়?',
        ['নাক দিয়ে', 'শুধু ঠোঁট দিয়ে', 'দাঁত চেপে'], 0),
    _Exercise('শুনে মনে রাখি', 'نّ বা مّ এলে কী অনুশীলন করি?',
        ['নাকের অনুরণনসহ গুন্নাহ', 'সবসময় থামা', 'হরফ বাদ দেওয়া'], 0),
    _Exercise('শিক্ষকের সঙ্গে পড়ি', 'মাদ ও গুন্নাহর সঠিক মাত্রা কীভাবে শিখব?',
        ['শিক্ষকের তিলাওয়াত শুনে', 'অনুমান করে', 'সব জায়গায় একই টান দিয়ে'], 0),
  ]),
  _Course('আয়াত পড়া', 'শেখা নিয়ম দিয়ে ছোট আয়াত পড়ি', 'قُلْ هُوَ اللَّهُ أَحَدٌ',
      Color(0xFFDDF1FF), Icons.menu_book_rounded, [
    _Exercise('আয়াত দেখি', 'আয়াত পড়ার আগে কী দেখি?',
        ['হরফ, হরকত ও থামার চিহ্ন', 'শুধু শেষের শব্দ', 'শুধু রং'], 0),
    _Exercise('হরফ জুড়ি', 'শব্দ পড়া সহজ করতে কী কাজে দেয়?',
        ['যুক্ত রূপ চেনা', 'বিন্দু উপেক্ষা', 'হরকত বাদ'], 0),
    _Exercise('ধীরে পড়ি', 'নতুন আয়াত শেখার সময় কেমন পড়ি?',
        ['ধীরে, স্পষ্ট করে', 'দৌড়ে', 'অনুমান করে'], 0),
    _Exercise('নিয়ম মনে রাখি', 'মাদ/গুন্নাহ দেখলে কী করি?',
        ['তাজবিদের নিয়ম মেনে পড়ি', 'চিহ্ন মুছে ফেলি', 'সব একইভাবে পড়ি'], 0),
    _Exercise('শুনে মিলাই', 'তিলাওয়াত শুদ্ধ করতে কার কাছে শুনব?',
        ['যোগ্য শিক্ষক/অভিভাবকের কাছে', 'শুধু নিজের অনুমান', 'না শুনেই'], 0),
  ]),
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
    _tts.stop();
    super.dispose();
  }

  Future<void> _playExample() async {
    try {
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(.38);
      await _tts.speak(_courses[_index].example);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('এই ডিভাইসে আরবি অডিও পাওয়া যায়নি।'),
      ));
    }
  }

  Future<void> _advance() async {
    final course = _courses[_index];
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
    final course = _courses[_index];
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
                          title: 'ক্বায়দা · ${course.title}',
                          subtitle: 'ধাপ ${_step + 1} · ${exercise.stage}',
                          iconType: VectorIconType.qaida,
                          gradientColors: const [
                            Color(0xFF0D7377),
                            Color(0xFF14919B)
                          ],
                          onBack: () => Navigator.pop(context),
                          trailing: Text('${_step + 1}/৫',
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
                                  Text(course.title,
                                      style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.darkText)),
                                  const SizedBox(height: 5),
                                  Text(course.description,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 15),
                                  Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(course.example,
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
                                        Text(
                                            'ধাপ ${_step + 1}: ${exercise.stage}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: AppTheme.primaryGreen)),
                                        const SizedBox(height: 5),
                                        Text(exercise.prompt,
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
                                text: 'আরবি উচ্চারণ শুনি',
                                icon: const Icon(Icons.volume_up_rounded),
                                onPressed: _playExample),
                            const SizedBox(height: 12),
                            const Text('অনুশীলনটি করো',
                                style: TextStyle(
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
                                  child: Text(
                                      _selected == exercise.answer
                                          ? 'ঠিক হয়েছে! ধীরে পড়ে আবার মিলিয়ে নাও।'
                                          : 'আবার চেষ্টা করো—উদাহরণটি দেখে উত্তর বেছে নাও।',
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
                                      ? 'উত্তর মিলিয়ে দেখি'
                                      : _selected != exercise.answer
                                          ? 'আবার চেষ্টা করি'
                                          : _step < course.exercises.length - 1
                                              ? 'পরের ধাপ'
                                              : _index < qaidaCourseCount - 1
                                                  ? 'পরের পাঠ'
                                                  : 'ক্বায়দা পাঠ শেষ',
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
                    child: Text(text,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.darkText)))
              ]))));
}
