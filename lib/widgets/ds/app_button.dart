import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, ghost }

/// AppButton: Unified accessible button adhering strictly to Design System tokens.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  }) : variant = AppButtonVariant.ghost;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide side = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = AppColors.brandPrimary;
        fg = AppColors.textInverse;
        break;
      case AppButtonVariant.secondary:
        bg = AppColors.surface;
        fg = AppColors.textPrimary;
        side = const BorderSide(color: AppColors.border, width: AppStroke.regular);
        break;
      case AppButtonVariant.ghost:
        bg = AppColors.transparent;
        fg = AppColors.textSecondary;
        break;
    }

    Widget child;
    if (isLoading) {
      child = SizedBox(
        width: AppSizes.iconMd,
        height: AppSizes.iconMd,
        child: CircularProgressIndicator(
          strokeWidth: AppStroke.regular,
          valueColor: AlwaysStoppedAnimation<Color>(fg),
        ),
      );
    } else {
      final labelWidget = Text(
        label,
        style: AppTextStyles.button(context, color: fg),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

      child = Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: AppSpacing.sm),
          ],
          if (fullWidth)
            Expanded(child: Center(child: labelWidget))
          else
            labelWidget,
        ],
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: AppSizes.touchTargetMin,
        minWidth: fullWidth ? double.infinity : AppSizes.touchTargetMin,
      ),
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderMd,
          side: side,
        ),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: AppRadius.borderMd,
          child: Padding(
            padding: AppSpacing.insetButton,
            child: child,
          ),
        ),
      ),
    );
  }
}
