import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/vector_icons.dart';
import '../settings/settings_screen.dart';

class LiveLearningScreen extends StatelessWidget {
  const LiveLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: EdgeInsets.all(tablet ? 32 : 18),
              children: [
                DuolingoPageHeader(
                  title: 'শিক্ষকের সাথে শিখি',
                  subtitle: 'সরাসরি শিক্ষকের কাছে শিখি',
                  iconType: VectorIconType.book,
                  gradientColors: const [Color(0xFF0D7377), Color(0xFF159A8C)],
                  onBack: () => Navigator.pop(context),
                  trailing: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const SettingsScreen())),
                    child:
                        const Icon(Icons.settings_rounded, color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(tablet ? 26 : 21),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF0D7377), Color(0xFF159A8C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.primaryGreen.withValues(alpha: .24),
                          blurRadius: 17,
                          offset: const Offset(0, 8))
                    ],
                  ),
                  child: Row(children: [
                    Container(
                      width: tablet ? 74 : 60,
                      height: tablet ? 74 : 60,
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .18),
                          borderRadius: BorderRadius.circular(22)),
                      child: const Icon(Icons.video_call_rounded,
                          color: Colors.white, size: 38),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('সরাসরি শিক্ষকের কাছে শিখি',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18)),
                            SizedBox(height: 5),
                            Text('কুরআন তিলাওয়াত ও মৌলিক ইসলাম শিক্ষা',
                                style: TextStyle(
                                    color: Colors.white,
                                    height: 1.45,
                                    fontSize: 13)),
                          ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),
                const DuolingoSectionLabel(label: 'কীভাবে চলবে'),
                const SizedBox(height: 10),
                const _FeatureCard(
                    icon: Icons.menu_book_rounded,
                    color: Color(0xFFDDF4E9),
                    title: 'কুরআন শেখা',
                    detail:
                        'শিক্ষকের সঙ্গে পড়া, মাখরাজ অনুশীলন ও তিলাওয়াত সংশোধন।'),
                const _FeatureCard(
                    icon: Icons.lightbulb_rounded,
                    color: Color(0xFFFFEBCF),
                    title: 'মৌলিক ইসলাম শিক্ষা',
                    detail:
                        'শিশুর বয়স অনুযায়ী ঈমান, ইবাদত ও দৈনন্দিন আদব নিয়ে live lesson।'),
                const _FeatureCard(
                    icon: Icons.calendar_month_rounded,
                    color: Color(0xFFE8E2FF),
                    title: 'মাসিক ক্লাস পরিকল্পনা',
                    detail:
                        'মাসিক subscription, শিক্ষক-নির্ধারিত সময়সূচি এবং অভিভাবকের class overview।'),
                const SizedBox(height: 15),
                DuolingoCard(
                  accentColor: AppTheme.primaryGreen,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(17),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          Icon(Icons.video_camera_front_rounded,
                              color: AppTheme.primaryGreen),
                          SizedBox(width: 9),
                          Expanded(
                              child: Text('Live classroom',
                                  style: TextStyle(
                                      color: AppTheme.darkText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900))),
                          _SetupBadge(),
                        ]),
                        const SizedBox(height: 11),
                        const Text(
                            'শিক্ষক account, class schedule এবং Zoom/Meet SDK সংযুক্ত হলে class এই screen-এর ভেতর চালু হবে। এখনো live room বা payment service সংযুক্ত হয়নি।',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                height: 1.6)),
                        const SizedBox(height: 13),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.lock_outline_rounded),
                            label: const Text('লাইভ ক্লাস এখনো প্রস্তুত নয়'),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const SettingsScreen()),
                    ),
                    icon: const Icon(Icons.payments_rounded),
                    label: const Text('মাসিক পরিকল্পনা ও পেমেন্ট সেটিংস'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryGreen,
                        side: const BorderSide(color: AppTheme.primaryGreen),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17))),
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

class _FeatureCard extends StatelessWidget {
  const _FeatureCard(
      {required this.icon,
      required this.color,
      required this.title,
      required this.detail});
  final IconData icon;
  final Color color;
  final String title, detail;

  @override
  Widget build(BuildContext context) => DuolingoCard(
        accentColor: AppTheme.primaryGreen,
        backgroundColor: Colors.white,
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: AppTheme.primaryGreen)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: const TextStyle(
                        color: AppTheme.darkText,
                        fontWeight: FontWeight.w900,
                        fontSize: 14)),
                const SizedBox(height: 3),
                Text(detail,
                    style: const TextStyle(
                        color: Colors.black54, fontSize: 11, height: 1.5)),
              ])),
        ]),
      );
}

class _SetupBadge extends StatelessWidget {
  const _SetupBadge();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
            color: const Color(0xFFFFEBCF),
            borderRadius: BorderRadius.circular(20)),
        child: const Text('সেটআপ বাকি',
            style: TextStyle(
                color: Color(0xFF9A6500),
                fontSize: 10,
                fontWeight: FontWeight.w800)),
      );
}
