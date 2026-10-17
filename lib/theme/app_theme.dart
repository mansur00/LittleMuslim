import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Islamic Middle-East inspired palette
  static const Color primaryGreen = Color(0xFF0D7377); // Deep teal-green
  static const Color secondaryGold = Color(0xFFD4A017); // Warm gold
  static const Color cream = Color(0xFFFFFFFF); // Clean white background like Duolingo
  static const Color softGreen = Color(0xFFE8F8D8); // Light green cards
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
        shadowColor: primaryGreen.withValues(alpha: .16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
              color: primaryGreen.withValues(alpha: .14), width: 1.4),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: primaryGreen.withValues(alpha: .16)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: primaryGreen.withValues(alpha: .16)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: darkText,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: darkText,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: darkText.withValues(alpha: 0.85),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: white,
          elevation: 5,
          shadowColor: const Color(0xFF084D4F),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(5),
          shadowColor: const WidgetStatePropertyAll(Color(0xFF084D4F)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: primaryGreen.withValues(alpha: .55), width: 1.5),
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
        elevation: 10,
        shadowColor: primaryGreen.withValues(alpha: .28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: primaryGreen.withValues(alpha: .18), width: 1.5),
        ),
        titleTextStyle: GoogleFonts.poppins(
          color: darkText,
          fontSize: 19,
          fontWeight: FontWeight.w900,
        ),
        contentTextStyle: GoogleFonts.poppins(
          color: darkText.withValues(alpha: .78),
          fontSize: 13,
          height: 1.5,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cream,
        modalBackgroundColor: cream,
        elevation: 12,
        shadowColor: primaryGreen.withValues(alpha: .25),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        showDragHandle: true,
        dragHandleColor: primaryGreen.withValues(alpha: .22),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A3C34),
        contentTextStyle: GoogleFonts.poppins(
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
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        iconTheme: const IconThemeData(color: darkText),
      ),
    );
  }
}
