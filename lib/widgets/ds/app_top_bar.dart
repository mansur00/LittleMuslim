import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/app_state.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/profile/login_screen.dart';
import '../../screens/onboarding/language_page.dart';
import '../faceless_silhouette.dart';
import 'app_avatar.dart';
import 'app_bottom_sheet.dart';
import 'app_dialog.dart';
import 'app_list_tile.dart';
import 'parental_gate_dialog.dart';

/// AppTopBar: The single, unified top bar for Little Muslim.
/// Provides two variants:
/// - Default constructor [AppTopBar]: Shell variant for main navigation (logo, streak, XP, profile menu).
/// - Named constructor [AppTopBar.page]: Page variant for sub-screens (back button, title, actions).
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.showWordmark = false,
  })  : isPageVariant = false,
        title = null,
        subtitle = null,
        onBack = null,
        actions = null;

  const AppTopBar.page({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.actions,
  })  : isPageVariant = true,
        showWordmark = false;

  final bool isPageVariant;
  final bool showWordmark;
  final String? title;
  final String? subtitle;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size.fromHeight(
        isPageVariant && subtitle != null && subtitle!.isNotEmpty
            ? 88.0
            : AppSizes.topBarHeight,
      );

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = isPageVariant && subtitle != null && subtitle!.isNotEmpty;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: AppStroke.hairline,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: hasSubtitle ? 88.0 : AppSizes.topBarHeight,
            maxHeight: hasSubtitle ? 88.0 : AppSizes.topBarHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: isPageVariant
                ? _buildPageVariant(context)
                : _buildShellVariant(context),
          ),
        ),
      ),
    );
  }

  Widget _buildPageVariant(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (canPop || onBack != null)
          IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
              size: AppSizes.iconLg,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppSizes.touchTargetMin,
              minHeight: AppSizes.touchTargetMin,
            ),
            splashRadius: AppSizes.iconXl,
            onPressed: onBack ?? () => Navigator.maybePop(context),
          )
        else
          const SizedBox(width: AppSpacing.sm),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Builder(
            builder: (context) {
              final showSubtitle = subtitle != null && subtitle!.isNotEmpty;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '',
                    style: AppTextStyles.titleSmall(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (showSubtitle) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        if (actions != null) ...actions!,
      ],
    );
  }

  Widget _buildShellVariant(BuildContext context) {
    AppState? state;
    try {
      state = context.watch<AppState>();
    } catch (_) {}

    final streak = state?.streakDays ?? 0;
    final xp = state?.xp ?? 0;
    final streakStr = context.formatDigits(streak.toString());
    final xpStr = context.formatDigits(xp.toString());

    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 280;
    final isWide = screenWidth >= 600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // App Brand Mark
        _buildBrandLogo(context),

        if ((showWordmark && screenWidth >= 420) || isWide) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Little Muslim',
            style: AppTextStyles.titleSmall(
              context,
              color: AppColors.brandDark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],

        const Spacer(),

        // On very narrow screens (<360px), streak and XP are housed inside the profile menu
        // to guarantee zero RenderFlex overflow across all languages and font scales.
        if (!isCompact) ...[
          // Streak Counter Pill
          Tooltip(
            message: context.t('menu.streak_tooltip', params: {'count': streakStr}),
            child: _TopBarMetricPill(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.orange,
              text: streakStr,
            ),
          ),

          const SizedBox(width: AppSpacing.xs),

          // XP Counter Pill
          Tooltip(
            message: context.t('menu.xp_tooltip', params: {'count': xpStr}),
            child: _TopBarMetricPill(
              icon: Icons.stars_rounded,
              iconColor: AppColors.brandAccentDark,
              text: xpStr,
            ),
          ),

          const SizedBox(width: AppSpacing.sm),
        ],

        // Compact Profile Avatar Entry
        _ProfileMenuButton(
          onTap: () => _openProfileMenu(context),
        ),
      ],
    );
  }

  Widget _buildBrandLogo(BuildContext context) {
    return Container(
      width: AppSizes.avatarSm,
      height: AppSizes.avatarSm,
      decoration: BoxDecoration(
        color: AppColors.brandLight,
        borderRadius: AppRadius.borderMd,
        border: Border.all(
          color: AppColors.borderBrand,
          width: AppStroke.hairline,
        ),
      ),
      child: const Icon(
        Icons.auto_stories_rounded,
        size: AppSizes.iconMd,
        color: AppColors.brandDark,
      ),
    );
  }

  void _openProfileMenu(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 600;
    if (isWide) {
      _showWideProfileDialog(context);
    } else {
      _showNarrowProfileSheet(context);
    }
  }

  void _showNarrowProfileSheet(BuildContext context) {
    AppBottomSheet.show<void>(
      context: context,
      title: context.t('menu.profile'),
      child: const _ProfileMenuContent(),
    );
  }

  void _showWideProfileDialog(BuildContext context) {
    AppDialog.show<void>(
      context: context,
      title: context.t('menu.profile'),
      content: const SizedBox(
        width: 380,
        child: _ProfileMenuContent(),
      ),
    );
  }
}

class _TopBarMetricPill extends StatelessWidget {
  const _TopBarMetricPill({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppSizes.buttonHeightSm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: AppRadius.borderPill,
        border: Border.all(
          color: AppColors.border,
          width: AppStroke.hairline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.iconSm, color: iconColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: AppTextStyles.label(context),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuButton extends StatelessWidget {
  const _ProfileMenuButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderPill,
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppAvatar(
              size: AppSizes.avatarSm,
              hasBorder: true,
            ),
            SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: AppSizes.iconSm,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuContent extends StatelessWidget {
  const _ProfileMenuContent();

  @override
  Widget build(BuildContext context) {
    AppState? state;
    try {
      state = context.watch<AppState>();
    } catch (_) {}

    final name = state?.userName.isNotEmpty == true
        ? state!.userName
        : context.t('menu.learner_title');
    final isAdmin = state?.isAdmin ?? false;

    final streak = state?.streakDays ?? 0;
    final xp = state?.xp ?? 0;
    final streakStr = context.formatDigits(streak.toString());
    final xpStr = context.formatDigits(xp.toString());

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Greeting Header
        Container(
          padding: AppSpacing.insetMd,
          decoration: BoxDecoration(
            color: AppColors.surfaceSubtle,
            borderRadius: AppRadius.borderLg,
            border: Border.all(
              color: AppColors.border,
              width: AppStroke.hairline,
            ),
          ),
          child: Row(
            children: [
              const AppAvatar(
                size: AppSizes.avatarLg,
                hasBorder: true,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('menu.header_greeting'),
                      style: AppTextStyles.caption(context),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      style: AppTextStyles.titleSmall(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isAdmin
                          ? context.t('menu.mode_admin')
                          : context.t('menu.mode_student'),
                      style: AppTextStyles.caption(
                        context,
                        color: isAdmin ? AppColors.warning : AppColors.brandDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        _TopBarMetricPill(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: AppColors.orange,
                          text: streakStr,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _TopBarMetricPill(
                          icon: Icons.stars_rounded,
                          iconColor: AppColors.brandAccentDark,
                          text: xpStr,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Profile & Account
        AppListTile(
          title: context.t('menu.profile'),
          leading: const Icon(
            Icons.account_circle_outlined,
            color: AppColors.brandDark,
            size: AppSizes.iconLg,
          ),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
            );
          },
        ),

        // Choose Avatar & Color
        AppListTile(
          title: context.t('menu.avatar_color'),
          leading: const Icon(
            Icons.palette_outlined,
            color: AppColors.blue,
            size: AppSizes.iconLg,
          ),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          onTap: () {
            Navigator.pop(context);
            showAvatarCustomizerModal(context);
          },
        ),

        // Settings
        AppListTile(
          title: context.t('menu.settings'),
          leading: const Icon(
            Icons.settings_outlined,
            color: AppColors.textSecondary,
            size: AppSizes.iconLg,
          ),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            );
          },
        ),

        // Language Picker
        AppListTile(
          title: context.t('menu.language'),
          leading: const Icon(
            Icons.translate_rounded,
            color: AppColors.purple,
            size: AppSizes.iconLg,
          ),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (pageCtx) => LanguagePage(
                  isTablet: MediaQuery.of(pageCtx).size.width >= 600,
                  onNext: () => Navigator.pop(pageCtx),
                  onBack: () => Navigator.pop(pageCtx),
                ),
              ),
            );
          },
        ),

        // Toggle Admin / Student Mode
        AppListTile(
          title: isAdmin
              ? context.t('menu.mode_student')
              : context.t('menu.mode_admin'),
          leading: Icon(
            isAdmin ? Icons.school_outlined : Icons.admin_panel_settings_outlined,
            color: isAdmin ? AppColors.brandDark : AppColors.warning,
            size: AppSizes.iconLg,
          ),
          trailing: Switch(
            value: isAdmin,
            activeThumbColor: AppColors.brandPrimary,
            onChanged: (val) async {
              if (val) {
                final token = await ParentalGate.verify(context);
                if (token != null) {
                  state?.setUserRole('admin', token: token);
                }
              } else {
                state?.setUserRole('child');
              }
            },
          ),
          onTap: () async {
            if (!isAdmin) {
              final token = await ParentalGate.verify(context);
              if (token != null) {
                state?.setUserRole('admin', token: token);
              }
            } else {
              state?.setUserRole('child');
            }
          },
        ),

        // Help & Support
        AppListTile(
          title: context.t('menu.help'),
          leading: const Icon(
            Icons.help_outline_rounded,
            color: AppColors.textSecondary,
            size: AppSizes.iconLg,
          ),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          onTap: () {
            Navigator.pop(context);
            AppDialog.show<void>(
              context: context,
              title: context.t('menu.help'),
              content: Text(
                'Little Muslim v1.0.0\nLearn Noorani Qaida, Quran, Daily Duas, and Prayer.\nDeveloped with authentic Islamic references and child-safe privacy.',
                style: AppTextStyles.body(context),
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    context.t('menu.close'),
                    style: AppTextStyles.button(context, color: AppColors.brandPrimary),
                  ),
                ),
              ],
            );
          },
        ),

        // Sign In / Sign Out
        AppListTile(
          title: (state?.userName.isNotEmpty == true)
              ? context.t('menu.sign_out')
              : context.t('menu.sign_in'),
          leading: Icon(
            (state?.userName.isNotEmpty == true)
                ? Icons.logout_rounded
                : Icons.login_rounded,
            color: AppColors.brandPrimary,
            size: AppSizes.iconLg,
          ),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ],
    );
  }
}
