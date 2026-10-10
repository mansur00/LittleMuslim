import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';

class _DuaEntry {
  const _DuaEntry(
      {required this.id,
      required this.title,
      required this.category,
      required this.arabic,
      required this.meaning,
      required this.reference,
      required this.color});
  final String id, title, category, arabic, meaning, reference;
  final Color color;
}

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  static const _categories = ['সব', 'সকাল ও সন্ধ্যা', 'দৈনন্দিন', 'ঘুম'];
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
      color: Color(0xFFFFF0C9),
    ),
    _DuaEntry(
      id: 'food',
      title: 'খাবার শুরু করার আগে',
      category: 'দৈনন্দিন',
      arabic: 'بِسْمِ اللَّهِ',
      meaning: 'আল্লাহর নামে।',
      reference: 'সহিহ বুখারি ৫৩৭৬',
      color: Color(0xFFE6F3E8),
    ),
    _DuaEntry(
      id: 'sleep',
      title: 'ঘুমাতে যাওয়ার সময়',
      category: 'ঘুম',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      meaning: 'হে আল্লাহ, আপনার নামেই আমি মরি এবং বাঁচি।',
      reference: 'সহিহ বুখারি ৬৩২৪',
      color: Color(0xFFE8E8F7),
    ),
    _DuaEntry(
      id: 'restroom',
      title: 'শৌচাগারে প্রবেশের আগে',
      category: 'দৈনন্দিন',
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
      meaning: 'হে আল্লাহ, আমি আপনার কাছে আল-খুবুথ ও আল-খাবাইথ থেকে আশ্রয় চাই।',
      reference: 'সহিহ বুখারি ৬৩২২',
      color: Color(0xFFE5F1F8),
    ),
  ];

  int _selectedCategory = 0;
  final Set<String> _favorites = {};

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final selectedCategory = _categories[_selectedCategory];
    final filtered = _duas
        .where((dua) =>
            selectedCategory == 'সব' || dua.category == selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      tablet ? 36 : 20, 16, tablet ? 36 : 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _DuaHeader(onBack: () => Navigator.pop(context)),
                      const SizedBox(height: 18),
                      const Text('ছোট ছোট দোয়া, প্রতিদিন',
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 23,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 5),
                      const Text('সময় ও কাজ অনুযায়ী দোয়া খুঁজে নাও।',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 14)),
                      const SizedBox(height: 17),
                      const _DuaBanner(),
                      const SizedBox(height: 19),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          for (var i = 0; i < _categories.length; i++) ...[
                            ChoiceChip(
                                label: Text(_categories[i]),
                                selected: _selectedCategory == i,
                                onSelected: (_) =>
                                    setState(() => _selectedCategory = i),
                                selectedColor: AppTheme.primaryGreen,
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                    color: _selectedCategory == i
                                        ? Colors.white
                                        : AppTheme.darkText,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12),
                                side: BorderSide.none,
                                showCheckmark: false),
                            const SizedBox(width: 7),
                          ],
                        ]),
                      ),
                      const SizedBox(height: 11),
                      for (final dua in filtered)
                        _DuaCard(
                          dua: dua,
                          isFavorite: _favorites.contains(dua.id),
                          onFavorite: () => setState(() =>
                              _favorites.contains(dua.id)
                                  ? _favorites.remove(dua.id)
                                  : _favorites.add(dua.id)),
                          onCopy: () => _copyDua(context, dua.arabic),
                          onListen: () => _showAudioNotice(context),
                        ),
                      const SizedBox(height: 12),
                      const Text(
                          'আরবি পাঠ ও হাদিস নম্বর Sunnah.com-এ উল্লেখিত রেফারেন্সের সঙ্গে মিলিয়ে দেওয়া হয়েছে। বাংলা অর্থ সহজ ভাষায় উপস্থাপিত।',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 10,
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

  void _copyDua(BuildContext context, String arabic) {
    Clipboard.setData(ClipboardData(text: arabic));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
          content: Text('দোয়াটি কপি হয়েছে।'),
          behavior: SnackBarBehavior.floating));
  }

  void _showAudioNotice(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
          content: Text('দোয়ার অডিও পরের ধাপে যোগ হবে।'),
          behavior: SnackBarBehavior.floating));
  }
}

class _DuaHeader extends StatelessWidget {
  const _DuaHeader({required this.onBack});
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => Row(children: [
        IconButton.filledTonal(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(backgroundColor: Colors.white)),
        const SizedBox(width: 8),
        const Text('মাসনুন দোয়া',
            style: TextStyle(
                color: AppTheme.darkText,
                fontWeight: FontWeight.w800,
                fontSize: 17)),
      ]);
}

class _DuaBanner extends StatelessWidget {
  const _DuaBanner();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: const Color(0xFFE5F1E7),
            borderRadius: BorderRadius.circular(22)),
        child: Row(children: [
          Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .78),
                  borderRadius: BorderRadius.circular(16)),
              alignment: Alignment.center,
              child: const Icon(Icons.auto_awesome_rounded,
                  color: AppTheme.secondaryGold, size: 26)),
          const SizedBox(width: 12),
          const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('আজকের ছোট্ট অভ্যাস',
                    style: TextStyle(
                        color: AppTheme.darkText,
                        fontWeight: FontWeight.w800,
                        fontSize: 14)),
                SizedBox(height: 4),
                Text('একটি দোয়া শেখো, অর্থটাও জেনে নাও।',
                    style: TextStyle(color: Colors.black54, fontSize: 11))
              ])),
        ]),
      );
}

class _DuaCard extends StatelessWidget {
  const _DuaCard(
      {required this.dua,
      required this.isFavorite,
      required this.onFavorite,
      required this.onCopy,
      required this.onListen});
  final _DuaEntry dua;
  final bool isFavorite;
  final VoidCallback onFavorite, onCopy, onListen;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 11),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(21),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 10,
                  offset: Offset(0, 3))
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 15, 16, 12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: dua.color,
                      borderRadius: BorderRadius.circular(11)),
                  child: const Icon(Icons.favorite_rounded,
                      color: AppTheme.primaryGreen, size: 17)),
              const SizedBox(width: 9),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(dua.title,
                        style: const TextStyle(
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w800,
                            fontSize: 13)),
                    Text(dua.category,
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 10))
                  ])),
              IconButton(
                  onPressed: onFavorite,
                  tooltip: isFavorite ? 'পছন্দ থেকে সরাও' : 'পছন্দে রাখো',
                  icon: Icon(
                      isFavorite
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isFavorite
                          ? AppTheme.secondaryGold
                          : Colors.black38)),
            ]),
            const SizedBox(height: 9),
            Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F3),
                    borderRadius: BorderRadius.circular(15)),
                child: Text(dua.arabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppTheme.darkText,
                        fontSize: 23,
                        height: 1.8,
                        fontWeight: FontWeight.w600))),
            const SizedBox(height: 10),
            Text(dua.meaning,
                style: const TextStyle(
                    color: AppTheme.darkText, fontSize: 12, height: 1.6)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                  child: Text(dua.reference,
                      style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w700))),
              IconButton(
                  onPressed: onListen,
                  tooltip: 'শোনো',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.volume_up_rounded,
                      color: AppTheme.primaryGreen, size: 19)),
              IconButton(
                  onPressed: onCopy,
                  tooltip: 'কপি',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.copy_rounded,
                      color: Colors.black45, size: 17))
            ]),
          ]),
        ),
      );
}
