import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('Phase 3: Fonts and Direction Architecture Tests', () {
    test('Font family resolution maps correctly per language', () {
      expect(AppFonts.fontFamilyFor('bn'), 'Noto Sans Bengali');
      expect(AppFonts.fontFamilyFor('hi'), 'Noto Sans Devanagari');
      expect(AppFonts.fontFamilyFor('en'), 'Inter');
      expect(AppFonts.fontFamilyFor('it'), 'Inter');
      expect(AppFonts.fontFamilyFor('ar'), 'Noto Naskh Arabic');
      expect(AppFonts.fontFamilyFor('ur'), 'Noto Naskh Arabic');
    });

    test('Universal font fallbacks contain all required script families', () {
      final fallbacks = AppFonts.globalFallbacks;

      expect(fallbacks, contains('Noto Sans Bengali'));
      expect(fallbacks, contains('Hind Siliguri'));
      expect(fallbacks, contains('Noto Sans Devanagari'));
      expect(fallbacks, contains('Noto Naskh Arabic'));
      expect(fallbacks, contains('Amiri'));
      expect(fallbacks, contains('Inter'));
      expect(fallbacks, contains('Roboto'));
    });

    test('getTextStyleForLang attaches global glyph fallbacks so no glyph shows as a box', () {
      for (final code in ['bn', 'en', 'hi', 'it', 'ar', 'ur']) {
        final style = AppFonts.getTextStyleForLang(code, fontSize: 16);
        expect(style.fontFamilyFallback, isNotNull);
        expect(style.fontFamilyFallback, contains('Noto Sans Bengali'));
        expect(style.fontFamilyFallback, contains('Noto Sans Devanagari'));
        expect(style.fontFamilyFallback, contains('Amiri'));
      }
    });

    test('AppTheme generates TextTheme dynamically per language with glyph fallbacks', () {
      final bnTheme = AppTheme.getThemeForLanguage('bn');
      expect(bnTheme.textTheme.bodyMedium?.fontFamilyFallback, contains('Noto Sans Bengali'));

      final hiTheme = AppTheme.getThemeForLanguage('hi');
      expect(hiTheme.textTheme.bodyMedium?.fontFamilyFallback, contains('Noto Sans Devanagari'));

      final enTheme = AppTheme.getThemeForLanguage('en');
      expect(enTheme.textTheme.bodyMedium?.fontFamilyFallback, contains('Inter'));

      final itTheme = AppTheme.getThemeForLanguage('it');
      expect(itTheme.textTheme.bodyMedium?.fontFamilyFallback, contains('Inter'));
    });

    test('RTL support: AppLanguage defines direction and HTML dir string', () {
      final bnLang = AppLanguages.byCode('bn')!;
      expect(bnLang.direction, TextDirection.ltr);
      expect(bnLang.dirString, 'ltr');
      expect(bnLang.isRtl, isFalse);

      final enLang = AppLanguages.byCode('en')!;
      expect(enLang.direction, TextDirection.ltr);
      expect(enLang.dirString, 'ltr');
      expect(enLang.isRtl, isFalse);

      const arabicFuture = AppLanguage(
        code: 'ar',
        name: 'العربية',
        nativeName: 'العربية',
        englishName: 'Arabic',
        direction: TextDirection.rtl,
        arbPath: 'assets/l10n/app_ar.arb',
        jsonPath: 'assets/locales/ar.json',
      );
      expect(arabicFuture.direction, TextDirection.rtl);
      expect(arabicFuture.dirString, 'rtl');
      expect(arabicFuture.isRtl, isTrue);
    });

    test('arabicTextStyle uses Amiri font family with universal glyph fallbacks', () {
      final arabicStyle = AppTheme.arabicTextStyle(fontSize: 24);
      expect(arabicStyle.fontFamily, 'Amiri');
      expect(arabicStyle.fontFamilyFallback, contains('Noto Sans Bengali'));
      expect(arabicStyle.fontFamilyFallback, contains('Noto Sans Devanagari'));
    });
  });
}
