import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/core.dart';

class AppTheme {
  // Brand Duolingo Gamification Palette
  static const Color primaryGreen = Color(0xFF58CC02); // Signature gamified bright green
  static const Color primaryDark = Color(0xFF46A302); // 3D bevel shadow green
  static const Color secondaryGold = Color(0xFFFFC800); // Warm gold
  static const Color cream = Color(0xFFFFFFFF); // Clean white background like Duolingo
  static const Color softGreen = Color(0xFFE8F8D8); // Light green cards / badges
  static const Color darkText = Color(0xFF3C3C3C); // Clean dark charcoal text
  static const Color accentCoral =
      Color(0xFFFF4B4B); // Duolingo heart/accent red
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGold = Color(0xFFFFF3C4);

  // Signature Duolingo Gamification 3D Palette
  static const Color duoGreen = Color(0xFF58CC02);
  static const Color duoGreenDark = Color(0xFF46A302);
  static const Color duoGold = Color(0xFFFFC800);
  static const Color duoGoldDark = Color(0xFFE5A100);
  static const Color duoBlue = Color(0xFF1CB0F6);
  static const Color duoBlueDark = Color(0xFF1899D6);
  static const Color duoRed = Color(0xFFFF4B4B);
  static const Color duoRedDark = Color(0xFFEA2B2B);
  static const Color duoGray = Color(0xFFE5E5E5);
  static const Color duoGrayDark = Color(0xFFAFAFAF);
  static const Color duoBorder = Color(0xFFE5E7EB);

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
      color: color ?? darkText,
      height: height ?? 1.8,
      fontFamilyFallback: AppFonts.globalFallbacks,
    );
  }

  /// Builds a language-specific [ThemeData] with optimal typography and global glyph fallbacks.
  static ThemeData getThemeForLanguage(String langCode) {
    final textTheme = AppFonts.getTextThemeForLang(langCode);
    return lightTheme.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: duoGreen,
      scaffoldBackgroundColor: white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: duoGreen,
        primary: duoGreen,
        secondary: duoGold,
        surface: white,
        onPrimary: white,
        onSecondary: darkText,
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: duoGreenDark.withValues(alpha: .14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // DS.rXl (20px)
          side: const BorderSide(
              color: duoBorder, width: 2.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: duoBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: duoBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: duoGreen, width: 2),
        ),
      ),
      textTheme: AppFonts.getTextThemeForLang('en'),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: duoGreen,
          foregroundColor: white,
          elevation: 4,
          shadowColor: duoGreenDark,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // DS.rLg
          ),
          textStyle: AppFonts.getTextStyleForLang(
            'en',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(duoGreen),
          foregroundColor: const WidgetStatePropertyAll(white),
          elevation: const WidgetStatePropertyAll(4),
          shadowColor: const WidgetStatePropertyAll(duoGreenDark),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: duoBorder, width: 2.0),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cream,
        elevation: 8,
        shadowColor: duoGreenDark.withValues(alpha: .20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // DS.rXl
          side: const BorderSide(color: duoBorder, width: 2.0),
        ),
        titleTextStyle: AppFonts.getTextStyleForLang(
          'en',
          color: darkText,
          fontSize: 19,
          fontWeight: FontWeight.w900,
        ),
        contentTextStyle: AppFonts.getTextStyleForLang(
          'en',
          color: darkText.withValues(alpha: .78),
          fontSize: 13,
          height: 1.5,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cream,
        modalBackgroundColor: cream,
        elevation: 12,
        shadowColor: duoGreenDark.withValues(alpha: .20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
        dragHandleColor: duoBorder,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A3C34),
        contentTextStyle: AppFonts.getTextStyleForLang(
          'en',
          color: white,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        iconColor: primaryGreen,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppFonts.getTextStyleForLang(
          'en',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        iconTheme: const IconThemeData(color: darkText),
      ),
    );
  }
}
