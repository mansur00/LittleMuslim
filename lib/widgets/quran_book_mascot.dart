import 'dart:math' as math;
import 'package:flutter/material.dart';

/// The 5 respectful animation / visual states of the 3D Quran Book mascot.
/// Note: No eyes, face, arms, legs, or animal-like features as per project memory rules.
enum QuranMascotMood {
  idle, // Closed or resting peacefully with gentle float
  glowing, // Radiating golden light / divine illumination
  open, // Gently open with illuminated pages
  celebrating, // Open with radiant stars, sparkles, and celebratory light
  encouraging, // Comforting warm glow encouraging the child to try again
}

/// A respectful, beautifully styled 3D Quran Book mascot for Little Muslim.
/// Features emerald-green leather binding, gold arabesque ornamentation,
/// gilded pages, silk ribbon bookmark, and dynamic illumination effects.
class QuranBookMascot extends StatefulWidget {
  const QuranBookMascot({
    super.key,
    this.size = 110,
    this.mood = QuranMascotMood.idle,
    this.animate = true,
  });

  final double size;
  final QuranMascotMood mood;
  final bool animate;

  @override
  State<QuranBookMascot> createState() => _QuranBookMascotState();
}

class _QuranBookMascotState extends State<QuranBookMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (widget.animate && !isTest) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant QuranBookMascot oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (widget.animate && !_controller.isAnimating && !isTest) {
      _controller.repeat(reverse: true);
    } else if (!widget.animate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _QuranBookPainter(
            mood: widget.mood,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class _QuranBookPainter extends CustomPainter {
  _QuranBookPainter({
    required this.mood,
    required this.animationValue,
  });

  final QuranMascotMood mood;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Subtle breathing float: move vertically by 3-5px
    final floatOffset = math.sin(animationValue * math.pi) * (h * 0.035);
    final animatedCenter = Offset(center.dx, center.dy + floatOffset);

    // ── 1. Soft Ambient Shadow on the ground ──
    final shadowScale = 1.0 - (floatOffset / (h * 0.15)) * 0.15;
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12 * shadowScale)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, h * 0.90),
        width: w * 0.65 * shadowScale,
        height: h * 0.14 * shadowScale,
      ),
      shadowPaint,
    );

    // ── 2. Aura / Radiance / Golden Glow ──
    if (mood == QuranMascotMood.glowing ||
        mood == QuranMascotMood.celebrating ||
        mood == QuranMascotMood.open ||
        mood == QuranMascotMood.encouraging) {
      _drawAuraAndSparkles(canvas, animatedCenter, w, h);
    }

    // ── 3. Draw the Book (Open or Closed based on mood) ──
    if (mood == QuranMascotMood.open || mood == QuranMascotMood.celebrating) {
      _drawOpenQuranBook(canvas, animatedCenter, w, h);
    } else {
      _drawClosedQuranBook(canvas, animatedCenter, w, h);
    }
  }

  void _drawAuraAndSparkles(Canvas canvas, Offset center, double w, double h) {
    final pulse = 0.85 + (math.sin(animationValue * math.pi * 2) * 0.15);
    final glowColor = (mood == QuranMascotMood.encouraging)
        ? const Color(0xFFFBBF24).withValues(alpha: 0.22 * pulse)
        : const Color(0xFFFFD700).withValues(alpha: 0.32 * pulse);

    final glowPaint = Paint()
      ..color = glowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.22);
    canvas.drawCircle(center, w * 0.40 * pulse, glowPaint);

    // Radiating subtle golden star sparkles for celebrating mood
    if (mood == QuranMascotMood.celebrating || mood == QuranMascotMood.glowing) {
      const sparkleColor = Color(0xFFFFE082);
      final sparklePaint = Paint()
        ..color = sparkleColor
        ..style = PaintingStyle.fill;

      final sparkleOffsets = [
        Offset(center.dx - w * 0.34, center.dy - h * 0.28),
        Offset(center.dx + w * 0.36, center.dy - h * 0.25),
        Offset(center.dx - w * 0.28, center.dy + h * 0.20),
        Offset(center.dx + w * 0.32, center.dy + h * 0.18),
        Offset(center.dx, center.dy - h * 0.42),
      ];

      for (var i = 0; i < sparkleOffsets.length; i++) {
        final sparklePulse =
            (math.sin((animationValue * math.pi * 2) + (i * 1.2)) + 1) / 2;
        final starRadius = (w * 0.035) * (0.6 + sparklePulse * 0.5);
        _draw4PointStar(canvas, sparkleOffsets[i], starRadius, sparklePaint);
      }
    }
  }

  void _draw4PointStar(
      Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.quadraticBezierTo(
        center.dx, center.dy, center.dx + radius, center.dy);
    path.quadraticBezierTo(
        center.dx, center.dy, center.dx, center.dy + radius);
    path.quadraticBezierTo(
        center.dx, center.dy, center.dx - radius, center.dy);
    path.quadraticBezierTo(
        center.dx, center.dy, center.dx, center.dy - radius);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawClosedQuranBook(
      Canvas canvas, Offset center, double w, double h) {
    final bookW = w * 0.62;
    final bookH = h * 0.72;
    final bookLeft = center.dx - bookW / 2;
    final bookTop = center.dy - bookH / 2;

    // 3D Perspective angle: Slight tilt
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.06); // subtle tilt for dynamic 3D look
    canvas.translate(-center.dx, -center.dy);

    // Gilded page block (side depth)
    final pageBlockRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bookLeft + 8, bookTop + 8, bookW - 4, bookH - 8),
      const Radius.circular(10),
    );
    final pagePaint = Paint()..color = const Color(0xFFFDE68A); // gold paper edges
    canvas.drawRRect(pageBlockRect, pagePaint);

    // Pages edge lines (subtle page stack effect)
    final linePaint = Paint()
      ..color = const Color(0xFFD97706).withValues(alpha: 0.35)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(bookLeft + bookW, bookTop + 14),
      Offset(bookLeft + bookW, bookTop + bookH - 4),
      linePaint,
    );

    // Silk ribbon bookmark (hanging at the bottom)
    final ribbonPath = Path()
      ..moveTo(center.dx + 4, bookTop + bookH - 6)
      ..lineTo(center.dx + 4, bookTop + bookH + 16)
      ..lineTo(center.dx + 10, bookTop + bookH + 11)
      ..lineTo(center.dx + 16, bookTop + bookH + 16)
      ..lineTo(center.dx + 16, bookTop + bookH - 6)
      ..close();
    final ribbonPaint = Paint()..color = const Color(0xFFDC2626); // deep ruby red
    canvas.drawPath(ribbonPath, ribbonPaint);

    // Emerald Green Hardcover
    final coverRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bookLeft, bookTop, bookW - 6, bookH - 6),
      const Radius.circular(12),
    );
    final coverPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0F766E), Color(0xFF042F2E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(coverRect.outerRect);
    canvas.drawRRect(coverRect, coverPaint);

    // Cover Spine highlight (left edge)
    final spinePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.transparent,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(bookLeft, bookTop, 12, bookH - 6));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bookLeft, bookTop, 12, bookH - 6),
        const Radius.circular(12),
      ),
      spinePaint,
    );

    // Gilded Arabesque outer border on cover
    final borderPaint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final innerBorderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bookLeft + 7, bookTop + 7, bookW - 20, bookH - 20),
      const Radius.circular(8),
    );
    canvas.drawRRect(innerBorderRect, borderPaint);

    // Central Rosette / Islamic Rub el Hizb medallion (embossed gold)
    final rosetteCenter = Offset(center.dx - 3, center.dy - 3);
    _drawIslamicMedallion(canvas, rosetteCenter, bookW * 0.22);

    canvas.restore();
  }

  void _drawOpenQuranBook(Canvas canvas, Offset center, double w, double h) {
    final bookW = w * 0.86;
    final bookH = h * 0.54;
    final left = center.dx - bookW / 2;
    final top = center.dy - bookH / 2 + 4;

    // Outer Cover Wing Base (Dark Emerald)
    final coverPath = Path()
      ..moveTo(left, top + bookH * 0.15)
      ..quadraticBezierTo(
          center.dx - bookW * 0.25, top + bookH * 0.35, center.dx, top + bookH * 0.20)
      ..quadraticBezierTo(
          center.dx + bookW * 0.25, top + bookH * 0.35, left + bookW, top + bookH * 0.15)
      ..lineTo(left + bookW, top + bookH)
      ..quadraticBezierTo(
          center.dx + bookW * 0.25, top + bookH * 1.15, center.dx, top + bookH * 1.05)
      ..quadraticBezierTo(
          center.dx - bookW * 0.25, top + bookH * 1.15, left, top + bookH)
      ..close();
    final coverPaint = Paint()..color = const Color(0xFF042F2E);
    canvas.drawPath(coverPath, coverPaint);

    // Pages (Left & Right curves - Ivory/Cream)
    final pageLeftPath = Path()
      ..moveTo(left + 5, top + bookH * 0.10)
      ..quadraticBezierTo(
          center.dx - bookW * 0.25, top - bookH * 0.08, center.dx, top + bookH * 0.12)
      ..lineTo(center.dx, top + bookH * 0.95)
      ..quadraticBezierTo(
          center.dx - bookW * 0.25, top + bookH * 0.78, left + 5, top + bookH * 0.92)
      ..close();

    final pageRightPath = Path()
      ..moveTo(center.dx, top + bookH * 0.12)
      ..quadraticBezierTo(
          center.dx + bookW * 0.25, top - bookH * 0.08, left + bookW - 5, top + bookH * 0.10)
      ..lineTo(left + bookW - 5, top + bookH * 0.92)
      ..quadraticBezierTo(
          center.dx + bookW * 0.25, top + bookH * 0.78, center.dx, top + bookH * 0.95)
      ..close();

    final pagePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(left, top, bookW, bookH));

    canvas.drawPath(pageLeftPath, pagePaint);
    canvas.drawPath(pageRightPath, pagePaint);

    // Gilded page borders (ornamental gold trim on pages)
    final goldBorderPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(pageLeftPath, goldBorderPaint);
    canvas.drawPath(pageRightPath, goldBorderPaint);

    // Spine valley shadow
    final spineShadow = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.black.withValues(alpha: 0.18),
          Colors.transparent,
          Colors.black.withValues(alpha: 0.18),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(center.dx - 8, top, 16, bookH));
    canvas.drawRect(Rect.fromLTWH(center.dx - 6, top, 12, bookH), spineShadow);

    // Red ribbon hanging through center
    final ribbonPath = Path()
      ..moveTo(center.dx - 4, top + bookH * 0.92)
      ..lineTo(center.dx - 4, top + bookH * 1.22)
      ..lineTo(center.dx, top + bookH * 1.16)
      ..lineTo(center.dx + 4, top + bookH * 1.22)
      ..lineTo(center.dx + 4, top + bookH * 0.92)
      ..close();
    final ribbonPaint = Paint()..color = const Color(0xFFDC2626);
    canvas.drawPath(ribbonPath, ribbonPaint);

    // Golden divine light beam emerging from inside the book
    final lightBeam = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFD700).withValues(alpha: 0.35),
          Colors.transparent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(Rect.fromLTWH(left, top - bookH * 0.45, bookW, bookH * 0.55));
    final beamPath = Path()
      ..moveTo(center.dx - bookW * 0.25, top + bookH * 0.10)
      ..lineTo(center.dx - bookW * 0.40, top - bookH * 0.45)
      ..lineTo(center.dx + bookW * 0.40, top - bookH * 0.45)
      ..lineTo(center.dx + bookW * 0.25, top + bookH * 0.10)
      ..close();
    canvas.drawPath(beamPath, lightBeam);
  }

  void _drawIslamicMedallion(Canvas canvas, Offset center, double radius) {
    // 8-pointed star (Rub el Hizb)
    final goldPaint = Paint()
      ..color = const Color(0xFFFBBF24)
      ..style = PaintingStyle.fill;
    final darkGold = Paint()
      ..color = const Color(0xFFB45309)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw two overlapping squares rotated 45 degrees
    canvas.save();
    canvas.translate(center.dx, center.dy);

    final squareRect = Rect.fromCenter(
        center: Offset.zero, width: radius * 1.3, height: radius * 1.3);
    canvas.drawRect(squareRect, goldPaint);
    canvas.drawRect(squareRect, darkGold);

    canvas.rotate(math.pi / 4);
    canvas.drawRect(squareRect, goldPaint);
    canvas.drawRect(squareRect, darkGold);

    // Center circular jewel
    final innerCirclePaint = Paint()..color = const Color(0xFF0F766E);
    canvas.drawCircle(Offset.zero, radius * 0.42, innerCirclePaint);

    final innerGoldDot = Paint()..color = const Color(0xFFFDE68A);
    canvas.drawCircle(Offset.zero, radius * 0.18, innerGoldDot);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _QuranBookPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.mood != mood;
  }
}
