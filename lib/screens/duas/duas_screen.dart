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
    required this.title,
    required this.category,
    required this.arabic,
    required this.meaning,
    required this.reference,
    required this.color,
    required this.accent,
  });
  final String id, title, category, arabic, meaning, reference;
  final Color color, accent;
}

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  static const _categories = [
    'সব',
    'পছন্দের',
    'সকাল ও সন্ধ্যা',
    'দৈনন্দিন',
    'ঘুম',
    'সফর',
    'বিশেষ'
  ];
  static const _duas = [
    _DuaEntry(
      id: 'wake',
      title: 'ঘুম থেকে উঠলে',
      category: 'সকাল ও সন্ধ্যা',
      arabic:
          'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا، وَإِلَيْهِ النُّشُورُ',
      meaning:
          'সব প্রশংসা আল্লাহর, যিনি ঘুমের পর আমাদের জীবিত করেছেন; আর তাঁর কাছেই পুনরুত্থান।',
      reference: 'সহিহ বুখারি ৬৩২৪',
      color: Color(0xFFFFF6D0),
      accent: Color(0xFFD4A017),
    ),
    _DuaEntry(
      id: 'morning_protection',
      title: 'সকালের দোয়া (সুরক্ষা)',
      category: 'সকাল ও সন্ধ্যা',
      arabic:
          'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      meaning:
          'আল্লাহর নামে, যার নামের সাথে আসমান ও জমিনে কোনো কিছু ক্ষতি করতে পারে না; তিনি সর্বশ্রোতা, সর্বজ্ঞানী।',
      reference: 'আবু দাউদ ৫০৮৮',
      color: Color(0xFFFFF6D0),
      accent: Color(0xFFD4A017),
    ),
    _DuaEntry(
      id: 'evening_adhkar',
      title: 'সন্ধ্যার দোয়া',
      category: 'সকাল ও সন্ধ্যা',
      arabic:
          'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
      meaning:
          'হে আল্লাহ, আপনার অনুগ্রহে আমরা সকালে উপনীত হয়েছি এবং আপনার অনুগ্রহে আমরা সন্ধ্যায় উপনীত হয়েছি। আপনার নামেই আমরা বাঁচি, আপনার নামেই আমরা মরি; আর আপনার কাছেই পুনরুত্থান।',
      reference: 'তিরমিজি ৩৩৯১',
      color: Color(0xFFFFF0DB),
      accent: Color(0xFFE8913A),
    ),
    _DuaEntry(
      id: 'morning_sabah',
      title: 'সকালের শুকরিয়া',
      category: 'সকাল ও সন্ধ্যা',
      arabic:
          'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ',
      meaning:
          'আমরা সকালে পৌঁছলাম এবং সকল রাজত্ব আল্লাহরই; সকল প্রশংসা আল্লাহর।',
      reference: 'মুসলিম ২৭২৩',
      color: Color(0xFFFFF6D0),
      accent: Color(0xFFD4A017),
    ),
    _DuaEntry(
      id: 'food',
      title: 'খাবার শুরু করার আগে',
      category: 'দৈনন্দিন',
      arabic: 'بِسْمِ اللَّهِ',
      meaning: 'আল্লাহর নামে শুরু করছি।',
      reference: 'সহিহ বুখারি ৫৩৭৬',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'food_after',
      title: 'খাবার শেষ করার পর',
      category: 'দৈনন্দিন',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
      meaning:
          'সব প্রশংসা আল্লাহর, যিনি আমাদের আহার করিয়েছেন, পান করিয়েছেন এবং মুসলিম বানিয়েছেন।',
      reference: 'আবু দাউদ ৩৮৫০',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'wudu_after',
      title: 'অজু শেষ করার পর',
      category: 'দৈনন্দিন',
      arabic:
          'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      meaning:
          'আমি সাক্ষ্য দিচ্ছি যে আল্লাহ ছাড়া কোনো সত্য ইলাহ নেই, তিনি একক, তাঁর কোনো শরিক নেই; এবং সাক্ষ্য দিচ্ছি মুহাম্মদ তাঁর বান্দা ও রাসুল।',
      reference: 'সহিহ মুসলিম ২৩৪',
      color: Color(0xFFD4F0EC),
      accent: Color(0xFF0D7377),
    ),
    _DuaEntry(
      id: 'clothes',
      title: 'নতুন পোশাক পরিধানের দোয়া',
      category: 'দৈনন্দিন',
      arabic:
          'الْحَمْدُ لِلَّهِ الَّذِي كَسَانِي هَذَا الثَّوْبَ وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
      meaning:
          'সব প্রশংসা আল্লাহর যিনি আমাকে এ পোশাক পরিধান করিয়েছেন এবং আমার কোনো শক্তি ও উপায় ছাড়াই এটি দান করেছেন।',
      reference: 'আবু দাউদ ৪০২৩',
      color: Color(0xFFFFF0DB),
      accent: Color(0xFFE8913A),
    ),
    _DuaEntry(
      id: 'restroom',
      title: 'শৌচাগারে প্রবেশের আগে',
      category: 'দৈনন্দিন',
      arabic:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
      meaning:
          'হে আল্লাহ, আমি আপনার কাছে অপবিত্র জিন ও শয়তান (নর ও নারী) থেকে আশ্রয় চাই।',
      reference: 'সহিহ বুখারি ১৪২',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'restroom_exit',
      title: 'শৌচাগার থেকে বের হলে',
      category: 'দৈনন্দিন',
      arabic: 'غُفْرَانَكَ',
      meaning: 'হে আল্লাহ, আমি আপনার ক্ষমা প্রার্থনা করছি।',
      reference: 'তিরমিজি ৭',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'leave_home',
      title: 'ঘর থেকে বের হওয়ার সময়',
      category: 'দৈনন্দিন',
      arabic:
          'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      meaning:
          'আল্লাহর নামে; আল্লাহর ওপরই ভরসা করলাম। আল্লাহর সাহায্য ছাড়া কোনো উপায় ও শক্তি নেই।',
      reference: 'আবু দাউদ ৫০৯৫',
      color: Color(0xFFFFF0DB),
      accent: Color(0xFFE8913A),
    ),
    _DuaEntry(
      id: 'enter_home',
      title: 'ঘরে প্রবেশের সময়',
      category: 'দৈনন্দিন',
      arabic:
          'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا',
      meaning:
          'আল্লাহর নামে প্রবেশ করলাম এবং আল্লাহর নামেই বের হলাম, আর আমাদের রব আল্লাহর ওপরই ভরসা করলাম।',
      reference: 'আবু দাউদ ৫০৯৬',
      color: Color(0xFFFFF0DB),
      accent: Color(0xFFE8913A),
    ),
    _DuaEntry(
      id: 'mosque_enter',
      title: 'মসজিদে প্রবেশের সময়',
      category: 'দৈনন্দিন',
      arabic:
          'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      meaning: 'হে আল্লাহ, আমার জন্য আপনার রহমতের দরজাগুলো খুলে দিন।',
      reference: 'মুসলিম ৭১৩',
      color: Color(0xFFD4F0EC),
      accent: Color(0xFF0D7377),
    ),
    _DuaEntry(
      id: 'mosque_exit',
      title: 'মসজিদ থেকে বের হওয়ার সময়',
      category: 'দৈনন্দিন',
      arabic:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      meaning: 'হে আল্লাহ, আমি আপনার অনুগ্রহ ও দান প্রার্থনা করছি।',
      reference: 'মুসলিম ৭১৩',
      color: Color(0xFFD4F0EC),
      accent: Color(0xFF0D7377),
    ),
    _DuaEntry(
      id: 'sleep',
      title: 'ঘুমাতে যাওয়ার সময়',
      category: 'ঘুম',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      meaning: 'হে আল্লাহ, আপনার নামেই আমি মৃত্যুবরণ করি এবং জীবিত হই।',
      reference: 'সহিহ বুখারি ৬৩২৪',
      color: Color(0xFFF3E8FF),
      accent: Color(0xFF9B6BC9),
    ),
    _DuaEntry(
      id: 'sleep_ayatul_kursi',
      title: 'ঘুমের আগে আয়াতুল কুরসি',
      category: 'ঘুম',
      arabic:
          'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ',
      meaning:
          'আল্লাহ—তিনি ছাড়া কোনো সত্য ইলাহ নেই; তিনি চিরজীবন্ত, সবকিছুর ধারক। তন্দ্রা বা ঘুম তাঁকে স্পর্শ করে না।',
      reference: 'সহিহ বুখারি ২৩১১',
      color: Color(0xFFF3E8FF),
      accent: Color(0xFF9B6BC9),
    ),
    _DuaEntry(
      id: 'nightmare',
      title: 'দুঃস্বপ্ন বা ঘুমের ভয়ে',
      category: 'ঘুম',
      arabic:
          'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ غَضَبِهِ وَعِقَابِهِ وَشَرِّ عِبَادِهِ',
      meaning:
          'আমি আল্লাহর পরিপূর্ণ বাণীসমূহের মাধ্যমে তাঁর ক্রোধ, শাস্তি এবং তাঁর বান্দাদের অনিষ্ট থেকে আশ্রয় চাই।',
      reference: 'আবু দাউদ ৩৮৯৩',
      color: Color(0xFFF3E8FF),
      accent: Color(0xFF9B6BC9),
    ),
    _DuaEntry(
      id: 'travel',
      title: 'সফরে বের হওয়ার সময়',
      category: 'সফর',
      arabic:
          'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
      meaning:
          'পবিত্র তিনি যিনি এটি আমাদের বশীভূত করে দিয়েছেন; আমরা এটি নিয়ন্ত্রণ করতে সক্ষম ছিলাম না। আর আমরা আমাদের রবের কাছেই ফিরে যাব।',
      reference: 'আবু দাউদ ২৬০২',
      color: Color(0xFFDCEBFF),
      accent: Color(0xFF3B82C4),
    ),
    _DuaEntry(
      id: 'travel_return',
      title: 'সফর থেকে ফেরার পর',
      category: 'সফর',
      arabic:
          'آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ',
      meaning:
          'আমরা ফিরে এসেছি, তাওবা করছি, ইবাদত করছি এবং আমাদের রবের প্রশংসা করছি।',
      reference: 'সহিহ বুখারি ৩০৮৫',
      color: Color(0xFFDCEBFF),
      accent: Color(0xFF3B82C4),
    ),
    _DuaEntry(
      id: 'rain',
      title: 'বৃষ্টি বর্ষণের সময়',
      category: 'দৈনন্দিন',
      arabic: 'اللَّهُمَّ صَيِّبًا نَافِعًا',
      meaning: 'হে আল্লাহ, এটিকে উপকারী ও কল্যাণময় বৃষ্টিপাত করুন।',
      reference: 'সহিহ বুখারি ১০৩২',
      color: Color(0xFFDCEBFF),
      accent: Color(0xFF3B82C4),
    ),
    _DuaEntry(
      id: 'sneeze',
      title: 'হাঁচি দিলে',
      category: 'দৈনন্দিন',
      arabic: 'الْحَمْدُ لِلَّهِ',
      meaning: 'আলহামদুলিল্লাহ—সকল প্রশংসা মহান আল্লাহর জন্য।',
      reference: 'সহিহ বুখারি ৬২২৪',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'sneeze_response',
      title: 'হাঁচির জবাব দেওয়া',
      category: 'দৈনন্দিন',
      arabic: 'يَرْحَمُكَ اللَّهُ',
      meaning: 'আল্লাহ তোমার ওপর রহম ও অনুগ্রহ বর্ষণ করুন।',
      reference: 'সহিহ বুখারি ৬২২৪',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'anxiety',
      title: 'দুশ্চিন্তায় পড়লে',
      category: 'বিশেষ',
      arabic:
          'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
      meaning:
          'আল্লাহই আমার জন্য যথেষ্ট; তিনি ছাড়া কোনো সত্য ইলাহ নেই; আমি তাঁর ওপর ভরসা করলাম, তিনি মহান আরশের অধিপতি।',
      reference: 'আবু দাউদ ৫০৮১',
      color: Color(0xFFFFEBCF),
      accent: Color(0xFFE8913A),
    ),
    _DuaEntry(
      id: 'forgiveness',
      title: 'ক্ষমা চাওয়ার দোয়া (সায়্যিদুল ইস্তিগফার)',
      category: 'বিশেষ',
      arabic:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ',
      meaning:
          'হে আল্লাহ, আপনিই আমার রব; আপনি ছাড়া কোনো ইলাহ নেই; আপনি আমাকে সৃষ্টি করেছেন এবং আমি আপনার বান্দা। আমি সাধ্যমতো আপনার অঙ্গীকার ও প্রতিশ্রুতির ওপর আছি।',
      reference: 'সহিহ বুখারি ৬৩০৬',
      color: Color(0xFFD4F0EC),
      accent: Color(0xFF0D7377),
    ),
    _DuaEntry(
      id: 'parents',
      title: 'পিতা-মাতার জন্য দোয়া',
      category: 'বিশেষ',
      arabic:
          'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
      meaning:
          'হে আমার রব, তাঁদের প্রতি রহম করুন, যেমন তাঁরা শৈশবে আমাকে স্নেহ-মমতায় লালন-পালন করেছেন।',
      reference: 'সুরা আল-ইসরা ১৭:২৪',
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
          ..showSnackBar(const SnackBar(
            content: LocalizedText('এই ডিভাইসে আরবি অডিও পাওয়া যায়নি।'),
            behavior: SnackBarBehavior.floating,
          ));
      }
    }
  }

  @override
  void dispose() {
    _playerCompleteSub?.cancel();
    _audioPlayer?.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final selectedCategory = _categories[_selectedCategory];
    final filtered = _duas
        .where((dua) =>
            selectedCategory == 'সব' ||
            (selectedCategory == 'পছন্দের'
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
                        title: 'মাসনুন দোয়া',
                        subtitle: 'ছোট ছোট দোয়া, প্রতিদিন',
                        iconType: VectorIconType.dua,
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
                          const Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LocalizedText('আজকের ছোট্ট অভ্যাস',
                                      style: TextStyle(
                                          color: AppTheme.darkText,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13)),
                                  SizedBox(height: 2),
                                  LocalizedText(
                                      'একটি দোয়া শেখো, অর্থটাও জেনে নাও।',
                                      style: TextStyle(
                                          color: Color(0xFF6B5B7A),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                ]),
                          ),
                        ]),
                      ),

                      // ── Category pills ──
                      DuolingoCategoryBar(
                        categories: _categories,
                        selected: _selectedCategory,
                        onSelect: (i) => setState(() => _selectedCategory = i),
                        activeColor: const Color(0xFF9B6BC9),
                      ),
                      const SizedBox(height: 16),

                      // ── Dua cards ──
                      if (filtered.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 36),
                          child: Center(
                              child: LocalizedText(
                                  'এখনো কোনো পছন্দের দোয়া নেই।')),
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
                                content: LocalizedText(wasFavorite
                                    ? 'পছন্দ থেকে সরানো হয়েছে।'
                                    : 'পছন্দে রাখা হয়েছে।'),
                                behavior: SnackBarBehavior.floating,
                              ));
                          },
                          onCopy: () => _copyDua(context, dua.arabic),
                        ),

                      const SizedBox(height: 12),
                      LocalizedText(
                        'আরবি পাঠ ও হাদিস নম্বর Sunnah.com-এ উল্লেখিত রেফারেন্সের সঙ্গে মিলিয়ে দেওয়া হয়েছে।',
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
      ..showSnackBar(const SnackBar(
          content: LocalizedText('দোয়াটি কপি হয়েছে।'),
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
                      LocalizedText(dua.title,
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontWeight: FontWeight.w800,
                              fontSize: 14)),
                      LocalizedText(dua.category,
                          style: TextStyle(
                              color: AppTheme.darkText.withValues(alpha: 0.45),
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ]),
              ),
              IconButton(
                onPressed: widget.onFavorite,
                tooltip: context.uiText(
                    widget.isFavorite ? 'পছন্দ থেকে সরাও' : 'পছন্দে রাখো'),
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
              child: LocalizedText(
                dua.arabic,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppTheme.arabicFontFamily,
                    color: dua.accent,
                    fontSize: 22,
                    height: 1.75,
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
                    firstChild: LocalizedText(
                      dua.meaning,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppTheme.darkText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                    secondChild: LocalizedText(
                      dua.meaning,
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
                child: LocalizedText(dua.reference,
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
                      LocalizedText(
                        widget.isPlaying ? 'থামাই' : 'উচ্চারণ শুনি',
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
                  tooltip: context.uiText('দোয়াটি অনুশীলন করি'),
                  icon: Icon(Icons.touch_app_rounded,
                      color: dua.accent, size: 20)),
              const SizedBox(width: 4),
              IconButton(
                  onPressed: widget.onCopy,
                  tooltip: context.uiText('কপি করো'),
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
                    child: LocalizedText(
                      dua.category,
                      style: TextStyle(
                          color: dua.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: widget.onFavorite,
                    tooltip: context.uiText(widget.isFavorite
                        ? 'পছন্দ থেকে সরাও'
                        : 'পছন্দে রাখো'),
                    icon: Icon(
                      widget.isFavorite
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: widget.isFavorite ? dua.accent : Colors.black45,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onCopy,
                    tooltip: context.uiText('কপি করো'),
                    icon: const Icon(Icons.copy_rounded, color: Colors.black45),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LocalizedText(
                dua.title,
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
                child: LocalizedText(
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
                label: LocalizedText(
                  widget.isPlaying ? 'উচ্চারণ থামাই' : 'বিশুদ্ধ উচ্চারণ শুনি',
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
                    const LocalizedText(
                      'অর্থ:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LocalizedText(
                      dua.meaning,
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
                      child: LocalizedText(
                        'সূত্র: ${dua.reference}',
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
                        const LocalizedText(
                          'দোয়া অনুশীলনের লক্ষ্য',
                          style: TextStyle(
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
                                    child: LocalizedText(
                                      '$t',
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
                            LocalizedText(
                              isDone
                                  ? 'মাশাআল্লাহ! লক্ষ্য পূর্ণ হয়েছে ($_target/$_target)'
                                  : 'পড়েছি: $_counter / $_target বার',
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
                        label: const LocalizedText('কাউন্টার রিসেট করি'),
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
