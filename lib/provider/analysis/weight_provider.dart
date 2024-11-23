import 'package:flutter/material.dart';

class WeightProvider with ChangeNotifier {
  List<Map<String, dynamic>> _weightData = [];

  // Getter for weight data
  List<Map<String, dynamic>> get weightData => _weightData;

  // Method to add weight data
  void addWeightData(double weight) {
    _weightData.add({
      'date': DateTime.now(),
      'weight': weight,
    });
    notifyListeners();
  }

  // Method to get the last weight and date
  Map<String, dynamic>? getLastWeightData() {
    if (_weightData.isNotEmpty) {
      _weightData.sort((a, b) => b['date'].compareTo(a['date'])); // Sort by latest date
      return _weightData.first;
    }
    return null;
  }
}
