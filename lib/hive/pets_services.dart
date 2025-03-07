import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _boxName = 'petBox';
  static const String _key = 'selectedPet';

  // Default pet image
  static const String defaultPet = "assets/pets/panda-01.png";

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);

    // Ensure a default pet is set when the app starts
    var box = Hive.box(_boxName);
    if (!box.containsKey(_key)) {
      await box.put(_key, defaultPet);
    }
  }

  static Future<void> saveSelectedPet(String petImage) async {
    var box = Hive.box(_boxName);
    await box.put(_key, petImage);
  }

  static String getSelectedPet() {
    var box = Hive.box(_boxName);
    return box.get(_key, defaultValue: defaultPet);
  }
}
