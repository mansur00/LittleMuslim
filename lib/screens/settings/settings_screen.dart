import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/vector_icons.dart';
import '../profile/profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: EdgeInsets.all(tablet ? 32 : 18),
              children: [
                DuolingoPageHeader(
                  title: 'সেটিংস',
                  subtitle: 'শেখার অভিজ্ঞতা নিজের মতো সাজাও',
                  iconType: VectorIconType.shield,
                  gradientColors: const [Color(0xFF0D7377), Color(0xFF159A8C)],
                  onBack: () => Navigator.pop(context),
                ),
                _SettingsSection(
                  title: 'প্রোফাইল ও অ্যাকাউন্ট',
                  child: Column(children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFDDF4E9),
                        child: state.userName.isEmpty
                            ? const Icon(Icons.person_rounded,
                                color: AppTheme.primaryGreen)
                            : LocalizedText(
                                state.userName.substring(0, 1),
                                style: const TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w800),
                              ),
                      ),
                      title: LocalizedText(
                          state.userName.isEmpty
                              ? 'শিক্ষার্থীর প্রোফাইল'
                              : state.userName,
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: LocalizedText(
                          'বয়স ${state.age} · এই ডিভাইসে সংরক্ষিত'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (_) => const ProfileScreen())),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.language_rounded,
                          color: AppTheme.primaryGreen),
                      title: const LocalizedText('অ্যাপের ভাষা',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      trailing: DropdownButton<String>(
                        value: state.selectedLanguage == 'en' ? 'en' : 'bn',
                        items: const [
                          DropdownMenuItem(value: 'bn', child: Text('বাংলা')),
                          DropdownMenuItem(value: 'en', child: Text('English')),
                        ],
                        onChanged: (language) {
                          if (language != null) {
                            context.read<AppState>().updateLanguage(language);
                          }
                        },
                      ),
                    ),
                    const LocalizedText(
                      'ইমেইল/ফোন login ও cloud sync এখনো backend-এ যুক্ত হয়নি।',
                      style: TextStyle(color: Colors.black45, fontSize: 11),
                    ),
                  ]),
                ),
                const SizedBox(height: 13),
                _SettingsSection(
                  title: 'নোটিফিকেশন ও স্ট্রিক রিমাইন্ডার',
                  child: Column(children: [
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: state.streakAlertsEnabled,
                      activeColor: AppTheme.primaryGreen,
                      title: const LocalizedText('দৈনিক শেখার রিমাইন্ডার',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: const LocalizedText(
                          'স্ট্রিক ধরে রাখতে মনে করিয়ে দেবে',
                          style: TextStyle(fontSize: 11)),
                      onChanged: (value) => context
                          .read<AppState>()
                          .updateNotificationSettings(
                              streakAlertsEnabled: value),
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: state.classAlertsEnabled,
                      activeColor: AppTheme.primaryGreen,
                      title: const LocalizedText('শিক্ষকের ক্লাসের আপডেট',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: const LocalizedText('ক্লাস schedule ও reminder',
                          style: TextStyle(fontSize: 11)),
                      onChanged: (value) => context
                          .read<AppState>()
                          .updateNotificationSettings(
                              classAlertsEnabled: value),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.alarm_rounded,
                          color: AppTheme.primaryGreen),
                      title: const LocalizedText('রিমাইন্ডারের সময়',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: LocalizedText(_formatTime(state.reminderTime)),
                      trailing: const Icon(Icons.edit_rounded, size: 19),
                      onTap: () async {
                        final parts = state.reminderTime.split(':');
                        final initial = TimeOfDay(
                          hour: int.tryParse(parts.first) ?? 19,
                          minute: int.tryParse(parts.last) ?? 0,
                        );
                        final chosen = await showTimePicker(
                            context: context, initialTime: initial);
                        if (chosen != null && context.mounted) {
                          await context
                              .read<AppState>()
                              .updateNotificationSettings(
                                reminderTime:
                                    '${chosen.hour.toString().padLeft(2, '0')}:${chosen.minute.toString().padLeft(2, '0')}',
                              );
                        }
                      },
                    ),
                    const LocalizedText(
                      'এই preview-তে পছন্দগুলো সংরক্ষিত হয়। ফোনে নির্দিষ্ট সময়ে push/local alert পাঠাতে notification service এখনো যুক্ত করতে হবে।',
                      style: TextStyle(
                          color: Colors.black45, fontSize: 11, height: 1.5),
                    ),
                  ]),
                ),
                const SizedBox(height: 13),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF0D7377), Color(0xFF159A8C)]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(children: [
                    CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.credit_card_rounded,
                            color: Colors.white, size: 27)),
                    SizedBox(width: 13),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          LocalizedText('Subscription ও পেমেন্ট',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900)),
                          SizedBox(height: 4),
                          LocalizedText(
                              'শিক্ষকের সঙ্গে live class-এর মাসিক পরিকল্পনা',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ])),
                  ]),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Expanded(
                              child: LocalizedText('শিক্ষক-সহ মাসিক পরিকল্পনা',
                                  style: TextStyle(
                                      color: AppTheme.darkText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900))),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 5),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBCF),
                                  borderRadius: BorderRadius.circular(20)),
                              child: const LocalizedText('শিগগিরই',
                                  style: TextStyle(
                                      color: Color(0xFF9A6500),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800))),
                        ]),
                        const SizedBox(height: 12),
                        const _PlanLine(
                            icon: Icons.menu_book_rounded,
                            text: 'কুরআন তিলাওয়াত অথবা মৌলিক ইসলাম শিক্ষা'),
                        const _PlanLine(
                            icon: Icons.video_call_rounded,
                            text: 'শিক্ষকের সঙ্গে app-এর ভেতর live class'),
                        const _PlanLine(
                            icon: Icons.calendar_month_rounded,
                            text: 'মাসিক subscription ও class schedule'),
                        const SizedBox(height: 13),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF7F3E9),
                              borderRadius: BorderRadius.circular(15)),
                          child: const LocalizedText(
                              'মাসিক মূল্য, class সংখ্যা ও সময়সূচি শিক্ষক/প্রতিষ্ঠান নির্ধারণ করলে এখানে দেখানো হবে। এখনো কোনো টাকা কাটা হবে না।',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 11,
                                  height: 1.6)),
                        ),
                      ]),
                ),
                const SizedBox(height: 13),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LocalizedText('পেমেন্ট পদ্ধতি',
                            style: TextStyle(
                                color: AppTheme.darkText,
                                fontSize: 16,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        const _PaymentMethod(
                            icon: Icons.account_balance_wallet_rounded,
                            title: 'মোবাইল ওয়ালেট',
                            detail: 'bKash / Nagad সংযোগ বাকি'),
                        const Divider(height: 16),
                        const _PaymentMethod(
                            icon: Icons.credit_card_rounded,
                            title: 'কার্ড বা অনলাইন পেমেন্ট',
                            detail: 'Payment gateway সংযোগ বাকি'),
                        const SizedBox(height: 11),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton.icon(
                            onPressed: () => _showSetupInfo(context),
                            icon: const Icon(Icons.settings_suggest_rounded),
                            label:
                                const LocalizedText('পেমেন্ট সেটআপের অবস্থা'),
                            style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16))),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 14),
                const LocalizedText(
                    'নিরাপত্তার জন্য এই preview-তে card number, mobile wallet PIN বা OTP চাওয়া হয় না। Live payment চালুর আগে merchant account, payment gateway ও subscription backend যুক্ত করতে হবে।',
                    style: TextStyle(
                        color: Colors.black45, fontSize: 11, height: 1.6)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSetupInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const LocalizedText('পেমেন্ট এখনো যুক্ত হয়নি'),
        content: const LocalizedText(
            'মাসিক মূল্য ও subscription নিয়ম ঠিক করে payment merchant account/API key যুক্ত হলে এখান থেকেই নিরাপদ payment flow চালু করা যাবে।'),
        actions: [
          FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const LocalizedText('ঠিক আছে'))
        ],
      ),
    );
  }
}

String _formatTime(String value) {
  final parts = value.split(':');
  final hour = int.tryParse(parts.first) ?? 19;
  final minute = int.tryParse(parts.last) ?? 0;
  final period = hour >= 12 ? 'PM' : 'AM';
  final shownHour = hour % 12 == 0 ? 12 : hour % 12;
  return '$shownHour:${minute.toString().padLeft(2, '0')} $period';
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => DuolingoCard(
        accentColor: AppTheme.primaryGreen,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(17),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LocalizedText(title,
              style: const TextStyle(
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.w900,
                  fontSize: 16)),
          const SizedBox(height: 8),
          child,
        ]),
      );
}

class _PlanLine extends StatelessWidget {
  const _PlanLine({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Row(children: [
          Icon(icon, color: AppTheme.primaryGreen, size: 19),
          const SizedBox(width: 9),
          Expanded(
              child: LocalizedText(text,
                  style: const TextStyle(
                      color: AppTheme.darkText, fontSize: 12, height: 1.4))),
        ]),
      );
}

class _PaymentMethod extends StatelessWidget {
  const _PaymentMethod(
      {required this.icon, required this.title, required this.detail});
  final IconData icon;
  final String title, detail;
  @override
  Widget build(BuildContext context) => Row(children: [
        CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFE8F5E9),
            child: Icon(icon, color: AppTheme.primaryGreen, size: 19)),
        const SizedBox(width: 10),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LocalizedText(title,
              style: const TextStyle(
                  color: AppTheme.darkText,
                  fontSize: 13,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          LocalizedText(detail,
              style: const TextStyle(color: Colors.black54, fontSize: 11)),
        ])),
        const Icon(Icons.hourglass_empty_rounded,
            size: 17, color: Colors.black38),
      ]);
}
