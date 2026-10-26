import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../core/core.dart';
import '../models/qaida/qaida_models.dart';
import '../widgets/ds/parental_gate_dialog.dart';
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
  bool _prayerAlertsEnabled = true;
  Map<String, bool> _prayerAlertToggles = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };
  bool _learningAlarmEnabled = true;
  String _learningAlarmTime = '17:30';
  final Set<String> _completedLessons = {};
  final Set<String> _lessonActivity = {};
  final Set<String> _openedChests = {};
  final Map<String, int> _qaidaLessonSteps = {};
  final Set<String> _duaFavorites = {};
  final Map<String, int> _quizResults = {};
  final Map<String, int> _basicsProgress = {};
  final Set<String> _quranBookmarks = {};
  int _salahStep = 0;
  final Map<String, int> _seerahProgress = {};
  QuranReadingPosition? _quranReadingPosition;
  Future<void> _progressSaveQueue = Future<void>.value();
  Future<void> _quranSaveQueue = Future<void>.value();

  // ── Skill mastery tracking (separate from lesson completion) ──
  final Map<String, SkillProgress> _skillProgress = {};

  // ── Checkpoint / exam scores ──
  // key: examId (e.g. 'track_1_letters_checkpoint_1'), value: 0–100
  final Map<String, int> _examScores = {};

  // ── Per-lesson activity attempt tracking ──
  // key: lessonId, value: current activity index (resume support)
  final Map<String, int> _lessonActivityIndex = {};

  // In-progress onboarding values, kept separate until setup is completed.
  String draftName = '';
  int draftAge = 8;
  String draftLanguage = 'bn';
  String draftRole = 'child'; // 'child' (regular) or 'admin'
  String draftAvatarType = 'topi'; // 'topi' or 'hijab'
  int draftAvatarColor = 0xFF10B981; // Default Emerald Green
  String _userRole = 'child';
  String _avatarType = 'topi';
  int _avatarColor = 0xFF10B981;

  bool get isLoaded => _isLoaded;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  String get userName => _userName;
  int get age => _age;
  String get selectedLanguage => _selectedLanguage;
  String get userRole => _userRole;
  String get avatarType => _avatarType;
  int get avatarColor => _avatarColor;
  bool get isAdmin => _userRole == 'admin';
  int get xp => _xp;
  bool get streakAlertsEnabled => _streakAlertsEnabled;
  bool get classAlertsEnabled => _classAlertsEnabled;
  String get reminderTime => _reminderTime;
  bool get prayerAlertsEnabled => _prayerAlertsEnabled;
  Map<String, bool> get prayerAlertToggles => Map.unmodifiable(_prayerAlertToggles);
  bool isPrayerAlertEnabled(String prayerName) {
    if (!_prayerAlertsEnabled) return false;
    return _prayerAlertToggles[prayerName] ?? true;
  }
  bool get learningAlarmEnabled => _learningAlarmEnabled;
  String get learningAlarmTime => _learningAlarmTime;
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
  Set<String> get duaFavorites => Set.unmodifiable(_duaFavorites);
  bool isDuaFavorite(String duaId) => _duaFavorites.contains(duaId);
  int? quizResult(String id) => _quizResults[id];
  int basicsProgress(String chapterId) => _basicsProgress[chapterId] ?? 0;
  int get salahStep => _salahStep;
  bool get isSalahCompleted => hasCompletedLesson('salah_guide');
  int seerahProgress(String storyId) => _seerahProgress[storyId] ?? 0;

  // ── Skill mastery ──
  SkillProgress? skillProgress(String skillId) => _skillProgress[skillId];
  Map<String, SkillProgress> get allSkillProgress =>
      Map.unmodifiable(_skillProgress);

  /// Skills that are due for spaced repetition review.
  List<SkillProgress> get skillsDueForReview => _skillProgress.values
      .where((s) => s.isDueForReview)
      .toList()
    ..sort((a, b) => b.revisionPriority.compareTo(a.revisionPriority));

  bool get hasSkillsDueForReview => skillsDueForReview.isNotEmpty;

  /// Returns true if any Qaida skill was missed (accuracy < 70%) recently.
  bool get hasRecentMistakes => _skillProgress.values.any(
        (s) =>
            s.incorrectAttempts > 0 &&
            s.accuracy < 0.7 &&
            DateTime.now().difference(s.lastPracticedAt).inDays <= 3,
      );

  // ── Exam scores ──
  int? examScore(String examId) => _examScores[examId];
  bool examPassed(String examId, {int passingThreshold = 80}) {
    final score = _examScores[examId];
    return score != null && score >= passingThreshold;
  }

  // ── Activity resume index ──
  int lessonActivityIndex(String lessonId) =>
      _lessonActivityIndex[lessonId] ?? 0;

  Future<void> saveSalahStep(int step) async {
    if (step < 0 || step > 4) return;
    _salahStep = step;
    notifyListeners();
    await _saveProgress();
  }

  Future<bool> completeSalahLesson({int xp = 15}) async {
    final earned = await completeLesson('salah_guide', xp: xp);
    return earned;
  }

  Future<void> resetSalahProgress() async {
    _salahStep = 0;
    notifyListeners();
    await _saveProgress();
  }

  Future<void> saveSeerahProgress(String storyId, int step) async {
    if (storyId.isEmpty || step < 0) return;
    _seerahProgress[storyId] = step;
    notifyListeners();
    await _saveProgress();
  }

  Future<void> toggleDuaFavorite(String duaId) async {
    if (duaId.isEmpty) return;
    if (!_duaFavorites.add(duaId)) _duaFavorites.remove(duaId);
    notifyListeners();
    await _saveProgress();
  }

  Future<void> recordQuizResult(String quizId, int score) async {
    if (quizId.isEmpty || score < 0) return;
    _quizResults[quizId] = score;
    notifyListeners();
    await _saveProgress();
  }

  Future<void> saveBasicsProgress(String chapterId, int step) async {
    if (chapterId.isEmpty || step < 0) return;
    _basicsProgress[chapterId] = step;
    await _saveProgress();
  }

  Future<void> clearBasicsProgress(String chapterId) async {
    _basicsProgress.remove(chapterId);
    await _saveProgress();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedProgress =
        _readLearningProgress(prefs.getString('learning_progress'));
    _hasCompletedOnboarding = prefs.getBool('onboarding_done') ?? false;
    _userName = prefs.getString('user_name') ?? '';
    _age = prefs.getInt('user_age') ?? 8;
    final rawLang = prefs.getString('language') ?? 'bn';
    _selectedLanguage = _validLang(rawLang);
    final initialLang = AppLanguages.byCode(_selectedLanguage);
    setHtmlLangAndDir(_selectedLanguage, initialLang?.dirString ?? 'ltr');
    _userRole = prefs.getString('user_role') ?? 'child';
    draftRole = _userRole;
    _avatarType = prefs.getString('avatar_type') ?? 'topi';
    _avatarColor = prefs.getInt('avatar_color') ?? 0xFF10B981;
    draftAvatarType = _avatarType;
    draftAvatarColor = _avatarColor;
    final savedXp = savedProgress?['xp'];
    _xp = savedXp is int && savedXp >= 0 ? savedXp : prefs.getInt('xp') ?? 0;
    _streakAlertsEnabled = prefs.getBool('streak_alerts') ?? true;
    _classAlertsEnabled = prefs.getBool('class_alerts') ?? true;
    _reminderTime = prefs.getString('reminder_time') ?? '19:00';
    _prayerAlertsEnabled = prefs.getBool('prayer_alerts_enabled') ?? true;
    final savedPrayerToggles = prefs.getString('prayer_alert_toggles');
    if (savedPrayerToggles != null) {
      try {
        final decoded = jsonDecode(savedPrayerToggles) as Map<String, dynamic>;
        _prayerAlertToggles = decoded.map((k, v) => MapEntry(k, v == true));
      } catch (_) {}
    }
    _learningAlarmEnabled = prefs.getBool('learning_alarm_enabled') ?? true;
    _learningAlarmTime = prefs.getString('learning_alarm_time') ?? '17:30';
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
    _duaFavorites
      ..clear()
      ..addAll(_savedStringList(savedProgress?['duaFavorites'],
          prefs.getStringList('dua_favorites')));
    _quizResults
      ..clear()
      ..addAll(_readIntMap(savedProgress?['quizResults']));
    _basicsProgress
      ..clear()
      ..addAll(_readIntMap(savedProgress?['basicsProgress']));
    final salahVal = savedProgress?['salahStep'];
    _salahStep = (salahVal is int && salahVal >= 0 && salahVal <= 4)
        ? salahVal
        : (prefs.getInt('salah_step') ?? 0).clamp(0, 4);
    _seerahProgress
      ..clear()
      ..addAll(_readIntMap(savedProgress?['seerahProgress']));
    _quranBookmarks
      ..clear()
      ..addAll(prefs.getStringList('quran_bookmarks') ?? const []);
    _quranReadingPosition =
        _readQuranPosition(prefs.getString('quran_last_read'));
    // Load skill progress
    _skillProgress
      ..clear()
      ..addAll(_readSkillProgress(savedProgress?['skillProgress']));
    // Load exam scores
    _examScores
      ..clear()
      ..addAll(_readIntMap(savedProgress?['examScores']));
    // Load activity resume indices
    _lessonActivityIndex
      ..clear()
      ..addAll(_readIntMap(savedProgress?['lessonActivityIndex']));
    _isLoaded = true;
    notifyListeners();
  }

  Map<String, SkillProgress> _readSkillProgress(Object? raw) {
    if (raw is! Map<String, dynamic>) return {};
    final result = <String, SkillProgress>{};
    for (final entry in raw.entries) {
      try {
        if (entry.key.isNotEmpty && entry.value is Map<String, dynamic>) {
          result[entry.key] =
              SkillProgress.fromJson(entry.value as Map<String, dynamic>);
        }
      } catch (_) {}
    }
    return result;
  }

  /// Awards XP once per lesson and saves the learner's progress locally.
  Future<bool> completeLesson(String lessonId, {int xp = 10}) async {
    if (!_completedLessons.add(lessonId)) return false;
    _qaidaLessonSteps.remove(lessonId);
    _lessonActivityIndex.remove(lessonId);
    _xp += xp;
    _lessonActivity.add('$lessonId|${_todayKey()}');
    notifyListeners();
    await _saveProgress();
    return true;
  }

  /// Record an activity attempt and update per-skill mastery state.
  Future<void> recordActivityAttempt({
    required String skillId,
    required bool isCorrect,
    required String lessonId,
    required int activityIndex,
  }) async {
    if (skillId.isEmpty) return;
    final existing = _skillProgress[skillId];
    final updated = existing != null
        ? existing.copyWith(
            correctAttempts:
                existing.correctAttempts + (isCorrect ? 1 : 0),
            incorrectAttempts:
                existing.incorrectAttempts + (isCorrect ? 0 : 1),
            masteryState: isCorrect
                ? _advanceMastery(existing.masteryState)
                : existing.masteryState,
            revisionPriority: isCorrect
                ? (existing.revisionPriority > 0
                    ? existing.revisionPriority - 1
                    : 0)
                : (existing.revisionPriority + 1).clamp(0, 2),
            lastPracticedAt: DateTime.now(),
          )
        : SkillProgress(
            skillId: skillId,
            correctAttempts: isCorrect ? 1 : 0,
            incorrectAttempts: isCorrect ? 0 : 1,
            masteryState: isCorrect
                ? SkillMasteryState.inProgress
                : SkillMasteryState.notStarted,
            revisionPriority: isCorrect ? 0 : 1,
            lastPracticedAt: DateTime.now(),
          );
    _skillProgress[skillId] = updated;
    _lessonActivityIndex[lessonId] = activityIndex;
    notifyListeners();
    await _saveProgress();
  }

  SkillMasteryState _advanceMastery(SkillMasteryState current) {
    switch (current) {
      case SkillMasteryState.notStarted:
        return SkillMasteryState.inProgress;
      case SkillMasteryState.inProgress:
        return SkillMasteryState.practiceCompleted;
      case SkillMasteryState.practiceCompleted:
        return SkillMasteryState.lessonCheckPassed;
      case SkillMasteryState.lessonCheckPassed:
        return SkillMasteryState.lessonCompleted;
      case SkillMasteryState.lessonCompleted:
        return SkillMasteryState.masteryDeveloping;
      case SkillMasteryState.masteryDeveloping:
        return SkillMasteryState.masteryDemonstrated;
      case SkillMasteryState.masteryDemonstrated:
      case SkillMasteryState.teacherReviewRequired:
        return current;
    }
  }

  /// Record an exam score (Lesson Check, Checkpoint, Track Final).
  Future<void> recordExamScore(String examId, int score) async {
    if (examId.isEmpty || score < 0 || score > 100) return;
    _examScores[examId] = score;
    notifyListeners();
    await _saveProgress();
  }

  /// Save current activity index for resume support.
  Future<void> saveLessonActivityIndex(
      String lessonId, int activityIndex) async {
    if (lessonId.isEmpty || activityIndex < 0) return;
    if (_completedLessons.contains(lessonId)) return;
    _lessonActivityIndex[lessonId] = activityIndex;
    await _saveProgress();
  }

  /// Awards bonus XP when a milestone treasure chest is opened.
  bool openChest(String chestId, {int xp = 25}) {
    if (!_openedChests.add(chestId)) return false;
    _xp += xp;
    notifyListeners();
    _saveProgress();
    return true;
  }

  /// Awards bonus XP directly (e.g. from guardian teach back or bonus mini-games).
  Future<void> addXp(int points) async {
    if (points <= 0) return;
    _xp += points;
    notifyListeners();
    await _saveProgress();
  }

  Future<void> _saveProgress() async {
    final xp = _xp;
    final completedLessons = _completedLessons.toList();
    final lessonActivity = _lessonActivity.toList();
    final openedChests = _openedChests.toList();
    final skillProgressData = {
      for (final e in _skillProgress.entries) e.key: e.value.toJson()
    };
    final progress = jsonEncode({
      'version': 2,
      'xp': xp,
      'completedLessons': completedLessons,
      'lessonActivity': lessonActivity,
      'openedChests': openedChests,
      'qaidaLessonSteps': _qaidaLessonSteps,
      'duaFavorites': _duaFavorites.toList(),
      'quizResults': _quizResults,
      'basicsProgress': _basicsProgress,
      'salahStep': _salahStep,
      'seerahProgress': _seerahProgress,
      'skillProgress': skillProgressData,
      'examScores': _examScores,
      'lessonActivityIndex': _lessonActivityIndex,
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
      if (decoded is Map<String, dynamic> &&
          (decoded['version'] == 1 || decoded['version'] == 2)) {
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

  Map<String, int> _readIntMap(Object? raw) {
    if (raw is! Map) return {};
    return {
      for (final entry in raw.entries)
        if (entry.key is String &&
            (entry.key as String).isNotEmpty &&
            entry.value is int &&
            (entry.value as int) >= 0)
          entry.key as String: entry.value as int,
    };
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

  Future<void> updatePrayerAlertSettings({
    bool? masterEnabled,
    String? prayerKey,
    bool? prayerEnabled,
  }) async {
    if (masterEnabled != null) _prayerAlertsEnabled = masterEnabled;
    if (prayerKey != null && prayerEnabled != null) {
      _prayerAlertToggles[prayerKey] = prayerEnabled;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('prayer_alerts_enabled', _prayerAlertsEnabled);
    await prefs.setString('prayer_alert_toggles', jsonEncode(_prayerAlertToggles));
    notifyListeners();
  }

  Future<void> updateLearningAlarmSettings({
    bool? enabled,
    String? time,
  }) async {
    if (enabled != null) _learningAlarmEnabled = enabled;
    if (time != null) _learningAlarmTime = time;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('learning_alarm_enabled', _learningAlarmEnabled);
    await prefs.setString('learning_alarm_time', _learningAlarmTime);
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
    draftLanguage = _validLang(lang);
    notifyListeners();
  }

  void updateDraftRole(String role) {
    draftRole = role == 'admin' ? 'admin' : 'child';
    notifyListeners();
  }

  void updateDraftAvatar({String? type, int? color}) {
    if (type != null) draftAvatarType = type;
    if (color != null) draftAvatarColor = color;
    notifyListeners();
  }

  Future<void> updateAvatar({String? type, int? color}) async {
    if (type != null) {
      _avatarType = type;
      draftAvatarType = type;
    }
    if (color != null) {
      _avatarColor = color;
      draftAvatarColor = color;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_type', _avatarType);
    await prefs.setInt('avatar_color', _avatarColor);
    notifyListeners();
  }

  int _failedGateAttempts = 0;
  DateTime? _gateLockoutUntil;

  int get failedGateAttempts => _failedGateAttempts;
  bool get isGateLockedOut =>
      _gateLockoutUntil != null && DateTime.now().isBefore(_gateLockoutUntil!);
  int get gateLockoutSecondsRemaining => isGateLockedOut
      ? _gateLockoutUntil!.difference(DateTime.now()).inSeconds + 1
      : 0;

  void recordGateFailure() {
    _failedGateAttempts++;
    if (_failedGateAttempts >= 3) {
      _gateLockoutUntil = DateTime.now().add(const Duration(seconds: 30));
    }
    notifyListeners();
  }

  void recordGateSuccess() {
    _failedGateAttempts = 0;
    _gateLockoutUntil = null;
    notifyListeners();
  }

  AdminElevationToken? _pendingAdminToken;

  void setPendingAdminToken(AdminElevationToken token) {
    _pendingAdminToken = token;
  }

  Future<bool> setUserRole(String role, {AdminElevationToken? token}) async {
    final next = role == 'admin' ? 'admin' : 'child';
    if (next == 'admin') {
      if (token == null || isGateLockedOut) return false;
      recordGateSuccess();
    }
    if (_userRole == next) return true;
    _userRole = next;
    draftRole = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', next);
    notifyListeners();
    return true;
  }

  Future<bool> toggleAdminMode({AdminElevationToken? token}) async {
    if (isAdmin) {
      return setUserRole('child');
    } else {
      return setUserRole('admin', token: token);
    }
  }

  Future<bool> quickAdminEnter({required AdminElevationToken token}) async {
    if (isGateLockedOut) return false;
    draftName = 'Admin';
    draftAge = 10;
    draftRole = 'admin';
    await completeOnboarding(role: 'admin', token: token);
    return true;
  }

  Future<void> updateLanguage(String language) async {
    final nextLanguage = _validLang(language);
    if (_selectedLanguage == nextLanguage) return;
    _selectedLanguage = nextLanguage;
    final targetLang = AppLanguages.byCode(nextLanguage);
    setHtmlLangAndDir(nextLanguage, targetLang?.dirString ?? 'ltr');
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', nextLanguage);
  }

  /// Returns a validated language code; falls back to default if unknown.
  static String _validLang(String? lang) => AppLanguages.validate(lang);

  Future<void> completeOnboarding({String? role, AdminElevationToken? token}) async {
    final tokenToUse = token ?? _pendingAdminToken;
    _pendingAdminToken = null;
    final requestedRole = role ?? (draftRole == 'admin' ? 'admin' : 'child');
    final roleToSave = (requestedRole == 'admin' && tokenToUse != null && !isGateLockedOut)
        ? 'admin'
        : 'child';
    if (roleToSave == 'admin') {
      recordGateSuccess();
    }
    final name = draftName.isNotEmpty
        ? draftName
        : (roleToSave == 'admin' ? 'Admin' : '');
    final age = draftAge;
    final language = _validLang(draftLanguage);

    _avatarType = draftAvatarType;
    _avatarColor = draftAvatarColor;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    await prefs.setString('user_name', name);
    await prefs.setInt('user_age', age);
    await prefs.setString('language', language);
    await prefs.setString('user_role', roleToSave);
    await prefs.setString('avatar_type', _avatarType);
    await prefs.setInt('avatar_color', _avatarColor);
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
    _userRole = roleToSave;
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
    _userRole = 'child';
    draftRole = 'child';
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
    _salahStep = 0;
    _seerahProgress.clear();
    _skillProgress.clear();
    _examScores.clear();
    _lessonActivityIndex.clear();
    draftName = '';
    draftAge = 8;
    draftLanguage = 'bn';
    _isLoaded = true;
    notifyListeners();
  }
}
