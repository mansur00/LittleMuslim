import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

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
      backgroundColor: AppTheme.cream,
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
                      _PageHeader(onBack: () => Navigator.pop(context)),
                      const SizedBox(height: 17),
                      const Text('নামাজ শিখি',
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 24,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 5),
                      const Text('সময় জেনে নাও, ধাপে ধাপে শিখে নাও।',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 14)),
                      const SizedBox(height: 18),
                      const _PrayerTimesCard(),
                      const SizedBox(height: 22),
                      Row(children: [
                        const Expanded(
                            child: Text('নামাজের ধাপ',
                                style: TextStyle(
                                    color: AppTheme.darkText,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                                color: const Color(0xFFFFF0C8),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text('৫টি ধাপ',
                                style: TextStyle(
                                    color: Color(0xFFA57910),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800)))
                      ]),
                      const SizedBox(height: 10),
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
                                  onTap: () =>
                                      _showStep(context, _steps.indexOf(step)))
                          ]);
                        }
                        return GridView.count(
                          crossAxisCount: constraints.maxWidth > 850 ? 3 : 2,
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
                                  onTap: () =>
                                      _showStep(context, _steps.indexOf(step)))
                          ],
                        );
                      }),
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
          decoration: const BoxDecoration(
              color: AppTheme.cream,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
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
              Text('ধাপ ${activeIndex + 1} · ${step.$2}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppTheme.darkText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 7),
              Text(detail.$1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 9),
              Text(detail.$2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, height: 1.55)),
              const SizedBox(height: 15),
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF2CE),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Text(
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
                          label: const Text('আগের ধাপ')))
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
                        label: Text(activeIndex < _steps.length - 1
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

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.onBack});
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => Row(children: [
        IconButton.filledTonal(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(backgroundColor: Colors.white)),
        const SizedBox(width: 8),
        const Text('নামাজ',
            style: TextStyle(
                color: AppTheme.darkText,
                fontWeight: FontWeight.w800,
                fontSize: 17)),
      ]);
}

class _PrayerTimesCard extends StatelessWidget {
  const _PrayerTimesCard();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(23)),
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
                  Text('নামাজের সময়',
                      style: TextStyle(
                          color: AppTheme.darkText,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                  SizedBox(height: 3),
                  Text('শহর ও গণনা-পদ্ধতি সেটআপ বাকি',
                      style: TextStyle(color: Colors.black54, fontSize: 11))
                ])),
            TextButton(
                onPressed: () => _showSetupNotice(context),
                child: const Text('সেটআপ'))
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
          const Text(
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
              Text('লোকেশন ও নামাজের হিসাব-পদ্ধতি সেটআপ পরের ধাপে যোগ হবে।'),
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
          Text(name,
              style: const TextStyle(
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.w800,
                  fontSize: 12)),
          Text(arabic,
              textDirection: TextDirection.rtl,
              style:
                  const TextStyle(color: AppTheme.primaryGreen, fontSize: 11)),
          const SizedBox(height: 4),
          const Text('--:--',
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
                      child: Text(number,
                          style: const TextStyle(
                              color: Color(0xFFA57910),
                              fontSize: 10,
                              fontWeight: FontWeight.w800))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(title,
                            style: const TextStyle(
                                color: AppTheme.darkText,
                                fontWeight: FontWeight.w800,
                                fontSize: 13)),
                        const SizedBox(height: 3),
                        Text(detail,
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
