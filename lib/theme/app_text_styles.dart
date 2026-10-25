import 'package:flutter/material.dart';
import '../core/localization/app_fonts.dart';
import '../l10n/app_localizations.dart';
import 'app_colors.dart';

/// AppTextStyles: Centralized typographic scales bound to multilingual fonts.
/// Guarantees that Latin, Bengali, Hindi, and Arabic render without glyph clipping or missing-glyph tofu.
class AppTextStyles {
  AppTextStyles._();

  // ── Context-Aware Multilingual Resolvers ──────────────────────────────────
  static TextStyle display(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return AppFonts.getTextStyle(
      context,
      fontSize: 28,
      fontWeight: fontWeight ?? FontWeight.w800,
      color: color ?? AppColors.textPrimary,
      height: 1.25,
    );
  }

  static TextStyle title(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return AppFonts.getTextStyle(
      context,
      fontSize: 20,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? AppColors.textPrimary,
      height: 1.3,
    );
  }

  static TextStyle titleSmall(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return AppFonts.getTextStyle(
      context,
      fontSize: 16,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? AppColors.textPrimary,
      height: 1.35,
    );
  }

  static TextStyle subtitle(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return AppFonts.getTextStyle(
      context,
      fontSize: 14,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? AppColors.textSecondary,
      height: 1.4,
    );
  }

  static TextStyle body(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return AppFonts.getTextStyle(
      context,
      fontSize: 14,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? AppColors.textPrimary,
      height: 1.5,
    );
  }

  static TextStyle bodySmall(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return AppFonts.getTextStyle(
      context,
      fontSize: 12,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? AppColors.textSecondary,
      height: 1.4,
    );
  }

  static TextStyle caption(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return AppFonts.getTextStyle(
      context,
      fontSize: 11,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textTertiary,
      height: 1.3,
    );
  }

  static TextStyle button(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return AppFonts.getTextStyle(
      context,
      fontSize: 15,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? AppColors.textInverse,
      height: 1.2,
    );
  }

  static TextStyle label(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return AppFonts.getTextStyle(
      context,
      fontSize: 12,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? AppColors.textPrimary,
      height: 1.2,
    );
  }

  // ── Language-Code Resolvers for Static Themes ─────────────────────────────
  static TextTheme buildTextTheme(String langCode) {
    return TextTheme(
      displayLarge: AppFonts.getTextStyleForLang(langCode, fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      displayMedium: AppFonts.getTextStyleForLang(langCode, fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      displaySmall: AppFonts.getTextStyleForLang(langCode, fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      headlineMedium: AppFonts.getTextStyleForLang(langCode, fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      headlineSmall: AppFonts.getTextStyleForLang(langCode, fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      titleLarge: AppFonts.getTextStyleForLang(langCode, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      titleMedium: AppFonts.getTextStyleForLang(langCode, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleSmall: AppFonts.getTextStyleForLang(langCode, fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
      bodyLarge: AppFonts.getTextStyleForLang(langCode, fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
      bodyMedium: AppFonts.getTextStyleForLang(langCode, fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
      bodySmall: AppFonts.getTextStyleForLang(langCode, fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
      labelLarge: AppFonts.getTextStyleForLang(langCode, fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      labelMedium: AppFonts.getTextStyleForLang(langCode, fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
      labelSmall: AppFonts.getTextStyleForLang(langCode, fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiary),
    );
  }
}
