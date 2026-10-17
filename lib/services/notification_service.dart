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
  static const String notificationChannelId = 'little_muslim_reminders';
  static const String notificationChannelName = 'LittleMuslim Reminders';
  static const String notificationChannelDescription =
      'Daily learning streak and live class reminder alerts';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize plugin, channels, and timezone databases.
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      tz.initializeTimeZones();

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

    if (!state.streakAlertsEnabled) {
      await cancelDailyStreakReminder();
      return;
    }

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
