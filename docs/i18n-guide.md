# Internationalization (i18n) & Localization Guide

This guide describes the localization architecture of the **Little Muslim** app, how to add new strings, how to add support for new languages, and how to verify zero hardcoded strings using the automated safeguards.

---

## 1. Core Rule & Principles

> [!IMPORTANT]
> **Never hardcode user-facing text.** Always use `context.t('key')` or `t('key')` and add the key to **ALL** locale files (`en`, `bn`, `hi`, `it`).

1. **Zero Raw Literals**: All user-facing strings in UI widgets and screens must be retrieved via `context.t('key', params: {...})` or `context.tr('key')`.
2. **Strict 4-Locale Parity**: Whenever a new string key is created, translations **must** be provided for all 4 supported languages:
   - English (`en`) — canonical source & default fallback
   - Bangla (`bn`) — primary user base
   - Hindi (`hi`) — regional expansion
   - Italian (`it`) — diaspora expansion
3. **No Unidirectional Fallbacks**: Non-Bangla locales fall back to English if a key is missing; never to Bangla.
4. **Digit Localization**: Numbers in strings (e.g., `'1 / 4'`, `'+10 XP'`, `'Age 9'`) are automatically formatted according to the active locale numeral system via `AppFormatters.formatDigits`.

---

## 2. Translation File Locations

The translation catalogs are synchronized across four synchronized files:

| Catalog File | Format | Purpose |
|---|---|---|
| `locales/{en,bn,hi,it}.json` | Nested/Flat JSON | Source developer locale dictionary |
| `assets/locales/{en,bn,hi,it}.json` | Nested/Flat JSON | Bundled app asset dictionary |
| `assets/l10n/app_{en,bn,hi,it}.arb` | ARB with `@key` | Flutter official ARB localization catalog with descriptions |
| `lib/l10n/static_translations.dart` | Dart `const Map` | Zero-latency synchronous runtime translation fallback |

---

## 3. How to Add a New String

Follow these steps when adding user-facing text:

### Step 1: Choose a Hierarchical Key Name
Use a dot-separated, lower_snake_case key scoped to the feature:
```text
profile.save_button
prayer.adhan_reminder_title
report.accuracy_rate
```

### Step 2: Add Translations to All Catalogs

#### In `locales/en.json`, `assets/locales/en.json`:
```json
"profile.save_button": "Save Changes"
```

#### In `locales/bn.json`, `assets/locales/bn.json`:
```json
"profile.save_button": "পরিবর্তন সংরক্ষণ করুন"
```

#### In `locales/hi.json`, `assets/locales/hi.json`:
```json
"profile.save_button": "बदलाव सहेजें"
```

#### In `locales/it.json`, `assets/locales/it.json`:
```json
"profile.save_button": "Salva modifiche"
```

#### In ARB files (`assets/l10n/app_{en,bn,hi,it}.arb`):
Add the key and its corresponding `@key` metadata object:
```json
"profile.save_button": "Save Changes",
"@profile.save_button": {
  "description": "Button to save profile changes (profile.save_button)"
}
```

#### In `lib/l10n/static_translations.dart`:
Add the entry into all 4 maps (`_en`, `_bn`, `_hi`, `_it`).

> [!TIP]
> You can add entries to `locales/*.json` and run `python3 tools/sync_keys.py` to automatically synchronize ARBs and `static_translations.dart`.

### Step 3: Reference the Key in Dart Code
```dart
// Simple text
Text(context.t('profile.save_button'))

// Interpolated text with parameters
Text(context.t('report.learner_age_desc', params: {'age': 8}))

// Inside widget properties
DuolingoPageHeader(
  title: context.t('profile.title'),
  subtitle: context.t('profile.subtitle'),
)
```

---

## 4. How to Add a New Language

To introduce a new language (e.g. `ar` for Arabic or `ur` for Urdu):

1. **Register the Language Definition**:
   In `lib/l10n/app_localizations.dart`, add the language code to `AppLanguages.supportedLanguages`:
   ```dart
   AppLanguage(
     code: 'ar',
     englishName: 'Arabic',
     nativeName: 'العربية',
     direction: TextDirection.rtl,
   ),
   ```
2. **Create Translation Catalogs**:
   - `locales/ar.json`
   - `assets/locales/ar.json`
   - `assets/l10n/app_ar.arb` (with `@@locale: "ar"`)
3. **Register Static Map**:
   In `lib/l10n/static_translations.dart`, add the `"ar": { ... }` map.
4. **Register Asset in `pubspec.yaml`**:
   Ensure `assets/locales/` and `assets/l10n/` are listed under `flutter.assets`.
5. **Update Supported Locales in `lib/main.dart`**:
   Add `const Locale('ar')` to `supportedLocales`.
6. **Run Safeguards**:
   ```bash
   npm run i18n:check
   flutter test
   ```

---

## 5. Automated Safeguards & CI Enforcement

The project includes strict automated guards to prevent mixed-language regressions:

### 1. NPM / Node Linter
Run anytime before committing or in CI:
```bash
npm run i18n:check
```
Checks:
- **Parity**: Fails if any locale is missing any key present in another.
- **Duplicates**: Fails if any catalog has duplicate keys.
- **Hardcoded Text**: Fails if non-allowlisted Bangla or Hindi characters appear in `lib/screens/` or `lib/widgets/`.

### 2. Flutter Test Suite
The safeguards run automatically as part of `flutter test`:
```bash
flutter test test/phase6_i18n_safeguards_test.dart
```

### 3. Build & Lint Pipeline
```bash
npm run lint
```
Executes `flutter analyze` followed by `node tools/i18n_check.js`.
