import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/duolingo_appbar.dart';
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
    setState(() { _loading = true; _loadError = null; });
    try {
      final surahs = await _repository.getSurahs();
      if (!mounted) return;
      setState(() { _surahs = surahs; _loading = false; });
    } catch (_) {
      if (!mounted) return;
      setState(() { _loading = false; _loadError = 'সূরার তালিকা আনা যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করো।'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
      backgroundColor: const Color(0xFFEDF7F0),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(isTablet ? 36 : 20, 18, isTablet ? 36 : 20, 26),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ── Duolingo Header ──
                      DuolingoPageHeader(
                        title: 'কুরআনের সাথে সময় কাটাই',
                        subtitle: 'শান্ত মনে পড়ো, ভাবো, আর সুন্দর গল্প শোনো।',
                        iconType: VectorIconType.book,
                        gradientColors: const [Color(0xFF0D7377), Color(0xFF178D72)],
                        onBack: () => Navigator.pop(context),
                      ),

                      // ── Continue reading banner ──
                      _ContinueReadingCard(
                        onTap: () => _openReader(context, _surahs.isEmpty ? null : _surahs.first),
                      ),
                      const SizedBox(height: 20),

                      // ── Section toggle ──
                      _SectionPicker(selected: _section, onSelect: (v) => setState(() => _section = v)),
                      const SizedBox(height: 16),

                      if (_section == 0) ...[
                        DuolingoSectionLabel(label: 'সব ১১৪টি সূরা', badgeText: '${_surahs.length}টি', badgeColor: const Color(0xFFD4F0EC), badgeTextColor: const Color(0xFF0D7377)),
                        const SizedBox(height: 12),
                        // Search box
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                          ),
                          child: TextField(
                            onChanged: (v) => setState(() => _search = v.trim().toLowerCase()),
                            decoration: InputDecoration(
                              hintText: 'সূরা খুঁজে দেখো',
                              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9CA3AF)),
                              filled: false,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_loading)
                          const Padding(
                            padding: EdgeInsets.all(28),
                            child: Center(child: CircularProgressIndicator(color: Color(0xFF0D7377))),
                          )
                        else if (_loadError != null)
                          _LoadError(message: _loadError!, onRetry: _loadSurahs)
                        else
                          for (final surah in _surahs.where((item) =>
                              _search.isEmpty ||
                              item.englishName.toLowerCase().contains(_search) ||
                              item.nameMeaning.toLowerCase().contains(_search) ||
                              item.arabicName.contains(_search)))
                            _SurahCard(
                              number: '${surah.number}',
                              arabicName: surah.arabicName,
                              title: surah.englishName,
                              detail: '${surah.ayahCount} আয়াত · ${surah.revelationType == 'Meccan' ? 'মক্কী' : 'মাদানী'} · ${surah.nameMeaning}',
                              onTap: () => _openReader(context, surah),
                            ),
                      ] else ...[
                        DuolingoSectionLabel(label: 'ছোট্ট ইসলামিক গল্প'),
                        const SizedBox(height: 12),
                        _StoryCard(iconType: VectorIconType.plant, title: 'দয়ার সুন্দর গল্প', subtitle: 'ভালো আচরণ আর মমতা', color: const Color(0xFFE8F5E9), accent: const Color(0xFF58A700), onTap: () => _showComingSoon(context)),
                        _StoryCard(iconType: VectorIconType.star, title: 'সাহস ও ধৈর্যের গল্প', subtitle: 'ছোটদের জন্য ছোট্ট শিক্ষা', color: const Color(0xFFFFF2D1), accent: const Color(0xFFD4A017), onTap: () => _showComingSoon(context)),
                        _StoryCard(iconType: VectorIconType.bird, title: 'সত্য বলার গল্প', subtitle: 'সুন্দর চরিত্রের অনুশীলন', color: const Color(0xFFE8F1FA), accent: const Color(0xFF3B82C4), onTap: () => _showComingSoon(context)),
                      ],

                      const SizedBox(height: 14),
                      const Text(
                        'রঙিন তাজবিদ পাঠ: Quran.com · বাংলা অনুবাদ: মুহিউদ্দীন খান, Al Quran Cloud',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black38, fontSize: 10),
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

  void _openReader(BuildContext context, QuranSurah? surah) {
    if (surah == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('সূরার তালিকা লোড হলে পড়া শুরু হবে।')));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => QuranReaderScreen(surah: surah, repository: _repository)));
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('এই অংশটি পরের ধাপে যোগ হবে।'), behavior: SnackBarBehavior.floating));
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          const Icon(Icons.wifi_off_rounded, color: AppTheme.accentCoral, size: 30),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('আবার চেষ্টা করি')),
        ]),
      );
}

class _ContinueReadingCard extends StatefulWidget {
  const _ContinueReadingCard({required this.onTap});
  final VoidCallback onTap;
  @override
  State<_ContinueReadingCard> createState() => _ContinueReadingCardState();
}

class _ContinueReadingCardState extends State<_ContinueReadingCard> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          transform: Matrix4.translationValues(0, _pressed ? 4 : 0, 0),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF0D7377), Color(0xFF178D72)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: const Color(0xFF0D7377).withValues(alpha: _pressed ? 0.1 : 0.3), blurRadius: 0, offset: Offset(0, _pressed ? 0 : 5))],
          ),
          child: Row(children: [
            Container(
              width: 58, height: 58,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .16), borderRadius: BorderRadius.circular(19)),
              alignment: Alignment.center,
              child: const Text('۩', style: TextStyle(color: Color(0xFFFFD776), fontSize: 32)),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('পড়া চালিয়ে যাও', style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 3),
                Text('সূরা আল-ফাতিহা', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                SizedBox(height: 3),
                Text('তিলাওয়াতের জন্য প্রস্তুত', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ]),
            ),
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
            ),
          ]),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE5E7EB), width: 2)),
        child: Row(children: [
          _Tab(label: 'সূরা', selected: selected == 0, onTap: () => onSelect(0)),
          _Tab(label: 'গল্প', selected: selected == 1, onTap: () => onSelect(1)),
        ]),
      );
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF0D7377) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: selected ? Colors.white : Colors.black54, fontWeight: FontWeight.w800)),
          ),
        ),
      );
}

class _SurahCard extends StatefulWidget {
  const _SurahCard({required this.number, required this.arabicName, required this.title, required this.detail, required this.onTap});
  final String number, arabicName, title, detail;
  final VoidCallback onTap;
  @override
  State<_SurahCard> createState() => _SurahCardState();
}

class _SurahCardState extends State<_SurahCard> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          margin: const EdgeInsets.only(bottom: 10),
          transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
            boxShadow: [BoxShadow(color: const Color(0xFF0D7377).withValues(alpha: _pressed ? 0.04 : 0.1), blurRadius: 0, offset: Offset(0, _pressed ? 0 : 3))],
          ),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: const Color(0xFFD4F0EC), borderRadius: BorderRadius.circular(13)),
              alignment: Alignment.center,
              child: Text(widget.number, style: const TextStyle(color: Color(0xFF0D7377), fontSize: 11, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.title, style: const TextStyle(color: AppTheme.darkText, fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 3),
                Text(widget.detail, style: const TextStyle(color: Colors.black54, fontSize: 11)),
              ]),
            ),
            Text(widget.arabicName, textDirection: TextDirection.rtl, style: const TextStyle(color: Color(0xFF0D7377), fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            Container(
              width: 28, height: 28,
              decoration: const BoxDecoration(color: Color(0xFFD4F0EC), shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow_rounded, color: Color(0xFF0D7377), size: 16),
            ),
          ]),
        ),
      );
}

class _StoryCard extends StatefulWidget {
  const _StoryCard({required this.iconType, required this.title, required this.subtitle, required this.color, required this.accent, required this.onTap});
  final VectorIconType iconType;
  final String title, subtitle;
  final Color color, accent;
  final VoidCallback onTap;
  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          margin: const EdgeInsets.only(bottom: 10),
          transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.accent.withValues(alpha: 0.25), width: 2),
            boxShadow: [BoxShadow(color: widget.accent.withValues(alpha: _pressed ? 0.04 : 0.12), blurRadius: 0, offset: Offset(0, _pressed ? 0 : 3))],
          ),
          child: Row(children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(16)),
              alignment: Alignment.center,
              child: VectorIcon(type: widget.iconType, size: 28, color: widget.accent),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.title, style: const TextStyle(color: AppTheme.darkText, fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(widget.subtitle, style: const TextStyle(color: Colors.black54, fontSize: 11)),
            ])),
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
              child: Icon(Icons.chevron_right_rounded, color: widget.accent, size: 20),
            ),
          ]),
        ),
      );
}
