import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget.dart';

import '../firebase/user_session.dart';
import '../hive/cycle_model.dart';
import 'package:flutter/foundation.dart';



class CycleProvider with ChangeNotifier {
  // Private fields with default values

  DateTime _lastPeriodStart = DateTime.now();
  int _cycleLength = 28;
  int _periodLength = 5;
  int _lutealPhaseLength = 14;
  bool isNewUser = true; // Flag to check if it's a new user or not

  // Dynamic cycle data
  List<DateTime> periodDays = [];
  List<DateTime> predictedDays = [];
  List<DateTime> fertileDays = [];
  List<DateTime> lutealPhaseDays = [];
  List<String> _symptoms = [];

  // List<DateTime> pastPeriods = [];


  // Getters
  DateTime get lastPeriodStart => _lastPeriodStart;
  int get cycleLength => _cycleLength;
  int get periodLength => _periodLength;
  int get lutealPhaseLength => _lutealPhaseLength;
  List<String> get symptoms => _symptoms;

  List<DateTime> get pastPeriods => pastPeriods;

  List<DateTime> getPeriodDays() => periodDays;
  List<DateTime> getPredictedDays() => predictedDays;
  List<DateTime> getFertileDays() => fertileDays;
  List<DateTime> getLutealPhaseDays() => lutealPhaseDays;

  //USER NAME
  String _userName = ""; // Default name

  // Getter for the user name
  String get userName => _userName;
  void addPeriod(DateTime period) {
    pastPeriods.add(period);  // Add the new period to the list
    notifyListeners();  // Notify listeners that the list has been updated
  }
  // Setter for the user name
  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
    _saveUserNameToHive();
  }

  // Save the name to Hive for persistence
  Future<void> _saveUserNameToHive() async {
    var box = await Hive.openBox<String>('userData');
    await box.put('userName', _userName);
    print("User name saved to Hive.");
  }

  // Load the name from Hive
  Future<void> _loadUserNameFromHive() async {
    var box = await Hive.openBox<String>('userData');
    _userName = box.get('userName', defaultValue: "User")!;
    notifyListeners();
  }


  // Method to calculate luteal phase days
  void _calculateLutealPhaseDays() {
    lutealPhaseDays = List.generate(
      _lutealPhaseLength - 6,
          (index) => _lastPeriodStart.add(
        Duration(days: _cycleLength - _lutealPhaseLength + index),
      ),
    );
  }



  // Singleton instance for MenstrualCycleWidget
  MenstrualCycleWidget? _widget;

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
          (index) =>
          _lastPeriodStart.add(Duration(days: _cycleLength - 14 + index)),
    );

    // Period days (starting from the last period start)
    periodDays = List.generate(
      _periodLength,
          (index) => _lastPeriodStart.add(Duration(days: index)),
    );

    notifyListeners(); // Notify listeners to update the UI
  }


  void updateLutealPhaseLength(int length) {
    if (length <= 0) throw Exception("Luteal phase length must be positive.");
    _lutealPhaseLength = length;

    // Recalculate the ovulation date
    DateTime ovulationDate = _lastPeriodStart.add(Duration(days: _cycleLength - _lutealPhaseLength));

    // Update fertile days
    fertileDays = List.generate(
      6,
          (index) => ovulationDate.subtract(Duration(days: 6 - index)),
    );

    // Update predicted period days
    predictedDays = List.generate(
      _periodLength,
          (index) => _lastPeriodStart.add(Duration(days: _cycleLength + index)),
    );

    // Notify listeners and save updated data
    notifyListeners();
    _saveToHive();
  }


  int get cycleDay {
    if (_lastPeriodStart == null) {
      return 0; // Default to 0 if no last period date is available yet
    }

    // Check if today is the first day of the period
    DateTime today = DateTime.now();
    if (_lastPeriodStart!.year == today.year &&
        _lastPeriodStart!.month == today.month &&
        _lastPeriodStart!.day == today.day) {
      return 1; // Today is the first day of the period, so cycle day is 1
    }

    // If today is not the first day, calculate the cycle day normally
    return today.difference(_lastPeriodStart!).inDays + 1;
  }

// Get current cycle phase
  String get currentPhase {
    if (_cycleLength == null || _periodLength == null) {
      return 'Unknown Phase'; // Return a fallback if data is incomplete
    }

    int cycleDay = this.cycleDay;

    // Check phase based on cycle day
    if (cycleDay <= _periodLength!) {
      return 'Menstrual Phase'; // During menstruation
    } else if (cycleDay <= _cycleLength! - 14) {
      return 'Follicular Phase'; // After menstruation but before ovulation
    } else if (cycleDay <= _cycleLength! - 6) {
      return 'Ovulation Phase'; // Ovulation phase
    } else {
      return 'Luteal Phase'; // After ovulation
    }
  }

  void updateCycleInfo(DateTime lastPeriod, int cycleLength, int periodLength) {
    if (cycleLength <= 0 || periodLength <= 0) {
      throw Exception(
          "Cycle length and period duration must be positive integers.");
    }
    _lastPeriodStart = lastPeriod;
    _cycleLength = cycleLength;
    _periodLength = periodLength;
    _totalCyclesLogged++; // Increment the count
    print("Cycle info updated. Total cycles logged: $_totalCyclesLogged");

    // Recalculate all related cycle data when core data is updated
    _initializeCycleData();
    notifyListeners();

    // Sync updated data with Hive
    _saveToHive();
  }
  // Add new period to past periods

  Future<void> _saveToHive() async {
    List<String> pastPeriodsList = List.generate(5, (index) => DateTime.now().subtract(Duration(days: index * _cycleLength)).toIso8601String()
    );

    CycleData cycleData = CycleData(
      cycleStartDate: _lastPeriodStart.toString(),
      cycleEndDate:
      _lastPeriodStart.add(Duration(days: _cycleLength)).toString(),
      periodLength: _periodLength,
      cycleLength: _cycleLength,
        pastPeriods: pastPeriodsList
    );

    // Open the Hive box
    var box = await Hive.openBox<CycleData>('cycleData');
    await box.put('cycle', cycleData);
    print("Cycle data saved to Hive.");

    saveCycleDataToFirestore();
  }
  Future<void> saveCycleDataToFirestore() async {
    if (await SessionManager.checkUserLoginStatus()) {
      try {
        String? userId = await SessionManager.getUserId();
        if (userId != null) {
          CollectionReference cycles = FirebaseFirestore.instance.collection('cycles');

          List<String> pastPeriodsList = List.generate(5, (index) => DateTime.now().subtract(Duration(days: index * _cycleLength)).toIso8601String());

          await cycles.doc(userId).set({
            'cycleStartDate': _lastPeriodStart.toString(),
            'cycleEndDate': _lastPeriodStart.add(Duration(days: _cycleLength)).toString(),
            'periodLength': _periodLength,
            'cycleLength': _cycleLength,
            'pastPeriods': pastPeriodsList,
          }, SetOptions(merge: true)); // Merge to avoid overwriting data

          print("Cycle data saved to Firebase.");
        }
      } catch (e) {
        print("Error saving cycle data to Firebase: $e");
      }
    } else {
      print("User is not logged in. Cycle data will not be saved to Firebase.");
    }
  }

  void updateCycleLength(int cycleLength) {
    if (cycleLength <= 0) {
      throw Exception("Cycle length must be a positive integer.");
    }
    _cycleLength = cycleLength;

    // Recalculate all related cycle data when cycle length is updated
    _initializeCycleData();
    notifyListeners();

    // Sync updated data with Hive
    _saveToHive();
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

  void updateLastPeriodStart(DateTime lastPeriodStart) {
    _lastPeriodStart = lastPeriodStart;

    // Recalculate all related cycle data when last period start is updated
    _initializeCycleData();
    notifyListeners();

    // Sync updated data with Hive
    _saveToHive();
  }

  void addSymptom(String symptom) {
    _symptoms.add(symptom);
    notifyListeners();
  }

  // Method to initialize and configure the MenstrualCycleWidget
  void initializeCycleWidget() {
    if (_lastPeriodStart == null ||
        _cycleLength == null ||
        _periodLength == null) {
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

  // Fertility and pregnancy chances logic
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

    return currentDate.isAfter(fertileStartDate) &&
        currentDate.isBefore(fertileEndDate);
  }

  Future<void> loadCycleDataFromHive() async {
    var box = await Hive.openBox<CycleData>('cycleData');
    CycleData? cycleData = box.get('cycle');

    if (cycleData != null) {
      // Initialize the provider with data from Hive
      _lastPeriodStart = DateTime.parse(cycleData.cycleStartDate);
      _cycleLength = cycleData.cycleLength!;
      _periodLength = cycleData.periodLength!;

      // Recalculate the cycle data
      _initializeCycleData();
      notifyListeners();
    } else {
      print("No cycle data found in Hive.");
    }
  }
}



class PartnerProvider with ChangeNotifier {
  DateTime? _lastMenstrualPeriod; // No default value
  int? _cycleLength; // No default value
  int? _periodLength; // No default value
  DateTime? _dueDate; // Will be calculated based on the fetched data

  DateTime? get lastMenstrualPeriod => _lastMenstrualPeriod;
  DateTime? get dueDate => _dueDate;
  int? get cycleLength => _cycleLength;
  int? get periodLength => _periodLength;
  List<DateTime> periodDays = [];
  List<DateTime> predictedDays = [];
  List<DateTime> fertileDays = [];

// Modify the method to accept a userId as a parameter
  Future<void> fetchUser1CycleData(String user1Id) async {
    try {
      // Fetch the cycle data for User 1 using their UID
      DocumentSnapshot user1Doc = await FirebaseFirestore.instance
          .collection('cycles')
          .doc(user1Id) // Use the user1Id here
          .get();

      if (user1Doc.exists) {
        var pregnancyData = user1Doc.data() as Map<String, dynamic>;

        // Parse and update the pregnancy data
        DateTime cycleStartDate =
        DateTime.parse(pregnancyData['cycleStartDate']);
        int cycleLength = pregnancyData['cycleLength'];
        int periodLength = pregnancyData['periodLength'];

        _lastMenstrualPeriod = cycleStartDate;
        _cycleLength = cycleLength;
        _periodLength = periodLength;

        _initializeCycleData(); // Initialize cycle data
      } else {
        print("No data found for User 1.");
      }
    } catch (e) {
      print("Error fetching User 1's cycle data: $e");
    }
  }

  // Initialize cycle data (predicted days, fertile days, period days)
  void _initializeCycleData() {
    if (_lastMenstrualPeriod == null ||
        _cycleLength == null ||
        _periodLength == null) {
      print("Cycle data is incomplete.");
      return; // Exit if any required data is null
    }

    // Predict period days (from last period start date)
    predictedDays = List.generate(
      _periodLength!,
      (index) =>
          _lastMenstrualPeriod!.add(Duration(days: _cycleLength! + index)),
    );

    // Fertile window (typically between cycleLength - 14 and cycleLength - 6)
    fertileDays = List.generate(
      _cycleLength! - 14 + 1,
      (index) =>
          _lastMenstrualPeriod!.add(Duration(days: _cycleLength! - 14 + index)),
    );

    // Period days (starting from the last period start)
    periodDays = List.generate(
      _periodLength!,
      (index) => _lastMenstrualPeriod!.add(Duration(days: index)),
    );

    notifyListeners(); // Notify listeners to update the UI
  }

  // Get the current week of pregnancy
  int getCurrentWeek() {
    if (_lastMenstrualPeriod == null) {
      return 0; // Default to 0 if no data is available yet
    }
    return DateTime.now().difference(_lastMenstrualPeriod!).inDays ~/ 7;
  }

  // Get the days until the due date
  int getDaysUntilDueDate() {
    if (_dueDate == null) {
      return 0; // Default to 0 if no due date is available yet
    }
    return _dueDate!.difference(DateTime.now()).inDays;
  }

// Get the current day of the cycle
  int get cycleDay {
    if (_lastMenstrualPeriod == null) {
      return 0; // Default to 0 if no last period date is available yet
    }

    // Check if today is the first day of the period
    DateTime today = DateTime.now();
    if (_lastMenstrualPeriod!.year == today.year &&
        _lastMenstrualPeriod!.month == today.month &&
        _lastMenstrualPeriod!.day == today.day) {
      return 1; // Today is the first day of the period, so cycle day is 1
    }

    // If today is not the first day, calculate the cycle day normally
    return today.difference(_lastMenstrualPeriod!).inDays + 1;
  }

// Get current cycle phase
  String get currentPhase {
    if (_cycleLength == null || _periodLength == null) {
      return 'Unknown Phase'; // Return a fallback if data is incomplete
    }

    int cycleDay = this.cycleDay;

    // Check phase based on cycle day
    if (cycleDay <= _periodLength!) {
      return 'Menstrual Phase'; // During menstruation
    } else if (cycleDay <= _cycleLength! - 14) {
      return 'Follicular Phase'; // After menstruation but before ovulation
    } else if (cycleDay <= _cycleLength! - 6) {
      return 'Ovulation Phase'; // Ovulation phase
    } else {
      return 'Luteal Phase'; // After ovulation
    }
  }

  // Get the number of days elapsed since the last period
  int get daysElapsed {
    if (_lastMenstrualPeriod == null) {
      return 0; // Default to 0 if no last period date is available yet
    }
    return DateTime.now().difference(_lastMenstrualPeriod!).inDays;
  }
}
