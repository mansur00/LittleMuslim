import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/l10n/app_localizations.dart';
import 'package:little_muslim/theme/app_theme.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:little_muslim/widgets/ds/app_top_bar.dart';

class _TestApp extends StatelessWidget {
  const _TestApp({
    required this.state,
    required this.scale,
    required this.child,
  });

  final AppState state;
  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: state,
      child: Consumer<AppState>(
        builder: (context, appState, _) => MaterialApp(
          locale: Locale(appState.selectedLanguage),
          supportedLocales: AppLanguages.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: MediaQueryData(
              size: MediaQuery.of(context).size,
              textScaler: TextScaler.linear(scale),
            ),
            child: Material(child: child),
          ),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const locales = ['en', 'bn', 'hi', 'it'];
  const widths = [320.0, 400.0];
  const textScales = [1.0, 1.3];
  const veryLongUserName = 'Muhammad Abdul Rahman Al-Mansooruddin Al-Ansari';

  setUpAll(() async {
    Directory('docs/screenshots').createSync(recursive: true);
    const delegate = AppLocalizationsDelegate();
    final enLoc = await delegate.load(const Locale('en'));
    final bnLoc = await delegate.load(const Locale('bn'));
    final hiLoc = await delegate.load(const Locale('hi'));
    final itLoc = await delegate.load(const Locale('it'));
    AppLocalizationsDelegate.cache('en', enLoc);
    AppLocalizationsDelegate.cache('bn', bnLoc);
    AppLocalizationsDelegate.cache('hi', hiLoc);
    AppLocalizationsDelegate.cache('it', itLoc);
  });

  for (final loc in locales) {
    for (final width in widths) {
      for (final scale in textScales) {
        testWidgets(
          'AppTopBar Shell & Page Variant Golden & Overflow test [$loc, ${width.toInt()}px, textScale: $scale]',
          (WidgetTester tester) async {
            // Strict overflow assertion: Any RenderFlex overflow MUST fail the test
            final previousOnError = FlutterError.onError;
            FlutterErrorDetails? caughtOverflow;

            FlutterError.onError = (FlutterErrorDetails details) {
              if (details.toString().contains('overflowed') ||
                  details.exceptionAsString().contains('RenderFlex overflowed')) {
                caughtOverflow = details;
              }
              previousOnError?.call(details);
            };

            tester.view.physicalSize = Size(width, 700);
            tester.view.devicePixelRatio = 1.0;
            addTearDown(() => tester.view.resetPhysicalSize());

            SharedPreferences.setMockInitialValues({
              'user_name': veryLongUserName,
              'language': loc,
              'xp': 4850,
              'streak_days': 125,
            });

            final state = AppState();
            await state.loadFromPrefs();
            await state.updateLanguage(loc);

            // 1. SHELL VARIANT
            final shellKey = GlobalKey();
            await tester.pumpWidget(
              _TestApp(
                state: state,
                scale: scale,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: RepaintBoundary(
                    key: shellKey,
                    child: const AppTopBar(showWordmark: true),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(
              caughtOverflow,
              isNull,
              reason: 'RenderFlex overflow occurred in AppTopBar shell variant at width $width, scale $scale in locale $loc',
            );

            // Capture screenshot for shell variant
            await tester.runAsync(() async {
              final boundary = shellKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
              if (boundary != null) {
                final image = await boundary.toImage(pixelRatio: 2.0);
                final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                if (byteData != null) {
                  final file = File('docs/screenshots/top_bar_shell_${loc}_w${width.toInt()}_s${(scale * 10).toInt()}.png');
                  file.writeAsBytesSync(byteData.buffer.asUint8List());
                }
              }
            });

            // 2. PAGE VARIANT
            final pageKey = GlobalKey();
            await tester.pumpWidget(
              _TestApp(
                state: state,
                scale: scale,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: RepaintBoundary(
                    key: pageKey,
                    child: AppTopBar.page(
                      title: loc == 'bn'
                          ? 'অধ্যায় ১৪: র এবং লাম এর তাফখীম ও তারকীক নিয়মাবলী'
                          : loc == 'hi'
                              ? 'अध्याय १४: रा और लाम के तफ़ख़ीम और तरक़ीक़ नियम'
                              : loc == 'it'
                                  ? 'Capitolo 14: Regole di pronuncia pesante e leggera di Ra e Lam'
                                  : 'Chapter 14: Rules of Heavy and Light Pronunciation of Ra and Lam',
                      subtitle: loc == 'bn'
                          ? 'বিশুদ্ধ তাজবীদ সহকারে হরফের উচ্চরণ অনুশীলন'
                          : loc == 'hi'
                              ? 'शुद्ध तजवीद के साथ अक्षरों का सही उच्चारण'
                              : loc == 'it'
                                  ? 'Esercizi di articolazione con perfetto Tajweed'
                                  : 'Mastering articulation points with pure Tajweed',
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(
              caughtOverflow,
              isNull,
              reason: 'RenderFlex overflow occurred in AppTopBar page variant at width $width, scale $scale in locale $loc',
            );

            // Capture screenshot for page variant
            await tester.runAsync(() async {
              final boundary = pageKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
              if (boundary != null) {
                final image = await boundary.toImage(pixelRatio: 2.0);
                final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                if (byteData != null) {
                  final file = File('docs/screenshots/top_bar_page_${loc}_w${width.toInt()}_s${(scale * 10).toInt()}.png');
                  file.writeAsBytesSync(byteData.buffer.asUint8List());
                }
              }
            });

            FlutterError.onError = previousOnError;
          },
        );
      }
    }
  }
}
