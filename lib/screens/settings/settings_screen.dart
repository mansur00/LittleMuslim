import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_languages.dart';

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
                  title: context.t('settings.title'),
                  subtitle: context.t('settings.subtitle'),
                  iconType: VectorIconType.shield,
                  gradientColors: const [Color(0xFF58CC02), Color(0xFF46A302)],
                  onBack: () => Navigator.pop(context),
                ),
                _SettingsSection(
                  title: context.t('profile.title'),
                  child: Column(children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const FacelessSilhouette(
                        size: 44,
                        circleBackground: true,
                      ),
                      title: Text(
                          state.userName.isEmpty
                              ? context.t('settings.learner_profile')
                              : state.userName,
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: Text(context.t('settings.age_device_saved',
                          params: {'age': context.formatNumber(state.age)})),
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
                      title: Text(context.t('avatar.modal_title'),
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: Text(
                        state.avatarType == 'hijab'
                            ? context.t('settings.avatar_hijab_subtitle')
                            : context.t('settings.avatar_topi_subtitle'),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => showAvatarCustomizerModal(context),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.language_rounded,
                          color: AppTheme.primaryGreen),
                      title: Text(context.t('settings.language'),
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      trailing: DropdownButton<String>(
                        value: ['bn', 'en', 'hi', 'it'].contains(state.selectedLanguage)
                            ? state.selectedLanguage
                            : 'bn',
                        items: AppLanguages.all
                            .map((lang) => DropdownMenuItem(
                                  value: lang.code,
                                  child: Text(lang.name),
                                ))
                            .toList(),
                        onChanged: (language) {
                          if (language != null) {
                            context.read<AppState>().updateLanguage(language);
                          }
                        },
                      ),
                    ),
                    Text(
                      context.t('settings.cloud_sync_notice'),
                      style: const TextStyle(color: Colors.black45, fontSize: 11),
                    ),
                  ]),
                ),
                const SizedBox(height: 13),
                _SettingsSection(
                  title: context.t('settings.prayer_adhan_section'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: state.prayerAlertsEnabled,
                        activeThumbColor: AppTheme.primaryGreen,
                        title: Text(context.t('settings.prayer_adhan_toggle_title'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 14)),
                        subtitle: Text(
                            context.t('settings.prayer_adhan_toggle_subtitle'),
                            style: const TextStyle(fontSize: 11)),
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
                        Text(
                          context.t('settings.select_prayer_adhan'),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.darkText),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final entry in [
                              ('Fajr', context.t('prayer.fajr')),
                              ('Dhuhr', context.t('prayer.dhuhr')),
                              ('Asr', context.t('prayer.asr')),
                              ('Maghrib', context.t('prayer.maghrib')),
                              ('Isha', context.t('prayer.isha')),
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
                                          ? context.t('settings.stop_adhan')
                                          : context.t('settings.test_adhan'),
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
                  title: context.t('settings.alarm_streak_section'),
                  child: Column(children: [
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: state.learningAlarmEnabled,
                      activeThumbColor: AppTheme.primaryGreen,
                      title: Text(
                          context.t('settings.learning_alarm_title'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: Text(
                          context.t('settings.learning_alarm_subtitle'),
                          style: const TextStyle(fontSize: 11)),
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
                        title: Text(context.t('settings.learning_alarm_time_label'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 14)),
                        subtitle: Text(
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
                                          ? context.t('settings.stop_learning_alarm')
                                          : context.t('settings.test_learning_alarm'),
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
                      title: Text(context.t('settings.daily_streak_reminder_title'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: Text(
                          context.t('settings.daily_streak_reminder_subtitle'),
                          style: const TextStyle(fontSize: 11)),
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
                      title: Text(context.t('settings.teacher_class_updates_title'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: Text(context.t('settings.teacher_class_updates_subtitle'),
                          style: const TextStyle(fontSize: 11)),
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
                      title: Text(context.t('settings.streak_reminder_time_label'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: Text(_formatTime(state.reminderTime)),
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
                    Text(
                      context.t('settings.reminder_device_footer'),
                      style: const TextStyle(
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
                  child: Row(children: [
                    const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.credit_card_rounded,
                            color: Colors.white, size: 27)),
                    const SizedBox(width: 13),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(context.t('payment.subscription_title'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text(
                              context.t('payment.live_class_plan_subtitle'),
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 12)),
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
                          Expanded(
                              child: Text(context.t('payment.plan_with_teacher'),
                                  style: const TextStyle(
                                      color: AppTheme.darkText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900))),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 5),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBCF),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(context.t('payment.coming_soon'),
                                  style: const TextStyle(
                                      color: Color(0xFF9A6500),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800))),
                        ]),
                        const SizedBox(height: 12),
                        _PlanLine(
                            icon: Icons.menu_book_rounded,
                            text: context.t('payment.feature_quran_or_basics')),
                        _PlanLine(
                            icon: Icons.video_call_rounded,
                            text: context.t('payment.feature_live_class')),
                        _PlanLine(
                            icon: Icons.calendar_month_rounded,
                            text: context.t('payment.feature_monthly_schedule')),
                        const SizedBox(height: 13),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF7F3E9),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                              context.t('payment.pricing_notice'),
                              style: const TextStyle(
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
                        Text(context.t('payment.payment_methods_title'),
                            style: const TextStyle(
                                color: AppTheme.darkText,
                                fontSize: 16,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        _PaymentMethod(
                            icon: Icons.account_balance_wallet_rounded,
                            title: context.t('payment.mobile_wallet_title'),
                            detail: context.t('payment.mobile_wallet_detail')),
                        const Divider(height: 16),
                        _PaymentMethod(
                            icon: Icons.credit_card_rounded,
                            title: context.t('payment.card_payment_title'),
                            detail: context.t('payment.card_payment_detail')),
                        const SizedBox(height: 11),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton.icon(
                            onPressed: () => _showSetupInfo(context),
                            icon: const Icon(Icons.settings_suggest_rounded),
                            label:
                                Text(context.t('payment.setup_status_btn')),
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
                  title: context.t('settings.privacy_data_section'),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.privacy_tip_rounded,
                            color: AppTheme.primaryGreen),
                        title: Text(context.t('settings.privacy'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 14)),
                        subtitle: Text(
                            context.t('settings.child_privacy_subtitle'),
                            style: const TextStyle(fontSize: 11)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                        onTap: () => _showPrivacyPolicy(context),
                      ),
                      const Divider(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.delete_forever_rounded,
                            color: AppTheme.accentCoral),
                        title: Text(context.t('settings.reset_all_data_title'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: AppTheme.accentCoral)),
                        subtitle: Text(
                            context.t('settings.reset_all_data_subtitle'),
                            style: const TextStyle(fontSize: 11)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                        onTap: () => _confirmResetData(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                    context.t('payment.security_note'),
                    style: const TextStyle(
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
        title: Text(context.t('settings.privacy')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.t('settings.privacy_bullet_1')}\n'
                '${context.t('settings.privacy_bullet_2')}\n'
                '${context.t('settings.privacy_bullet_3')}\n'
                '${context.t('settings.privacy_bullet_4')}',
                style: const TextStyle(fontSize: 13, height: 1.6),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.t('common.ok')),
          ),
        ],
      ),
    );
  }

  void _confirmResetData(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.t('settings.reset_dialog_title')),
        content: Text(
          context.t('settings.reset_dialog_body'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.t('common.cancel')),
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
                SnackBar(
                  content: Text(context.t('settings.reset_success_snack')),
                ),
              );
            },
            child: Text(context.t('common.delete')),
          ),
        ],
      ),
    );
  }

  void _showSetupInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t('payment.not_connected_dialog_title')),
        content: Text(context.t('payment.not_connected_dialog_body')),
        actions: [
          FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.t('common.ok')))
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
          Text(title,
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
              child: Text(text,
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
          Text(title,
              style: const TextStyle(
                  color: AppTheme.darkText,
                  fontSize: 13,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(detail,
              style: const TextStyle(color: Colors.black54, fontSize: 11)),
        ])),
        const Icon(Icons.hourglass_empty_rounded,
            size: 17, color: Colors.black38),
      ]);
}
