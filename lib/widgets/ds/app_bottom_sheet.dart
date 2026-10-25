import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// AppBottomSheet: Standard bottom sheet modal with drag handle and responsive constraints.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.trailing,
  });

  final Widget child;
  final String? title;
  final Widget? trailing;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    Widget? trailing,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      builder: (ctx) => AppBottomSheet(
        title: title,
        trailing: trailing,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle pill
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
                width: 36,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.borderStrong,
                  borderRadius: AppRadius.borderPill,
                ),
              ),
            ),
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: AppTextStyles.title(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
              ),
              const Divider(color: AppColors.divider, height: 1),
            ],
            Padding(
              padding: AppSpacing.insetLg,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
