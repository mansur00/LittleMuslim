import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// AppProgressBar: Accessible and animated progress indicator.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.progress,
    this.height = AppSpacing.sm,
    this.backgroundColor = AppColors.surfaceSubtle,
    this.progressColor = AppColors.brandPrimary,
  });

  final double progress; // 0.0 to 1.0
  final double height;
  final Color backgroundColor;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.borderPill,
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: clamped,
        child: Container(
          decoration: BoxDecoration(
            color: progressColor,
            borderRadius: AppRadius.borderPill,
          ),
        ),
      ),
    );
  }
}
