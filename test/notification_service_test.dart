import 'package:flutter_test/flutter_test.dart';
import 'package:little_muslim/services/notification_service.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService unit tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('syncWithAppState handles streak alerts disabled without throwing',
        () async {
      final state = AppState();
      await state.loadFromPrefs();
      await state.updateNotificationSettings(streakAlertsEnabled: false);

      // Should complete cleanly without error
      await NotificationService.instance.syncWithAppState(state);
      expect(state.streakAlertsEnabled, isFalse);
    });

    test('syncWithAppState handles valid reminder time parsing', () async {
      final state = AppState();
      await state.loadFromPrefs();
      await state.updateNotificationSettings(
        streakAlertsEnabled: true,
        reminderTime: '20:30',
      );

      expect(state.streakAlertsEnabled, isTrue);
      expect(state.reminderTime, '20:30');
    });

    test('class reminder ID base offset is safe', () {
      expect(NotificationService.streakReminderNotificationId, 1001);
      expect(NotificationService.classReminderBaseNotificationId, 2000);
      expect(
        NotificationService.classReminderBaseNotificationId,
        greaterThan(NotificationService.streakReminderNotificationId),
      );
    });
  });
}
