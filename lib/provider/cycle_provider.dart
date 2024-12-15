import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget.dart';
import 'package:provider/provider.dart';
import '../firebase/user_session.dart';
import '../hive/cycle_model.dart';
import 'package:flutter/foundation.dart';

class CycleProvider with ChangeNotifier {
  late BuildContext _context;

  DateTime _lastPeriodStart = DateTime.now();
  int _cycleLength = 28;
  int _periodLength = 5;
  int _lutealPhaseLength = 14;
  bool isNewUser = true; // Flag to check if it's a new user or not
  List<Map<String, String>> _pastPeriods = [];  // Store all past period start dates as strings

  // Dynamic cycle data
  List<DateTime> periodDays = [];
  List<DateTime> predictedDays = [];
  List<DateTime> fertileDays = [];
  List<DateTime> lutealPhaseDays = [];
  List<String> _symptoms = [];


  // Getters
  List<Map<String, String>> get pastPeriods => _pastPeriods;
  DateTime get lastPeriodStart => _lastPeriodStart;
  int get cycleLength => _cycleLength;
  int get periodLength => _periodLength;
  int get lutealPhaseLength => _lutealPhaseLength;
  List<String> get symptoms => _symptoms;


  List<DateTime> getPeriodDays() => periodDays;
  List<DateTime> getPredictedDays() => predictedDays;
  List<DateTime> getFertileDays() => fertileDays;
  List<DateTime> getLutealPhaseDays() => lutealPhaseDays;

  //USER NAME
  String _userName = "Default User"; // Default name
  String get userName => _userName;
  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
    _saveUserNameToHive();
  }
  Future<void> _saveUserNameToHive() async {
    var box = await Hive.openBox<String>('userData');
    await box.put('userName', _userName);
    print("User name saved to Hive.");
  }
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

  int _totalCyclesLogged = 0;
  int get totalCyclesLogged => _totalCyclesLogged;
  void addPastPeriod(DateTime startDate, DateTime endDate) {
    String startDateStr = startDate.toIso8601String();
    String endDateStr = endDate.toIso8601String();

    // Check if the period with the same start date already exists
    int existingPeriodIndex = _pastPeriods.indexWhere((period) =>
    period['startDate'] == startDateStr);

    if (existingPeriodIndex != -1) {
      // Update the existing period's end date
      _pastPeriods[existingPeriodIndex]['endDate'] = endDateStr;
      print("Period updated: Start: $startDateStr, End: $endDateStr");
    } else {
      // Add a new period if none exists
      _pastPeriods.add({'startDate': startDateStr, 'endDate': endDateStr});
      print("New period added: Start: $startDateStr, End: $endDateStr");
    }

    _saveToHive(); // Sync with Hive storage
    notifyListeners(); // Notify listeners to update UI
  }


  void removePastPeriod(String startDate) {
    pastPeriods.removeWhere((period) => period['startDate'] == startDate);
    notifyListeners();
  }

  void addPastPeriodsFromFirestore(List<Map<String, String>> newPeriods) {
    for (var newPeriod in newPeriods) {
      String startDateStr = newPeriod['startDate']!;
      String endDateStr = newPeriod['endDate']!;

      if (!_pastPeriods.any((period) =>
      period['startDate'] == startDateStr && period['endDate'] == endDateStr)) {
        _pastPeriods.add(newPeriod);
        print("Added new period: Start: $startDateStr, End: $endDateStr");
      } else {
        print("Period already exists: Start: $startDateStr, End: $endDateStr");
      }
    }

    // Notify listeners to update the UI
    notifyListeners();
  }

  Future<void> retrieveCycleDataFromFirestore(BuildContext context) async {
    try {
      String? userId = await SessionManager.getUserId();
      if (userId == null) {
        print("User is not logged in.");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User not logged in. Please log in first.")));
        return;
      }

      var data = await FirebaseFirestore.instance
          .collection('cycles')
          .doc(userId)
          .get();

      if (data.exists) {
        // Retrieve data from Firestore
        int? fetchedCycleLength = data['cycleLength'];
        int? fetchedPeriodLength = data['periodLength'];
        DateTime? fetchedLastPeriodStart =
        data['cycleStartDate'] != null ? DateTime.parse(data['cycleStartDate']) : null;

        List<String> restoredPastPeriods = [];
        if (data['pastPeriods'] != null) {
          List<String> pastPeriodsFromFirestore = List<String>.from(data['pastPeriods'] ?? []);
          restoredPastPeriods.addAll(pastPeriodsFromFirestore);
        }

        // Update the provider with the fetched periods
        final provider = Provider.of<CycleProvider>(context, listen: false);
        provider.addPastPeriodsFromFirestore(restoredPastPeriods.cast<Map<String, String>>());

        // Show popup to ask the user if they want to update the cycle details
        showDialog(
          context: context,
          builder: (BuildContext context) {
            bool updateCycleLength = false;
            bool updatePeriodLength = false;
            bool updateLastPeriodStart = false;

            return AlertDialog(
              title: Text("Update Cycle Details"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (fetchedCycleLength != null)
                    Row(
                      children: [
                        Expanded(child: Text("Update Cycle Length?")),
                        Switch(
                          value: updateCycleLength,
                          onChanged: (value) {
                            updateCycleLength = value;
                          },
                        ),
                      ],
                    ),
                  if (fetchedPeriodLength != null)
                    Row(
                      children: [
                        Expanded(child: Text("Update Period Length?")),
                        Switch(
                          value: updatePeriodLength,
                          onChanged: (value) {
                            updatePeriodLength = value;
                          },
                        ),
                      ],
                    ),
                  if (fetchedLastPeriodStart != null)
                    Row(
                      children: [
                        Expanded(child: Text("Update Last Period Start?")),
                        Switch(
                          value: updateLastPeriodStart,
                          onChanged: (value) {
                            updateLastPeriodStart = value;
                          },
                        ),
                      ],
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                CustomButton(
                    backgroundColor: primaryColor,
                    onPressed: () {
                      if (updateCycleLength && fetchedCycleLength != null) {
                        provider.updateCycleLength(fetchedCycleLength);
                      }
                      if (updatePeriodLength && fetchedPeriodLength != null) {
                        provider.updatePeriodLength(fetchedPeriodLength);
                      }
                      if (updateLastPeriodStart && fetchedLastPeriodStart != null) {
                        provider.updateLastPeriodStart(fetchedLastPeriodStart);
                      }

                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cycle data updated successfully!")),
                      );
                    },
                    text: "Submit"
                ),
              ],
            );
          },
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No cycle data found for your account.")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred while fetching data.")));
    }
  }

  void logCycle(String cycleStartDate) {
    // Create a new period map with start and end dates
    String formattedStartDate = cycleStartDate;
    String formattedEndDate = DateTime.parse(formattedStartDate).add(Duration(days: _periodLength)).toIso8601String();
    Map<String, String> newCyclePeriod = {
      'startDate': formattedStartDate,
      'endDate': formattedEndDate,
    };

    // Only add the new period if it doesn't already exist
    if (!_pastPeriods.any((period) =>
    period['startDate'] == newCyclePeriod['startDate'] && period['endDate'] == newCyclePeriod['endDate'])) {
      _pastPeriods.add(newCyclePeriod);
      _totalCyclesLogged++;

      // Sync the changes with Hive and Firestore
      _saveToHive();  // Save to Hive
      saveCycleDataToFirestore();  // Save to Firestore

      // Notify listeners to update the UI
      notifyListeners();
    }
  }

  void initialize(BuildContext context) {
    _context = context;
    notifyListeners();
  }

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
    return getNextPeriodDate().difference(DateTime.now()).inDays+1;
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

  void updateCycleInfo(
      DateTime lastPeriod, int cycleLength, int periodLength) {
    if (cycleLength <= 0 || periodLength <= 0) {
      throw Exception(
          "Cycle length and period duration must be positive integers.");
    }
    _lastPeriodStart = lastPeriod;
    _cycleLength = cycleLength;
    _periodLength = periodLength;
    // Log the cycle to past cycles list
    logCycle(_lastPeriodStart as String);

    _initializeCycleData();
    notifyListeners();

    // Sync updated data with Hive
    _saveToHive();

  }

  Future<void> _saveToHive() async {
    CycleData cycleData = CycleData(
      cycleStartDate: _lastPeriodStart.toString(),
      cycleEndDate:
      _lastPeriodStart.add(Duration(days: _cycleLength)).toString(),
      periodLength: _periodLength,
      cycleLength: _cycleLength,
      pastPeriods: _pastPeriods
    );

    // Open the Hive box
    var box = await Hive.openBox<CycleData>('cycleData');
    await box.put('cycle', cycleData);
    print("Cycle data saved to Hive.");

    saveCycleDataToFirestore();

  }


  Future<void> loadCycleDataFromHive() async {
    var box = await Hive.openBox<CycleData>('cycleData');
    CycleData? cycleData = box.get('cycle');

    if (cycleData != null) {
      // Initialize the provider with data from Hive
      _lastPeriodStart = DateTime.parse(cycleData.cycleStartDate);
      _cycleLength = cycleData.cycleLength!;
      _periodLength = cycleData.periodLength!;
      _pastPeriods=cycleData.pastPeriods;
      // Recalculate the cycle data
      _initializeCycleData();
      notifyListeners();
    } else {
      print("No cycle data found in Hive.");
    }
  }

  Future<void> saveCycleDataToFirestore() async {
    if (await SessionManager.checkUserLoginStatus()) {
      try {
        String? userId = await SessionManager.getUserId();
        if (userId == null) {
          print("User ID is null. Cannot save data.");
          return;
        }

        final cycles = FirebaseFirestore.instance.collection('cycles');
        Map<String, dynamic> cycleData = {
          'cycleStartDate': _lastPeriodStart.toIso8601String(),
          'cycleEndDate': _lastPeriodStart.add(Duration(days: _cycleLength)).toIso8601String(),
          'periodLength': _periodLength,
          'cycleLength': _cycleLength,
          'pastPeriods': _pastPeriods
        };

        final pregnancyProvider = Provider.of<PregnancyModeProvider>(_context, listen: false);

        if (pregnancyProvider.isPregnancyMode) {
          cycleData.addAll({
            'pregnancyMode': true,
            'gestationStart': pregnancyProvider.gestationStart?.toIso8601String(),
          });
        } else {
          // If pregnancy mode is disabled, remove pregnancy-related fields
          await cycles.doc(userId).update({
            'pregnancyMode': FieldValue.delete(),
            'gestationStart': FieldValue.delete(),
          });
          print("Deleted pregnancyMode and gestationStart fields from Firestore.");
        }

        // Save cycle data, including pregnancy-related fields if necessary
        await cycles.doc(userId).set(cycleData, SetOptions(merge: true));
        print("Cycle data saved successfully.");
      } catch (e, stackTrace) {
        print("Error saving data: $e");
        print("Stack trace: $stackTrace");
      }
    } else {
      print("User is not logged in.");
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
    final endDate = lastPeriodStart.add(Duration(days: _periodLength)); // Calculate end date

    // Recalculate all related cycle data when period length is updated
    _initializeCycleData();
    notifyListeners();
  }

  void updateLastPeriodStart(DateTime lastPeriodStart) {
    _lastPeriodStart = lastPeriodStart;

    // Create the new period map with start and end dates
    String formattedDate = lastPeriodStart.toIso8601String();
    Map<String, String> newPeriod = {
      'startDate': formattedDate,
      'endDate': lastPeriodStart.add(Duration(days: _periodLength)).toIso8601String(),
    };

    // Add the new period to the list if it doesn't already exist
    if (!_pastPeriods.any((period) =>
    period['startDate'] == newPeriod['startDate'] && period['endDate'] == newPeriod['endDate'])) {
      _pastPeriods.add(newPeriod);
    }

    // Calculate the latest date from the periods
    _lastPeriodStart = _calculateLatestDate();

    _initializeCycleData();

    // Notify listeners to update the UI
    notifyListeners();

    // Sync with Hive
    _saveToHive();
  }

  DateTime? getLastPeriodStartForEnd() {
    if (pastPeriods.isEmpty) {
      return lastPeriodStart ?? DateTime.now(); // Use lastPeriodStart if available, otherwise today's date
    } else {
      final lastPeriod = pastPeriods.last;
      return DateTime.parse(lastPeriod['startDate']!);  // Return the end date of the last period
    }
  }
  DateTime _calculateLatestDate() {
    if (_pastPeriods.isNotEmpty) {
      // Parse startDate from the map and find the latest date
      List<DateTime> parsedDates = _pastPeriods
          .map((period) => DateTime.parse(period['startDate']!))
          .toList();
      return parsedDates.reduce((a, b) => a.isAfter(b) ? a : b);
    } else {
      return DateTime.now(); // Fallback if there are no past periods
    }
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
  static final CycleProvider _instance = CycleProvider._internal();

  factory CycleProvider() {
    return _instance;
  }

  CycleProvider._internal();

}


class PartnerProvider with ChangeNotifier {
  DateTime? _lastMenstrualPeriod;
  int? _cycleLength;
  int? _periodLength;
  DateTime? _dueDate;
  bool _pregnancyMode = false;
  DateTime? _gestationStart;

  // Getters
  DateTime? get lastMenstrualPeriod => _lastMenstrualPeriod;
  DateTime? get dueDate => _dueDate;
  int? get cycleLength => _cycleLength;
  int? get periodLength => _periodLength;
  bool get pregnancyMode => _pregnancyMode;
  DateTime? get gestationStart => _gestationStart;


  List<DateTime> periodDays = [];
  List<DateTime> predictedDays = [];
  List<DateTime> fertileDays = [];

  // Fetch user1's cycle data
  Future<void> fetchUser1CycleData(String user1Id) async {
    try {
      DocumentSnapshot user1Doc = await FirebaseFirestore.instance
          .collection('cycles')
          .doc(user1Id)
          .get();

      if (user1Doc.exists) {
        var pregnancyData = user1Doc.data() as Map<String, dynamic>;

        // Parse mandatory fields
        DateTime cycleStartDate = DateTime.parse(pregnancyData['cycleStartDate']);
        int cycleLength = pregnancyData['cycleLength'];
        int periodLength = pregnancyData['periodLength'];

        // Handle optional fields safely
        bool isPregnancyMode = pregnancyData['pregnancyMode'] ?? false;
        DateTime? gestationStart = pregnancyData['gestationStart'] != null
            ? DateTime.parse(pregnancyData['gestationStart'])
            : null;

        _lastMenstrualPeriod = cycleStartDate;
        _cycleLength = cycleLength;
        _periodLength = periodLength;
        _pregnancyMode = isPregnancyMode;
        _gestationStart = gestationStart;

        if (_pregnancyMode && _gestationStart != null) {
          _dueDate = _gestationStart!.add(Duration(days: 280));
        } else {
          _dueDate = null;
        }

        _initializeCycleData();
        notifyListeners();
      } else {
        print("No data found for User 1.");
      }
    } catch (e) {
      print("Error fetching User 1's cycle data: $e");
    }
  }

  // Initialize cycle data
  void _initializeCycleData() {
    if (_lastMenstrualPeriod == null || _cycleLength == null || _periodLength == null) {
      print("Cycle data is incomplete.");
      return;
    }

    predictedDays = List.generate(
      _periodLength!,
          (index) => _lastMenstrualPeriod!.add(Duration(days: index)),
    );

    fertileDays = List.generate(
      _cycleLength! - 14 + 1,
          (index) => _lastMenstrualPeriod!.add(Duration(days: _cycleLength! - 14 + index)),
    );

    periodDays = List.generate(
      _periodLength!,
          (index) => _lastMenstrualPeriod!.add(Duration(days: index)),
    );

    notifyListeners();
  }

  /// Calculate "days until due date" only if pregnancy mode is enabled and gestation start is set
  int get daysUntilDueDate {
    if (!_pregnancyMode || _dueDate == null) {
      return 0;
    }

    final remainingDays = _dueDate!.difference(DateTime.now()).inDays;
    return remainingDays >= 0 ? remainingDays : 0;
  }

  /// Get the current pregnancy week dynamically
  int getCurrentWeek() {
    if (!_pregnancyMode || _gestationStart == null) return 0;

    final daysPregnant = DateTime.now().difference(_gestationStart!).inDays;
    final weeksPregnant = (daysPregnant / 7).floor() + 1;

    return weeksPregnant;
  }

  /// Get days into pregnancy
  int getDaysIntoPregnancy() {
    if (!_pregnancyMode || _gestationStart == null) return 0;

    final daysPregnant = DateTime.now().difference(_gestationStart!).inDays;
    return daysPregnant;
  }

  /// Logic for cycle phases depending on the current cycle state
  String get currentPhase {

    int cycleDay = this.cycleDay;

    if (cycleDay <= _periodLength!) {
      return 'Menstrual Phase';
    } else if (cycleDay <= _cycleLength! - 14) {
      return 'Follicular Phase';
    } else if (cycleDay <= _cycleLength! - 6) {
      return 'Ovulation Phase';
    } else {
      return 'Luteal Phase';
    }
  }

  /// Determine days elapsed into the current cycle
  int get daysElapsed {
    if (_lastMenstrualPeriod == null) return 0;
    return DateTime.now().difference(_lastMenstrualPeriod!).inDays;
  }

  int get cycleDay {
    if (_lastMenstrualPeriod == null) return 0;

    DateTime today = DateTime.now();
    if (_lastMenstrualPeriod!.isAtSameMomentAs(today)) {
      return 1;
    }
    return today.difference(_lastMenstrualPeriod!).inDays ;
  }

  /// Toggle pregnancy mode and update necessary values accordingly
  void togglePregnancyMode(bool isEnabled) {
    _pregnancyMode = isEnabled;

    if (_pregnancyMode && _gestationStart != null) {
      _dueDate = _gestationStart!.add(Duration(days: 280));
    } else {
      _dueDate = null;
    }

    notifyListeners();
  }
}
