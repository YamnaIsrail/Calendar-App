import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:calender_app/hive/timeline_entry.dart';

class TimelineProvider extends ChangeNotifier {
  List<TimelineEntry> _entries = [];
  late Box<TimelineEntry> _timelineBox;
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  TimelineProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    _timelineBox = await Hive.openBox<TimelineEntry>('timeline');
    _entries = _timelineBox.values.toList();
    _isLoading = false;

    notifyListeners();
  }

  List<TimelineEntry> get entries => List.unmodifiable(_entries);

  Future<void> addEntry(TimelineEntry entry) async {
    _entries.add(entry);
    await _timelineBox.add(entry);
    notifyListeners();
  }

  void deleteEntry(int id) {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index != -1) {
      _timelineBox.deleteAt(index);
      _entries.removeAt(index);
      notifyListeners();
    }
  }
}

// class TimelineProvider extends ChangeNotifier {
//   List<TimelineEntry> _entries = [];
//   late Box<TimelineEntry> _timelineBox;
//
//   Future<void> init() async {
//     // Open the box for timeline entries
//     _timelineBox = await Hive.openBox<TimelineEntry>('timeline');
//     _entries = _timelineBox.values.toList();
//     notifyListeners();
//   }
//
//   List<TimelineEntry> get entries => List.unmodifiable(_entries);
//
//   Future<void> addEntry(TimelineEntry entry) async {
//     init();
//     _entries.add(entry);
//     await _timelineBox.add(entry); // Save the entry to Hive
//     notifyListeners();
//   }
//
//   void deleteEntry(int id) {
//     final index = _entries.indexWhere((entry) => entry.id == id);
//     if (index != -1) {
//       _timelineBox.deleteAt(index);
//       _entries.removeAt(index);
//       notifyListeners();
//     }
//   }
// }
