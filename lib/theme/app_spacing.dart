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
}

/// AppSizes: Standard dimensions for icons, avatars, buttons, and app bars.
class AppSizes {
  AppSizes._();

  // Icons
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // Avatars
  static const double avatarSm = 32;
  static const double avatarMd = 40;
  static const double avatarLg = 48;
  static const double avatarXl = 64;

  // Touch targets & Heights
  static const double touchTargetMin = 44; // Minimum accessible touch target
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 44;
  static const double buttonHeightLg = 52;

  // App Bar & Top Bar
  static const double topBarHeight = 60;
  static const double pageHeaderHeight = 56;
}
