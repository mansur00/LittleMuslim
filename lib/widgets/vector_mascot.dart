import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'faceless_silhouette.dart';

enum MascotMood {
  happy,
  waving,
  celebrating,
  studying,
  thinking,
}

/// Shari'ah-compliant Faceless Silhouette Avatar
/// Replaces cartoon face mascots with a respectful faceless Islamic silhouette.
class VectorMascot extends StatelessWidget {
  const VectorMascot({
    super.key,
    this.size = 100,
    this.mood = MascotMood.happy,
    this.showCap = true,
    this.color,
  });

  final double size;
  final MascotMood mood;
  final bool showCap;
  final Color? color;

  SilhouettePose get _pose {
    switch (mood) {
      case MascotMood.studying:
        return SilhouettePose.reading;
      case MascotMood.celebrating:
      case MascotMood.waving:
        return SilhouettePose.celebrating;
      case MascotMood.happy:
      case MascotMood.thinking:
      default:
        return SilhouettePose.portrait;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FacelessSilhouette(
      size: size,
      pose: _pose,
      type: showCap ? SilhouetteType.topi : null,
      color: color,
    );
  }
}

/// Helpful guidance banner with faceless silhouette
class MascotSpeechBanner extends StatelessWidget {
  const MascotSpeechBanner({
    super.key,
    required this.message,
    this.title,
    this.mood = MascotMood.happy,
    this.mascotSize = 78,
  });

  final String message;
  final String? title;
  final MascotMood mood;
  final double mascotSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFDE68A), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFDE68A).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VectorMascot(size: mascotSize, mood: mood),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: LocalizedText(
                        title ?? context.t('mascot.reminder_title'),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LocalizedText(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3E2723),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
