import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// AppDialog: Standard modal dialog adhering strictly to tokens.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.icon,
  });

  final String title;
  final Widget content;
  final List<Widget>? actions;
  final Widget? icon;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    Widget? icon,
  }) {
    return showDialog<T>(
      context: context,
      builder: (ctx) => AppDialog(
        title: title,
        content: content,
        actions: actions,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
      child: Padding(
        padding: AppSpacing.insetXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (icon != null) ...[
              Center(child: icon!),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(
              title,
              style: AppTextStyles.title(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(child: SingleChildScrollView(child: content)),
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .map((a) => Padding(
                          padding: const EdgeInsets.only(left: AppSpacing.sm),
                          child: a,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
