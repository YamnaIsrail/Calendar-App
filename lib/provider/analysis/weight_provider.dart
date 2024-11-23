import 'package:flutter/material.dart';

class WeightProvider with ChangeNotifier {
  List<Map<String, dynamic>> _weightData = [];

  List<Map<String, dynamic>> get weightData => _weightData;

  // Add new weight data
  void addWeightData(double weight) {
    final newWeightData = {
      'date': DateTime.now(),
      'weight': weight,
    };
    _weightData.add(newWeightData);
    notifyListeners();
  }

  // Get last weight data for the week
  Map<String, dynamic>? getLastWeightData() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 7));
    final lastWeekData = _weightData.where((entry) {
      DateTime entryDate = entry['date'];
      return entryDate.isAfter(weekStart) && entryDate.isBefore(now);
    }).toList();
    return lastWeekData.isNotEmpty ? lastWeekData.last : null;
  }
}
