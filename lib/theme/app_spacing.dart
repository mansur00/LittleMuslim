import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AppSpacing: Standard 4px-grid spacing tokens for Little Muslim.
class AppSpacing {
  AppSpacing._();

  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  // Pre-built insets for zero-literal UI construction
  static const EdgeInsets insetNone = EdgeInsets.zero;
  static const EdgeInsets insetXs = EdgeInsets.all(xs);
  static const EdgeInsets insetSm = EdgeInsets.all(sm);
  static const EdgeInsets insetMd = EdgeInsets.all(md);
  static const EdgeInsets insetLg = EdgeInsets.all(lg);
  static const EdgeInsets insetXl = EdgeInsets.all(xl);
  static const EdgeInsets insetXxl = EdgeInsets.all(xxl);

  static const EdgeInsets insetHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets insetHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets insetHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets insetHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets insetVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets insetVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets insetVerticalLg = EdgeInsets.symmetric(vertical: lg);

  // Common symmetrical button and chip insets
  static const EdgeInsets insetButton = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets insetChip = EdgeInsets.symmetric(horizontal: md, vertical: xs);
  static const EdgeInsets insetCard = EdgeInsets.all(lg);

  // Spacing gaps
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);
  static const SizedBox gapXxl = SizedBox(width: xxl, height: xxl);

  static const SizedBox gapWXs = SizedBox(width: xs);
  static const SizedBox gapWSm = SizedBox(width: sm);
  static const SizedBox gapWMd = SizedBox(width: md);
  static const SizedBox gapWLg = SizedBox(width: lg);
  static const SizedBox gapWXl = SizedBox(width: xl);

  static const SizedBox gapHXs = SizedBox(height: xs);
  static const SizedBox gapHSm = SizedBox(height: sm);
  static const SizedBox gapHMd = SizedBox(height: md);
  static const SizedBox gapHLg = SizedBox(height: lg);
  static const SizedBox gapHXl = SizedBox(height: xl);
  static const SizedBox gapHXxl = SizedBox(height: xxl);

  static EdgeInsets all(double v) => EdgeInsets.all(v);
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  static EdgeInsets only({double left = 0, double top = 0, double right = 0, double bottom = 0}) =>
      EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  static EdgeInsets fromLTRB(double l, double t, double r, double b) =>
      EdgeInsets.fromLTRB(l, t, r, b);
}

/// AppRadius: Standardized corner radii across components.
class AppRadius {
  AppRadius._();

  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double pill = 9999;

  static const BorderRadius borderXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius borderPill = BorderRadius.all(Radius.circular(pill));

  // Sheet / Modal rounded tops
  static const BorderRadius sheetTop = BorderRadius.vertical(top: Radius.circular(xl));

  static BorderRadius radius(double r) => BorderRadius.circular(r);
  static BorderRadius only({double topLeft = 0, double topRight = 0, double bottomLeft = 0, double bottomRight = 0}) =>
      BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      );
}

/// AppStroke: Standard border and outline stroke widths.
class AppStroke {
  AppStroke._();

  static const double none = 0;
  static const double hairline = 1.0;
  static const double regular = 1.5;
  static const double strong = 2.0;
  static const double thick = 3.0;
}

/// AppElevation: Standard elevation levels and shadow configurations.
class AppElevation {
  AppElevation._();

  static const double none = 0;
  static const double sm = 2;
  static const double md = 4;
  static const double lg = 8;
  static const double xl = 16;

  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x10000000),
      offset: Offset(0, 4),
      blurRadius: 10,
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x18000000),
      offset: Offset(0, 8),
      blurRadius: 20,
    ),
  ];

  static const List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Color(0x08000000),
      offset: Offset(0, 2),
      blurRadius: 6,
    ),
  ];

  static List<BoxShadow> shadow({
    Color color = AppColors.black10,
    double blurRadius = 4,
    Offset offset = const Offset(0, 2),
  }) => [
    BoxShadow(color: color, blurRadius: blurRadius, offset: offset),
  ];
}

/// AppSizes: Standard dimensions for icons, avatars, buttons, and app bars.
class AppSizes {
  AppSizes._();

  // Icons
  static const double iconXs = 12;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconButtonSm = 22;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // Avatars & Lesson Boxes
  static const double avatarSm = 32;
  static const double avatarMd = 40;
  static const double avatarLg = 48;
  static const double lessonIconBox = 54;
  static const double avatarXl = 64;

  // Touch targets & Heights
  static const double touchTargetMin = 44; // Minimum accessible touch target
  static const double pillHeight = 38;
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 44;
  static const double buttonHeightLg = 52;

  // App Bar & Top Bar
  static const double topBarHeight = 60;
  static const double pageHeaderHeight = 56;
}

/// AppBorders: Standardized border strokes.
class AppBorders {
  AppBorders._();

  static const Border hairline = Border.fromBorderSide(BorderSide(color: AppColors.border, width: AppStroke.hairline));
  static const Border regular = Border.fromBorderSide(BorderSide(color: AppColors.border, width: AppStroke.regular));
  static const Border warning = Border.fromBorderSide(BorderSide(color: AppColors.warning, width: AppStroke.regular));
  static const Border brand = Border.fromBorderSide(BorderSide(color: AppColors.brandPrimary, width: AppStroke.regular));
  static const Border greenAccent = Border.fromBorderSide(BorderSide(color: AppColors.borderBrand, width: AppStroke.regular));
  static const Border blue = Border.fromBorderSide(BorderSide(color: AppColors.infoBorder, width: AppStroke.regular));
  static const Border purple = Border.fromBorderSide(BorderSide(color: AppColors.purpleBorder, width: AppStroke.regular));
  static const Border orange = Border.fromBorderSide(BorderSide(color: AppColors.orangeBorder, width: AppStroke.regular));
  static const Border none = Border.fromBorderSide(BorderSide(color: AppColors.transparent, width: AppStroke.none));
  static const Border topHairline = Border(top: BorderSide(color: AppColors.border, width: AppStroke.regular));

  static Border custom({Color color = AppColors.border, double width = AppStroke.regular}) =>
      Border.all(color: color, width: width);
  static Border sideOnly({
    BorderSide top = BorderSide.none,
    BorderSide right = BorderSide.none,
    BorderSide bottom = BorderSide.none,
    BorderSide left = BorderSide.none,
  }) => Border(top: top, right: right, bottom: bottom, left: left);
  static Border borderTop({Color color = AppColors.border, double width = AppStroke.regular}) =>
      Border(top: BorderSide(color: color, width: width));
}

/// AppGradients: Pre-defined multi-color gradients.
class AppGradients {
  AppGradients._();

  static const LinearGradient brand = LinearGradient(
    colors: [AppColors.brandPrimary, AppColors.brandDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gold = LinearGradient(
    colors: [AppColors.brandAccent, AppColors.orange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient linear({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) => LinearGradient(colors: colors, begin: begin, end: end);
}
