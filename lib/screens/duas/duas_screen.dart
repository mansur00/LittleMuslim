import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/duolingo_appbar.dart';

class _DuaEntry {
  const _DuaEntry({
    required this.id,
    required this.category,
    required this.arabic,
    required this.color,
    required this.accent,
  });
  final String id, category, arabic;
  final Color color, accent;

  String getLocalizedTitle(BuildContext context) =>
      context.t('duas.item.$id.title');

  String getLocalizedMeaning(BuildContext context) =>
      context.t('duas.item.$id.meaning');

  String getLocalizedReference(BuildContext context) =>
      context.t('duas.item.$id.reference');

  String getLocalizedCategory(BuildContext context) =>
      _DuasScreenState.getCategoryLabel(context, category);
}

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  static const _categories = [
    'all',
    'favorites',
    'morning_evening',
    'daily',
    'sleep',
    'travel',
    'special'
  ];

  static String getCategoryLabel(BuildContext context, String category) {
    switch (category) {
      case 'all':
      return context.t('duas.category.all');
      case 'favorites':
      return context.t('duas.category.favorites');
      case 'morning_evening':
      return context.t('duas.category.morning_evening');
      case 'daily':
      return context.t('duas.category.daily');
      case 'sleep':
      return context.t('duas.category.sleep');
      case 'travel':
      return context.t('duas.category.travel');
      case 'special':
      return context.t('duas.category.special');
      default:
        return category;
    }
  }

  static List<String> getCategoryLabels(BuildContext context) => [
        context.t('duas.category.all'),
        context.t('duas.category.favorites'),
        context.t('duas.category.morning_evening'),
        context.t('duas.category.daily'),
        context.t('duas.category.sleep'),
        context.t('duas.category.travel'),
        context.t('duas.category.special'),
      ];
  static const _duas = [
    _DuaEntry(
      id: 'wake',
      category: 'morning_evening',
      arabic:
          'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا، وَإِلَيْهِ النُّشُورُ',
      color: Color(0xFFFFF6D0),
      accent: Color(0xFFD4A017),
    ),
    _DuaEntry(
      id: 'morning_protection',
      category: 'morning_evening',
      arabic:
          'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      color: Color(0xFFFFF6D0),
      accent: Color(0xFFD4A017),
    ),
    _DuaEntry(
      id: 'evening_adhkar',
      category: 'morning_evening',
      arabic:
          'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
      color: Color(0xFFFFF0DB),
      accent: Color(0xFFE8913A),
    ),
    _DuaEntry(
      id: 'morning_sabah',
      category: 'morning_evening',
      arabic:
          'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا الْيَوْمِ وَخَيْرَ مَا بَعْدَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذَا الْيَوْمِ وَشَرِّ مَا بَعْدَهُ، رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ، وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ',
      color: Color(0xFFFFF6D0),
      accent: Color(0xFFD4A017),
    ),
    _DuaEntry(
      id: 'food',
      category: 'daily',
      arabic: 'بِسْمِ اللَّهِ',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'food_after',
      category: 'daily',
      arabic:
          'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا، وَكَفَانَا، وَآوَانَا، فَكَمْ مِمَّنْ لَا كَافِيَ لَهُ وَلَا مُؤْوِيَ',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'wudu_after',
      category: 'daily',
      arabic:
          'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF46A302),
    ),
    _DuaEntry(
      id: 'clothes',
      category: 'daily',
      arabic:
          'الْحَمْدُ لِلَّهِ الَّذِي كَسَانِي هَذَا الثَّوْبَ وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
      color: Color(0xFFFFF0DB),
      accent: Color(0xFFE8913A),
    ),
    _DuaEntry(
      id: 'restroom',
      category: 'daily',
      arabic:
          'بِسْمِ اللَّهِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'restroom_exit',
      category: 'daily',
      arabic: 'غُفْرَانَكَ',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'leave_home',
      category: 'daily',
      arabic:
          'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      color: Color(0xFFFFF0DB),
      accent: Color(0xFFE8913A),
    ),
    _DuaEntry(
      id: 'enter_home',
      category: 'daily',
      arabic:
          'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى رَبِّنَا تَوَكَّلْنَا',
      color: Color(0xFFFFF0DB),
      accent: Color(0xFFE8913A),
    ),
    _DuaEntry(
      id: 'mosque_enter',
      category: 'daily',
      arabic:
          'أَعُوذُ بِاللَّهِ الْعَظِيمِ، وَبِوَجْهِهِ الْكَرِيمِ، وَسُلْطَانِهِ الْقَدِيمِ، مِنَ الشَّيْطَانِ الرَّجِيمِ، بِسْمِ اللَّهِ، وَالصَّلَاةُ وَالسَّلَّامُ عَلَى رَسُولِ اللَّهِ، اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF46A302),
    ),
    _DuaEntry(
      id: 'mosque_exit',
      category: 'daily',
      arabic:
          'بِسْمِ اللَّهِ، وَالصَّلَاةُ وَالسَّلَّامُ عَلَى رَسُولِ اللَّهِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ، اللَّهُمَّ اعْصِمْنِي مِنَ الشَّيْطَانِ الرَّجِيمِ',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF46A302),
    ),
    _DuaEntry(
      id: 'sleep',
      category: 'sleep',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      color: Color(0xFFF3E8FF),
      accent: Color(0xFF9B6BC9),
    ),
    _DuaEntry(
      id: 'sleep_ayatul_kursi',
      category: 'sleep',
      arabic:
          'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
      color: Color(0xFFF3E8FF),
      accent: Color(0xFF9B6BC9),
    ),
    _DuaEntry(
      id: 'nightmare',
      category: 'sleep',
      arabic:
          'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ غَضَبِهِ وَعِقَابِهِ، وَشَرِّ عِبَادِهِ، وَمِنْ هَمَزَاتِ الشَّيَاطِينِ وَأَنْ يَحْضُرُونِ',
      color: Color(0xFFF3E8FF),
      accent: Color(0xFF9B6BC9),
    ),
    _DuaEntry(
      id: 'travel',
      category: 'travel',
      arabic:
          'بِسْمِ اللَّهِ وَالْحَمْدُ لِلَّهِ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ، الْحَمْدُ لِلَّهِ، الْحَمْدُ لِلَّهِ، الْحَمْدُ لِلَّهِ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، سُبْحَانَكَ اللَّهُمَّ إِنِّي ظَلَمْتُ نَفْسِي فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      color: Color(0xFFDCEBFF),
      accent: Color(0xFF3B82C4),
    ),
    _DuaEntry(
      id: 'travel_return',
      category: 'travel',
      arabic:
          'اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ، اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى، وَمِنَ الْعَمَلِ مَا تَرْضَى، اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا وَاطْوِ عَنَّا بُعْدَهُ، اللَّهُمَّ أَنْتَ الصَّاحِبُ فِي السَّفَرِ، وَالْخَلِيفَةُ فِي الْأَهْلِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ وَعْثَاءِ السَّفَرِ، وَكَآبَةِ الْمَنْظَرِ، وَسُوءِ الْمُنْقَلَبِ فِي الْمَالِ وَالْأَهْلِ، آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ',
      color: Color(0xFFDCEBFF),
      accent: Color(0xFF3B82C4),
    ),
    _DuaEntry(
      id: 'rain',
      category: 'daily',
      arabic: 'اللَّهُمَّ صَيِّبًا نَافِعًا',
      color: Color(0xFFDCEBFF),
      accent: Color(0xFF3B82C4),
    ),
    _DuaEntry(
      id: 'sneeze',
      category: 'daily',
      arabic: 'الْحَمْدُ لِلَّهِ',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'sneeze_response',
      category: 'daily',
      arabic: 'يَرْحَمُكَ اللَّهُ',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'anxiety',
      category: 'special',
      arabic:
          'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
      color: Color(0xFFFFEBCF),
      accent: Color(0xFFE8913A),
    ),
    _DuaEntry(
      id: 'forgiveness',
      category: 'special',
      arabic:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF46A302),
    ),
    _DuaEntry(
      id: 'parents',
      category: 'special',
      arabic:
          'وَاخْفِضْ لَهُمَا جَنَاحَ الذُّلِّ مِنَ الرَّحْمَةِ وَقُلْ رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
      color: Color(0xFFFFF6D0),
      accent: Color(0xFFD4A017),
    ),
  ];

  int _selectedCategory = 0;
  AudioPlayer? _audioPlayer;
  StreamSubscription<void>? _playerCompleteSub;
  String? _playingDuaId;
  final FlutterTts _tts = FlutterTts();

  // All duas now have local MP3 audio files bundled with the app
  static const _mp3Duas = {
    'wake', 'morning_protection', 'evening_adhkar', 'morning_sabah',
    'food', 'food_after', 'restroom', 'restroom_exit', 'leave_home',
    'enter_home', 'mosque_enter', 'mosque_exit', 'sleep',
    'sleep_ayatul_kursi', 'nightmare', 'mirror', 'travel',
    'travel_return', 'rain', 'sneeze', 'sneeze_response',
    'anxiety', 'forgiveness', 'parents',
  };

  AudioPlayer _getAudioPlayer() {
    if (_audioPlayer == null) {
      final player = AudioPlayer();
      _audioPlayer = player;
      _playerCompleteSub = player.onPlayerComplete.listen((_) {
        if (mounted) setState(() => _playingDuaId = null);
      });
    }
    return _audioPlayer!;
  }

  Future<void> _playDuaAudio(String id, String arabicText) async {
    // Toggle off if same dua already playing
    if (_playingDuaId == id) {
      try {
        await _audioPlayer?.stop();
        await _tts.stop();
      } catch (_) {}
      if (mounted) setState(() => _playingDuaId = null);
      return;
    }

    // Stop previous playback
    try {
      await _audioPlayer?.stop();
      await _tts.stop();
    } catch (_) {}
    if (mounted) setState(() => _playingDuaId = id);

    // Try local MP3 first, then fall back to Arabic TTS
    if (_mp3Duas.contains(id)) {
      try {
        final player = _getAudioPlayer();
        await player.play(AssetSource('audio/duas/$id.mp3'));
        return;
      } catch (_) {
        // fall through to TTS
      }
    }

    // Arabic TTS fallback
    try {
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(0.40);
      await _tts.setPitch(1.0);
      _tts.setCompletionHandler(() {
        if (mounted) setState(() => _playingDuaId = null);
      });
      await _tts.speak(arabicText);
    } catch (_) {
      if (mounted) {
        setState(() => _playingDuaId = null);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(context.t('duas.audio_unavailable')),
            behavior: SnackBarBehavior.floating,
          ));
      }
    }
  }

  @override
  void dispose() {
    _playerCompleteSub?.cancel();
    _audioPlayer?.dispose();
    try {
      _tts.stop().catchError((_) => null);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final selectedCategory = _categories[_selectedCategory];
    final filtered = _duas
        .where((dua) =>
            selectedCategory == 'all' ||
            (selectedCategory == 'favorites'
                ? appState.isDuaFavorite(dua.id)
                : dua.category == selectedCategory))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
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
                        title: context.t('duas.header_title'),
                        subtitle: context.t('duas.header_subtitle'),
                        customIcon: Image.asset(
                          'assets/images/badge_dua_3d.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                        gradientColors: const [
                          Color(0xFF9B6BC9),
                          Color(0xFF7B4FA8)
                        ],
                        onBack: () => Navigator.pop(context),
                      ),

                      // ── Habit tip card ──
                      DuolingoCard(
                        accentColor: const Color(0xFF9B6BC9),
                        showAccentStripe: true,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E8FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: VectorIcon(
                                  type: VectorIconType.lightbulb,
                                  size: 24,
                                  color: Color(0xFF9B6BC9)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(context.t('duas.habit_title'),
                                      style: const TextStyle(
                                          color: AppTheme.darkText,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13)),
                                  const SizedBox(height: 2),
                                  Text(
                                      context.t('duas.habit_desc'),
                                      style: const TextStyle(
                                          color: Color(0xFF6B5B7A),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                ]),
                          ),
                        ]),
                      ),

                      // ── Category pills ──
                      DuolingoCategoryBar(
                        categories: getCategoryLabels(context),
                        selected: _selectedCategory,
                        onSelect: (i) => setState(() => _selectedCategory = i),
                        activeColor: const Color(0xFF9B6BC9),
                      ),
                      const SizedBox(height: 16),

                      // ── Dua cards ──
                      if (filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 36),
                          child: Center(
                              child: Text(
                                  context.t('duas.empty_favorites'))),
                        ),
                      for (final dua in filtered)
                        _DuaCard(
                          dua: dua,
                          isFavorite: appState.isDuaFavorite(dua.id),
                          isPlaying: _playingDuaId == dua.id,
                          onPlayAudio: () => _playDuaAudio(dua.id, dua.arabic),
                          onFavorite: () async {
                            final wasFavorite = appState.isDuaFavorite(dua.id);
                            await appState.toggleDuaFavorite(dua.id);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                content: Text(context.t(wasFavorite
                                    ? 'duas.favorite_removed'
                                    : 'duas.favorite_added')),
                                behavior: SnackBarBehavior.floating,
                              ));
                          },
                          onCopy: () => _copyDua(context, dua.arabic),
                        ),

                      const SizedBox(height: 12),
                      Text(
                        context.t('duas.disclaimer'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.darkText.withValues(alpha: 0.4),
                            fontSize: 10,
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

  void _copyDua(BuildContext context, String arabic) {
    Clipboard.setData(ClipboardData(text: arabic));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(context.t('duas.copied')),
          behavior: SnackBarBehavior.floating));
  }
}

class _DuaCard extends StatefulWidget {
  const _DuaCard({
    required this.dua,
    required this.isFavorite,
    required this.isPlaying,
    required this.onPlayAudio,
    required this.onFavorite,
    required this.onCopy,
  });
  final _DuaEntry dua;
  final bool isFavorite;
  final bool isPlaying;
  final VoidCallback onPlayAudio;
  final VoidCallback onFavorite, onCopy;

  @override
  State<_DuaCard> createState() => _DuaCardState();
}

class _DuaCardState extends State<_DuaCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final dua = widget.dua;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: dua.accent.withValues(alpha: 0.25), width: 2),
        boxShadow: [
          BoxShadow(
              color: dua.accent.withValues(alpha: 0.12),
              blurRadius: 0,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 0),
            child: Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: dua.color, borderRadius: BorderRadius.circular(14)),
                child: Center(
                    child: VectorIcon(
                        type: VectorIconType.dua, size: 24, color: dua.accent)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dua.getLocalizedTitle(context),
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontWeight: FontWeight.w800,
                              fontSize: 14)),
                      Text(dua.getLocalizedCategory(context),
                          style: TextStyle(
                              color: AppTheme.darkText.withValues(alpha: 0.45),
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ]),
              ),
              IconButton(
                onPressed: widget.onFavorite,
                tooltip: context.t(
                    widget.isFavorite ? 'duas.tooltip.favorite_remove' : 'duas.tooltip.favorite_add'),
                icon: Icon(
                  widget.isFavorite
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: widget.isFavorite ? dua.accent : Colors.black38,
                ),
              ),
            ]),
          ),

          // ── Arabic box ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [dua.color, dua.color.withValues(alpha: 0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                dua.arabic,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppTheme.arabicFontFamily,
                    color: dua.accent,
                    fontSize: dua.arabic.length > 150 ? 18 : (dua.arabic.length > 80 ? 20 : 22),
                    height: 1.8,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),

          // ── Meaning (collapsible) ──
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(children: [
                Expanded(
                  child: AnimatedCrossFade(
                    firstChild: Text(
                      dua.getLocalizedMeaning(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppTheme.darkText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                    secondChild: Text(
                      dua.getLocalizedMeaning(context),
                      style: const TextStyle(
                          color: AppTheme.darkText,
                          fontSize: 13,
                          height: 1.55,
                          fontWeight: FontWeight.w500),
                    ),
                    crossFadeState: _expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                ),
                Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: dua.accent,
                    size: 20),
              ]),
            ),
          ),

          // ── Footer ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 8, 8),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: dua.color, borderRadius: BorderRadius.circular(8)),
                child: Text(dua.getLocalizedReference(context),
                    style: TextStyle(
                        color: dua.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ),
              const Spacer(),
              InkWell(
                onTap: widget.onPlayAudio,
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: widget.isPlaying
                        ? widget.dua.accent
                        : widget.dua.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.isPlaying
                            ? Icons.pause_rounded
                            : Icons.volume_up_rounded,
                        size: 16,
                        color: widget.isPlaying
                            ? Colors.white
                            : widget.dua.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.t(widget.isPlaying ? 'duas.audio_stop' : 'duas.audio_listen'),
                        style: TextStyle(
                            color: widget.isPlaying
                                ? Colors.white
                                : widget.dua.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                  onPressed: () => _openDetail(context),
                  tooltip: context.t('duas.tooltip.practice'),
                  icon: Icon(Icons.touch_app_rounded,
                      color: dua.accent, size: 20)),
              const SizedBox(width: 4),
              IconButton(
                  onPressed: widget.onCopy,
                  tooltip: context.t('duas.tooltip.copy'),
                  icon: const Icon(Icons.copy_rounded,
                      color: Colors.black45, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints()),
              const SizedBox(width: 8),
            ]),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DuaDetailSheet(
        dua: widget.dua,
        isFavorite: widget.isFavorite,
        isPlaying: widget.isPlaying,
        onPlayAudio: widget.onPlayAudio,
        onFavorite: widget.onFavorite,
        onCopy: widget.onCopy,
      ),
    );
  }
}

class _DuaDetailSheet extends StatefulWidget {
  const _DuaDetailSheet({
    required this.dua,
    required this.isFavorite,
    required this.isPlaying,
    required this.onPlayAudio,
    required this.onFavorite,
    required this.onCopy,
  });

  final _DuaEntry dua;
  final bool isFavorite;
  final bool isPlaying;
  final VoidCallback onPlayAudio;
  final VoidCallback onFavorite;
  final VoidCallback onCopy;

  @override
  State<_DuaDetailSheet> createState() => _DuaDetailSheetState();
}

class _DuaDetailSheetState extends State<_DuaDetailSheet> {
  int _target = 3;
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final dua = widget.dua;
    final isDone = _counter >= _target;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: dua.color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      dua.getLocalizedCategory(context),
                      style: TextStyle(
                          color: dua.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: widget.onFavorite,
                    tooltip: context.t(widget.isFavorite
                        ? 'duas.tooltip.favorite_remove'
                        : 'duas.tooltip.favorite_add'),
                    icon: Icon(
                      widget.isFavorite
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: widget.isFavorite ? dua.accent : Colors.black45,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onCopy,
                    tooltip: context.t('duas.tooltip.copy'),
                    icon: const Icon(Icons.copy_rounded, color: Colors.black45),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                dua.getLocalizedTitle(context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [dua.color, dua.color.withValues(alpha: 0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                      color: dua.accent.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Text(
                  dua.arabic,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTheme.arabicFontFamily,
                    color: dua.accent,
                    fontSize: 26,
                    height: 1.7,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: widget.onPlayAudio,
                icon: Icon(
                  widget.isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.volume_up_rounded,
                  size: 22,
                ),
                label: Text(
                  context.t(widget.isPlaying ? 'duas.detail.audio_stop' : 'duas.detail.audio_listen'),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      widget.isPlaying ? AppTheme.accentCoral : dua.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('duas.detail.meaning_label'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dua.getLocalizedMeaning(context),
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: AppTheme.darkText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: dua.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        context.t('duas.detail.source', params: {'reference': dua.getLocalizedReference(context)}),
                        style: TextStyle(
                          color: dua.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Practice target & counter
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.t('duas.practice.goal_title'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: AppTheme.darkText,
                          ),
                        ),
                        Row(
                          children: [
                            for (final t in [1, 3, 7, 33])
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: InkWell(
                                  onTap: () => setState(() {
                                    _target = t;
                                    if (_counter > _target) _counter = _target;
                                  }),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _target == t
                                          ? dua.accent
                                          : const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      context.formatDigits('$t'),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: _target == t
                                            ? Colors.white
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_counter < _target) _counter++;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDone
                                ? [
                                    const Color(0xFF58CC02),
                                    const Color(0xFF58A700)
                                  ]
                                : [dua.accent, dua.accent.withValues(alpha: 0.85)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (isDone
                                      ? const Color(0xFF58A700)
                                      : dua.accent)
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              isDone
                                  ? Icons.check_circle_rounded
                                  : Icons.touch_app_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isDone
                                  ? context.t('duas.practice.done', params: {'target': context.formatDigits('$_target')})
                                  : context.t('duas.practice.progress', params: {'count': context.formatDigits('$_counter'), 'target': context.formatDigits('$_target')}),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_counter > 0)
                      TextButton.icon(
                        onPressed: () => setState(() => _counter = 0),
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: Text(context.t('duas.practice.reset')),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black45),
                      ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
