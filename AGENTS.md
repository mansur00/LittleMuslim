# Project Agent Rules

Never hardcode user-facing text. Always use t('key') and add the key to ALL locale files.

---

## 1. Internationalization (i18n) Rules
- **Zero hardcoded text**: Never write raw strings in UI widgets (e.g. `Text('Hello')`, `title: 'Welcome'`).
- **Use `context.t('key')`**: Always lookup translations using `context.t('feature.key', params: {...})`.
- **4-Locale Parity**: Whenever you add a new string key, you **must** add it to:
  1. `locales/{en,bn,hi,it}.json`
  2. `assets/locales/{en,bn,hi,it}.json`
  3. `assets/l10n/app_{en,bn,hi,it}.arb` (with `@key` metadata description)
  4. `lib/l10n/static_translations.dart` (all 4 maps)
- **Validation**: Always run `npm run i18n:check` and `flutter test test/phase6_i18n_safeguards_test.dart` to verify 100% test pass rate and key parity.
- Refer to [docs/i18n-guide.md](docs/i18n-guide.md) for detailed guidelines.
