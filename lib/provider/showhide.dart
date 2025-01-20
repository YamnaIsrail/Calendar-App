import 'package:flutter/material.dart';

// class ShowHideProvider with ChangeNotifier {
//   // Manage visibility states as a map
//   Map<String, bool> _visibilityMap = {
//     'Intercourse Option': true,
//     'Condom Option': true,
//     'Chance of getting pregnant': true,
//     'Ovulation / Fertile': true,
//     'Future Period': true,
//     'Contraceptive Medicine': true,
//   };
//
//   Map<String, bool> get visibilityMap => _visibilityMap;
//
//   // Toggle visibility for each section
//   void toggleVisibility(String title) {
//     if (_visibilityMap.containsKey(title)) {
//       _visibilityMap[title] = !_visibilityMap[title]!;
//       notifyListeners();
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShowHideProvider with ChangeNotifier {
  // The Hive box to store the visibility states
  late Box<bool> _visibilityBox;

  // Default visibility map
  final Map<String, bool> defaultVisibilityMap = {
    'Intercourse Option': true,
    'Condom Option': true,
    'Chance of getting pregnant': true,
    'Ovulation / Fertile': true,
    'Future Period': true,
    'Contraceptive Medicine': true,
  };

  // Getter for visibility map
  Map<String, bool> get visibilityMap {
    final visibilityMap = <String, bool>{};
    for (var entry in defaultVisibilityMap.entries) {
      visibilityMap[entry.key] = _visibilityBox.get(entry.key, defaultValue: entry.value)!;
    }
    return visibilityMap;
  }

  // Initialize Hive and open the box
  Future<void> initialize() async {
    // Open the box to store visibility states
    _visibilityBox = await Hive.openBox<bool>('visibilityBox');
    // Initialize the box with default values if it's empty
    if (_visibilityBox.isEmpty) {
      defaultVisibilityMap.forEach((key, value) {
        _visibilityBox.put(key, value);
      });
    }
    notifyListeners();
  }

  // Toggle visibility for each section
  void toggleVisibility(String title) {
    if (_visibilityBox.containsKey(title)) {
      bool currentVisibility = _visibilityBox.get(title)!;
      _visibilityBox.put(title, !currentVisibility);
      notifyListeners();
    }
  }
}
