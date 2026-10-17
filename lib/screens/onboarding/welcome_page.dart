import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
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
    final mascotSize = isTablet ? 170.0 : 130.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 64 : 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Speech bubble in Duolingo style
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(DS.rXl),
              border: Border.all(color: DS.border, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('✨', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                LocalizedText(
                  'আসসালামু আলাইকুম! চলো শুরু করি',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: DS.black,
                    color: DS.textPrimary,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.3, end: 0, curve: Curves.easeOutBack),

          const SizedBox(height: 12),

          // 3D Mascot in circular badge
          Container(
            width: mascotSize,
            height: mascotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: DS.green500, width: 4),
              boxShadow: [
                BoxShadow(
                  color: DS.green500.withValues(alpha: 0.30),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                const BoxShadow(
                  color: Color(0xFF46A302),
                  offset: Offset(0, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/mascot_happy.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: CustomPaint(
                    size: Size(80, 80),
                    painter: QuranIllustrationPainter(),
                  ),
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),

          SizedBox(height: isTablet ? 28 : 20),

          LocalizedText(
            'LittleMuslim',
            style: TextStyle(
              fontSize: isTablet ? 38 : 30,
              fontWeight: DS.black,
              color: DS.green600,
              letterSpacing: -0.5,
            ),
          )
              .animate()
              .fadeIn(delay: 150.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 6),

          LocalizedText(
            'কুরআন শেখো · মজার সাথে · ইসলাম জানো',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: DS.textSecondary,
              height: 1.4,
              fontWeight: DS.bold,
            ),
          )
              .animate()
              .fadeIn(delay: 280.ms, duration: 500.ms),

          SizedBox(height: isTablet ? 32 : 24),

          // Feature chips with 3D Duolingo style
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _FeatureChip(
                type: VectorIconType.book,
                label: 'কুরআন',
                color: DS.orange500,
                bg: DS.orange100,
                isTablet: isTablet,
              ),
              _FeatureChip(
                type: VectorIconType.qaida,
                label: 'ক্বায়দা',
                color: DS.green500,
                bg: DS.green100,
                isTablet: isTablet,
              ),
              _FeatureChip(
                type: VectorIconType.mosque,
                label: 'নামাজ',
                color: DS.blue500,
                bg: DS.blue100,
                isTablet: isTablet,
              ),
              _FeatureChip(
                type: VectorIconType.dua,
                label: 'দোয়া',
                color: DS.purple500,
                bg: DS.purple100,
                isTablet: isTablet,
              ),
              _FeatureChip(
                type: VectorIconType.scroll,
                label: 'সীরাত',
                color: DS.pink500,
                bg: DS.pink100,
                isTablet: isTablet,
              ),
            ],
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 550.ms)
              .slideY(begin: 0.12, end: 0),

          SizedBox(height: isTablet ? 40 : 30),

          // 3D Duolingo button
          DSButton(
            label: 'শুরু করি',
            width: double.infinity,
            height: isTablet ? DS.btnLg : DS.btnMd,
            color: DS.green500,
            shadowColor: DS.green600,
            onPressed: onNext,
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
        boxShadow: [
          BoxShadow(
            color: HSLColor.fromColor(color)
                .withLightness(
                  (HSLColor.fromColor(color).lightness - .18)
                      .clamp(0.0, 1.0),
                )
                .toColor()
                .withValues(alpha: .55),
            blurRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VectorIcon(type: type, size: isTablet ? 20 : 17, color: color),
          const SizedBox(width: 6),
          LocalizedText(
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
