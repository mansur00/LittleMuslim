import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';
import 'app_languages.dart';
import 'html_helper.dart';

/// Global, reactive language provider managing active locale, persistence,
/// and web DOM <html lang> and dir synchronization.
///
/// Modifying the language here instantly triggers widget re-renders
/// without reloading the browser window or resetting user navigation.
class LanguageProvider extends ChangeNotifier {
  LanguageProvider({SharedPreferences? prefs}) {
    if (prefs != null) {
      _prefs = prefs;
      _loadFromPrefs();
    }
  }

  SharedPreferences? _prefs;
  String _currentCode = AppLanguages.defaultCode;
  bool _isLoaded = false;

  /// Current 2-letter ISO language code (e.g., 'bn', 'en', 'hi', 'it')
  String get currentCode => _currentCode;

  /// Flutter [Locale] representation of the active language
  Locale get currentLocale => Locale(_currentCode);

  /// Metadata descriptor of the active language
  AppLanguage get currentLanguage =>
      AppLanguages.byCode(_currentCode) ?? AppLanguages.fallback;

  /// Text direction of the current language (LTR or RTL)
  TextDirection get textDirection => currentLanguage.direction;

  /// Whether saved preferences have finished loading
  bool get isLoaded => _isLoaded;

  /// Asynchronously initialize provider and restore persisted selection
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    _loadFromPrefs();
  }

  void _loadFromPrefs() {
    final saved = _prefs?.getString(StorageKeys.language);
    if (saved != null && AppLanguages.isSupported(saved)) {
      _currentCode = AppLanguages.validate(saved);
    } else {
      _currentCode = AppLanguages.defaultCode;
    }
    _isLoaded = true;
    _syncDom();
    notifyListeners();
  }

  /// Change active language, persist to localStorage/SharedPreferences,
  /// update HTML document lang & dir attributes, and notify listeners to rebuild UI instantly.
  Future<void> setLanguage(String code) async {
    final validated = AppLanguages.validate(code);
    if (_currentCode == validated) return;

    _currentCode = validated;
    _syncDom();
    notifyListeners();

    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(StorageKeys.language, validated);
  }

  /// Synchronize web DOM attributes (<html lang> and <html dir>)
  void _syncDom() {
    setHtmlLangAndDir(currentLanguage.code, currentLanguage.dirString);
  }
}
