import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/l10n/app_localizations.dart';
import 'package:little_muslim/screens/home/home_screen.dart';
import 'package:little_muslim/screens/settings/settings_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_chapters_screen.dart';
import 'package:little_muslim/screens/quran/quran_screen.dart';
import 'package:little_muslim/screens/quran/quran_data.dart';
import 'package:little_muslim/theme/app_theme.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:little_muslim/widgets/ds/parental_gate_dialog.dart';

class _ScalingTestApp extends StatelessWidget {
  const _ScalingTestApp({
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

  setUpAll(() async {
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

    const delegate = AppLocalizationsDelegate();
    await delegate.load(const Locale('en'));
    await delegate.load(const Locale('bn'));
    await delegate.load(const Locale('hi'));
    await delegate.load(const Locale('it'));

    await AlQuranCloudRepository.preloadBundledData();
  });

  group('Text Scaling & Overflow Audit (en, it @ 1.0, 1.5, 2.0)', () {
    const screens = ['Home', 'Settings', 'QaidaChapters', 'QuranScreen'];
    const locales = ['en', 'it'];
    const scales = [1.0, 1.5, 2.0];

    for (final screenName in screens) {
      for (final loc in locales) {
        for (final scale in scales) {
          testWidgets('$screenName in $loc @ textScale $scale', (tester) async {
            final overflows = <FlutterErrorDetails>[];
            final prevOnError = FlutterError.onError;
            FlutterError.onError = (details) {
              if (details.toString().contains('overflowed') || details.exceptionAsString().contains('RenderFlex overflowed')) {
                overflows.add(details);
              }
              prevOnError?.call(details);
            };

            tester.view.physicalSize = const Size(360, 800);
            tester.view.devicePixelRatio = 1.0;
            addTearDown(() => tester.view.resetPhysicalSize());

            SharedPreferences.setMockInitialValues({
              'selected_language': loc,
              'user_role': 'admin',
              'user_name': 'Test User',
            });
            await SharedPreferences.getInstance();
            final state = AppState();
            await state.updateLanguage(loc);

            Widget screenWidget;
            switch (screenName) {
              case 'Home':
                screenWidget = const HomeScreen();
                break;
              case 'Settings':
                screenWidget = const SettingsScreen();
                break;
              case 'QaidaChapters':
                screenWidget = const QaidaChaptersScreen();
                break;
              case 'QuranScreen':
                screenWidget = const QuranScreen();
                break;
              default:
                screenWidget = const SizedBox();
            }

            await tester.pumpWidget(
              _ScalingTestApp(state: state, scale: scale, child: screenWidget),
            );
            await tester.pumpAndSettle();

            // Report any overflow findings
            if (overflows.isNotEmpty) {
              print('OVERFLOW DETECTED: $screenName [$loc] scale=$scale count=${overflows.length}');
              for (final o in overflows) {
                print('  -> ${o.exceptionAsString().split('\n').first}');
              }
            }
          });
        }
      }
    }

    testWidgets('Home Italian Admin Banner Clipping & Cramping Reproduction', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      SharedPreferences.setMockInitialValues({
        'selected_language': 'it',
        'user_role': 'admin',
      });
      await SharedPreferences.getInstance();
      final state = AppState();
      await state.updateLanguage('it');
      await state.setUserRole('admin', token: ParentalGate.mintForTesting());

      await tester.pumpWidget(
        _ScalingTestApp(state: state, scale: 1.5, child: const HomeScreen()),
      );
      await tester.pumpAndSettle();

      final adminTextFinder = find.text('Modalità amministratore: tutti i livelli sbloccati');
      final studentBtnFinder = find.text('Modalità studente');

      expect(adminTextFinder, findsOneWidget);
      expect(studentBtnFinder, findsOneWidget);

      final adminTextRender = tester.renderObject(adminTextFinder) as RenderBox;
      final studentBtnRender = tester.renderObject(studentBtnFinder) as RenderBox;

      print('--- Italian Admin Banner Metrics at scale 1.5 ---');
      print('Admin Notice Text Size: ${adminTextRender.size}');
      print('Student Mode Button Size: ${studentBtnRender.size}');
      print('Total Row constraint width: 360 - 32 = 328px');
      print('Remaining width for notice: 328 - ${studentBtnRender.size.width} = ${328 - studentBtnRender.size.width}px');
    });
  });
}
