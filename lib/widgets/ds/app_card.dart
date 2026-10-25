import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// AppCard: Unified container card strictly utilizing Design System tokens.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.insetLg,
    this.margin = AppSpacing.insetNone,
    this.color = AppColors.surfaceCard,
    this.borderColor = AppColors.border,
    this.borderWidth = AppStroke.regular,
    this.borderRadius = AppRadius.borderLg,
    this.boxShadow = AppElevation.shadowCard,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: borderWidth > 0
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        boxShadow: boxShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: content,
      );
    }

    return content;
  }
}
