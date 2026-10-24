import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 6: Automated i18n Safeguards & Lint Checks', () {
    const locales = ['en', 'bn', 'hi', 'it'];

    test('All locales in locales/*.json share 100% key parity', () {
      final keysByLocale = <String, Set<String>>{};
      for (final loc in locales) {
        final file = File('locales/$loc.json');
        expect(file.existsSync(), isTrue, reason: 'locales/$loc.json must exist');
        final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        keysByLocale[loc] = data.keys.toSet();
      }

      final baseKeys = keysByLocale['en']!;
      for (final loc in locales) {
        if (loc == 'en') continue;
        final missing = baseKeys.difference(keysByLocale[loc]!);
        final extra = keysByLocale[loc]!.difference(baseKeys);
        expect(missing, isEmpty,
            reason: 'locales/$loc.json is missing keys present in en.json: $missing');
        expect(extra, isEmpty,
            reason: 'locales/$loc.json has extra keys not in en.json: $extra');
      }
    });

    test('All locales in assets/locales/*.json share 100% key parity', () {
      final keysByLocale = <String, Set<String>>{};
      for (final loc in locales) {
        final file = File('assets/locales/$loc.json');
        expect(file.existsSync(), isTrue,
            reason: 'assets/locales/$loc.json must exist');
        final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        keysByLocale[loc] = data.keys.toSet();
      }

      final baseKeys = keysByLocale['en']!;
      for (final loc in locales) {
        if (loc == 'en') continue;
        final missing = baseKeys.difference(keysByLocale[loc]!);
        expect(missing, isEmpty,
            reason: 'assets/locales/$loc.json is missing keys: $missing');
      }
    });

    test('All ARB files share 100% key parity and have @key metadata', () {
      final keysByLocale = <String, Set<String>>{};
      for (final loc in locales) {
        final file = File('assets/l10n/app_$loc.arb');
        expect(file.existsSync(), isTrue,
            reason: 'assets/l10n/app_$loc.arb must exist');
        final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        keysByLocale[loc] = data.keys
            .where((k) => !k.startsWith('@') && k != '@@locale')
            .toSet();

        // Ensure every key has metadata object with description
        for (final k in keysByLocale[loc]!) {
          final meta = data['@$k'];
          expect(meta, isNotNull, reason: 'app_$loc.arb missing metadata for @$k');
          expect(meta, isA<Map<String, dynamic>>(),
              reason: 'app_$loc.arb @$k metadata must be a map');
          final desc = (meta as Map<String, dynamic>)['description'];
          expect(desc, isNotNull,
              reason: 'app_$loc.arb @$k metadata must have description');
        }
      }

      final baseKeys = keysByLocale['en']!;
      for (final loc in locales) {
        if (loc == 'en') continue;
        final missing = baseKeys.difference(keysByLocale[loc]!);
        expect(missing, isEmpty,
            reason: 'assets/l10n/app_$loc.arb is missing keys: $missing');
      }
    });

    test('lib/l10n/static_translations.dart has all 4 locales and zero missing keys', () {
      final file = File('lib/l10n/static_translations.dart');
      expect(file.existsSync(), isTrue);
      final content = file.readAsStringSync();

      final keysByLocale = <String, Set<String>>{};
      for (final loc in locales) {
        final marker = '"$loc": {';
        final startIdx = content.indexOf(marker);
        expect(startIdx, isNot(-1),
            reason: 'staticTranslations must declare "$loc" map');
        final endIdx = content.indexOf('  },', startIdx);
        final block = content.substring(
            startIdx + marker.length,
            endIdx != -1 ? endIdx : content.indexOf('};', startIdx));
        final matches = RegExp(r'"([^"]+)":').allMatches(block);
        keysByLocale[loc] = matches.map((m) => m.group(1)!).toSet();
      }

      final baseKeys = keysByLocale['en']!;
      for (final loc in locales) {
        if (loc == 'en') continue;
        final missing = baseKeys.difference(keysByLocale[loc]!);
        expect(missing, isEmpty,
            reason: 'staticTranslations["$loc"] is missing keys: $missing');
      }
    });

    test('Zero hardcoded non-Latin script in UI screens and widgets', () {
      final banglaRegex = RegExp(r'[\u0980-\u09FF]');
      final hindiRegex = RegExp(r'[\u0900-\u097F]');

      const allowlist = [
        'Little Muslim',
        'Noorani Qaida',
        'Nurani Qaida',
        'Quran',
        'Bismillah',
        'Alhamdulillah',
        'Allah',
        'MashaAllah',
        'InshaAllah',
        'SubhanAllah',
        'বাংলা',
        'हिंदी',
        'Italiano',
        'English',
        'অ্যাডমিন (Admin)',
        'Admin',
        "const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯']"
      ];

      const exemptFiles = [
        'lib/l10n/',
        'lib/screens/duas/duas_screen.dart',
        'lib/screens/seerah/seerah_screen.dart',
        'lib/screens/prayer/prayer_screen.dart',
        'lib/screens/basics/islam_basics_screen.dart',
        'lib/services/notification_service.dart',
      ];

      final violations = <String>[];

      void scanDir(Directory dir) {
        if (!dir.existsSync()) return;
        for (final entity in dir.listSync(recursive: true)) {
          if (entity is! File || !entity.path.endsWith('.dart')) continue;
          final rel = entity.path.replaceAll('\\', '/');
          if (exemptFiles.any((ef) => rel.contains(ef))) continue;

          final lines = entity.readAsLinesSync();
          for (var i = 0; i < lines.length; i++) {
            final line = lines[i].trim();
            if (line.startsWith('//') ||
                line.startsWith('/*') ||
                line.startsWith('*')) {
              continue;
            }
            if (allowlist.any((a) => line.contains(a))) continue;

            if (banglaRegex.hasMatch(line) || hindiRegex.hasMatch(line)) {
              violations.add('$rel:${i + 1}: $line');
            }
          }
        }
      }

      scanDir(Directory('lib/screens'));
      scanDir(Directory('lib/widgets'));
      scanDir(Directory('lib/data'));
      scanDir(Directory('lib/models'));

      expect(violations, isEmpty,
          reason:
              'Found hardcoded non-Latin script in source files:\n${violations.join('\n')}');
    });
  });
}
