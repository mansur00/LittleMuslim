import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../l10n/static_translations.dart';
import 'app_languages.dart';

/// Predefined standard date formats supported across all locales.
enum AppDateFormat {
  /// e.g. '21/10/2026' or locale equivalent
  short,

  /// e.g. '21 Oct 2026' or '২১ অক্টো, ২০২৬'
  medium,

  /// e.g. '21 October 2026' or '২১ অক্টোবর, ২০২৬'
  full,

  /// e.g. 'October 21' or '২১ অক্টোবর'
  monthDay,

  /// e.g. 'October 2026' or 'অক্টোবর ২০২৬'
  monthYear,

  /// e.g. 'Wednesday' or 'বুধবার'
  weekday,

  /// e.g. 'Wed' or 'বুধ'
  weekdayShort,

  /// e.g. 'Wed, Oct 21' or 'বুধ, ২১ অক্টো'
  weekdayMonthDay,
}

/// Centralized i18n formatting engine for dates, times, numbers, currency, and digits.
///
/// Backed by standard [Intl] ([DateFormat], [NumberFormat]), ensuring zero
/// hardcoded formats, month names, day names, or currency symbols.
class AppFormatters {
  AppFormatters._();

  static const String banglaDigits =
      '\u09E6\u09E7\u09E8\u09E9\u09EA\u09EB\u09EC\u09ED\u09EE\u09EF';
  static const String latinDigits = '0123456789';
  static const String devanagariDigits =
      '\u0966\u0967\u0968\u0969\u096A\u096B\u096C\u096D\u096E\u096F';

  static final Set<String> _initializedLocales = {};

  /// Ensures date symbols are loaded for all registered app languages or a specific locale.
  static Future<void> initialize([String? locale]) async {
    if (locale != null) {
      await _initSingleLocale(locale);
    } else {
      for (final lang in AppLanguages.all) {
        await _initSingleLocale(lang.effectiveIntlLocale);
      }
    }
  }

  static Future<void> _initSingleLocale(String loc) async {
    final code = _resolveLocale(loc);
    if (!_initializedLocales.contains(code)) {
      try {
        await initializeDateFormatting(code, null);
        _initializedLocales.add(code);
      } catch (_) {
        // Fallback gracefully
      }
    }
  }

  static void _ensureLocaleInitialized(String loc) {
    if (!_initializedLocales.contains(loc)) {
      try {
        initializeDateFormatting(loc, null);
        _initializedLocales.add(loc);
      } catch (_) {
        // Non-fatal, intl handles standard fallbacks
      }
    }
  }

  static String _resolveLocale(String? locale) {
    if (locale == null || locale.isEmpty) return AppLanguages.defaultCode;
    final normalized = locale.toLowerCase().trim();
    final lang = AppLanguages.byCode(normalized);
    return lang?.effectiveIntlLocale ?? normalized;
  }

  // ===========================================================================
  // DIGIT CONVERSIONS
  // ===========================================================================

  /// Converts any string containing numeric digits according to the target locale.
  /// - For `'bn'`, converts Latin digits (`0-9`) to Bengali digits (`০-৯`).
  /// - For other locales (`'en'`, `'it'`, `'hi'`), normalizes Bengali digits back to Latin digits.
  static String formatDigits(String input, {String? locale}) {
    if (input.isEmpty) return input;
    final lang = _resolveLocale(locale);

    if (lang == 'bn') {
      var result = input;
      for (var i = 0; i < latinDigits.length; i++) {
        result = result.replaceAll(latinDigits[i], banglaDigits[i]);
      }
      return result;
    } else {
      var result = input;
      for (var i = 0; i < banglaDigits.length; i++) {
        result = result.replaceAll(banglaDigits[i], latinDigits[i]);
      }
      return result;
    }
  }

  /// Converts any number or string representation to Bengali digits.
  static String toBengaliDigits(dynamic value) {
    if (value == null) return '';
    final str = value.toString();
    var result = str;
    for (var i = 0; i < latinDigits.length; i++) {
      result = result.replaceAll(latinDigits[i], banglaDigits[i]);
    }
    return result;
  }

  /// Converts any Bengali or Devanagari digit string back to standard Latin digits.
  static String toLatinDigits(dynamic value) {
    if (value == null) return '';
    var result = value.toString();
    for (var i = 0; i < banglaDigits.length; i++) {
      result = result.replaceAll(banglaDigits[i], latinDigits[i]);
    }
    for (var i = 0; i < devanagariDigits.length; i++) {
      result = result.replaceAll(devanagariDigits[i], latinDigits[i]);
    }
    return result;
  }

  /// Converts any number or string representation to Devanagari digits.
  static String toDevanagariDigits(dynamic value) {
    if (value == null) return '';
    final str = toLatinDigits(value);
    var result = str;
    for (var i = 0; i < latinDigits.length; i++) {
      result = result.replaceAll(latinDigits[i], devanagariDigits[i]);
    }
    return result;
  }

  // ===========================================================================
  // NUMBER & PERCENT FORMATTING
  // ===========================================================================

  /// Formats numbers using standard [Intl.NumberFormat] for the active locale.
  /// Bengali produces Bengali digits (`১২,৩৪৫`); Italian produces period groupings (`12.345`).
  static String formatNumber(
    num number, {
    String? locale,
    int? decimalDigits,
    bool compact = false,
  }) {
    final loc = _resolveLocale(locale);
    try {
      if (compact) {
        return NumberFormat.compact(locale: loc).format(number);
      }
      final fmt = NumberFormat.decimalPattern(loc);
      if (decimalDigits != null) {
        fmt.minimumFractionDigits = decimalDigits;
        fmt.maximumFractionDigits = decimalDigits;
      }
      return fmt.format(number);
    } catch (_) {
      final str = decimalDigits != null
          ? number.toStringAsFixed(decimalDigits)
          : number.toString();
      return formatDigits(str, locale: loc);
    }
  }

  /// Formats a percentage using [NumberFormat.percentPattern].
  /// [isRatio] should be true when value is 0.0 - 1.0, or false when 0 - 100.
  static String formatPercent(
    num value, {
    String? locale,
    int decimalDigits = 0,
    bool isRatio = true,
  }) {
    final loc = _resolveLocale(locale);
    final ratio = isRatio ? value.toDouble() : value.toDouble() / 100.0;
    try {
      final fmt = NumberFormat.percentPattern(loc);
      fmt.minimumFractionDigits = decimalDigits;
      fmt.maximumFractionDigits = decimalDigits;
      return fmt.format(ratio);
    } catch (_) {
      final pct = (ratio * 100).toStringAsFixed(decimalDigits);
      return '${formatDigits(pct, locale: loc)}%';
    }
  }

  // ===========================================================================
  // CURRENCY FORMATTING
  // ===========================================================================

  /// Formats a price or monetary value using [NumberFormat.currency].
  /// Default currency symbols and codes are derived automatically from [AppLanguages].
  static String formatCurrency(
    num amount, {
    String? locale,
    String? symbol,
    String? currencyCode,
    int? decimalDigits,
  }) {
    final loc = _resolveLocale(locale);
    final lang = AppLanguages.byCode(loc);
    final resolvedSymbol = symbol ?? lang?.currencySymbol ?? '\$';
    final resolvedCode = currencyCode ?? lang?.currencyCode ?? 'USD';

    try {
      final fmt = NumberFormat.currency(
        locale: loc,
        symbol: resolvedSymbol,
        name: resolvedCode,
        decimalDigits: decimalDigits,
      );
      return fmt.format(amount);
    } catch (_) {
      final dec = decimalDigits ?? 2;
      final numStr = formatNumber(amount, locale: loc, decimalDigits: dec);
      return loc == 'bn'
          ? '$numStr $resolvedSymbol'
          : '$resolvedSymbol$numStr';
    }
  }

  // ===========================================================================
  // DATE FORMATTING
  // ===========================================================================

  /// Formats a [DateTime] using standard [DateFormat] with full locale translation.
  static String formatDate(
    DateTime date, {
    String? locale,
    AppDateFormat format = AppDateFormat.medium,
    String? pattern,
  }) {
    final loc = _resolveLocale(locale);
    _ensureLocaleInitialized(loc);

    try {
      if (pattern != null) {
        return DateFormat(pattern, loc).format(date);
      }
      switch (format) {
        case AppDateFormat.short:
          return DateFormat.yMd(loc).format(date);
        case AppDateFormat.medium:
          return DateFormat.yMMMd(loc).format(date);
        case AppDateFormat.full:
          return DateFormat.yMMMMd(loc).format(date);
        case AppDateFormat.monthDay:
          return DateFormat.MMMMd(loc).format(date);
        case AppDateFormat.monthYear:
          return DateFormat.yMMMM(loc).format(date);
        case AppDateFormat.weekday:
          return DateFormat.EEEE(loc).format(date);
        case AppDateFormat.weekdayShort:
          return DateFormat.E(loc).format(date);
        case AppDateFormat.weekdayMonthDay:
          return DateFormat('EEE, MMM d', loc).format(date);
      }
    } catch (_) {
      final d = formatDigits(date.day.toString(), locale: loc);
      final m = formatDigits(date.month.toString(), locale: loc);
      final y = formatDigits(date.year.toString(), locale: loc);
      return '$d/$m/$y';
    }
  }

  // ===========================================================================
  // TIME FORMATTING
  // ===========================================================================

  /// Formats a time ([DateTime] or [TimeOfDay]) using [DateFormat].
  static String formatTime(
    dynamic time, {
    String? locale,
    bool use24Hour = false,
    bool includeSeconds = false,
  }) {
    if (time == null) return '--:--';
    final loc = _resolveLocale(locale);
    _ensureLocaleInitialized(loc);

    DateTime dt;
    if (time is DateTime) {
      dt = time;
    } else if (time is TimeOfDay) {
      final now = DateTime.now();
      dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    } else {
      return time.toString();
    }

    try {
      if (use24Hour) {
        return (includeSeconds ? DateFormat.Hms(loc) : DateFormat.Hm(loc))
            .format(dt);
      } else {
        return (includeSeconds ? DateFormat.jms(loc) : DateFormat.jm(loc))
            .format(dt);
      }
    } catch (_) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return formatDigits('$h:$m', locale: loc);
    }
  }

  /// Specific helper for 24h prayer time display (e.g. '05:15' / '০৫:১৫').
  static String formatPrayerTime(
    DateTime? time, {
    String? locale,
    bool use24Hour = true,
  }) {
    if (time == null) return '--:--';
    final loc = _resolveLocale(locale);
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return formatDigits('$h:$m', locale: loc);
  }

  // ===========================================================================
  // DURATION FORMATTING
  // ===========================================================================

  /// Formats a countdown or elapsed duration into localized human-readable text.
  /// E.g. '2h 15m' or '২ ঘণ্টা ১৫ মিনিট' or '2 ore 15 min'.
  static String formatDuration(
    Duration duration, {
    String? locale,
    bool compact = false,
  }) {
    final loc = _resolveLocale(locale);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    final hStr = formatNumber(hours, locale: loc);
    final mStr = formatNumber(minutes, locale: loc);

    if (compact) {
      if (hours > 0) {
        return '$hStr h $mStr m';
      }
      return '$mStr m';
    }

    final cat = staticTranslations[loc] ?? staticTranslations['en'] ?? {};
    final enCat = staticTranslations['en'] ?? {};
    final hourWord = hours == 1
        ? (cat['duration.hr'] ?? enCat['duration.hr'] ?? 'hr')
        : (cat['duration.hrs'] ?? enCat['duration.hrs'] ?? 'hrs');

    if (hours > 0 && minutes > 0) {
      final tpl = cat['duration.hours_minutes'] ?? enCat['duration.hours_minutes'] ?? '';
      return tpl
          .replaceAll('{hours}', hStr)
          .replaceAll('{hourWord}', hourWord)
          .replaceAll('{minutes}', mStr);
    } else if (hours > 0) {
      final tpl = cat['duration.hours'] ?? enCat['duration.hours'] ?? '';
      return tpl
          .replaceAll('{hours}', hStr)
          .replaceAll('{hourWord}', hourWord);
    } else {
      final tpl = cat['duration.minutes'] ?? enCat['duration.minutes'] ?? '';
      return tpl.replaceAll('{minutes}', mStr);
    }
  }

  // ===========================================================================
  // ISLAMIC / HIJRI CALENDAR LOCALIZATION
  // ===========================================================================

  /// Returns the localized Islamic / Hijri month name (1 to 12).
  static String getHijriMonthName(int month, {String? locale}) {
    final loc = _resolveLocale(locale);
    final key = 'hijri.month.$month';
    return staticTranslations[loc]?[key] ?? staticTranslations['en']?[key] ?? '';
  }

  /// Formats a complete Hijri date string according to locale.
  /// E.g. '১০ জিলহজ্ব ১৪৪৭ হিজরি' or '10 Dhul Hijjah 1447 AH'.
  static String formatHijriDate(
    int day,
    int month,
    int year, {
    String? locale,
  }) {
    final loc = _resolveLocale(locale);
    final dayStr = formatDigits(day.toString(), locale: loc);
    final yearStr = formatDigits(year.toString(), locale: loc);
    final monthName = getHijriMonthName(month, locale: loc);

    final cat = staticTranslations[loc] ?? staticTranslations['en'] ?? {};
    final enCat = staticTranslations['en'] ?? {};
    final tpl = cat['hijri.date_format'] ?? enCat['hijri.date_format'] ?? '';
    return tpl
        .replaceAll('{day}', dayStr)
        .replaceAll('{month}', monthName)
        .replaceAll('{year}', yearStr);
  }
}
