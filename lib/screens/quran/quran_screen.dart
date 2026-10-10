import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'quran_data.dart';
import 'quran_reader_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key, this.repository});

  final QuranRepository? repository;

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  int _section = 0;
  late final QuranRepository _repository =
      widget.repository ?? AlQuranCloudRepository();
  List<QuranSurah> _surahs = const [];
  bool _loading = true;
  String? _loadError;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final surahs = await _repository.getSurahs();
      if (!mounted) return;
      setState(() {
        _surahs = surahs;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'সূরার তালিকা আনা যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করো।';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      isTablet ? 36 : 20, 18, isTablet ? 36 : 20, 26),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _TopBar(onBack: () => Navigator.pop(context)),
                      const SizedBox(height: 22),
                      const Text('কুরআনের সাথে সময় কাটাই',
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 24,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 5),
                      const Text('শান্ত মনে পড়ো, ভাবো, আর সুন্দর গল্প শোনো।',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 14)),
                      const SizedBox(height: 20),
                      _ContinueReading(
                          onTap: () => _openReader(
                              context, _surahs.isEmpty ? null : _surahs.first)),
                      const SizedBox(height: 22),
                      _SectionPicker(
                          selected: _section,
                          onSelect: (value) =>
                              setState(() => _section = value)),
                      const SizedBox(height: 15),
                      if (_section == 0) ...[
                        const Text('সব ১১৪টি সূরা',
                            style: TextStyle(
                                color: AppTheme.darkText,
                                fontWeight: FontWeight.w800,
                                fontSize: 17)),
                        const SizedBox(height: 10),
                        TextField(
                          onChanged: (value) => setState(
                              () => _search = value.trim().toLowerCase()),
                          decoration: InputDecoration(
                            hintText: 'সূরা খুঁজে দেখো',
                            prefixIcon: const Icon(Icons.search_rounded),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_loading)
                          const Padding(
                            padding: EdgeInsets.all(28),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_loadError != null)
                          _LoadSurahsError(
                              message: _loadError!, onRetry: _loadSurahs)
                        else
                          for (final surah in _surahs.where((item) =>
                              _search.isEmpty ||
                              item.englishName
                                  .toLowerCase()
                                  .contains(_search) ||
                              item.nameMeaning
                                  .toLowerCase()
                                  .contains(_search) ||
                              item.arabicName.contains(_search)))
                            _SurahCard(
                              number: '${surah.number}',
                              arabicName: surah.arabicName,
                              title: surah.englishName,
                              detail:
                                  '${surah.ayahCount} আয়াত · ${surah.revelationType == 'Meccan' ? 'মক্কী' : 'মাদানী'} · ${surah.nameMeaning}',
                              isAvailable: true,
                              onTap: () => _openReader(context, surah),
                            ),
                      ] else ...[
                        const Text('ছোট্ট ইসলামিক গল্প',
                            style: TextStyle(
                                color: AppTheme.darkText,
                                fontWeight: FontWeight.w800,
                                fontSize: 17)),
                        const SizedBox(height: 10),
                        _StoryCard(
                            emoji: '🌱',
                            title: 'দয়ার সুন্দর গল্প',
                            subtitle: 'ভালো আচরণ আর মমতা',
                            color: const Color(0xFFE8F5E9),
                            onTap: () => _showComingSoon(context)),
                        _StoryCard(
                            emoji: '⭐',
                            title: 'সাহস ও ধৈর্যের গল্প',
                            subtitle: 'ছোটদের জন্য ছোট্ট শিক্ষা',
                            color: const Color(0xFFFFF2D1),
                            onTap: () => _showComingSoon(context)),
                        _StoryCard(
                            emoji: '🕊️',
                            title: 'সত্য বলার গল্প',
                            subtitle: 'সুন্দর চরিত্রের অনুশীলন',
                            color: const Color(0xFFE8F1FA),
                            onTap: () => _showComingSoon(context)),
                      ],
                      const SizedBox(height: 14),
                      const _SourceNote(),
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

  void _openReader(BuildContext context, QuranSurah? surah) {
    if (surah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('সূরার তালিকা লোড হলে পড়া শুরু হবে।')));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => QuranReaderScreen(
              surah: surah,
              repository: _repository,
            )));
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
          content: Text('এই অংশটি পরের ধাপে যোগ হবে।'),
          behavior: SnackBarBehavior.floating));
  }
}

class _LoadSurahsError extends StatelessWidget {
  const _LoadSurahsError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Column(children: [
          const Icon(Icons.wifi_off_rounded,
              color: AppTheme.accentCoral, size: 30),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('আবার চেষ্টা করি')),
        ]),
      );
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => Row(children: [
        IconButton.filledTonal(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(backgroundColor: Colors.white)),
        const SizedBox(width: 8),
        const Text('কুরআন পড়ি',
            style: TextStyle(
                color: AppTheme.darkText,
                fontSize: 17,
                fontWeight: FontWeight.w800)),
      ]);
}

class _ContinueReading extends StatelessWidget {
  const _ContinueReading({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                    colors: [Color(0xFF0D7377), Color(0xFF178D72)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
            child: Row(children: [
              Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .16),
                      borderRadius: BorderRadius.circular(19)),
                  alignment: Alignment.center,
                  child: const Text('۞',
                      style:
                          TextStyle(color: Color(0xFFFFD776), fontSize: 39))),
              const SizedBox(width: 14),
              const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('পড়া চালিয়ে যাও',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                    SizedBox(height: 3),
                    Text('সূরা আল-ফাতিহা',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 3),
                    Text('তিলাওয়াতের জন্য প্রস্তুত',
                        style: TextStyle(color: Colors.white70, fontSize: 11))
                  ])),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ]),
          ),
        ),
      );
}

class _SectionPicker extends StatelessWidget {
  const _SectionPicker({required this.selected, required this.onSelect});
  final int selected;
  final ValueChanged<int> onSelect;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: const Color(0xFFECE9DE),
            borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          _PickerButton(
              label: 'সূরা', selected: selected == 0, onTap: () => onSelect(0)),
          _PickerButton(
              label: 'গল্প', selected: selected == 1, onTap: () => onSelect(1)),
        ]),
      );
}

class _PickerButton extends StatelessWidget {
  const _PickerButton(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Expanded(
      child: Material(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Text(label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              selected ? AppTheme.primaryGreen : Colors.black54,
                          fontWeight: FontWeight.w800))))));
}

class _SurahCard extends StatelessWidget {
  const _SurahCard(
      {required this.number,
      required this.arabicName,
      required this.title,
      required this.detail,
      required this.onTap,
      this.isAvailable = false});
  final String number, arabicName, title, detail;
  final VoidCallback onTap;
  final bool isAvailable;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                child: Row(children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color(0xFFEAF4EA),
                          borderRadius: BorderRadius.circular(13)),
                      alignment: Alignment.center,
                      child: Text(number,
                          style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w800))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(title,
                            style: const TextStyle(
                                color: AppTheme.darkText,
                                fontWeight: FontWeight.w800,
                                fontSize: 14)),
                        const SizedBox(height: 3),
                        Text(detail,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 11))
                      ])),
                  Text(arabicName,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  Icon(
                      isAvailable
                          ? Icons.play_circle_fill_rounded
                          : Icons.lock_outline_rounded,
                      color:
                          isAvailable ? AppTheme.secondaryGold : Colors.black26,
                      size: 21),
                ])),
          ),
        ),
      );
}

class _StoryCard extends StatelessWidget {
  const _StoryCard(
      {required this.emoji,
      required this.title,
      required this.subtitle,
      required this.color,
      required this.onTap});
  final String emoji, title, subtitle;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(15)),
                        alignment: Alignment.center,
                        child:
                            Text(emoji, style: const TextStyle(fontSize: 23))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(title,
                              style: const TextStyle(
                                  color: AppTheme.darkText,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 3),
                          Text(subtitle,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 11))
                        ])),
                    const Icon(Icons.chevron_right_rounded,
                        color: Colors.black38)
                  ])))));
}

class _SourceNote extends StatelessWidget {
  const _SourceNote();
  @override
  Widget build(BuildContext context) => const Text(
      'রঙিন তাজবিদ পাঠ: Quran.com · বাংলা অনুবাদ: মুহিউদ্দীন খান, Al Quran Cloud',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black38, fontSize: 10));
}
