import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// AppChip: Standard interactive or informational status pill.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.backgroundColor,
    this.borderColor,
    this.labelColor,
    this.onTap,
  });

  final String label;
  final Widget? icon;
  final bool isSelected;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? labelColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ??
        (isSelected ? AppColors.brandLight : AppColors.surfaceSubtle);
    final border = borderColor ??
        (isSelected ? AppColors.borderBrand : AppColors.border);
    final fg = labelColor ??
        (isSelected ? AppColors.textBrand : AppColors.textPrimary);

    Widget content = Container(
      padding: AppSpacing.insetChip,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderPill,
        border: Border.all(color: border, width: AppStroke.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTextStyles.label(context, color: fg),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderPill,
        child: content,
      );
    }

    return content;
  }
}
