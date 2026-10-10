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
  chest,
  chestOpen,
  lightbulb,
  flag,
  globe,
  plant,
  bird,
  smile,
  flagBd,
  flagGb,
  flagSa,
  heart,
  compass,
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
      case VectorIconType.chest:
        _drawChest(canvas, s);
      case VectorIconType.chestOpen:
        _drawChestOpen(canvas, s);
      case VectorIconType.lightbulb:
        _drawLightbulb(canvas, s);
      case VectorIconType.flag:
        _drawFlag(canvas, s);
      case VectorIconType.globe:
        _drawGlobe(canvas, s);
      case VectorIconType.plant:
        _drawPlant(canvas, s);
      case VectorIconType.bird:
        _drawBird(canvas, s);
      case VectorIconType.smile:
        _drawSmile(canvas, s);
      case VectorIconType.flagBd:
        _drawFlagBd(canvas, s);
      case VectorIconType.flagGb:
        _drawFlagGb(canvas, s);
      case VectorIconType.flagSa:
        _drawFlagSa(canvas, s);
      case VectorIconType.heart:
        _drawHeart(canvas, s);
      case VectorIconType.compass:
        _drawCompass(canvas, s);
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
      ..addOval(
          Rect.fromCircle(center: Offset(s * 0.48, s * 0.5), radius: s * 0.38));
    final cut = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(s * 0.64, s * 0.40), radius: s * 0.30));
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
    canvas.drawRect(
        Rect.fromLTWH(s * 0.18, s * 0.15, s * 0.08, s * 0.70), spine);
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
    _star(canvas, Offset(s * 0.5, s * 0.28), s * 0.08,
        Paint()..color = const Color(0xFFD4A017));
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
    canvas.drawRect(
        Rect.fromLTWH(s * 0.44, s * 0.62, s * 0.12, s * 0.12), base);
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
    canvas.drawCircle(
        c, s * 0.40, Paint()..color = color ?? const Color(0xFFFF6B4A));
    canvas.drawCircle(c, s * 0.28, Paint()..color = Colors.white);
    canvas.drawCircle(
        c, s * 0.16, Paint()..color = color ?? const Color(0xFFFF6B4A));
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
    _star(canvas, Offset(s * 0.5, s * 0.5), s * 0.40,
        Paint()..color = color ?? const Color(0xFFD4A017));
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
    canvas.drawCircle(
        Offset(s * 0.5, s * 0.58), s * 0.06, Paint()..color = Colors.white);
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
    _star(canvas, Offset(s * 0.5, s * 0.48), s * 0.16,
        Paint()..color = const Color(0xFFD4A017));
  }

  void _drawChest(Canvas canvas, double s) {
    final wood = Paint()..color = color ?? const Color(0xFFC07A38);
    final gold = Paint()..color = const Color(0xFFFFD54F);
    final dark = Paint()..color = const Color(0xFF7A481F);
    // Base chest
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.15, s * 0.42, s * 0.70, s * 0.44),
      Radius.circular(s * 0.08),
    );
    canvas.drawRRect(baseRect, wood);
    // Lid
    final lidRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.12, s * 0.22, s * 0.76, s * 0.24),
      Radius.circular(s * 0.08),
    );
    canvas.drawRRect(lidRect, wood);
    // Gold straps
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.28, s * 0.22, s * 0.10, s * 0.64),
          Radius.circular(s * 0.02)),
      gold,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.62, s * 0.22, s * 0.10, s * 0.64),
          Radius.circular(s * 0.02)),
      gold,
    );
    // Keyhole plate
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.43, s * 0.40, s * 0.14, s * 0.16),
          Radius.circular(s * 0.04)),
      gold,
    );
    canvas.drawCircle(Offset(s * 0.5, s * 0.47), s * 0.035, dark);
  }

  void _drawChestOpen(Canvas canvas, double s) {
    final wood = Paint()..color = color ?? const Color(0xFFC07A38);
    final gold = Paint()..color = const Color(0xFFFFD54F);
    final glow = Paint()..color = const Color(0xFFFFF176);
    // Glow inside
    canvas.drawCircle(Offset(s * 0.5, s * 0.35), s * 0.25, glow);
    _star(canvas, Offset(s * 0.5, s * 0.26), s * 0.14, gold);
    _star(canvas, Offset(s * 0.35, s * 0.30), s * 0.08, gold);
    _star(canvas, Offset(s * 0.65, s * 0.30), s * 0.08, gold);
    // Base chest
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.15, s * 0.46, s * 0.70, s * 0.42),
      Radius.circular(s * 0.08),
    );
    canvas.drawRRect(baseRect, wood);
    // Straps
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.28, s * 0.46, s * 0.10, s * 0.42),
          Radius.circular(s * 0.02)),
      gold,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.62, s * 0.46, s * 0.10, s * 0.42),
          Radius.circular(s * 0.02)),
      gold,
    );
  }

  void _drawLightbulb(Canvas canvas, double s) {
    final bulb = Paint()..color = color ?? const Color(0xFFFFC800);
    final base = Paint()..color = const Color(0xFFB0BEC5);
    // Bulb glass
    final path = Path()
      ..moveTo(s * 0.34, s * 0.55)
      ..arcToPoint(Offset(s * 0.66, s * 0.55),
          radius: Radius.circular(s * 0.24), clockwise: true)
      ..lineTo(s * 0.60, s * 0.70)
      ..lineTo(s * 0.40, s * 0.70)
      ..close();
    canvas.drawPath(path, bulb);
    // Base screw
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.42, s * 0.72, s * 0.16, s * 0.12),
          Radius.circular(s * 0.03)),
      base,
    );
  }

  void _drawFlag(Canvas canvas, double s) {
    final flagPaint = Paint()..color = color ?? const Color(0xFFFF6B4A);
    final pole = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = s * 0.06
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(s * 0.28, s * 0.15), Offset(s * 0.28, s * 0.85), pole);
    final flag = Path()
      ..moveTo(s * 0.28, s * 0.18)
      ..lineTo(s * 0.78, s * 0.32)
      ..lineTo(s * 0.28, s * 0.48)
      ..close();
    canvas.drawPath(flag, flagPaint);
  }

  void _drawGlobe(Canvas canvas, double s) {
    final ocean = Paint()..color = color ?? const Color(0xFF1CB0F6);
    final land = Paint()..color = const Color(0xFF58CC02);
    canvas.drawCircle(Offset(s * 0.5, s * 0.5), s * 0.38, ocean);
    // Land blobs
    canvas.drawCircle(Offset(s * 0.42, s * 0.42), s * 0.16, land);
    canvas.drawCircle(Offset(s * 0.60, s * 0.58), s * 0.14, land);
  }

  void _drawPlant(Canvas canvas, double s) {
    final stem = Paint()
      ..color = color ?? const Color(0xFF58A700)
      ..strokeWidth = s * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final leaf = Paint()..color = color ?? const Color(0xFF58A700);
    canvas.drawLine(Offset(s * 0.5, s * 0.45), Offset(s * 0.5, s * 0.82), stem);
    // Left leaf
    final left = Path()
      ..moveTo(s * 0.5, s * 0.60)
      ..quadraticBezierTo(s * 0.25, s * 0.50, s * 0.22, s * 0.32)
      ..quadraticBezierTo(s * 0.42, s * 0.35, s * 0.5, s * 0.60);
    canvas.drawPath(left, leaf);
    // Right leaf
    final right = Path()
      ..moveTo(s * 0.5, s * 0.52)
      ..quadraticBezierTo(s * 0.75, s * 0.42, s * 0.78, s * 0.24)
      ..quadraticBezierTo(s * 0.58, s * 0.27, s * 0.5, s * 0.52);
    canvas.drawPath(right, leaf);
  }

  void _drawBird(Canvas canvas, double s) {
    final body = Paint()..color = color ?? const Color(0xFF38BDF8);
    // Bird body
    final path = Path()
      ..moveTo(s * 0.24, s * 0.52)
      ..quadraticBezierTo(s * 0.45, s * 0.30, s * 0.72, s * 0.42)
      ..quadraticBezierTo(s * 0.82, s * 0.46, s * 0.88, s * 0.48)
      ..lineTo(s * 0.80, s * 0.54)
      ..quadraticBezierTo(s * 0.60, s * 0.74, s * 0.35, s * 0.68)
      ..close();
    canvas.drawPath(path, body);
    // Wing
    final wing = Path()
      ..moveTo(s * 0.42, s * 0.52)
      ..quadraticBezierTo(s * 0.55, s * 0.32, s * 0.68, s * 0.38)
      ..quadraticBezierTo(s * 0.58, s * 0.62, s * 0.42, s * 0.52);
    canvas.drawPath(wing, Paint()..color = Colors.white.withValues(alpha: 0.8));
  }

  void _drawSmile(Canvas canvas, double s) {
    final face = Paint()..color = color ?? const Color(0xFFFFC800);
    canvas.drawCircle(Offset(s * 0.5, s * 0.5), s * 0.38, face);
    // Eyes
    final eyes = Paint()..color = const Color(0xFF5D4037);
    canvas.drawCircle(Offset(s * 0.38, s * 0.42), s * 0.05, eyes);
    canvas.drawCircle(Offset(s * 0.62, s * 0.42), s * 0.05, eyes);
    // Smile
    final smile = Path()
      ..moveTo(s * 0.35, s * 0.55)
      ..quadraticBezierTo(s * 0.50, s * 0.72, s * 0.65, s * 0.55);
    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFF5D4037)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.05
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawFlagBd(Canvas canvas, double s) {
    // Bangladesh flag: green background, red disc slightly offset left
    final green = Paint()..color = const Color(0xFF006A4E);
    final red = Paint()..color = const Color(0xFFF42A41);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.12, s * 0.22, s * 0.76, s * 0.56),
      Radius.circular(s * 0.08),
    );
    canvas.drawRRect(rect, green);
    canvas.drawCircle(Offset(s * 0.45, s * 0.50), s * 0.17, red);
  }

  void _drawFlagGb(Canvas canvas, double s) {
    // UK flag
    final blue = Paint()..color = const Color(0xFF012169);
    final white = Paint()..color = Colors.white;
    final red = Paint()..color = const Color(0xFFC8102E);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.12, s * 0.22, s * 0.76, s * 0.56),
      Radius.circular(s * 0.08),
    );
    canvas.save();
    canvas.clipRRect(rect);
    canvas.drawRect(Rect.fromLTWH(0, 0, s, s), blue);
    // Cross white
    canvas.drawRect(Rect.fromLTWH(s * 0.43, 0, s * 0.14, s), white);
    canvas.drawRect(Rect.fromLTWH(0, s * 0.43, s, s * 0.14), white);
    // Cross red
    canvas.drawRect(Rect.fromLTWH(s * 0.46, 0, s * 0.08, s), red);
    canvas.drawRect(Rect.fromLTWH(0, s * 0.46, s, s * 0.08), red);
    canvas.restore();
  }

  void _drawFlagSa(Canvas canvas, double s) {
    // Saudi Arabia flag: green with white Arabic calligraphy shape & sword
    final green = Paint()..color = const Color(0xFF006C35);
    final white = Paint()..color = Colors.white;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.12, s * 0.22, s * 0.76, s * 0.56),
      Radius.circular(s * 0.08),
    );
    canvas.drawRRect(rect, green);
    // Stylized Arabic calligraphy line
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.25, s * 0.40, s * 0.50, s * 0.07),
          Radius.circular(s * 0.02)),
      white,
    );
    // Sword line
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.28, s * 0.56, s * 0.44, s * 0.04),
          Radius.circular(s * 0.01)),
      white,
    );
  }

  void _drawHeart(Canvas canvas, double s) {
    final heartPaint = Paint()..color = color ?? const Color(0xFFFF4B4B);
    final path = Path()
      ..moveTo(s * 0.5, s * 0.75)
      ..cubicTo(s * 0.2, s * 0.55, s * 0.15, s * 0.35, s * 0.32, s * 0.25)
      ..cubicTo(s * 0.42, s * 0.19, s * 0.48, s * 0.28, s * 0.5, s * 0.32)
      ..cubicTo(s * 0.52, s * 0.28, s * 0.58, s * 0.19, s * 0.68, s * 0.25)
      ..cubicTo(s * 0.85, s * 0.35, s * 0.8, s * 0.55, s * 0.5, s * 0.75)
      ..close();
    canvas.drawPath(path, heartPaint);
  }

  void _drawCompass(Canvas canvas, double s) {
    final ring = Paint()
      ..color = color ?? const Color(0xFF1CB0F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.07;
    canvas.drawCircle(Offset(s * 0.5, s * 0.5), s * 0.36, ring);
    // Needle
    final redNeedle = Path()
      ..moveTo(s * 0.5, s * 0.20)
      ..lineTo(s * 0.42, s * 0.50)
      ..lineTo(s * 0.5, s * 0.45)
      ..close();
    canvas.drawPath(redNeedle, Paint()..color = const Color(0xFFFF4B4B));
    final blueNeedle = Path()
      ..moveTo(s * 0.5, s * 0.80)
      ..lineTo(s * 0.58, s * 0.50)
      ..lineTo(s * 0.5, s * 0.55)
      ..close();
    canvas.drawPath(blueNeedle, Paint()..color = const Color(0xFF8B9AAB));
    canvas.drawCircle(Offset(s * 0.5, s * 0.5), s * 0.05,
        Paint()..color = const Color(0xFF263238));
  }

  void _star(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final a = -math.pi / 2 + i * 2 * math.pi / 5;
      final a2 = a + math.pi / 5;
      final p1 = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      final p2 =
          Offset(c.dx + r * 0.4 * math.cos(a2), c.dy + r * 0.4 * math.sin(a2));
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

/// A raised, toy-like icon badge used across cards and headers.
///
/// The highlight and low shadow make the hand-drawn vector icons feel like
/// small physical tokens instead of flat glyphs.
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
    final darker = HSLColor.fromColor(bgColor)
        .withLightness(
          (HSLColor.fromColor(bgColor).lightness - 0.12).clamp(0.0, 1.0),
        )
        .toColor();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
            top: size * .09,
            child: DecoratedBox(
              decoration: BoxDecoration(color: darker, shape: BoxShape.circle),
            ),
          ),
          Positioned.fill(
            bottom: size * .09,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: .30),
                    bgColor,
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: .55),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: darker.withValues(alpha: .18),
                    blurRadius: size * .16,
                    offset: Offset(0, size * .08),
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
            ),
          ),
          Positioned(
            top: size * .16,
            left: size * .22,
            child: Container(
              width: size * .27,
              height: size * .10,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .36),
                borderRadius: BorderRadius.circular(size),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
