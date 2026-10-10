import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class WelcomePage extends StatelessWidget {
  final bool isTablet;
  final VoidCallback onNext;

  const WelcomePage({
    super.key,
    required this.isTablet,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 64 : 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo / Illustration placeholder
          Container(
            width: isTablet ? 220 : 160,
            height: isTablet ? 220 : 160,
            decoration: BoxDecoration(
              color: AppTheme.softGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '🌙',
                style: TextStyle(fontSize: isTablet ? 90 : 70),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),

          SizedBox(height: isTablet ? 48 : 36),

          // App Name
          Text(
            'LittleMuslim',
            style: TextStyle(
              fontSize: isTablet ? 42 : 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
              letterSpacing: -0.5,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0),

          SizedBox(height: isTablet ? 16 : 12),

          // Tagline
          Text(
            'কুরআন শেখো • মজার সাথে • ইসলাম জানো',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 18 : 15,
              color: AppTheme.darkText.withOpacity(0.75),
              height: 1.4,
            ),
          )
              .animate()
              .fadeIn(delay: 350.ms, duration: 500.ms),

          SizedBox(height: isTablet ? 56 : 40),

          // Feature chips
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _FeatureChip(emoji: '📖', label: 'কুরআন', isTablet: isTablet),
              _FeatureChip(emoji: '🎮', label: 'মজার গেম', isTablet: isTablet),
              _FeatureChip(emoji: '🕌', label: 'নামাজ', isTablet: isTablet),
              _FeatureChip(emoji: '✨', label: 'দোয়া', isTablet: isTablet),
              _FeatureChip(emoji: '📜', label: 'সীরাত', isTablet: isTablet),
            ],
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 600.ms)
              .slideY(begin: 0.15, end: 0),

          SizedBox(height: isTablet ? 64 : 48),

          // Start Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 20 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                'শুরু করি ✨',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 700.ms, duration: 500.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isTablet;

  const _FeatureChip({
    required this.emoji,
    required this.label,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: isTablet ? 18 : 15)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 14 : 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkText,
            ),
          ),
        ],
      ),
    );
  }
}
