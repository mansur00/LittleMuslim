import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  const AppLocalizations(this.locale, this.translations);

  final Locale locale;
  final Map<String, String> translations;

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  String translate(String source) {
    var value = translations[source] ?? _translateTemplate(source) ?? source;
    const banglaDigits = '০১২৩৪৫৬৭৮৯';
    const englishDigits = '0123456789';
    if (locale.languageCode == 'en') {
      for (var i = 0; i < banglaDigits.length; i++) {
        value = value.replaceAll(banglaDigits[i], englishDigits[i]);
      }
    } else {
      for (var i = 0; i < englishDigits.length; i++) {
        value = value.replaceAll(englishDigits[i], banglaDigits[i]);
      }
    }
    return value;
  }

  String? _translateTemplate(String value) {
    for (final entry in translations.entries) {
      final placeholders =
          RegExp(r'\{([^}]+)\}').allMatches(entry.key).toList(growable: false);
      if (placeholders.isEmpty) continue;
      final pattern = StringBuffer('^');
      var offset = 0;
      for (final placeholder in placeholders) {
        pattern.write(
            RegExp.escape(entry.key.substring(offset, placeholder.start)));
        pattern.write('(.*?)');
        offset = placeholder.end;
      }
      pattern
        ..write(RegExp.escape(entry.key.substring(offset)))
        ..write(r'$');
      final match = RegExp(pattern.toString()).firstMatch(value);
      if (match == null) continue;
      var translated = entry.value;
      for (var i = 0; i < placeholders.length; i++) {
        translated = translated.replaceAll(
            '{${placeholders[i].group(1)}}', match.group(i + 1) ?? '');
      }
      return translated;
    }
    return null;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'bn' || locale.languageCode == 'en';

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final language = locale.languageCode == 'en' ? 'en' : 'bn';
    final raw = await rootBundle.loadString('assets/l10n/app_$language.arb');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final translations = <String, String>{};
    for (final entry in decoded.entries) {
      if (entry.key.startsWith('@') || entry.value is! String) continue;
      final metadata = decoded['@${entry.key}'];
      final source =
          metadata is Map<String, dynamic> ? metadata['description'] : null;
      if (source is String && source.isNotEmpty) {
        translations[source] = entry.value as String;
      }
    }
    return AppLocalizations(Locale(language), translations);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

extension LocalizedBuildContext on BuildContext {
  String uiText(String source) =>
      AppLocalizations.of(this)?.translate(source) ?? source;
}

/// A drop-in Text widget that resolves its source text from the active locale.
class LocalizedText extends StatelessWidget {
  const LocalizedText(
    this.data, {
    super.key,
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
        AppLocalizations.of(context)?.translate(data) ?? data,
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
