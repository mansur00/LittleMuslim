import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/l10n/app_localizations.dart';
import 'package:little_muslim/screens/home/home_screen.dart';
import 'package:little_muslim/screens/profile/profile_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_chapters_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_lesson_screen.dart';
import 'package:little_muslim/screens/quran/quran_screen.dart';
import 'package:little_muslim/screens/quran/quran_reader_screen.dart';
import 'package:little_muslim/screens/quran/quran_data.dart';
import 'package:little_muslim/screens/settings/settings_screen.dart';
import 'package:little_muslim/theme/app_theme.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:little_muslim/widgets/ds/parental_gate_dialog.dart';

class _CaptureApp extends StatelessWidget {
  const _CaptureApp({
    required this.state,
    required this.boundaryKey,
    required this.child,
  });

  final AppState state;
  final GlobalKey boundaryKey;
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
            data: const MediaQueryData(
              size: Size(360, 780),
              textScaler: TextScaler.linear(1.0),
            ),
            child: Material(
              child: RepaintBoundary(
                key: boundaryKey,
                child: SizedBox(
                  width: 360,
                  height: 780,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Directory('docs/screenshots/audit').createSync(recursive: true);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), (call) async => 1);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('plugins.flutter.io/shared_preferences'), (call) async => null);

    for (final ch in [
      'xyz.luan/audioplayers.global',
      'xyz.luan/audioplayers.global/events',
      'xyz.luan/audioplayers',
      'xyz.luan/audioplayers/events',
    ]) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(MethodChannel(ch), (call) async => 1);
    }

    // Load available fonts
    final iconFile = File('/Users/mdmansur/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');
    if (iconFile.existsSync()) {
      final iconLoader = FontLoader('MaterialIcons');
      iconLoader.addFont(Future.value(ByteData.view(iconFile.readAsBytesSync().buffer)));
      await iconLoader.load();
    }

    final robotoFile = File('/Users/mdmansur/flutter/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf');
    if (robotoFile.existsSync()) {
      final robotoBytes = robotoFile.readAsBytesSync().buffer;
      final interLoader = FontLoader('Inter');
      interLoader.addFont(Future.value(ByteData.view(robotoBytes)));
      await interLoader.load();

      final rLoader = FontLoader('Roboto');
      rLoader.addFont(Future.value(ByteData.view(robotoBytes)));
      await rLoader.load();
    }

    final arialUnicodeFile = File('/System/Library/Fonts/Supplemental/Arial Unicode.ttf');
    if (arialUnicodeFile.existsSync()) {
      final arialBytes = arialUnicodeFile.readAsBytesSync().buffer;
      final bnLoader = FontLoader('Noto Sans Bengali');
      bnLoader.addFont(Future.value(ByteData.view(arialBytes)));
      await bnLoader.load();

      final hiLoader = FontLoader('Noto Sans Devanagari');
      hiLoader.addFont(Future.value(ByteData.view(arialBytes)));
      await hiLoader.load();
    }

    final amiriFile = File('assets/fonts/Amiri-Regular.ttf');
    if (amiriFile.existsSync()) {
      final amiriLoader = FontLoader('Amiri');
      amiriLoader.addFont(Future.value(ByteData.view(amiriFile.readAsBytesSync().buffer)));
      await amiriLoader.load();
    }

    const delegate = AppLocalizationsDelegate();
    await delegate.load(const Locale('en'));
    await delegate.load(const Locale('bn'));
    await delegate.load(const Locale('hi'));
    await delegate.load(const Locale('it'));

    await AlQuranCloudRepository.preloadBundledData();
  });

  const locales = ['en', 'hi', 'it'];

  for (final loc in locales) {
    testWidgets('Capture Home at 360px in $loc', (tester) async {
      final boundaryKey = GlobalKey();
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({
        'selected_language': loc,
        'user_name': 'Ahmad',
        'user_role': 'admin',
      });
      final state = AppState();
      await state.updateLanguage(loc);
      await state.setUserRole('admin', token: ParentalGate.mintForTesting());

      await tester.pumpWidget(
        _CaptureApp(state: state, boundaryKey: boundaryKey, child: const HomeScreen()),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump();

      await tester.runAsync(() async {
        final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary != null) {
          final image = await boundary.toImage(pixelRatio: 1.0);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            final file = File('docs/screenshots/audit/home_360_$loc.png');
            file.writeAsBytesSync(byteData.buffer.asUint8List());
          }
        }
      });
    });

    testWidgets('Capture Qaida Chapters at 360px in $loc', (tester) async {
      final boundaryKey = GlobalKey();
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({
        'selected_language': loc,
        'user_name': 'Ahmad',
      });
      final state = AppState();
      await state.updateLanguage(loc);

      await tester.pumpWidget(
        _CaptureApp(state: state, boundaryKey: boundaryKey, child: const QaidaChaptersScreen()),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump();

      await tester.runAsync(() async {
        final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary != null) {
          final image = await boundary.toImage(pixelRatio: 1.0);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            final file = File('docs/screenshots/audit/qaida_chapters_360_$loc.png');
            file.writeAsBytesSync(byteData.buffer.asUint8List());
          }
        }
      });
    });

    testWidgets('Capture Settings at 360px in $loc', (tester) async {
      final boundaryKey = GlobalKey();
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({
        'selected_language': loc,
        'user_name': 'Ahmad',
      });
      final state = AppState();
      await state.updateLanguage(loc);

      await tester.pumpWidget(
        _CaptureApp(state: state, boundaryKey: boundaryKey, child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump();

      await tester.runAsync(() async {
        final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary != null) {
          final image = await boundary.toImage(pixelRatio: 1.0);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            final file = File('docs/screenshots/audit/settings_360_$loc.png');
            file.writeAsBytesSync(byteData.buffer.asUint8List());
          }
        }
      });
    });

    testWidgets('Capture Quran Screen at 360px in $loc', (tester) async {
      final boundaryKey = GlobalKey();
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({
        'selected_language': loc,
        'user_name': 'Ahmad',
      });
      final state = AppState();
      await state.updateLanguage(loc);

      await tester.pumpWidget(
        _CaptureApp(state: state, boundaryKey: boundaryKey, child: const QuranScreen()),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump();

      await tester.runAsync(() async {
        final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary != null) {
          final image = await boundary.toImage(pixelRatio: 1.0);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            final file = File('docs/screenshots/audit/quran_360_$loc.png');
            file.writeAsBytesSync(byteData.buffer.asUint8List());
          }
        }
      });
    });

    testWidgets('Capture Qaida Lesson at 360px in $loc', (tester) async {
      final boundaryKey = GlobalKey();
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({'selected_language': loc});
      final state = AppState();
      await state.updateLanguage(loc);

      await tester.pumpWidget(
        _CaptureApp(
          state: state,
          boundaryKey: boundaryKey,
          child: const QaidaLessonScreen(
            lessonId: '1_1',
            lessonTitle: 'Alif',
            letter: 'ا',
            letterName: 'Alif',
            options: ['Alif', 'Baa', 'Taa'],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump();

      await tester.runAsync(() async {
        final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary != null) {
          final image = await boundary.toImage(pixelRatio: 1.0);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            final file = File('docs/screenshots/audit/qaida_lesson_360_$loc.png');
            file.writeAsBytesSync(byteData.buffer.asUint8List());
          }
        }
      });
    });

    testWidgets('Capture Quran Reader at 360px in $loc', (tester) async {
      final boundaryKey = GlobalKey();
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({'selected_language': loc});
      final state = AppState();
      await state.updateLanguage(loc);

      await tester.pumpWidget(
        _CaptureApp(state: state, boundaryKey: boundaryKey, child: const QuranReaderScreen()),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump();

      await tester.runAsync(() async {
        final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary != null) {
          final image = await boundary.toImage(pixelRatio: 1.0);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            final file = File('docs/screenshots/audit/quran_reader_360_$loc.png');
            file.writeAsBytesSync(byteData.buffer.asUint8List());
          }
        }
      });
    });

    testWidgets('Capture Profile at 360px in $loc', (tester) async {
      final boundaryKey = GlobalKey();
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({'selected_language': loc, 'user_name': 'Ahmad'});
      final state = AppState();
      await state.updateLanguage(loc);

      await tester.pumpWidget(
        _CaptureApp(state: state, boundaryKey: boundaryKey, child: const ProfileScreen()),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump();

      await tester.runAsync(() async {
        final boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary != null) {
          final image = await boundary.toImage(pixelRatio: 1.0);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            final file = File('docs/screenshots/audit/profile_360_$loc.png');
            file.writeAsBytesSync(byteData.buffer.asUint8List());
          }
        }
      });
    });
  }
}
