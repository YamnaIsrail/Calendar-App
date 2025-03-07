import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
class WeightProvider with ChangeNotifier {
  double? get latestWeight {
    final weightBox = Hive.box('weightBox');
    final weights = weightBox.get('weights', defaultValue: []) as List;

    if (weights.isNotEmpty) {
      // Safely convert Map<dynamic, dynamic> to Map<String, dynamic>
      final lastEntry = Map<String, dynamic>.from(weights.last as Map);
      return lastEntry['weight'] as double;
    }
    return null;
  }

  DateTime? get latestDate {
    final weightBox = Hive.box('weightBox');
    final weights = weightBox.get('weights', defaultValue: []) as List;

    if (weights.isNotEmpty) {
      // Safely convert Map<dynamic, dynamic> to Map<String, dynamic>
      final lastEntry = Map<String, dynamic>.from(weights.last as Map);
      return DateTime.parse(lastEntry['date'] as String);
    }
    return null;
  }

  void updateLatestWeight(double weight, DateTime date) {
    final weightBox = Hive.box('weightBox');
    final weights = weightBox.get('weights', defaultValue: []) as List;

    Map<String, dynamic> newWeightRecord = {
      'date': date.toIso8601String(),
      'weight': weight,
    };

    weights.add(newWeightRecord);
    weightBox.put('weights', weights);
    notifyListeners();
  }
}