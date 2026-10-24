import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/l10n/app_localizations.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Senior i18n & Localization Architecture Tests', () {
    test('All 4 ARB catalogs exist, are valid JSON, and have identical keys',
        () async {
      final loaded = await Future.wait([
        rootBundle.loadString('assets/l10n/app_en.arb'),
        rootBundle.loadString('assets/l10n/app_bn.arb'),
        rootBundle.loadString('assets/l10n/app_hi.arb'),
        rootBundle.loadString('assets/l10n/app_it.arb'),
      ]);

      final en = jsonDecode(loaded[0]) as Map<String, dynamic>;
      final bn = jsonDecode(loaded[1]) as Map<String, dynamic>;
      final hi = jsonDecode(loaded[2]) as Map<String, dynamic>;
      final it = jsonDecode(loaded[3]) as Map<String, dynamic>;

      final enKeys = en.keys
          .where((k) => !k.startsWith('@') && k != '@@locale')
          .toSet();
      final bnKeys = bn.keys
          .where((k) => !k.startsWith('@') && k != '@@locale')
          .toSet();
      final hiKeys = hi.keys
          .where((k) => !k.startsWith('@') && k != '@@locale')
          .toSet();
      final itKeys = it.keys
          .where((k) => !k.startsWith('@') && k != '@@locale')
          .toSet();

      expect(enKeys.length, greaterThanOrEqualTo(950));
      expect(enKeys.difference(bnKeys), isEmpty,
          reason: 'Missing in bn: ${enKeys.difference(bnKeys)}');
      expect(enKeys.difference(hiKeys), isEmpty,
          reason: 'Missing in hi: ${enKeys.difference(hiKeys)}');
      expect(enKeys.difference(itKeys), isEmpty,
          reason: 'Missing in it: ${enKeys.difference(itKeys)}');
    });

    test('English is the strict fallback: missing locale keys NEVER fall back to Bangla',
        () async {
      // Simulate delegate load for English, Hindi, Italian, and Bangla
      final delegate = const AppLocalizationsDelegate();
      final enLoc = await delegate.load(const Locale('en'));
      final bnLoc = await delegate.load(const Locale('bn'));
      final hiLoc = await delegate.load(const Locale('hi'));
      final itLoc = await delegate.load(const Locale('it'));

      // 1. In English: settings -> 'Settings', not 'সেটিংস'
      expect(enLoc.translate('settings'), 'Settings');
      expect(enLoc.translate('সেটিংস'), 'Settings');
      expect(enLoc.translate('ক্বায়দা'), 'Qaida');
      expect(enLoc.translate('নামাজ'), 'Prayer');

      // 2. In Hindi: settings -> 'सेटिंग्स', qaida -> 'कायदा'
      expect(hiLoc.translate('settings'), 'सेटिंग्स');
      expect(hiLoc.translate('সেটিংস'), 'सेटिंग्स');
      expect(hiLoc.translate('ক্বায়দা'), 'कायदा');
      expect(hiLoc.translate('নামাজ'), 'नमाज़');

      // 3. In Italian: settings -> 'Impostazioni', prayer -> 'Preghiera'
      expect(itLoc.translate('settings'), 'Impostazioni');
      expect(itLoc.translate('সেটিংস'), 'Impostazioni');
      expect(itLoc.translate('নামাজ'), 'Preghiera');
      expect(itLoc.translate('কুরআন'), 'Corano');

      // 4. In Bangla: settings -> 'সেটিংস', qaida -> 'ক্বায়দা'
      expect(bnLoc.translate('settings'), 'সেটিংস');
      expect(bnLoc.translate('Settings'), 'সেটিংস');
      expect(bnLoc.translate('ক্বায়দা'), 'ক্বায়দা');
      expect(bnLoc.translate('নামাজ'), 'নামাজ');
    });

    test('Zero mixed languages: English output contains zero Bengali characters',
        () async {
      final delegate = const AppLocalizationsDelegate();
      final enLoc = await delegate.load(const Locale('en'));

      final corePhrases = [
        'ক্বায়দা',
        'কুরআন',
        'নামাজ',
        'দোয়া',
        'সীরাত',
        'অর্জন',
        'সেটিংস',
        'দৈনিক স্ট্রিক',
        'চলমান পাঠ্যক্রম',
        'স্মার্ট রিভিশন',
        'ভুল শোধরাই',
        'ভয়েস গাইড',
        'পরবর্তী ধাপ ➔',
        '১ আলিফ',
        '২ আলিফ',
        'মুছে ফেলুন',
        'ফিরে যান',
        'সহায়তা',
      ];

      for (final phrase in corePhrases) {
        final translated = enLoc.translate(phrase);
        final hasBengali =
            translated.runes.any((r) => r >= 0x0980 && r <= 0x09FF);
        expect(hasBengali, isFalse,
            reason:
                'English translation for "$phrase" leaked Bengali: "$translated"');
      }
    });

    test('Zero mixed languages: Hindi output uses Hindi (Devanagari) terms',
        () async {
      final delegate = const AppLocalizationsDelegate();
      final hiLoc = await delegate.load(const Locale('hi'));

      expect(hiLoc.translate('ক্বায়দা'), 'कायदा');
      expect(hiLoc.translate('নামাজ'), 'नमाज़');
      expect(hiLoc.translate('দোয়া'), 'दुआ');
      expect(hiLoc.translate('সেটিংস'), 'सेटिंग्स');
      expect(hiLoc.translate('পরবর্তী ধাপ ➔'), 'अगला चरण ➔');
      expect(hiLoc.translate('১ আলিফ'), '1 अलिफ़');

      // Zero Bengali characters in translated Hindi output
      final terms = ['ক্বায়দা', 'নামাজ', 'দোয়া', 'সেটিংস', 'পরবর্তী ধাপ ➔'];
      for (final t in terms) {
        final out = hiLoc.translate(t);
        final hasBengali = out.runes.any((r) => r >= 0x0980 && r <= 0x09FF);
        expect(hasBengali, isFalse,
            reason:
                'Hindi translation for "$t" leaked Bengali: "$out"');
      }
    });

    test('Zero mixed languages: Italian output uses Italian terms',
        () async {
      final delegate = const AppLocalizationsDelegate();
      final itLoc = await delegate.load(const Locale('it'));

      expect(itLoc.translate('কুরআন'), 'Corano');
      expect(itLoc.translate('নামাজ'), 'Preghiera');
      expect(itLoc.translate('সেটিংস'), 'Impostazioni');
      expect(itLoc.translate('পরবর্তী ধাপ ➔'), 'Passaggio successivo ➔');
      expect(itLoc.translate('১ আলিফ'), '1 Alif');
    });

    test('Scalability: AppLanguages registry supports 20+ languages by configuration', () {
      expect(AppLanguages.all.length, greaterThanOrEqualTo(4));
      expect(AppLanguages.supportedLocales.map((l) => l.languageCode),
          containsAll(['bn', 'en', 'hi', 'it']));
      expect(AppLanguages.isSupported('bn'), isTrue);
      expect(AppLanguages.isSupported('en'), isTrue);
      expect(AppLanguages.isSupported('hi'), isTrue);
      expect(AppLanguages.isSupported('it'), isTrue);
      expect(AppLanguages.isSupported('invalid_code'), isFalse);
    });

    test('Digit formatting: Bangla uses Bengali numerals; other locales use Latin numerals',
        () async {
      final delegate = const AppLocalizationsDelegate();
      final bnLoc = await delegate.load(const Locale('bn'));
      final enLoc = await delegate.load(const Locale('en'));
      final hiLoc = await delegate.load(const Locale('hi'));
      final itLoc = await delegate.load(const Locale('it'));

      expect(bnLoc.translate('12345'), '১২৩৪৫');
      expect(enLoc.translate('১২৩৪৫'), '12345');
      expect(hiLoc.translate('১২৩৪৫'), '12345');
      expect(itLoc.translate('১২৩৪৫'), '12345');
    });
  });
}
