import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranReadingPosition {
  const QuranReadingPosition(
      {required this.surahNumber, required this.ayahNumber});

  final int surahNumber;
  final int ayahNumber;
}

class AppState extends ChangeNotifier {
  static const int maxQaidaLessonStep = 5;

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
  final Map<String, int> _qaidaLessonSteps = {};
  final Set<String> _quranBookmarks = {};
  QuranReadingPosition? _quranReadingPosition;
  Future<void> _progressSaveQueue = Future<void>.value();
  Future<void> _quranSaveQueue = Future<void>.value();

  // In-progress onboarding values, kept separate until setup is completed.
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
  QuranReadingPosition? get quranReadingPosition => _quranReadingPosition;
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
  int qaidaLessonStep(String lessonId) => _qaidaLessonSteps[lessonId] ?? 0;
  bool isQuranAyahBookmarked(int surahNumber, int ayahNumber) =>
      _quranBookmarks.contains(_quranBookmarkKey(surahNumber, ayahNumber));
  Set<String> get quranBookmarks => Set.unmodifiable(_quranBookmarks);

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedProgress =
        _readLearningProgress(prefs.getString('learning_progress'));
    _hasCompletedOnboarding = prefs.getBool('onboarding_done') ?? false;
    _userName = prefs.getString('user_name') ?? '';
    _age = prefs.getInt('user_age') ?? 8;
    _selectedLanguage = prefs.getString('language') ?? 'bn';
    final savedXp = savedProgress?['xp'];
    _xp = savedXp is int && savedXp >= 0 ? savedXp : prefs.getInt('xp') ?? 0;
    _streakAlertsEnabled = prefs.getBool('streak_alerts') ?? true;
    _classAlertsEnabled = prefs.getBool('class_alerts') ?? true;
    _reminderTime = prefs.getString('reminder_time') ?? '19:00';
    _completedLessons
      ..clear()
      ..addAll(_savedStringList(savedProgress?['completedLessons'],
          prefs.getStringList('completed_lessons')));
    _lessonActivity
      ..clear()
      ..addAll(_savedStringList(savedProgress?['lessonActivity'],
          prefs.getStringList('lesson_activity')));
    _openedChests
      ..clear()
      ..addAll(_savedStringList(savedProgress?['openedChests'],
          prefs.getStringList('opened_chests')));
    _qaidaLessonSteps
      ..clear()
      ..addAll(_readQaidaLessonSteps(savedProgress?['qaidaLessonSteps'] ??
          prefs.getString('qaida_lesson_steps')));
    _qaidaLessonSteps
        .removeWhere((lessonId, _) => _completedLessons.contains(lessonId));
    _quranBookmarks
      ..clear()
      ..addAll(prefs.getStringList('quran_bookmarks') ?? const []);
    _quranReadingPosition =
        _readQuranPosition(prefs.getString('quran_last_read'));
    _isLoaded = true;
    notifyListeners();
  }

  /// Awards XP once per lesson and saves the learner's progress locally.
  Future<bool> completeLesson(String lessonId, {int xp = 10}) async {
    if (!_completedLessons.add(lessonId)) return false;
    _qaidaLessonSteps.remove(lessonId);
    _xp += xp;
    _lessonActivity.add('$lessonId|${_todayKey()}');
    notifyListeners();
    await _saveProgress();
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
    final xp = _xp;
    final completedLessons = _completedLessons.toList();
    final lessonActivity = _lessonActivity.toList();
    final openedChests = _openedChests.toList();
    final progress = jsonEncode({
      'version': 1,
      'xp': xp,
      'completedLessons': completedLessons,
      'lessonActivity': lessonActivity,
      'openedChests': openedChests,
      'qaidaLessonSteps': _qaidaLessonSteps,
    });
    final save = _progressSaveQueue.catchError((_) {}).then((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('learning_progress', progress);
    });
    _progressSaveQueue = save;
    await save;
  }

  Future<void> saveQaidaLessonStep(String lessonId, int step) async {
    if (lessonId.isEmpty || step < 0 || step > maxQaidaLessonStep) return;
    if (_completedLessons.contains(lessonId)) return;
    _qaidaLessonSteps[lessonId] = step;
    await _saveProgress();
  }

  Future<void> saveQuranReadingPosition(int surahNumber, int ayahNumber) async {
    if (surahNumber < 1 || ayahNumber < 1) return;
    _quranReadingPosition = QuranReadingPosition(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    notifyListeners();
    await _saveQuranProgress();
  }

  Future<void> clearQuranReadingPosition() async {
    _quranReadingPosition = null;
    notifyListeners();
    await _saveQuranProgress();
  }

  Future<void> toggleQuranBookmark(int surahNumber, int ayahNumber) async {
    if (surahNumber < 1 || ayahNumber < 1) return;
    final key = _quranBookmarkKey(surahNumber, ayahNumber);
    if (!_quranBookmarks.add(key)) _quranBookmarks.remove(key);
    notifyListeners();
    await _saveQuranProgress();
  }

  /// Drops bookmarks that no longer match the downloaded surah list and
  /// clears or clamps a saved position if the Quran data has changed.
  Future<void> validateQuranProgress(Map<int, int> ayahCounts) async {
    final previousBookmarks = _quranBookmarks.toSet();
    _quranBookmarks.removeWhere((bookmark) {
      final parts = _parseQuranBookmarkKey(bookmark);
      return parts == null ||
          !ayahCounts.containsKey(parts.$1) ||
          parts.$2 > (ayahCounts[parts.$1] ?? 0);
    });

    final current = _quranReadingPosition;
    if (current != null) {
      final ayahCount = ayahCounts[current.surahNumber];
      if (ayahCount == null || ayahCount < 1) {
        _quranReadingPosition = null;
      } else if (current.ayahNumber > ayahCount) {
        _quranReadingPosition = QuranReadingPosition(
          surahNumber: current.surahNumber,
          ayahNumber: ayahCount,
        );
      }
    }
    final positionChanged =
        current?.surahNumber != _quranReadingPosition?.surahNumber ||
            current?.ayahNumber != _quranReadingPosition?.ayahNumber;
    final bookmarksChanged = !setEquals(previousBookmarks, _quranBookmarks);
    if (!positionChanged && !bookmarksChanged) return;

    notifyListeners();
    await _saveQuranProgress();
  }

  Future<void> _saveQuranProgress() {
    final bookmarks = _quranBookmarks.toList();
    final position = _quranReadingPosition;
    final save = _quranSaveQueue.catchError((_) {}).then((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('quran_bookmarks', bookmarks);
      if (position == null) {
        await prefs.remove('quran_last_read');
      } else {
        await prefs.setString(
            'quran_last_read',
            jsonEncode({
              'surah': position.surahNumber,
              'ayah': position.ayahNumber,
            }));
      }
    });
    _quranSaveQueue = save;
    return save;
  }

  String _quranBookmarkKey(int surahNumber, int ayahNumber) =>
      '$surahNumber:$ayahNumber';

  (int, int)? _parseQuranBookmarkKey(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final surah = int.tryParse(parts[0]);
    final ayah = int.tryParse(parts[1]);
    if (surah == null || ayah == null || surah < 1 || ayah < 1) return null;
    return (surah, ayah);
  }

  Map<String, dynamic>? _readLearningProgress(String? raw) {
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic> && decoded['version'] == 1) {
        return decoded;
      }
    } catch (_) {
      // Keep older preference values if the newer snapshot cannot be read.
    }
    return null;
  }

  List<String> _savedStringList(Object? stored, List<String>? fallback) {
    if (stored is List<dynamic> && stored.every((value) => value is String)) {
      return stored.cast<String>();
    }
    return fallback ?? const [];
  }

  Map<String, int> _readQaidaLessonSteps(Object? raw) {
    if (raw == null) return {};
    try {
      final decoded = raw is String ? jsonDecode(raw) : raw;
      if (decoded is! Map<String, dynamic>) return {};
      return {
        for (final entry in decoded.entries)
          if (entry.key.isNotEmpty &&
              entry.value is int &&
              (entry.value as int) >= 0 &&
              (entry.value as int) <= maxQaidaLessonStep)
            entry.key: entry.value as int,
      };
    } catch (_) {
      return {};
    }
  }

  QuranReadingPosition? _readQuranPosition(String? raw) {
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      final surah = decoded['surah'];
      final ayah = decoded['ayah'];
      if (surah is! int || ayah is! int || surah < 1 || ayah < 1) return null;
      return QuranReadingPosition(surahNumber: surah, ayahNumber: ayah);
    } catch (_) {
      return null;
    }
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
    await prefs.setString('qaida_lesson_steps', '{}');
    await prefs.setString(
      'learning_progress',
      jsonEncode({
        'version': 1,
        'xp': 0,
        'completedLessons': <String>[],
        'lessonActivity': <String>[],
        'openedChests': _openedChests.toList(),
        'qaidaLessonSteps': <String, int>{},
      }),
    );

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
    _qaidaLessonSteps.clear();
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
    _qaidaLessonSteps.clear();
    _quranBookmarks.clear();
    _quranReadingPosition = null;
    draftName = '';
    draftAge = 8;
    draftLanguage = 'bn';
    _isLoaded = true;
    notifyListeners();
  }
}
