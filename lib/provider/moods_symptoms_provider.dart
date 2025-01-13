import 'package:calender_app/hive/timeline_entry.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_entry.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

import '../screens/flow2/detail page/cycle/cycle_page_components/category_grid.dart';

class MoodsProvider with ChangeNotifier {
  MoodsProvider() {
    _initializeHiveBox();
  }

  // Method to initialize the Hive box
  Future<void> _initializeHiveBox() async {
    _visibleMoodsBox = await Hive.openBox('visibleMoods');
    loadVisibleMoods();  // Load the visible moods after initialization
  }

  final List<Map<String, String>> _recentMoods = [];
  final Set<String> _selectedMoods = {};

  // Hive Box for visible moods
  late Box _visibleMoodsBox;

  List<Map<String, String>> get recentMoods => _recentMoods;

  bool isSelected(String label) => _selectedMoods.contains(label);


  void addMood(BuildContext context, String iconPath, String label) {
    if (_selectedMoods.contains(label)) {
      _recentMoods.removeWhere((item) => item['label'] == label);
      _selectedMoods.remove(label);
      // final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
      // timelineProvider.removeEntry(label); // Remove from timeline
    } else {
      _recentMoods.add({'iconPath': iconPath, 'label': label});
      _selectedMoods.add(label);
      final moodEntry = TimelineEntry(
        id: DateTime
            .now()
            .millisecondsSinceEpoch,
        type: 'Mood',
        details: {'You Feel': label},
      );
      final timelineProvider = Provider.of<TimelineProvider>(
          context, listen: false);
      timelineProvider.addEntry(moodEntry, context); // Add to timeline
    }
    notifyListeners();
  }

  // Load visible moods from Hive
  Future<void> loadVisibleMoods() async {
    _visibleMoodsBox = await Hive.openBox('visibleMoods');

    List<String> visibleMoods = List<String>.from(_visibleMoodsBox.get('visibleMoods', defaultValue: []));
    _visibleMoods.clear();
    _visibleMoods.addAll(visibleMoods);
    notifyListeners();
  }

  // Save visible moods to Hive
  Future<void> _saveVisibleMoods() async {
    await _visibleMoodsBox.put('visibleMoods', _visibleMoods);
  }

  final List<String> _visibleMoods = [];

  List<String> get visibleMoods => _visibleMoods;

  bool isMoodVisible(String label) => _visibleMoods.contains(label);

  void addVisibleMood(String label) {
    if (!_visibleMoods.contains(label)) {
      _visibleMoods.add(label);
      _saveVisibleMoods();  // Sync with Hive
      notifyListeners();
    }
  }

  void removeVisibleMood(String label) {
    _visibleMoods.remove(label);
    _saveVisibleMoods();  // Sync with Hive
    notifyListeners();
  }

  void initializeVisibleMoods(List<String> allLabels) {
    _visibleMoods.clear();
    _visibleMoods.addAll(allLabels);
    _saveVisibleMoods();  // Sync with Hive
    notifyListeners();
  }
}


class SymptomsProvider with ChangeNotifier {
  SymptomsProvider() {
    _initializeHiveBox();
  }

  // Method to initialize the Hive box
  Future<void> _initializeHiveBox() async {
    _visibleSymptomsBox = await Hive.openBox('visibleMoods');
    loadVisibleSymptoms();  // Load the visible moods after initialization
  }

  final List<Map<String, String>> _recentSymptoms = [];
  final Set<String> _selectedSymptoms = {};

  // Hive Box for visible symptoms
  late Box _visibleSymptomsBox;

  List<Map<String, String>> get recentSymptoms => _recentSymptoms;

  bool isSelected(String label) => _selectedSymptoms.contains(label);

  void addSymptom(BuildContext context, String iconPath, String label) {
    if (_selectedSymptoms.contains(label)) {
      _recentSymptoms.removeWhere((item) => item['label'] == label);
      _selectedSymptoms.remove(label);
      // final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
      // timelineProvider.removeEntry(label); // Remove from timeline
    } else {
      _recentSymptoms.add({'iconPath': iconPath, 'label': label});
      _selectedSymptoms.add(label);
      final symptomEntry = TimelineEntry(
        id: DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
        type: 'Symptom',
        details: {'You feel': label},
      );
      final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
      timelineProvider.addEntry(symptomEntry, context); // Add to timeline
    }
    notifyListeners();
  }
  // void addSymptom(BuildContext context, String iconPath, String label) {
  //   if (_selectedSymptoms.contains(label)) {
  //     _recentSymptoms.removeWhere((item) => item['label'] == label);
  //     _selectedSymptoms.remove(label);
  //   } else {
  //     _recentSymptoms.add({'iconPath': iconPath, 'label': label});
  //     _selectedSymptoms.add(label);
  //     // Add to timeline or other logic if needed
  //   }
  //   notifyListeners();
  // }

  // Load visible symptoms from Hive
  Future<void> loadVisibleSymptoms() async {
    _visibleSymptomsBox = await Hive.openBox('visibleSymptoms');
    List<String> visibleSymptoms = List<String>.from(_visibleSymptomsBox.get('visibleSymptoms', defaultValue: []));

    _visibleSymptoms.clear();
    _visibleSymptoms.addAll(visibleSymptoms);
    notifyListeners();
  }

  // Save visible symptoms to Hive
  Future<void> _saveVisibleSymptoms() async {
    await _visibleSymptomsBox.put('visibleSymptoms', _visibleSymptoms);
  }

  final List<String> _visibleSymptoms = [];

  List<String> get visibleSymptoms => _visibleSymptoms;
  bool isSymptomVisible(String label) => _visibleSymptoms.contains(label);

  void addVisibleSymptom(String label) {
    if (!_visibleSymptoms.contains(label)) {
      _visibleSymptoms.add(label);
      _saveVisibleSymptoms();  // Sync with Hive
      notifyListeners();
    }
  }

  void removeVisibleSymptom(String label) {
    _visibleSymptoms.remove(label);
    _saveVisibleSymptoms();  // Sync with Hive
    notifyListeners();
  }

  // void initializeVisibleSymptoms(List<String> allLabels) {
  //   _visibleSymptoms.clear();
  //   _visibleSymptoms.addAll(allLabels);
  //   _saveVisibleSymptoms();  // Sync with Hive
  //   notifyListeners();
  // }
  //
  void initializeVisibleSymptoms(List<String> symptoms) {
    if (visibleSymptoms.isEmpty) {
      visibleSymptoms.addAll(symptoms);
    }
    _saveVisibleSymptoms();
    notifyListeners();

  }
}

class SymptomService {
  static const symptomFolders = ['head', 'body', 'cervix', 'fluid', 'abdomen', 'mental'];

  static Future<List<CategoryItem>> loadAllSymptoms() async {
    List<CategoryItem> allSymptoms = [];
    for (String folder in symptomFolders) {
      final symptoms = await loadCategoryItems(folder);
      allSymptoms.addAll(symptoms);
    }
    return allSymptoms;
  }
}
