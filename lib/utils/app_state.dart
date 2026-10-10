import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isLoaded = false;
  bool _hasCompletedOnboarding = false;
  String _userName = '';
  int _age = 8;
  String _selectedLanguage = 'bn'; // bn / en / ar
  int _xp = 0;
  final Set<String> _completedLessons = {};
  final Set<String> _lessonActivity = {};

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

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _hasCompletedOnboarding = prefs.getBool('onboarding_done') ?? false;
    _userName = prefs.getString('user_name') ?? '';
    _age = prefs.getInt('user_age') ?? 8;
    _selectedLanguage = prefs.getString('language') ?? 'bn';
    _xp = prefs.getInt('xp') ?? 0;
    _completedLessons
      ..clear()
      ..addAll(prefs.getStringList('completed_lessons') ?? const []);
    _lessonActivity
      ..clear()
      ..addAll(prefs.getStringList('lesson_activity') ?? const []);
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

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', _xp);
    await prefs.setStringList('completed_lessons', _completedLessons.toList());
    await prefs.setStringList('lesson_activity', _lessonActivity.toList());
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
    _completedLessons.clear();
    _lessonActivity.clear();
    draftName = '';
    draftAge = 8;
    draftLanguage = 'bn';
    _isLoaded = true;
    notifyListeners();
  }
}
