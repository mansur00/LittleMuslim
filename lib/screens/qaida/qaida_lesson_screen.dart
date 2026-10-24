import '../../l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/vector_mascot.dart';
import 'qaida_chapters_screen.dart';
import 'qaida_letters.dart';

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

  AudioPlayer? _audioPlayer;
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
  bool _initialized = false;

  List<String> _getStepNames(BuildContext context) => [
        context.t('qaida.lesson.step_listen'),
        context.t('qaida.lesson.step_form'),
        context.t('qaida.lesson.step_dots'),
        context.t('qaida.lesson.step_memory'),
        context.t('qaida.lesson.step_pronounce'),
        context.t('qaida.lesson.step_complete'),
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
      _speechInitialization ??= _speech.initialize(
        onError: (err) {
          debugPrint('STT error: $err');
          if (mounted) setState(() => _isListening = false);
        },
        onStatus: (status) {
          debugPrint('STT status: $status');
          if (mounted && (status == 'notListening' || status == 'done')) {
            setState(() => _isListening = false);
          }
        },
      );
      final available = await _speechInitialization!;
      final locales = available ? await _speech.locales() : <LocaleName>[];
      LocaleName? preferredLocale;
      for (final locale in locales) {
        if (locale.localeId.toLowerCase().startsWith('ar')) {
          preferredLocale = locale;
          break;
        }
      }
      if (preferredLocale == null && locales.isNotEmpty) {
        final systemLocale = await _speech.systemLocale();
        preferredLocale = systemLocale ?? locales.first;
      }
      if (!mounted) return;
      setState(() {
        _speechAvailable = available;
        _speechLocale = preferredLocale?.localeId ?? 'ar-SA';
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
    } catch (_) {}
  }

  @override
  void dispose() {
    if (_speech.isListening) _speech.cancel();
    _audioPlayer?.dispose();
    try {
      _tts.stop().catchError((_) => null);
    } catch (_) {}
    super.dispose();
  }

  Future<void> _handleExit() async {
    if (_step > 0 && _step < 5 && !_lessonAlreadyCompleted) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(ctx.t('qaida.lesson.exit_title')),
          content: Text(
            ctx.t('qaida.lesson.exit_message', params: {'step': _step + 1}),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(ctx.t('qaida.lesson.keep_learning')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(ctx.t('qaida.lesson.exit')),
            ),
          ],
        ),
      );
      if (shouldExit != true || !mounted) return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final xp = context.watch<AppState>().xp;
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final stepNames = _getStepNames(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleExit();
      },
      child: Scaffold(
        backgroundColor: AppTheme.cream,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(children: [
                _LessonHeader(
                  onClose: _handleExit,
                  xp: xp,
                  step: _step,
                  stepCount: stepNames.length,
                ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                      tablet ? 34 : 18, 10, tablet ? 34 : 18, 28),
                  children: [
                    _StepIndicator(step: _step, names: stepNames),
                    const SizedBox(height: 13),
                    _MakhrajNote(
                      note: widget.makhrajNote != null
                          ? context.uiText(widget.makhrajNote!)
                          : context.t('qaida.lesson.makhraj_default'),
                    ),
                    const SizedBox(height: 13),
                    _LetterHero(
                      letter: widget.letter,
                      name: widget.letterName,
                      arabicName: _arabicName,
                      title: widget.lessonTitle,
                      onSpeak: _speakTarget,
                      canSpeak: true,
                    ),
                    const SizedBox(height: 15),
                    _buildStepCard(stepNames),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    ));
  }

  Widget _buildStepCard(List<String> stepNames) {
    if (_step == 5) return _buildFinishStep();

    final stepData = switch (_step) {
      0 => (Icons.hearing_rounded, context.t('qaida.lesson.step_listen_title')),
      1 => (Icons.text_fields_rounded, context.t('qaida.lesson.step_form_title')),
      2 => (Icons.extension_rounded, context.t('qaida.lesson.step_dots_title')),
      3 => (Icons.lightbulb_outline_rounded, context.t('qaida.lesson.step_memory_title')),
      _ => (Icons.mic_rounded, context.t('qaida.lesson.step_pronounce_title')),
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
          LocalizedText('${_step + 1} / ${stepNames.length}',
              style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w800,
                  fontSize: 11)),
        ]),
        const SizedBox(height: 13),
        Text(_stepPrompt(context),
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
            label: Text(context.t('qaida.lesson.next_step')),
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

  String _stepPrompt(BuildContext context) => switch (_step) {
        0 => context.t('qaida.lesson.prompt_listen',
            params: {'letter': context.uiText(widget.letterName)}),
        1 => context.t('qaida.lesson.prompt_form'),
        2 => context.t('qaida.lesson.prompt_dots',
            params: {'letter': context.uiText(widget.letterName)}),
        3 => context.t('qaida.lesson.prompt_memory',
            params: {'letter': context.uiText(widget.letterName)}),
        4 => context.t('qaida.lesson.prompt_pronounce',
            params: {'name': _arabicName}),
        _ => '',
      };

  Widget _buildListeningChoice() => Column(children: [
        DSButton(
          onPressed: _speakTarget,
          icon: Icons.volume_up_rounded,
          label: context.t('qaida.lesson.listen_audio'),
          variant: DSButtonVariant.outline,
          fullWidth: true,
        ),
        const SizedBox(height: 12),
        _letterChoices(widget.options),
        const SizedBox(height: 6),
        Text(
            _heardLetter
                ? context.t('qaida.lesson.listen_hint_audio')
                : context.t('qaida.lesson.listen_hint_no_audio'),
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
                form, correctForm, context.t('qaida.lesson.feedback_form_success')),
          ),
      ],
    );
  }

  Widget _buildDotPuzzle() {
    final correct = _dotKey[widget.letter] ?? 'one_below';
    final choices = [
      ('no_dot', context.t('qaida.lesson.dot_none'), 'ـ'),
      ('one_above', context.t('qaida.lesson.dot_one_above'), '•'),
      ('one_below', context.t('qaida.lesson.dot_one_below'), '•'),
      ('two_above', context.t('qaida.lesson.dot_two_above'), '••'),
      ('three_above', context.t('qaida.lesson.dot_three_above'), '•••'),
      ('two_below', context.t('qaida.lesson.dot_two_below'), '••'),
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
      Text(context.t('qaida.lesson.place_dots_instruction'),
          style: const TextStyle(color: Colors.black54, fontSize: 12)),
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
                  option.$1, correct, context.t('qaida.lesson.feedback_dots_success')),
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
          context.t('qaida.lesson.feedback_memory_success'),
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
                  ? context.t('qaida.lesson.speak_calmly', params: {'name': _arabicName})
                  : context.t('qaida.lesson.recognized_words', params: {'words': _recognizedWords}),
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
              label: Text(_isListening
                  ? context.t('qaida.lesson.stop_listening')
                  : context.t('qaida.lesson.press_to_speak')),
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
              _FeedbackBanner(
                  text: context.t('qaida.lesson.no_stt_banner'),
                  success: false),
              const SizedBox(height: 8),
              DSButton(
                onPressed: _confirmSelfPractice,
                icon: Icons.record_voice_over_rounded,
                label: context.t('qaida.lesson.i_pronounced'),
                variant: DSButtonVariant.primary,
                fullWidth: true,
              ),
              const SizedBox(height: 8),
              DSButton(
                onPressed: _confirmWithGuardian,
                icon: Icons.family_restroom_rounded,
                label: context.t('qaida.lesson.guardian_confirm'),
                variant: DSButtonVariant.outline,
                fullWidth: true,
              ),
            ]),
          if (_speechAvailable && !_stagePassed) ...[
            const SizedBox(height: 8),
            DSButton(
              onPressed: _confirmWithGuardian,
              icon: Icons.family_restroom_rounded,
              label: context.t('qaida.lesson.guardian_confirm'),
              variant: DSButtonVariant.outline,
              fullWidth: true,
            ),
          ],
          const SizedBox(height: 10),
          Text(
            context.t('qaida.lesson.voice_practice_note'),
            textAlign: TextAlign.center,
            style:
                const TextStyle(color: Colors.black45, fontSize: 10, height: 1.5),
          ),
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
              _lessonAlreadyCompleted && !_earnedXp
                  ? context.t('qaida.lesson.finish_already_completed')
                  : context.t('qaida.lesson.finish_all_done'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTheme.darkText,
                  fontSize: 20,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 7),
          Text(context.t('qaida.lesson.finish_recap'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF4D7),
                borderRadius: BorderRadius.circular(14)),
            child: Text(
                _earnedXp
                    ? context.t('qaida.lesson.finish_xp_earned')
                    : context.t('qaida.lesson.finish_xp_already'),
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
                  ? context.t('qaida.lesson.finish_button')
                  : context.t('qaida.lesson.next_lesson_button', params: {
                      'title': context.uiText(widget.nextLesson!.lessonTitle),
                    })),
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
              _playLetterAudio(option);
              if (onChoice != null) {
                onChoice(option);
              } else {
                _selectStageAnswer(
                    option, widget.letter, context.t('qaida.lesson.feedback_correct_letter'));
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
          : context.t('qaida.lesson.feedback_try_again');
    });
  }

  Future<void> _advanceStep() async {
    if (!_stagePassed || _step >= 5) return;
    final nextStep = _step + 1;
    final appState = context.read<AppState>();
    await appState.saveQaidaLessonStep(widget.lessonId, nextStep);
    if (nextStep == 5) {
      _earnedXp = await appState.completeLesson(widget.lessonId);
      _lessonAlreadyCompleted = true;
    }
    if (!mounted) return;
    setState(() {
      _step = nextStep;
      _feedback = null;
      _stagePassed = false;
      _recognizedWords = '';
    });
  }

  Future<void> _playLetterAudio(String letter) async {
    try {
      final assetPath = arabicCharToAudioAsset[letter] ??
          qaidaLetterAudioAssets[widget.lessonId];
      if (assetPath != null) {
        final relativePath = assetPath.startsWith('assets/')
            ? assetPath.substring('assets/'.length)
            : assetPath;
        _audioPlayer ??= AudioPlayer();
        await _audioPlayer?.stop();
        await _audioPlayer?.play(AssetSource(relativePath));
        return;
      }
    } catch (_) {}

    try {
      await _tts.speak(letter);
    } catch (_) {}
  }

  Future<void> _speakTarget() async {
    try {
      final assetPath = qaidaLetterAudioAssets[widget.lessonId] ??
          arabicCharToAudioAsset[widget.letter];
      if (assetPath != null) {
        final relativePath = assetPath.startsWith('assets/')
            ? assetPath.substring('assets/'.length)
            : assetPath;
        _audioPlayer ??= AudioPlayer();
        await _audioPlayer?.stop();
        await _audioPlayer?.play(AssetSource(relativePath));
        if (mounted && _step == 0) setState(() => _heardLetter = true);
        return;
      }
    } catch (_) {}

    try {
      await _tts.speak(_arabicName);
      if (mounted && _step == 0) setState(() => _heardLetter = true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.t('qaida.lesson.audio_failed'))));
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
              _feedback = context.t('qaida.lesson.feedback_voice_excellent');
            } else if (result.finalResult && words.isNotEmpty) {
              _feedback = context.t('qaida.lesson.feedback_voice_close');
            }
          });
        },
      );
      if (mounted) setState(() => _isListening = true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _isListening = false;
          _feedback = context.t('qaida.lesson.feedback_mic_failed');
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
    final aliases = [
      _normalizeSpeech(_arabicName),
      _normalizeSpeech(context.uiText(widget.letterName)),
      ...switch (widget.letter) {
        'ا' => ['الف', 'alif', 'alef', 'elif', 'a', 'ا'],
        'ب' => ['باء', 'با', 'baa', 'ba', 'ب'],
        'ت' => ['تاء', 'تا', 'taa', 'ta', 'ت'],
        'ث' => ['ثاء', 'ثا', 'thaa', 'tha', 'tsa', 'ث'],
        'ج' => ['جيم', 'jeem', 'jim', 'ج'],
        'ح' => ['حاء', 'حا', 'haa', 'ha', 'ح'],
        'خ' => ['خاء', 'خا', 'khaa', 'kha', 'kho', 'خ'],
        'د' => ['دال', 'daal', 'dal', 'د'],
        'ذ' => ['ذال', 'dhaal', 'dhal', 'zal', 'ذ'],
        'ر' => ['راء', 'را', 'raa', 'ra', 'ر'],
        'ز' => ['زاي', 'زا', 'zaay', 'zay', 'zai', 'ز'],
        'س' => ['سين', 'siin', 'seen', 'sin', 'س'],
        'ش' => ['شين', 'shiin', 'sheen', 'shin', 'ش'],
        'ص' => ['صاد', 'saad', 'sad', 'shad', 'ص'],
        'ض' => ['ضاد', 'daad', 'dad', 'dhad', 'ض'],
        'ط' => ['طاء', 'طا', 'toa', 'to', 'taa', 'ط'],
        'ظ' => ['ظاء', 'ظا', 'zoa', 'zo', 'dhaa', 'ظ'],
        'ع' => ['عين', 'ayn', 'ain', 'ع'],
        'غ' => ['غين', 'ghayn', 'ghain', 'غ'],
        'ف' => ['فاء', 'فا', 'faa', 'fa', 'ف'],
        'ق' => ['قاف', 'qaaf', 'qaf', 'ق'],
        'ك' => ['كاف', 'kaaf', 'kaf', 'ك'],
        'ل' => ['لام', 'laam', 'lam', 'ل'],
        'م' => ['ميم', 'meem', 'mim', 'م'],
        'ن' => ['نون', 'noon', 'nuun', 'nun', 'ن'],
        'ه' => ['هاء', 'ها', 'haa', 'ha', 'ه'],
        'و' => ['واو', 'waw', 'waaw', 'و'],
        'ي' => ['ياء', 'يا', 'yaa', 'ya', 'ي'],
        _ => <String>[],
      },
    ];
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
      builder: (ctx) => AlertDialog(
        title: Text(ctx.t('qaida.lesson.guardian_help_title')),
        content: Text(
          ctx.t('qaida.lesson.guardian_help_message', params: {'letter': _arabicName}),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(ctx.t('qaida.lesson.try_again'))),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(ctx.t('qaida.lesson.confirmed_correct'))),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() {
        _stagePassed = true;
        _feedback = context.t('qaida.lesson.feedback_guardian_confirmed');
      });
    }
  }

  void _confirmSelfPractice() {
    setState(() {
      _stagePassed = true;
      _feedback = context.t('qaida.lesson.feedback_self_practice');
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
        builder: (_) => const QaidaChaptersScreen(),
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
              LocalizedText('$xp',
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
            child: LocalizedText(names[index],
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
            child: LocalizedText(letter,
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
                Text(context.uiText(title),
                    style: const TextStyle(
                        color: AppTheme.darkText,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text('${context.uiText(name)} · $arabicName',
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 12)),
              ])),
          IconButton.filledTonal(
            onPressed: canSpeak ? onSpeak : null,
            tooltip: context.t('qaida.lesson.listen_letter_name'),
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
                LocalizedText(glyph!,
                    style: const TextStyle(
                        color: AppTheme.primaryGreen,
                        fontSize: 22,
                        fontWeight: FontWeight.w800)),
              LocalizedText(label,
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
        child: LocalizedText(text,
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
                Text(context.t('qaida.lesson.makhraj_title'),
                    style: const TextStyle(
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
