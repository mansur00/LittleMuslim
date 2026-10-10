import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/vector_icons.dart';

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
          // Vector mascot circle
          Container(
            width: isTablet ? 200 : 150,
            height: isTablet ? 200 : 150,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D7377), Color(0xFF14919B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.35),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Center(
              child: VectorIcon(
                type: VectorIconType.crescent,
                size: isTablet ? 100 : 76,
                color: Colors.white,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.75, 0.75), curve: Curves.easeOutBack),

          SizedBox(height: isTablet ? 40 : 30),

          Text(
            'LittleMuslim',
            style: TextStyle(
              fontSize: isTablet ? 40 : 30,
              fontWeight: FontWeight.w900,
              color: AppTheme.primaryGreen,
              letterSpacing: -0.8,
            ),
          )
              .animate()
              .fadeIn(delay: 150.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0),

          SizedBox(height: isTablet ? 12 : 8),

          Text(
            'কুরআন শেখো · মজার সাথে · ইসলাম জানো',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: AppTheme.darkText.withValues(alpha: 0.65),
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          )
              .animate()
              .fadeIn(delay: 280.ms, duration: 500.ms),

          SizedBox(height: isTablet ? 40 : 28),

          // Feature chips with vector icons
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _FeatureChip(
                type: VectorIconType.book,
                label: 'কুরআন',
                color: const Color(0xFFE8913A),
                bg: const Color(0xFFFFF0DB),
                isTablet: isTablet,
              ),
              _FeatureChip(
                type: VectorIconType.qaida,
                label: 'ক্বায়দা',
                color: const Color(0xFF58A700),
                bg: const Color(0xFFE8F8D8),
                isTablet: isTablet,
              ),
              _FeatureChip(
                type: VectorIconType.mosque,
                label: 'নামাজ',
                color: const Color(0xFF3B82C4),
                bg: const Color(0xFFDCEBFF),
                isTablet: isTablet,
              ),
              _FeatureChip(
                type: VectorIconType.dua,
                label: 'দোয়া',
                color: const Color(0xFF9B6BC9),
                bg: const Color(0xFFF3E8FF),
                isTablet: isTablet,
              ),
              _FeatureChip(
                type: VectorIconType.scroll,
                label: 'সীরাত',
                color: const Color(0xFFE05A7A),
                bg: const Color(0xFFFFE8EE),
                isTablet: isTablet,
              ),
            ],
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 550.ms)
              .slideY(begin: 0.12, end: 0),

          SizedBox(height: isTablet ? 48 : 36),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 20 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                shadowColor: AppTheme.primaryGreen.withValues(alpha: 0.4),
              ),
              child: Text(
                'শুরু করি',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 550.ms, duration: 500.ms)
              .slideY(begin: 0.25, end: 0),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final VectorIconType type;
  final String label;
  final Color color;
  final Color bg;
  final bool isTablet;

  const _FeatureChip({
    required this.type,
    required this.label,
    required this.color,
    required this.bg,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 14 : 11,
        vertical: isTablet ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VectorIcon(type: type, size: isTablet ? 20 : 17, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 13 : 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkText,
            ),
          ),
        ],
      ),
    );
  }
}
