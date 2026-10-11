import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/duolingo_appbar.dart';

class _PrayerChapter {
  const _PrayerChapter(
      {required this.title,
      required this.subtitle,
      required this.rakat,
      required this.time,
      required this.note,
      required this.icon,
      required this.color,
      this.rule =
          'নিয়ত, তাকবির, কিয়াম, রুকু, সিজদা, শেষ বৈঠক ও সালাম—শিক্ষকের শেখানো পদ্ধতি অনুসরণ করো।',
      this.virtue = 'নিয়মিত ইবাদত ও আল্লাহর স্মরণে সাহায্য করে।',
      this.reference = ''});
  final String title, subtitle, rakat, time, note, rule, virtue, reference;
  final IconData icon;
  final Color color;
}

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  static const _fardChapters = <_PrayerChapter>[
    _PrayerChapter(
        title: 'ফজর',
        subtitle: 'ভোরের নামাজ',
        rakat: 'ফরজ: ২ রাকাত · আগে ২ রাকাত সুন্নত প্রচলিত',
        time: 'শুরু: সুবহে সাদিক হলে  ·  শেষ: সূর্য ওঠার আগে',
        note:
            'ফজরের সময় সত্য ভোরের আলো দেখা দিলে শুরু হয় এবং সূর্যোদয়ে শেষ হয়। স্থানীয় ক্যালেন্ডারে ঘড়ির সময় দেখো।',
        virtue: 'ফজর ও আসর যত্নে আদায়ের ব্যাপারে জান্নাতের সুসংবাদ এসেছে।',
        reference: 'সহিহ বুখারি ৫৭৪',
        icon: Icons.wb_twilight_rounded,
        color: Color(0xFF6D75BC)),
    _PrayerChapter(
        title: 'যোহর',
        subtitle: 'দুপুরের নামাজ',
        rakat: 'ফরজ: ৪ রাকাত · সুন্নতের রাকাত বিন্যাসে মতভেদ আছে',
        time: 'শুরু: সূর্য ঢলে গেলে  ·  শেষ: আসরের সময় শুরু হলে',
        note:
            'সূর্য মধ্য আকাশ পার হয়ে পশ্চিমে ঢলে গেলে যোহর শুরু হয়। আসরের শুরু হিসাবের পদ্ধতি অনুযায়ী কিছুটা ভিন্ন হতে পারে।',
        virtue: 'নামাজ নির্ধারিত সময়ে আদায় করা আল্লাহর কাছে প্রিয় আমল।',
        reference: 'সহিহ বুখারি ৫২৭',
        icon: Icons.wb_sunny_rounded,
        color: Color(0xFFE39C4D)),
    _PrayerChapter(
        title: 'আসর',
        subtitle: 'বিকেলের নামাজ',
        rakat: 'ফরজ: ৪ রাকাত',
        time: 'শুরু: আসরের ওয়াক্ত হলে  ·  শেষ: সূর্যাস্তের আগে',
        note:
            'আসরের শুরুর হিসাব মাযহাবভেদে ভিন্ন হতে পারে। দেরি না করে স্থানীয় মসজিদের সময় মেনে পড়ো।',
        virtue: 'ফজর ও আসর যত্নে আদায়ের ব্যাপারে জান্নাতের সুসংবাদ এসেছে।',
        reference: 'সহিহ বুখারি ৫৭৪',
        icon: Icons.wb_sunny_rounded,
        color: Color(0xFF54A8C8)),
    _PrayerChapter(
        title: 'মাগরিব',
        subtitle: 'সূর্যাস্তের নামাজ',
        rakat: 'ফরজ: ৩ রাকাত · পরে ২ রাকাত সুন্নত প্রচলিত',
        time: 'শুরু: সূর্য ডুবে গেলে  ·  শেষ: সন্ধ্যার আভা মিলিয়ে যাওয়ার আগে',
        note:
            'সূর্য পুরোপুরি অস্ত গেলে মাগরিব শুরু হয়। এর সময় তুলনামূলক ছোট, তাই দ্রুত আদায় করা ভালো।',
        virtue:
            'পাঁচ ওয়াক্ত নামাজের ধারাবাহিকতা ভুলত্রুটি মাফের কারণ হয়—বড় গুনাহ থেকে বেঁচে থাকতে হয়।',
        reference: 'সহিহ মুসলিম ২৩৩b',
        icon: Icons.wb_twilight_rounded,
        color: Color(0xFFD97868)),
    _PrayerChapter(
        title: 'ইশা',
        subtitle: 'রাতের নামাজ',
        rakat: 'ফরজ: ৪ রাকাত · এরপর সুন্নত ও বিতর',
        time:
            'শুরু: সন্ধ্যার আভা মিলালে  ·  শেষসীমা বিষয়ে মতভেদ; অর্ধরাত পার না করাই ভালো',
        note:
            'সন্ধ্যার আভা মিলিয়ে গেলে ইশার সময় শুরু হয়। হাদিসে মধ্যরাত পর্যন্ত সময়ের উল্লেখ আছে; মধ্যরাত বলতে সূর্যাস্ত থেকে ফজর পর্যন্ত রাতের অর্ধেক, ঘড়ির ১২টা সবসময় নয়।',
        virtue: 'জামাতে ইশা ও ফজর আদায়ের বিশেষ ফজিলত বর্ণিত হয়েছে।',
        reference: 'সহিহ মুসলিম ৬৫৬a',
        icon: Icons.nights_stay_rounded,
        color: Color(0xFF8D79C7)),
  ];

  static const _otherChapters = <_PrayerChapter>[
    _PrayerChapter(
        title: 'সুন্নত নামাজ',
        subtitle: 'ফরজের আগে-পরে',
        rakat: 'উদাহরণ: ফজরের আগে ২; কিছু ফরজের আগে/পরে ২ রাকাত',
        time: 'সংশ্লিষ্ট ফরজের আগে বা পরে',
        note:
            'সুন্নত নামাজের সংখ্যা ও জোরালো/কম জোরালো শ্রেণিতে মাযহাবভেদে পার্থক্য আছে। পরিবারের শিক্ষক বা স্থানীয় ইমামের শেখানো নিয়ম অনুসরণ করো।',
        virtue:
            'প্রতিদিন ফরজের বাইরে ১২ রাকাত সুন্নত পড়ার জন্য জান্নাতে ঘরের সুসংবাদ এসেছে।',
        reference: 'সহিহ মুসলিম ৭২৮c',
        icon: Icons.auto_awesome_rounded,
        color: Color(0xFFE8F8D8)),
    _PrayerChapter(
        title: 'বিতর',
        subtitle: 'ইশার পর বিজোড় রাকাত',
        rakat: 'বিজোড় রাকাত; ১ বা ৩-সহ পদ্ধতিতে মতভেদ আছে',
        time: 'ইশার পর থেকে ফজরের আগে',
        note:
            'বিতর কীভাবে ও কয় রাকাত পড়তে হয়—এ বিষয়ে মাযহাবভেদে কিছু পার্থক্য রয়েছে। নিজের শেখা পদ্ধতিতে আদায় করো।',
        rule:
            'ইশার পর বিজোড় রাকাত আদায় করো; কুনুত ও রাকাতের নিয়ম তোমার মাযহাবের শিক্ষক/ইমামের কাছ থেকে শিখে নাও।',
        virtue: 'বিতর বিজোড় রাকাতের নামাজ; রাসুল ﷺ এটি আদায়ে উৎসাহ দিয়েছেন।',
        icon: Icons.star_rounded,
        color: Color(0xFFFFF0C8)),
    _PrayerChapter(
        title: 'তাহাজ্জুদ',
        subtitle: 'রাতের নফল নামাজ',
        rakat: '২ রাকাত করে পড়া যায়; নির্দিষ্ট মোট সংখ্যা নেই',
        time: 'ইশার পর ঘুম থেকে উঠে, ফজরের আগে',
        note:
            'রাতের শেষ ভাগে পড়া উত্তম। ক্লান্ত হলে অল্প পড়ো; নিয়ম শেখার জন্য অভিভাবককে জিজ্ঞেস করো।',
        rule:
            'সাধারণভাবে ২ রাকাত করে পড়া হয়। রাতের নামাজ শেষে বিতর আদায়ের নিয়ম শিখে নাও।',
        virtue: 'ফরজের পর রাতের নামাজকে উত্তম নফল নামাজ বলা হয়েছে।',
        reference: 'সহিহ মুসলিম ১১৬৩b',
        icon: Icons.dark_mode_rounded,
        color: Color(0xFFE8E2FF)),
    _PrayerChapter(
        title: 'ইশরাক',
        subtitle: 'সূর্য ওঠার পর নফল',
        rakat: 'সাধারণত ২ রাকাত দিয়ে শুরু',
        time: 'সূর্য ওঠার নিষিদ্ধ সময় পার হওয়ার পর; যোহরের আগে',
        note:
            'সূর্য ওঠার পরপর নামাজ পড়া হয় না। সূর্য কিছুটা ওপরে উঠলে—স্থানীয় সূর্যোদয়ের প্রায় ১৫–২০ মিনিট পর—সময় শুরু হয়; নির্দিষ্ট ব্যবধান শহর/মৌসুমে যাচাই করো।',
        rule:
            'সময় হওয়ার পর সাধারণ নফল নামাজের মতো ২ রাকাত পড়ো; সূর্য ওঠার নিষিদ্ধ সময় এড়িয়ে চলো।',
        virtue: 'ফজরের পর আল্লাহর স্মরণ ও নফল নামাজ দিয়ে সকাল শুরু করার সুযোগ।',
        icon: Icons.wb_sunny_outlined,
        color: Color(0xFFFFEBCF)),
    _PrayerChapter(
        title: 'দুহা / চাশত',
        subtitle: 'সকালের নফল নামাজ',
        rakat: 'কমপক্ষে ২ রাকাত; একাধিক রাকাত পড়া যায়',
        time: 'সূর্য ওপরে ওঠার পর থেকে যোহরের আগে',
        note:
            'ইশরাককে অনেক জায়গায় দুহার প্রথম দিকের নামাজ বলা হয়। নাম ও সময় গণনায় প্রচলিত ব্যাখ্যা ভিন্ন হতে পারে।',
        rule:
            '২ রাকাত করে নফল পড়ো; কয় রাকাত পড়বে তা সামর্থ্য ও শেখা পদ্ধতি অনুযায়ী রাখো।',
        virtue: 'দুহা একটি পরিচিত নফল ইবাদত; সামর্থ্য অনুযায়ী নিয়মিত করা যায়।',
        icon: Icons.light_mode_rounded,
        color: Color(0xFFFFF6D0)),
    _PrayerChapter(
        title: 'তারাবিহ',
        subtitle: 'রমজানের রাতের নামাজ',
        rakat: 'রাকাত সংখ্যায় প্রচলিত পদ্ধতিগুলো ভিন্ন',
        time: 'রমজানে ইশার পর',
        note:
            'তারাবিহ জামাতে বা একা পড়া যায়। ৮/২০ রাকাতসহ বিভিন্ন স্বীকৃত পদ্ধতি আছে—নিজের মসজিদ/শিক্ষকের অনুসরণ করো।',
        rule:
            'রমজানে ইশার পর ২ রাকাত করে পড়া হয়; বিরতি ও মোট রাকাতের পদ্ধতি মসজিদ/ইমামের অনুসরণ করো।',
        virtue:
            'ঈমান ও সওয়াবের আশায় রমজানের রাতে ইবাদত করার ফজিলত বর্ণিত হয়েছে.',
        reference: 'সহিহ বুখারি ২০০৮',
        icon: Icons.nightlight_round,
        color: Color(0xFFDCEBFF)),
    _PrayerChapter(
        title: 'জুমার নামাজ',
        subtitle: 'শুক্রবারের জামাত',
        rakat: 'খুতবার পর জামাতে ২ রাকাত ফরজ',
        time: 'যোহরের ওয়াক্তে',
        note:
            'জুমার শর্ত ও কার ওপর ফরজ—এসব বিষয়ে অভিভাবক বা আলেমের কাছ থেকে বয়স ও পরিস্থিতি অনুযায়ী শিখে নাও।',
        rule: 'খুতবা মনোযোগ দিয়ে শোনো, তারপর জামাতে ২ রাকাত ফরজ আদায় করো।',
        virtue:
            'জুমা থেকে পরের জুমা পর্যন্ত নামাজগুলো গুনাহ মাফের কারণ হয়—বড় গুনাহ থেকে বেঁচে থাকতে হয়।',
        reference: 'সহিহ মুসলিম ২৩৩b',
        icon: Icons.groups_rounded,
        color: Color(0xFFDDF4E9)),
    _PrayerChapter(
        title: 'ঈদের নামাজ',
        subtitle: 'ঈদুল ফিতর ও ঈদুল আজহা',
        rakat: '২ রাকাত; অতিরিক্ত তাকবিরের নিয়মে মতভেদ আছে',
        time: 'ঈদের সকালে, সূর্য ওঠার কিছু পর',
        note:
            'ঈদের নামাজের তাকবির ও পদ্ধতি মাযহাবভেদে কিছুটা আলাদা হতে পারে; জামাতের ইমামের অনুসরণ করো।',
        rule:
            '২ রাকাত জামাতে হয় এবং অতিরিক্ত তাকবির থাকে; ইমামের সঙ্গে ধাপে ধাপে পড়ো।',
        virtue: 'জামাতে ঈদের নামাজ মুসলিমদের আনন্দ ও কৃতজ্ঞতার ইবাদত।',
        icon: Icons.celebration_rounded,
        color: Color(0xFFFFE4E8)),
    _PrayerChapter(
        title: 'জানাজার নামাজ',
        subtitle: 'মৃত মুসলিমের জন্য দোয়া',
        rakat: 'রুকু-সিজদা নেই; সাধারণ পদ্ধতিতে ৪ তাকবির',
        time: 'জানাজা প্রস্তুত হলে জামাতে',
        note:
            'জানাজার নামাজ দাঁড়িয়ে আদায় করা হয়। দোয়া ও তাকবিরের ধাপ কোনো বড়দের সঙ্গে শিখে নাও।',
        rule:
            'দাঁড়িয়ে ৪ তাকবির; এতে রুকু-সিজদা নেই। দোয়ার ধাপ অভিভাবক/ইমামের কাছে শিখে নাও।',
        virtue: 'জানাজার নামাজে অংশ নেওয়ার বড় প্রতিদানের কথা হাদিসে এসেছে।',
        reference: 'সহিহ বুখারি ৪৭',
        icon: Icons.volunteer_activism_rounded,
        color: Color(0xFFE0F1FF)),
  ];

  static const _prayers = [
    ('ফজর', 'الفجر', Icons.wb_twilight_rounded),
    ('যোহর', 'الظهر', Icons.wb_sunny_rounded),
    ('আসর', 'العصر', Icons.wb_sunny_rounded),
    ('মাগরিব', 'المغرب', Icons.wb_twilight_rounded),
    ('ইশা', 'العشاء', Icons.nights_stay_rounded),
  ];

  static const _steps = [
    (
      '১',
      'প্রস্তুতি',
      'পবিত্রতা ও কিবলামুখী হওয়া',
      Icons.water_drop_rounded,
      Color(0xFF54A8C8)
    ),
    (
      '২',
      'তাকবির ও কিয়াম',
      'দাঁড়ানোর ধাপ',
      Icons.accessibility_new_rounded,
      Color(0xFF8D79C7)
    ),
    (
      '৩',
      'কিরাত',
      'দাঁড়িয়ে তিলাওয়াত',
      Icons.menu_book_rounded,
      Color(0xFF58A976)
    ),
    (
      '৪',
      'রুকু ও সিজদা',
      'নামাজের ভঙ্গিগুলো',
      Icons.self_improvement_rounded,
      Color(0xFFE39C4D)
    ),
    (
      '٥',
      'বৈঠক ও সালাম',
      'শেষের ধাপ',
      Icons.waving_hand_rounded,
      Color(0xFFD97868)
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
      backgroundColor: const Color(0xFFEEF4FF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      tablet ? 36 : 20, 16, tablet ? 36 : 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      DuolingoPageHeader(
                        title: 'নামাজ শিখি',
                        subtitle: 'সময় জেনে নাও, ধাপে ধাপে শিখে নাও।',
                        iconType: VectorIconType.mosque,
                        gradientColors: const [
                          Color(0xFF5B86E5),
                          Color(0xFF36D1DC)
                        ],
                        onBack: () => Navigator.pop(context),
                      ),
                      const _PrayerTimesCard(),
                      const SizedBox(height: 22),
                      _PrayerChapterGroup(
                        number: 'অধ্যায় ১',
                        title: 'নামাজের ধাপ',
                        subtitle: 'ওজু থেকে সালাম পর্যন্ত শিখি',
                        icon: Icons.self_improvement_rounded,
                        color: const Color(0xFFE8E2FF),
                        initiallyExpanded: true,
                        children: [
                          LayoutBuilder(builder: (context, constraints) {
                            if (constraints.maxWidth < 640) {
                              return Column(children: [
                                for (final step in _steps)
                                  _StepCard(
                                      number: step.$1,
                                      title: step.$2,
                                      detail: step.$3,
                                      icon: step.$4,
                                      color: step.$5,
                                      onTap: () => _showStep(
                                          context, _steps.indexOf(step)))
                              ]);
                            }
                            return GridView.count(
                              crossAxisCount:
                                  constraints.maxWidth > 850 ? 3 : 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.55,
                              children: [
                                for (final step in _steps)
                                  _StepCard(
                                      number: step.$1,
                                      title: step.$2,
                                      detail: step.$3,
                                      icon: step.$4,
                                      color: step.$5,
                                      onTap: () => _showStep(
                                          context, _steps.indexOf(step)))
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _PrayerChapterGroup(
                        number: 'অধ্যায় ২',
                        title: 'পাঁচ ওয়াক্ত ফরজ নামাজ',
                        subtitle: 'রাকাত · ওয়াক্ত · নিয়ম · ফজিলত',
                        icon: Icons.wb_twilight_rounded,
                        color: const Color(0xFFDDF4E9),
                        children: [
                          for (final chapter in _fardChapters)
                            _PrayerChapterTile(chapter: chapter),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _PrayerChapterGroup(
                        number: 'অধ্যায় ৩',
                        title: 'অন্যান্য সুন্নত ও নফল নামাজ',
                        subtitle: 'তাহাজ্জুদ · ইশরাক · বিতরসহ',
                        icon: Icons.nightlight_round,
                        color: const Color(0xFFFFEBCF),
                        children: [
                          for (final chapter in _otherChapters)
                            _PrayerChapterTile(chapter: chapter),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const LocalizedText(
                          'ঘড়ির সঠিক ওয়াক্ত শহর, তারিখ ও হিসাব-পদ্ধতি অনুযায়ী বদলায়। এই screen-এ এখন ওয়াক্তের সীমা শেখানো হচ্ছে; নির্দিষ্ট আজকের সময় জানতে স্থানীয় মসজিদ/বিশ্বস্ত ক্যালেন্ডার দেখো।',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 11,
                              height: 1.6)),
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

  static const _guideDetails = [
    (
      'ওজু করে প্রস্তুত হও',
      'শরীর, পোশাক ও নামাজের জায়গা পরিষ্কার রাখো। ওজু করে কিবলামুখী হয়ে দাঁড়াও।'
    ),
    (
      'নিয়ত করে নামাজ শুরু',
      'কোন নামাজ পড়ছ তা মনে স্থির করো। দাঁড়িয়ে “আল্লাহু আকবার” বলে নামাজ শুরু করো।'
    ),
    (
      'দাঁড়িয়ে তিলাওয়াত',
      'শান্তভাবে দাঁড়িয়ে সূরা আল-ফাতিহা পড়ো। এরপর কুরআন থেকে যা সহজ, তা পড়ো।'
    ),
    (
      'রুকু, দাঁড়ানো ও সিজদা',
      'রুকুতে স্থির হও, তারপর সোজা হয়ে দাঁড়াও। এরপর সিজদা করো, বসো, আবার সিজদা করো।'
    ),
    (
      'বৈঠক ও সালাম',
      'শেষ বৈঠকে তাশাহহুদ পড়ো। নামাজ শেষ করতে ডানে ও বামে সালাম ফেরাও।'
    ),
  ];

  void _showStep(BuildContext context, int startIndex) {
    var activeIndex = startIndex;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, setSheetState) {
        final step = _steps[activeIndex];
        final detail = _guideDetails[activeIndex];
        return Container(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          decoration: BoxDecoration(
            color: AppTheme.cream,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(
              color: AppTheme.primaryGreen.withValues(alpha: .16),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withValues(alpha: .22),
                blurRadius: 0,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8))),
              const SizedBox(height: 18),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < _steps.length; i++)
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: i == activeIndex ? 28 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                          color: i == activeIndex
                              ? AppTheme.primaryGreen
                              : const Color(0xFFD9E4D5),
                          borderRadius: BorderRadius.circular(8))),
              ]),
              const SizedBox(height: 16),
              Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                      color: step.$5.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(24)),
                  child: Icon(step.$4, size: 38, color: step.$5)),
              const SizedBox(height: 13),
              LocalizedText('ধাপ ${activeIndex + 1} · ${step.$2}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppTheme.darkText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 7),
              LocalizedText(detail.$1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 9),
              LocalizedText(detail.$2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, height: 1.55)),
              const SizedBox(height: 15),
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF2CE),
                      borderRadius: BorderRadius.circular(15)),
                  child: const LocalizedText(
                      'মাযহাবভেদে কিছু নিয়মে পার্থক্য থাকতে পারে—পরিবারের অভিভাবক বা শিক্ষকের কাছ থেকে নিজের পদ্ধতিটি শিখে নাও।',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF735B24),
                          fontSize: 11,
                          height: 1.5))),
              const SizedBox(height: 17),
              Row(children: [
                if (activeIndex > 0)
                  Expanded(
                      child: OutlinedButton.icon(
                          onPressed: () => setSheetState(() => activeIndex--),
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const LocalizedText('আগের ধাপ')))
                else
                  const Spacer(),
                const SizedBox(width: 10),
                Expanded(
                    child: FilledButton.icon(
                        onPressed: activeIndex < _steps.length - 1
                            ? () => setSheetState(() => activeIndex++)
                            : () => Navigator.pop(context),
                        icon: Icon(activeIndex < _steps.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded),
                        label: LocalizedText(activeIndex < _steps.length - 1
                            ? 'পরের ধাপ'
                            : 'শেষ করি'),
                        style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen))),
              ]),
            ]),
          ),
        );
      }),
    );
  }
}

class _PrayerTimesCard extends StatelessWidget {
  const _PrayerTimesCard();
  @override
  Widget build(BuildContext context) => DuolingoCard(
        accentColor: AppTheme.primaryGreen,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(17),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: const Color(0xFFE7F2E6),
                    borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.location_on_rounded,
                    color: AppTheme.primaryGreen)),
            const SizedBox(width: 11),
            const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  LocalizedText('নামাজের সময়',
                      style: TextStyle(
                          color: AppTheme.darkText,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                  SizedBox(height: 3),
                  LocalizedText('শহর ও গণনা-পদ্ধতি সেটআপ বাকি',
                      style: TextStyle(color: Colors.black54, fontSize: 11))
                ])),
            TextButton(
                onPressed: () => _showSetupNotice(context),
                child: const LocalizedText('সেটআপ'))
          ]),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFECEDE7)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final prayer in PrayerScreen._prayers)
              _PrayerTimeChip(
                  name: prayer.$1, arabic: prayer.$2, icon: prayer.$3)
          ]),
          const SizedBox(height: 11),
          const LocalizedText(
              'সময় দেখানোর আগে সঠিক শহর ও হিসাব-পদ্ধতি নির্বাচন করতে হবে।',
              style:
                  TextStyle(color: Colors.black45, fontSize: 10, height: 1.5)),
        ]),
      );

  void _showSetupNotice(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
          content:
              LocalizedText('লোকেশন ও নামাজের হিসাব-পদ্ধতি সেটআপ পরের ধাপে যোগ হবে।'),
          behavior: SnackBarBehavior.floating));
  }
}

class _PrayerTimeChip extends StatelessWidget {
  const _PrayerTimeChip(
      {required this.name, required this.arabic, required this.icon});
  final String name, arabic;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
        width: 105,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: BoxDecoration(
            color: const Color(0xFFF7F7F1),
            borderRadius: BorderRadius.circular(15)),
        child: Column(children: [
          Icon(icon, size: 18, color: AppTheme.secondaryGold),
          const SizedBox(height: 5),
          LocalizedText(name,
              style: const TextStyle(
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.w800,
                  fontSize: 12)),
          LocalizedText(arabic,
              textDirection: TextDirection.rtl,
              style:
                  const TextStyle(color: AppTheme.primaryGreen, fontSize: 11)),
          const SizedBox(height: 4),
          const LocalizedText('--:--',
              style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w700,
                  fontSize: 12))
        ]),
      );
}

class _StepCard extends StatelessWidget {
  const _StepCard(
      {required this.number,
      required this.title,
      required this.detail,
      required this.icon,
      required this.color,
      required this.onTap});
  final String number, title, detail;
  final IconData icon;
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
                padding: const EdgeInsets.all(13),
                child: Row(children: [
                  Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: color.withValues(alpha: .13),
                          borderRadius: BorderRadius.circular(14)),
                      child: Icon(icon, color: color, size: 22)),
                  const SizedBox(width: 12),
                  Container(
                      width: 23,
                      height: 23,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFF2CE),
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: LocalizedText(number,
                          style: const TextStyle(
                              color: Color(0xFFA57910),
                              fontSize: 10,
                              fontWeight: FontWeight.w800))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        LocalizedText(title,
                            style: const TextStyle(
                                color: AppTheme.darkText,
                                fontWeight: FontWeight.w800,
                                fontSize: 13)),
                        const SizedBox(height: 3),
                        LocalizedText(detail,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 10))
                      ])),
                  const Icon(Icons.chevron_right_rounded,
                      color: Colors.black38),
                ])),
          ),
        ),
      );
}

class _PrayerChapterGroup extends StatelessWidget {
  const _PrayerChapterGroup({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.children,
    this.initiallyExpanded = false,
  });
  final String number, title, subtitle;
  final IconData icon;
  final Color color;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: initiallyExpanded,
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            leading: CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: AppTheme.primaryGreen),
            ),
            title: LocalizedText(title,
                style: const TextStyle(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w900,
                    fontSize: 15)),
            subtitle: LocalizedText('$number · $subtitle',
                style: const TextStyle(color: Colors.black54, fontSize: 11)),
            children: children,
          ),
        ),
      );
}

class _PrayerChapterTile extends StatelessWidget {
  const _PrayerChapterTile({required this.chapter});
  final _PrayerChapter chapter;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 9),
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: chapter.color.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(14)),
              child: Icon(chapter.icon, color: chapter.color, size: 23),
            ),
            title: LocalizedText(chapter.title,
                style: const TextStyle(
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w900,
                    fontSize: 15)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: LocalizedText(chapter.rakat,
                  style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 11,
                      height: 1.4,
                      fontWeight: FontWeight.w700)),
            ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: chapter.color.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LocalizedText('ওয়াক্ত',
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      LocalizedText(chapter.time,
                          style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 13,
                              height: 1.5,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 9),
                      const LocalizedText('কীভাবে পড়ি',
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      LocalizedText(chapter.rule,
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              height: 1.6)),
                      const SizedBox(height: 9),
                      const LocalizedText('সময় ও নিয়মের কথা',
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      LocalizedText(chapter.note,
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              height: 1.6)),
                      const SizedBox(height: 10),
                      const LocalizedText('ফজিলত',
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      LocalizedText(chapter.virtue,
                          style: const TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 12,
                              height: 1.6)),
                      if (chapter.reference.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        LocalizedText('সূত্র: ${chapter.reference}',
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ],
                    ]),
              ),
            ],
          ),
        ),
      );
}
