import 'package:flutter/material.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget.dart';


class CycleProvider with ChangeNotifier {
  DateTime _lastPeriodStart = DateTime.now();
  int _cycleLength = 28; // Default cycle length in days
  int _periodLength = 5; // Default period duration in days
  List<String> _symptoms = []; // User's logged symptoms

  DateTime get lastPeriodStart => _lastPeriodStart;
  int get cycleLength => _cycleLength;
  int get periodLength => _periodLength;
  List<String> get symptoms => _symptoms;

  // Update cycle info
  void updateCycleInfo(DateTime lastPeriod, int cycleLength, int periodLength) {
    _lastPeriodStart = lastPeriod;
    _cycleLength = cycleLength;
    _periodLength = periodLength;
    notifyListeners();
  }

  // Add a symptom
  void addSymptom(String symptom) {
    _symptoms.add(symptom);
    notifyListeners();
  }

  // Get next period date
  DateTime getNextPeriodDate() {
    return _lastPeriodStart.add(Duration(days: _cycleLength));
  }

  // Days until next period
  int getDaysUntilNextPeriod() {
    return getNextPeriodDate().difference(DateTime.now()).inDays;
  }

  // Initialize the menstrual cycle widget
  MenstrualCycleWidget initializeCycleWidget() {
    if (_lastPeriodStart == null || _cycleLength == null || _periodLength == null) {
      throw Exception("Cycle information is not properly initialized");
    }

    // Initialize the MenstrualCycleWidget with proper initialization
    MenstrualCycleWidget widget = MenstrualCycleWidget.init(
      secretKey: "11a1215l0119a140409p0919",
      ivKey: "23a1dfr5lyhd9a1404845001",
    );

    // Update the cycle info in the widget
    widget.updateConfiguration(
      cycleLength: _cycleLength,
      periodDuration: _periodLength,
      lastPeriodDate: _lastPeriodStart,
    );

    // Return the initialized widget
    return widget;
  }
}
