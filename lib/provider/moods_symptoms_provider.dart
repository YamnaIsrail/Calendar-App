import 'package:calender_app/hive/timeline_entry.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_entry.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SymptomsProvider with ChangeNotifier {
  final List<Map<String, String>> _recentSymptoms = [];
  final Set<String> _selectedSymptoms = {};

  List<Map<String, String>> get recentSymptoms => _recentSymptoms;

  bool isSelected(String label) => _selectedSymptoms.contains(label);

  void addSymptom(BuildContext context, String iconPath, String label) {
    if (_selectedSymptoms.contains(label)) {
      _recentSymptoms.removeWhere((item) => item['label'] == label);
      _selectedSymptoms.remove(label);
      final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
      timelineProvider.removeEntry(label); // Remove from timeline
    } else {
      _recentSymptoms.add({'iconPath': iconPath, 'label': label});
      _selectedSymptoms.add(label);
      final symptomEntry = TimelineEntry(
        id: DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
        type: 'Symptom',
        details: {'You feel': label},
      );
      final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
      timelineProvider.addEntry(symptomEntry); // Add to timeline
    }
    notifyListeners();
  }

}

class MoodsProvider with ChangeNotifier {
  final List<Map<String, String>> _recentMoods = [];
  final Set<String> _selectedMoods = {};

  List<Map<String, String>> get recentMoods => _recentMoods;

  bool isSelected(String label) => _selectedMoods.contains(label);
  void addMood(BuildContext context, String iconPath, String label) {
    if (_selectedMoods.contains(label)) {
      _recentMoods.removeWhere((item) => item['label'] == label);
      _selectedMoods.remove(label);
      final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
      timelineProvider.removeEntry(label); // Remove from timeline
    } else {
      _recentMoods.add({'iconPath': iconPath, 'label': label});
      _selectedMoods.add(label);
      final moodEntry = TimelineEntry(
        id: DateTime.now().millisecondsSinceEpoch,
        type: 'Mood',
        details: {'You Feel': label},
      );
      final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
      timelineProvider.addEntry(moodEntry); // Add to timeline
    }
    notifyListeners();
  }

  // void addMood(BuildContext context, String iconPath, String label) {
  //   if (!_recentMoods.any((item) => item['label'] == label)) {
  //     _recentMoods.add({'iconPath': iconPath, 'label': label});
  //     _selectedMoods.add(label);
  //     // Map the mood to a TimelineEntry and send to TimelineProvider
  //     final moodEntry = TimelineEntry(
  //       id: DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
  //       type: 'Mood',
  //       details: {'You Feel': label},
  //     );
  //     // Correctly access the provider via context
  //    final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
  //      timelineProvider.addEntry(moodEntry);
  //
  //     notifyListeners();
  //   }
  // }


}
