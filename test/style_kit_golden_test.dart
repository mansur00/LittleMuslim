import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

// =============================================================================
// PHASE B STYLE SPEC TOKENS (Aligned with References 1, 2, 3, 4 + User Overrides)
// =============================================================================

class StyleKitColors {
  // App Shell Theme (Gentle Mint / Light Green Family)
  static const Color appDark = Color(0xFF047857);        // Primary button fill (CR 5.48:1 on white)
  static const Color appDarkEdge = Color(0xFF064E3B);    // 3D bottom edge
  static const Color appSoft = Color(0xFFECFDF5);        // Header panel & soft mint tiles
  static const Color appSoftEdge = Color(0xFFD1FAE5);    // Secondary 3D edge
  static const Color appIllus = Color(0xFFA7F3D0);       // Decorative mint lanterns & crescent
  static const Color appText = Color(0xFF064E3B);        // High contrast text on soft (9.23:1)

  // Qaida Module Theme (Strong Forest Green Family)
  static const Color qaidaDark = Color(0xFF1E6B24);      // Primary button fill (CR 6.60:1 on white)
  static const Color qaidaDarkEdge = Color(0xFF124317);  // 3D bottom edge
  static const Color qaidaSoft = Color(0xFFE8F5E9);      // Header panel & soft tiles
  static const Color qaidaSoftEdge = Color(0xFFC8E6C9);  // Secondary 3D edge
  static const Color qaidaIllus = Color(0xFFC8E6C9);     // Decorative 8-point geometric star
  static const Color qaidaText = Color(0xFF124317);      // High contrast text on soft (10.14:1)

  // Quran Module Theme (Gold / Ochre)
  static const Color quranDark = Color(0xFF92400E);      // Primary button fill (CR 7.09:1 on white)
  static const Color quranDarkEdge = Color(0xFF78350F);  // 3D bottom edge
  static const Color quranSoft = Color(0xFFFEF3C7);      // Header panel & soft tiles
  static const Color quranSoftEdge = Color(0xFFFDE68A);  // Secondary 3D edge
  static const Color quranIllus = Color(0xFFFDE68A);     // Decorative mosque arch & dome
  static const Color quranText = Color(0xFF78350F);      // Text on soft (8.15:1)

  // Neutral / Surface
  static const Color pageBg = Color(0xFFF4FAF4);         // Gentle soft tinted page bg
  static const Color surface = Color(0xFFFFFFFF);        // Flat white card fill
  static const Color surfaceEdge = Color(0xFFCBD5E1);    // Tappable card 3D edge
  static const Color textDark = Color(0xFF0F172A);       // Dark slate heading text
  static const Color textMuted = Color(0xFF475569);      // Secondary body text (CR > 4.5:1)
  static const Color inputBorder = Color(0xFF64748B);    // 1.5px border (CR 3.9:1 against white)
  static const Color white = Color(0xFFFFFFFF);

  // Path Nodes (Ref-3 Adventure Map style in module's own green family)
  static const Color nodeComplete = Color(0xFF1E6B24);
  static const Color nodeCompleteEdge = Color(0xFF124317);
  static const Color nodeDone = Color(0xFF2E7D32);
  static const Color nodeDoneEdge = Color(0xFF1B5E20);
  static const Color nodeCurrent = Color(0xFF2E7D32);    // Module's own green family (NOT amber)
  static const Color nodeCurrentEdge = Color(0xFF1E6B24);
  static const Color nodeLocked = Color(0xFF94A3B8);
  static const Color nodeLockedEdge = Color(0xFF64748B);

  // Adventure Map Land & Water
  static const Color mapLand = Color(0xFFDCFCE7);
  static const Color mapLandDark = Color(0xFFBBF7D0);
  static const Color mapWater = Color(0xFFBAE6FD);
  static const Color mapRoad = Color(0xFFF1F5F9);
  static const Color mapRoadEdge = Color(0xFFCBD5E1);
  static const Color mapRoadDashes = Color(0xFF94A3B8);
}

// -----------------------------------------------------------------------------
// Vector Decorative Islamic Illustrations (ExcludeSemantics, Flat, Contrast-safe)
// -----------------------------------------------------------------------------

/// 8-Point Islamic Star Pattern for Qaida Header
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

    draw8PointStar(size.width - 38, size.height * 0.45, 36);
    draw8PointStar(size.width - 95, size.height * 0.72, 20);
    draw8PointStar(size.width - 25, size.height * 0.82, 14);
    draw8PointStar(size.width - 120, size.height * 0.30, 14);

    final crescentPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width - 70, 24), radius: 16));
    final cutout = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width - 64, 21), radius: 14));
    final diff = Path.combine(PathOperation.difference, crescentPath, cutout);
    canvas.drawPath(diff, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Mosque Silhouette with Dome and Minaret for Quran Header
class MosqueSilhouettePainter extends CustomPainter {
  const MosqueSilhouettePainter({required this.tintColor});
  final Color tintColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = tintColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final baseH = size.height;
    final right = size.width - 15;

    // Minaret (far right)
    path.moveTo(right - 18, baseH);
    path.lineTo(right - 18, baseH - 60);
    path.lineTo(right - 9, baseH - 80);
    path.lineTo(right, baseH - 60);
    path.lineTo(right, baseH);

    // Central Mosque Dome
    final domeCenterX = right - 60;
    final domeCenterY = baseH - 10;
    const domeR = 36.0;
    path.moveTo(domeCenterX - domeR, baseH);
    path.arcTo(
      Rect.fromCircle(center: Offset(domeCenterX, domeCenterY), radius: domeR),
      math.pi,
      math.pi,
      false,
    );
    path.lineTo(domeCenterX, domeCenterY - domeR - 8);
    path.lineTo(domeCenterX + 2, domeCenterY - domeR);
    path.lineTo(domeCenterX + domeR, baseH);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Crescent and Hanging Lantern Silhouette for App Shell Header
class LanternCrescentPainter extends CustomPainter {
  const LanternCrescentPainter({required this.tintColor});
  final Color tintColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = tintColor
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = tintColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const x1 = 295.0;
    canvas.drawLine(const Offset(x1, 0), const Offset(x1, 30), linePaint);
    final lantern1 = Path()
      ..moveTo(x1 - 7, 30)
      ..lineTo(x1 + 7, 30)
      ..lineTo(x1 + 10, 44)
      ..lineTo(x1, 58)
      ..lineTo(x1 - 10, 44)
      ..close();
    canvas.drawPath(lantern1, paint);

    const x2 = 325.0;
    canvas.drawLine(const Offset(x2, 0), const Offset(x2, 18), linePaint);
    final lantern2 = Path()
      ..moveTo(x2 - 5, 18)
      ..lineTo(x2 + 5, 18)
      ..lineTo(x2 + 8, 30)
      ..lineTo(x2, 40)
      ..lineTo(x2 - 8, 30)
      ..close();
    canvas.drawPath(lantern2, paint);

    final crescent = Path()
      ..addOval(const Rect.fromLTWH(245, 15, 30, 30));
    final cut = Path()
      ..addOval(const Rect.fromLTWH(252, 13, 27, 27));
    final moon = Path.combine(PathOperation.difference, crescent, cut);
    canvas.drawPath(moon, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// 3D Bottom Edge Tappable Control (No shadows, flat edge, press translation)
// -----------------------------------------------------------------------------

class EdgeButton extends StatefulWidget {
  const EdgeButton({
    super.key,
    required this.child,
    required this.fillColor,
    required this.edgeColor,
    this.edgeHeight = 4.0,
    this.borderRadius = 16.0,
    this.onTap,
    this.minHeight = 48.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  final Widget child;
  final Color fillColor;
  final Color edgeColor;
  final double edgeHeight;
  final double borderRadius;
  final VoidCallback? onTap;
  final double minHeight;
  final EdgeInsets padding;

  @override
  State<EdgeButton> createState() => _EdgeButtonState();
}

class _EdgeButtonState extends State<EdgeButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: Container(
        decoration: BoxDecoration(
          color: widget.edgeColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Container(
          margin: EdgeInsets.only(
            bottom: _pressed ? 0 : widget.edgeHeight,
            top: _pressed ? widget.edgeHeight : 0,
          ),
          padding: widget.padding,
          constraints: BoxConstraints(minHeight: widget.minHeight),
          decoration: BoxDecoration(
            color: widget.fillColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Hexagon Painter for Path Nodes (3D bottom edge, clean flat bevel)
// -----------------------------------------------------------------------------

class HexagonPainter extends CustomPainter {
  HexagonPainter({required this.fillColor, required this.edgeColor, this.edgeHeight = 4.0});
  final Color fillColor;
  final Color edgeColor;
  final double edgeHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height - edgeHeight;

    // Draw bottom edge
    final edgePath = Path();
    edgePath.moveTo(w * 0.5, h);
    edgePath.lineTo(w, h * 0.75);
    edgePath.lineTo(w, h * 0.75 + edgeHeight);
    edgePath.lineTo(w * 0.5, h + edgeHeight);
    edgePath.lineTo(0, h * 0.75 + edgeHeight);
    edgePath.lineTo(0, h * 0.75);
    edgePath.close();
    canvas.drawPath(edgePath, Paint()..color = edgeColor);

    // Draw main hexagon face
    final facePath = Path();
    facePath.moveTo(w * 0.5, 0);
    facePath.lineTo(w, h * 0.25);
    facePath.lineTo(w, h * 0.75);
    facePath.lineTo(w * 0.5, h);
    facePath.lineTo(0, h * 0.75);
    facePath.lineTo(0, h * 0.25);
    facePath.close();
    canvas.drawPath(facePath, Paint()..color = fillColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// Header Panel Component (Aligned with ref-2 & ref-4)
// -----------------------------------------------------------------------------

class StyleKitHeaderPanel extends StatelessWidget {
  const StyleKitHeaderPanel({
    super.key,
    required this.panelColor,
    required this.textColor,
    required this.title,
    required this.subtitle,
    required this.illustrationPainter,
    required this.streakText,
    required this.xpText,
    this.showBack = true,
  });

  final Color panelColor;
  final Color textColor;
  final String title;
  final String subtitle;
  final CustomPainter illustrationPainter;
  final String streakText;
  final String xpText;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: CustomPaint(painter: illustrationPainter),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (showBack)
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: StyleKitColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: textColor, size: 22),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: StyleKitColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.menu_book_rounded, color: StyleKitColors.qaidaDark, size: 18),
                            const SizedBox(width: 6),
                            Text('Little Muslim',
                                style: TextStyle(
                                  fontFamily: 'Baloo2',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: textColor,
                                )),
                          ],
                        ),
                      ),
                    const Spacer(),
                    // Streak Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: StyleKitColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: Color(0xFFEA580C), size: 18),
                          const SizedBox(width: 4),
                          Text(streakText,
                              style: const TextStyle(
                                fontFamily: 'Baloo2',
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: StyleKitColors.textDark,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // XP Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: StyleKitColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 18),
                          const SizedBox(width: 4),
                          Text(xpText,
                              style: const TextStyle(
                                fontFamily: 'Baloo2',
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: StyleKitColors.textDark,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor.withValues(alpha: 0.85),
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

// -----------------------------------------------------------------------------
// Qaida Map Path with 5 Nodes (Faithfully aligned with ref-3-adventure-map)
// -----------------------------------------------------------------------------

enum PathNodeState { complete, done, current, locked }

class PathNodeData {
  const PathNodeData({
    required this.stepNumber,
    required this.titleEn,
    required this.titleHi,
    required this.state,
    required this.stars,
    required this.alignLeft,
  });

  final int stepNumber;
  final String titleEn;
  final String titleHi;
  final PathNodeState state;
  final int stars;
  final bool alignLeft;
}

class StyleKitAdventureMapSection extends StatelessWidget {
  const StyleKitAdventureMapSection({super.key, required this.isHindi});
  final bool isHindi;

  static const nodes = [
    PathNodeData(
      stepNumber: 1,
      titleEn: '1: Isolated Letters',
      titleHi: '1: हुरूफ़े मुफ़रदात',
      state: PathNodeState.complete,
      stars: 3,
      alignLeft: true,
    ),
    PathNodeData(
      stepNumber: 2,
      titleEn: '2: Compound Forms',
      titleHi: '2: हुरूफ़ के रूप',
      state: PathNodeState.done,
      stars: 2,
      alignLeft: false,
    ),
    PathNodeData(
      stepNumber: 3,
      titleEn: '3: Harakat Vowels',
      titleHi: '3: हरकत (ज़बर, ज़ेर)',
      state: PathNodeState.current,
      stars: 1,
      alignLeft: true,
    ),
    PathNodeData(
      stepNumber: 4,
      titleEn: '4: Tanween Double',
      titleHi: '4: दो ज़बर, दो ज़ेर',
      state: PathNodeState.locked,
      stars: 0,
      alignLeft: false,
    ),
    PathNodeData(
      stepNumber: 5,
      titleEn: '5: Sukoon & Jazm',
      titleHi: '5: जज़्म व सकून',
      state: PathNodeState.locked,
      stars: 0,
      alignLeft: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: StyleKitColors.mapLand,
        borderRadius: BorderRadius.circular(22),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Flat vector landscape (Winding blue river + green islands)
            Positioned.fill(
              child: ExcludeSemantics(
                child: CustomPaint(
                  painter: _AdventureMapLandscapePainter(),
                ),
              ),
            ),

            // Winding Road & Nodes
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  for (int i = 0; i < nodes.length; i++) ...[
                    _buildWindingNodeRow(nodes[i]),
                    if (i < nodes.length - 1)
                      _buildRoadSegment(isCurveLeft: !nodes[i].alignLeft),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadSegment({required bool isCurveLeft}) {
    return SizedBox(
      height: 32,
      child: Center(
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: StyleKitColors.mapRoad,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: StyleKitColors.mapRoadEdge, width: 2),
          ),
          child: Center(
            child: Container(
              width: 3,
              height: 20,
              color: StyleKitColors.mapRoadDashes,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWindingNodeRow(PathNodeData data) {
    Color fillColor;
    Color edgeColor;
    IconData stateIcon;
    String statusLabelEn;
    String statusLabelHi;

    switch (data.state) {
      case PathNodeState.complete:
        fillColor = StyleKitColors.nodeComplete;
        edgeColor = StyleKitColors.nodeCompleteEdge;
        stateIcon = Icons.check_circle_rounded;
        statusLabelEn = 'Mastered';
        statusLabelHi = 'पूर्ण';
        break;
      case PathNodeState.done:
        fillColor = StyleKitColors.nodeDone;
        edgeColor = StyleKitColors.nodeDoneEdge;
        stateIcon = Icons.check_rounded;
        statusLabelEn = 'Done';
        statusLabelHi = 'सम्पन्न';
        break;
      case PathNodeState.current:
        fillColor = StyleKitColors.nodeCurrent;
        edgeColor = StyleKitColors.nodeCurrentEdge;
        stateIcon = Icons.play_arrow_rounded;
        statusLabelEn = 'Start Here';
        statusLabelHi = 'यहाँ से शुरू करें';
        break;
      case PathNodeState.locked:
        fillColor = StyleKitColors.nodeLocked;
        edgeColor = StyleKitColors.nodeLockedEdge;
        stateIcon = Icons.lock_rounded;
        statusLabelEn = 'Locked';
        statusLabelHi = 'बंद';
        break;
    }

    final isTappable = data.state != PathNodeState.locked;
    final isCurrent = data.state == PathNodeState.current;

    final nodeWidget = Semantics(
      label: '${isHindi ? data.titleHi : data.titleEn}: ${isHindi ? statusLabelHi : statusLabelEn}',
      button: isTappable,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Current Go marker badge (Directly from ref-3-adventure-map "Go!")
          if (isCurrent)
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B), // Dark pill badge matching ref-3 "Go!"
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isHindi ? 'Go! शुरू' : 'Go!',
                style: const TextStyle(
                  fontFamily: 'Baloo2',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: StyleKitColors.white,
                ),
              ),
            ),
          // 3D Hexagon Node
          SizedBox(
            width: 66,
            height: 62,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(66, 62),
                  painter: HexagonPainter(
                    fillColor: fillColor,
                    edgeColor: edgeColor,
                    edgeHeight: isTappable ? 4.0 : 2.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: isTappable ? 4.0 : 2.0),
                  child: Icon(stateIcon, color: StyleKitColors.white, size: 28),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Node Label & Stars
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: StyleKitColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  isHindi ? data.titleHi : data.titleEn,
                  style: const TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: StyleKitColors.textDark,
                  ),
                ),
                if (data.stars > 0)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int s = 0; s < 3; s++)
                        Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: s < data.stars ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    return Align(
      alignment: data.alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(
          left: data.alignLeft ? 28 : 0,
          right: data.alignLeft ? 0 : 28,
        ),
        child: nodeWidget,
      ),
    );
  }
}

class _AdventureMapLandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Winding River (Ref-3)
    final riverPaint = Paint()
      ..color = StyleKitColors.mapWater
      ..style = PaintingStyle.fill;
    final riverPath = Path();
    riverPath.moveTo(size.width * 0.45, 0);
    riverPath.cubicTo(
      size.width * 0.85, size.height * 0.25,
      size.width * 0.05, size.height * 0.55,
      size.width * 0.65, size.height,
    );
    riverPath.lineTo(size.width * 0.95, size.height);
    riverPath.cubicTo(
      size.width * 0.35, size.height * 0.55,
      size.width * 1.10, size.height * 0.25,
      size.width * 0.75, 0,
    );
    riverPath.close();
    canvas.drawPath(riverPath, riverPaint);

    // 2. Flat Green Hill Islands
    final hillPaint = Paint()
      ..color = StyleKitColors.mapLandDark
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(30, size.height * 0.3), width: 90, height: 60),
      hillPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width - 25, size.height * 0.7), width: 85, height: 55),
      hillPaint,
    );

    // 3. Simple Flat Vector Tree Shapes (Cone trees)
    void drawFlatTree(double cx, double cy, double h) {
      final treePaint = Paint()..color = const Color(0xFF15803D);
      final trunkPaint = Paint()..color = const Color(0xFF78350F);
      canvas.drawRect(Rect.fromLTWH(cx - 2, cy, 4, h * 0.3), trunkPaint);
      final tree = Path()
        ..moveTo(cx, cy - h * 0.7)
        ..lineTo(cx + h * 0.4, cy)
        ..lineTo(cx - h * 0.4, cy)
        ..close();
      canvas.drawPath(tree, treePaint);
    }

    drawFlatTree(24, 70, 20);
    drawFlatTree(46, 85, 16);
    drawFlatTree(size.width - 32, size.height * 0.45, 18);
    drawFlatTree(size.width - 48, size.height * 0.48, 14);
    drawFlatTree(38, size.height * 0.82, 18);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// Level Badge Card Component (Directly modeled from ref-3 bottom card)
// -----------------------------------------------------------------------------

class StyleKitLevelBadgeCard extends StatelessWidget {
  const StyleKitLevelBadgeCard({super.key, required this.isHindi});
  final bool isHindi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StyleKitColors.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          // Hexagon Emblem Badge
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: StyleKitColors.quranSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.workspace_premium_rounded, color: StyleKitColors.quranDark, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? 'शुरुआती स्तर 1' : 'Beginner Level 1',
                  style: const TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: StyleKitColors.textDark,
                  ),
                ),
                Text(
                  isHindi ? 'बुनियादी अरबी अक्षर व मखरज' : 'Learners gain authentic Arabic phonetics',
                  style: const TextStyle(
                    fontFamily: 'Baloo2',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: StyleKitColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          // View Action Button with 3D Edge
          EdgeButton(
            fillColor: StyleKitColors.qaidaDark,
            edgeColor: StyleKitColors.qaidaDarkEdge,
            edgeHeight: 3,
            minHeight: 36,
            borderRadius: 14,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              isHindi ? 'देखें' : 'View',
              style: const TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 13,
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
// FIGMA SVG ASSET WIDGET
// =============================================================================

class FigmaSvgWidget extends StatelessWidget {
  const FigmaSvgWidget({
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
        return SvgPicture.string(
          file.readAsStringSync(),
          width: width,
          height: height,
          fit: fit,
        );
      }
    } catch (_) {}
    return SizedBox(width: width, height: height);
  }
}

// =============================================================================
// MAIN STYLE KIT MASTER SHOWCASE WIDGET
// =============================================================================

class StyleKitShowcase extends StatelessWidget {
  const StyleKitShowcase({super.key, required this.isHindi});
  final bool isHindi;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StyleKitColors.pageBg,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 1. HEADER PANELS WITH DECORATIVE ISLAMIC ILLUSTRATIONS ──
            // A. Qaida Header Panel (Green Theme)
            StyleKitHeaderPanel(
              panelColor: StyleKitColors.qaidaSoft,
              textColor: StyleKitColors.qaidaText,
              title: isHindi ? 'नूरानी क़ायदा' : 'Noorani Qaida',
              subtitle: isHindi ? 'चरण 3: हरकत और अलिफ़' : 'Step 3: Harakat & Alif',
              illustrationPainter: const IslamicStarPatternPainter(tintColor: StyleKitColors.qaidaIllus),
              streakText: isHindi ? '5 दिन' : '5 Days',
              xpText: isHindi ? '120 अंक' : '120 XP',
            ),
            const SizedBox(height: 12),

            // B. Quran Header Panel (Gold Theme)
            StyleKitHeaderPanel(
              panelColor: StyleKitColors.quranSoft,
              textColor: StyleKitColors.quranText,
              title: isHindi ? 'पवित्र क़ुरआन' : 'The Holy Quran',
              subtitle: isHindi ? 'सूरह अल-फ़ातिहा (1-7 आयत)' : 'Surah Al-Fatihah (Ayahs 1-7)',
              illustrationPainter: const MosqueSilhouettePainter(tintColor: StyleKitColors.quranIllus),
              streakText: '5',
              xpText: '120',
            ),
            const SizedBox(height: 12),

            // C. App Shell Header Panel (Gentle Mint App Theme)
            StyleKitHeaderPanel(
              showBack: false,
              panelColor: StyleKitColors.appSoft,
              textColor: StyleKitColors.appText,
              title: isHindi ? 'इस्लामी शिक्षा केंद्र' : 'Learning Dashboard',
              subtitle: isHindi ? 'दैनिक प्रगति और अभ्यास' : 'Daily Progress & Habits',
              illustrationPainter: const LanternCrescentPainter(tintColor: StyleKitColors.appIllus),
              streakText: '5',
              xpText: '120',
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── 2. APP BUTTONS (Ref-2 & Ref-3 style) ──
                  _buildSectionTitle(isHindi ? 'बटन घटक (3D बॉटम एज)' : 'Buttons (3D Bottom Edge)'),
                  const SizedBox(height: 8),

                  // Primary Button (Dark Fill + White Text + 3D Edge)
                  EdgeButton(
                    fillColor: StyleKitColors.qaidaDark,
                    edgeColor: StyleKitColors.qaidaDarkEdge,
                    child: Text(
                      isHindi ? 'सबक शुरू करें' : 'Start Lesson',
                      style: const TextStyle(
                        fontFamily: 'Baloo2',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: StyleKitColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Secondary Button (Soft Fill + Dark Text + 3D Edge)
                  EdgeButton(
                    fillColor: StyleKitColors.qaidaSoft,
                    edgeColor: StyleKitColors.qaidaSoftEdge,
                    child: Text(
                      isHindi ? 'अभ्यास दोहराएं' : 'Practice Review',
                      style: const TextStyle(
                        fontFamily: 'Baloo2',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: StyleKitColors.qaidaText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Ghost Button (Text only)
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        isHindi ? 'बाद में करें' : 'Skip for Now',
                        style: const TextStyle(
                          fontFamily: 'Baloo2',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: StyleKitColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── 3. TAPPABLE CARD (3D bottom edge, white fill, no border/shadow) ──
                  _buildSectionTitle(isHindi ? 'टैप करने योग्य कार्ड (3D एज)' : 'Tappable Card (3D Edge)'),
                  const SizedBox(height: 8),
                  EdgeButton(
                    fillColor: StyleKitColors.surface,
                    edgeColor: StyleKitColors.surfaceEdge,
                    borderRadius: 20,
                    edgeHeight: 4,
                    minHeight: 74,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: StyleKitColors.qaidaSoft,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.school_rounded, color: StyleKitColors.qaidaDark, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isHindi ? 'तजवीद के नियम' : 'Tajweed Mastery',
                                style: const TextStyle(
                                  fontFamily: 'Baloo2',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: StyleKitColors.textDark,
                                ),
                              ),
                              Text(
                                isHindi ? 'शुद्ध उच्चारण सीखें' : 'Master authentic phonetics',
                                style: const TextStyle(
                                  fontFamily: 'Baloo2',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: StyleKitColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: StyleKitColors.textMuted, size: 24),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── 4. FLAT CARDS & PROGRESS BAR (Ref-2 & Ref-4) ──
                  _buildSectionTitle(isHindi ? 'समतल कार्ड व प्रगति बार' : 'Flat Card & Progress Bar'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: StyleKitColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: StyleKitColors.quranSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.alarm_on_rounded, color: StyleKitColors.quranDark, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isHindi ? 'दैनिक अध्ययन लक्ष्य' : 'Daily Study Goal',
                                    style: const TextStyle(
                                      fontFamily: 'Baloo2',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: StyleKitColors.textDark,
                                    ),
                                  ),
                                  Text(
                                    isHindi ? '15 मिनट प्रतिदिन (लगातार 5 दिन)' : '15 mins/day (5-day streak maintained)',
                                    style: const TextStyle(
                                      fontFamily: 'Baloo2',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: StyleKitColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Pill Progress Bar (Ref-2)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 10,
                            color: StyleKitColors.qaidaSoft,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: 0.72,
                                child: Container(color: StyleKitColors.qaidaDark),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── 5. LEVEL BADGE CARD (Ref-3 Adventure Map Bottom Card) ──
                  _buildSectionTitle(isHindi ? 'स्तर बैज कार्ड (रेफरेंस 3 शैली)' : 'Level Badge Card (Ref-3 Style)'),
                  const SizedBox(height: 8),
                  StyleKitLevelBadgeCard(isHindi: isHindi),
                  const SizedBox(height: 20),

                  // ── 6. ICON TILES (Ref-1 & Ref-2) ──
                  _buildSectionTitle(isHindi ? 'आइकन टाइल्स (सॉफ्ट टाइल + डार्क आइकन)' : 'Icon Tiles (Soft Tile + Dark Icon)'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconTile(
                        icon: Icons.menu_book_rounded,
                        bgColor: StyleKitColors.qaidaSoft,
                        iconColor: StyleKitColors.qaidaDark,
                        label: isHindi ? 'क़ायदा' : 'Qaida',
                      ),
                      _buildIconTile(
                        icon: Icons.auto_stories_rounded,
                        bgColor: StyleKitColors.quranSoft,
                        iconColor: StyleKitColors.quranDark,
                        label: isHindi ? 'क़ुरआन' : 'Quran',
                      ),
                      _buildIconTile(
                        icon: Icons.mosque_rounded,
                        bgColor: const Color(0xFFE0F2FE),
                        iconColor: const Color(0xFF0369A1),
                        label: isHindi ? 'नमाज़' : 'Prayer',
                      ),
                      _buildIconTile(
                        icon: Icons.volunteer_activism_rounded,
                        bgColor: const Color(0xFFF3E8FF),
                        iconColor: const Color(0xFF7E22CE),
                        label: isHindi ? 'दुआ' : 'Dua',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── 7. CHIPS & TABS (Ref-1 & Ref-4 Segmented Pills) ──
                  _buildSectionTitle(isHindi ? 'चिप्स व टैब्स (3D बॉटम एज)' : 'Chips & Tabs (3D Edge)'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: EdgeButton(
                          fillColor: StyleKitColors.qaidaDark,
                          edgeColor: StyleKitColors.qaidaDarkEdge,
                          borderRadius: 24,
                          edgeHeight: 3,
                          minHeight: 36,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            isHindi ? 'सभी पाठ' : 'All Lessons',
                            style: const TextStyle(
                              fontFamily: 'Baloo2',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: StyleKitColors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: EdgeButton(
                          fillColor: StyleKitColors.qaidaSoft,
                          edgeColor: StyleKitColors.qaidaSoftEdge,
                          borderRadius: 24,
                          edgeHeight: 3,
                          minHeight: 36,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            isHindi ? 'अक्षर' : 'Letters',
                            style: const TextStyle(
                              fontFamily: 'Baloo2',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: StyleKitColors.qaidaText,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: EdgeButton(
                          fillColor: StyleKitColors.qaidaSoft,
                          edgeColor: StyleKitColors.qaidaSoftEdge,
                          borderRadius: 24,
                          edgeHeight: 3,
                          minHeight: 36,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            isHindi ? 'शब्द' : 'Words',
                            style: const TextStyle(
                              fontFamily: 'Baloo2',
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: StyleKitColors.qaidaText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── 8. ADVENTURE MAP PATH (Directly from Ref-3 with 5 Nodes in all states) ──
                  _buildSectionTitle(isHindi ? 'क़ायदा साहसिक नक्शा (रेफरेंस 3 षट्कोण नोड्स)' : 'Qaida Adventure Map (Ref-3 Hexagon Path)'),
                  const SizedBox(height: 8),
                  StyleKitAdventureMapSection(isHindi: isHindi),
                  const SizedBox(height: 20),

                  // ── 9. TEXT FIELD (Ref-1 style, 1.5px border >= 3:1) ──
                  _buildSectionTitle(isHindi ? 'इनपुट फ़ील्ड (1.5px बॉर्डर >= 3:1)' : 'Text Input (1.5px Border >= 3:1)'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: StyleKitColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: StyleKitColors.inputBorder, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person_rounded, color: StyleKitColors.inputBorder, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isHindi ? 'अपना नाम दर्ज करें...' : 'Enter student name...',
                            style: const TextStyle(
                              fontFamily: 'Baloo2',
                              fontSize: 14,
                              color: StyleKitColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── 10. FIGMA ASSETS SHOWCASE (Used AS-IS on Flat Surfaces) ──
                  _buildSectionTitle(isHindi ? 'फ़िगमा एसेट्स (AS-IS वेक्टर + 3D एज)' : 'Figma Assets (AS-IS Vectors + 3D Edge)'),
                  const SizedBox(height: 4),
                  Text(
                    isHindi
                        ? 'स्रोत: फ़्रीपिक प्रीमियम (स्वामी सदस्यता)। सतहें समतल हैं, एसेट्स AS-IS हैं।'
                        : 'Source: Freepik Premium (owner subscription). Assets AS-IS, UI surfaces flat solid.',
                    style: const TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: StyleKitColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // A. Figma Header Illustration (Mosque Dome & Arch)
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: StyleKitColors.qaidaSoft,
                      borderRadius: BorderRadius.circular(20),
                      border: const Border(
                        bottom: BorderSide(
                          color: StyleKitColors.qaidaSoftEdge,
                          width: 4,
                        ),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        const Positioned(
                          right: -10,
                          bottom: -10,
                          top: -10,
                          child: Opacity(
                            opacity: 0.9,
                            child: FigmaSvgWidget(
                              path: 'assets/figma/illustrations/islamic/mosque_dome_arch.svg',
                              width: 140,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isHindi ? 'इस्लामी मस्जिद वास्तुकला' : 'Islamic Mosque Architecture',
                                style: const TextStyle(
                                  fontFamily: 'Baloo2',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: StyleKitColors.qaidaText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isHindi ? 'वेक्टर चित्रण (फ़िगमा से)' : 'Figma SVG Illustration',
                                style: const TextStyle(
                                  fontFamily: 'Baloo2',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: StyleKitColors.qaidaText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // B. 8 Figma Icons on Flat 3D-Edged Soft Tiles
                  Text(
                    isHindi ? '8 फ़िगमा आइकन्स (सॉफ्ट टाइल्स पर 3D एज)' : '8 Figma Icons (3D Edge Soft Tiles)',
                    style: const TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: StyleKitColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFigmaIconTile('ic_game_star', 'assets/figma/icons/game/ic_game_star.svg', StyleKitColors.quranSoft, StyleKitColors.quranSoftEdge, isHindi ? 'तारा' : 'Star'),
                      _buildFigmaIconTile('ic_heart', 'assets/figma/icons/game/ic_heart.svg', const Color(0xFFFCE7F3), const Color(0xFFFBCFE8), isHindi ? 'जीवन' : 'Heart'),
                      _buildFigmaIconTile('ic_gem', 'assets/figma/icons/game/ic_gem.svg', const Color(0xFFE0F2FE), const Color(0xFFBAE6FD), isHindi ? 'रत्न' : 'Gem'),
                      _buildFigmaIconTile('ic_check', 'assets/figma/icons/game/ic_check.svg', StyleKitColors.qaidaSoft, StyleKitColors.qaidaSoftEdge, isHindi ? 'सही' : 'Check'),
                      _buildFigmaIconTile('ic_play', 'assets/figma/icons/game/ic_play.svg', StyleKitColors.appSoft, StyleKitColors.appSoftEdge, isHindi ? 'चलाएं' : 'Play'),
                      _buildFigmaIconTile('ic_lock', 'assets/figma/icons/game/ic_lock.svg', const Color(0xFFF1F5F9), const Color(0xFFCBD5E1), isHindi ? 'ताला' : 'Lock'),
                      _buildFigmaIconTile('ic_trophy', 'assets/figma/icons/game/ic_trophy.svg', StyleKitColors.quranSoft, StyleKitColors.quranSoftEdge, isHindi ? 'ट्रॉफी' : 'Trophy'),
                      _buildFigmaIconTile('ic_lantern', 'assets/figma/icons/islamic/ic_lantern.svg', StyleKitColors.appSoft, StyleKitColors.appSoftEdge, isHindi ? 'फ़ानूस' : 'Lantern'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // C. 3 Figma Badges
                  Text(
                    isHindi ? '3 फ़िगमा बैज (समतल कार्ड + 3D बॉटम एज)' : '3 Figma Badges (Flat Surface + 3D Edge)',
                    style: const TextStyle(
                      fontFamily: 'Baloo2',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: StyleKitColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFigmaBadgeCard(
                          path: 'assets/figma/badges/badge_shield_gold.svg',
                          label: isHindi ? 'स्वर्ण शील्ड' : 'Gold Shield',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildFigmaBadgeCard(
                          path: 'assets/figma/badges/badge_level_1.svg',
                          label: isHindi ? 'स्तर 1' : 'Level 1',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildFigmaBadgeCard(
                          path: 'assets/figma/badges/stars_reward_3.svg',
                          label: isHindi ? '3 सितारे' : '3 Stars',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Baloo2',
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: StyleKitColors.textDark,
      ),
    );
  }

  Widget _buildIconTile({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Baloo2',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: StyleKitColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildFigmaIconTile(String keyName, String path, Color bg, Color edge, String label) {
    return Container(
      width: 74,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(color: edge, width: 3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FigmaSvgWidget(path: path, width: 32, height: 32),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: StyleKitColors.textDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFigmaBadgeCard({required String path, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: StyleKitColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StyleKitColors.surfaceEdge, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FigmaSvgWidget(path: path, width: 44, height: 44),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Baloo2',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: StyleKitColors.textDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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

  testWidgets('Generate Style Kit Golden English (360px)', (tester) async {
    final boundaryKey = GlobalKey();
    tester.view.physicalSize = const Size(360, 3100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Baloo2'),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 3100),
            textScaler: TextScaler.linear(1.0),
          ),
          child: Material(
            child: RepaintBoundary(
              key: boundaryKey,
              child: const SizedBox(
                width: 360,
                height: 3100,
                child: StyleKitShowcase(isHindi: false),
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
          print('✅ Generated docs/screenshots/style_kit_360_en.png (${pngBytes.length} bytes)');
        }
      }
    });
  });

  testWidgets('Generate Style Kit Golden Hindi (360px)', (tester) async {
    final boundaryKey = GlobalKey();
    tester.view.physicalSize = const Size(360, 3100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Baloo2'),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 3100),
            textScaler: TextScaler.linear(1.0),
          ),
          child: Material(
            child: RepaintBoundary(
              key: boundaryKey,
              child: const SizedBox(
                width: 360,
                height: 3100,
                child: StyleKitShowcase(isHindi: true),
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

  testWidgets('Generate Combined Master Style Kit Golden (360px en and hi)', (tester) async {
    final boundaryKey = GlobalKey();
    tester.view.physicalSize = const Size(720, 3100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Baloo2'),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(720, 3100),
            textScaler: TextScaler.linear(1.0),
          ),
          child: Material(
            child: RepaintBoundary(
              key: boundaryKey,
              child: const SizedBox(
                width: 720,
                height: 3100,
                child: Row(
                  children: [
                    SizedBox(width: 360, height: 3100, child: StyleKitShowcase(isHindi: false)),
                    SizedBox(width: 360, height: 3100, child: StyleKitShowcase(isHindi: true)),
                  ],
                ),
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
          File('docs/screenshots/style_kit_360.png').writeAsBytesSync(pngBytes);
          print('✅ Generated master docs/screenshots/style_kit_360.png (${pngBytes.length} bytes)');
        }
      }
    });
  });
}
