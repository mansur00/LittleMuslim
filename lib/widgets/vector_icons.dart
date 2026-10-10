import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Colorful vector icon widgets — no emoji. Duolingo-inspired playful shapes.

class VectorIcon extends StatelessWidget {
  const VectorIcon({
    super.key,
    required this.type,
    this.size = 48,
    this.color,
  });

  final VectorIconType type;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _VectorIconPainter(type: type, color: color),
      ),
    );
  }
}

enum VectorIconType {
  crescent,
  book,
  mosque,
  dua,
  scroll,
  trophy,
  target,
  flame,
  star,
  lock,
  check,
  qaida,
  xp,
  pathNode,
  sparkle,
  shield,
}

class _VectorIconPainter extends CustomPainter {
  _VectorIconPainter({required this.type, this.color});
  final VectorIconType type;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    switch (type) {
      case VectorIconType.crescent:
        _drawCrescent(canvas, s);
      case VectorIconType.book:
        _drawBook(canvas, s);
      case VectorIconType.mosque:
        _drawMosque(canvas, s);
      case VectorIconType.dua:
        _drawDua(canvas, s);
      case VectorIconType.scroll:
        _drawScroll(canvas, s);
      case VectorIconType.trophy:
        _drawTrophy(canvas, s);
      case VectorIconType.target:
        _drawTarget(canvas, s);
      case VectorIconType.flame:
        _drawFlame(canvas, s);
      case VectorIconType.star:
        _drawStar(canvas, s);
      case VectorIconType.lock:
        _drawLock(canvas, s);
      case VectorIconType.check:
        _drawCheck(canvas, s);
      case VectorIconType.qaida:
        _drawQaida(canvas, s);
      case VectorIconType.xp:
        _drawXp(canvas, s);
      case VectorIconType.pathNode:
        _drawPathNode(canvas, s);
      case VectorIconType.sparkle:
        _drawSparkle(canvas, s);
      case VectorIconType.shield:
        _drawShield(canvas, s);
    }
  }

  void _drawCrescent(Canvas canvas, double s) {
    final bg = Paint()..color = color ?? const Color(0xFF0D7377);
    final star = Paint()..color = const Color(0xFFD4A017);
    // Outer circle
    canvas.drawCircle(Offset(s * 0.48, s * 0.5), s * 0.38, bg);
    // Cutout for crescent
    canvas.drawCircle(
      Offset(s * 0.62, s * 0.42),
      s * 0.30,
      Paint()..color = Colors.white.withValues(alpha: 0.01),
    );
    // Use blend to cut — draw cream cutout on top if needed; instead draw arc path
    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset(s * 0.48, s * 0.5), radius: s * 0.38));
    final cut = Path()
      ..addOval(Rect.fromCircle(center: Offset(s * 0.64, s * 0.40), radius: s * 0.30));
    final crescent = Path.combine(PathOperation.difference, path, cut);
    canvas.drawPath(crescent, bg);
    // Small star
    _star(canvas, Offset(s * 0.72, s * 0.28), s * 0.10, star);
  }

  void _drawBook(Canvas canvas, double s) {
    final cover = Paint()..color = color ?? const Color(0xFFE8913A);
    final page = Paint()..color = const Color(0xFFFFF8E7);
    final spine = Paint()..color = const Color(0xFFC46B1A);
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.18, s * 0.15, s * 0.64, s * 0.70),
      Radius.circular(s * 0.06),
    );
    canvas.drawRRect(r, cover);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.26, s * 0.22, s * 0.50, s * 0.56),
        Radius.circular(s * 0.03),
      ),
      page,
    );
    canvas.drawRect(Rect.fromLTWH(s * 0.18, s * 0.15, s * 0.08, s * 0.70), spine);
    // Lines
    final line = Paint()
      ..color = const Color(0xFFE8913A).withValues(alpha: 0.35)
      ..strokeWidth = 1.5;
    for (var i = 0; i < 4; i++) {
      final y = s * 0.35 + i * s * 0.1;
      canvas.drawLine(Offset(s * 0.32, y), Offset(s * 0.70, y), line);
    }
  }

  void _drawMosque(Canvas canvas, double s) {
    final wall = Paint()..color = color ?? const Color(0xFF3B82C4);
    final dome = Paint()..color = const Color(0xFF2563A8);
    final gold = Paint()..color = const Color(0xFFD4A017);
    // Base
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.15, s * 0.48, s * 0.70, s * 0.38),
        Radius.circular(s * 0.04),
      ),
      wall,
    );
    // Dome
    canvas.drawArc(
      Rect.fromLTWH(s * 0.22, s * 0.18, s * 0.56, s * 0.50),
      math.pi,
      math.pi,
      true,
      dome,
    );
    // Minaret left
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.08, s * 0.30, s * 0.12, s * 0.56),
        Radius.circular(s * 0.02),
      ),
      wall,
    );
    canvas.drawCircle(Offset(s * 0.14, s * 0.28), s * 0.07, gold);
    // Door
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.40, s * 0.58, s * 0.20, s * 0.28),
        Radius.circular(s * 0.08),
      ),
      Paint()..color = const Color(0xFF1E4A7A),
    );
  }

  void _drawDua(Canvas canvas, double s) {
    final hands = Paint()..color = color ?? const Color(0xFF9B6BC9);
    final glow = Paint()..color = const Color(0xFFF5E6C8);
    // Glow circle
    canvas.drawCircle(Offset(s * 0.5, s * 0.38), s * 0.18, glow);
    // Left hand
    final left = Path()
      ..moveTo(s * 0.22, s * 0.72)
      ..quadraticBezierTo(s * 0.15, s * 0.45, s * 0.35, s * 0.42)
      ..quadraticBezierTo(s * 0.42, s * 0.50, s * 0.40, s * 0.68)
      ..close();
    canvas.drawPath(left, hands);
    // Right hand
    final right = Path()
      ..moveTo(s * 0.78, s * 0.72)
      ..quadraticBezierTo(s * 0.85, s * 0.45, s * 0.65, s * 0.42)
      ..quadraticBezierTo(s * 0.58, s * 0.50, s * 0.60, s * 0.68)
      ..close();
    canvas.drawPath(right, hands);
    // Spark
    _star(canvas, Offset(s * 0.5, s * 0.28), s * 0.08, Paint()..color = const Color(0xFFD4A017));
  }

  void _drawScroll(Canvas canvas, double s) {
    final paper = Paint()..color = color ?? const Color(0xFFF5E6C8);
    final roll = Paint()..color = const Color(0xFFD4A017);
    final ink = Paint()
      ..color = const Color(0xFF1A3C34).withValues(alpha: 0.5)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.22, s * 0.18, s * 0.56, s * 0.64),
        Radius.circular(s * 0.04),
      ),
      paper,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.18, s * 0.14, s * 0.64, s * 0.12),
        Radius.circular(s * 0.06),
      ),
      roll,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.18, s * 0.74, s * 0.64, s * 0.12),
        Radius.circular(s * 0.06),
      ),
      roll,
    );
    for (var i = 0; i < 3; i++) {
      final y = s * 0.38 + i * s * 0.1;
      canvas.drawLine(Offset(s * 0.32, y), Offset(s * 0.68, y), ink);
    }
  }

  void _drawTrophy(Canvas canvas, double s) {
    final cup = Paint()..color = color ?? const Color(0xFFD4A017);
    final base = Paint()..color = const Color(0xFFB8860B);
    // Cup body
    final cupPath = Path()
      ..moveTo(s * 0.28, s * 0.22)
      ..lineTo(s * 0.72, s * 0.22)
      ..quadraticBezierTo(s * 0.70, s * 0.55, s * 0.55, s * 0.62)
      ..lineTo(s * 0.45, s * 0.62)
      ..quadraticBezierTo(s * 0.30, s * 0.55, s * 0.28, s * 0.22)
      ..close();
    canvas.drawPath(cupPath, cup);
    // Handles
    canvas.drawArc(
      Rect.fromLTWH(s * 0.08, s * 0.26, s * 0.24, s * 0.28),
      -math.pi / 2,
      -math.pi,
      false,
      Paint()
        ..color = const Color(0xFFD4A017)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.06,
    );
    canvas.drawArc(
      Rect.fromLTWH(s * 0.68, s * 0.26, s * 0.24, s * 0.28),
      -math.pi / 2,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFFD4A017)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.06,
    );
    // Stem + base
    canvas.drawRect(Rect.fromLTWH(s * 0.44, s * 0.62, s * 0.12, s * 0.12), base);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.30, s * 0.74, s * 0.40, s * 0.12),
        Radius.circular(s * 0.03),
      ),
      base,
    );
  }

  void _drawTarget(Canvas canvas, double s) {
    final c = Offset(s * 0.5, s * 0.5);
    canvas.drawCircle(c, s * 0.40, Paint()..color = color ?? const Color(0xFFFF6B4A));
    canvas.drawCircle(c, s * 0.28, Paint()..color = Colors.white);
    canvas.drawCircle(c, s * 0.16, Paint()..color = color ?? const Color(0xFFFF6B4A));
    canvas.drawCircle(c, s * 0.06, Paint()..color = Colors.white);
  }

  void _drawFlame(Canvas canvas, double s) {
    final outer = Paint()..color = color ?? const Color(0xFFFF6B35);
    final inner = Paint()..color = const Color(0xFFFFC94F);
    final flame = Path()
      ..moveTo(s * 0.50, s * 0.12)
      ..quadraticBezierTo(s * 0.78, s * 0.40, s * 0.70, s * 0.62)
      ..quadraticBezierTo(s * 0.62, s * 0.82, s * 0.50, s * 0.88)
      ..quadraticBezierTo(s * 0.38, s * 0.82, s * 0.30, s * 0.62)
      ..quadraticBezierTo(s * 0.22, s * 0.40, s * 0.50, s * 0.12)
      ..close();
    canvas.drawPath(flame, outer);
    final core = Path()
      ..moveTo(s * 0.50, s * 0.38)
      ..quadraticBezierTo(s * 0.62, s * 0.52, s * 0.58, s * 0.68)
      ..quadraticBezierTo(s * 0.52, s * 0.78, s * 0.50, s * 0.80)
      ..quadraticBezierTo(s * 0.48, s * 0.78, s * 0.42, s * 0.68)
      ..quadraticBezierTo(s * 0.38, s * 0.52, s * 0.50, s * 0.38)
      ..close();
    canvas.drawPath(core, inner);
  }

  void _drawStar(Canvas canvas, double s) {
    _star(canvas, Offset(s * 0.5, s * 0.5), s * 0.40, Paint()..color = color ?? const Color(0xFFD4A017));
  }

  void _drawLock(Canvas canvas, double s) {
    final body = Paint()..color = color ?? const Color(0xFF8B9AAB);
    final shackle = Paint()
      ..color = color ?? const Color(0xFF6B7A8B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.08
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromLTWH(s * 0.28, s * 0.12, s * 0.44, s * 0.40),
      math.pi,
      math.pi,
      false,
      shackle,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.22, s * 0.42, s * 0.56, s * 0.42),
        Radius.circular(s * 0.08),
      ),
      body,
    );
    canvas.drawCircle(Offset(s * 0.5, s * 0.58), s * 0.06, Paint()..color = Colors.white);
    canvas.drawRect(
      Rect.fromLTWH(s * 0.47, s * 0.58, s * 0.06, s * 0.14),
      Paint()..color = Colors.white,
    );
  }

  void _drawCheck(Canvas canvas, double s) {
    canvas.drawCircle(
      Offset(s * 0.5, s * 0.5),
      s * 0.40,
      Paint()..color = color ?? const Color(0xFF58CC02),
    );
    final check = Path()
      ..moveTo(s * 0.28, s * 0.50)
      ..lineTo(s * 0.44, s * 0.66)
      ..lineTo(s * 0.74, s * 0.34);
    canvas.drawPath(
      check,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.10
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawQaida(Canvas canvas, double s) {
    final bg = Paint()..color = color ?? const Color(0xFF58A700);
    final letter = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.12, s * 0.12, s * 0.76, s * 0.76),
        Radius.circular(s * 0.18),
      ),
      bg,
    );
    // Stylized Alif-like shape
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.42, s * 0.24, s * 0.14, s * 0.52),
        Radius.circular(s * 0.07),
      ),
      letter,
    );
    canvas.drawCircle(Offset(s * 0.49, s * 0.22), s * 0.08, letter);
  }

  void _drawXp(Canvas canvas, double s) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.08, s * 0.22, s * 0.84, s * 0.56),
        Radius.circular(s * 0.16),
      ),
      Paint()..color = color ?? const Color(0xFFFFC800),
    );
  }

  void _drawPathNode(Canvas canvas, double s) {
    canvas.drawCircle(
      Offset(s * 0.5, s * 0.5),
      s * 0.42,
      Paint()..color = color ?? const Color(0xFF58CC02),
    );
    canvas.drawCircle(
      Offset(s * 0.5, s * 0.5),
      s * 0.42,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.08,
    );
  }

  void _drawSparkle(Canvas canvas, double s) {
    final p = Paint()..color = color ?? const Color(0xFFD4A017);
    _star(canvas, Offset(s * 0.5, s * 0.5), s * 0.28, p);
    _star(canvas, Offset(s * 0.22, s * 0.28), s * 0.12, p);
    _star(canvas, Offset(s * 0.78, s * 0.70), s * 0.10, p);
  }

  void _drawShield(Canvas canvas, double s) {
    final body = Paint()..color = color ?? const Color(0xFF0D7377);
    final path = Path()
      ..moveTo(s * 0.50, s * 0.12)
      ..lineTo(s * 0.82, s * 0.28)
      ..lineTo(s * 0.82, s * 0.52)
      ..quadraticBezierTo(s * 0.82, s * 0.78, s * 0.50, s * 0.90)
      ..quadraticBezierTo(s * 0.18, s * 0.78, s * 0.18, s * 0.52)
      ..lineTo(s * 0.18, s * 0.28)
      ..close();
    canvas.drawPath(path, body);
    _star(canvas, Offset(s * 0.5, s * 0.48), s * 0.16, Paint()..color = const Color(0xFFD4A017));
  }

  void _star(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final a = -math.pi / 2 + i * 2 * math.pi / 5;
      final a2 = a + math.pi / 5;
      final p1 = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      final p2 = Offset(c.dx + r * 0.4 * math.cos(a2), c.dy + r * 0.4 * math.sin(a2));
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
  bool shouldRepaint(covariant _VectorIconPainter old) =>
      old.type != type || old.color != color;
}

/// Soft circular badge behind a vector icon (Duolingo-style).
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.type,
    required this.bgColor,
    this.size = 56,
    this.iconSize,
    this.iconColor,
  });

  final VectorIconType type;
  final Color bgColor;
  final double size;
  final double? iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: VectorIcon(
          type: type,
          size: iconSize ?? size * 0.55,
          color: iconColor,
        ),
      ),
    );
  }
}
