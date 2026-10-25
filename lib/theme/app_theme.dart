import 'package:flutter/material.dart';
import '../core/core.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

export 'app_colors.dart';
export 'app_spacing.dart';
export 'app_text_styles.dart';

/// AppTheme: Global theme configuration driven strictly by Design System tokens.
class AppTheme {
  // Brand Color Aliases for backward compatibility
  static const Color primaryGreen = AppColors.brandPrimary;
  static const Color primaryDark = AppColors.brandDark;
  static const Color secondaryGold = AppColors.brandAccent;
  static const Color cream = AppColors.background;
  static const Color softGreen = AppColors.brandLight;
  static const Color darkText = AppColors.textPrimary;
  static const Color accentCoral = AppColors.error;
  static const Color white = AppColors.surface;
  static const Color lightGold = AppColors.warningLight;

  static const Color duoGreen = AppColors.brandPrimary;
  static const Color duoGreenDark = AppColors.brandDark;
  static const Color duoGold = AppColors.brandAccent;
  static const Color duoGoldDark = AppColors.brandAccentDark;
  static const Color duoBlue = AppColors.blue;
  static const Color duoBlueDark = AppColors.blueDark;
  static const Color duoRed = AppColors.error;
  static const Color duoRedDark = Color(0xFFEA2B2B);
  static const Color duoGray = Color(0xFFE5E5E5);
  static const Color duoGrayDark = Color(0xFFAFAFAF);
  static const Color duoBorder = AppColors.border;

  static const String arabicFontFamily = 'Amiri';

  static TextStyle arabicTextStyle({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontFamily: arabicFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
      height: height ?? 1.8,
      fontFamilyFallback: AppFonts.globalFallbacks,
    );
  }

  /// Builds a language-specific [ThemeData] with optimal typography and global glyph fallbacks.
  static ThemeData getThemeForLanguage(String langCode) {
    final textTheme = AppTextStyles.buildTextTheme(langCode);
    return _buildTheme(langCode, textTheme);
  }

  static ThemeData get lightTheme => getThemeForLanguage('en');

  static ThemeData _buildTheme(String langCode, TextTheme textTheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.brandPrimary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.brandPrimary,
        onPrimary: AppColors.textInverse,
        secondary: AppColors.brandAccent,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textInverse,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: AppElevation.none,
        scrolledUnderElevation: AppElevation.none,
        toolbarHeight: AppSizes.topBarHeight,
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppSizes.iconLg,
        ),
        titleTextStyle: AppFonts.getTextStyleForLang(
          langCode,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceCard,
        elevation: AppElevation.none,
        margin: AppSpacing.insetNone,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderLg,
          side: BorderSide(color: AppColors.border, width: AppStroke.regular),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: AppSpacing.insetButton,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.border, width: AppStroke.regular),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.border, width: AppStroke.regular),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppColors.brandPrimary, width: AppStroke.strong),
        ),
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandPrimary,
          foregroundColor: AppColors.textInverse,
          elevation: AppElevation.none,
          padding: AppSpacing.insetButton,
          minimumSize: const Size(AppSizes.touchTargetMin, AppSizes.buttonHeightMd),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderMd,
          ),
          textStyle: AppFonts.getTextStyleForLang(
            langCode,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          padding: AppSpacing.insetButton,
          minimumSize: const Size(AppSizes.touchTargetMin, AppSizes.buttonHeightMd),
          side: const BorderSide(color: AppColors.border, width: AppStroke.regular),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderMd,
          ),
          textStyle: AppFonts.getTextStyleForLang(
            langCode,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceSubtle,
        disabledColor: AppColors.surfaceSubtle,
        selectedColor: AppColors.brandLight,
        secondarySelectedColor: AppColors.brandLight,
        padding: AppSpacing.insetChip,
        labelStyle: AppFonts.getTextStyleForLang(
          langCode,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        secondaryLabelStyle: AppFonts.getTextStyleForLang(
          langCode,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textBrand,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderPill,
          side: BorderSide(color: AppColors.border, width: AppStroke.hairline),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppElevation.lg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderXl,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppElevation.lg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.sheetTop,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: AppStroke.hairline,
        space: 1,
      ),
    );
  }
}
