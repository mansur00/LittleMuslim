import 'package:flutter/material.dart';
import '../../widgets/vector_icons.dart';

/// Single source of truth for an application language.
///
/// Contains code, native name, reading direction, typography font family,
/// and asset bundle paths. Adding a language requires ONLY:
/// 1. Adding one entry here
/// 2. Adding one JSON locale file (e.g. `assets/locales/xx.json`)
class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    this.englishName = '',
    this.direction = TextDirection.ltr,
    this.fontFamily,
    this.intlLocale,
    this.currencyCode = 'USD',
    this.currencySymbol = '\$',
    required this.arbPath,
    required this.jsonPath,
    this.flagIcon = VectorIconType.globe,
  });

  /// 2-letter ISO language code (e.g., 'bn', 'en', 'hi', 'it', 'ar')
  final String code;

  /// Native display name (e.g., 'বাংলা', 'English', 'हिंदी', 'Italiano')
  final String name;

  /// Explicit native script name
  final String nativeName;

  /// English / international name (e.g. 'Bengali', 'English', 'Hindi', 'Italian')
  final String englishName;

  /// Reading direction: LTR (Left-to-Right) or RTL (Right-to-Left)
  final TextDirection direction;

  /// Optional custom font family override (e.g., 'Amiri' for Arabic)
  final String? fontFamily;

  /// Standard BCP-47 / Intl locale identifier (e.g. 'bn', 'en', 'hi', 'it')
  final String? intlLocale;

  /// ISO 4217 currency code (e.g. 'BDT', 'USD', 'INR', 'EUR')
  final String currencyCode;

  /// Primary currency symbol (e.g. '৳', '$', '₹', '€')
  final String currencySymbol;

  /// Effective Intl locale code
  String get effectiveIntlLocale => intlLocale ?? code;

  /// Path to the localized ARB file
  final String arbPath;

  /// Path to the localized JSON file
  final String jsonPath;

  /// Vector icon or country flag
  final VectorIconType flagIcon;

  /// Standard Flutter Locale object
  Locale get locale => Locale(code);

  /// HTML dir attribute string ('ltr' or 'rtl')
  String get dirString => direction == TextDirection.rtl ? 'rtl' : 'ltr';

  /// Whether this language reads Right-to-Left
  bool get isRtl => direction == TextDirection.rtl;
}

/// Global registry of supported languages.
///
/// **To add or remove a language app-wide, update only this list!**
/// All screens (Settings, Onboarding, AppState, MaterialApp, Localizations)
/// derive their configuration dynamically from here.
class AppLanguages {
  AppLanguages._();

  static const String defaultCode = 'bn';
  static const String fallbackCode = 'en';

  static const List<AppLanguage> all = [
    AppLanguage(
      code: 'bn',
      name: '\u09AC\u09BE\u0982\u09B2\u09BE',
      nativeName: '\u09AC\u09BE\u0982\u09B2\u09BE',
      englishName: 'Bengali',
      direction: TextDirection.ltr,
      intlLocale: 'bn',
      currencyCode: 'BDT',
      currencySymbol: '\u09F3',
      arbPath: 'assets/l10n/app_bn.arb',
      jsonPath: 'assets/locales/bn.json',
      flagIcon: VectorIconType.flagBd,
    ),
    AppLanguage(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      englishName: 'English',
      direction: TextDirection.ltr,
      intlLocale: 'en',
      currencyCode: 'USD',
      currencySymbol: '\$',
      arbPath: 'assets/l10n/app_en.arb',
      jsonPath: 'assets/locales/en.json',
      flagIcon: VectorIconType.flagGb,
    ),
    AppLanguage(
      code: 'hi',
      name: '\u0939\u093F\u0902\u0926\u0940',
      nativeName: '\u0939\u093F\u0902\u0926\u0940',
      englishName: 'Hindi',
      direction: TextDirection.ltr,
      intlLocale: 'hi',
      currencyCode: 'INR',
      currencySymbol: '\u20B9',
      arbPath: 'assets/l10n/app_hi.arb',
      jsonPath: 'assets/locales/hi.json',
      flagIcon: VectorIconType.globe,
    ),
    AppLanguage(
      code: 'it',
      name: 'Italiano',
      nativeName: 'Italiano',
      englishName: 'Italian',
      direction: TextDirection.ltr,
      intlLocale: 'it',
      currencyCode: 'EUR',
      currencySymbol: '€',
      arbPath: 'assets/l10n/app_it.arb',
      jsonPath: 'assets/locales/it.json',
      flagIcon: VectorIconType.globe,
    ),
  ];

  /// The canonical English fallback language object
  static AppLanguage get fallback => byCode(fallbackCode) ?? all[1];

  /// Set of all supported language codes
  static final Set<String> codes = all.map((l) => l.code).toSet();

  /// List of supported Flutter [Locale] objects for [MaterialApp.supportedLocales]
  static List<Locale> get supportedLocales =>
      all.map((l) => l.locale).toList();

  /// Checks if a language code is currently supported
  static bool isSupported(String? code) =>
      code != null && codes.contains(code.toLowerCase().trim());

  /// Returns valid language code, falling back to [defaultCode] if invalid
  static String validate(String? code) {
    if (code == null) return defaultCode;
    final normalized = code.toLowerCase().trim();
    return codes.contains(normalized) ? normalized : defaultCode;
  }

  /// Finds an [AppLanguage] by its code
  static AppLanguage? byCode(String? code) {
    if (code == null) return null;
    final normalized = code.toLowerCase().trim();
    for (final lang in all) {
      if (lang.code == normalized) return lang;
    }
    return null;
  }

  /// Returns the ARB file asset path for a language code
  static String getArbPath(String code) {
    final lang = byCode(code);
    return lang?.arbPath ?? 'assets/l10n/app_$defaultCode.arb';
  }

  /// Returns the JSON file asset path for a language code
  static String getJsonPath(String code) {
    final lang = byCode(code);
    return lang?.jsonPath ?? 'assets/locales/$defaultCode.json';
  }
}
