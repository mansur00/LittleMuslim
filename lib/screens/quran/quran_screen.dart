import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/duolingo_appbar.dart';
import 'quran_data.dart';
import 'quran_reader_screen.dart';
import '../seerah/seerah_screen.dart';

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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final surahs = await _repository.getSurahs();
      if (!mounted) return;
      await context.read<AppState>().validateQuranProgress({
        for (final surah in surahs) surah.number: surah.ayahCount,
      });
      if (!mounted) return;
      setState(() {
        _surahs = surahs;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'সূরার তালিকা আনা যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করো।';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = context.select<AppState, (int, int)?>((state) {
      final savedPosition = state.quranReadingPosition;
      return savedPosition == null
          ? null
          : (savedPosition.surahNumber, savedPosition.ayahNumber);
    });
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final savedSurah = _findSurah(position?.$1);
    final continueSurah =
        savedSurah ?? (_surahs.isEmpty ? null : _surahs.first);
    return Scaffold(
      backgroundColor: const Color(0xFFEDF7F0),
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
                      // ── Duolingo Header ──
                      DuolingoPageHeader(
                        title: 'কুরআনের সাথে সময় কাটাই',
                        subtitle: 'শান্ত মনে পড়ো, ভাবো, আর সুন্দর গল্প শোনো।',
                        customIcon: Image.asset(
                          'assets/images/quran_3d_open.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                        gradientColors: const [
                          Color(0xFF58CC02),
                          Color(0xFF46A302)
                        ],
                        onBack: () => Navigator.pop(context),
                      ),

                      // ── Continue reading banner ──
                      _ContinueReadingCard(
                        surahLabel: continueSurah == null
                            ? 'সূরা লোড হলে আবার চেষ্টা করো'
                            : 'সূরা ${continueSurah.englishName}',
                        ayahNumber: position?.$2,
                        canResume: continueSurah != null,
                        onTap: () => _openReader(
                          context,
                          continueSurah,
                          initialAyah: position?.$2 ?? 1,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Section toggle ──
                      _SectionPicker(
                          selected: _section,
                          onSelect: (v) => setState(() => _section = v)),
                      const SizedBox(height: 16),

                      if (_section == 0) ...[
                        DuolingoSectionLabel(
                            label: 'সব ১১৪টি সূরা',
                            badgeText: '${_surahs.length}টি',
                            badgeColor: const Color(0xFFE8F8D8),
                            badgeTextColor: AppTheme.primaryDark),
                        const SizedBox(height: 12),
                        // Search box
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: const Color(0xFFE5E7EB), width: 2),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(
                                () => _search = v.trim().toLowerCase()),
                            decoration: InputDecoration(
                              hintText: context.uiText('সূরা খুঁজে দেখো'),
                              hintStyle:
                                  const TextStyle(color: Color(0xFF9CA3AF)),
                              prefixIcon: const Icon(Icons.search_rounded,
                                  color: Color(0xFF9CA3AF)),
                              suffixIcon: _search.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded,
                                          color: Color(0xFF9CA3AF)),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _search = '');
                                      },
                                    )
                                  : null,
                              filled: false,
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_loading)
                          const Padding(
                            padding: EdgeInsets.all(28),
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: AppTheme.primaryGreen)),
                          )
                        else if (_loadError != null)
                          _LoadError(message: _loadError!, onRetry: _loadSurahs)
                        else if (_surahs.isEmpty)
                          _EmptySurahs(onRetry: _loadSurahs)
                        else ...[
                          () {
                            final filtered = _surahs
                                .where((item) =>
                                    _search.isEmpty ||
                                    item.englishName
                                        .toLowerCase()
                                        .contains(_search) ||
                                    item.nameMeaning
                                        .toLowerCase()
                                        .contains(_search) ||
                                    item.arabicName.contains(_search))
                                .toList();
                            if (filtered.isEmpty && _search.isNotEmpty) {
                              return _SearchEmptySurahs(
                                query: _search,
                                onClear: () {
                                  _searchController.clear();
                                  setState(() => _search = '');
                                },
                              );
                            }
                            return Column(
                              children: [
                                for (final surah in filtered)
                                  _SurahCard(
                                    number: '${surah.number}',
                                    arabicName: surah.arabicName,
                                    title: surah.englishName,
                                    detail:
                                        '${surah.ayahCount} আয়াত · ${surah.revelationType == 'Meccan' ? 'মক্কী' : 'মাদানী'} · ${surah.nameMeaning}',
                                    onTap: () => _openReader(context, surah),
                                  ),
                              ],
                            );
                          }(),
                        ],
                      ] else if (_section == 1) ...[
                        DuolingoSectionLabel(
                            label: '৩০টি পারা / জুয',
                            badgeText: '${quranJuzList.length} পারা',
                            badgeColor: const Color(0xFFE8F8D8),
                            badgeTextColor: AppTheme.primaryDark),
                        const SizedBox(height: 12),
                        for (final juz in quranJuzList)
                          _JuzCard(
                            juz: juz,
                            onTap: () {
                              final surah = _findSurah(juz.startSurahNumber);
                              _openReader(context, surah,
                                  initialAyah: juz.startAyahNumber);
                            },
                          ),
                      ] else if (_section == 2) ...[
                        () {
                          final bookmarks =
                              context.watch<AppState>().quranBookmarks;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DuolingoSectionLabel(
                                  label: 'সংরক্ষিত আয়াত',
                                  badgeText: '${bookmarks.length}টি',
                                  badgeColor: const Color(0xFFE8F8D8),
                                  badgeTextColor: AppTheme.primaryDark),
                              const SizedBox(height: 12),
                              if (bookmarks.isEmpty)
                                const _BookmarksEmptyCard()
                              else
                                for (final key in bookmarks)
                                  _buildBookmarkTile(context, key),
                            ],
                          );
                        }(),
                      ] else ...[
                        const DuolingoSectionLabel(label: 'ছোট্ট ইসলামিক গল্প'),
                        const SizedBox(height: 12),
                        _StoryCard(
                            iconType: VectorIconType.plant,
                            title: 'দয়ার সুন্দর গল্প',
                            subtitle: 'ভালো আচরণ আর মমতা',
                            color: const Color(0xFFE8F5E9),
                            accent: const Color(0xFF58A700),
                            onTap: () => _openStoryInfo(
                                context, 'দয়ার সুন্দর গল্প', 'ভালো আচরণ আর মমতা')),
                        _StoryCard(
                            iconType: VectorIconType.star,
                            title: 'সাহস ও ধৈর্যের গল্প',
                            subtitle: 'ছোটদের জন্য ছোট্ট শিক্ষা',
                            color: const Color(0xFFFFF2D1),
                            accent: const Color(0xFFD4A017),
                            onTap: () => _openStoryInfo(context,
                                'সাহস ও ধৈর্যের গল্প', 'ছোটদের জন্য ছোট্ট শিক্ষা')),
                        _StoryCard(
                            iconType: VectorIconType.bird,
                            title: 'সত্য বলার গল্প',
                            subtitle: 'সুন্দর চরিত্রের অনুশীলন',
                            color: const Color(0xFFE8F1FA),
                            accent: const Color(0xFF3B82C4),
                            onTap: () => _openStoryInfo(context,
                                'সত্য বলার গল্প', 'সুন্দর চরিত্রের অনুশীলন')),
                      ],

                      const SizedBox(height: 14),
                      const LocalizedText(
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

  QuranSurah? _findSurah(int? number) {
    if (number == null) return null;
    for (final surah in _surahs) {
      if (surah.number == number) return surah;
    }
    return null;
  }

  void _openReader(BuildContext context, QuranSurah? surah,
      {int initialAyah = 1}) {
    if (surah == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: LocalizedText('সূরার তালিকা লোড হলে পড়া শুরু হবে।')));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => QuranReaderScreen(
            surah: surah, repository: _repository, initialAyah: initialAyah)));
  }

  void _openStoryInfo(
      BuildContext context, String title, String subtitle) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(children: [
          const VectorIcon(
              type: VectorIconType.book, size: 24, color: AppTheme.primaryGreen),
          const SizedBox(width: 10),
          Expanded(child: LocalizedText(title)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocalizedText(subtitle,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: AppTheme.primaryGreen)),
            const SizedBox(height: 12),
            const LocalizedText(
              'কুরআনিক শিক্ষণীয় ঘটনাভিত্তিক বিশেষ শিশুতোষ মডিউলটি নির্ভরযোগ্য তাফসির সূত্রের আলোকে সংকলন করা হচ্ছে।\n\nবর্তমানে তুমি ‘সীরাত’ মডিউল থেকে রাসুলুল্লাহ ﷺ-এর জীবনের নির্ভরযোগ্য ঐতিহাসিক গল্পগুলো পড়তে পারো।',
              style: TextStyle(height: 1.6, color: AppTheme.darkText),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const LocalizedText('বুঝেছি'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SeerahScreen()),
              );
            },
            icon: const Icon(Icons.auto_stories_rounded, size: 18),
            label: const LocalizedText('সীরাতের গল্পে যাই'),
            style:
                FilledButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkTile(BuildContext context, String key) {
    final parts = key.split(':');
    final surahNum = parts.isNotEmpty ? int.tryParse(parts[0]) : null;
    final ayahNum = parts.length > 1 ? int.tryParse(parts[1]) : null;
    final surah = _findSurah(surahNum);

    if (surah == null ||
        ayahNum == null ||
        ayahNum < 1 ||
        ayahNum > surah.ayahCount) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1B7B7)),
        ),
        child: Row(children: [
          const Icon(Icons.broken_image_rounded,
              color: Colors.redAccent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: LocalizedText('মুছে যাওয়া বা অপ্রাসঙ্গিক রেফারেন্স ($key)',
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
          IconButton(
            onPressed: () {
              if (surahNum != null && ayahNum != null) {
                context
                    .read<AppState>()
                    .toggleQuranBookmark(surahNum, ayahNum);
              }
            },
            icon:
                const Icon(Icons.delete_outline_rounded, color: Colors.black45),
            tooltip: context.uiText('মুছে ফেলো'),
          ),
        ]),
      );
    }

    return _BookmarkCard(
      surah: surah,
      ayahNumber: ayahNum,
      onOpen: () => _openReader(context, surah, initialAyah: ayahNum),
      onRemove: () =>
          context.read<AppState>().toggleQuranBookmark(surah.number, ayahNum),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          const Icon(Icons.wifi_off_rounded,
              color: AppTheme.accentCoral, size: 30),
          const SizedBox(height: 8),
          LocalizedText(message, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          DSButton(
              onPressed: onRetry,
              icon: Icons.refresh_rounded,
              variant: DSButtonVariant.outline,
              label: 'আবার চেষ্টা করি'),
        ]),
      );
}

class _EmptySurahs extends StatelessWidget {
  const _EmptySurahs({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          const LocalizedText('এখন কোনো সূরা পাওয়া যায়নি।'),
          const SizedBox(height: 10),
          DSButton(
              onPressed: onRetry,
              icon: Icons.refresh_rounded,
              variant: DSButtonVariant.outline,
              label: 'আবার চেষ্টা করি'),
        ]),
      );
}

class _ContinueReadingCard extends StatefulWidget {
  const _ContinueReadingCard(
      {required this.surahLabel,
      required this.ayahNumber,
      required this.canResume,
      required this.onTap});
  final String surahLabel;
  final int? ayahNumber;
  final bool canResume;
  final VoidCallback onTap;
  @override
  State<_ContinueReadingCard> createState() => _ContinueReadingCardState();
}

class _ContinueReadingCardState extends State<_ContinueReadingCard> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          transform: Matrix4.translationValues(0, _pressed ? 4 : 0, 0),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF58CC02), Color(0xFF46A302)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF46A302)
                      .withValues(alpha: _pressed ? 0.1 : 0.35),
                  blurRadius: 0,
                  offset: Offset(0, _pressed ? 0 : 5))
            ],
          ),
          child: Row(children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(19)),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/quran_3d_open.png',
                width: 44,
                height: 44,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LocalizedText('পড়া চালিয়ে যাও',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 3),
                    LocalizedText(widget.surahLabel,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    LocalizedText(
                        !widget.canResume
                            ? 'ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করো'
                            : widget.ayahNumber == null
                                ? 'শুরু থেকে পড়ি'
                                : 'আয়াত ${widget.ayahNumber} থেকে পড়ি',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11)),
                  ]),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 20),
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
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 2)),
        child: Row(children: [
          _Tab(
              label: 'সূরা', selected: selected == 0, onTap: () => onSelect(0)),
          _Tab(
              label: 'পারা', selected: selected == 1, onTap: () => onSelect(1)),
          _Tab(
              label: 'বুকমার্ক',
              selected: selected == 2,
              onTap: () => onSelect(2)),
          _Tab(
              label: 'গল্প', selected: selected == 3, onTap: () => onSelect(3)),
        ]),
      );
}

class _Tab extends StatelessWidget {
  const _Tab(
      {required this.label, required this.selected, required this.onTap});
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
              color: selected ? AppTheme.primaryGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: LocalizedText(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: selected ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.w800)),
          ),
        ),
      );
}

class _SurahCard extends StatefulWidget {
  const _SurahCard(
      {required this.number,
      required this.arabicName,
      required this.title,
      required this.detail,
      required this.onTap});
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
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
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
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFFE5E5E5),
                  blurRadius: 0,
                  offset: Offset(0, _pressed ? 0 : 3))
            ],
          ),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: const Color(0xFFE8F8D8),
                  borderRadius: BorderRadius.circular(13)),
              alignment: Alignment.center,
              child: LocalizedText(widget.number,
                  style: const TextStyle(
                      color: AppTheme.primaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(widget.title,
                        style: const TextStyle(
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w800,
                            fontSize: 14)),
                    const SizedBox(height: 3),
                    LocalizedText(widget.detail,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 11)),
                  ]),
            ),
            LocalizedText(widget.arabicName,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                  color: Color(0xFFE8F8D8), shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow_rounded,
                  color: AppTheme.primaryGreen, size: 16),
            ),
          ]),
        ),
      );
}

class _StoryCard extends StatefulWidget {
  const _StoryCard(
      {required this.iconType,
      required this.title,
      required this.subtitle,
      required this.color,
      required this.accent,
      required this.onTap});
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
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          margin: const EdgeInsets.only(bottom: 10),
          transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: widget.accent.withValues(alpha: 0.25), width: 2),
            boxShadow: [
              BoxShadow(
                  color:
                      widget.accent.withValues(alpha: _pressed ? 0.04 : 0.12),
                  blurRadius: 0,
                  offset: Offset(0, _pressed ? 0 : 3))
            ],
          ),
          child: Row(children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: widget.color, borderRadius: BorderRadius.circular(16)),
              alignment: Alignment.center,
              child: VectorIcon(
                  type: widget.iconType, size: 28, color: widget.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  LocalizedText(widget.title,
                      style: const TextStyle(
                          color: AppTheme.darkText,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  LocalizedText(widget.subtitle,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 11)),
                ])),
            Container(
              width: 30,
              height: 30,
              decoration:
                  BoxDecoration(color: widget.color, shape: BoxShape.circle),
              child: Icon(Icons.chevron_right_rounded,
                  color: widget.accent, size: 20),
            ),
          ]),
        ),
      );
}

class _SearchEmptySurahs extends StatelessWidget {
  const _SearchEmptySurahs({required this.query, required this.onClear});
  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          const Icon(Icons.search_off_rounded,
              color: Color(0xFF9CA3AF), size: 36),
          const SizedBox(height: 8),
          LocalizedText('“$query” দিয়ে কোনো সূরা পাওয়া যায়নি।',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          DSButton(
              onPressed: onClear,
              icon: Icons.clear_rounded,
              variant: DSButtonVariant.outline,
              label: 'অনুসন্ধান মুছুন'),
        ]),
      );
}

class _BookmarksEmptyCard extends StatelessWidget {
  const _BookmarksEmptyCard();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: const Column(children: [
          Icon(Icons.bookmark_border_rounded,
              color: AppTheme.primaryGreen, size: 38),
          SizedBox(height: 10),
          LocalizedText('এখনো কোনো বুকমার্ক নেই',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppTheme.darkText)),
          SizedBox(height: 6),
          LocalizedText(
              'কুরআন পড়ার সময় যেকোনো আয়াতের পাশে বুকমার্ক আইকনে চাপ দিলে এখানে সহজে খুঁজে পাবে।',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.5)),
        ]),
      );
}

class _JuzCard extends StatelessWidget {
  const _JuzCard({required this.juz, required this.onTap});
  final QuranJuz juz;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8D8),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: LocalizedText(
              '${juz.number}',
              style: const TextStyle(
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LocalizedText(
                'পারা ${juz.number}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkText,
                ),
              ),
              LocalizedText(
                juz.arabicName,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          subtitle: LocalizedText(
            'শুরু: সূরা ${juz.startSurahName} · আয়াত ${juz.startAyahNumber}',
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: Colors.black38),
        ),
      );
}

class _BookmarkCard extends StatelessWidget {
  const _BookmarkCard({
    required this.surah,
    required this.ayahNumber,
    required this.onOpen,
    required this.onRemove,
  });

  final QuranSurah surah;
  final int ayahNumber;
  final VoidCallback onOpen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0DB),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.bookmark_rounded,
                color: Color(0xFFE8913A), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              LocalizedText('সূরা ${surah.englishName} · আয়াত $ayahNumber',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppTheme.darkText)),
              const SizedBox(height: 2),
              LocalizedText('${surah.arabicName} · ${surah.nameMeaning}',
                  style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ]),
          ),
          IconButton(
            onPressed: onOpen,
            tooltip: context.uiText('পড়া শুরু করি'),
            icon: const Icon(Icons.menu_book_rounded, color: AppTheme.primaryGreen),
          ),
          IconButton(
            onPressed: onRemove,
            tooltip: context.uiText('বুকমার্ক সরাও'),
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.black45),
          ),
        ]),
      );
}
