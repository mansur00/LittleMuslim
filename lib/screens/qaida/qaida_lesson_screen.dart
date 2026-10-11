import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/vector_mascot.dart';
import 'qaida_letters.dart';
import 'qaida_next_course_screen.dart';

class QaidaNextLesson {
  const QaidaNextLesson({
    required this.lessonId,
    required this.lessonTitle,
    required this.letter,
    required this.letterName,
    required this.options,
    required this.makhrajNote,
  });

  final String lessonId, lessonTitle, letter, letterName;
  final List<String> options;
  final String makhrajNote;
}

class QaidaLessonScreen extends StatefulWidget {
  const QaidaLessonScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.letter,
    required this.letterName,
    required this.options,
    this.nextLesson,
    this.makhrajNote,
    this.chapterEndLessonId,
  });

  final String lessonId;
  final String lessonTitle;
  final String letter;
  final String letterName;
  final List<String> options;
  final QaidaNextLesson? nextLesson;
  final String? makhrajNote;
  final String? chapterEndLessonId;

  @override
  State<QaidaLessonScreen> createState() => _QaidaLessonScreenState();
}

class _QaidaLessonScreenState extends State<QaidaLessonScreen> {
  static final SpeechToText _speech = SpeechToText();
  static Future<bool>? _speechInitialization;

  final FlutterTts _tts = FlutterTts();
  int _step = 0;
  String? _feedback;
  String _recognizedWords = '';
  String? _speechLocale;
  bool _stagePassed = false;
  bool _lessonAlreadyCompleted = false;
  bool _earnedXp = false;
  bool _heardLetter = false;
  bool _speechAvailable = false;
  bool _isListening = false;
  bool _ttsAvailable = false;
  bool _initialized = false;

  static const _stepNames = [
    'শুনে বাছি',
    'রূপ চিনি',
    'বিন্দুর পাজল',
    'মনে আছে?',
    'মুখে বলি',
    'পাঠ শেষ',
  ];

  String get _arabicName => switch (widget.letter) {
        'ا' => 'أَلِف',
        'ب' => 'بَاء',
        'ت' => 'تَاء',
        'ث' => 'ثَاء',
        'ج' => 'جِيم',
        'ح' => 'حَاء',
        'خ' => 'خَاء',
        'د' => 'دَال',
        'ذ' => 'ذَال',
        'ر' => 'رَاء',
        'ز' => 'زَاي',
        'س' => 'سِين',
        'ش' => 'شِين',
        'ص' => 'صَاد',
        'ض' => 'ضَاد',
        'ط' => 'طَاء',
        'ظ' => 'ظَاء',
        'ع' => 'عَيْن',
        'غ' => 'غَيْن',
        'ف' => 'فَاء',
        'ق' => 'قَاف',
        'ك' => 'كَاف',
        'ل' => 'لَام',
        'م' => 'مِيم',
        'ن' => 'نُون',
        'ه' => 'هَاء',
        'و' => 'وَاو',
        'ي' => 'يَاء',
        _ => widget.letterName,
      };

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeTts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _lessonAlreadyCompleted =
          context.read<AppState>().hasCompletedLesson(widget.lessonId);
      _step = context.read<AppState>().qaidaLessonStep(widget.lessonId);
      _initialized = true;
    }
  }

  Future<void> _initializeSpeech() async {
    try {
      _speechInitialization ??= _speech.initialize();
      final available = await _speechInitialization!;
      final locales = available ? await _speech.locales() : <LocaleName>[];
      LocaleName? arabicLocale;
      for (final locale in locales) {
        if (locale.localeId.toLowerCase().startsWith('ar')) {
          arabicLocale = locale;
          break;
        }
      }
      if (!mounted) return;
      setState(() {
        _speechAvailable = available && arabicLocale != null;
        _speechLocale = arabicLocale?.localeId;
      });
    } catch (_) {
      if (mounted) setState(() => _speechAvailable = false);
    }
  }

  Future<void> _initializeTts() async {
    try {
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(.38);
      await _tts.setVolume(1);
      if (mounted) setState(() => _ttsAvailable = true);
    } catch (_) {
      if (mounted) setState(() => _ttsAvailable = false);
    }
  }

  @override
  void dispose() {
    if (_speech.isListening) _speech.cancel();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final xp = context.watch<AppState>().xp;
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(children: [
              _LessonHeader(
                onClose: () => Navigator.pop(context),
                xp: xp,
                step: _step,
                stepCount: _stepNames.length,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                      tablet ? 34 : 18, 10, tablet ? 34 : 18, 28),
                  children: [
                    _StepIndicator(step: _step, names: _stepNames),
                    const SizedBox(height: 13),
                    _MakhrajNote(
                      note: widget.makhrajNote ??
                          'হরফটি ধীরে বলো এবং শিক্ষক/অভিভাবকের কাছে উচ্চারণ মিলিয়ে নাও।',
                    ),
                    const SizedBox(height: 13),
                    _LetterHero(
                      letter: widget.letter,
                      name: widget.letterName,
                      arabicName: _arabicName,
                      title: widget.lessonTitle,
                      onSpeak: _speakTarget,
                      canSpeak: _ttsAvailable,
                    ),
                    const SizedBox(height: 15),
                    _buildStepCard(),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard() {
    if (_step == 5) return _buildFinishStep();

    final stepData = switch (_step) {
      0 => (Icons.hearing_rounded, 'শব্দ শুনে হরফ বাছো'),
      1 => (Icons.text_fields_rounded, 'হরফের রূপ চিনি'),
      2 => (Icons.extension_rounded, 'বিন্দুর পাজল'),
      3 => (Icons.lightbulb_outline_rounded, 'মনে আছে?'),
      _ => (Icons.mic_rounded, 'মুখে বলি'),
    };

    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Color(0x10000000), blurRadius: 13, offset: Offset(0, 4))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: const Color(0xFFFFF1C6),
                borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Icon(stepData.$1, color: const Color(0xFFD09A1B), size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(stepData.$2,
                style: const TextStyle(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w800,
                    fontSize: 16)),
          ),
          Text('${_step + 1} / ${_stepNames.length}',
              style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w800,
                  fontSize: 11)),
        ]),
        const SizedBox(height: 13),
        Text(_stepPrompt,
            style: const TextStyle(
                color: AppTheme.darkText,
                fontSize: 17,
                height: 1.4,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 15),
        if (_step == 0) _buildListeningChoice(),
        if (_step == 1) _buildFormMatch(),
        if (_step == 2) _buildDotPuzzle(),
        if (_step == 3) _buildMemoryQuiz(),
        if (_step == 4) _buildVoiceStep(),
        if (_feedback != null) ...[
          const SizedBox(height: 13),
          _FeedbackBanner(text: _feedback!, success: _stagePassed),
        ],
        if (_stagePassed) ...[
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _advanceStep,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('পরের ধাপে যাই'),
            style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ],
      ]),
    );
  }

  String get _stepPrompt => switch (_step) {
        0 => '“${widget.letterName}” অক্ষরটি শুনে বেছে নাও।',
        1 => 'এটি একই হরফের আরেকটি রূপ। মিল আছে এমনটি খুঁজে নাও।',
        2 => 'কোন বিন্দুর টুকরোটি “${widget.letterName}” হরফে বসবে?',
        3 => '“${widget.letterName}” অক্ষরটি কোনটি?',
        4 => 'মাইক্রোফোনে আরবি নামটি বলো: $_arabicName',
        _ => '',
      };

  Widget _buildListeningChoice() => Column(children: [
        OutlinedButton.icon(
          onPressed: _ttsAvailable ? _speakTarget : null,
          icon: const Icon(Icons.volume_up_rounded),
          label: const Text('শব্দটি শুনি'),
          style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryGreen,
              minimumSize: const Size.fromHeight(45),
              side: const BorderSide(color: Color(0xFFB8D8C3)),
              shape: const StadiumBorder()),
        ),
        const SizedBox(height: 12),
        _letterChoices(widget.options),
        const SizedBox(height: 6),
        Text(
            _heardLetter
                ? 'শুনে সঠিক হরফটি বেছে নাও।'
                : 'অডিও না চললেও নমুনা দেখে হরফটি বেছে নিতে পারো।',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black45, fontSize: 10)),
      ]);

  Widget _buildFormMatch() {
    final forms = _letterForms[widget.letter] ?? [widget.letter];
    final correctForm = forms.length > 1 ? forms[1] : forms.first;
    final choices = <String>{...forms, 'نـ', 'ـب', 'د'}.take(4).toList();
    if (!choices.contains(correctForm)) choices[0] = correctForm;
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      alignment: WrapAlignment.center,
      children: [
        for (final form in choices)
          _ChoiceTile(
            label: form,
            isArabic: true,
            onTap: () => _selectStageAnswer(
                form, correctForm, 'মাশাআল্লাহ! হরফের রূপটি মিলেছে।'),
          ),
      ],
    );
  }

  Widget _buildDotPuzzle() {
    final correct = _dotKey[widget.letter] ?? 'one_below';
    const choices = [
      ('no_dot', 'বিন্দু নেই', 'ـ'),
      ('one_above', 'একটি ওপরে', '•'),
      ('one_below', 'একটি নিচে', '•'),
      ('two_above', 'দুটি ওপরে', '••'),
      ('three_above', 'তিনটি ওপরে', '•••'),
      ('two_below', 'দুটি নিচে', '••'),
    ];
    return Column(children: [
      Container(
        width: 92,
        height: 76,
        decoration: BoxDecoration(
            color: const Color(0xFFEAF4EA),
            borderRadius: BorderRadius.circular(18)),
        alignment: Alignment.center,
        child: Text(_dotlessLetter[widget.letter] ?? widget.letter,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
                color: AppTheme.primaryGreen,
                fontSize: 46,
                fontWeight: FontWeight.w700)),
      ),
      const SizedBox(height: 10),
      const Text('হরফের গায়ে ঠিক বিন্দুটি বসাও',
          style: TextStyle(color: Colors.black54, fontSize: 12)),
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          for (final option in choices)
            _ChoiceTile(
              label: option.$2,
              glyph: option.$3,
              onTap: () => _selectStageAnswer(
                  option.$1, correct, 'দারুণ! বিন্দুর জায়গাটিও ঠিক হয়েছে।'),
            ),
        ],
      ),
    ]);
  }

  Widget _buildMemoryQuiz() => _letterChoices(
        widget.options,
        onChoice: (option) => _selectStageAnswer(
          option,
          widget.letter,
          'ঠিক ধরেছ! এবার নিজের কণ্ঠে বলার পালা।',
        ),
      );

  Widget _buildVoiceStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
                color: const Color(0xFFEAF4EA),
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              _recognizedWords.isEmpty
                  ? 'শান্তভাবে বলো: $_arabicName'
                  : 'শোনা গেছে: $_recognizedWords',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTheme.darkText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          if (_stagePassed)
            const SizedBox.shrink()
          else if (_speechAvailable)
            FilledButton.icon(
              onPressed: _isListening ? _stopListening : _startListening,
              icon: Icon(_isListening ? Icons.stop_rounded : Icons.mic_rounded),
              label: Text(_isListening ? 'শোনা বন্ধ করো' : 'চেপে বলো'),
              style: FilledButton.styleFrom(
                  backgroundColor: _isListening
                      ? AppTheme.accentCoral
                      : AppTheme.primaryGreen,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
            )
          else
            Column(children: [
              const _FeedbackBanner(
                  text:
                      'এই ডিভাইসে আরবি voice recognition পাওয়া যায়নি। অভিভাবক শুনে সাহায্য করতে পারেন।',
                  success: false),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _confirmSelfPractice,
                icon: const Icon(Icons.record_voice_over_rounded),
                label: const Text('আমি উচ্চারণ করে ফেলেছি'),
              ),
              const SizedBox(height: 4),
              OutlinedButton.icon(
                onPressed: _confirmWithGuardian,
                icon: const Icon(Icons.family_restroom_rounded),
                label: const Text('অভিভাবক শুনে নিশ্চিত করবেন'),
              ),
            ]),
          if (_speechAvailable && !_stagePassed) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _confirmWithGuardian,
              icon: const Icon(Icons.family_restroom_rounded),
              label: const Text('অভিভাবক শুনে নিশ্চিত করবেন'),
            ),
          ],
          const SizedBox(height: 10),
          const Text(
              'ভয়েস মিলিয়ে দেখা একটি প্রাথমিক অনুশীলন। সঠিক মাখরাজের জন্য শিক্ষক/অভিভাবকের শোনা জরুরি।',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.black45, fontSize: 10, height: 1.5)),
        ],
      );

  Widget _buildFinishStep() => Container(
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Column(children: [
          const VectorMascot(
            size: 80,
            mood: MascotMood.celebrating,
          ),
          const SizedBox(height: 8),
          const VectorIcon(
            type: VectorIconType.star,
            size: 36,
            color: Color(0xFFFFC800),
          ),
          const SizedBox(height: 10),
          Text(
              _lessonAlreadyCompleted
                  ? 'এই পাঠটি আগেই শেষ করেছ!'
                  : 'সব ধাপ শেষ করেছ, মাশাআল্লাহ!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTheme.darkText,
                  fontSize: 20,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 7),
          const Text('শোনা · রূপ চেনা · বিন্দুর পাজল · কুইজ · বলা',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF4D7),
                borderRadius: BorderRadius.circular(14)),
            child: Text(
                _earnedXp || _lessonAlreadyCompleted
                    ? 'এই পাঠের +১০ XP আগেই পেয়েছ!'
                    : 'পাঠ শেষ হলে +১০ XP পাবে',
                style: const TextStyle(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w800,
                    fontSize: 13)),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _completeAndContinue,
              icon: Icon(widget.nextLesson == null
                  ? Icons.check_circle_rounded
                  : Icons.arrow_forward_rounded),
              label: Text(widget.nextLesson == null
                  ? 'পাঠ শেষ করি'
                  : 'পরের পাঠ: ${widget.nextLesson!.lessonTitle}'),
              style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
          ),
        ]),
      );

  Widget _letterChoices(List<String> choices,
      {ValueChanged<String>? onChoice}) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      alignment: WrapAlignment.center,
      children: [
        for (final option in choices)
          _ChoiceTile(
            label: option,
            isArabic: true,
            onTap: () {
              if (onChoice != null) {
                onChoice(option);
              } else {
                _selectStageAnswer(
                    option, widget.letter, 'মাশাআল্লাহ! ঠিক চিনেছ।');
              }
            },
          ),
      ],
    );
  }

  void _selectStageAnswer(String answer, String correct, String successText) {
    if (_stagePassed) return;
    final isCorrect = answer == correct;
    setState(() {
      _stagePassed = isCorrect;
      _feedback = isCorrect
          ? successText
          : 'আবার চেষ্টা করো। বড় হরফটি দেখে ধীরে ভাবো—তুমি পারবে!';
    });
  }

  Future<void> _advanceStep() async {
    if (!_stagePassed || _step >= 5) return;
    final nextStep = _step + 1;
    await context
        .read<AppState>()
        .saveQaidaLessonStep(widget.lessonId, nextStep);
    if (!mounted) return;
    setState(() {
      _step = nextStep;
      _feedback = null;
      _stagePassed = false;
      _recognizedWords = '';
    });
  }

  Future<void> _speakTarget() async {
    try {
      await _tts.speak(_arabicName);
      if (mounted && _step == 0) setState(() => _heardLetter = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _ttsAvailable = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('এই ডিভাইসে শব্দ শোনানো যাচ্ছে না।')));
    }
  }

  Future<void> _startListening() async {
    if (!_speechAvailable || _speechLocale == null) return;
    setState(() {
      _recognizedWords = '';
      _feedback = null;
    });
    try {
      await _speech.listen(
        listenOptions: SpeechListenOptions(
          localeId: _speechLocale!,
          listenFor: const Duration(seconds: 7),
          pauseFor: const Duration(seconds: 3),
        ),
        onResult: (result) {
          if (!mounted) return;
          final words = result.recognizedWords;
          final correct = _matchesTargetPronunciation(words);
          setState(() {
            _recognizedWords = words;
            if (result.finalResult) _isListening = false;
            if (correct) {
              _stagePassed = true;
              _feedback = 'শব্দটি চিনতে পেরেছি। ভালো চেষ্টা!';
            } else if (result.finalResult && words.isNotEmpty) {
              _feedback = 'কাছাকাছি—আরেকবার ধীরে বলো, তারপর চেষ্টা করো।';
            }
          });
        },
      );
      if (mounted) setState(() => _isListening = true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _isListening = false;
          _feedback =
              'মাইক্রোফোন চালু হয়নি। আবার চেষ্টা করো বা অভিভাবকের সাহায্য নাও।';
        });
      }
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (mounted) setState(() => _isListening = false);
  }

  bool _matchesTargetPronunciation(String words) {
    final normalized = _normalizeSpeech(words);
    if (normalized.isEmpty) return false;
    final aliases = switch (widget.letter) {
      'ا' => ['الف', 'الف', 'alif', 'elif', 'ا'],
      'ب' => ['باء', 'با', 'baa', 'ba', 'ب'],
      'ت' => ['تاء', 'تا', 'taa', 'ta', 'ت'],
      'ث' => ['ثاء', 'ثا', 'thaa', 'tha', 'ث'],
      'ج' => ['جيم', 'جيم', 'jeem', 'jim', 'ج'],
      _ => [_normalizeSpeech(_arabicName), _normalizeSpeech(widget.letterName)],
    };
    return aliases.any((alias) =>
        alias.isNotEmpty && normalized.contains(_normalizeSpeech(alias)));
  }

  String _normalizeSpeech(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u0640\s.,!?]'), '')
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا');

  Future<void> _confirmWithGuardian() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('অভিভাবকের সাহায্য'),
        content: Text(
            'শিশুটি কি “$_arabicName” বলার চেষ্টা করেছে? শুনে ঠিক মনে হলে নিশ্চিত করুন।'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('আবার চেষ্টা')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('শুনেছি, ঠিক বলেছে')),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() {
        _stagePassed = true;
        _feedback = 'অভিভাবক উচ্চারণ শুনে নিশ্চিত করেছেন।';
      });
    }
  }

  void _confirmSelfPractice() {
    setState(() {
      _stagePassed = true;
      _feedback =
          'তুমি উচ্চারণের চেষ্টা করেছ। এই ডিভাইসে কণ্ঠ যাচাই করা যায়নি।';
    });
  }

  Future<void> _completeAndContinue() async {
    if (!_lessonAlreadyCompleted) {
      _earnedXp =
          await context.read<AppState>().completeLesson(widget.lessonId);
      _lessonAlreadyCompleted = true;
    }
    if (!mounted) return;
    if (widget.chapterEndLessonId == widget.lessonId) {
      Navigator.pop(context);
      return;
    }
    final next = widget.nextLesson;
    if (next == null) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
        return;
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
        builder: (_) => const QaidaNextCourseScreen(),
      ));
      return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => QaidaLessonScreen(
        lessonId: next.lessonId,
        lessonTitle: next.lessonTitle,
        letter: next.letter,
        letterName: next.letterName,
        options: next.options,
        makhrajNote: next.makhrajNote,
        chapterEndLessonId: widget.chapterEndLessonId,
        nextLesson: _nextAfter(next.lessonId),
      ),
    ));
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({
    required this.onClose,
    required this.xp,
    required this.step,
    required this.stepCount,
  });
  final VoidCallback onClose;
  final int xp, step, stepCount;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 18, 12),
        child: Row(children: [
          IconButton.filledTonal(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
              style: IconButton.styleFrom(backgroundColor: Colors.white)),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                  value: (step + 1) / stepCount,
                  minHeight: 11,
                  backgroundColor: const Color(0xFFE4E8DD),
                  color: AppTheme.primaryGreen),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              const Icon(Icons.star_rounded,
                  color: AppTheme.secondaryGold, size: 19),
              const SizedBox(width: 3),
              Text('$xp',
                  style: const TextStyle(
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w800,
                      fontSize: 13)),
            ]),
          ),
        ]),
      );
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step, required this.names});
  final int step;
  final List<String> names;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 37,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: names.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
                color: index == step
                    ? AppTheme.primaryGreen
                    : index < step
                        ? const Color(0xFFDCEEDC)
                        : Colors.white,
                borderRadius: BorderRadius.circular(15)),
            child: Text(names[index],
                style: TextStyle(
                    color: index == step
                        ? Colors.white
                        : index < step
                            ? AppTheme.primaryGreen
                            : Colors.black45,
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      );
}

class _LetterHero extends StatelessWidget {
  const _LetterHero({
    required this.letter,
    required this.name,
    required this.arabicName,
    required this.title,
    required this.onSpeak,
    required this.canSpeak,
  });
  final String letter, name, arabicName, title;
  final VoidCallback onSpeak;
  final bool canSpeak;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, 3))
          ],
        ),
        child: Row(children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: [Color(0xFFE8F5E9), Color(0xFFF7F4E9)])),
            alignment: Alignment.center,
            child: Text(letter,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 42,
                    height: 1.2,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 13),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: const TextStyle(
                        color: AppTheme.darkText,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text('$name · $arabicName',
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 12)),
              ])),
          IconButton.filledTonal(
            onPressed: canSpeak ? onSpeak : null,
            tooltip: 'হরফের নাম শোনো',
            icon: const Icon(Icons.volume_up_rounded),
            style: IconButton.styleFrom(
                foregroundColor: AppTheme.primaryGreen,
                backgroundColor: const Color(0xFFEAF4EA)),
          ),
        ]),
      );
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.onTap,
    this.isArabic = false,
    this.glyph,
  });
  final String label;
  final VoidCallback onTap;
  final bool isArabic;
  final String? glyph;

  @override
  Widget build(BuildContext context) => Material(
        color: const Color(0xFFFFFEFB),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            constraints:
                BoxConstraints(minWidth: isArabic ? 76 : 112, minHeight: 67),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E9E0), width: 1.4)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (glyph != null)
                Text(glyph!,
                    style: const TextStyle(
                        color: AppTheme.primaryGreen,
                        fontSize: 22,
                        fontWeight: FontWeight.w800)),
              Text(label,
                  textDirection: isArabic ? TextDirection.rtl : null,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.darkText,
                      fontSize: isArabic ? 29 : 12,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      );
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.text, required this.success});
  final String text;
  final bool success;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: success ? const Color(0xFFE8F5E9) : const Color(0xFFFFF1E9),
            borderRadius: BorderRadius.circular(15)),
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: success ? AppTheme.primaryGreen : AppTheme.accentCoral,
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.w700)),
      );
}

const Map<String, List<String>> _letterForms = {
  'ا': ['ا', 'ـا'],
  'ب': ['ب', 'بـ', 'ـب', 'ـبـ'],
  'ت': ['ت', 'تـ', 'ـت', 'ـتـ'],
  'ث': ['ث', 'ثـ', 'ـث', 'ـثـ'],
  'ج': ['ج', 'جـ', 'ـج', 'ـجـ'],
  'ح': ['ح', 'حـ', 'ـح', 'ـحـ'],
  'خ': ['خ', 'خـ', 'ـخ', 'ـخـ'],
  'د': ['د', 'ـد'],
  'ذ': ['ذ', 'ـذ'],
  'ر': ['ر', 'ـر'],
  'ز': ['ز', 'ـز'],
  'س': ['س', 'سـ', 'ـس', 'ـسـ'],
  'ش': ['ش', 'شـ', 'ـش', 'ـشـ'],
  'ص': ['ص', 'صـ', 'ـص', 'ـصـ'],
  'ض': ['ض', 'ضـ', 'ـض', 'ـضـ'],
  'ط': ['ط', 'طـ', 'ـط', 'ـطـ'],
  'ظ': ['ظ', 'ظـ', 'ـظ', 'ـظـ'],
  'ع': ['ع', 'عـ', 'ـع', 'ـعـ'],
  'غ': ['غ', 'غـ', 'ـغ', 'ـغـ'],
  'ف': ['ف', 'فـ', 'ـف', 'ـفـ'],
  'ق': ['ق', 'قـ', 'ـق', 'ـقـ'],
  'ك': ['ك', 'كـ', 'ـك', 'ـكـ'],
  'ل': ['ل', 'لـ', 'ـل', 'ـلـ'],
  'م': ['م', 'مـ', 'ـم', 'ـمـ'],
  'ن': ['ن', 'نـ', 'ـن', 'ـنـ'],
  'ه': ['ه', 'هـ', 'ـه', 'ـهـ'],
  'و': ['و', 'ـو'],
  'ي': ['ي', 'يـ', 'ـي', 'ـيـ'],
};

const Map<String, String> _dotKey = {
  'ا': 'no_dot',
  'ب': 'one_below',
  'ت': 'two_above',
  'ث': 'three_above',
  'ج': 'one_below',
  'ح': 'no_dot',
  'خ': 'one_above',
  'د': 'no_dot',
  'ذ': 'one_above',
  'ر': 'no_dot',
  'ز': 'one_above',
  'س': 'no_dot',
  'ش': 'three_above',
  'ص': 'no_dot',
  'ض': 'one_above',
  'ط': 'no_dot',
  'ظ': 'one_above',
  'ع': 'no_dot',
  'غ': 'one_above',
  'ف': 'one_above',
  'ق': 'two_above',
  'ك': 'no_dot',
  'ل': 'no_dot',
  'م': 'no_dot',
  'ن': 'one_above',
  'ه': 'no_dot',
  'و': 'no_dot',
  'ي': 'two_below',
};

const Map<String, String> _dotlessLetter = {
  'ا': 'ا',
  'ب': 'ٮ',
  'ت': 'ٮ',
  'ث': 'ٮ',
  'ج': 'ح',
  'ح': 'ح',
  'خ': 'ح',
  'د': 'د',
  'ذ': 'د',
  'ر': 'ر',
  'ز': 'ر',
  'س': 'س',
  'ش': 'س',
  'ص': 'ص',
  'ض': 'ص',
  'ط': 'ط',
  'ظ': 'ط',
  'ع': 'ع',
  'غ': 'ع',
  'ف': 'ڡ',
  'ق': 'ڡ',
  'ك': 'ك',
  'ل': 'ل',
  'م': 'م',
  'ن': 'ٮ',
  'ه': 'ه',
  'و': 'و',
  'ي': 'ى',
};

QaidaNextLesson? _nextAfter(String lessonId) {
  final index = qaidaLetters.indexWhere((item) => item.id == lessonId);
  final nextIndex = index + 1;
  if (index < 0 || nextIndex >= qaidaLetters.length) return null;
  final next = qaidaLetters[nextIndex];
  return QaidaNextLesson(
    lessonId: next.id,
    lessonTitle: next.title,
    letter: next.letter,
    letterName: next.name,
    options: qaidaLetterOptions(nextIndex),
    makhrajNote: next.makhraj,
  );
}

class _MakhrajNote extends StatelessWidget {
  const _MakhrajNote({required this.note});
  final String note;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F2E5),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFD2E4CD)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.record_voice_over_rounded,
              color: AppTheme.primaryGreen, size: 19),
          const SizedBox(width: 9),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('শুরুর মাখরাজ নোট',
                    style: TextStyle(
                        color: AppTheme.primaryGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(note,
                    style: const TextStyle(
                        color: AppTheme.darkText, fontSize: 12, height: 1.45)),
              ])),
        ]),
      );
}
