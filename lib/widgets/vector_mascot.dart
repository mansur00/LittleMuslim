import 'dart:math' as math;
import 'package:flutter/material.dart';

enum MascotMood {
  happy,
  waving,
  celebrating,
  studying,
  thinking,
}

/// Fully vector-based cute Little Muslim mascot "Noor"
/// Designed with Duolingo-style charm, expressive eyes, and playful Islamic identity.
class VectorMascot extends StatelessWidget {
  const VectorMascot({
    super.key,
    this.size = 100,
    this.mood = MascotMood.happy,
    this.showCap = true,
  });

  final double size;
  final MascotMood mood;
  final bool showCap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MascotPainter(mood: mood, showCap: showCap),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  _MascotPainter({required this.mood, required this.showCap});

  final MascotMood mood;
  final bool showCap;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;

    // Color Palette
    const skinColor = Color(0xFFFFDFC4);
    const skinShadow = Color(0xFFF3C7A5);
    const blushColor = Color(0xFFFFB2A6);
    const eyeColor = Color(0xFF2C3E50);
    const capColor = Color(0xFF0D7377);
    const capGold = Color(0xFFFFD54F);
    const shirtColor = Color(0xFF149A8C);
    const mouthColor = Color(0xFFD32F2F);

    // 1. Shadow beneath mascot
    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.08);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(s * 0.5, s * 0.94),
        width: s * 0.65,
        height: s * 0.12,
      ),
      shadowPaint,
    );

    // 2. Body / Tunic
    final bodyPaint = Paint()..color = shirtColor;
    final bodyPath = Path()
      ..moveTo(s * 0.28, s * 0.72)
      ..quadraticBezierTo(s * 0.20, s * 0.92, s * 0.22, s * 0.94)
      ..lineTo(s * 0.78, s * 0.94)
      ..quadraticBezierTo(s * 0.80, s * 0.92, s * 0.72, s * 0.72)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Collar / Gold Trim
    final trimPaint = Paint()
      ..color = capGold
      ..strokeWidth = s * 0.03
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(s * 0.5, s * 0.70),
        width: s * 0.22,
        height: s * 0.10,
      ),
      0,
      math.pi,
      false,
      trimPaint,
    );

    // 3. Hands based on mood
    final handPaint = Paint()..color = skinColor;
    if (mood == MascotMood.waving) {
      // Left hand waving up
      final handPath = Path()
        ..moveTo(s * 0.26, s * 0.74)
        ..quadraticBezierTo(s * 0.12, s * 0.55, s * 0.14, s * 0.40);
      canvas.drawPath(
        handPath,
        Paint()
          ..color = shirtColor
          ..strokeWidth = s * 0.09
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
      canvas.drawCircle(Offset(s * 0.14, s * 0.38), s * 0.07, handPaint);
      // Right hand resting
      canvas.drawCircle(Offset(s * 0.76, s * 0.78), s * 0.065, handPaint);
    } else if (mood == MascotMood.celebrating) {
      // Both hands raised!
      canvas.drawLine(
        Offset(s * 0.26, s * 0.74),
        Offset(s * 0.15, s * 0.42),
        Paint()
          ..color = shirtColor
          ..strokeWidth = s * 0.09
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(Offset(s * 0.15, s * 0.40), s * 0.07, handPaint);

      canvas.drawLine(
        Offset(s * 0.74, s * 0.74),
        Offset(s * 0.85, s * 0.42),
        Paint()
          ..color = shirtColor
          ..strokeWidth = s * 0.09
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(Offset(s * 0.85, s * 0.40), s * 0.07, handPaint);

      // Sparkles around hands
      _drawSmallSparkle(canvas, Offset(s * 0.12, s * 0.26), s * 0.05, capGold);
      _drawSmallSparkle(canvas, Offset(s * 0.88, s * 0.26), s * 0.05, capGold);
    } else if (mood == MascotMood.studying) {
      // Hands holding Quran book
      canvas.drawCircle(Offset(s * 0.32, s * 0.78), s * 0.065, handPaint);
      canvas.drawCircle(Offset(s * 0.68, s * 0.78), s * 0.065, handPaint);
      // Small Quran in front
      final bookPaint = Paint()..color = const Color(0xFF006C35);
      final pagePaint = Paint()..color = const Color(0xFFFFF9E6);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(s * 0.5, s * 0.80),
            width: s * 0.36,
            height: s * 0.22,
          ),
          Radius.circular(s * 0.03),
        ),
        bookPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(s * 0.5, s * 0.80),
            width: s * 0.30,
            height: s * 0.18,
          ),
          Radius.circular(s * 0.02),
        ),
        pagePaint,
      );
    } else if (mood == MascotMood.thinking) {
      // Right hand to chin
      canvas.drawCircle(Offset(s * 0.26, s * 0.78), s * 0.065, handPaint);
      canvas.drawLine(
        Offset(s * 0.74, s * 0.74),
        Offset(s * 0.60, s * 0.64),
        Paint()
          ..color = shirtColor
          ..strokeWidth = s * 0.08
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(Offset(s * 0.60, s * 0.64), s * 0.065, handPaint);
    } else {
      // Happy hands resting
      canvas.drawCircle(Offset(s * 0.24, s * 0.78), s * 0.065, handPaint);
      canvas.drawCircle(Offset(s * 0.76, s * 0.78), s * 0.065, handPaint);
    }

    // 4. Ears
    canvas.drawCircle(Offset(s * 0.18, s * 0.48), s * 0.09, handPaint);
    canvas.drawCircle(Offset(s * 0.82, s * 0.48), s * 0.09, handPaint);
    canvas.drawCircle(Offset(s * 0.18, s * 0.48), s * 0.05, Paint()..color = skinShadow);
    canvas.drawCircle(Offset(s * 0.82, s * 0.48), s * 0.05, Paint()..color = skinShadow);

    // 5. Head / Round face
    final headRect = Rect.fromCenter(
      center: Offset(s * 0.5, s * 0.48),
      width: s * 0.64,
      height: s * 0.60,
    );
    canvas.drawOval(headRect, Paint()..color = skinColor);

    // 6. Hair / Cap
    if (showCap) {
      // Islamic Kufi cap (Teal with golden geometric embroidery)
      final capPath = Path()
        ..moveTo(s * 0.20, s * 0.44)
        ..quadraticBezierTo(s * 0.18, s * 0.20, s * 0.50, s * 0.16)
        ..quadraticBezierTo(s * 0.82, s * 0.20, s * 0.80, s * 0.44)
        ..quadraticBezierTo(s * 0.50, s * 0.40, s * 0.20, s * 0.44)
        ..close();
      canvas.drawPath(capPath, Paint()..color = capColor);

      // Cap rim band
      final rimPaint = Paint()
        ..color = capGold
        ..strokeWidth = s * 0.025
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(s * 0.5, s * 0.43),
          width: s * 0.58,
          height: s * 0.12,
        ),
        0,
        math.pi,
        false,
        rimPaint,
      );

      // Crescent & star embroidery on cap
      _drawMiniCrescent(canvas, Offset(s * 0.5, s * 0.28), s * 0.055, capGold);
    } else {
      // Cute short boy/girl hair
      final hairPath = Path()
        ..moveTo(s * 0.18, s * 0.44)
        ..quadraticBezierTo(s * 0.16, s * 0.18, s * 0.50, s * 0.18)
        ..quadraticBezierTo(s * 0.84, s * 0.18, s * 0.82, s * 0.44)
        ..quadraticBezierTo(s * 0.50, s * 0.36, s * 0.18, s * 0.44)
        ..close();
      canvas.drawPath(hairPath, Paint()..color = const Color(0xFF3E2723));
    }

    // 7. Cheeks / Blush
    final blushPaint = Paint()..color = blushColor.withValues(alpha: 0.6);
    canvas.drawCircle(Offset(s * 0.29, s * 0.56), s * 0.07, blushPaint);
    canvas.drawCircle(Offset(s * 0.71, s * 0.56), s * 0.07, blushPaint);

    // 8. Eyes
    if (mood == MascotMood.celebrating) {
      // Happy curved arcs (^_^)
      final eyeArcPaint = Paint()
        ..color = eyeColor
        ..strokeWidth = s * 0.035
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(s * 0.36, s * 0.48),
          width: s * 0.12,
          height: s * 0.08,
        ),
        math.pi,
        math.pi,
        false,
        eyeArcPaint,
      );
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(s * 0.64, s * 0.48),
          width: s * 0.12,
          height: s * 0.08,
        ),
        math.pi,
        math.pi,
        false,
        eyeArcPaint,
      );
    } else {
      // Big, cute, sparkling anime eyes!
      final eyePaint = Paint()..color = eyeColor;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(s * 0.36, s * 0.49),
          width: s * 0.10,
          height: s * 0.14,
        ),
        eyePaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(s * 0.64, s * 0.49),
          width: s * 0.10,
          height: s * 0.14,
        ),
        eyePaint,
      );

      // Eye highlights (sparkles)
      final highlightPaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(s * 0.34, s * 0.46), s * 0.038, highlightPaint);
      canvas.drawCircle(Offset(s * 0.38, s * 0.52), s * 0.018, highlightPaint);

      canvas.drawCircle(Offset(s * 0.62, s * 0.46), s * 0.038, highlightPaint);
      canvas.drawCircle(Offset(s * 0.66, s * 0.52), s * 0.018, highlightPaint);
    }

    // 9. Eyebrows
    final browPaint = Paint()
      ..color = const Color(0xFF4A3728)
      ..strokeWidth = s * 0.025
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    if (mood == MascotMood.thinking) {
      // One brow raised
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(s * 0.36, s * 0.39),
          width: s * 0.12,
          height: s * 0.05,
        ),
        math.pi,
        math.pi,
        false,
        browPaint,
      );
      canvas.drawLine(
        Offset(s * 0.58, s * 0.41),
        Offset(s * 0.70, s * 0.38),
        browPaint,
      );
    } else {
      // Happy gentle curves
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(s * 0.36, s * 0.40),
          width: s * 0.12,
          height: s * 0.05,
        ),
        math.pi,
        math.pi,
        false,
        browPaint,
      );
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(s * 0.64, s * 0.40),
          width: s * 0.12,
          height: s * 0.05,
        ),
        math.pi,
        math.pi,
        false,
        browPaint,
      );
    }

    // 10. Cute Mouth
    if (mood == MascotMood.celebrating || mood == MascotMood.waving) {
      // Big open cheerful smile :D
      final mouthPath = Path()
        ..moveTo(s * 0.42, s * 0.60)
        ..quadraticBezierTo(s * 0.50, s * 0.72, s * 0.58, s * 0.60)
        ..close();
      canvas.drawPath(mouthPath, Paint()..color = mouthColor);
      // Tongue
      final tonguePath = Path()
        ..moveTo(s * 0.45, s * 0.66)
        ..quadraticBezierTo(s * 0.50, s * 0.72, s * 0.55, s * 0.66)
        ..close();
      canvas.drawPath(tonguePath, Paint()..color = const Color(0xFFFF8A80));
    } else {
      // Gentle happy curve
      final mouthPaint = Paint()
        ..color = const Color(0xFF6D4C41)
        ..strokeWidth = s * 0.03
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final smile = Path()
        ..moveTo(s * 0.43, s * 0.61)
        ..quadraticBezierTo(s * 0.50, s * 0.68, s * 0.57, s * 0.61);
      canvas.drawPath(smile, mouthPaint);
    }
  }

  void _drawMiniCrescent(Canvas canvas, Offset c, double r, Color col) {
    final path = Path()
      ..addOval(Rect.fromCircle(center: c, radius: r));
    final cut = Path()
      ..addOval(Rect.fromCircle(center: Offset(c.dx + r * 0.35, c.dy - r * 0.2), radius: r * 0.8));
    final crescent = Path.combine(PathOperation.difference, path, cut);
    canvas.drawPath(crescent, Paint()..color = col);
  }

  void _drawSmallSparkle(Canvas canvas, Offset c, double r, Color col) {
    final paint = Paint()..color = col;
    final path = Path();
    for (var i = 0; i < 4; i++) {
      final a = i * math.pi / 2;
      final a2 = a + math.pi / 4;
      final p1 = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      final p2 = Offset(c.dx + r * 0.3 * math.cos(a2), c.dy + r * 0.3 * math.sin(a2));
      if (i == 0) {
        path.moveTo(p1.dx, p1.dy);
      } else {
        path.lineTo(p1.dx, p1.dy);
      }
      path.lineTo(p2.dx, p2.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) =>
      oldDelegate.mood != mood || oldDelegate.showCap != showCap;
}

/// Mascot with speech bubble card (like Reference 2 & 3)
class MascotSpeechBanner extends StatelessWidget {
  const MascotSpeechBanner({
    super.key,
    required this.message,
    this.title = 'নুর বলছে',
    this.mood = MascotMood.happy,
    this.mascotSize = 78,
  });

  final String message;
  final String title;
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D7377),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        title,
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
                Text(
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
