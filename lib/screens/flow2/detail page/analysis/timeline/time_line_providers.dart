
import 'package:calender_app/hive/timeline_entry.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TimelineProvider with ChangeNotifier {
  List<TimelineEntry> _entries = [];
  Box<TimelineEntry>? _timelineBox; // Change this to nullable

  List<TimelineEntry> get entries => _entries;

   Future<void> initialize() async {
    try {
      _timelineBox = await Hive.openBox<TimelineEntry>('timelineBox');
      _entries = _timelineBox?.values.toList() ?? [];
      notifyListeners();
    } catch (e) {
      print('Failed to initialize timeline data: $e');
    }
  }

  /// Add data safely only when `_timelineBox` has been initialized
  void addEntry(TimelineEntry entry) {
    if (_timelineBox != null) {
      _timelineBox!.add(entry);
      _entries.add(entry);
      notifyListeners();
    } else {
      print('Timeline box not initialized yet!');
    }
  }

  Map<String, List<TimelineEntry>> get groupedEntries {
    final groupedData = <String, List<TimelineEntry>>{};

    if (_entries.isNotEmpty) {
      for (var entry in _entries) {
        final dateKey = "${entry.date.year}-${entry.date.month}-${entry.date.day}";
        if (!groupedData.containsKey(dateKey)) {
          groupedData[dateKey] = [];
        }
        groupedData[dateKey]!.add(entry);
      }
    }

    return groupedData;
  }
}

class TimelinexProvider with ChangeNotifier {
  List<TimelineEntry> _entries = [];

  List<TimelineEntry> get entries => _entries;

  void addEntry(TimelineEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  /// Group data by date into a map
  Map<String, List<TimelineEntry>> get groupedEntries {
    Map<String, List<TimelineEntry>> groupedData = {};
    for (var entry in _entries) {
      String dateKey = "${entry.date.year}-${entry.date.month}-${entry.date.day}";
      if (!groupedData.containsKey(dateKey)) {
        groupedData[dateKey] = [];
      }
      groupedData[dateKey]!.add(entry);
    }
    return groupedData;
  }
}
