import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isLoaded = false;
  bool _hasCompletedOnboarding = false;
  String _userName = '';
  int _age = 8;
  String _selectedLanguage = 'bn'; // bn / en / ar
  int _xp = 0;
  bool _streakAlertsEnabled = true;
  bool _classAlertsEnabled = true;
  String _reminderTime = '19:00';
  final Set<String> _completedLessons = {};
  final Set<String> _lessonActivity = {};
  final Set<String> _openedChests = {};

  // Temporary values while user is going through onboarding
  String draftName = '';
  int draftAge = 8;
  String draftLanguage = 'bn';

  bool get isLoaded => _isLoaded;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  String get userName => _userName;
  int get age => _age;
  String get selectedLanguage => _selectedLanguage;
  int get xp => _xp;
  bool get streakAlertsEnabled => _streakAlertsEnabled;
  bool get classAlertsEnabled => _classAlertsEnabled;
  String get reminderTime => _reminderTime;
  int get streakDays {
    final activeDays = _lessonActivity
        .map((entry) => entry.substring(entry.lastIndexOf('|') + 1))
        .toSet();
    var day = DateTime.now();
    String key(DateTime value) =>
        '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
    if (!activeDays.contains(key(day))) {
      day = day.subtract(const Duration(days: 1));
    }
    var count = 0;
    while (activeDays.contains(key(day))) {
      count++;
      day = day.subtract(const Duration(days: 1));
    }
    return count;
  }

  int get completedQaidaLessons =>
      _completedLessons.where((lesson) => lesson.startsWith('qaida_')).length;
  int get todayQaidaLessons => _lessonActivity
      .where((entry) => entry.endsWith('|${_todayKey()}'))
      .map((entry) => entry.substring(0, entry.lastIndexOf('|')))
      .where((lesson) => lesson.startsWith('qaida_'))
      .toSet()
      .length;
  String get todayQaidaMissionLessonId => 'qaida_daily_${_todayKey()}';
  bool hasCompletedLesson(String lessonId) =>
      _completedLessons.contains(lessonId);
  bool hasOpenedChest(String chestId) => _openedChests.contains(chestId);

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _hasCompletedOnboarding = prefs.getBool('onboarding_done') ?? false;
    _userName = prefs.getString('user_name') ?? '';
    _age = prefs.getInt('user_age') ?? 8;
    _selectedLanguage = prefs.getString('language') ?? 'bn';
    _xp = prefs.getInt('xp') ?? 0;
    _streakAlertsEnabled = prefs.getBool('streak_alerts') ?? true;
    _classAlertsEnabled = prefs.getBool('class_alerts') ?? true;
    _reminderTime = prefs.getString('reminder_time') ?? '19:00';
    _completedLessons
      ..clear()
      ..addAll(prefs.getStringList('completed_lessons') ?? const []);
    _lessonActivity
      ..clear()
      ..addAll(prefs.getStringList('lesson_activity') ?? const []);
    _openedChests
      ..clear()
      ..addAll(prefs.getStringList('opened_chests') ?? const []);
    _isLoaded = true;
    notifyListeners();
  }

  /// Awards XP once per lesson and saves the learner's progress locally.
  bool completeLesson(String lessonId, {int xp = 10}) {
    if (!_completedLessons.add(lessonId)) return false;
    _xp += xp;
    _lessonActivity.add('$lessonId|${_todayKey()}');
    notifyListeners();
    _saveProgress();
    return true;
  }

  /// Awards bonus XP when a milestone treasure chest is opened.
  bool openChest(String chestId, {int xp = 25}) {
    if (!_openedChests.add(chestId)) return false;
    _xp += xp;
    notifyListeners();
    _saveProgress();
    return true;
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', _xp);
    await prefs.setStringList('completed_lessons', _completedLessons.toList());
    await prefs.setStringList('lesson_activity', _lessonActivity.toList());
    await prefs.setStringList('opened_chests', _openedChests.toList());
  }

  Future<void> updateProfile({required String name, required int age}) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;
    _userName = cleanName;
    _age = age.clamp(6, 14);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _userName);
    await prefs.setInt('user_age', _age);
    notifyListeners();
  }

  Future<void> updateNotificationSettings({
    bool? streakAlertsEnabled,
    bool? classAlertsEnabled,
    String? reminderTime,
  }) async {
    if (streakAlertsEnabled != null) {
      _streakAlertsEnabled = streakAlertsEnabled;
    }
    if (classAlertsEnabled != null) _classAlertsEnabled = classAlertsEnabled;
    if (reminderTime != null) _reminderTime = reminderTime;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('streak_alerts', _streakAlertsEnabled);
    await prefs.setBool('class_alerts', _classAlertsEnabled);
    await prefs.setString('reminder_time', _reminderTime);
    notifyListeners();
  }

  String _todayKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  void updateDraftName(String name) {
    draftName = name.trim();
    notifyListeners();
  }

  void updateDraftAge(int age) {
    draftAge = age;
    notifyListeners();
  }

  void updateDraftLanguage(String lang) {
    draftLanguage = lang;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final name = draftName.isNotEmpty ? draftName : 'Young Muslim';
    final age = draftAge;
    final language = draftLanguage;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    await prefs.setString('user_name', name);
    await prefs.setInt('user_age', age);
    await prefs.setString('language', language);
    await prefs.setInt('xp', 0);
    await prefs.setStringList('completed_lessons', const []);
    await prefs.setStringList('lesson_activity', const []);

    _hasCompletedOnboarding = true;
    _userName = name;
    _age = age;
    _selectedLanguage = language;
    _xp = 0;
    _streakAlertsEnabled = true;
    _classAlertsEnabled = true;
    _reminderTime = '19:00';
    _completedLessons.clear();
    _lessonActivity.clear();
    notifyListeners();
  }

  // For testing / reset
  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _hasCompletedOnboarding = false;
    _userName = '';
    _age = 8;
    _selectedLanguage = 'bn';
    _xp = 0;
    _streakAlertsEnabled = true;
    _classAlertsEnabled = true;
    _reminderTime = '19:00';
    _completedLessons.clear();
    _lessonActivity.clear();
    _openedChests.clear();
    draftName = '';
    draftAge = 8;
    draftLanguage = 'bn';
    _isLoaded = true;
    notifyListeners();
  }
}
