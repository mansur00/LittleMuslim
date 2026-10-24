import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../core/core.dart';
import '../utils/app_state.dart';
import 'static_translations.dart';

/// Central application localization system.
/// Uses standard Flutter ARB dictionaries with English as the canonical fallback.
class AppLocalizations {
  const AppLocalizations(this.locale, this.translations);

  final Locale locale;
  final Map<String, String> translations;

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  /// Resolves a namespaced key or source text with optional interpolation and pluralization.
  String translate(String source, {Map<String, dynamic>? params, int? count}) {
    if (source.isEmpty) return source;

    String? result;

    // 1. Pluralization resolution (e.g. key.zero, key.one, key.other)
    if (count != null) {
      if (count == 0 && translations.containsKey('$source.zero')) {
        result = translations['$source.zero'];
      } else if (count == 1 && translations.containsKey('$source.one')) {
        result = translations['$source.one'];
      } else if (translations.containsKey('$source.other')) {
        result = translations['$source.other'];
      }
    }

    // 2. Direct dictionary match (exact or trimmed)
    result ??= translations[source] ??
        translations[source.trim()] ??
        _translateTemplate(source);

    // 3. Fallback to raw source if no dictionary entry exists
    result ??= source;

    // 4. Interpolation: replace {{param}} and {param}
    final effectiveParams = <String, dynamic>{};
    if (params != null) effectiveParams.addAll(params);
    if (count != null && !effectiveParams.containsKey('count')) {
      effectiveParams['count'] = count;
    }

    if (effectiveParams.isNotEmpty) {
      effectiveParams.forEach((paramKey, paramVal) {
        final valStr = paramVal?.toString() ?? '';
        result = result!.replaceAll('{{$paramKey}}', valStr);
        result = result!.replaceAll('{$paramKey}', valStr);
      });
    }

    // 5. Digit localization according to target locale
    return AppFormatters.formatDigits(result!, locale: locale.languageCode);
  }

  /// Semantic namespaced translation shortcut (e.g. `tr('nav.home')`).
  String tr(String key, {Map<String, dynamic>? params, int? count}) =>
      translate(key, params: params, count: count);

  /// Pluralization translation shortcut (e.g. `plural('missions.streak_days', count)`).
  String plural(String key, int count, {Map<String, dynamic>? params}) =>
      translate(key, params: params, count: count);


  /// Parameterized regex templates that format numbers and dynamic slots across locales.
  String? _translateTemplate(String value) {
    // 1. Step {n} / ধাপ {n} / চরণ {n} / Passo {n}
    final stepMatch = RegExp(
      r'^(?:চলমান:\s*)?(?:স্টেপ|ধাপ|Step|Passo|चरण)\s+(\d+)(?::\s*(.*))?$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (stepMatch != null) {
      final isCurrent = value.trim().startsWith(RegExp(r'^(?:চলমান:|current:)', caseSensitive: false));
      final n = stepMatch.group(1)!;
      final rawTitle = stepMatch.group(2)?.trim();
      final translatedTitle =
          rawTitle != null && rawTitle.isNotEmpty ? translate(rawTitle) : null;

      final prefix = isCurrent ? translate('template.current_prefix') : '';
      final stepWord = translate('template.step_word');

      if (translatedTitle != null) {
        return '$prefix$stepWord $n: $translatedTitle';
      }
      return '$prefix$stepWord $n';
    }

    // 2. Lesson {n}/{total} / পাঠ {n}/{total} / Lezione {n}/{total}
    final lessonMatch = RegExp(
      r'^(?:পাঠ|Lesson|Lezione|पाठ)\s+(\d+)(?:/(\d+))?$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (lessonMatch != null) {
      final n = lessonMatch.group(1)!;
      final total = lessonMatch.group(2);
      final word = translate('template.lesson_word');
      return total != null ? '$word $n/$total' : '$word $n';
    }

    // 3. Age {n} / বয়স {n} / उम्र {n} / Età {n}
    final ageMatch = RegExp(
      r'^(?:বয়স|Age|উम्र|Età|उम्र)\s+(\d+)(?:\s*·\s*(.*))?$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (ageMatch != null) {
      final n = ageMatch.group(1)!;
      final rest = ageMatch.group(2)?.trim();
      final word = translate('template.age_word');
      if (rest != null && rest.isNotEmpty) {
        return '$word $n · ${translate(rest)}';
      }
      return '$word $n';
    }

    // 4. Question {a} / {b}
    final qMatch = RegExp(
      r'^(?:প্রশ্ন|Question|Domanda|प्रश्न)\s+(\d+)\s*/\s*(\d+)(.*)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (qMatch != null) {
      final a = qMatch.group(1)!;
      final b = qMatch.group(2)!;
      final rest = qMatch.group(3) ?? '';
      final word = translate('template.question_word');
      final passNote = rest.isNotEmpty ? translate('template.pass_mark_note') : '';
      return '$word $a / $b$passNote';
    }

    // 5. {n} Lessons / {n}টি পাঠ
    final nLessonsMatch = RegExp(
      r'^(\d+)(?:টি পাঠ| Lessons| lezioni| पाठ)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (nLessonsMatch != null) {
      final n = nLessonsMatch.group(1)!;
      return translate('template.n_lessons', params: {'n': n});
    }

    // 6. {n} Steps / {n}টি ধাপ
    final nStepsMatch = RegExp(
      r'^(\d+)(?:টি ধাপ| Steps| passaggi| चरण)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (nStepsMatch != null) {
      final n = nStepsMatch.group(1)!;
      return translate('template.n_steps', params: {'n': n});
    }

    // 7. Track {n} Exam Passed
    final trackExamMatch = RegExp(
      r'^(?:ট্র্যাক|Track)\s+(\d+)\s+(?:সমাপনী উত্তীর্ণ!|Exam Passed!)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (trackExamMatch != null) {
      final n = trackExamMatch.group(1)!;
      return translate('template.track_exam_passed', params: {'n': n});
    }

    // 8. Surah {s} · Ayah {a}
    final surahAyahMatch = RegExp(
      r'^(?:সূরা নম্বর|Surah|सूरा|Sura)\s+(\d+)\s*·\s*(?:আয়াত|Ayah|आयাত|Versetto)\s+(\d+)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (surahAyahMatch != null) {
      final s = surahAyahMatch.group(1)!;
      final a = surahAyahMatch.group(2)!;
      return translate('template.surah_ayah', params: {'s': s, 'a': a});
    }

    // 9. Learn {letter} / {letter} চিনি
    final learnLetterMatch = RegExp(
      r'^(?:Learn\s+(.+)|(.+?)\s*চিনি|सीखें\s+(.+)|Impara\s+(.+))$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (learnLetterMatch != null) {
      final rawLetter = learnLetterMatch.group(1) ??
          learnLetterMatch.group(2) ??
          learnLetterMatch.group(3) ??
          learnLetterMatch.group(4)!;
      final letter = translate(rawLetter.trim());
      return translate('template.learn_letter', params: {'letter': letter});
    }

    // 10. Listen for "{letter}" and choose the letter
    final listenLetterMatch = RegExp(
      r'^(?:Listen for [“"”](.+?)[“"”]|and choose the letter\.?)',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (listenLetterMatch != null) {
      final rawLetter =
          listenLetterMatch.group(1) ?? listenLetterMatch.group(2)!;
      final letter = translate(rawLetter.trim());
      return translate('template.listen_choose_letter', params: {'letter': letter});
    }

    // 11. Which letter is "{letter}"?
    final whichLetterMatch = RegExp(
      r'^(?:Which (?:one is the )?letter [“"”](.+?)[“"”]|হরফে বসবে)',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (whichLetterMatch != null) {
      final rawLetter =
          whichLetterMatch.group(1) ?? whichLetterMatch.group(2)!;
      final letter = translate(rawLetter.trim());
      return translate('template.which_letter', params: {'letter': letter});
    }

    // 12. Which dot piece belongs on the letter "{letter}"?
    final whichDotMatch = RegExp(
      r'^(?:Which dot piece belongs on the letter [“"”](.+?)[“"”]|কোন বিন্দুর টুকরোটি)',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (whichDotMatch != null) {
      final rawLetter = whichDotMatch.group(1) ?? whichDotMatch.group(2)!;
      final letter = translate(rawLetter.trim());
      return translate('template.which_dot', params: {'letter': letter});
    }

    // 13. Letter {name} / {name} হরফ
    final letterNameMatch = RegExp(
      r'^(?:Letter\s+(.+)|(.+?)\s+হরফ|अक्षर\s+(.+)|Lettera\s+(.+))$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (letterNameMatch != null) {
      final rawName = letterNameMatch.group(1) ??
          letterNameMatch.group(2) ??
          letterNameMatch.group(3) ??
          letterNameMatch.group(4)!;
      final name = translate(rawName.trim());
      return translate('template.letter_name', params: {'name': name});
    }

    // 14. Letter: {x} / হরফ: {x}
    final letterColonMatch = RegExp(
      r'^(?:Letter:\s*|হরফ:\s*|अक्षर:\s*|Lettera:\s*)(.*)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (letterColonMatch != null) {
      final rest = letterColonMatch.group(1)?.trim() ?? '';
      return translate('template.letter_colon', params: {'rest': rest});
    }

    // 15. Teacher: {name} / শিক্ষক: {name}
    final teacherMatch = RegExp(
      r'^(?:শিক্ষক:\s*|Teacher:\s*|शिक्षक:\s*|Insegnante:\s*)(.*)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (teacherMatch != null) {
      final teacher = teacherMatch.group(1)?.trim() ?? '';
      return translate('template.teacher', params: {'teacher': teacher});
    }

    return null;
  }
}

/// Standard LocalizationsDelegate for Flutter.
/// Loads ARBs dynamically and guarantees English as master fallback.
class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  static final Map<String, AppLocalizations> _cache = {};

  static void cache(String lang, AppLocalizations loc) {
    _cache[lang] = loc;
  }

  static void clearCache() => _cache.clear();

  @override
  bool isSupported(Locale locale) =>
      AppLanguages.isSupported(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    final lang = locale.languageCode;
    if (_cache.containsKey(lang)) {
      return SynchronousFuture<AppLocalizations>(_cache[lang]!);
    }
    return _loadInternal(locale);
  }

  Future<AppLocalizations> _loadInternal(Locale locale) async {
    final lang = locale.languageCode;
    final localeArbPath = AppLanguages.getArbPath(lang);

    // 1. Always load English (app_en.arb) as the canonical master fallback
    // 2. Always load Bangla (app_bn.arb) for bidirectional legacy key resolution
    // 3. Load active locale ARB (if not en or bn)
    final rawEn = await rootBundle.loadString('assets/l10n/app_en.arb');
    final rawBn = await rootBundle.loadString('assets/l10n/app_bn.arb');

    final decodedEn = jsonDecode(rawEn) as Map<String, dynamic>;
    final decodedBn = jsonDecode(rawBn) as Map<String, dynamic>;

    final Map<String, dynamic> decodedLocale;
    if (lang == 'en') {
      decodedLocale = decodedEn;
    } else if (lang == 'bn') {
      decodedLocale = decodedBn;
    } else {
      final rawLoc = await rootBundle.loadString(localeArbPath);
      decodedLocale = jsonDecode(rawLoc) as Map<String, dynamic>;
    }

    final translations = <String, String>{};

    void addMapping(String? source, String target) {
      if (source == null) return;
      final trimmed = source.trim();
      if (trimmed.isEmpty) return;
      translations[source] = target;
      if (trimmed != source) {
        translations[trimmed] = target;
      }
    }

    // Collect all ARB keys across the catalogs
    final allKeys = <String>{
      ...decodedEn.keys.where((k) => !k.startsWith('@') && k != '@@locale'),
      ...decodedBn.keys.where((k) => !k.startsWith('@') && k != '@@locale'),
      ...decodedLocale.keys.where((k) => !k.startsWith('@') && k != '@@locale'),
    };

    for (final k in allKeys) {
      final valEn = decodedEn[k] as String?;
      final valBn = decodedBn[k] as String?;
      final valLoc = decodedLocale[k] as String?;

      // STRICT FALLBACK RULE:
      // If active language is Bangla ('bn'): target is valBn ?? valEn ?? k
      // If active language is NOT Bangla: target is valLoc ?? valEn ?? k
      // Missing keys ALWAYS fall back to English, NEVER to Bangla!
      final String target;
      if (lang == 'bn') {
        target = (valBn != null && valBn.trim().isNotEmpty)
            ? valBn
            : (valEn ?? k);
      } else {
        target = (valLoc != null && valLoc.trim().isNotEmpty)
            ? valLoc
            : (valEn ?? k);
      }

      // Map ARB key -> target
      addMapping(k, target);

      // Map English string -> target
      if (valEn != null) {
        addMapping(valEn, target);
      }

      // Map Bangla string -> target (ensures legacy UI strings translate to target or fallback to English)
      if (valBn != null) {
        addMapping(valBn, target);
      }

      // Map native target string -> target
      if (valLoc != null) {
        addMapping(valLoc, target);
      }
    }

    // Also load JSON locale catalogs from assets/locales/ to support both ARB and JSON
    try {
      final jsonEnStr = await rootBundle.loadString('assets/locales/en.json');
      final jsonEn = jsonDecode(jsonEnStr) as Map<String, dynamic>;
      final jsonBnStr = await rootBundle.loadString('assets/locales/bn.json');
      final jsonBn = jsonDecode(jsonBnStr) as Map<String, dynamic>;

      Map<String, dynamic> jsonLoc = jsonEn;
      if (lang == 'bn') {
        jsonLoc = jsonBn;
      } else if (lang != 'en') {
        try {
          final jsonLocStr = await rootBundle.loadString('assets/locales/$lang.json');
          jsonLoc = jsonDecode(jsonLocStr) as Map<String, dynamic>;
        } catch (_) {}
      }

      final jsonKeys = <String>{...jsonEn.keys, ...jsonBn.keys, ...jsonLoc.keys};
      for (final k in jsonKeys) {
        final valEn = jsonEn[k] as String?;
        final valBn = jsonBn[k] as String?;
        final valLoc = jsonLoc[k] as String?;

        final String target;
        if (lang == 'bn') {
          target = (valBn != null && valBn.trim().isNotEmpty) ? valBn : (valEn ?? k);
        } else {
          target = (valLoc != null && valLoc.trim().isNotEmpty) ? valLoc : (valEn ?? k);
        }

        addMapping(k, target);
        if (valEn != null) addMapping(valEn, target);
        if (valBn != null) addMapping(valBn, target);
        if (valLoc != null) addMapping(valLoc, target);
      }
    } catch (_) {
      // Non-fatal if JSON files are not bundled in specific test runners
    }

    final result = AppLocalizations(Locale(lang), translations);
    _cache[lang] = result;
    return result;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}

extension LocalizedBuildContext on BuildContext {
  /// Standard translation helper with optional interpolation parameters and pluralization count.
  String tr(String key, {Map<String, dynamic>? params, int? count}) {
    final instance = AppLocalizations.of(this) ??
        AppLocalizationsDelegate._cache[currentLanguageCode] ??
        AppLocalizationsDelegate._cache['bn'] ??
        AppLocalizationsDelegate._cache['en'];
    if (instance != null) {
      return instance.translate(key, params: params, count: count);
    }
    final lang = currentLanguageCode;
    final fallbackVal = staticTranslations[lang]?[key] ??
        staticTranslations['bn']?[key] ??
        staticTranslations['en']?[key];
    if (fallbackVal != null) {
      String res = fallbackVal;
      if (params != null) {
        params.forEach((paramKey, paramVal) {
          final valStr = paramVal?.toString() ?? '';
          res = res.replaceAll('{{$paramKey}}', valStr).replaceAll('{$paramKey}', valStr);
        });
      }
      return res;
    }
    return key;
  }

  /// Short translation alias for t('key', params: ...).
  String t(String key, {Map<String, dynamic>? params, int? count}) =>
      tr(key, params: params, count: count);

  /// Pluralization translation shortcut.
  String plural(String key, int count, {Map<String, dynamic>? params}) =>
      AppLocalizations.of(this)?.plural(key, count, params: params) ?? key;

  /// Legacy UI text resolver preserving backward compatibility.
  String uiText(String source, {Map<String, dynamic>? params, int? count}) =>
      tr(source, params: params, count: count);

  String uiLocalizedText(String source, {Map<String, dynamic>? params, int? count}) =>
      uiText(source, params: params, count: count);

  /// Active locale language code (e.g. 'bn', 'en', 'hi', 'it').
  String get currentLanguageCode {
    final loc = AppLocalizations.of(this)?.locale.languageCode;
    if (loc != null) return loc;
    try {
      final state = read<AppState>();
      return state.selectedLanguage;
    } catch (_) {}
    return AppLanguages.defaultCode;
  }

  /// Formats a date using standard Intl.DateFormat for the current active locale.
  String formatDate(
    DateTime date, {
    AppDateFormat format = AppDateFormat.medium,
    String? pattern,
  }) =>
      AppFormatters.formatDate(
        date,
        locale: currentLanguageCode,
        format: format,
        pattern: pattern,
      );

  /// Formats a time (from DateTime or TimeOfDay) using standard Intl.DateFormat.
  String formatTime(
    dynamic time, {
    bool use24Hour = false,
    bool includeSeconds = false,
  }) =>
      AppFormatters.formatTime(
        time,
        locale: currentLanguageCode,
        use24Hour: use24Hour,
        includeSeconds: includeSeconds,
      );

  /// Formats a number using standard Intl.NumberFormat according to the current locale.
  String formatNumber(
    num number, {
    int? decimalDigits,
    bool compact = false,
  }) =>
      AppFormatters.formatNumber(
        number,
        locale: currentLanguageCode,
        decimalDigits: decimalDigits,
        compact: compact,
      );

  /// Formats a monetary amount / currency string using standard Intl.NumberFormat.
  String formatCurrency(
    num amount, {
    String? symbol,
    String? currencyCode,
    int? decimalDigits,
  }) =>
      AppFormatters.formatCurrency(
        amount,
        locale: currentLanguageCode,
        symbol: symbol,
        currencyCode: currencyCode,
        decimalDigits: decimalDigits,
      );

  /// Formats a percentage using standard Intl.NumberFormat.
  String formatPercent(
    num value, {
    int decimalDigits = 0,
    bool isRatio = true,
  }) =>
      AppFormatters.formatPercent(
        value,
        locale: currentLanguageCode,
        decimalDigits: decimalDigits,
        isRatio: isRatio,
      );

  /// Formats digits in any string according to the current locale.
  String formatDigits(String input) =>
      AppFormatters.formatDigits(input, locale: currentLanguageCode);

  /// Formats a duration into localized readable text (e.g. '২ ঘণ্টা ১৫ মিনিট' / '2 hrs 15 mins').
  String formatDuration(Duration duration, {bool compact = false}) =>
      AppFormatters.formatDuration(
        duration,
        locale: currentLanguageCode,
        compact: compact,
      );

  /// Formats a Hijri date with localized Islamic month and numerals.
  String formatHijriDate(int day, int month, int year) =>
      AppFormatters.formatHijriDate(
        day,
        month,
        year,
        locale: currentLanguageCode,
      );
}

/// A drop-in Text widget that resolves its source text from the active locale,
/// supporting both namespaced keys (e.g. `nav.home`) and dynamic parameter interpolation.
class LocalizedText extends StatelessWidget {
  const LocalizedText(
    this.data, {
    super.key,
    this.params,
    this.count,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  final String data;
  final Map<String, dynamic>? params;
  final int? count;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) => Text(
        context.tr(data, params: params, count: count),
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
}

