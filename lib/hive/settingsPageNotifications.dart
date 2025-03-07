import 'package:hive/hive.dart';

class ToggleStateService {
  static const String periodReminderKey = 'isPeriodReminderOn';
  static const String fertilityReminderKey = 'isFertilityReminderOn';
  static const String lutealReminderKey = 'isLutealReminderOn';

  // Save the state of the toggles
  static Future<void> saveToggleState({
    required bool isPeriodReminderOn,
    required bool isFertilityReminderOn,
    required bool isLutealReminderOn,
  }) async {
    final box = await Hive.openBox('toggleBox');
    await box.put(periodReminderKey, isPeriodReminderOn);
    await box.put(fertilityReminderKey, isFertilityReminderOn);
    await box.put(lutealReminderKey, isLutealReminderOn);
  }

  // Load the state of the toggles
  static Future<Map<String, bool>> loadToggleState() async {
    final box = await Hive.openBox('toggleBox');
    bool isPeriodReminderOn = box.get(periodReminderKey, defaultValue: true);
    bool isFertilityReminderOn = box.get(fertilityReminderKey, defaultValue: true);
    bool isLutealReminderOn = box.get(lutealReminderKey, defaultValue: true);

    return {
      periodReminderKey: isPeriodReminderOn,
      fertilityReminderKey: isFertilityReminderOn,
      lutealReminderKey: isLutealReminderOn,
    };
  }
}
