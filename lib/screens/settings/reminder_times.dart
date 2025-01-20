import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class NotificationTimeService {
  static const String periodTimeKey = 'periodReminderTime';
  static const String fertilityTimeKey = 'fertilityReminderTime';
  static const String lutealTimeKey = 'lutealReminderTime';

  static Future<void> saveNotificationTime({
    required String key,
    required TimeOfDay time,
  }) async {
    final box = await Hive.openBox('timeBox');
    await box.put(key, {'hour': time.hour, 'minute': time.minute});
  }

  static Future<TimeOfDay> loadNotificationTime(String key, TimeOfDay defaultTime) async {
    final box = await Hive.openBox('timeBox');
    final storedTime = box.get(key);
    if (storedTime != null) {
      return TimeOfDay(hour: storedTime['hour'], minute: storedTime['minute']);
    }
    return defaultTime;
  }
}
