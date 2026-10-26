import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/l10n/app_localizations.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:little_muslim/widgets/ds/ds.dart';

class _TestApp extends StatelessWidget {
  const _TestApp({
    required this.state,
    required this.child,
    this.localeCode = 'en',
  });

  final AppState state;
  final Widget child;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: state,
      child: MaterialApp(
        locale: Locale(localeCode),
        supportedLocales: AppLanguages.supportedLocales,
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.getThemeForLanguage(localeCode),
        home: Material(child: child),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppState state;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({
      'language': 'en',
      'user_name': 'Tester',
      'user_role': 'child',
    });
    const delegate = AppLocalizationsDelegate();
    await delegate.load(const Locale('en'));
    await delegate.load(const Locale('bn'));
  });

  setUp(() async {
    state = AppState();
  });

  group('ParentalGateDialog Widget Tests', () {
    testWidgets('Displays arithmetic challenge prompt and custom numbers', (tester) async {
      await tester.pumpWidget(
        _TestApp(
          state: state,
          child: const ParentalGateDialog(
            challengeNum1: 4,
            challengeNum2: 5,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ParentalGateDialog), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      // Question should contain 4 and 5
      expect(find.textContaining('4'), findsWidgets);
      expect(find.textContaining('5'), findsWidgets);
    });

    testWidgets('Entering incorrect answer shows error and keeps dialog open', (tester) async {
      AdminElevationToken? result;
      await tester.pumpWidget(
        _TestApp(
          state: state,
          child: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () async {
                result = await ParentalGate.verify(ctx, num1: 3, num2: 4);
              },
              child: const Text('Open Gate'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Gate'));
      await tester.pumpAndSettle();

      expect(find.byType(ParentalGateDialog), findsOneWidget);

      // Enter incorrect answer: 99
      await tester.enterText(find.byType(TextField), '99');
      // Tap Confirm
      final confirmBtn = find.widgetWithText(AppButton, 'Confirm');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Dialog is still open, error is shown
      expect(find.byType(ParentalGateDialog), findsOneWidget);
      expect(find.text('Incorrect answer. Please try again.'), findsOneWidget);
      expect(result, isNull);
    });

    testWidgets('Entering correct answer dismisses dialog and returns token', (tester) async {
      AdminElevationToken? result;
      await tester.pumpWidget(
        _TestApp(
          state: state,
          child: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () async {
                result = await ParentalGate.verify(ctx, num1: 6, num2: 7);
              },
              child: const Text('Open Gate'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Gate'));
      await tester.pumpAndSettle();

      // Enter correct answer: 13
      await tester.enterText(find.byType(TextField), '13');
      final confirmBtn = find.widgetWithText(AppButton, 'Confirm');
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.byType(ParentalGateDialog), findsNothing);
      expect(result, isNotNull);
      expect(result, isA<AdminElevationToken>());
    });

    testWidgets('Tapping Cancel dismisses dialog and returns null', (tester) async {
      AdminElevationToken? result;
      await tester.pumpWidget(
        _TestApp(
          state: state,
          child: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () async {
                result = await ParentalGate.verify(ctx, num1: 2, num2: 3);
              },
              child: const Text('Open Gate'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Gate'));
      await tester.pumpAndSettle();

      final cancelBtn = find.widgetWithText(AppButton, 'Cancel');
      expect(cancelBtn, findsOneWidget);
      await tester.tap(cancelBtn);
      await tester.pumpAndSettle();

      expect(find.byType(ParentalGateDialog), findsNothing);
      expect(result, isNull);
    });

    testWidgets('Bengali localized numerals can be entered and verified', (tester) async {
      AdminElevationToken? result;
      await tester.pumpWidget(
        _TestApp(
          state: state,
          localeCode: 'bn',
          child: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () async {
                result = await ParentalGate.verify(ctx, num1: 5, num2: 3);
              },
              child: const Text('Open Gate'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Gate'));
      await tester.pumpAndSettle();

      // In Bengali, 5 + 3 = 8 ('৮')
      await tester.enterText(find.byType(TextField), '৮');
      // Look for Bengali confirm button ('নিশ্চিত করুন')
      final confirmBtn = find.widgetWithText(AppButton, 'নিশ্চিত করুন');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.byType(ParentalGateDialog), findsNothing);
      expect(result, isNotNull);
      expect(result, isA<AdminElevationToken>());
    });

    testWidgets('Turning OFF admin mode needs zero gate', (tester) async {
      await state.setUserRole('admin', token: ParentalGate.mintForTesting());
      expect(state.isAdmin, isTrue);

      await tester.pumpWidget(
        _TestApp(
          state: state,
          child: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () {
                // Direct turn off without gate
                ctx.read<AppState>().setUserRole('child');
              },
              child: const Text('Turn Off Admin'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Turn Off Admin'));
      await tester.pumpAndSettle();

      expect(state.isAdmin, isFalse);
      expect(find.byType(ParentalGateDialog), findsNothing);
    });

    testWidgets('AppState strictly rejects setUserRole(admin) without token', (tester) async {
      final success = await state.setUserRole('admin'); // no token
      expect(success, isFalse);
      expect(state.isAdmin, isFalse);

      final verifiedSuccess = await state.setUserRole('admin', token: ParentalGate.mintForTesting());
      expect(verifiedSuccess, isTrue);
      expect(state.isAdmin, isTrue);
    });

    testWidgets('3 failed attempts activate lockout and block verification', (tester) async {
      await tester.pumpWidget(
        _TestApp(
          state: state,
          child: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () async {
                await ParentalGate.verify(ctx, num1: 4, num2: 4);
              },
              child: const Text('Open Gate'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Gate'));
      await tester.pumpAndSettle();

      final confirmBtn = find.widgetWithText(AppButton, 'Confirm');

      // Attempt 1: wrong
      await tester.enterText(find.byType(TextField), '1');
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();
      expect(state.failedGateAttempts, 1);
      expect(state.isGateLockedOut, isFalse);

      // Attempt 2: wrong
      await tester.enterText(find.byType(TextField), '2');
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();
      expect(state.failedGateAttempts, 2);
      expect(state.isGateLockedOut, isFalse);

      // Attempt 3: wrong -> triggers lockout!
      await tester.enterText(find.byType(TextField), '3');
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();
      expect(state.failedGateAttempts, 3);
      expect(state.isGateLockedOut, isTrue);

      // Lockout message is displayed, TextField and Confirm button are hidden
      expect(find.textContaining('Too many attempts'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });
  });
}
