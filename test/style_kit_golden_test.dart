import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

// =============================================================================
// DESIGN SYSTEM TOKENS (Duolingo Style: #58CC02, 3D #46A302, Ref 1, 2, 3, 4)
// =============================================================================

class StyleKitColors {
  // Duolingo Brand Green Family (The Core Little Muslim Brand Theme)
  static const Color duoGreen = Color(0xFF58CC02);        // Vibrant Duolingo green
  static const Color duoGreenDark = Color(0xFF46A302);    // 3D bevel / bottom edge
  static const Color duoGreenSoft = Color(0xFFEDFED9);    // Soft pastel green panel
  static const Color duoGreenSoftEdge = Color(0xFFD4F4B8);// Soft 3D edge
  static const Color duoGreenIllus = Color(0xFFC7EFA4);   // Decorative star motif tint
  static const Color duoGreenText = Color(0xFF2D6A00);    // High contrast text on soft (6.8:1)

  // Qaida Module Theme (Duolingo Green Family)
  static const Color qaidaDark = Color(0xFF58CC02);      // Primary Duolingo green button fill
  static const Color qaidaDarkEdge = Color(0xFF46A302);  // 3D bottom bevel
  static const Color qaidaSoft = Color(0xFFEDFED9);      // Header panel & soft tiles
  static const Color qaidaSoftEdge = Color(0xFFD4F4B8);  // Secondary 3D edge
  static const Color qaidaIllus = Color(0xFFC7EFA4);     // Decorative 8-point geometric star
  static const Color qaidaText = Color(0xFF2D6A00);      // High contrast text on soft (6.8:1)

  // Ref-2 Warm Yellow Header Family (Drawing / Dashboard Hero)
  static const Color headerYellow = Color(0xFFFFD233);    // Warm sunny header panel (Ref-2)
  static const Color headerYellowEdge = Color(0xFFE5A100);// 3D bottom bevel for yellow header
  static const Color headerYellowText = Color(0xFF4A3400);// Dark brown text on warm yellow (8.4:1)

  // Quran Module Theme (Warm Gold / Amber)
  static const Color quranDark = Color(0xFFD97706);      // Primary button fill
  static const Color quranDarkEdge = Color(0xFFB45309);  // 3D bottom edge
  static const Color quranSoft = Color(0xFFFEF3C7);      // Header panel & soft tiles
  static const Color quranSoftEdge = Color(0xFFFDE68A);  // Secondary 3D edge
  static const Color quranText = Color(0xFF78350F);      // Text on soft (8.15:1)

  // Surface / Neutral
  static const Color pageBg = Color(0xFFF1F5F9);         // Cool neutral presentation background
  static const Color deviceBg = Color(0xFFF8FAFC);       // Soft phone body background
  static const Color surface = Color(0xFFFFFFFF);        // Flat white card fill
  static const Color surfaceEdge = Color(0xFFCBD5E1);    // Tappable card 3D edge
  static const Color textDark = Color(0xFF0F172A);       // Dark slate heading text
  static const Color textMuted = Color(0xFF475569);      // Secondary body text (CR > 4.5:1)
  static const Color textSubtle = Color(0xFF64748B);     // Micro label text
  static const Color white = Color(0xFFFFFFFF);

  // Path Nodes (Duolingo Green Style!)
  static const Color nodeComplete = Color(0xFF58CC02);   // Duolingo green
  static const Color nodeCompleteEdge = Color(0xFF46A302);// 3D bottom edge
  static const Color nodeCurrent = Color(0xFF58CC02);    // Vibrant Duolingo green
  static const Color nodeCurrentEdge = Color(0xFF46A302); // 3D bottom edge
  static const Color nodeLocked = Color(0xFFE2E8F0);     // Slate soft grey
  static const Color nodeLockedEdge = Color(0xFFCBD5E1); // Slate 3D edge

  // Adventure Map Palette (Ref-3 Island)
  static const Color mapGrass = Color(0xFFE5F8D0);       // Fresh Duolingo meadow green
  static const Color mapGrassAlt = Color(0xFFD7F4BD);    // Meadow contour
  static const Color mapWater = Color(0xFFBAE6FD);       // Sky blue river/ocean
  static const Color mapRiver = Color(0xFF7DD3FC);
  static const Color mapRiverEdge = Color(0xFF38BDF8);
  static const Color mapRoad = Color(0xFFF7F2E7);        // Sand trail
  static const Color mapRoadEdge = Color(0xFFDFCDB2);
  static const Color mapRoadDashes = Color(0xFFD5C3A5);
}

// =============================================================================
// REUSABLE 3D EDGE CONTROLS (Tappable controls only, solid flat fills, no shadow)
// =============================================================================

class EdgeButton extends StatelessWidget {
  const EdgeButton({
    super.key,
    required this.fillColor,
    required this.edgeColor,
    required this.child,
    this.borderRadius = 16.0,
    this.edgeHeight = 3.5,
    this.minHeight = 44.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  final Color fillColor;
  final Color edgeColor;
  final Widget child;
  final double borderRadius;
  final double edgeHeight;
  final double minHeight;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: edgeColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: edgeHeight),
        constraints: BoxConstraints(minHeight: minHeight),
        padding: padding,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class EdgeCard extends StatelessWidget {
  const EdgeCard({
    super.key,
    required this.child,
    this.fillColor = StyleKitColors.surface,
    this.edgeColor = StyleKitColors.surfaceEdge,
    this.borderRadius = 18.0,
    this.edgeHeight = 3.0,
    this.padding = const EdgeInsets.all(14),
    this.margin,
  });

  final Widget child;
  final Color fillColor;
  final Color edgeColor;
  final double borderRadius;
  final double edgeHeight;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: edgeColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: edgeHeight),
        padding: padding,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}

// =============================================================================
// ASSET LOADER (Figma SVGs & 3D PNG assets used AS-IS on flat surfaces)
// =============================================================================

class LocalAssetWidget extends StatelessWidget {
  const LocalAssetWidget({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        if (path.endsWith('.svg')) {
          return SvgPicture.string(
            file.readAsStringSync(),
            width: width,
            height: height,
            fit: fit,
          );
        } else if (path.endsWith('.png')) {
          return Image.memory(
            file.readAsBytesSync(),
            width: width,
            height: height,
            fit: fit,
          );
        }
      }
    } catch (_) {}
    return SizedBox(width: width, height: height);
  }
}

// Backwards-compatible alias
typedef FigmaSvgWidget = LocalAssetWidget;

// =============================================================================
// CLEAN 2D VECTOR MAP ELEMENTS (Ref-3 Wooden Bridge, Signpost, Summit Crescent)
// =============================================================================

class WoodenBridgePainter extends CustomPainter {
  const WoodenBridgePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Bridge deck base
    final deckEdge = Paint()..color = const Color(0xFF78350F)..style = PaintingStyle.fill;
    final deckRect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 4, w, h - 8), const Radius.circular(5));
    canvas.drawRRect(deckRect, deckEdge);

    // Individual wooden planks
    final plankPaint = Paint()..color = const Color(0xFFB45309)..style = PaintingStyle.fill;
    const numPlanks = 6;
    final plankW = (w - 4) / numPlanks;
    for (int i = 0; i < numPlanks; i++) {
      final pRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(2 + i * plankW + 1, 6, plankW - 2, h - 14),
        const Radius.circular(2),
      );
      canvas.drawRRect(pRect, plankPaint);
    }

    // Side guide rails
    final railPaint = Paint()
      ..color = const Color(0xFF592B06)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, 5), Offset(w, 5), railPaint);
    canvas.drawLine(Offset(0, h - 5), Offset(w, h - 5), railPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrailSignpostPainter extends CustomPainter {
  const TrailSignpostPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Wooden post
    final postPaint = Paint()..color = const Color(0xFF78350F)..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(size.width * 0.44, size.height * 0.35, size.width * 0.12, size.height * 0.65), postPaint);

    // Signboard plank with 3D bottom bevel
    final boardEdge = Paint()..color = const Color(0xFFB45309)..style = PaintingStyle.fill;
    final boardPaint = Paint()..color = const Color(0xFFD97706)..style = PaintingStyle.fill;

    final rrectEdge = RRect.fromRectAndRadius(Rect.fromLTWH(0, 3, size.width, size.height * 0.42), const Radius.circular(4));
    final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height * 0.42 - 2), const Radius.circular(4));
    canvas.drawRRect(rrectEdge, boardEdge);
    canvas.drawRRect(rrect, boardPaint);

    // Small trail indicator lines on the board
    final textPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.16), Offset(size.width * 0.8, size.height * 0.16), textPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SummitMonumentPainter extends CustomPainter {
  const SummitMonumentPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()..color = const Color(0xFFF59E0B)..style = PaintingStyle.fill;
    final goldEdge = Paint()..color = const Color(0xFFD97706)..style = PaintingStyle.fill;

    // Base pedestal
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.15, size.height * 0.58, size.width * 0.7, size.height * 0.36), const Radius.circular(5)), goldEdge);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.15, size.height * 0.52, size.width * 0.7, size.height * 0.36), const Radius.circular(5)), goldPaint);

    // Golden Crescent Moon on top
    final crescentPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.30), radius: size.width * 0.26));
    final cutPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width * 0.58, size.height * 0.26), radius: size.width * 0.21));
    final moon = Path.combine(PathOperation.difference, crescentPath, cutPath);
    canvas.drawPath(moon, goldPaint);

    // Mini star next to crescent
    canvas.drawCircle(Offset(size.width * 0.68, size.height * 0.22), 2.5, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// 3D HEXAGON NODE PEDESTAL PAINTER (Direct from Ref-3 Adventure Map)
// =============================================================================

class HexagonPedestalPainter extends CustomPainter {
  const HexagonPedestalPainter({
    required this.fillColor,
    required this.edgeColor,
    this.edgeHeight = 6.0,
  });

  final Color fillColor;
  final Color edgeColor;
  final double edgeHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height - edgeHeight;
    final cx = w / 2;
    final cy = h / 2;
    final r = math.min(w, h) / 2;

    List<Offset> getHexPoints(double centerY) {
      final pts = <Offset>[];
      for (int i = 0; i < 6; i++) {
        final angle = (i * 60 + 30) * math.pi / 180;
        pts.add(Offset(cx + r * math.cos(angle), centerY + r * math.sin(angle)));
      }
      return pts;
    }

    final topPts = getHexPoints(cy);
    final botPts = getHexPoints(cy + edgeHeight);

    // 1. Draw 3D Bottom Extrusion Bevel
    final edgePaint = Paint()
      ..color = edgeColor
      ..style = PaintingStyle.fill;
    final edgePath = Path();
    edgePath.moveTo(topPts[0].dx, topPts[0].dy);
    edgePath.lineTo(topPts[1].dx, topPts[1].dy);
    edgePath.lineTo(topPts[2].dx, topPts[2].dy);
    edgePath.lineTo(topPts[3].dx, topPts[3].dy);
    edgePath.lineTo(botPts[3].dx, botPts[3].dy);
    edgePath.lineTo(botPts[2].dx, botPts[2].dy);
    edgePath.lineTo(botPts[1].dx, botPts[1].dy);
    edgePath.lineTo(botPts[0].dx, botPts[0].dy);
    edgePath.close();
    canvas.drawPath(edgePath, edgePaint);

    // 2. Draw Top Hexagon Face
    final topPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final topPath = Path();
    topPath.moveTo(topPts[0].dx, topPts[0].dy);
    for (int i = 1; i < 6; i++) {
      topPath.lineTo(topPts[i].dx, topPts[i].dy);
    }
    topPath.close();
    canvas.drawPath(topPath, topPaint);

    // 3. Subtle Highlight Stroke on Top Face
    final strokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(topPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// ADVENTURE MAP LANDSCAPE PAINTER (Clean Duolingo Island, Winding Trail & River)
// =============================================================================

class AdventureMapLandscapePainter extends CustomPainter {
  const AdventureMapLandscapePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Base Island Meadow Background
    final bgPaint = Paint()
      ..color = StyleKitColors.mapGrass
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 2. Organic Grass Hill Contours
    final hillPaint = Paint()
      ..color = StyleKitColors.mapGrassAlt
      ..style = PaintingStyle.fill;

    final hillPath1 = Path();
    hillPath1.moveTo(0, 0);
    hillPath1.lineTo(w * 0.45, 0);
    hillPath1.quadraticBezierTo(w * 0.40, h * 0.22, 0, h * 0.28);
    hillPath1.close();
    canvas.drawPath(hillPath1, hillPaint);

    final hillPath2 = Path();
    hillPath2.moveTo(w, h * 0.65);
    hillPath2.quadraticBezierTo(w * 0.60, h * 0.75, w * 0.70, h);
    hillPath2.lineTo(w, h);
    hillPath2.close();
    canvas.drawPath(hillPath2, hillPaint);

    // 3. Sky Blue Ocean Water on Top Right Edge
    final waterPaint = Paint()
      ..color = StyleKitColors.mapWater
      ..style = PaintingStyle.fill;
    final oceanPath = Path();
    oceanPath.moveTo(w * 0.78, 0);
    oceanPath.quadraticBezierTo(w * 0.70, h * 0.12, w, h * 0.22);
    oceanPath.lineTo(w, 0);
    oceanPath.close();
    canvas.drawPath(oceanPath, waterPaint);

    // 4. Winding River Channel crossing the map
    final riverPaint = Paint()
      ..color = StyleKitColors.mapRiver
      ..style = PaintingStyle.stroke
      ..strokeWidth = 34
      ..strokeCap = StrokeCap.round;

    final riverEdgePaint = Paint()
      ..color = StyleKitColors.mapRiverEdge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 38
      ..strokeCap = StrokeCap.round;

    final riverPath = Path();
    riverPath.moveTo(w + 10, h * 0.32);
    riverPath.cubicTo(w * 0.65, h * 0.36, w * 0.45, h * 0.60, -10, h * 0.64);

    canvas.drawPath(riverPath, riverEdgePaint);
    canvas.drawPath(riverPath, riverPaint);

    // 5. Winding Road (Warm Sand Beige with Outlines & Dashed Centerline)
    final roadPath = Path();
    // Connecting Node 1 -> Node 2 -> Bridge Crossing -> Node 3 -> Node 4 -> Node 5
    roadPath.moveTo(85, 420);     // Node 1
    roadPath.cubicTo(60, 365, 80, 335, 120, 320); // Towards Node 2
    roadPath.cubicTo(155, 305, 170, 280, 180, 260); // Over River (Bridge Location)
    roadPath.cubicTo(190, 240, 220, 235, 230, 215); // Towards Node 3
    roadPath.cubicTo(240, 185, 140, 175, 115, 130); // Towards Node 4
    roadPath.cubicTo(95, 90, 190, 75, 235, 45);    // Towards Node 5

    // Outer Road Border
    final roadBorderPaint = Paint()
      ..color = StyleKitColors.mapRoadEdge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 44
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(roadPath, roadBorderPaint);

    // Inner Road Fill
    final roadFillPaint = Paint()
      ..color = StyleKitColors.mapRoad
      ..style = PaintingStyle.stroke
      ..strokeWidth = 38
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(roadPath, roadFillPaint);

    // Dashed Centerline (Ref-3 Style)
    final dashPaint = Paint()
      ..color = StyleKitColors.mapRoadDashes
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final metrics = roadPath.computeMetrics();
    for (final metric in metrics) {
      double distance = 10.0;
      const dashLength = 8.0;
      const dashGap = 7.0;
      while (distance < metric.length - 12) {
        final extractPath = metric.extractPath(distance, distance + dashLength);
        canvas.drawPath(extractPath, dashPaint);
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// CLEAN 2D VECTOR FLORA PAINTER (Real planted trees & rocks, no dirt-cube blocks)
// =============================================================================

class MapFloraPainter extends CustomPainter {
  const MapFloraPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Pine Tree helper (layered green triangles + brown trunk)
    void drawPineTree(double x, double y, double scale) {
      final trunkPaint = Paint()..color = const Color(0xFF78350F)..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(x - 3 * scale, y + 14 * scale, 6 * scale, 8 * scale), trunkPaint);

      final foliagePaint = Paint()..color = const Color(0xFF46A302)..style = PaintingStyle.fill;
      final highlightPaint = Paint()..color = const Color(0xFF58CC02)..style = PaintingStyle.fill;

      // Bottom layer
      final p1 = Path()
        ..moveTo(x - 14 * scale, y + 15 * scale)
        ..lineTo(x + 14 * scale, y + 15 * scale)
        ..lineTo(x, y + 2 * scale)
        ..close();
      canvas.drawPath(p1, foliagePaint);

      // Middle layer
      final p2 = Path()
        ..moveTo(x - 11 * scale, y + 8 * scale)
        ..lineTo(x + 11 * scale, y + 8 * scale)
        ..lineTo(x, y - 4 * scale)
        ..close();
      canvas.drawPath(p2, foliagePaint);

      // Top layer
      final p3 = Path()
        ..moveTo(x - 8 * scale, y + 1 * scale)
        ..lineTo(x + 8 * scale, y + 1 * scale)
        ..lineTo(x, y - 10 * scale)
        ..close();
      canvas.drawPath(p3, highlightPaint);
    }

    // Round Oak Tree helper (cloud-like green circles + trunk)
    void drawOakTree(double x, double y, double scale) {
      final trunkPaint = Paint()..color = const Color(0xFF78350F)..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(x - 3 * scale, y + 10 * scale, 6 * scale, 10 * scale), trunkPaint);

      final leafPaint = Paint()..color = const Color(0xFF58CC02)..style = PaintingStyle.fill;
      final shadowLeafPaint = Paint()..color = const Color(0xFF46A302)..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x - 6 * scale, y + 4 * scale), 9 * scale, shadowLeafPaint);
      canvas.drawCircle(Offset(x + 6 * scale, y + 4 * scale), 9 * scale, shadowLeafPaint);
      canvas.drawCircle(Offset(x, y - 4 * scale), 10 * scale, leafPaint);
      canvas.drawCircle(Offset(x - 4 * scale, y), 8 * scale, leafPaint);
      canvas.drawCircle(Offset(x + 4 * scale, y), 8 * scale, leafPaint);
    }

    // River Pebble/Rock helper (smooth rounded pebbles)
    void drawRock(double x, double y, double r) {
      final rockPaint = Paint()..color = const Color(0xFF94A3B8)..style = PaintingStyle.fill;
      final rockEdge = Paint()..color = const Color(0xFF64748B)..style = PaintingStyle.fill;
      canvas.drawOval(Rect.fromCenter(center: Offset(x, y + 2), width: r * 2.2, height: r * 1.5), rockEdge);
      canvas.drawOval(Rect.fromCenter(center: Offset(x, y), width: r * 2.2, height: r * 1.4), rockPaint);
    }

    // Draw flora around the trail
    drawPineTree(42, 120, 1.1);
    drawPineTree(275, 130, 1.0);
    drawPineTree(38, 290, 0.9);
    drawOakTree(280, 310, 1.1);
    drawOakTree(25, 360, 1.0);
    drawOakTree(295, 70, 0.9);

    // River pebbles
    drawRock(135, 415, 6);
    drawRock(150, 420, 8);
    drawRock(260, 275, 7);
    drawRock(275, 270, 5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// ISLAMIC STAR PATTERN PAINTER (Header Vector Motif, Flat, ExcludeSemantics)
// =============================================================================

class IslamicStarPatternPainter extends CustomPainter {
  const IslamicStarPatternPainter({required this.tintColor});
  final Color tintColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = tintColor
      ..style = PaintingStyle.fill;

    void draw8PointStar(double cx, double cy, double r) {
      final path = Path();
      const numPoints = 8;
      final innerR = r * 0.45;
      for (int i = 0; i < numPoints * 2; i++) {
        final radius = i.isEven ? r : innerR;
        final angle = (i * math.pi) / numPoints - math.pi / 2;
        final x = cx + radius * math.cos(angle);
        final y = cy + radius * math.sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }

    draw8PointStar(size.width - 32, size.height * 0.45, 30);
    draw8PointStar(size.width - 80, size.height * 0.72, 16);
    draw8PointStar(size.width - 20, size.height * 0.85, 12);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// SCREEN 1: QAIDA ADVENTURE MAP JOURNEY SCREEN (Full 360x800 Ref-3 Translation)
// =============================================================================

class AdventureMapScreenView extends StatelessWidget {
  const AdventureMapScreenView({super.key, required this.isHindi});
  final bool isHindi;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 800,
      decoration: BoxDecoration(
        color: StyleKitColors.deviceBg,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Device Top Status Bar ──
          _buildPhoneStatusBar(),

          // ── Floating Top Status Capsules Bar (Ref-3) ──
          _buildFloatingStatusBar(isHindi: isHindi),

          // ── Module Header Panel with Islamic Motif (Duolingo Soft Green) ──
          _buildModuleHeaderPanel(isHindi: isHindi),

          // ── Interactive Adventure Map Viewport ──
          Expanded(
            child: Stack(
              children: [
                // 1. Map Canvas (Island, River, Winding Road)
                const Positioned.fill(
                  child: CustomPaint(
                    painter: AdventureMapLandscapePainter(),
                  ),
                ),

                // 2. Clean 2D Planted Flora (Trees, River Pebbles)
                const Positioned.fill(
                  child: CustomPaint(
                    painter: MapFloraPainter(),
                  ),
                ),

                // 3. Wooden Bridge Spanning Over the River Crossing
                Positioned(
                  left: 146,
                  top: 236,
                  child: Transform.rotate(
                    angle: -0.32,
                    child: const LocalAssetWidget(
                      path: 'assets/figma/illustrations/map/map_bridge.svg',
                      width: 66,
                      height: 56,
                    ),
                  ),
                ),

                // Signboard at Trailhead (Node 1)
                const Positioned(
                  left: 18,
                  top: 405,
                  child: LocalAssetWidget(
                    path: 'assets/figma/illustrations/map/map_signboard.svg',
                    width: 38,
                    height: 38,
                  ),
                ),

                // Garden Pavilion at Summit Destination (Node 5)
                const Positioned(
                  right: 18,
                  top: 20,
                  child: LocalAssetWidget(
                    path: 'assets/figma/illustrations/map/garden_pavilion.svg',
                    width: 54,
                    height: 54,
                  ),
                ),

                // Highland Pine Tree
                const Positioned(
                  left: 68,
                  top: 175,
                  child: LocalAssetWidget(
                    path: 'assets/figma/illustrations/map/garden_tree_pine.svg',
                    width: 46,
                    height: 46,
                  ),
                ),

                // Riverbank Oak Tree
                const Positioned(
                  right: 34,
                  top: 275,
                  child: LocalAssetWidget(
                    path: 'assets/figma/illustrations/map/garden_tree_oak.svg',
                    width: 44,
                    height: 44,
                  ),
                ),

                // River Rocks
                const Positioned(
                  left: 14,
                  top: 348,
                  child: LocalAssetWidget(
                    path: 'assets/figma/illustrations/map/map_rocks.svg',
                    width: 44,
                    height: 44,
                  ),
                ),

                // 4. The 5 Path Nodes (Large 3D Hexagon Pedestals + Stars / "Go!" + Labels)
                // Node 1: Completed / Mastered (Trailhead)
                Positioned(
                  left: 58,
                  top: 395,
                  child: _buildMapNode(
                    nodeNumber: isHindi ? '१' : '1',
                    label: isHindi ? '१: वर्णमाला' : '1: Alphabet',
                    state: _NodeState.complete,
                    starCount: 3,
                  ),
                ),

                // Node 2: Completed (River Approach)
                Positioned(
                  left: 92,
                  top: 295,
                  child: _buildMapNode(
                    nodeNumber: isHindi ? '२' : '2',
                    label: isHindi ? '२: स्वर' : '2: Vowels',
                    state: _NodeState.complete,
                    starCount: 2,
                  ),
                ),

                // Node 3: Current Active (User's Next Level!)
                Positioned(
                  left: 202,
                  top: 190,
                  child: _buildMapNode(
                    nodeNumber: isHindi ? '३' : '3',
                    label: isHindi ? '३: हरकत' : '3: Harakat',
                    state: _NodeState.current,
                    isHindi: isHindi,
                  ),
                ),

                // Node 4: Locked (Highland Trail)
                Positioned(
                  left: 88,
                  top: 105,
                  child: _buildMapNode(
                    nodeNumber: isHindi ? '४' : '4',
                    label: isHindi ? '४: तनवीन' : '4: Tanween',
                    state: _NodeState.locked,
                  ),
                ),

                // Node 5: Locked (Summit Milestone)
                Positioned(
                  left: 208,
                  top: 20,
                  child: _buildMapNode(
                    nodeNumber: isHindi ? '५' : '5',
                    label: isHindi ? '५: सुकून' : '5: Sukoon',
                    state: _NodeState.locked,
                  ),
                ),

                // 5. Floating Level Milestone Bottom Card (Ref-3)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 72,
                  child: _buildMilestoneBottomCard(isHindi: isHindi),
                ),

                // 6. Floating Bottom Navigation Dock (Ref-3)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 10,
                  child: _buildFloatingBottomDock(activeTab: 1, isHindi: isHindi),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleHeaderPanel({required bool isHindi}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: StyleKitColors.qaidaSoftEdge,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: StyleKitColors.qaidaSoft,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: ExcludeSemantics(
                child: CustomPaint(
                  painter: IslamicStarPatternPainter(
                    tintColor: StyleKitColors.qaidaIllus,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isHindi ? 'नूरानी क़ायदा' : 'Noorani Qaida',
                          style: const TextStyle(
                            fontFamily: 'Baloo2',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: StyleKitColors.qaidaText,
                          ),
                        ),
                        Text(
                          isHindi ? 'चरण ३: हरकत और अलफ़' : 'Step 3: Harakat & Vowels',
                          style: const TextStyle(
                            fontFamily: 'Baloo2',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: StyleKitColors.duoGreenDark,
                          ),
                        ),
                      ],
                    ),
                    // Segmented View Switch (Map / List)
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: StyleKitColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: StyleKitColors.qaidaSoftEdge, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: StyleKitColors.qaidaDark,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              isHindi ? 'नक्शा' : 'Map',
                              style: const TextStyle(
                                fontFamily: 'Baloo2',
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: StyleKitColors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            child: Text(
                              isHindi ? 'सूची' : 'List',
                              style: const TextStyle(
                                fontFamily: 'Baloo2',
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: StyleKitColors.qaidaText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Flat Duolingo Progress Bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          height: 8,
                          color: StyleKitColors.white,
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.60,
                            child: Container(color: StyleKitColors.qaidaDark),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isHindi ? '३/५ पूर्ण' : '3/5 Done',
                      style: const TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: StyleKitColors.qaidaText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapNode({
    required String nodeNumber,
    required String label,
    required _NodeState state,
    int starCount = 0,
    bool isHindi = false,
    Widget? customIcon,
  }) {
    Color fillColor;
    Color edgeColor;
    Widget iconWidget;

    switch (state) {
      case _NodeState.complete:
        fillColor = StyleKitColors.nodeComplete;
        edgeColor = StyleKitColors.nodeCompleteEdge;
        iconWidget = customIcon ?? const Icon(Icons.check_rounded, color: Colors.white, size: 26);
        break;
      case _NodeState.current:
        fillColor = StyleKitColors.nodeCurrent;
        edgeColor = StyleKitColors.nodeCurrentEdge;
        iconWidget = customIcon ?? const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30);
        break;
      case _NodeState.locked:
        fillColor = StyleKitColors.nodeLocked;
        edgeColor = StyleKitColors.nodeLockedEdge;
        iconWidget = customIcon ?? const Icon(Icons.lock_rounded, color: Color(0xFF64748B), size: 22);
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Above Node: Floating "Go!" Badge (for current) OR Stars (for completed)
        if (state == _NodeState.current) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: StyleKitColors.textDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isHindi ? 'Go! शुरू' : 'Go!',
              style: const TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          // Downward pointer triangle
          const CustomPaint(
            size: Size(10, 5),
            painter: _DownwardTrianglePainter(color: StyleKitColors.textDark),
          ),
          const SizedBox(height: 2),
        ] else if (state == _NodeState.complete) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              starCount,
              (i) => const Icon(Icons.star_rounded, color: Color(0xFFFFB600), size: 15),
            ),
          ),
          const SizedBox(height: 2),
        ] else ...[
          const SizedBox(height: 18),
        ],

        // 2. Large Tactile 3D Hexagon Pedestal (56x52)
        CustomPaint(
          size: const Size(56, 52),
          painter: HexagonPedestalPainter(
            fillColor: fillColor,
            edgeColor: edgeColor,
            edgeHeight: 5,
          ),
          child: SizedBox(
            width: 56,
            height: 47,
            child: Center(child: iconWidget),
          ),
        ),

        const SizedBox(height: 4),

        // 3. Node Label Pill with 3D bottom edge
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFCBD5E1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: StyleKitColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: state == _NodeState.locked ? StyleKitColors.textSubtle : StyleKitColors.textDark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneBottomCard({required bool isHindi}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: StyleKitColors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const LocalAssetWidget(
              path: 'assets/figma/badges/badge_shield_gold.svg',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isHindi ? 'शुरुआती स्तर १' : 'Beginner Level 1',
                    style: const TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: StyleKitColors.textDark,
                    ),
                  ),
                  Text(
                    isHindi ? 'बुनियादी अरबी अक्षर व मखरज' : 'Master letters & phonetics',
                    style: const TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: StyleKitColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            EdgeButton(
              fillColor: StyleKitColors.duoGreen,
              edgeColor: StyleKitColors.duoGreenDark,
              borderRadius: 14,
              edgeHeight: 2.5,
              minHeight: 34,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Text(
                isHindi ? 'जारी रखें' : 'Continue',
                style: const TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: StyleKitColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _NodeState { complete, current, locked }

class _DownwardTrianglePainter extends CustomPainter {
  const _DownwardTrianglePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// SCREEN 2: DAILY LEARNING DASHBOARD (Ref-2 Warm Yellow Header + Duolingo Green)
// =============================================================================

class LearningDashboardScreenView extends StatelessWidget {
  const LearningDashboardScreenView({super.key, required this.isHindi});
  final bool isHindi;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 800,
      decoration: BoxDecoration(
        color: StyleKitColors.deviceBg,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Device Top Status Bar ──
          _buildPhoneStatusBar(),

          // ── Floating Top Status Capsules Bar (Ref-2 / Ref-3) ──
          _buildFloatingStatusBar(isHindi: isHindi),

          // ── Scrollable Dashboard Content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Gentle Mint Green Islamic Header Panel
                  _buildMintGreenHeader(isHindi: isHindi),
                  const SizedBox(height: 10),

                  // 2. Ref-2 Prominent Level Card with Thick Duolingo Green Progress Bar
                  _buildRef2LevelCard(isHindi: isHindi),
                  const SizedBox(height: 14),

                  // 3. Category Squircle Icon Tiles (Clean Figma Icons)
                  Text(
                    isHindi ? 'शिक्षा श्रेणियां' : 'Learning Tracks',
                    style: const TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: StyleKitColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCategoryTile(
                          iconPath: 'assets/figma/icons/islamic/ic_book.svg',
                          title: isHindi ? 'क़ायदा' : 'Qaida',
                          bg: StyleKitColors.qaidaSoft,
                          edge: StyleKitColors.qaidaSoftEdge,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCategoryTile(
                          iconPath: 'assets/figma/icons/islamic/ic_mosque.svg',
                          title: isHindi ? 'क़ुरआन' : 'Quran',
                          bg: StyleKitColors.quranSoft,
                          edge: StyleKitColors.quranSoftEdge,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCategoryTile(
                          iconPath: 'assets/figma/icons/islamic/ic_lantern.svg',
                          title: isHindi ? 'दुआएं' : 'Duas',
                          bg: const Color(0xFFE0F2FE),
                          edge: const Color(0xFFBAE6FD),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCategoryTile(
                          iconPath: 'assets/figma/icons/game/ic_trophy.svg',
                          title: isHindi ? 'प्रगति' : 'Progress',
                          bg: const Color(0xFFF3E8FF),
                          edge: const Color(0xFFDDD6FE),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 4. Daily Challenges / Lesson Rows (Ref-2 + Ref-4)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isHindi ? 'आज के दैनिक सबक' : "Today's Lessons",
                        style: const TextStyle(
                          fontFamily: 'Baloo2',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: StyleKitColors.textDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: StyleKitColors.qaidaSoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isHindi ? '३ शेष' : '3 Pending',
                          style: const TextStyle(
                            fontFamily: 'Baloo2',
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: StyleKitColors.duoGreenDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Challenge 1: Arabic Harakat
                  _buildLessonRow(
                    leadingWidget: _buildSquircleBadge('بَ', StyleKitColors.qaidaSoft, StyleKitColors.duoGreenDark),
                    title: isHindi ? 'सबक ३: हरकत (ज़बर)' : 'Lesson 3: Harakat (Fatha)',
                    subtitle: isHindi ? 'लघु स्वर व उच्चारण' : 'Short vowels & pronunciation',
                    rewardText: isHindi ? '+१० अंक' : '+10 XP',
                    actionText: isHindi ? 'शुरू' : 'Start',
                    actionColor: StyleKitColors.duoGreen,
                    actionEdge: StyleKitColors.duoGreenDark,
                  ),
                  const SizedBox(height: 8),

                  // Challenge 2: Vocal Practice
                  _buildLessonRow(
                    leadingWidget: const FigmaSvgWidget(
                      path: 'assets/figma/icons/game/ic_sound.svg',
                      width: 22,
                      height: 22,
                    ),
                    title: isHindi ? 'मखरज कंठ अभ्यास' : 'Makharij Throat Drill',
                    subtitle: isHindi ? 'हलक़ के अक्षर: हा, ख़ा' : 'Throat letters: Ha & Kha',
                    rewardText: isHindi ? '+१५ अंक' : '+15 XP',
                    actionText: isHindi ? 'अभ्यास' : 'Drill',
                    actionColor: StyleKitColors.duoGreen,
                    actionEdge: StyleKitColors.duoGreenDark,
                  ),
                  const SizedBox(height: 8),

                  // Challenge 3: Surah Al-Fatiha
                  _buildLessonRow(
                    leadingWidget: const FigmaSvgWidget(
                      path: 'assets/figma/icons/islamic/ic_star.svg',
                      width: 22,
                      height: 22,
                    ),
                    title: isHindi ? 'सूरह अल-फ़ातिहा (१-३)' : 'Surah Al-Fatihah (1-3)',
                    subtitle: isHindi ? 'तजवीद के साथ तिलावत' : 'Tajweed recitation with audio',
                    rewardText: isHindi ? '+२० अंक' : '+20 XP',
                    actionText: isHindi ? 'सुनें' : 'Listen',
                    actionColor: StyleKitColors.quranDark,
                    actionEdge: StyleKitColors.quranDarkEdge,
                  ),
                  const SizedBox(height: 14),

                  // 5. Big Vibrant Duolingo Green Action Button
                  EdgeButton(
                    fillColor: StyleKitColors.duoGreen,
                    edgeColor: StyleKitColors.duoGreenDark,
                    borderRadius: 24,
                    edgeHeight: 4,
                    minHeight: 50,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    child: Text(
                      isHindi ? 'आज का सबक शुरू करें' : "Start Today's Lesson",
                      style: const TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: StyleKitColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Floating Bottom Navigation Dock (Home Active) ──
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: _buildFloatingBottomDock(activeTab: 0, isHindi: isHindi),
          ),
        ],
      ),
    );
  }

  Widget _buildMintGreenHeader({required bool isHindi}) {
    return Container(
      decoration: BoxDecoration(
        color: StyleKitColors.qaidaSoftEdge,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: StyleKitColors.qaidaSoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // 3D Little Muslim Mascot Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: StyleKitColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: StyleKitColors.duoGreen, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: const LocalAssetWidget(
                path: 'assets/images/mascot_happy.png',
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi ? 'अस्सलाम अलैकुम, हमज़ा' : 'Assalamu Alaikum, Hamza',
                    style: const TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: StyleKitColors.qaidaText,
                    ),
                  ),
                  Text(
                    isHindi ? 'आज का सबक़ पूरा करने के लिए तैयार?' : 'Ready to master your Qaida lesson?',
                    style: const TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: StyleKitColors.duoGreenDark,
                    ),
                  ),
                ],
              ),
            ),
            // Notification Bell
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: StyleKitColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: StyleKitColors.qaidaSoftEdge, width: 1.5),
              ),
              child: const Icon(Icons.notifications_rounded, color: StyleKitColors.qaidaText, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRef2LevelCard({required bool isHindi}) {
    return EdgeCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isHindi ? 'दैनिक अध्ययन लक्ष्य' : 'Daily Study Goal',
                style: const TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: StyleKitColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFDE68A), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: Color(0xFFD97706), size: 14),
                    const SizedBox(width: 3),
                    Text(
                      isHindi ? '५ दिन स्ट्रीक' : '5 Days Streak',
                      style: const TextStyle(
                        fontFamily: 'Baloo2',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Thick, Rounded Duolingo Green Progress Bar (Height 14px, Ref-2)
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 14,
                    color: const Color(0xFFE2E8F0),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.75,
                      child: Container(color: StyleKitColors.duoGreen),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: StyleKitColors.duoGreenDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isHindi ? 'स्तर १' : 'Lv 1',
                  style: const TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: StyleKitColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isHindi ? '१५/२० मिनट पूर्ण (७५%)' : '15 of 20 mins completed today (75%)',
            style: const TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: StyleKitColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile({
    required String iconPath,
    required String title,
    required Color bg,
    required Color edge,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: edge,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2.5),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FigmaSvgWidget(path: iconPath, width: 28, height: 28),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: StyleKitColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquircleBadge(String text, Color bg, Color textColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildLessonRow({
    required Widget leadingWidget,
    required String title,
    required String subtitle,
    required String rewardText,
    required String actionText,
    required Color actionColor,
    required Color actionEdge,
  }) {
    return EdgeCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: leadingWidget,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: StyleKitColors.textDark,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: StyleKitColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              rewardText,
              style: const TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF92400E),
              ),
            ),
          ),
          EdgeButton(
            fillColor: actionColor,
            edgeColor: actionEdge,
            borderRadius: 12,
            edgeHeight: 2.5,
            minHeight: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Text(
              actionText,
              style: const TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: StyleKitColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SHARED SHELL WIDGETS (Phone Status Bar, Floating Capsules, Floating Nav Dock)
// =============================================================================

Widget _buildPhoneStatusBar() {
  return Container(
    padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '9:41',
          style: TextStyle(
            fontFamily: 'Baloo2',
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: StyleKitColors.textDark,
          ),
        ),
        Row(
          children: [
            Icon(Icons.signal_cellular_alt_rounded, size: 14, color: StyleKitColors.textDark),
            SizedBox(width: 4),
            Icon(Icons.wifi_rounded, size: 14, color: StyleKitColors.textDark),
            SizedBox(width: 4),
            Icon(Icons.battery_full_rounded, size: 16, color: StyleKitColors.textDark),
          ],
        ),
      ],
    ),
  );
}

Widget _buildFloatingStatusBar({required bool isHindi}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFCBD5E1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: StyleKitColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.monetization_on_rounded, color: Color(0xFFEAB308), size: 15),
              const SizedBox(width: 4),
              Text(
                isHindi ? '४५०' : '450',
                style: const TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: StyleKitColors.textDark,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.diamond_rounded, color: Color(0xFF0284C7), size: 15),
              const SizedBox(width: 4),
              Text(
                isHindi ? '८४' : '84',
                style: const TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: StyleKitColors.textDark,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.local_fire_department_rounded, color: Color(0xFFEA580C), size: 15),
              const SizedBox(width: 4),
              Text(
                isHindi ? '५ दिन' : '5 Days',
                style: const TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: StyleKitColors.textDark,
                ),
              ),
            ],
          ),
          // Mini 3D Mascot Avatar circle
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: StyleKitColors.qaidaSoft,
              shape: BoxShape.circle,
              border: Border.all(color: StyleKitColors.duoGreen, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: const LocalAssetWidget(
              path: 'assets/images/mascot_happy.png',
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildFloatingBottomDock({required int activeTab, required bool isHindi}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFCBD5E1),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Container(
      margin: const EdgeInsets.only(bottom: 2.5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: StyleKitColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDockItem(icon: Icons.mosque_rounded, label: isHindi ? 'होम' : 'Home', isActive: activeTab == 0),
          _buildDockItem(icon: Icons.menu_book_rounded, label: isHindi ? 'क़ायदा' : 'Qaida', isActive: activeTab == 1),
          _buildDockItem(icon: Icons.auto_stories_rounded, label: isHindi ? 'क़ुरआन' : 'Quran', isActive: activeTab == 2),
          _buildDockItem(icon: Icons.person_rounded, label: isHindi ? 'प्रोफ़ाइल' : 'Profile', isActive: activeTab == 3),
        ],
      ),
    ),
  );
}

Widget _buildDockItem({required IconData icon, required String label, required bool isActive}) {
  if (isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: StyleKitColors.qaidaSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: StyleKitColors.qaidaSoftEdge, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: StyleKitColors.qaidaText, size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: StyleKitColors.qaidaText,
            ),
          ),
        ],
      ),
    );
  }
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Icon(icon, color: StyleKitColors.textSubtle, size: 19),
  );
}

// =============================================================================
// MASTER DUAL-SCREEN SHOWCASE (Side-by-Side 1:1 Scale Presentation: 740 x 820)
// =============================================================================

class MasterSideBySideShowcase extends StatelessWidget {
  const MasterSideBySideShowcase({super.key, required this.isHindi});
  final bool isHindi;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StyleKitColors.pageBg,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left Screen: Qaida Adventure Map (Ref 3)
          AdventureMapScreenView(isHindi: isHindi),
          const SizedBox(width: 14),
          // Right Screen: Daily Learning Dashboard (Ref 2, 1, 4)
          LearningDashboardScreenView(isHindi: isHindi),
        ],
      ),
    );
  }
}

// =============================================================================
// FLUTTER TEST RUNNER & GOLDEN SCREENSHOT GENERATOR
// =============================================================================

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Directory('docs/screenshots').createSync(recursive: true);

    final iconFile = File('/Users/mdmansur/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
    if (iconFile.existsSync()) {
      final iconLoader = FontLoader('MaterialIcons');
      iconLoader.addFont(Future.value(ByteData.view(iconFile.readAsBytesSync().buffer)));
      await iconLoader.load();
    }

    final baloo2File = File('assets/fonts/Baloo2-Variable.ttf');
    if (baloo2File.existsSync()) {
      final balooBytes = baloo2File.readAsBytesSync().buffer;
      final balooLoader = FontLoader('Baloo2');
      balooLoader.addFont(Future.value(ByteData.view(balooBytes)));
      await balooLoader.load();
    }
  });

  // 1. Single Screen: Qaida Adventure Map Screen (360x800)
  testWidgets('Generate Qaida Adventure Map Golden (360x800)', (tester) async {
    final boundaryKey = GlobalKey();
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Baloo2'),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 800),
            textScaler: TextScaler.linear(1.0),
          ),
          child: Material(
            child: RepaintBoundary(
              key: boundaryKey,
              child: const SizedBox(
                width: 360,
                height: 800,
                child: AdventureMapScreenView(isHindi: false),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();

    await tester.runAsync(() async {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 1.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final pngBytes = byteData.buffer.asUint8List();
          File('docs/screenshots/qaida_map_360.png').writeAsBytesSync(pngBytes);
          print('✅ Generated docs/screenshots/qaida_map_360.png (${pngBytes.length} bytes)');
        }
      }
    });
  });

  // 2. Single Screen: Daily Learning Dashboard Screen (360x800)
  testWidgets('Generate Daily Learning Dashboard Golden (360x800)', (tester) async {
    final boundaryKey = GlobalKey();
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Baloo2'),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 800),
            textScaler: TextScaler.linear(1.0),
          ),
          child: Material(
            child: RepaintBoundary(
              key: boundaryKey,
              child: const SizedBox(
                width: 360,
                height: 800,
                child: LearningDashboardScreenView(isHindi: false),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();

    await tester.runAsync(() async {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 1.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final pngBytes = byteData.buffer.asUint8List();
          File('docs/screenshots/dashboard_360.png').writeAsBytesSync(pngBytes);
          print('✅ Generated docs/screenshots/dashboard_360.png (${pngBytes.length} bytes)');
        }
      }
    });
  });

  // 3. Master Side-by-Side English Showcase (760x820: Full 1:1 scale for both screens!)
  testWidgets('Generate Style Kit Golden English (Side-by-Side 760x820)', (tester) async {
    final boundaryKey = GlobalKey();
    tester.view.physicalSize = const Size(760, 820);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Baloo2'),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(760, 820),
            textScaler: TextScaler.linear(1.0),
          ),
          child: Material(
            child: RepaintBoundary(
              key: boundaryKey,
              child: const SizedBox(
                width: 760,
                height: 820,
                child: MasterSideBySideShowcase(isHindi: false),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();

    await tester.runAsync(() async {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 1.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final pngBytes = byteData.buffer.asUint8List();
          File('docs/screenshots/style_kit_360_en.png').writeAsBytesSync(pngBytes);
          File('docs/screenshots/style_kit_360.png').writeAsBytesSync(pngBytes);
          print('✅ Generated master docs/screenshots/style_kit_360.png (${pngBytes.length} bytes)');
        }
      }
    });
  });

  // 4. Master Side-by-Side Hindi Showcase (760x820)
  testWidgets('Generate Style Kit Golden Hindi (Side-by-Side 760x820)', (tester) async {
    final boundaryKey = GlobalKey();
    tester.view.physicalSize = const Size(760, 820);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Baloo2'),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(760, 820),
            textScaler: TextScaler.linear(1.0),
          ),
          child: Material(
            child: RepaintBoundary(
              key: boundaryKey,
              child: const SizedBox(
                width: 760,
                height: 820,
                child: MasterSideBySideShowcase(isHindi: true),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();

    await tester.runAsync(() async {
      final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 1.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final pngBytes = byteData.buffer.asUint8List();
          File('docs/screenshots/style_kit_360_hi.png').writeAsBytesSync(pngBytes);
          print('✅ Generated docs/screenshots/style_kit_360_hi.png (${pngBytes.length} bytes)');
        }
      }
    });
  });
}
