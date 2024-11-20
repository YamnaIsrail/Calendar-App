import 'package:flutter/material.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget.dart';

class CycleProvider with ChangeNotifier {
  // Private fields with default values
  DateTime _lastPeriodStart = DateTime.now();
  int _cycleLength = 28; // Default cycle length in days
  int _periodLength = 5; // Default period duration in days
  List<String> _symptoms = []; // User's logged symptoms

  // Dynamic cycle data
  List<DateTime> periodDays = [];
  List<DateTime> predictedDays = [];
  List<DateTime> fertileDays = [];

  // Singleton instance for MenstrualCycleWidget
  MenstrualCycleWidget? _widget;

  // Getters to expose private fields
  DateTime get lastPeriodStart => _lastPeriodStart;
  int get cycleLength => _cycleLength;
  int get periodLength => _periodLength;
  List<String> get symptoms => _symptoms;

  MenstrualCycleWidget get cycleWidget {
    _widget ??= MenstrualCycleWidget.init(
      secretKey: "11a1215l0119a140409p0919",
      ivKey: "23a1dfr5lyhd9a1404845001",
    );
    return _widget!;
  }

  int _totalCyclesLogged = 0; // Tracks the total number of cycles logged

// Getter for accessing the total cycles logged
  int get totalCyclesLogged => _totalCyclesLogged;


  // Calculate the number of days elapsed since the last period
  int get daysElapsed {
    return DateTime.now().difference(_lastPeriodStart).inDays;
  }

  // Calculate the next period date
  DateTime getNextPeriodDate() {
    return _lastPeriodStart.add(Duration(days: _cycleLength));
  }

  // Calculate days until the next period
  int getDaysUntilNextPeriod() {
    return getNextPeriodDate().difference(DateTime.now()).inDays;
  }

  // Initialize and calculate all dynamic cycle data
  void _initializeCycleData() {
    // Predict period days (from last period start date)
    predictedDays = List.generate(
      _periodLength,
          (index) => _lastPeriodStart.add(Duration(days: _cycleLength + index)),
    );

    // Fertile window (typically between cycleLength - 14 and cycleLength - 6)
    fertileDays = List.generate(
      _cycleLength - 14 + 1,
          (index) => _lastPeriodStart.add(Duration(days: _cycleLength - 14 + index)),
    );

    // Period days (starting from the last period start)
    periodDays = List.generate(
      _periodLength,
          (index) => _lastPeriodStart.add(Duration(days: index)),
    );

    notifyListeners(); // Notify listeners to update the UI
  }

  // Method to update cycle info with validation
  void updateCycleInfo(DateTime lastPeriod, int cycleLength, int periodLength) {
    if (cycleLength <= 0 || periodLength <= 0) {
      throw Exception("Cycle length and period duration must be positive integers.");
    }
    _lastPeriodStart = lastPeriod;
    _cycleLength = cycleLength;
    _periodLength = periodLength;
    _totalCyclesLogged++; // Increment the count
    print("Cycle info updated. Total cycles logged: $_totalCyclesLogged");


    // Recalculate all related cycle data when core data is updated
    _initializeCycleData();
    notifyListeners();
  }

  // Method to update only the cycle length
  void updateCycleLength(int cycleLength) {
    if (cycleLength <= 0) {
      throw Exception("Cycle length must be a positive integer.");
    }
    _cycleLength = cycleLength;

    // Recalculate all related cycle data when cycle length is updated
    _initializeCycleData();
    notifyListeners();
  }

  // Method to update only the period length
  void updatePeriodLength(int periodLength) {
    if (periodLength <= 0) {
      throw Exception("Period length must be a positive integer.");
    }
    _periodLength = periodLength;

    // Recalculate all related cycle data when period length is updated
    _initializeCycleData();
    notifyListeners();
  }

  // Method to update only the last period start date
  void updateLastPeriodStart(DateTime lastPeriodStart) {
    _lastPeriodStart = lastPeriodStart;

    // Recalculate all related cycle data when last period start is updated
    _initializeCycleData();
    notifyListeners();
  }

  // Method to add a symptom
  void addSymptom(String symptom) {
    _symptoms.add(symptom);
    notifyListeners();
  }

  // Method to initialize and configure the MenstrualCycleWidget
  void initializeCycleWidget() {
    if (_lastPeriodStart == null || _cycleLength == null || _periodLength == null) {
      throw Exception("Cycle information is not properly initialized.");
    }

    // Update the cycle info in the widget
    cycleWidget.updateConfiguration(
      cycleLength: _cycleLength,
      periodDuration: _periodLength,
      lastPeriodDate: _lastPeriodStart,
    );
  }

  // Method to get the fertile window days (usually between cycleLength - 14 and cycleLength - 6)
  List<DateTime> get fertileDaysRange {
    return fertileDays;
  }

  // Method to get predicted period days (usually cycleLength + lastPeriodStart)
  List<DateTime> get predictedPeriodDays {
    return predictedDays;
  }

  // Method to update dynamic cycle data
  void updateCycleData({
    required DateTime lastPeriodStart,
    required int cycleLength,
    required int periodLength,
  }) {
    // Update the cycle data and recalculate all related information
    _lastPeriodStart = lastPeriodStart;
    _cycleLength = cycleLength;
    _periodLength = periodLength;

    _initializeCycleData();
    notifyListeners();
  }



  Fertility and pregnancy chances logic
  String getPregnancyChance(int day) {
    if (fertileDays.contains(periodDays[day])) {
      return 'High Chance of Pregnancy';
    } else if (day < _cycleLength - 14 || day > _cycleLength - 6) {
      return 'Low Chance of Pregnancy';
    } else {
      return 'Medium Chance of Pregnancy';
    }
  }


  bool isInFertileWindow() {
    DateTime currentDate = DateTime.now();
    DateTime fertileStartDate = fertileDays.first;
    DateTime fertileEndDate = fertileDays.last;

    return currentDate.isAfter(fertileStartDate) && currentDate.isBefore(fertileEndDate);
  }
}
