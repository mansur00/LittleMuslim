/// Global application configuration and metadata.
/// Change app-wide constants, limits, and defaults from here in one place.
class AppConfig {
  AppConfig._();

  static const String appName = 'Little Muslim';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Gamification & Progression Defaults
  static const int defaultUserAge = 8;
  static const int defaultDailyMissionCount = 3;
  static const int xpPerLesson = 10;
  static const int xpPerQuiz = 15;
  static const int xpPerPrayer = 5;

  // Tablet breakpoint
  static const double tabletBreakpoint = 600.0;
  static const double maxContentWidth = 800.0;

  // External / Support links
  static const String privacyPolicyUrl = 'https://littlemuslim.app/privacy';
  static const String termsOfServiceUrl = 'https://littlemuslim.app/terms';
  static const String supportEmail = 'support@littlemuslim.app';
}
