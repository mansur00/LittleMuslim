import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:little_muslim/core/core.dart';
import 'package:little_muslim/screens/onboarding/language_page.dart';
import 'package:little_muslim/widgets/language_switcher.dart';
import 'package:little_muslim/utils/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({'language': 'hi', 'onboarding_done': true});
  });

  testWidgets('LanguagePage switches language from Hindi to Bengali and persists', (tester) async {
    final appState = AppState();
    await appState.loadFromPrefs();
    expect(appState.selectedLanguage, 'hi');

    final languageProvider = LanguageProvider();
    await languageProvider.initialize();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: languageProvider),
          ChangeNotifierProvider.value(value: appState),
        ],
        child: MaterialApp(
          locale: const Locale('hi'),
          home: LanguagePage(
            isTablet: false,
            isStandalone: true,
            onNext: () {},
            onBack: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Bengali card exists and tap it
    final bnCard = find.text('বাংলা').first;
    expect(bnCard, findsOneWidget);
    await tester.tap(bnCard);
    await tester.pumpAndSettle();

    // Assert appState.selectedLanguage is updated to 'bn'
    await tester.pump(const Duration(milliseconds: 300));
    expect(appState.selectedLanguage, 'bn');
    expect(appState.draftLanguage, 'bn');
    expect(languageProvider.currentCode, 'bn');

    // Tap English card
    final enCard = find.text('English').first;
    expect(enCard, findsOneWidget);
    await tester.tap(enCard);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(appState.selectedLanguage, 'en');
    expect(appState.draftLanguage, 'en');
    expect(languageProvider.currentCode, 'en');
  });

  testWidgets('showSearchableLanguageSheet switches language and dismisses', (tester) async {
    final appState = AppState();
    await appState.loadFromPrefs();

    final languageProvider = LanguageProvider();
    await languageProvider.initialize();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: languageProvider),
          ChangeNotifierProvider.value(value: appState),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showSearchableLanguageSheet(context),
                  child: const Text('Open Sheet'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    // Tap on Bengali option
    final bnOption = find.text('বাংলা').first;
    expect(bnOption, findsOneWidget);
    await tester.tap(bnOption);
    await tester.pumpAndSettle();

    expect(appState.selectedLanguage, 'bn');
    expect(appState.draftLanguage, 'bn');
    expect(languageProvider.currentCode, 'bn');
  });
}
