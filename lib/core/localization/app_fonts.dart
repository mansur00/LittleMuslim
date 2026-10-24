import 'package:flutter/material.dart';

/// Central typography and font manager for Little Muslim.
///
/// Automatically binds scripts to their optimal typography:
/// - Bengali (`bn`) -> Noto Sans Bengali (with Hind Siliguri fallback)
/// - Hindi (`hi`) -> Noto Sans Devanagari
/// - English/Italian (`en`, `it`) -> Inter (with Roboto fallback)
/// - Arabic/Urdu (`ar`, `ur`) -> Noto Naskh Arabic (with Amiri fallback)
///
/// Attaches universal font-family fallbacks to eliminate missing-glyph boxes ("tofu").
class AppFonts {
  AppFonts._();

  /// Universal fallback chain ensuring glyphs from any script render smoothly.
  static const List<String> globalFallbacks = [
    'Noto Sans Bengali',
    'Hind Siliguri',
    'Noto Sans Devanagari',
    'Noto Naskh Arabic',
    'Amiri',
    'Inter',
    'Roboto',
    'sans-serif',
  ];

  /// Returns the primary font family name for a given language code.
  static String fontFamilyFor(String langCode) {
    switch (langCode.toLowerCase().trim()) {
      case 'bn':
        return 'Noto Sans Bengali';
      case 'hi':
        return 'Noto Sans Devanagari';
      case 'ar':
      case 'ur':
        return 'Noto Naskh Arabic';
      case 'it':
      case 'en':
      default:
        return 'Inter';
    }
  }

  /// Builds a [TextStyle] for the specified language code with full glyph fallbacks.
  static TextStyle getTextStyleForLang(
    String langCode, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    FontStyle? fontStyle,
    List<String>? fontFallbacks,
  }) {
    final fallbacks = fontFallbacks ?? globalFallbacks;
    final primaryFamily = fontFamilyFor(langCode);

    return TextStyle(
      fontFamily: primaryFamily,
      fontFamilyFallback: fallbacks,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      fontStyle: fontStyle,
    );
  }

  /// Builds a localized [TextStyle] deriving language from the active [BuildContext].
  static TextStyle getTextStyle(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    FontStyle? fontStyle,
  }) {
    final locale = Localizations.maybeLocaleOf(context)?.languageCode ?? 'bn';
    return getTextStyleForLang(
      locale,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      fontStyle: fontStyle,
    );
  }

  /// Generates a complete Material 3 [TextTheme] for the target language.
  static TextTheme getTextThemeForLang(String langCode) {
    final fallbacks = globalFallbacks;

    return TextTheme(
      displayLarge: getTextStyleForLang(langCode, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: getTextStyleForLang(langCode, fontSize: 26, fontWeight: FontWeight.w700),
      displaySmall: getTextStyleForLang(langCode, fontSize: 22, fontWeight: FontWeight.w700),
      headlineLarge: getTextStyleForLang(langCode, fontSize: 22, fontWeight: FontWeight.w700),
      headlineMedium: getTextStyleForLang(langCode, fontSize: 20, fontWeight: FontWeight.w600),
      headlineSmall: getTextStyleForLang(langCode, fontSize: 18, fontWeight: FontWeight.w600),
      titleLarge: getTextStyleForLang(langCode, fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: getTextStyleForLang(langCode, fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: getTextStyleForLang(langCode, fontSize: 14, fontWeight: FontWeight.w600),
      bodyLarge: getTextStyleForLang(langCode, fontSize: 16),
      bodyMedium: getTextStyleForLang(langCode, fontSize: 14),
      bodySmall: getTextStyleForLang(langCode, fontSize: 12),
      labelLarge: getTextStyleForLang(langCode, fontSize: 14, fontWeight: FontWeight.w700),
      labelMedium: getTextStyleForLang(langCode, fontSize: 12, fontWeight: FontWeight.w700),
      labelSmall: getTextStyleForLang(langCode, fontSize: 11),
    ).apply(
      fontFamilyFallback: fallbacks,
    );
  }
}
