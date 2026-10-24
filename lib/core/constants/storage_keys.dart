/// Centralized SharedPreferences storage keys.
/// Eliminates magic strings and prevents typo-induced persistence bugs.
class StorageKeys {
  StorageKeys._();

  static const String language = 'language';
  static const String onboardingDone = 'onboarding_done';
  static const String userName = 'user_name';
  static const String userAge = 'user_age';
  static const String userRole = 'user_role';
  static const String avatarType = 'avatar_type';

  static const String xp = 'xp';
  static const String streak = 'streak';
  static const String gems = 'gems';
  static const String hearts = 'hearts';
  static const String lastActiveDate = 'last_active_date';

  static const String soundEnabled = 'sound_enabled';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String reminderTime = 'reminder_time';
}
