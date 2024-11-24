import 'package:flutter/material.dart';

class SymptomsProvider with ChangeNotifier {
  final List<Map<String, String>> _recentSymptoms = [];
  final Set<String> _selectedSymptoms = {};

  List<Map<String, String>> get recentSymptoms => _recentSymptoms;

  bool isSelected(String label) => _selectedSymptoms.contains(label);

  void addSymptom(String iconPath, String label) {
    if (!_recentSymptoms.any((item) => item['label'] == label)) {
      _recentSymptoms.add({'iconPath': iconPath, 'label': label});
      _selectedSymptoms.add(label);
      notifyListeners();
    }
  }
}

class MoodsProvider with ChangeNotifier {
  final List<Map<String, String>> _recentMoods = [];
  final Set<String> _selectedMoods = {};

  List<Map<String, String>> get recentMoods => _recentMoods;

  bool isSelected(String label) => _selectedMoods.contains(label);

  void addMood(String iconPath, String label) {
    if (!_recentMoods.any((item) => item['label'] == label)) {
      _recentMoods.add({'iconPath': iconPath, 'label': label});
      _selectedMoods.add(label);
      notifyListeners();
    }
  }
}
