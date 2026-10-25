import 'package:flutter/material.dart';

/// AppColors: Unified design system color palette for Little Muslim.
/// Includes brand, surface, background, text, border, semantic feedback,
/// and dark-mode ready tokens.
class AppColors {
  AppColors._();

  // ── Brand Colors ─────────────────────────────────────────────────────────
  static const Color brandPrimary = Color(0xFF58CC02); // Vibrant child-friendly green
  static const Color brandDark = Color(0xFF46A302);    // 3D bevel / shadow green
  static const Color brandLight = Color(0xFFE8F8D8);   // Soft pastel green tint
  static const Color brandAccent = Color(0xFFFFC800);  // Gold / streak / star accent
  static const Color brandAccentDark = Color(0xFFE5A100);

  // ── Secondary Brand Accents ──────────────────────────────────────────────
  static const Color blue = Color(0xFF1CB0F6);
  static const Color blueDark = Color(0xFF1899D6);
  static const Color blueLight = Color(0xFFE0F2FE);

  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleDark = Color(0xFF7C3AED);
  static const Color purpleLight = Color(0xFFF3E8FF);

  static const Color orange = Color(0xFFFF9600);
  static const Color orangeDark = Color(0xFFEA8000);
  static const Color orangeLight = Color(0xFFFFEDD5);

  // ── Surfaces & Backgrounds ───────────────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSubtle = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF1F5F9);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceOverlay = Color(0x66000000);

  // ── Text & Typography ───────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F172A);   // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textTertiary = Color(0xFF94A3B8);  // Slate 400
  static const Color textDisabled = Color(0xFFCBD5E1);  // Slate 300
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textBrand = Color(0xFF2D6A00);

  // ── Borders & Dividers ───────────────────────────────────────────────────
  static const Color border = Color(0xFFE2E8F0);        // Slate 200
  static const Color borderSubtle = Color(0xFFF1F5F9);  // Slate 100
  static const Color borderStrong = Color(0xFFCBD5E1);  // Slate 300
  static const Color borderBrand = Color(0xFF86EFAC);   // Green 300
  static const Color divider = Color(0xFFE2E8F0);

  // ── Semantic Feedback ────────────────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color successBorder = Color(0xFF86EFAC);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningBorder = Color(0xFFFDE68A);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorBorder = Color(0xFFFCA5A5);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEFF6FF);
  static const Color infoBorder = Color(0xFFBFDBFE);

  // ── Transparent / Opacity Helpers ────────────────────────────────────────
  static const Color transparent = Color(0x00000000);
  static const Color black10 = Color(0x1A000000);
  static const Color black20 = Color(0x33000000);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white80 = Color(0xCCFFFFFF);
}

/// AppColorsDark: Dark-mode ready pairs for future theme expansion.
class AppColorsDark {
  AppColorsDark._();

  static const Color background = Color(0xFF0F172A);
  static const Color backgroundSubtle = Color(0xFF1E293B);
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceSubtle = Color(0xFF334155);
  static const Color surfaceCard = Color(0xFF1E293B);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF475569);
  static const Color textInverse = Color(0xFF0F172A);

  static const Color border = Color(0xFF334155);
  static const Color borderSubtle = Color(0xFF1E293B);
  static const Color borderStrong = Color(0xFF475569);
  static const Color divider = Color(0xFF334155);
}
