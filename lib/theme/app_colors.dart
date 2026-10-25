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

  static const Color warningText = Color(0xFF92400E);
  static const Color warningSubtext = Color(0xFFB45309);
  static const Color warningDark = Color(0xFFD97706);
  static const Color blueText = Color(0xFF1D4ED8);
  static const Color blueAccent = Color(0xFF2563EB);
  static const Color purpleText = Color(0xFF7E22CE);
  static const Color purpleBorder = Color(0xFFE9D5FF);
  static const Color orangeText = Color(0xFFC2410C);
  static const Color orangeBorder = Color(0xFFFDBA74);
  static const Color greenText = Color(0xFF15803D);

  // ── Palette Shades & Semantic Tints ───────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color black06 = Color(0x10000000);
  static const Color black10 = Color(0x1A000000);
  static const Color black12 = Color(0x1F000000);
  static const Color black20 = Color(0x33000000);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white80 = Color(0xCCFFFFFF);
  static const Color transparent = Color(0x00000000);

  // Slate Neutrals
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // Gray / Indigo / Accents
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color green50 = Color(0xFFF0FDF4);
  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green200 = Color(0xFFBBF7D0);
  static const Color green300 = Color(0xFF86EFAC);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green600 = Color(0xFF16A34A);
  static const Color greenDarkText = Color(0xFF2D6A00);
  static const Color emerald500 = Color(0xFF10B981);
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue200 = Color(0xFFBFDBFE);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color indigo50 = Color(0xFFEEF2FF);
  static const Color indigo200 = Color(0xFFC7D2FE);
  static const Color indigo500 = Color(0xFF6366F1);
  static const Color purple50 = Color(0xFFFAF5FF);
  static const Color purple200 = Color(0xFFE9D5FF);
  static const Color purple600 = Color(0xFF9333EA);
  static const Color purple700 = Color(0xFF7E22CE);
  static const Color amber50 = Color(0xFFFFFBEB);
  static const Color amber100 = Color(0xFFFEF3C7);
  static const Color amber200 = Color(0xFFFDE68A);
  static const Color amber300 = Color(0xFFFCD34D);
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber600 = Color(0xFFD97706);
  static const Color amber700 = Color(0xFFB45309);
  static const Color amber800 = Color(0xFF92400E);
  static const Color orange50 = Color(0xFFFFF7ED);
  static const Color orange200 = Color(0xFFFDBA74);
  static const Color orange500 = Color(0xFFF97316);
  static const Color goldLight = Color(0xFFFFE39A);
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
