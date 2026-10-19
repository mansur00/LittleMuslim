/// LittleMuslim Design System
/// Duolingo-inspired gamification + Islamic aesthetics
/// Spacing & sizing follow Tailwind's 4px base grid (mobile-optimised)
library little_muslim_design_system;

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SPACING  (Tailwind 4px base — s1=4, s2=8, s3=12, s4=16 …)
// ─────────────────────────────────────────────────────────────────────────────
abstract class DS {
  static const double s0 = 0;
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s8 = 32;
  static const double s10 = 40;
  static const double s12 = 48;
  static const double s14 = 56;
  static const double s16 = 64;

  // Border radius
  static const double rSm = 8;
  static const double rMd = 12;
  static const double rLg = 16;
  static const double rXl = 20;
  static const double r2xl = 24;
  static const double r3xl = 32;

  // Icon sizes (Tailwind h-4=16, h-5=20, h-6=24, h-8=32, h-10=40, h-12=48)
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 40;
  static const double icon2xl = 48;

  // Touch targets — min 44pt for mobile accessibility
  static const double touchSm = 44;
  static const double touchMd = 52;
  static const double touchLg = 60;

  // Button heights
  static const double btnSm = 40;
  static const double btnMd = 52;
  static const double btnLg = 60;

  // Card
  static const double moduleCardHeight = 140;
  static const double moduleIconBadge = 64;

  // ── COLORS ─────────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF9FAFB);
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Green (primary / Qaida)
  static const Color green500 = Color(0xFF58CC02);
  static const Color green600 = Color(0xFF46A302);
  static const Color green100 = Color(0xFFE7F8CC);

  // Gold / XP
  static const Color gold500 = Color(0xFFFFC800);
  static const Color gold600 = Color(0xFFE5A100);
  static const Color gold100 = Color(0xFFFFFAE5);

  // Blue (Prayer)
  static const Color blue500 = Color(0xFF1CB0F6);
  static const Color blue600 = Color(0xFF1899D6);
  static const Color blue100 = Color(0xFFE0F2FE);

  // Red / Heart
  static const Color red500 = Color(0xFFFF4B4B);
  static const Color red600 = Color(0xFFEA2B2B);

  // Purple / Dua
  static const Color purple500 = Color(0xFFA855F7);
  static const Color purple600 = Color(0xFF9333EA);
  static const Color purple100 = Color(0xFFF3E8FF);

  // Orange / Quran
  static const Color orange500 = Color(0xFFF97316);
  static const Color orange600 = Color(0xFFEA580C);
  static const Color orange100 = Color(0xFFFFF7ED);

  // Pink / Seerah
  static const Color pink500 = Color(0xFFEC4899);
  static const Color pink600 = Color(0xFFDB2777);
  static const Color pink100 = Color(0xFFFFE4EF);

  // Teal / Basics
  static const Color teal500 = Color(0xFF14B8A6);
  static const Color teal600 = Color(0xFF0D9488);
  static const Color teal100 = Color(0xFFCCFBF1);

  // Amber / Achievements
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber600 = Color(0xFFD97706);
  static const Color amber100 = Color(0xFFFEF3C7);

  // Gray / Locked
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);

  // ── MODULE PALETTES ────────────────────────────────────────────────────────
  static const ModuleColors qaida = ModuleColors(
    face: Color(0xFF58CC02), bevel: Color(0xFF46A302),
    glow: Color(0xFF58CC02), label: Color(0xFF2D6A00),
  );
  static const ModuleColors quran = ModuleColors(
    face: Color(0xFFFFC800), bevel: Color(0xFFE5A100),
    glow: Color(0xFFFFC800), label: Color(0xFF7A5000),
  );
  static const ModuleColors prayer = ModuleColors(
    face: Color(0xFF1CB0F6), bevel: Color(0xFF1899D6),
    glow: Color(0xFF1CB0F6), label: Color(0xFF0B5E8A),
  );
  static const ModuleColors dua = ModuleColors(
    face: Color(0xFFA855F7), bevel: Color(0xFF9333EA),
    glow: Color(0xFFA855F7), label: Color(0xFF5B21B6),
  );
  static const ModuleColors seerah = ModuleColors(
    face: Color(0xFFEC4899), bevel: Color(0xFFDB2777),
    glow: Color(0xFFEC4899), label: Color(0xFF831843),
  );
  static const ModuleColors basics = ModuleColors(
    face: Color(0xFF14B8A6), bevel: Color(0xFF0D9488),
    glow: Color(0xFF14B8A6), label: Color(0xFF134E4A),
  );
  static const ModuleColors achievements = ModuleColors(
    face: Color(0xFFF59E0B), bevel: Color(0xFFD97706),
    glow: Color(0xFFF59E0B), label: Color(0xFF78350F),
  );

  // ── TYPOGRAPHY ─────────────────────────────────────────────────────────────
  static const double textXs = 12;
  static const double textSm = 14;
  static const double textBase = 16;
  static const double textLg = 18;
  static const double textXl = 20;
  static const double text2xl = 24;
  static const double text3xl = 30;
  static const double text4xl = 36;

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extrabold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // ── 3D BEVEL ───────────────────────────────────────────────────────────────
  static const double bevelSm = 4;
  static const double bevelMd = 6;
  static const double bevelLg = 8;

  static List<BoxShadow> shadow(Color color, {double depth = 6}) => [
        BoxShadow(color: color, offset: Offset(0, depth), blurRadius: 0),
      ];

  static List<BoxShadow> glow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.30),
          blurRadius: 18,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// MODULE COLORS
// ─────────────────────────────────────────────────────────────────────────────
class ModuleColors {
  final Color face;
  final Color bevel;
  final Color glow;
  final Color label;

  const ModuleColors({
    required this.face,
    required this.bevel,
    required this.glow,
    required this.label,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// DS BUTTON — Duolingo 3D press animation
// ─────────────────────────────────────────────────────────────────────────────
// DS BUTTON — Duolingo 3D press animation & tactile bevel
// ─────────────────────────────────────────────────────────────────────────────
enum DSButtonVariant {
  primary,
  secondary,
  gold,
  orange,
  blue,
  danger,
  purple,
  outline,
}

class DSButton extends StatefulWidget {
  const DSButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = DSButtonVariant.primary,
    this.color,
    this.shadowColor,
    this.textColor,
    this.borderColor,
    this.height = DS.btnMd,
    this.icon,
    this.iconData,
    this.width,
    this.fullWidth = false,
    this.fontSize = DS.textBase,
    this.borderRadius = DS.rLg, // 16px
    this.bevel = 4.0,
    this.child,
  });

  final String label;
  final VoidCallback? onPressed;
  final DSButtonVariant variant;
  final Color? color;
  final Color? shadowColor;
  final Color? textColor;
  final Color? borderColor;
  final double height;
  final dynamic icon; // Widget? or IconData?
  final IconData? iconData;
  final double? width;
  final bool fullWidth;
  final double fontSize;
  final double borderRadius;
  final double bevel;
  final Widget? child;

  @override
  State<DSButton> createState() => _DSButtonState();
}

class _DSButtonState extends State<DSButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;
    final bevel = isDisabled ? 2.0 : widget.bevel;

    Color faceColor;
    Color bevelColor;
    Color labelColor;
    Color? outlineBorder;

    if (isDisabled) {
      faceColor = const Color(0xFFE5E7EB);
      bevelColor = const Color(0xFFD1D5DB);
      labelColor = const Color(0xFF9CA3AF);
    } else {
      switch (widget.variant) {
        case DSButtonVariant.primary:
          faceColor = widget.color ?? const Color(0xFF58CC02);
          bevelColor = widget.shadowColor ?? const Color(0xFF46A302);
          labelColor = widget.textColor ?? Colors.white;
          break;
        case DSButtonVariant.secondary:
          faceColor = widget.color ?? Colors.white;
          bevelColor = widget.shadowColor ?? const Color(0xFFE5E7EB);
          labelColor = widget.textColor ?? const Color(0xFF3C3C3C);
          outlineBorder = widget.borderColor ?? const Color(0xFFE5E7EB);
          break;
        case DSButtonVariant.gold:
          faceColor = widget.color ?? const Color(0xFFFFC800);
          bevelColor = widget.shadowColor ?? const Color(0xFFE5A100);
          labelColor = widget.textColor ?? Colors.white;
          break;
        case DSButtonVariant.orange:
          faceColor = widget.color ?? const Color(0xFFF97316);
          bevelColor = widget.shadowColor ?? const Color(0xFFEA580C);
          labelColor = widget.textColor ?? Colors.white;
          break;
        case DSButtonVariant.blue:
          faceColor = widget.color ?? const Color(0xFF1CB0F6);
          bevelColor = widget.shadowColor ?? const Color(0xFF1899D6);
          labelColor = widget.textColor ?? Colors.white;
          break;
        case DSButtonVariant.danger:
          faceColor = widget.color ?? const Color(0xFFFF4B4B);
          bevelColor = widget.shadowColor ?? const Color(0xFFEA2B2B);
          labelColor = widget.textColor ?? Colors.white;
          break;
        case DSButtonVariant.purple:
          faceColor = widget.color ?? const Color(0xFFA855F7);
          bevelColor = widget.shadowColor ?? const Color(0xFF9333EA);
          labelColor = widget.textColor ?? Colors.white;
          break;
        case DSButtonVariant.outline:
          faceColor = widget.color ?? Colors.white;
          bevelColor = widget.shadowColor ?? const Color(0xFFE5E7EB);
          labelColor = widget.textColor ?? const Color(0xFF58CC02);
          outlineBorder = widget.borderColor ?? const Color(0xFF58CC02);
          break;
      }
    }

    Widget content = widget.child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              if (widget.icon is IconData)
                Icon(widget.icon as IconData,
                    color: labelColor, size: widget.fontSize + 4)
              else if (widget.icon is Widget)
                widget.icon as Widget,
              const SizedBox(width: DS.s2),
            ] else if (widget.iconData != null) ...[
              Icon(widget.iconData, color: labelColor, size: widget.fontSize + 4),
              const SizedBox(width: DS.s2),
            ],
            Flexible(
              child: LocalizedText(
                widget.label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: widget.fontSize,
                  fontWeight: DS.black,
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onPressed!();
            },
      onTapCancel: isDisabled ? null : () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        curve: Curves.easeOut,
        width: widget.fullWidth ? double.infinity : widget.width,
        height: widget.height,
        margin: EdgeInsets.only(
          top: _pressed ? bevel : 0,
          bottom: _pressed ? 0 : bevel,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: faceColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: outlineBorder != null
              ? Border.all(color: outlineBorder, width: 2.0)
              : Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 1.5,
                ),
          boxShadow: [
            BoxShadow(
              color: bevelColor,
              offset: Offset(0, _pressed ? 0 : bevel),
              blurRadius: 0,
            ),
          ],
        ),
        child: content,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DS CARD — Feature Card (DS.rXl 20px + 2px Border + 3D Bevel Shadow)
// ─────────────────────────────────────────────────────────────────────────────
class DSCard extends StatefulWidget {
  const DSCard({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor = const Color(0xFF58CC02),
    this.bevelColor,
    this.backgroundColor = Colors.white,
    this.borderRadius = DS.rXl, // 20px
    this.borderWidth = 2.0,
    this.borderColor,
    this.bevelDepth = 5.0,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 14),
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color accentColor;
  final Color? bevelColor;
  final Color backgroundColor;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final double bevelDepth;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  State<DSCard> createState() => _DSCardState();
}

class _DSCardState extends State<DSCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBevelColor = widget.bevelColor ??
        HSLColor.fromColor(widget.accentColor)
            .withLightness(
              (HSLColor.fromColor(widget.accentColor).lightness - .15)
                  .clamp(0.0, 1.0),
            )
            .toColor();

    final effectiveBorderColor = widget.borderColor ??
        widget.accentColor.withValues(alpha: 0.28);

    return GestureDetector(
      onTapDown:
          widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap!();
            }
          : null,
      onTapCancel:
          widget.onTap != null ? () => setState(() => _pressed = false) : null,
      child: Container(
        margin: widget.margin,
        child: Stack(
          children: [
            Positioned.fill(
              top: widget.bevelDepth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: effectiveBevelColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
              ),
            ),
            AnimatedPadding(
              duration: const Duration(milliseconds: 80),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                top: _pressed ? widget.bevelDepth : 0,
                bottom: _pressed ? 0 : widget.bevelDepth,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color: effectiveBorderColor,
                    width: widget.borderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: Offset(0, _pressed ? 1 : 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      (widget.borderRadius - 2).clamp(0.0, 40.0)),
                  child: Padding(
                    padding: widget.padding,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DS LIST TILE CARD — List Item (DS.rLg 16px + 1.5px Border)
// ─────────────────────────────────────────────────────────────────────────────
class DSListTileCard extends StatelessWidget {
  const DSListTileCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = DS.rLg, // 16px
    this.borderWidth = 1.5,
    this.borderColor = const Color(0xFFE5E7EB),
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.margin = const EdgeInsets.only(bottom: 10),
  });

  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DS MODULE CARD — Duolingo 3D bevel card with 3D realistic badge
// ─────────────────────────────────────────────────────────────────────────────
class DSModuleCard extends StatefulWidget {
  const DSModuleCard({
    super.key,
    required this.colors,
    required this.title,
    required this.subtitle,
    this.badgeAsset,
    this.customBadge,
    this.iconPainter,
    required this.onTap,
    this.isTablet = false,
  });

  final ModuleColors colors;
  final String title;
  final String subtitle;
  final String? badgeAsset;
  final Widget? customBadge;
  final CustomPainter? iconPainter;
  final VoidCallback onTap;
  final bool isTablet;

  @override
  State<DSModuleCard> createState() => _DSModuleCardState();
}

class _DSModuleCardState extends State<DSModuleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    const bevel = 5.0;
    final badgeSize = widget.isTablet ? 90.0 : 76.0;
    final titleSize = widget.isTablet ? DS.textLg : 15.0;
    final subtitleSize = widget.isTablet ? DS.textSm : 11.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: Stack(
        children: [
          // 3D Bevel (bottom edge)
          Positioned.fill(
            top: bevel,
            child: Container(
              decoration: BoxDecoration(
                color: widget.colors.bevel,
                borderRadius: BorderRadius.circular(DS.r2xl),
              ),
            ),
          ),
          // 3D Card Face (Pure clean white background with crisp border)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 85),
            curve: Curves.easeOut,
            top: _pressed ? bevel : 0,
            bottom: _pressed ? 0 : bevel,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DS.r2xl),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.colors.glow.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 3D Badge / Icon
                  if (widget.badgeAsset != null)
                    SizedBox(
                      width: badgeSize,
                      height: badgeSize,
                      child: Image.asset(
                        widget.badgeAsset!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => widget.iconPainter != null
                            ? CustomPaint(painter: widget.iconPainter)
                            : const SizedBox.shrink(),
                      ),
                    )
                  else if (widget.customBadge != null)
                    SizedBox(
                      width: badgeSize,
                      height: badgeSize,
                      child: widget.customBadge!,
                    )
                  else if (widget.iconPainter != null)
                    Container(
                      width: badgeSize * 0.75,
                      height: badgeSize * 0.75,
                      decoration: BoxDecoration(
                        color: widget.colors.face,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.colors.bevel.withValues(alpha: 0.35),
                            offset: const Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: CustomPaint(
                        painter: widget.iconPainter,
                      ),
                    ),
                  const SizedBox(height: 6),
                  LocalizedText(
                    widget.title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: DS.black,
                      color: DS.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.colors.face.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: LocalizedText(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: subtitleSize,
                        fontWeight: DS.bold,
                        color: widget.colors.label,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ISLAMIC ILLUSTRATION PAINTERS  (strictly aniconic — no faces/eyes/limbs)
// ─────────────────────────────────────────────────────────────────────────────

/// Open Holy Quran on rehal with gold glow (welcome / Quran module)
class QuranIllustrationPainter extends CustomPainter {
  const QuranIllustrationPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    // Golden glow
    canvas.drawCircle(
      Offset(w / 2, h * 0.45),
      w * 0.38,
      Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );
    // Rehal legs
    final rehal = Paint()..color = const Color(0xFF8D6748);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.25, h * 0.72, w * 0.08, h * 0.20), const Radius.circular(3)),
      rehal,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.67, h * 0.72, w * 0.08, h * 0.20), const Radius.circular(3)),
      rehal,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.18, h * 0.68, w * 0.64, h * 0.07), const Radius.circular(3)),
      Paint()..color = const Color(0xFFA0724A),
    );
    // Left page
    final lp = Path()
      ..moveTo(w * 0.20, h * 0.30)
      ..lineTo(w * 0.20, h * 0.72)
      ..lineTo(w * 0.50, h * 0.68)
      ..lineTo(w * 0.50, h * 0.26)
      ..close();
    canvas.drawPath(lp, Paint()..color = const Color(0xFFE8F5E9));
    // Right page
    final rp = Path()
      ..moveTo(w * 0.80, h * 0.30)
      ..lineTo(w * 0.80, h * 0.72)
      ..lineTo(w * 0.50, h * 0.68)
      ..lineTo(w * 0.50, h * 0.26)
      ..close();
    canvas.drawPath(rp, Paint()..color = const Color(0xFFE8F5E9));
    // Page lines
    final linePaint = Paint()
      ..color = const Color(0xFF4CAF50).withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 5; i++) {
      final y = h * (0.36 + i * 0.065);
      canvas.drawLine(Offset(w * 0.25, y), Offset(w * 0.46, y), linePaint);
      canvas.drawLine(Offset(w * 0.54, y), Offset(w * 0.75, y), linePaint);
    }
    // Gold spine
    canvas.drawLine(
      Offset(w * 0.50, h * 0.26),
      Offset(w * 0.50, h * 0.68),
      Paint()..color = const Color(0xFFFFD700)..strokeWidth = 2.5,
    );
    // Gold borders
    for (final path in [lp, rp]) {
      canvas.drawPath(path, Paint()
        ..color = const Color(0xFFFFD700)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5);
    }
    // Sparkles
    for (final pos in [Offset(w * 0.12, h * 0.15), Offset(w * 0.88, h * 0.10), Offset(w * 0.76, h * 0.82)]) {
      final r = w * 0.045;
      final sp = Paint()..color = const Color(0xFFFFD700)..strokeWidth = 2;
      canvas.drawLine(Offset(pos.dx - r, pos.dy), Offset(pos.dx + r, pos.dy), sp);
      canvas.drawLine(Offset(pos.dx, pos.dy - r), Offset(pos.dx, pos.dy + r), sp);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// Night sky with crescent moon and stars (welcome / onboarding)
class CrescentStarsIllustrationPainter extends CustomPainter {
  const CrescentStarsIllustrationPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    // Deep blue sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E1B4B), Color(0xFF3730A3)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    // Moon glow
    canvas.drawCircle(
      Offset(w * 0.38, h * 0.38),
      w * 0.28,
      Paint()
        ..color = const Color(0xFFFFC800).withValues(alpha: 0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
    // Moon body
    canvas.drawCircle(Offset(w * 0.38, h * 0.38), w * 0.22, Paint()..color = const Color(0xFFFFC800));
    // Bite to create crescent
    canvas.drawCircle(Offset(w * 0.48, h * 0.32), w * 0.17, Paint()..color = const Color(0xFF2D2A6E));
    // Stars
    final starPositions = [
      [0.72, 0.15, 0.05],
      [0.18, 0.20, 0.04],
      [0.85, 0.42, 0.035],
      [0.60, 0.28, 0.03],
      [0.12, 0.55, 0.04],
      [0.88, 0.65, 0.03],
      [0.45, 0.12, 0.025],
    ];
    for (final st in starPositions) {
      canvas.drawCircle(
        Offset(w * st[0], h * st[1]),
        w * st[2],
        Paint()..color = Colors.white.withValues(alpha: 0.9),
      );
    }
    // Rolling green hills at bottom
    final hillPaint = Paint()..color = const Color(0xFF059669);
    final hillPath = Path()
      ..moveTo(0, h * 0.75)
      ..quadraticBezierTo(w * 0.25, h * 0.62, w * 0.50, h * 0.70)
      ..quadraticBezierTo(w * 0.75, h * 0.78, w, h * 0.68)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(hillPath, hillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// Mosque silhouette at dusk (prayer / onboarding)
class MosqueIllustrationPainter extends CustomPainter {
  const MosqueIllustrationPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    // Sky
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E3A8A), Color(0xFF7C3AED)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    // Ground
    canvas.drawRect(Rect.fromLTWH(0, h * 0.76, w, h * 0.24), Paint()..color = const Color(0xFF065F46));
    // Main building
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.20, h * 0.46, w * 0.60, h * 0.30), const Radius.circular(4)),
      Paint()..color = const Color(0xFF0D9488),
    );
    // Minarets
    for (final x in [w * 0.12, w * 0.76]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, h * 0.28, w * 0.12, h * 0.48), const Radius.circular(3)),
        Paint()..color = const Color(0xFF14B8A6),
      );
      // Minaret tip
      final tip = Path()
        ..moveTo(x, h * 0.28)
        ..lineTo(x + w * 0.06, h * 0.15)
        ..lineTo(x + w * 0.12, h * 0.28)
        ..close();
      canvas.drawPath(tip, Paint()..color = const Color(0xFFFFD700));
    }
    // Central dome
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.46), width: w * 0.44, height: w * 0.38),
      3.14159, 3.14159, false,
      Paint()..color = const Color(0xFF0D9488),
    );
    // Dome crescent
    canvas.drawCircle(Offset(w * 0.50, h * 0.27), w * 0.04, Paint()..color = const Color(0xFFFFD700));
    canvas.drawCircle(Offset(w * 0.54, h * 0.24), w * 0.03, Paint()..color = const Color(0xFF1E3A8A));
    // Windows
    for (var i = 0; i < 3; i++) {
      final wx = w * (0.27 + i * 0.18);
      canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          wx, h * 0.55, wx + w * 0.12, h * 0.72,
          topLeft: Radius.circular(w * 0.06),
          topRight: Radius.circular(w * 0.06),
        ),
        Paint()..color = const Color(0xFFFFD700).withValues(alpha: 0.65),
      );
    }
    // Sky stars
    for (final pos in [Offset(w * 0.08, h * 0.10), Offset(w * 0.88, h * 0.08), Offset(w * 0.68, h * 0.16)]) {
      canvas.drawCircle(pos, w * 0.013, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3D MODULE ICON PAINTERS (all white, painted on colored badge background)
// ─────────────────────────────────────────────────────────────────────────────

class QaidaIconPainter extends CustomPainter {
  const QaidaIconPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final stroke = Paint()
      ..color = Colors.white
      ..strokeWidth = w * 0.14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.50, h * 0.16), Offset(w * 0.50, h * 0.72), stroke);
    canvas.drawLine(Offset(w * 0.34, h * 0.24), Offset(w * 0.66, h * 0.24), stroke..strokeWidth = w * 0.10);
    canvas.drawCircle(Offset(w * 0.50, h * 0.84), w * 0.09, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class QuranIconPainter extends CustomPainter {
  const QuranIconPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final leftPage = Path()
      ..moveTo(w * 0.14, h * 0.16)
      ..lineTo(w * 0.14, h * 0.84)
      ..quadraticBezierTo(w * 0.14, h * 0.90, w * 0.20, h * 0.90)
      ..lineTo(w * 0.50, h * 0.90)
      ..lineTo(w * 0.50, h * 0.12)
      ..lineTo(w * 0.20, h * 0.12)
      ..quadraticBezierTo(w * 0.14, h * 0.12, w * 0.14, h * 0.16)
      ..close();
    final rightPage = Path()
      ..moveTo(w * 0.86, h * 0.16)
      ..lineTo(w * 0.86, h * 0.84)
      ..quadraticBezierTo(w * 0.86, h * 0.90, w * 0.80, h * 0.90)
      ..lineTo(w * 0.50, h * 0.90)
      ..lineTo(w * 0.50, h * 0.12)
      ..lineTo(w * 0.80, h * 0.12)
      ..quadraticBezierTo(w * 0.86, h * 0.12, w * 0.86, h * 0.16)
      ..close();
    canvas.drawPath(leftPage, Paint()..color = Colors.white.withValues(alpha: 0.88));
    canvas.drawPath(rightPage, Paint()..color = Colors.white);
    canvas.drawLine(
      Offset(w * 0.50, h * 0.12),
      Offset(w * 0.50, h * 0.90),
      Paint()
        ..color = const Color(0xFFFFD700)
        ..strokeWidth = w * 0.05
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
    final lp = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.55)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 4; i++) {
      final y = h * (0.28 + i * 0.14);
      canvas.drawLine(Offset(w * 0.19, y), Offset(w * 0.44, y), lp);
      canvas.drawLine(Offset(w * 0.56, y), Offset(w * 0.81, y), lp);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class PrayerIconPainter extends CustomPainter {
  const PrayerIconPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final p = Paint()..color = Colors.white;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.48), width: w * 0.58, height: w * 0.48),
      3.14159, 3.14159, false, p,
    );
    canvas.drawRect(Rect.fromLTWH(w * 0.21, h * 0.48, w * 0.58, h * 0.28), p);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.09, h * 0.28, w * 0.12, h * 0.48), const Radius.circular(2)),
      p,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.79, h * 0.28, w * 0.12, h * 0.48), const Radius.circular(2)),
      p,
    );
    canvas.drawCircle(Offset(w * 0.50, h * 0.22), w * 0.07, Paint()..color = const Color(0xFFFFD700));
    canvas.drawCircle(Offset(w * 0.545, h * 0.185), w * 0.052, Paint()..color = const Color(0xFF1CB0F6));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class DuaIconPainter extends CustomPainter {
  const DuaIconPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final hp = Paint()..color = Colors.white;
    final leftHand = Path()
      ..moveTo(w * 0.10, h * 0.62)
      ..quadraticBezierTo(w * 0.06, h * 0.48, w * 0.18, h * 0.40)
      ..quadraticBezierTo(w * 0.28, h * 0.34, w * 0.40, h * 0.38)
      ..quadraticBezierTo(w * 0.46, h * 0.44, w * 0.46, h * 0.56)
      ..quadraticBezierTo(w * 0.42, h * 0.70, w * 0.28, h * 0.74)
      ..close();
    final rightHand = Path()
      ..moveTo(w * 0.90, h * 0.62)
      ..quadraticBezierTo(w * 0.94, h * 0.48, w * 0.82, h * 0.40)
      ..quadraticBezierTo(w * 0.72, h * 0.34, w * 0.60, h * 0.38)
      ..quadraticBezierTo(w * 0.54, h * 0.44, w * 0.54, h * 0.56)
      ..quadraticBezierTo(w * 0.58, h * 0.70, w * 0.72, h * 0.74)
      ..close();
    canvas.drawPath(leftHand, hp);
    canvas.drawPath(rightHand, hp);
    final ray = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.9)
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.50, h * 0.08), Offset(w * 0.50, h * 0.26), ray);
    canvas.drawLine(Offset(w * 0.30, h * 0.12), Offset(w * 0.38, h * 0.26), ray..strokeWidth = w * 0.04);
    canvas.drawLine(Offset(w * 0.70, h * 0.12), Offset(w * 0.62, h * 0.26), ray);
    canvas.drawCircle(Offset(w * 0.50, h * 0.20), w * 0.08, Paint()..color = const Color(0xFFFFD700));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class SeerahIconPainter extends CustomPainter {
  const SeerahIconPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final p = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.16, h * 0.22, w * 0.68, h * 0.56), Radius.circular(w * 0.05)),
      p,
    );
    canvas.drawOval(Rect.fromLTWH(w * 0.08, h * 0.22, w * 0.18, h * 0.56), Paint()..color = Colors.white.withValues(alpha: 0.72));
    canvas.drawOval(Rect.fromLTWH(w * 0.74, h * 0.22, w * 0.18, h * 0.56), Paint()..color = Colors.white.withValues(alpha: 0.72));
    final lp = Paint()
      ..color = const Color(0xFFEC4899).withValues(alpha: 0.45)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(Offset(w * 0.24, h * (0.34 + i * 0.12)), Offset(w * 0.76, h * (0.34 + i * 0.12)), lp);
    }
    canvas.drawCircle(Offset(w * 0.82, h * 0.20), w * 0.065, Paint()..color = const Color(0xFFFFD700));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class BasicsIconPainter extends CustomPainter {
  const BasicsIconPainter();

  static double _cos(double a) {
    double x = a % (2 * 3.14159265358979);
    double r = 1, t = 1;
    for (var i = 1; i <= 6; i++) { t *= -x * x / ((2 * i - 1) * (2 * i)); r += t; }
    return r;
  }

  static double _sin(double a) {
    double x = a % (2 * 3.14159265358979);
    double r = x, t = x;
    for (var i = 1; i <= 6; i++) { t *= -x * x / ((2 * i) * (2 * i + 1)); r += t; }
    return r;
  }

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final center = Offset(w * 0.5, h * 0.5);
    const outerR = 0.40;
    const innerR = 0.20;
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final oa = (i * 3.14159 * 2 / 8) - 3.14159 / 2;
      final ia = oa + 3.14159 / 8;
      final ox = center.dx + w * outerR * _cos(oa);
      final oy = center.dy + h * outerR * _sin(oa);
      final ix = center.dx + w * innerR * _cos(ia);
      final iy = center.dy + h * innerR * _sin(ia);
      i == 0 ? path.moveTo(ox, oy) : path.lineTo(ox, oy);
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.white);
    canvas.drawCircle(center, w * 0.10, Paint()..color = DS.basics.face);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class TrophyIconPainter extends CustomPainter {
  const TrophyIconPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final p = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.26, h * 0.12, w * 0.48, h * 0.46), Radius.circular(w * 0.22)),
      p,
    );
    canvas.drawArc(Rect.fromLTWH(w * 0.06, h * 0.16, w * 0.24, h * 0.30), -1.57, 3.14, false,
      Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = w * 0.08..strokeCap = StrokeCap.round);
    canvas.drawArc(Rect.fromLTWH(w * 0.70, h * 0.16, w * 0.24, h * 0.30), 1.57, 3.14, false,
      Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = w * 0.08..strokeCap = StrokeCap.round);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.42, h * 0.58, w * 0.16, h * 0.18), const Radius.circular(2)), p);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.22, h * 0.76, w * 0.56, h * 0.10), Radius.circular(w * 0.04)), p);
    canvas.drawCircle(Offset(w * 0.50, h * 0.35), w * 0.11, Paint()..color = const Color(0xFFFFD700));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3D REALISTIC GAMIFIED BADGE (Matching Duolingo / Clash Reference)
// ─────────────────────────────────────────────────────────────────────────────
// GAMIFY 3D HEXAGONAL SHIELD BADGE
// (Hexagonal shield, golden rim, sunburst rays, center 3D emblem, ribbon banner)
// ─────────────────────────────────────────────────────────────────────────────
enum BadgeEmblem { trophy, crown, star, diamond, lightning, quran, check, lock }

class DSGamifyBadge extends StatelessWidget {
  const DSGamifyBadge({
    super.key,
    required this.emblem,
    this.primaryColor = const Color(0xFFFFC800),
    this.bevelColor = const Color(0xFFE5A100),
    this.ribbonColor = const Color(0xFFFFD700),
    this.ribbonText,
    this.size = 80,
    this.isLocked = false,
  });

  final BadgeEmblem emblem;
  final Color primaryColor;
  final Color bevelColor;
  final Color ribbonColor;
  final String? ribbonText;
  final double size;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GamifyBadgePainter(
          emblem: emblem,
          primaryColor: primaryColor,
          bevelColor: bevelColor,
          ribbonColor: ribbonColor,
          ribbonText: ribbonText,
          isLocked: isLocked,
        ),
      ),
    );
  }
}

class _GamifyBadgePainter extends CustomPainter {
  const _GamifyBadgePainter({
    required this.emblem,
    required this.primaryColor,
    required this.bevelColor,
    required this.ribbonColor,
    this.ribbonText,
    this.isLocked = false,
  });

  final BadgeEmblem emblem;
  final Color primaryColor;
  final Color bevelColor;
  final Color ribbonColor;
  final String? ribbonText;
  final bool isLocked;

  Path _hexagonPath(Offset c, double r) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final a = (i * 3.14159265 / 3) - 3.14159265 / 2;
      final x = c.dx + r * _cos(a);
      final y = c.dy + r * _sin(a);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  static double _cos(double a) {
    double x = a % (2 * 3.14159265358979);
    double r = 1, t = 1;
    for (var i = 1; i <= 6; i++) { t *= -x * x / ((2 * i - 1) * (2 * i)); r += t; }
    return r;
  }

  static double _sin(double a) {
    double x = a % (2 * 3.14159265358979);
    double r = x, t = x;
    for (var i = 1; i <= 6; i++) { t *= -x * x / ((2 * i) * (2 * i + 1)); r += t; }
    return r;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.5, h * 0.46);
    final radius = w * 0.44;

    final effPrimary = isLocked ? const Color(0xFFE2E8F0) : primaryColor;
    final effBevel = isLocked ? const Color(0xFF94A3B8) : bevelColor;
    final effRibbon = isLocked ? const Color(0xFFF1F5F9) : ribbonColor;

    // 1. Drop shadow
    final shadowPath = _hexagonPath(Offset(center.dx, center.dy + h * 0.04), radius);
    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // 2. Bevel bottom ring
    final bevelPath = _hexagonPath(Offset(center.dx, center.dy + h * 0.025), radius);
    canvas.drawPath(bevelPath, Paint()..color = effBevel);

    // 3. Golden metallic rim (or silver if locked)
    final outerHex = _hexagonPath(center, radius);
    final rimPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isLocked
            ? [const Color(0xFFFFFFFF), const Color(0xFFCBD5E1), const Color(0xFF94A3B8)]
            : [const Color(0xFFFFFBEB), effPrimary, effBevel],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawPath(outerHex, rimPaint);

    // 4. Inner face
    final innerHex = _hexagonPath(center, radius * 0.84);
    final facePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.2),
        radius: 0.9,
        colors: isLocked
            ? [const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)]
            : [effPrimary, effBevel],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.84));
    canvas.drawPath(innerHex, facePaint);

    // 5. Sunburst rays
    canvas.save();
    canvas.clipPath(innerHex);
    final rayPaint = Paint()
      ..color = Colors.white.withValues(alpha: isLocked ? 0.12 : 0.22)
      ..style = PaintingStyle.fill;
    for (var i = 0; i < 8; i++) {
      if (i % 2 == 0) continue;
      final startA = (i * 3.14159265 * 2 / 8);
      final endA = ((i + 1) * 3.14159265 * 2 / 8);
      final rayPath = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + radius * 1.5 * _cos(startA), center.dy + radius * 1.5 * _sin(startA))
        ..lineTo(center.dx + radius * 1.5 * _cos(endA), center.dy + radius * 1.5 * _sin(endA))
        ..close();
      canvas.drawPath(rayPath, rayPaint);
    }
    canvas.restore();

    // 6. Draw Emblem
    _drawEmblem(canvas, center, radius * 0.58, isLocked ? BadgeEmblem.lock : emblem);

    // 7. Sparkles (4-pointed glints) - only when unlocked
    if (!isLocked) {
      _drawSparkle(canvas, Offset(w * 0.22, h * 0.20), w * 0.08);
      _drawSparkle(canvas, Offset(w * 0.78, h * 0.24), w * 0.06);
    }

    // 8. 3D Ribbon Banner
    if (ribbonText != null && ribbonText!.isNotEmpty) {
      _drawRibbon(canvas, Offset(w * 0.5, h * 0.84), w * 0.86, h * 0.20, ribbonText!, effBevel, effRibbon);
    }
  }

  void _drawEmblem(Canvas canvas, Offset c, double s, BadgeEmblem activeEmblem) {
    switch (activeEmblem) {
      case BadgeEmblem.lock:
        // 3D Metallic Padlock
        final shacklePaint = Paint()
          ..color = const Color(0xFF94A3B8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.16
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(
          Rect.fromCenter(center: Offset(c.dx, c.dy - s * 0.14), width: s * 0.40, height: s * 0.42),
          3.14159,
          3.14159,
          false,
          shacklePaint,
        );
        final body = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(c.dx, c.dy + s * 0.12), width: s * 0.52, height: s * 0.44),
          const Radius.circular(6),
        );
        canvas.drawRRect(
          body,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE2E8F0), Color(0xFF94A3B8), Color(0xFF64748B)],
            ).createShader(body.outerRect),
        );
        // Keyhole
        canvas.drawCircle(Offset(c.dx, c.dy + s * 0.08), s * 0.06, Paint()..color = const Color(0xFF334155));
        canvas.drawRect(Rect.fromLTWH(c.dx - s * 0.025, c.dy + s * 0.08, s * 0.05, s * 0.08), Paint()..color = const Color(0xFF334155));
        break;

      case BadgeEmblem.trophy:
        // 3D Trophy
        final gold = Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF9C4), Color(0xFFFFD700), Color(0xFFF59E0B), Color(0xFFB45309)],
          ).createShader(Rect.fromCenter(center: c, width: s, height: s));
        // Cup body
        final cup = Path()
          ..moveTo(c.dx - s * 0.40, c.dy - s * 0.35)
          ..lineTo(c.dx + s * 0.40, c.dy - s * 0.35)
          ..lineTo(c.dx + s * 0.30, c.dy + s * 0.10)
          ..quadraticBezierTo(c.dx, c.dy + s * 0.30, c.dx - s * 0.30, c.dy + s * 0.10)
          ..close();
        canvas.drawPath(cup, gold);
        // Handles
        final hp = Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.14
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(Rect.fromCenter(center: Offset(c.dx - s * 0.42, c.dy - s * 0.15), width: s * 0.36, height: s * 0.42), 1.5, 3.14, false, hp);
        canvas.drawArc(Rect.fromCenter(center: Offset(c.dx + s * 0.42, c.dy - s * 0.15), width: s * 0.36, height: s * 0.42), -1.5, 3.14, false, hp);
        // Pedestal
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(c.dx - s * 0.12, c.dy + s * 0.22, s * 0.24, s * 0.14), const Radius.circular(2)), gold);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(c.dx - s * 0.32, c.dy + s * 0.34, s * 0.64, s * 0.12), const Radius.circular(3)), gold);
        // Center ruby gem
        canvas.drawCircle(Offset(c.dx, c.dy - s * 0.08), s * 0.13, Paint()..color = const Color(0xFFEF4444));
        canvas.drawCircle(Offset(c.dx - s * 0.04, c.dy - s * 0.12), s * 0.04, Paint()..color = Colors.white);
        break;

      case BadgeEmblem.crown:
        final gold = Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF9C4), Color(0xFFFFD700), Color(0xFFF59E0B)],
          ).createShader(Rect.fromCenter(center: c, width: s, height: s));
        final crown = Path()
          ..moveTo(c.dx - s * 0.42, c.dy - s * 0.20)
          ..lineTo(c.dx - s * 0.20, c.dy)
          ..lineTo(c.dx, c.dy - s * 0.34)
          ..lineTo(c.dx + s * 0.20, c.dy)
          ..lineTo(c.dx + s * 0.42, c.dy - s * 0.20)
          ..lineTo(c.dx + s * 0.34, c.dy + s * 0.28)
          ..lineTo(c.dx - s * 0.34, c.dy + s * 0.28)
          ..close();
        canvas.drawPath(crown, gold);
        // Pearl points
        canvas.drawCircle(Offset(c.dx - s * 0.42, c.dy - s * 0.20), s * 0.07, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(c.dx, c.dy - s * 0.34), s * 0.08, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(c.dx + s * 0.42, c.dy - s * 0.20), s * 0.07, Paint()..color = Colors.white);
        break;

      case BadgeEmblem.star:
        final star = Path();
        for (var i = 0; i < 5; i++) {
          final oa = (i * 3.14159265 * 2 / 5) - 3.14159265 / 2;
          final ia = oa + 3.14159265 / 5;
          final ox = c.dx + s * 0.50 * _cos(oa);
          final oy = c.dy + s * 0.50 * _sin(oa);
          final ix = c.dx + s * 0.24 * _cos(ia);
          final iy = c.dy + s * 0.24 * _sin(ia);
          i == 0 ? star.moveTo(ox, oy) : star.lineTo(ox, oy);
          star.lineTo(ix, iy);
        }
        star.close();
        canvas.drawPath(
          star,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFFDE7), Color(0xFFFFD700), Color(0xFFD97706)],
            ).createShader(Rect.fromCenter(center: c, width: s, height: s)),
        );
        break;

      case BadgeEmblem.diamond:
        final dia = Path()
          ..moveTo(c.dx, c.dy - s * 0.42)
          ..lineTo(c.dx + s * 0.42, c.dy - s * 0.10)
          ..lineTo(c.dx, c.dy + s * 0.42)
          ..lineTo(c.dx - s * 0.42, c.dy - s * 0.10)
          ..close();
        canvas.drawPath(
          dia,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFF93C5FD), Color(0xFF2563EB)],
            ).createShader(Rect.fromCenter(center: c, width: s, height: s)),
        );
        break;

      case BadgeEmblem.lightning:
        final bolt = Path()
          ..moveTo(c.dx + s * 0.12, c.dy - s * 0.45)
          ..lineTo(c.dx - s * 0.28, c.dy)
          ..lineTo(c.dx - s * 0.04, c.dy)
          ..lineTo(c.dx - s * 0.16, c.dy + s * 0.45)
          ..lineTo(c.dx + s * 0.28, c.dy - s * 0.02)
          ..lineTo(c.dx + s * 0.04, c.dy - s * 0.02)
          ..close();
        canvas.drawPath(
          bolt,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFEF08A), Color(0xFFEAB308), Color(0xFFCA8A04)],
            ).createShader(Rect.fromCenter(center: c, width: s, height: s)),
        );
        break;

      case BadgeEmblem.check:
        final check = Path()
          ..moveTo(c.dx - s * 0.35, c.dy)
          ..lineTo(c.dx - s * 0.10, c.dy + s * 0.28)
          ..lineTo(c.dx + s * 0.35, c.dy - s * 0.25);
        canvas.drawPath(
          check,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = s * 0.18
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
        break;

      default:
        canvas.drawCircle(c, s * 0.38, Paint()..color = Colors.white);
        break;
    }
  }

  void _drawSparkle(Canvas canvas, Offset c, double size) {
    final p = Path()
      ..moveTo(c.dx, c.dy - size)
      ..quadraticBezierTo(c.dx, c.dy, c.dx + size, c.dy)
      ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + size)
      ..quadraticBezierTo(c.dx, c.dy, c.dx - size, c.dy)
      ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - size)
      ..close();
    canvas.drawPath(p, Paint()..color = Colors.white);
  }

  void _drawRibbon(Canvas canvas, Offset c, double rw, double rh, String text, Color ribbonBevel, Color ribbonMain) {
    final leftFold = Path()
      ..moveTo(c.dx - rw * 0.48, c.dy - rh * 0.25)
      ..lineTo(c.dx - rw * 0.36, c.dy - rh * 0.45)
      ..lineTo(c.dx - rw * 0.36, c.dy + rh * 0.45)
      ..lineTo(c.dx - rw * 0.48, c.dy + rh * 0.25)
      ..lineTo(c.dx - rw * 0.42, c.dy)
      ..close();
    canvas.drawPath(leftFold, Paint()..color = ribbonBevel);

    final rightFold = Path()
      ..moveTo(c.dx + rw * 0.48, c.dy - rh * 0.25)
      ..lineTo(c.dx + rw * 0.36, c.dy - rh * 0.45)
      ..lineTo(c.dx + rw * 0.36, c.dy + rh * 0.45)
      ..lineTo(c.dx + rw * 0.48, c.dy + rh * 0.25)
      ..lineTo(c.dx + rw * 0.42, c.dy)
      ..close();
    canvas.drawPath(rightFold, Paint()..color = ribbonBevel);

    final centerRibbon = RRect.fromRectAndRadius(
      Rect.fromCenter(center: c, width: rw * 0.74, height: rh),
      const Radius.circular(5),
    );
    canvas.drawRRect(centerRibbon, Paint()..color = ribbonMain);

    // Text on ribbon
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isLocked ? const Color(0xFF64748B) : const Color(0xFF78350F),
          fontSize: rh * 0.52,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: rw * 0.70);
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _GamifyBadgePainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3D REALISTIC BOTTOM NAVIGATION BAR ICONS
// ─────────────────────────────────────────────────────────────────────────────
enum Real3DNavType { path, modules, missions, achievements }

class Real3DNavIcon extends StatelessWidget {
  const Real3DNavIcon({
    super.key,
    required this.type,
    this.size = 28,
    this.isSelected = false,
  });

  final Real3DNavType type;
  final double size;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _Real3DNavPainter(type: type, isSelected: isSelected),
      ),
    );
  }
}

class _Real3DNavPainter extends CustomPainter {
  const _Real3DNavPainter({required this.type, required this.isSelected});
  final Real3DNavType type;
  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.5, h * 0.5);

    switch (type) {
      case Real3DNavType.path:
        // 3D Compass
        // Shadow
        canvas.drawCircle(Offset(center.dx, center.dy + h * 0.06), w * 0.42, Paint()..color = Colors.black.withValues(alpha: 0.15));
        // Gold bezel
        final bezelPaint = Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF9C4), Color(0xFFFFD700), Color(0xFFB45309)],
          ).createShader(Rect.fromCircle(center: center, radius: w * 0.44));
        canvas.drawCircle(center, w * 0.44, bezelPaint);
        // Dial (deep blue glass)
        final dialPaint = Paint()
          ..shader = const RadialGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
          ).createShader(Rect.fromCircle(center: center, radius: w * 0.36));
        canvas.drawCircle(center, w * 0.36, dialPaint);
        // 3D Needle
        final northNeedle = Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(center.dx - w * 0.08, center.dy - w * 0.06)
          ..lineTo(center.dx + w * 0.22, center.dy - w * 0.24)
          ..close();
        canvas.drawPath(northNeedle, Paint()..color = const Color(0xFFEF4444));
        final southNeedle = Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(center.dx + w * 0.08, center.dy + w * 0.06)
          ..lineTo(center.dx - w * 0.22, center.dy + w * 0.24)
          ..close();
        canvas.drawPath(southNeedle, Paint()..color = Colors.white);
        // Center rivet
        canvas.drawCircle(center, w * 0.08, Paint()..color = const Color(0xFFFFD700));
        canvas.drawCircle(Offset(center.dx - w * 0.02, center.dy - w * 0.02), w * 0.03, Paint()..color = Colors.white);
        break;

      case Real3DNavType.modules:
        // 3D Holy Book / Quran
        // Shadow
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.12, h * 0.16 + 2, w * 0.76, h * 0.72), const Radius.circular(5)), Paint()..color = Colors.black.withValues(alpha: 0.18));
        // Book cover
        final bookCover = Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF10B981), Color(0xFF047857), Color(0xFF064E3B)],
          ).createShader(Rect.fromLTWH(w * 0.12, h * 0.14, w * 0.76, h * 0.72));
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.12, h * 0.14, w * 0.76, h * 0.72), const Radius.circular(5)), bookCover);
        // Page edge
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.70, h * 0.19, w * 0.14, h * 0.62), const Radius.circular(3)), Paint()..color = const Color(0xFFFEF3C7));
        // Gold emblem on cover
        canvas.drawCircle(Offset(w * 0.42, h * 0.50), w * 0.14, Paint()..color = const Color(0xFFFFD700));
        canvas.drawCircle(Offset(w * 0.42, h * 0.50), w * 0.09, Paint()..color = const Color(0xFF047857));
        // Gold bookmark ribbon
        final ribbon = Path()
          ..moveTo(w * 0.38, h * 0.74)
          ..lineTo(w * 0.48, h * 0.74)
          ..lineTo(w * 0.48, h * 0.94)
          ..lineTo(w * 0.43, h * 0.88)
          ..lineTo(w * 0.38, h * 0.94)
          ..close();
        canvas.drawPath(ribbon, Paint()..color = const Color(0xFFF59E0B));
        break;

      case Real3DNavType.missions:
        // 3D Target
        // Shadow
        canvas.drawCircle(Offset(center.dx, center.dy + h * 0.06), w * 0.44, Paint()..color = Colors.black.withValues(alpha: 0.15));
        // Outer ring (red)
        final redPaint = Paint()
          ..shader = const RadialGradient(
            colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
          ).createShader(Rect.fromCircle(center: center, radius: w * 0.44));
        canvas.drawCircle(center, w * 0.44, redPaint);
        // Middle ring (white)
        canvas.drawCircle(center, w * 0.30, Paint()..color = const Color(0xFFF9FAFB));
        // Center bullseye (red)
        canvas.drawCircle(center, w * 0.16, Paint()..color = const Color(0xFFEF4444));
        // Gold Arrow in center
        final arrowShaft = Paint()
          ..color = const Color(0xFFFFD700)
          ..strokeWidth = w * 0.08
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(center.dx + w * 0.28, center.dy - w * 0.28), center, arrowShaft);
        // Flights
        final f1 = Path()
          ..moveTo(center.dx + w * 0.28, center.dy - w * 0.28)
          ..lineTo(center.dx + w * 0.36, center.dy - w * 0.22)
          ..lineTo(center.dx + w * 0.22, center.dy - w * 0.36)
          ..close();
        canvas.drawPath(f1, Paint()..color = const Color(0xFFF59E0B));
        break;

      case Real3DNavType.achievements:
        // 3D Trophy
        final gold = Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFFBEB), Color(0xFFFFD700), Color(0xFFD97706)],
          ).createShader(Rect.fromCenter(center: center, width: w, height: h));
        // Cup
        final cup = Path()
          ..moveTo(center.dx - w * 0.30, center.dy - w * 0.30)
          ..lineTo(center.dx + w * 0.30, center.dy - w * 0.30)
          ..lineTo(center.dx + w * 0.22, center.dy + w * 0.10)
          ..quadraticBezierTo(center.dx, center.dy + w * 0.25, center.dx - w * 0.22, center.dy + w * 0.10)
          ..close();
        canvas.drawPath(cup, gold);
        // Handles
        final hp = Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.09
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(Rect.fromCenter(center: Offset(center.dx - w * 0.32, center.dy - w * 0.12), width: w * 0.26, height: w * 0.32), 1.5, 3.14, false, hp);
        canvas.drawArc(Rect.fromCenter(center: Offset(center.dx + w * 0.32, center.dy - w * 0.12), width: w * 0.26, height: w * 0.32), -1.5, 3.14, false, hp);
        // Base
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(center.dx - w * 0.25, center.dy + w * 0.28, w * 0.50, w * 0.14), const Radius.circular(3)), gold);
        // Center ruby gem
        canvas.drawCircle(Offset(center.dx, center.dy - w * 0.08), w * 0.09, Paint()..color = const Color(0xFFEF4444));
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _Real3DNavPainter old) =>
      old.type != type || old.isSelected != isSelected;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3D REALISTIC TOP BAR ICONS (Streak Flame & XP Star Coin)
// ─────────────────────────────────────────────────────────────────────────────
enum Real3DTopType { flame, xp }

class Real3DTopBarIcon extends StatelessWidget {
  const Real3DTopBarIcon({
    super.key,
    required this.type,
    this.size = 20,
  });

  final Real3DTopType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _Real3DTopPainter(type: type),
      ),
    );
  }
}

class _Real3DTopPainter extends CustomPainter {
  const _Real3DTopPainter({required this.type});
  final Real3DTopType type;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.5, h * 0.5);

    if (type == Real3DTopType.flame) {
      // 3D Volumetric Flame
      // Outer red flame
      final outerFlame = Path()
        ..moveTo(w * 0.50, h * 0.05)
        ..quadraticBezierTo(w * 0.88, h * 0.40, w * 0.82, h * 0.70)
        ..quadraticBezierTo(w * 0.75, h * 0.98, w * 0.50, h * 0.98)
        ..quadraticBezierTo(w * 0.25, h * 0.98, w * 0.18, h * 0.70)
        ..quadraticBezierTo(w * 0.12, h * 0.40, w * 0.50, h * 0.05)
        ..close();
      final outerPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF7A00), Color(0xFFEA2B2B)],
        ).createShader(Rect.fromLTWH(0, 0, w, h));
      canvas.drawPath(outerFlame, outerPaint);

      // Inner golden core
      final innerFlame = Path()
        ..moveTo(w * 0.50, h * 0.35)
        ..quadraticBezierTo(w * 0.74, h * 0.58, w * 0.70, h * 0.78)
        ..quadraticBezierTo(w * 0.65, h * 0.94, w * 0.50, h * 0.94)
        ..quadraticBezierTo(w * 0.35, h * 0.94, w * 0.30, h * 0.78)
        ..quadraticBezierTo(w * 0.26, h * 0.58, w * 0.50, h * 0.35)
        ..close();
      final innerPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFBEB), Color(0xFFFFD700)],
        ).createShader(Rect.fromLTWH(0, 0, w, h));
      canvas.drawPath(innerFlame, innerPaint);

      // Specular gloss dot
      canvas.drawCircle(Offset(w * 0.38, h * 0.45), w * 0.06, Paint()..color = Colors.white.withValues(alpha: 0.8));
    } else {
      // 3D XP Gold Coin with Star
      // Drop shadow
      canvas.drawCircle(Offset(center.dx, center.dy + h * 0.06), w * 0.44, Paint()..color = Colors.black.withValues(alpha: 0.18));
      // Outer bevel rim
      final rimPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFDE7), Color(0xFFFFD700), Color(0xFFB45309)],
        ).createShader(Rect.fromCircle(center: center, radius: w * 0.44));
      canvas.drawCircle(center, w * 0.44, rimPaint);
      // Inner face
      canvas.drawCircle(center, w * 0.34, Paint()..color = const Color(0xFFFFC800));
      // 3D Star in center
      final star = Path();
      for (var i = 0; i < 5; i++) {
        final oa = (i * 3.14159265 * 2 / 5) - 3.14159265 / 2;
        final ia = oa + 3.14159265 / 5;
        final ox = center.dx + w * 0.24 * _cos(oa);
        final oy = center.dy + w * 0.24 * _sin(oa);
        final ix = center.dx + w * 0.11 * _cos(ia);
        final iy = center.dy + w * 0.11 * _sin(ia);
        i == 0 ? star.moveTo(ox, oy) : star.lineTo(ox, oy);
        star.lineTo(ix, iy);
      }
      star.close();
      canvas.drawPath(star, Paint()..color = Colors.white);
    }
  }

  static double _cos(double a) {
    double x = a % (2 * 3.14159265358979);
    double r = 1, t = 1;
    for (var i = 1; i <= 6; i++) { t *= -x * x / ((2 * i - 1) * (2 * i)); r += t; }
    return r;
  }

  static double _sin(double a) {
    double x = a % (2 * 3.14159265358979);
    double r = x, t = x;
    for (var i = 1; i <= 6; i++) { t *= -x * x / ((2 * i) * (2 * i + 1)); r += t; }
    return r;
  }

  @override
  bool shouldRepaint(covariant _Real3DTopPainter old) => old.type != type;
}

