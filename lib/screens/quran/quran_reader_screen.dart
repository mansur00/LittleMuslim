import '../../l10n/app_localizations.dart';
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import 'quran_data.dart';

class QuranReaderScreen extends StatefulWidget {
  const QuranReaderScreen({
    super.key,
    this.surah,
    this.repository,
    this.initialAyah = 1,
  });

  final QuranSurah? surah;
  final QuranRepository? repository;
  final int initialAyah;

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen>
    with WidgetsBindingObserver {
  double _fontSize = 29;
  bool _isPlaying = false;
  late final AudioPlayer _audioPlayer;
  late final StreamSubscription<void> _audioCompleteSubscription;
  late final QuranRepository _repository =
      widget.repository ?? AlQuranCloudRepository();
  late final QuranSurah _surah = widget.surah ??
      const QuranSurah(
        number: 1,
        arabicName: 'سُورَةُ الْفَاتِحَة',
        englishName: 'আল-ফাতিহা',
        nameMeaning: 'The Opening',
        ayahCount: 7,
        revelationType: 'Meccan',
      );
  List<QuranAyah> _ayahs = const [];
  bool _loading = true;
  String? _loadError;
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _verseKeys = {};
  Timer? _positionSaveTimer;
  int _currentAyah = 1;
  int? _playingAyahNumber;
  bool _positionRestored = false;
  bool _allowPop = false;
  bool _isLeaving = false;

  @override
  void initState() {
    super.initState();
    _currentAyah = widget.initialAyah;
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AudioPlayer();
    _audioCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playingAyahNumber = null;
        });
      }
    });
    _loadSurah();
  }

  Future<void> _loadSurah() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final result = await _repository.getSurah(_surah);
      if (!mounted) return;
      final initialAyah = result.ayahs.isEmpty
          ? 1
          : widget.initialAyah.clamp(1, result.ayahs.length).toInt();
      setState(() {
        _ayahs = result.ayahs;
        _loading = false;
        _currentAyah = initialAyah;
        _verseKeys
          ..clear()
          ..addEntries(
              result.ayahs.map((ayah) => MapEntry(ayah.number, GlobalKey())));
      });
      if (result.ayahs.isNotEmpty) {
        await context
            .read<AppState>()
            .saveQuranReadingPosition(_surah.number, initialAyah);
        if (!mounted) return;
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _restorePosition(initialAyah));
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'এই সূরার পাঠ আনা যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করো।';
      });
    }
  }

  Future<void> _restorePosition(int ayahNumber) async {
    final targetContext = _verseKeys[ayahNumber]?.currentContext;
    if (targetContext != null && mounted) {
      await Scrollable.ensureVisible(targetContext,
          alignment: 0.05, duration: Duration.zero);
    }
    if (mounted) setState(() => _positionRestored = true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _positionSaveTimer?.cancel();
      _saveVisiblePosition();
    }
  }

  void _queuePositionSave(ScrollNotification notification) {
    if (_loading || !_positionRestored) return;
    final userMoved = notification is ScrollUpdateNotification &&
        notification.dragDetails != null;
    final scrollingEnded = notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle;
    if (!userMoved && !scrollingEnded) return;
    _positionSaveTimer?.cancel();
    _positionSaveTimer =
        Timer(const Duration(milliseconds: 250), _saveVisiblePosition);
  }

  int? _findVisibleAyah() {
    final topLimit = MediaQuery.paddingOf(context).top + 80;
    final bottomLimit = MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).bottom -
        12;
    int? visibleAyah;
    for (final ayah in _ayahs) {
      final renderObject =
          _verseKeys[ayah.number]?.currentContext?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) continue;
      final top = renderObject.localToGlobal(Offset.zero).dy;
      final bottom = top + renderObject.size.height;
      if (bottom > topLimit && top < bottomLimit) visibleAyah = ayah.number;
    }
    return visibleAyah;
  }

  Future<void> _saveVisiblePosition() async {
    if (!_positionRestored || !mounted) return;
    final visibleAyah = _findVisibleAyah();
    if (visibleAyah == null || visibleAyah == _currentAyah) return;
    setState(() => _currentAyah = visibleAyah);
    await context
        .read<AppState>()
        .saveQuranReadingPosition(_surah.number, visibleAyah);
  }

  Future<void> _leaveReader() async {
    if (_isLeaving) return;
    _isLeaving = true;
    _positionSaveTimer?.cancel();
    final visibleAyah = _findVisibleAyah();
    if (visibleAyah != null) {
      try {
        await context
            .read<AppState>()
            .saveQuranReadingPosition(_surah.number, visibleAyah);
      } catch (_) {
        // Keep the reader usable if local storage is temporarily unavailable.
      }
    }
    if (!mounted) return;
    setState(() => _allowPop = true);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _positionSaveTimer?.cancel();
    _scrollController.dispose();
    _audioCompleteSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleRecitation() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        if (mounted) setState(() => _isPlaying = false);
      } else {
        if (_playingAyahNumber != null) {
          await _audioPlayer.stop();
          if (mounted) setState(() => _playingAyahNumber = null);
        }
        await _audioPlayer.play(UrlSource(
            'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/${_surah.number}.mp3'));
        if (mounted) setState(() => _isPlaying = true);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: LocalizedText(
                'অডিও চালু হয়নি। ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করো।')));
    }
  }

  Future<void> _toggleAyahAudio(QuranAyah ayah) async {
    try {
      if (_playingAyahNumber == ayah.number) {
        await _audioPlayer.pause();
        if (mounted) setState(() => _playingAyahNumber = null);
      } else {
        if (_isPlaying) {
          await _audioPlayer.stop();
          if (mounted) setState(() => _isPlaying = false);
        }
        final surahStr = _surah.number.toString().padLeft(3, '0');
        final ayahStr = ayah.number.toString().padLeft(3, '0');
        final ayahUrl =
            'https://everyayah.com/data/Alafasy_128kbps/$surahStr$ayahStr.mp3';
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(ayahUrl));
        if (mounted) setState(() => _playingAyahNumber = ayah.number);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: LocalizedText(
                'আয়াতের অডিও চালু হয়নি। ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করো।')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final bookmarks =
        context.select<AppState, Set<String>>((state) => state.quranBookmarks);
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return PopScope<void>(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_leaveReader());
      },
      child: Scaffold(
        backgroundColor: AppTheme.cream,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      tablet ? 36 : 18, 10, tablet ? 36 : 18, 8),
                  child: _ReaderToolbar(
                    bookmarked:
                        bookmarks.contains('${_surah.number}:$_currentAyah'),
                    onBack: _leaveReader,
                    onBookmark: () => unawaited(appState.toggleQuranBookmark(
                        _surah.number, _currentAyah)),
                    fontSize: _fontSize,
                    onSmaller: () => setState(
                        () => _fontSize = (_fontSize - 2).clamp(23, 37)),
                    onLarger: () => setState(
                        () => _fontSize = (_fontSize + 2).clamp(23, 37)),
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      _queuePositionSave(notification);
                      return false;
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                              tablet ? 36 : 18, 10, tablet ? 36 : 18, 28),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              const SizedBox(height: 7),
                              _SurahHeading(
                                  surah: _surah,
                                  isPlaying: _isPlaying,
                                  onAudio: _toggleRecitation),
                              const SizedBox(height: 17),
                              if (_loading)
                                const Padding(
                                    padding: EdgeInsets.all(30),
                                    child: Center(
                                        child: CircularProgressIndicator()))
                              else if (_loadError != null)
                                _ReaderLoadError(
                                    message: _loadError!, onRetry: _loadSurah)
                              else if (_ayahs.isEmpty)
                                const _ReaderEmpty()
                              else
                                Column(children: [
                                  for (final ayah in _ayahs) ...[
                                    _VerseCard(
                                        key: _verseKeys[ayah.number],
                                        ayah: ayah,
                                        number: ayah.number,
                                        fontSize: _fontSize,
                                        isPlaying: _playingAyahNumber == ayah.number,
                                        onPlay: () => _toggleAyahAudio(ayah)),
                                    const SizedBox(height: 9),
                                  ],
                                ]),
                              const SizedBox(height: 11),
                              const LocalizedText(
                                  'রঙিন তাজবিদ: Quran.com · বাংলা অর্থ: মুহিউদ্দীন খান, Al Quran Cloud',
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
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReaderEmpty extends StatelessWidget {
  const _ReaderEmpty();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(24),
        child:
            Center(child: LocalizedText('এই সূরায় এখন কোনো আয়াত পাওয়া যায়নি।')),
      );
}

class _ReaderToolbar extends StatelessWidget {
  const _ReaderToolbar(
      {required this.bookmarked,
      required this.onBack,
      required this.onBookmark,
      required this.fontSize,
      required this.onSmaller,
      required this.onLarger});
  final bool bookmarked;
  final VoidCallback onBack, onBookmark, onSmaller, onLarger;
  final double fontSize;
  @override
  Widget build(BuildContext context) => Row(children: [
        IconButton.filledTonal(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(backgroundColor: Colors.white)),
        const SizedBox(width: 7),
        const Expanded(
            child: LocalizedText('পাঠ মোড',
                style: TextStyle(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w800,
                    fontSize: 16))),
        IconButton(
            onPressed: onSmaller,
            tooltip: context.uiText('ছোট লেখা'),
            icon: const Icon(Icons.text_decrease_rounded,
                color: AppTheme.primaryGreen)),
        LocalizedText('${fontSize.round()}',
            style: const TextStyle(color: Colors.black54, fontSize: 11)),
        IconButton(
            onPressed: onLarger,
            tooltip: context.uiText('বড় লেখা'),
            icon: const Icon(Icons.text_increase_rounded,
                color: AppTheme.primaryGreen)),
        IconButton.filledTonal(
            onPressed: onBookmark,
            tooltip: context.uiText(bookmarked ? 'বুকমার্ক সরাও' : 'বুকমার্ক'),
            icon: Icon(
                bookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: AppTheme.primaryGreen),
            style: IconButton.styleFrom(backgroundColor: Colors.white)),
      ]);
}

class _SurahHeading extends StatelessWidget {
  const _SurahHeading({
    required this.surah,
    required this.isPlaying,
    required this.onAudio,
  });
  final QuranSurah surah;
  final bool isPlaying;
  final VoidCallback onAudio;
  @override
  Widget build(BuildContext context) => DuolingoCard(
        accentColor: AppTheme.primaryGreen,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
        child: Column(children: [
          LocalizedText(surah.arabicName,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                  fontFamily: AppTheme.arabicFontFamily,
                  color: AppTheme.primaryGreen,
                  fontSize: 30,
                  height: 1.7,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          LocalizedText('সূরা ${surah.englishName}',
              style: const TextStyle(
                  color: AppTheme.darkText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          LocalizedText(
              '${surah.revelationType == 'Meccan' ? 'মক্কী' : 'মাদানী'}  ·  ${surah.ayahCount} আয়াত · ${surah.nameMeaning}',
              style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 14),
          OutlinedButton.icon(
              onPressed: onAudio,
              icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 19),
              label:
                  LocalizedText(isPlaying ? 'তিলাওয়াত থামাই' : 'তিলাওয়াত শুনি'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGreen,
                  side: const BorderSide(color: Color(0xFFB8D8C3), width: 1.3),
                  shape: const StadiumBorder())),
        ]),
      );
}

class _VerseCard extends StatelessWidget {
  const _VerseCard({
    super.key,
    required this.ayah,
    required this.number,
    required this.fontSize,
    required this.isPlaying,
    required this.onPlay,
  });
  final QuranAyah ayah;
  final int number;
  final double fontSize;
  final bool isPlaying;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) => DuolingoCard(
        accentColor: isPlaying ? AppTheme.accentCoral : const Color(0xFF0D7377),
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text.rich(
            TextSpan(children: _tajweedSpans(ayah.tajweedText, fontSize)),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontFamily: AppTheme.arabicFontFamily,
                color: AppTheme.darkText,
                fontSize: fontSize,
                height: 2,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          LocalizedText(ayah.translation,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.black54, fontSize: 13, height: 1.6)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      color: isPlaying ? const Color(0xFFFFE0E0) : const Color(0xFFFFF2CE),
                      borderRadius: BorderRadius.circular(9)),
                  alignment: Alignment.center,
                  child: LocalizedText('$number',
                      style: TextStyle(
                          color: isPlaying ? const Color(0xFFD32F2F) : const Color(0xFFA57910),
                          fontSize: 11,
                          fontWeight: FontWeight.w800))),
              const Spacer(),
              IconButton(
                onPressed: onPlay,
                tooltip: context.uiText(isPlaying ? 'আয়াত থামাই' : 'আয়াত শুনি'),
                icon: Icon(
                  isPlaying ? Icons.pause_circle_rounded : Icons.play_circle_outline_rounded,
                  color: isPlaying ? AppTheme.accentCoral : AppTheme.primaryGreen,
                  size: 26,
                ),
              ),
            ],
          ),
        ]),
      );
}

class _ReaderLoadError extends StatelessWidget {
  const _ReaderLoadError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Column(children: [
          LocalizedText(message, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const LocalizedText('আবার চেষ্টা করি')),
        ]),
      );
}

List<InlineSpan> _tajweedSpans(String taggedText, double fontSize) {
  final spans = <InlineSpan>[];
  final tagPattern = RegExp(
    r"""<tajweed\b[^>]*class=(?:"([^"]+)"|'([^']+)'|([^\s>]+))[^>]*>(.*?)</tajweed>""",
    dotAll: true,
  );
  final cleanText = taggedText.replaceAll(
      RegExp(r'<span class=end>.*?</span>', dotAll: true), '');
  var cursor = 0;
  for (final match in tagPattern.allMatches(cleanText)) {
    if (match.start > cursor) {
      spans.add(TextSpan(text: cleanText.substring(cursor, match.start)));
    }
    spans.add(TextSpan(
      text: match.group(4),
      style: TextStyle(
          color: _tajweedColor(
              match.group(1) ?? match.group(2) ?? match.group(3)!),
          fontSize: fontSize),
    ));
    cursor = match.end;
  }
  if (cursor < cleanText.length) {
    spans.add(TextSpan(text: cleanText.substring(cursor)));
  }
  return spans;
}

Color _tajweedColor(String rule) => switch (rule) {
      'ham_wasl' || 'laam_shamsiyah' => const Color(0xFFAAAAAA),
      'madda_normal' => const Color(0xFF537FFF),
      'madda_permissible' => const Color(0xFF4050FF),
      'madda_necessary' => const Color(0xFF000EBC),
      'madda_obligatory' => const Color(0xFF2144C1),
      'qlq' => const Color(0xFFDD0008),
      'ikhf_shfw' => const Color(0xFFD500B7),
      'ikhf' => const Color(0xFF9400A8),
      'idghm_shfw' => const Color(0xFF58B800),
      'iqlb' => const Color(0xFF26BFFD),
      'idgh_ghn' => const Color(0xFF169777),
      'idgh_w_ghn' => const Color(0xFF169200),
      'idgh_mus' => const Color(0xFFA1A1A1),
      'ghn' => const Color(0xFFFF7E1E),
      _ => AppTheme.darkText,
    };
