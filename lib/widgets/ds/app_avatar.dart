import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../utils/app_state.dart';

/// AppAvatar: Unified avatar component for Little Muslim.
/// Displays the child's customized avatar (topi boy or hijab girl) with a clean,
/// consistent size and at most a thin hairline border.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.avatarType,
    this.avatarColor,
    this.size = AppSizes.avatarMd,
    this.hasBorder = true,
    this.onTap,
  });

  final String? avatarType;
  final Color? avatarColor;
  final double size;
  final bool hasBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    String type = avatarType ?? 'topi';
    Color bg = avatarColor ?? AppColors.brandPrimary;

    if (avatarType == null || avatarColor == null) {
      try {
        final state = context.watch<AppState>();
        type = avatarType ?? state.avatarType;
        bg = avatarColor ?? Color(state.avatarColor);
      } catch (_) {}
    }

    final isHijab = type == 'hijab';
    final imageAsset = isHijab
        ? 'assets/images/silhouette_hijab.png'
        : 'assets/images/silhouette_topi.png';

    Widget avatarWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: hasBorder
            ? Border.all(
                color: AppColors.border,
                width: AppStroke.hairline,
              )
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        imageAsset,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            isHijab ? Icons.face_3_rounded : Icons.person_rounded,
            size: size * 0.6,
            color: AppColors.textInverse,
          );
        },
      ),
    );

    if (onTap != null) {
      avatarWidget = InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }
}
