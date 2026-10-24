import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/faceless_silhouette.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late int _age;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _nameController = TextEditingController(text: state.userName);
    _age = state.age;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: EdgeInsets.all(tablet ? 32 : 18),
              children: [
                DuolingoPageHeader(
                  title: context.t('profile.title'),
                  subtitle: context.t('profile.subtitle'),
                  iconType: VectorIconType.smile,
                  gradientColors: const [Color(0xFF58CC02), Color(0xFF46A302)],
                  onBack: () => Navigator.pop(context),
                ),
                Container(
                  padding: const EdgeInsets.all(21),
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
                    GestureDetector(
                      onTap: () => showAvatarCustomizerModal(context),
                      child: Tooltip(
                        message: context.t('avatar.customize_tooltip'),
                        child: Stack(
                          children: [
                            const FacelessSilhouette(
                              size: 62,
                              circleBackground: true,
                              backgroundColor: Colors.white,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFFD54F),
                                ),
                                child: const Icon(Icons.edit, size: 12, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(
                              state.userName.isEmpty
                                  ? context.t('profile.default_learner')
                                  : state.userName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900)),
                          Text(
                              context.t('profile.streak_xp', params: {
                                'streak': '${state.streakDays}',
                                'xp': '${state.xp}',
                              }),
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ])),
                  ]),
                ),
                const SizedBox(height: 14),
                // User Mode Switcher (Admin / Regular Child)
                DuolingoCard(
                  accentColor: state.isAdmin ? const Color(0xFFF59E0B) : AppTheme.primaryGreen,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            state.isAdmin
                                ? Icons.admin_panel_settings_rounded
                                : Icons.child_care_rounded,
                            color: state.isAdmin ? const Color(0xFFD97706) : AppTheme.primaryGreen,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.isAdmin
                                      ? context.t('profile.admin_mode_title')
                                      : context.t('profile.learner_mode_title'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    color: state.isAdmin ? const Color(0xFFB45309) : AppTheme.darkText,
                                  ),
                                ),
                                Text(
                                  state.isAdmin
                                      ? context.t('profile.admin_mode_desc')
                                      : context.t('profile.learner_mode_desc'),
                                  style: const TextStyle(color: Colors.black54, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: DSButton(
                              label: state.isAdmin
                                  ? context.t('profile.switch_to_learner')
                                  : context.t('profile.switch_to_admin'),
                              icon: state.isAdmin
                                  ? Icons.swap_horiz_rounded
                                  : Icons.lock_open_rounded,
                              variant: state.isAdmin
                                  ? DSButtonVariant.gold
                                  : DSButtonVariant.outline,
                              onPressed: () async {
                                await state.toggleAdminMode();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        state.isAdmin
                                            ? context.t('profile.admin_enabled_snack')
                                            : context.t('profile.learner_enabled_snack'),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: state.isAdmin
                                          ? const Color(0xFFD97706)
                                          : AppTheme.primaryGreen,
                                    ),
                                  );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                DuolingoCard(
                  accentColor: AppTheme.primaryGreen,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.t('profile.learner_info'),
                            style: const TextStyle(
                                color: AppTheme.darkText,
                                fontSize: 16,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 13),
                        TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              labelText: context.t('profile.name_label'),
                              prefixIcon: const Icon(Icons.person_outline_rounded)),
                        ),
                        const SizedBox(height: 13),
                        DropdownButtonFormField<int>(
                          initialValue: _age,
                          decoration: InputDecoration(
                              labelText: context.t('profile.age_label'),
                              prefixIcon: const Icon(Icons.cake_outlined)),
                          items: [
                            for (var age = 6; age <= 14; age++)
                              DropdownMenuItem(
                                  value: age,
                                  child: Text(context.t('profile.age_years', params: {'age': '$age'})))
                          ],
                          onChanged: (value) {
                            if (value != null) setState(() => _age = value);
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: () async {
                              await context.read<AppState>().updateProfile(
                                  name: _nameController.text, age: _age);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          context.t('profile.saved_snack'))));
                            },
                            icon: const Icon(Icons.check_rounded),
                            label: Text(context.t('profile.save_button')),
                            style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 14),
                DuolingoCard(
                  accentColor: const Color(0xFF58CC02),
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(17),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.verified_user_rounded,
                              color: AppTheme.primaryGreen),
                          const SizedBox(width: 9),
                          Text(context.t('profile.login_sync_title'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15))
                        ]),
                        const SizedBox(height: 8),
                        Text(
                            context.t('profile.login_sync_desc'),
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                height: 1.55)),
                      ]),
                ),
                const SizedBox(height: 12),
                DSButton(
                  label: context.t('profile.login_action'),
                  icon: Icons.login_rounded,
                  variant: DSButtonVariant.outline,
                  onPressed: () =>
                      Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => const LoginScreen(),
                  )),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      await context.read<AppState>().resetOnboarding();
                      if (!context.mounted) return;
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 16, color: Colors.black45),
                    label: Text(
                      context.t('profile.reset_onboarding'),
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
