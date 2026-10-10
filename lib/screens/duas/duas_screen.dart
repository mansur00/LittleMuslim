import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../../widgets/vector_icons.dart';

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
      color: Color(0xFFFFF6D0),
      accent: Color(0xFFD4A017),
    ),
    _DuaEntry(
      id: 'food',
      title: 'খাবার শুরু করার আগে',
      category: 'দৈনন্দিন',
      arabic: 'بِسْمِ اللَّهِ',
      meaning: 'আল্লাহর নামে।',
      reference: 'সহিহ বুখারি ৫৩৭৬',
      color: Color(0xFFE8F8D8),
      accent: Color(0xFF58A700),
    ),
    _DuaEntry(
      id: 'sleep',
      title: 'ঘুমাতে যাওয়ার সময়',
      category: 'ঘুম',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      meaning: 'হে আল্লাহ, আপনার নামেই আমি মরি এবং বাঁচি।',
      reference: 'সহিহ বুখারি ৬৩২৪',
      color: Color(0xFFF3E8FF),
      accent: Color(0xFF9B6BC9),
    ),
    _DuaEntry(
      id: 'restroom',
      title: 'শৌচাগারে প্রবেশের আগে',
      category: 'দৈনন্দিন',
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
      meaning: 'হে আল্লাহ, আমি আপনার কাছে আল-খুবুথ ও আল-খাবাইথ থেকে আশ্রয় চাই।',
      reference: 'সহিহ বুখারি ৬৩২২',
      color: Color(0xFFDCEBFF),
      accent: Color(0xFF3B82C4),
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
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      tablet ? 36 : 18, 12, tablet ? 36 : 18, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Row(children: [
                        IconButton.filledTonal(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded),
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'মাসনুন দোয়া',
                          style: TextStyle(
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      const Text(
                        'ছোট ছোট দোয়া, প্রতিদিন',
                        style: TextStyle(
                          color: AppTheme.darkText,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'সময় ও কাজ অনুযায়ী দোয়া খুঁজে নাও।',
                        style: TextStyle(
                          color: AppTheme.darkText.withValues(alpha: 0.55),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFF9B6BC9).withValues(alpha: 0.25),
                            width: 2,
                          ),
                        ),
                        child: Row(children: [
                          IconBadge(
                            type: VectorIconType.dua,
                            bgColor: Colors.white,
                            size: 48,
                            iconColor: const Color(0xFF9B6BC9),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'আজকের ছোট্ট অভ্যাস',
                                  style: TextStyle(
                                    color: AppTheme.darkText,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'একটি দোয়া শেখো, অর্থটাও জেনে নাও।',
                                  style: TextStyle(
                                    color: Color(0xFF6B5B7A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          for (var i = 0; i < _categories.length; i++) ...[
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedCategory = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 9),
                                decoration: BoxDecoration(
                                  color: _selectedCategory == i
                                      ? const Color(0xFF9B6BC9)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _selectedCategory == i
                                        ? const Color(0xFF9B6BC9)
                                        : const Color(0xFFE5E5E5),
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  _categories[i],
                                  style: TextStyle(
                                    color: _selectedCategory == i
                                        ? Colors.white
                                        : AppTheme.darkText,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ]),
                      ),
                      const SizedBox(height: 14),
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
                      Text(
                        'আরবি পাঠ ও হাদিস নম্বর Sunnah.com-এ উল্লেখিত রেফারেন্সের সঙ্গে মিলিয়ে দেওয়া হয়েছে।',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.darkText.withValues(alpha: 0.4),
                          fontSize: 10,
                          height: 1.5,
                        ),
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
        content: Text('দোয়াটি কপি হয়েছে।'),
        behavior: SnackBarBehavior.floating,
      ));
  }

  void _showAudioNotice(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('দোয়ার অডিও পরের ধাপে যোগ হবে।'),
        behavior: SnackBarBehavior.floating,
      ));
  }
}

class _DuaCard extends StatelessWidget {
  const _DuaCard({
    required this.dua,
    required this.isFavorite,
    required this.onFavorite,
    required this.onCopy,
    required this.onListen,
  });
  final _DuaEntry dua;
  final bool isFavorite;
  final VoidCallback onFavorite, onCopy, onListen;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              IconBadge(
                type: VectorIconType.dua,
                bgColor: dua.color,
                size: 40,
                iconColor: dua.accent,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dua.title,
                      style: const TextStyle(
                        color: AppTheme.darkText,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      dua.category,
                      style: TextStyle(
                        color: AppTheme.darkText.withValues(alpha: 0.45),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isFavorite ? dua.accent : Colors.black38,
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                dua.arabic,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.darkText,
                  fontSize: 22,
                  height: 1.75,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              dua.meaning,
              style: const TextStyle(
                color: AppTheme.darkText,
                fontSize: 13,
                height: 1.55,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(
                child: Text(
                  dua.reference,
                  style: TextStyle(
                    color: dua.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: onListen,
                icon: Icon(Icons.volume_up_rounded,
                    color: dua.accent, size: 20),
              ),
              IconButton(
                onPressed: onCopy,
                icon: const Icon(Icons.copy_rounded,
                    color: Colors.black45, size: 18),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
