import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';
import 'utils/app_state.dart';
import 'l10n/app_localizations.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();

  // Portrait + Landscape support (phone & tablet friendly)
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState()..loadFromPrefs(),
      child: const LittleMuslimApp(),
    ),
  );
}

class LittleMuslimApp extends StatelessWidget {
  const LittleMuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.select<AppState, String>((appState) =>
        appState.hasCompletedOnboarding
            ? appState.selectedLanguage
            : appState.draftLanguage);
    return MaterialApp(
      title: 'LittleMuslim',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: Locale(language == 'en' ? 'en' : 'bn'),
      supportedLocales: const [Locale('bn'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const _AppEntryPoint(),
    );
  }
}

class _AppEntryPoint extends StatelessWidget {
  const _AppEntryPoint();

  @override
  Widget build(BuildContext context) {
    final (isLoaded, hasCompletedOnboarding) =
        context.select<AppState, (bool, bool)>(
            (appState) => (appState.isLoaded, appState.hasCompletedOnboarding));

    // Wait until SharedPreferences have been read to avoid flashing onboarding
    if (!isLoaded) {
      return const Scaffold(
        backgroundColor: AppTheme.cream,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryGreen,
          ),
        ),
      );
    }

    if (hasCompletedOnboarding) {
      return const HomeScreen();
    } else {
      return const OnboardingScreen();
    }
  }
}
