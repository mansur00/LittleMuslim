import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/qaida/qaida_models.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_button.dart';

class QaidaActivityScreen extends StatefulWidget {
  const QaidaActivityScreen({
    super.key,
    required this.lesson,
    this.nextLesson,
  });

  final QaidaLessonInfo lesson;
  final QaidaLessonInfo? nextLesson;

  @override
  State<QaidaActivityScreen> createState() => _QaidaActivityScreenState();
}

class _QaidaActivityScreenState extends State<QaidaActivityScreen> {
  AudioPlayer? _player;
  final FlutterTts _tts = FlutterTts();
  int _currentActivityIndex = 0;
  int? _selectedOptionIndex;
  bool _hasChecked = false;
  bool _isCorrect = false;
  bool _isCompleted = false;
  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
    _playActivityAudio();
  }

  void _initAudio() {
    try {
      _player = AudioPlayer();
      _player?.onPlayerComplete.listen((_) {
        if (mounted) setState(() => _isPlayingAudio = false);
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _player?.dispose();
    _tts.stop();
    super.dispose();
  }

  QaidaActivity get _currentActivity =>
      widget.lesson.activities[_currentActivityIndex];

  Future<void> _playActivityAudio() async {
    final asset = _currentActivity.audioAsset ?? widget.lesson.audioAsset;
    if (asset != null && asset.isNotEmpty) {
      try {
        setState(() => _isPlayingAudio = true);
        await _player?.stop();
        await _player?.play(AssetSource(asset.replaceFirst('assets/', '')));
        return;
      } catch (_) {
        if (mounted) setState(() => _isPlayingAudio = false);
      }
    }

    // TTS fallback for Arabic text
    final text = _currentActivity.arabicTarget ?? widget.lesson.arabicDisplay;
    if (text.isNotEmpty) {
      try {
        setState(() => _isPlayingAudio = true);
        await _tts.setLanguage('ar');
        await _tts.speak(text);
        if (mounted) {
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) setState(() => _isPlayingAudio = false);
          });
        }
      } catch (_) {
        if (mounted) setState(() => _isPlayingAudio = false);
      }
    }
  }

  void _checkAnswer() {
    if (_hasChecked) return;
    final activity = _currentActivity;

    // Letter intro activities are informative
    if (activity.type == QaidaActivityType.letterIntro) {
      setState(() {
        _hasChecked = true;
        _isCorrect = true;
      });
      return;
    }

    if (_selectedOptionIndex == null) return;

    final isCorrect = _selectedOptionIndex == activity.correctIndex;
    setState(() {
      _hasChecked = true;
      _isCorrect = isCorrect;
    });
  }

  void _nextActivity() {
    if (_currentActivityIndex < widget.lesson.activities.length - 1) {
      setState(() {
        _currentActivityIndex++;
        _selectedOptionIndex = null;
        _hasChecked = false;
        _isCorrect = false;
      });
      _playActivityAudio();
    } else {
      // Completed lesson
      final state = context.read<AppState>();
      state.completeLesson(widget.lesson.id, xp: 15);
      setState(() {
        _isCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      return _buildCelebrationScreen();
    }

    final activity = _currentActivity;
    final progress =
        (_currentActivityIndex + 1) / widget.lesson.activities.length;
    final isIntro = activity.type == QaidaActivityType.letterIntro;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      size: 28, color: Color(0xFF777777)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 14,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.duoGreen),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFEDD5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt_rounded,
                          color: Color(0xFFFF9600), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${_currentActivityIndex + 1}/${widget.lesson.activities.length}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC2410C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Instruction / prompt
                        Text(
                          activity.prompt,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2B2D42),
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Arabic Target Card
                        if (activity.arabicTarget != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color: const Color(0xFFE2E8F0), width: 2),
                              boxShadow: [
                                BoxStyle.subtle,
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  activity.arabicTarget!,
                                  style: TextStyle(
                                    fontFamily: AppTheme.arabicFontFamily,
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                                const SizedBox(height: 12),
                                // Replay Audio Button
                                InkWell(
                                  onTap: _isPlayingAudio
                                      ? null
                                      : _playActivityAudio,
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _isPlayingAudio
                                          ? AppTheme.duoBlue.withOpacity(0.2)
                                          : AppTheme.duoBlue.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: AppTheme.duoBlue.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _isPlayingAudio
                                              ? Icons.volume_up_rounded
                                              : Icons.volume_down_rounded,
                                          color: AppTheme.duoBlueDark,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _isPlayingAudio
                                              ? 'বাজছে...'
                                              : 'উচ্চারণ শুনুন',
                                          style: GoogleFonts.hindSiliguri(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.duoBlueDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (activity.makhrajInfo != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'মাখরাজ: ${activity.makhrajInfo}',
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 13,
                                        color: const Color(0xFF475569),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Options grid / list
                        if (!isIntro && activity.options.isNotEmpty) ...[
                          Column(
                            children: List.generate(activity.options.length,
                                (index) {
                              final option = activity.options[index];
                              final isSelected =
                                  _selectedOptionIndex == index;
                              Color borderColor = const Color(0xFFE2E8F0);
                              Color bgColor = Colors.white;

                              if (_hasChecked) {
                                if (index == activity.correctIndex) {
                                  borderColor = AppTheme.duoGreen;
                                  bgColor = const Color(0xFFF0FDF4);
                                } else if (isSelected) {
                                  borderColor = const Color(0xFFEF4444);
                                  bgColor = const Color(0xFFFEF2F2);
                                }
                              } else if (isSelected) {
                                borderColor = AppTheme.duoBlue;
                                bgColor = const Color(0xFFEFF6FF);
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: _hasChecked
                                      ? null
                                      : () {
                                          setState(() =>
                                              _selectedOptionIndex = index);
                                        },
                                  borderRadius: BorderRadius.circular(16),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: borderColor,
                                        width: isSelected ||
                                                (_hasChecked &&
                                                    index ==
                                                        activity.correctIndex)
                                            ? 2.5
                                            : 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          offset: const Offset(0, 3),
                                          blurRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? (_hasChecked
                                                    ? (_isCorrect
                                                        ? AppTheme.duoGreen
                                                        : const Color(
                                                            0xFFEF4444))
                                                    : AppTheme.duoBlue)
                                                : const Color(0xFFF1F5F9),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: isSelected
                                                  ? Colors.white
                                                  : const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontFamily: option.contains(
                                                      RegExp(r'[\u0600-\u06FF]'))
                                                  ? AppTheme.arabicFontFamily
                                                  : GoogleFonts.hindSiliguri()
                                                      .fontFamily,
                                              fontSize: option.contains(
                                                      RegExp(r'[\u0600-\u06FF]'))
                                                  ? 26
                                                  : 17,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF1E293B),
                                            ),
                                            textDirection: option.contains(
                                                    RegExp(r'[\u0600-\u06FF]'))
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom action / feedback sheet
            _buildBottomBanner(isIntro),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBanner(bool isIntro) {
    if (!_hasChecked && !isIntro) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1.5)),
        ),
        child: SafeArea(
          top: false,
          child: Duolingo3DButton(
            text: 'যাচাই করুন',
            color: _selectedOptionIndex != null
                ? AppTheme.duoGreen
                : const Color(0xFFE5E7EB),
            textColor: _selectedOptionIndex != null
                ? Colors.white
                : const Color(0xFFAFAFAF),
            onPressed: _selectedOptionIndex != null ? _checkAnswer : null,
          ),
        ),
      );
    }

    // Checked state or Intro state
    final bool isSuccess = isIntro || _isCorrect;
    final Color bannerColor =
        isSuccess ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);
    final Color textColor =
        isSuccess ? const Color(0xFF15803D) : const Color(0xFFB45309);
    final Color btnColor =
        isSuccess ? AppTheme.duoGreen : const Color(0xFFF59E0B);
    final String title = isIntro
        ? 'মনোযোগ দিয়ে লক্ষ্য করুন'
        : (isSuccess ? 'মাশাআল্লাহ! চমৎকার!' : 'মনোযোগ দিয়ে আবার ভাবি');

    final String? feedback =
        _currentActivity.explanation ?? widget.lesson.description;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bannerColor,
        border: Border(
          top: BorderSide(
            color: isSuccess
                ? const Color(0xFF86EFAC)
                : const Color(0xFFFDE68A),
            width: 1.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  isSuccess
                      ? Icons.check_circle_rounded
                      : Icons.info_outline_rounded,
                  color: textColor,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            if (feedback != null && feedback.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                feedback,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  color: textColor.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Duolingo3DButton(
              text: 'পরবর্তী ধাপ',
              color: btnColor,
              onPressed: _nextActivity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationScreen() {
    final next = widget.nextLesson;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    size: 72,
                    color: Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'মাশাআল্লাহ!',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '“${widget.lesson.title}” পাঠ সফলভাবে সম্পন্ন হয়েছে!',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 16,
                    color: const Color(0xFF64748B),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RewardPill(
                      icon: Icons.bolt_rounded,
                      color: const Color(0xFFFF9600),
                      text: '+15 XP',
                    ),
                    const SizedBox(width: 16),
                    _RewardPill(
                      icon: Icons.workspace_premium_rounded,
                      color: AppTheme.duoGreen,
                      text: '১০০% সঠিক',
                    ),
                  ],
                ),
                const Spacer(),
                if (next != null) ...[
                  Duolingo3DButton(
                    text: 'পরবর্তী পাঠ: ${next.title}',
                    color: AppTheme.duoGreen,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => QaidaActivityScreen(
                            lesson: next,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                Duolingo3DButton(
                  text: 'অধ্যায় তালিকায় ফিরুন',
                  color: const Color(0xFFF1F5F9),
                  textColor: const Color(0xFF334155),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardPill extends StatelessWidget {
  const _RewardPill({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class BoxStyle {
  static final subtle = BoxShadow(
    color: Colors.black.withOpacity(0.04),
    offset: const Offset(0, 4),
    blurRadius: 12,
  );
}
