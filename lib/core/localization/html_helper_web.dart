// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Sets the <html lang="..."> and <html dir="..."> attributes dynamically in the DOM on Flutter Web.
void setHtmlLangAndDir(String lang, String dir) {
  try {
    final root = html.document.documentElement;
    if (root != null) {
      root.setAttribute('lang', lang);
      root.setAttribute('dir', dir);
    }
  } catch (_) {
    // Graceful fallback if DOM is unavailable
  }
}
