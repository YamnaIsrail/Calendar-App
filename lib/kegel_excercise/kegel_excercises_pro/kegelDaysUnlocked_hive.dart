import 'package:hive/hive.dart';
class KegelStorage {
  static Box? _box;

  // Ensure the box is initialized
  static Future<void> init() async {
    _box ??= await Hive.openBox('kegel_storage');
  }
  // Get the unlocked day with null check
  static int get unlockedDay {
    if (_box == null) {
      throw Exception('Hive box is not initialized');
    }
    return _box!.get('unlockedDay', defaultValue: 1); // Default to Day 1 unlocked
  }

  static Future<int> getUnlockedDay() async {
    await init(); // Ensure initialization
    return _box!.get('unlockedDay', defaultValue: 1);
  }

  static Future<void> setUnlockedDay(int day) async {
    await init(); // Ensure initialization
    _box!.put('unlockedDay', day);
  }



  // New methods to track repetitions for each day
  static Future<int> getRepetitionsForDay(int day) async {
    await init();
    return _box!.get('repetitions_day_$day', defaultValue: 3); // Default to 3 repetitions
  }

  static Future<void> setRepetitionsForDay(int day, int repetitions) async {
    await init();
    _box!.put('repetitions_day_$day', repetitions);
  }

  // New methods to track completed repetitions for each day
  static Future<int> getCompletedRepetitionsForDay(int day) async {
    await init();
    return _box!.get('completed_repetitions_day_$day', defaultValue: 1);
  }

  static Future<void> incrementCompletedRepetitionsForDay(int day) async {
    await init();
    int currentCount = await getCompletedRepetitionsForDay(day);
    _box!.put('completed_repetitions_day_$day', currentCount + 1);
  }

  static Future<void> resetCompletedRepetitionsForDay(int day) async {
    await init();
    _box!.put('completed_repetitions_day_$day', 1);
  }

}
