/// Global catalog of asset paths used across the application.
/// Avoids typos and allows assets to be moved or updated in one place.
class AssetPaths {
  AssetPaths._();

  // 3D Badges
  static const String badgeQaida = 'assets/images/badge_qaida_3d.png';
  static const String badgeQuran = 'assets/images/badge_quran_3d.png';
  static const String badgePrayer = 'assets/images/badge_prayer_3d.png';
  static const String badgeDua = 'assets/images/badge_dua_3d.png';
  static const String badgeSeerah = 'assets/images/badge_seerah_3d.png';
  static const String badgeBasics = 'assets/images/badge_basics_3d.png';

  // 3D Objects & Mascots
  static const String quran3D = 'assets/images/quran_3d.png';
  static const String quran3DOpen = 'assets/images/quran_3d_open.png';
  static const String mascotCelebrate = 'assets/images/mascot_celebrate.png';
  static const String mascotReading = 'assets/images/mascot_reading.png';
  static const String mascotHappy = 'assets/images/mascot_happy.png';

  // Faceless Silhouettes
  static const String silhouetteTopi = 'assets/images/silhouette_topi.png';
  static const String silhouetteHijab = 'assets/images/silhouette_hijab.png';
  static const String silhouetteReadingTopi =
      'assets/images/silhouette_reading_topi.png';
  static const String silhouetteReadingHijab =
      'assets/images/silhouette_reading_hijab.png';
  static const String silhouetteCelebrateTopi =
      'assets/images/silhouette_celebrate_topi.png';
  static const String silhouetteCelebrateHijab =
      'assets/images/silhouette_celebrate_hijab.png';

  // Audio - System & Alerts
  static const String audioAdhan = 'assets/audio/adhan.mp3';
  static const String audioAlarm = 'assets/audio/learning_alarm.mp3';

  // Audio - Directory Prefixes
  static const String audioLettersDir = 'assets/audio/letters';
  static const String audioDuasDir = 'assets/audio/duas';

  // Helper for letter audio
  static String letterAudio(String letterId) =>
      '$audioLettersDir/$letterId.mp3';

  // Helper for dua audio
  static String duaAudio(String duaId) => '$audioDuasDir/$duaId.mp3';
}
