import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/l10n/app_localizations.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppFormatters.initialize();
  });

  group('Phase 4: Digit Systems & Conversions', () {
    test('formatDigits correctly localizes Latin to Bengali digits in bn', () {
      expect(AppFormatters.formatDigits('1234567890', locale: 'bn'), '১২৩৪৫৬৭৮৯০');
      expect(AppFormatters.formatDigits('Age 9 · saved', locale: 'bn'), 'Age ৯ · saved');
      expect(AppFormatters.formatDigits('Step 3: Lessons', locale: 'bn'), 'Step ৩: Lessons');
    });

    test('formatDigits normalizes Bengali digits back to Latin in en, hi, and it', () {
      expect(AppFormatters.formatDigits('১২৩৪৫৬৭৮৯০', locale: 'en'), '1234567890');
      expect(AppFormatters.formatDigits('১২৩৪৫৬৭৮৯০', locale: 'hi'), '1234567890');
      expect(AppFormatters.formatDigits('১২৩৪৫৬৭৮৯০', locale: 'it'), '1234567890');
    });

    test('toBengaliDigits converts any number or string to Bengali script', () {
      expect(AppFormatters.toBengaliDigits(42), '৪২');
      expect(AppFormatters.toBengaliDigits(3.14), '৩.১৪');
      expect(AppFormatters.toBengaliDigits('05:15'), '০৫:১৫');
    });

    test('toLatinDigits converts Bengali and Devanagari numerals to standard Latin', () {
      expect(AppFormatters.toLatinDigits('৪২'), '42');
      expect(AppFormatters.toLatinDigits('४२'), '42');
      expect(AppFormatters.toLatinDigits('০৫:১৫'), '05:15');
    });

    test('toDevanagariDigits converts Latin to Devanagari numerals', () {
      expect(AppFormatters.toDevanagariDigits(123), '१२३');
      expect(AppFormatters.toDevanagariDigits('456'), '४५६');
    });
  });

  group('Phase 4: Number & Percent Formatting with Intl', () {
    test('formatNumber outputs localized digits and grouping across locales', () {
      final number = 12345;
      final bnNumber = AppFormatters.formatNumber(number, locale: 'bn');
      final enNumber = AppFormatters.formatNumber(number, locale: 'en');
      final itNumber = AppFormatters.formatNumber(number, locale: 'it');
      final hiNumber = AppFormatters.formatNumber(number, locale: 'hi');

      expect(bnNumber, '১২,৩৪৫');
      expect(enNumber, '12,345');
      // Italian standard uses dot for thousand grouping
      expect(itNumber, '12.345');
      expect(hiNumber, '12,345');
    });

    test('formatNumber respects decimalDigits', () {
      expect(AppFormatters.formatNumber(4.5, locale: 'en', decimalDigits: 2), '4.50');
      expect(AppFormatters.formatNumber(4.5, locale: 'bn', decimalDigits: 2), '৪.৫০');
    });

    test('formatPercent produces localized percentage strings', () {
      expect(AppFormatters.formatPercent(0.85, locale: 'en'), '85%');
      expect(AppFormatters.formatPercent(0.85, locale: 'bn'), '৮৫%');
      expect(AppFormatters.formatPercent(0.755, locale: 'en', decimalDigits: 1), '75.5%');
    });
  });

  group('Phase 4: Currency Formatting with Intl', () {
    test('formatCurrency uses locale-bound currency symbols and formats', () {
      final bnPrice = AppFormatters.formatCurrency(499, locale: 'bn');
      final enPrice = AppFormatters.formatCurrency(4.99, locale: 'en');
      final hiPrice = AppFormatters.formatCurrency(499, locale: 'hi');
      final itPrice = AppFormatters.formatCurrency(4.99, locale: 'it');

      // Bengali Taka
      expect(bnPrice, contains('৳'));
      expect(bnPrice, contains('৪৯৯'));

      // US Dollar
      expect(enPrice, contains('\$'));
      expect(enPrice, contains('4.99'));

      // Indian Rupee
      expect(hiPrice, contains('₹'));
      expect(hiPrice, contains('499'));

      // Euro
      expect(itPrice, contains('€'));
      expect(itPrice, contains('4,99'));
    });

    test('formatCurrency accepts custom symbols or codes', () {
      final custom = AppFormatters.formatCurrency(
        100,
        locale: 'en',
        symbol: 'SAR ',
        decimalDigits: 0,
      );
      expect(custom, contains('SAR'));
      expect(custom, contains('100'));
    });
  });

  group('Phase 4: Date & Time Formatting with Intl', () {
    final fixedDate = DateTime(2026, 10, 21, 14, 30);

    test('formatDate translates month names dynamically per locale', () {
      final bnDate = AppFormatters.formatDate(fixedDate, locale: 'bn', format: AppDateFormat.full);
      final enDate = AppFormatters.formatDate(fixedDate, locale: 'en', format: AppDateFormat.full);
      final hiDate = AppFormatters.formatDate(fixedDate, locale: 'hi', format: AppDateFormat.full);
      final itDate = AppFormatters.formatDate(fixedDate, locale: 'it', format: AppDateFormat.full);

      // Bengali uses 'অক্টোবর' and Bengali numerals
      expect(bnDate, contains('অক্টোবর'));
      expect(bnDate, contains('২১'));
      expect(bnDate, contains('২০২৬'));

      // English uses 'October' and Latin numerals
      expect(enDate, contains('October'));
      expect(enDate, contains('21'));
      expect(enDate, contains('2026'));

      // Hindi uses 'अक्टूबर'
      expect(hiDate, contains('अक्टूबर'));
      expect(hiDate, contains('2026'));

      // Italian uses 'ottobre'
      expect(itDate, contains('ottobre'));
      expect(itDate, contains('2026'));
    });

    test('formatDate translates weekday names dynamically per locale', () {
      final bnDay = AppFormatters.formatDate(fixedDate, locale: 'bn', format: AppDateFormat.weekday);
      final enDay = AppFormatters.formatDate(fixedDate, locale: 'en', format: AppDateFormat.weekday);
      final hiDay = AppFormatters.formatDate(fixedDate, locale: 'hi', format: AppDateFormat.weekday);
      final itDay = AppFormatters.formatDate(fixedDate, locale: 'it', format: AppDateFormat.weekday);

      expect(bnDay, 'বুধবার');
      expect(enDay, 'Wednesday');
      expect(hiDay, 'बुधवार');
      expect(itDay.toLowerCase(), contains('mercoledì'));
    });

    test('formatTime handles 12h, 24h, and prayer time formatting', () {
      final time = TimeOfDay(hour: 14, minute: 30);

      // 24-hour format
      expect(AppFormatters.formatTime(time, locale: 'en', use24Hour: true), '14:30');
      expect(AppFormatters.formatTime(time, locale: 'bn', use24Hour: true), '১৪:৩০');

      // Prayer time chip 24h format
      expect(AppFormatters.formatPrayerTime(DateTime(2026, 1, 1, 5, 15), locale: 'en'), '05:15');
      expect(AppFormatters.formatPrayerTime(DateTime(2026, 1, 1, 5, 15), locale: 'bn'), '০৫:১৫');
      expect(AppFormatters.formatPrayerTime(null, locale: 'bn'), '--:--');
    });

    test('formatDuration formats elapsed/countdown time per locale', () {
      final duration = const Duration(hours: 2, minutes: 15);

      expect(AppFormatters.formatDuration(duration, locale: 'bn'), '২ ঘণ্টা ১৫ মিনিট');
      expect(AppFormatters.formatDuration(duration, locale: 'en'), '2 hrs 15 mins');
      expect(AppFormatters.formatDuration(duration, locale: 'hi'), '2 घंटे 15 मिनट');
      expect(AppFormatters.formatDuration(duration, locale: 'it'), '2 ore 15 min');
      expect(AppFormatters.formatDuration(duration, locale: 'en', compact: true), '2 h 15 m');
      expect(AppFormatters.formatDuration(duration, locale: 'bn', compact: true), '২ h ১৫ m');
    });
  });

  group('Phase 4: Islamic / Hijri Calendar Localization', () {
    test('getHijriMonthName returns localized names for all 12 months', () {
      for (var month = 1; month <= 12; month++) {
        final bn = AppFormatters.getHijriMonthName(month, locale: 'bn');
        final en = AppFormatters.getHijriMonthName(month, locale: 'en');
        final hi = AppFormatters.getHijriMonthName(month, locale: 'hi');
        final it = AppFormatters.getHijriMonthName(month, locale: 'it');

        expect(bn.isNotEmpty, isTrue, reason: 'Month $month in bn');
        expect(en.isNotEmpty, isTrue, reason: 'Month $month in en');
        expect(hi.isNotEmpty, isTrue, reason: 'Month $month in hi');
        expect(it.isNotEmpty, isTrue, reason: 'Month $month in it');
      }
    });

    test('formatHijriDate produces localized Hijri dates', () {
      expect(
        AppFormatters.formatHijriDate(10, 12, 1447, locale: 'bn'),
        '১০ জিলহজ্ব ১৪৪৭ হিজরি',
      );
      expect(
        AppFormatters.formatHijriDate(10, 12, 1447, locale: 'en'),
        '10 Dhul Hijjah 1447 AH',
      );
      expect(
        AppFormatters.formatHijriDate(10, 12, 1447, locale: 'hi'),
        '10 धुल हिज्जा 1447 हिजरी',
      );
      expect(
        AppFormatters.formatHijriDate(10, 12, 1447, locale: 'it'),
        '10 Dhul Hijjah 1447 E.',
      );
    });
  });

  group('Phase 4: BuildContext Localization & Formatter Extensions', () {
    testWidgets('LocalizedBuildContext extension provides seamless formatting', (tester) async {
      await tester.pumpWidget(MaterialApp(
        locale: const Locale('bn'),
        home: Builder(
          builder: (context) {
            final formattedDate = context.formatDate(DateTime(2026, 10, 21), format: AppDateFormat.medium);
            final formattedNum = context.formatNumber(500);
            final formattedCurr = context.formatCurrency(500);
            final formattedDigit = context.formatDigits('Page 4 of 10');

            return Column(
              children: [
                Text(formattedDate),
                Text(formattedNum),
                Text(formattedCurr),
                Text(formattedDigit),
              ],
            );
          },
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.textContaining('২১'), findsWidgets);
      expect(find.text('৫০০'), findsOneWidget);
      expect(find.textContaining('৳'), findsOneWidget);
      expect(find.text('Page ৪ of ১০'), findsOneWidget);
    });
  });

  group('Phase 4: Scalability & AppLanguage Registry Integration', () {
    test('All registered languages define valid intlLocale, currencyCode, and currencySymbol', () {
      for (final lang in AppLanguages.all) {
        expect(lang.effectiveIntlLocale.isNotEmpty, isTrue);
        expect(lang.currencyCode.isNotEmpty, isTrue);
        expect(lang.currencySymbol.isNotEmpty, isTrue);
      }
    });
  });
}
