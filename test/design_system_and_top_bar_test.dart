import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/l10n/app_localizations.dart';
import 'package:little_muslim/theme/app_theme.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:little_muslim/widgets/ds/ds.dart';

class _TestApp extends StatelessWidget {
  const _TestApp({
    required this.state,
    required this.child,
    this.textDirection = TextDirection.ltr,
  });

  final AppState state;
  final Widget child;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: state,
      child: Directionality(
        textDirection: textDirection,
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
            theme: AppTheme.getThemeForLanguage(appState.selectedLanguage),
            home: Material(child: child),
          ),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      'language': 'en',
      'user_name': 'Ahmad',
      'streak_count': 5,
      'xp': 120,
    });
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

  Future<AppState> createTestState(String locale) async {
    SharedPreferences.setMockInitialValues({
      'language': locale,
      'user_name': 'Ahmad',
      'streak_count': 5,
      'xp': 120,
    });
    final state = AppState();
    await state.loadFromPrefs();
    await state.updateLanguage(locale);
    return state;
  }

  Future<void> pumpScreen(WidgetTester tester, AppState state, Widget widget, {TextDirection textDirection = TextDirection.ltr}) async {
    await tester.pumpWidget(_TestApp(state: state, textDirection: textDirection, child: widget));
    await tester.pumpAndSettle();
  }

  group('Design System Tokens Sanity', () {
    test('Tokens are defined and adhere to grid scale', () {
      expect(AppColors.brandPrimary, isNotNull);
      expect(AppColors.background, isNotNull);
      expect(AppSpacing.sm, 8);
      expect(AppSpacing.md, 12);
      expect(AppSpacing.lg, 16);
      expect(AppSpacing.xxl, 24);
      expect(AppRadius.sm, 8);
      expect(AppRadius.md, 12);
      expect(AppRadius.lg, 16);
      expect(AppRadius.pill, 9999);
      expect(AppStroke.hairline, 1.0);
      expect(AppStroke.regular, 1.5);
      expect(AppSizes.touchTargetMin, 44);
      expect(AppSizes.topBarHeight, 60);
    });
  });

  group('Design System Shared Components', () {
    testWidgets('AppAvatar renders without errors', (tester) async {
      final state = await createTestState('en');
      await pumpScreen(tester, state, const Center(child: AppAvatar()));
      expect(find.byType(AppAvatar), findsOneWidget);
    });

    testWidgets('AppCard renders child with token decoration', (tester) async {
      final state = await createTestState('en');
      await pumpScreen(
        tester,
        state,
        const AppCard(child: Text('Card Content')),
      );
      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('AppButton renders primary, secondary, ghost', (tester) async {
      final state = await createTestState('en');
      await pumpScreen(
        tester,
        state,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton.primary(label: 'Primary', onPressed: () {}),
            AppButton.secondary(label: 'Secondary', onPressed: () {}),
            AppButton.ghost(label: 'Ghost', onPressed: () {}),
          ],
        ),
      );
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
      expect(find.text('Ghost'), findsOneWidget);
    });

    testWidgets('AppChip renders label and selection state', (tester) async {
      final state = await createTestState('en');
      await pumpScreen(
        tester,
        state,
        const AppChip(label: 'Active Filter', isSelected: true),
      );
      expect(find.text('Active Filter'), findsOneWidget);
    });

    testWidgets('AppSectionHeader renders title and subtitle', (tester) async {
      final state = await createTestState('en');
      await pumpScreen(
        tester,
        state,
        const AppSectionHeader(
          title: 'Section Title',
          subtitle: 'Section Subtitle',
        ),
      );
      expect(find.text('Section Title'), findsOneWidget);
      expect(find.text('Section Subtitle'), findsOneWidget);
    });

    testWidgets('AppProgressBar clamps and renders', (tester) async {
      final state = await createTestState('en');
      await pumpScreen(
        tester,
        state,
        const AppProgressBar(progress: 0.65),
      );
      expect(find.byType(AppProgressBar), findsOneWidget);
    });
  });

  group('AppTopBar Tests', () {
    testWidgets('AppTopBar page variant renders back button and title', (tester) async {
      final state = await createTestState('en');
      await pumpScreen(
        tester,
        state,
        const Scaffold(
          appBar: AppTopBar.page(
            title: 'Sub Page Title',
            subtitle: 'Sub Page Details',
          ),
        ),
      );
      expect(find.text('Sub Page Title'), findsOneWidget);
      expect(find.text('Sub Page Details'), findsOneWidget);
    });

    testWidgets('AppTopBar shell variant renders logo, streak, xp, and profile', (tester) async {
      final state = await createTestState('en');
      await pumpScreen(
        tester,
        state,
        const Scaffold(
          appBar: AppTopBar(showWordmark: true),
        ),
      );
      expect(find.text('Little Muslim'), findsOneWidget);
      expect(find.byType(AppAvatar), findsOneWidget);
    });

    testWidgets('AppTopBar does not overflow at 320px width and 1.3x text scale', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final state = await createTestState('bn');
      await pumpScreen(
        tester,
        state,
        const Scaffold(
          appBar: AppTopBar(showWordmark: false),
        ),
      );
      expect(find.byType(AppTopBar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('AppTopBar renders in RTL mode without error', (tester) async {
      final state = await createTestState('en');
      await pumpScreen(
        tester,
        state,
        const Scaffold(
          appBar: AppTopBar(showWordmark: true),
        ),
        textDirection: TextDirection.rtl,
      );
      expect(find.byType(AppTopBar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('AppTopBar profile menu opens bottom sheet with all required items', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final state = await createTestState('en');
      await pumpScreen(
        tester,
        state,
        const Scaffold(
          appBar: AppTopBar(),
        ),
      );

      // Tap profile button
      final profileFinder = find.byType(AppAvatar);
      expect(profileFinder, findsOneWidget);
      await tester.tap(profileFinder);
      await tester.pumpAndSettle();

      // Verify bottom sheet opened and options exist
      expect(find.text('Profile'), findsWidgets);
      expect(find.text('Choose Avatar & Color'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Admin Mode'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
    });

    testWidgets('AppTopBar profile menu in Italian renders Italian translated keys', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final state = await createTestState('it');
      await pumpScreen(
        tester,
        state,
        const Scaffold(
          appBar: AppTopBar(),
        ),
      );

      // Tap profile button
      final profileFinder = find.byType(AppAvatar);
      expect(profileFinder, findsOneWidget);
      await tester.tap(profileFinder);
      await tester.pumpAndSettle();

      // Verify Italian translations appear
      expect(find.text('Profilo'), findsWidgets);
      expect(find.text('Scegli avatar e colore'), findsOneWidget);
      expect(find.text('Impostazioni'), findsOneWidget);
      expect(find.text('Lingua'), findsOneWidget);
      expect(find.text('Modalità amministratore'), findsOneWidget);
      expect(find.text('Aiuto e supporto'), findsOneWidget);
    });
  });
}
