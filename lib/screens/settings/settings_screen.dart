import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/faceless_silhouette.dart';
import '../../services/notification_service.dart';
import '../../services/alert_sound_service.dart';
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
                  gradientColors: const [Color(0xFF58CC02), Color(0xFF46A302)],
                  onBack: () => Navigator.pop(context),
                ),
                _SettingsSection(
                  title: 'প্রোফাইল ও অ্যাকাউন্ট',
                  child: Column(children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const FacelessSilhouette(
                        size: 44,
                        circleBackground: true,
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
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(state.avatarColor).withValues(alpha: 0.15),
                        ),
                        child: Icon(
                          Icons.palette_rounded,
                          color: Color(state.avatarColor),
                        ),
                      ),
                      title: const LocalizedText('অবতার ও রঙ নির্বাচন',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: LocalizedText(
                        state.avatarType == 'hijab'
                            ? 'হিজাব অবতার · রঙ পরিবর্তন করুন'
                            : 'টুপি অবতার · রঙ পরিবর্তন করুন',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => showAvatarCustomizerModal(context),
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
                  title: 'নামাজের আযান অ্যালার্ট',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: state.prayerAlertsEnabled,
                        activeThumbColor: AppTheme.primaryGreen,
                        title: const LocalizedText('নামাজের সময় আযান বাজবে',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 14)),
                        subtitle: const LocalizedText(
                            'ওয়াক্ত হলে সুমধুর আযানের অ্যালার্ট ও নোটিফিকেশন আসবে',
                            style: TextStyle(fontSize: 11)),
                        onChanged: (value) async {
                          final appState = context.read<AppState>();
                          if (value) {
                            await NotificationService.instance
                                .requestPermissions();
                          }
                          await appState.updatePrayerAlertSettings(
                              masterEnabled: value);
                        },
                      ),
                      if (state.prayerAlertsEnabled) ...[
                        const SizedBox(height: 6),
                        const LocalizedText(
                          'ওয়াক্ত অনুযায়ী আযান নির্বাচন:',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.darkText),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final entry in const [
                              ('Fajr', 'ফজর'),
                              ('Dhuhr', 'যোহর'),
                              ('Asr', 'আসর'),
                              ('Maghrib', 'মাগরিব'),
                              ('Isha', 'ইশা'),
                            ])
                              FilterChip(
                                label: Text(entry.$2),
                                selected: state.isPrayerAlertEnabled(entry.$1),
                                onSelected: (selected) {
                                  context
                                      .read<AppState>()
                                      .updatePrayerAlertSettings(
                                        prayerKey: entry.$1,
                                        prayerEnabled: selected,
                                      );
                                },
                                selectedColor: const Color(0xFFE8F5E9),
                                checkmarkColor: AppTheme.primaryGreen,
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: state.isPrayerAlertEnabled(entry.$1)
                                      ? AppTheme.primaryGreen
                                      : Colors.black54,
                                ),
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      ValueListenableBuilder<AlertSoundType?>(
                        valueListenable:
                            AlertSoundService.instance.currentPlayingNotifier,
                        builder: (context, playingType, _) {
                          final isPlaying =
                              playingType == AlertSoundType.adhan;
                          return InkWell(
                            onTap: () =>
                                AlertSoundService.instance.playAdhan(),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isPlaying
                                    ? const Color(0xFFFEE2E2)
                                    : const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isPlaying
                                      ? const Color(0xFFFCA5A5)
                                      : const Color(0xFF86EFAC),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPlaying
                                        ? Icons.stop_circle_rounded
                                        : Icons.play_circle_fill_rounded,
                                    color: isPlaying
                                        ? const Color(0xFFDC2626)
                                        : const Color(0xFF16A34A),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      isPlaying
                                          ? 'আযান থামান'
                                          : 'আযান টেস্ট করুন / শুনুন',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                        color: isPlaying
                                            ? const Color(0xFFDC2626)
                                            : const Color(0xFF16A34A),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                _SettingsSection(
                  title: 'পড়ার অ্যালার্ম ও স্ট্রিক রিমাইন্ডার',
                  child: Column(children: [
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: state.learningAlarmEnabled,
                      activeThumbColor: AppTheme.primaryGreen,
                      title: const LocalizedText(
                          'দৈনিক পড়ার অ্যালার্ম (আউযুবিল্লাহ ও বিসমিল্লাহ)',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: const LocalizedText(
                          'নির্ধারিত সময়ে আউযুবিল্লাহ ও বিসমিল্লাহ পড়ে পড়ার জন্য ডাকবে',
                          style: TextStyle(fontSize: 11)),
                      onChanged: (value) async {
                        final appState = context.read<AppState>();
                        if (value) {
                          await NotificationService.instance
                              .requestPermissions();
                        }
                        await appState.updateLearningAlarmSettings(
                            enabled: value);
                        await NotificationService.instance
                            .syncWithAppState(appState);
                      },
                    ),
                    if (state.learningAlarmEnabled) ...[
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.alarm_rounded,
                            color: AppTheme.primaryGreen),
                        title: const LocalizedText('পড়ার অ্যালার্মের সময়',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 14)),
                        subtitle: LocalizedText(
                            _formatTime(state.learningAlarmTime)),
                        trailing: const Icon(Icons.edit_rounded, size: 19),
                        onTap: () async {
                          final appState = context.read<AppState>();
                          final parts = state.learningAlarmTime.split(':');
                          final initial = TimeOfDay(
                            hour: int.tryParse(parts.first) ?? 17,
                            minute: int.tryParse(parts.last) ?? 30,
                          );
                          final chosen = await showTimePicker(
                              context: context, initialTime: initial);
                          if (chosen != null) {
                            final newTime =
                                '${chosen.hour.toString().padLeft(2, '0')}:${chosen.minute.toString().padLeft(2, '0')}';
                            await appState.updateLearningAlarmSettings(
                              time: newTime,
                            );
                            await NotificationService.instance
                                .syncWithAppState(appState);
                          }
                        },
                      ),
                      const SizedBox(height: 4),
                      ValueListenableBuilder<AlertSoundType?>(
                        valueListenable:
                            AlertSoundService.instance.currentPlayingNotifier,
                        builder: (context, playingType, _) {
                          final isPlaying =
                              playingType == AlertSoundType.learningAlarm;
                          return InkWell(
                            onTap: () => AlertSoundService.instance
                                .playLearningAlarm(),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isPlaying
                                    ? const Color(0xFFFEE2E2)
                                    : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isPlaying
                                      ? const Color(0xFFFCA5A5)
                                      : const Color(0xFFFCD34D),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPlaying
                                        ? Icons.stop_circle_rounded
                                        : Icons.play_circle_fill_rounded,
                                    color: isPlaying
                                        ? const Color(0xFFDC2626)
                                        : const Color(0xFFD97706),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      isPlaying
                                          ? 'পড়ার অ্যালার্ম থামান'
                                          : 'পড়ার অ্যালার্ম টেস্ট করুন (আউযুবিল্লাহ ও বিসমিল্লাহ)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        color: isPlaying
                                            ? const Color(0xFFDC2626)
                                            : const Color(0xFFB45309),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                    const Divider(height: 16),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: state.streakAlertsEnabled,
                      activeThumbColor: AppTheme.primaryGreen,
                      title: const LocalizedText('দৈনিক স্ট্রিক রিমাইন্ডার',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: const LocalizedText(
                          'স্ট্রিক ধরে রাখতে মনে করিয়ে দেবে',
                          style: TextStyle(fontSize: 11)),
                      onChanged: (value) async {
                        final appState = context.read<AppState>();
                        if (value) {
                          await NotificationService.instance
                              .requestPermissions();
                        }
                        await appState.updateNotificationSettings(
                            streakAlertsEnabled: value);
                        await NotificationService.instance
                            .syncWithAppState(appState);
                      },
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: state.classAlertsEnabled,
                      activeThumbColor: AppTheme.primaryGreen,
                      title: const LocalizedText('শিক্ষকের ক্লাসের আপডেট',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: const LocalizedText('ক্লাস schedule ও reminder',
                          style: TextStyle(fontSize: 11)),
                      onChanged: (value) async {
                        final appState = context.read<AppState>();
                        if (value) {
                          await NotificationService.instance
                              .requestPermissions();
                        }
                        await appState.updateNotificationSettings(
                            classAlertsEnabled: value);
                        await NotificationService.instance
                            .syncWithAppState(appState);
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.alarm_rounded,
                          color: AppTheme.primaryGreen),
                      title: const LocalizedText('স্ট্রিক রিমাইন্ডারের সময়',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: LocalizedText(_formatTime(state.reminderTime)),
                      trailing: const Icon(Icons.edit_rounded, size: 19),
                      onTap: () async {
                        final appState = context.read<AppState>();
                        final parts = state.reminderTime.split(':');
                        final initial = TimeOfDay(
                          hour: int.tryParse(parts.first) ?? 19,
                          minute: int.tryParse(parts.last) ?? 0,
                        );
                        final chosen = await showTimePicker(
                            context: context, initialTime: initial);
                        if (chosen != null) {
                          final newTime =
                              '${chosen.hour.toString().padLeft(2, '0')}:${chosen.minute.toString().padLeft(2, '0')}';
                          await appState.updateNotificationSettings(
                            reminderTime: newTime,
                          );
                          await NotificationService.instance
                              .syncWithAppState(appState);
                        }
                      },
                    ),
                    const LocalizedText(
                      'নির্ধারিত সময়ে আপনার ডিভাইসে দৈনিক পড়ার রিমাইন্ডার পৌঁছে যাবে।',
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
                        colors: [Color(0xFF58CC02), Color(0xFF46A302)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF46A302).withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
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
                _SettingsSection(
                  title: 'প্রাইভেসি ও ডেটা নিয়ন্ত্রণ',
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.privacy_tip_rounded,
                            color: AppTheme.primaryGreen),
                        title: const LocalizedText('শিশু প্রাইভেসি নীতি',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 14)),
                        subtitle: const LocalizedText(
                            'LittleMuslim কোনো ব্যক্তিগত তথ্য সংগ্রহ বা ট্র্যাক করে না',
                            style: TextStyle(fontSize: 11)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                        onTap: () => _showPrivacyPolicy(context),
                      ),
                      const Divider(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.delete_forever_rounded,
                            color: AppTheme.accentCoral),
                        title: const LocalizedText('সব অগ্রগতি ও ডেটা মুছুন',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: AppTheme.accentCoral)),
                        subtitle: const LocalizedText(
                            'ডিভাইসে সংরক্ষিত সব শিক্ষা ও স্কোর মুছে ফেলা হবে',
                            style: TextStyle(fontSize: 11)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                        onTap: () => _confirmResetData(context),
                      ),
                    ],
                  ),
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

  void _showPrivacyPolicy(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const LocalizedText('শিশু প্রাইভেসি নীতি'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocalizedText(
                '• LittleMuslim শিশুদের কোনো ব্যক্তিগত সংবেদনশীল তথ্য সার্ভারে সংগ্রহ করে না।\n'
                '• শেখার যাবতীয় অগ্রগতি (XP, কায়দা ও দুআ পড়া) স্থানীয়ভাবে ডিভাইসে সংরক্ষিত থাকে।\n'
                '• নামাজের সময় নির্ধারণের জন্য শুধুমাত্র আল-আধান এপিআই-তে জিপিএস স্থানাঙ্ক পাঠানো হয়।\n'
                '• কোনো তৃতীয় পক্ষের ট্র্যাকার বা অনাকাঙ্ক্ষিত বিজ্ঞাপন অ্যাপে নেই।',
                style: TextStyle(fontSize: 13, height: 1.6),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const LocalizedText('ঠিক আছে'),
          ),
        ],
      ),
    );
  }

  void _confirmResetData(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const LocalizedText('সব ডেটা মুছে ফেলবেন?'),
        content: const LocalizedText(
          'আপনার অর্জিত XP, স্ট্রিক, পড়া পাঠের অগ্রগতি এবং সংরক্ষণ করা বুকমার্ক সব মুছে যাবে।',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const LocalizedText('বাতিল'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.accentCoral,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<AppState>().resetOnboarding();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: LocalizedText('সব ডেটা সফলভাবে মুছে ফেলা হয়েছে।'),
                ),
              );
            },
            child: const LocalizedText('মুছে ফেলুন'),
          ),
        ],
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
          Material(type: MaterialType.transparency, child: child),
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
