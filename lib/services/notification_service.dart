import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../utils/app_state.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const int streakReminderNotificationId = 1001;
  static const int classReminderBaseNotificationId = 2000;
  static const int prayerReminderBaseNotificationId = 3000;
  static const int learningAlarmNotificationId = 4001;

  static const String notificationChannelId = 'little_muslim_reminders';
  static const String notificationChannelName = 'LittleMuslim Reminders';
  static const String notificationChannelDescription =
      'Daily learning streak and live class reminder alerts';

  static const String prayerChannelId = 'little_muslim_prayer';
  static const String prayerChannelName = 'নামাজের আযান ও ওয়াক্ত (Prayer Times)';
  static const String prayerChannelDescription =
      'নামাজের ওয়াক্ত হলে আযানের নোটিফিকেশন ও অ্যালার্ট';

  static const String learningAlarmChannelId = 'little_muslim_learning_alarm';
  static const String learningAlarmChannelName = 'পড়ার অ্যালার্ম (আউযুবিল্লাহ ও বিসমিল্লাহ)';
  static const String learningAlarmChannelDescription =
      'দৈনিক কুরআন ও কায়দা পড়ার অ্যালার্ম ও স্মরণিকা';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize plugin, channels, and timezone databases.
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      tz.initializeTimeZones();
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {}

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      final initialized = await _plugin.initialize(initSettings);
      _isInitialized = initialized ?? true;
      return _isInitialized;
    } catch (e) {
      debugPrint('NotificationService: Failed to initialize: $e');
      return false;
    }
  }

  /// Request runtime permissions from the user.
  Future<bool> requestPermissions() async {
    try {
      if (kIsWeb) return false;

      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        final granted = await android.requestNotificationsPermission();
        return granted ?? false;
      }

      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        final granted = await ios.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }

      final macos = _plugin.resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>();
      if (macos != null) {
        final granted = await macos.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    } catch (e) {
      debugPrint('NotificationService: Request permission failed: $e');
    }
    return false;
  }

  /// Synchronize notification schedules with current AppState settings.
  Future<void> syncWithAppState(AppState state) async {
    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) return;
    }

    // 1. Streak Reminder
    if (!state.streakAlertsEnabled) {
      await cancelDailyStreakReminder();
    } else {
      final parts = state.reminderTime.split(':');
      final hour = int.tryParse(parts.first) ?? 19;
      final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

      final isBangla = state.selectedLanguage != 'en';
      final title = isBangla
          ? 'আজকের কায়দা ও দুআ পড়া বাকি আছে!'
          : 'Keep your streak going! Time to learn!';
      final body = isBangla
          ? 'প্রতিদিনের ছোট আমল ও পড়াশোনা নিয়মিত রাখলে স্ট্রিক বাড়ে।'
          : 'Complete your daily lesson to grow your streak and earn XP.';

      await scheduleDailyStreakReminder(
        hour: hour,
        minute: minute,
        title: title,
        body: body,
      );
    }

    // 2. Learning Alarm (Auzubillah & Bismillah)
    if (!state.learningAlarmEnabled) {
      await cancelDailyLearningAlarm();
    } else {
      final parts = state.learningAlarmTime.split(':');
      final hour = int.tryParse(parts.first) ?? 17;
      final minute = int.tryParse(parts.length > 1 ? parts[1] : '30') ?? 30;

      final isBangla = state.selectedLanguage != 'en';
      final title = isBangla
          ? 'পড়ার সময় হয়েছে! — আউযুবিল্লাহ ও বিসমিল্লাহ'
          : 'Time to learn! Recite Auzubillah & Bismillah';
      final body = isBangla
          ? 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ • بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'
          : 'Start your Quran & Qaida reading with blessings!';

      await scheduleDailyLearningAlarm(
        hour: hour,
        minute: minute,
        title: title,
        body: body,
      );
    }
  }

  /// Schedule a recurring daily notification at [hour]:[minute].
  Future<bool> scheduleDailyStreakReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      const androidDetails = AndroidNotificationDetails(
        notificationChannelId,
        notificationChannelName,
        channelDescription: notificationChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
      );
      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      const details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        streakReminderNotificationId,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      return true;
    } catch (e) {
      debugPrint('NotificationService: scheduleDailyStreakReminder failed: $e');
      return false;
    }
  }

  /// Cancel daily streak reminder.
  Future<void> cancelDailyStreakReminder() async {
    try {
      await _plugin.cancel(streakReminderNotificationId);
    } catch (e) {
      debugPrint('NotificationService: cancelDailyStreakReminder failed: $e');
    }
  }

  /// Schedule recurring Daily Learning Alarm (Auzubillah & Bismillah) at [hour]:[minute].
  Future<bool> scheduleDailyLearningAlarm({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      const androidDetails = AndroidNotificationDetails(
        learningAlarmChannelId,
        learningAlarmChannelName,
        channelDescription: learningAlarmChannelDescription,
        importance: Importance.max,
        priority: Priority.max,
      );
      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      const details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        learningAlarmNotificationId,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      return true;
    } catch (e) {
      debugPrint('NotificationService: scheduleDailyLearningAlarm failed: $e');
      return false;
    }
  }

  /// Cancel daily learning alarm.
  Future<void> cancelDailyLearningAlarm() async {
    try {
      await _plugin.cancel(learningAlarmNotificationId);
    } catch (e) {
      debugPrint('NotificationService: cancelDailyLearningAlarm failed: $e');
    }
  }

  /// Schedule a prayer time Adhan notification at [prayerTime].
  Future<bool> schedulePrayerAlert({
    required int prayerIndex,
    required DateTime prayerTime,
    required String prayerName,
    required String arabicName,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      final targetTz = tz.TZDateTime.from(prayerTime, tz.local);
      if (targetTz.isBefore(tz.TZDateTime.now(tz.local))) {
        return false;
      }

      const androidDetails = AndroidNotificationDetails(
        prayerChannelId,
        prayerChannelName,
        channelDescription: prayerChannelDescription,
        importance: Importance.max,
        priority: Priority.max,
      );
      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      const details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      final id = prayerReminderBaseNotificationId + prayerIndex;
      final title = 'ওয়াক্ত হয়েছে: $prayerName ($arabicName)';
      final body = 'আল্লাহু আকবার! নামাজের সময় হয়েছে, ওজু করে সালাতের জন্য প্রস্তুত হও।';

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        targetTz,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return true;
    } catch (e) {
      debugPrint('NotificationService: schedulePrayerAlert failed: $e');
      return false;
    }
  }

  /// Cancel prayer alert for [prayerIndex].
  Future<void> cancelPrayerAlert(int prayerIndex) async {
    try {
      await _plugin.cancel(prayerReminderBaseNotificationId + prayerIndex);
    } catch (e) {
      debugPrint('NotificationService: cancelPrayerAlert failed: $e');
    }
  }

  /// Schedule a class reminder at [scheduledTime].
  Future<bool> scheduleClassReminder({
    required int id,
    required DateTime scheduledTime,
    required String title,
    required String body,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      final targetTz = tz.TZDateTime.from(scheduledTime, tz.local);
      if (targetTz.isBefore(tz.TZDateTime.now(tz.local))) {
        return false;
      }

      const androidDetails = AndroidNotificationDetails(
        notificationChannelId,
        notificationChannelName,
        channelDescription: notificationChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
      );
      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      const details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
        macOS: darwinDetails,
      );

      await _plugin.zonedSchedule(
        classReminderBaseNotificationId + id,
        title,
        body,
        targetTz,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return true;
    } catch (e) {
      debugPrint('NotificationService: scheduleClassReminder failed: $e');
      return false;
    }
  }

  /// Cancel all active notifications.
  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('NotificationService: cancelAll failed: $e');
    }
  }
}
