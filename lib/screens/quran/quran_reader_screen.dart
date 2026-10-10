import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/duolingo_appbar.dart';
import 'quran_data.dart';

class QuranReaderScreen extends StatefulWidget {
  const QuranReaderScreen({
    super.key,
    this.surah,
    this.repository,
  });

  final QuranSurah? surah;
  final QuranRepository? repository;

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  double _fontSize = 29;
  bool _bookmarked = false;
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

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
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
      setState(() {
        _ayahs = result.ayahs;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'এই সূরার পাঠ আনা যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করো।';
      });
    }
  }

  @override
  void dispose() {
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
        await _audioPlayer.play(UrlSource(
            'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/${_surah.number}.mp3'));
        if (mounted) setState(() => _isPlaying = true);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content:
                Text('অডিও চালু হয়নি। ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করো।')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      tablet ? 36 : 18, 10, tablet ? 36 : 18, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _ReaderToolbar(
                        bookmarked: _bookmarked,
                        onBack: () => Navigator.pop(context),
                        onBookmark: () =>
                            setState(() => _bookmarked = !_bookmarked),
                        fontSize: _fontSize,
                        onSmaller: () => setState(
                            () => _fontSize = (_fontSize - 2).clamp(23, 37)),
                        onLarger: () => setState(
                            () => _fontSize = (_fontSize + 2).clamp(23, 37)),
                      ),
                      const SizedBox(height: 15),
                      _SurahHeading(
                        surah: _surah,
                        isPlaying: _isPlaying,
                        onAudio: _toggleRecitation,
                      ),
                      const SizedBox(height: 17),
                      if (_loading)
                        const Padding(
                          padding: EdgeInsets.all(30),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_loadError != null)
                        _ReaderLoadError(
                            message: _loadError!, onRetry: _loadSurah)
                      else
                        for (final ayah in _ayahs) ...[
                          _VerseCard(
                              ayah: ayah,
                              number: ayah.number,
                              fontSize: _fontSize),
                          const SizedBox(height: 9),
                        ],
                      const SizedBox(height: 11),
                      const Text(
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
      ),
    );
  }
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
            child: Text('পাঠ মোড',
                style: TextStyle(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w800,
                    fontSize: 16))),
        IconButton(
            onPressed: onSmaller,
            tooltip: 'ছোট লেখা',
            icon: const Icon(Icons.text_decrease_rounded,
                color: AppTheme.primaryGreen)),
        Text('${fontSize.round()}',
            style: const TextStyle(color: Colors.black54, fontSize: 11)),
        IconButton(
            onPressed: onLarger,
            tooltip: 'বড় লেখা',
            icon: const Icon(Icons.text_increase_rounded,
                color: AppTheme.primaryGreen)),
        IconButton.filledTonal(
            onPressed: onBookmark,
            tooltip: 'বুকমার্ক',
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
          Text(surah.arabicName,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 30,
                  height: 1.7,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('সূরা ${surah.englishName}',
              style: TextStyle(
                  color: AppTheme.darkText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text(
              '${surah.revelationType == 'Meccan' ? 'মক্কী' : 'মাদানী'}  ·  ${surah.ayahCount} আয়াত · ${surah.nameMeaning}',
              style: TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 14),
          OutlinedButton.icon(
              onPressed: onAudio,
              icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 19),
              label: Text(isPlaying ? 'তিলাওয়াত থামাই' : 'তিলাওয়াত শুনি'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGreen,
                  side: const BorderSide(color: Color(0xFFB8D8C3), width: 1.3),
                  shape: const StadiumBorder())),
        ]),
      );
}

class _VerseCard extends StatelessWidget {
  const _VerseCard(
      {required this.ayah, required this.number, required this.fontSize});
  final QuranAyah ayah;
  final int number;
  final double fontSize;
  @override
  Widget build(BuildContext context) => DuolingoCard(
        accentColor: const Color(0xFF0D7377),
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text.rich(
            TextSpan(children: _tajweedSpans(ayah.tajweedText, fontSize)),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
                color: AppTheme.darkText,
                fontSize: fontSize,
                height: 2,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(ayah.translation,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.black54, fontSize: 13, height: 1.6)),
          const SizedBox(height: 8),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF2CE),
                      borderRadius: BorderRadius.circular(9)),
                  alignment: Alignment.center,
                  child: Text('$number',
                      style: const TextStyle(
                          color: Color(0xFFA57910),
                          fontSize: 11,
                          fontWeight: FontWeight.w800)))),
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
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('আবার চেষ্টা করি')),
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
