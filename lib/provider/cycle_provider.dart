import 'package:calender_app/hive/partner_model.dart';
import 'package:calender_app/notifications/notification_service.dart';
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

import '../hive/settingsPageNotifications.dart';
import '../screens/settings/reminder_times.dart';

class CycleProvider with ChangeNotifier {


  // Load data from Hive during initialization
  void loadFromHive() {
    final box = Hive.box('luteal_data');
    _lutealPhaseLength = box.get('lutealPhaseLength', defaultValue: 14);
    notifyListeners();
  }


  Future<void> rescheduleNotifications() async {
    final toggleStates = await ToggleStateService.loadToggleState();

    bool isPeriodReminderOn = toggleStates[ToggleStateService.periodReminderKey] ?? false;
    bool isFertilityReminderOn = toggleStates[ToggleStateService.fertilityReminderKey] ?? false;
    bool isLutealReminderOn = toggleStates[ToggleStateService.lutealReminderKey] ?? false;
    print("Toggle States - Period: $isPeriodReminderOn, Fertility: $isFertilityReminderOn, Luteal: $isLutealReminderOn");
    // Retrieve saved times or use defaults
    TimeOfDay periodReminderTime = await NotificationTimeService.loadNotificationTime(
      NotificationTimeService.periodTimeKey,
      TimeOfDay(hour: 9, minute: 0),
    );
    TimeOfDay fertilityReminderTime = await NotificationTimeService.loadNotificationTime(
      NotificationTimeService.fertilityTimeKey,
      TimeOfDay(hour: 8, minute: 0),
    );
    TimeOfDay lutealReminderTime = await NotificationTimeService.loadNotificationTime(
      NotificationTimeService.lutealTimeKey,
      TimeOfDay(hour: 10, minute: 0),
    );

    // Cancel existing notifications
    cancelNotification(1000);
    cancelNotification(2000);
    cancelNotification(3000);

    DateTime nextPeriodStart = lastPeriodStart.add(Duration(days: cycleLength));

    // Schedule Period Reminder
    if (isPeriodReminderOn) {
      DateTime periodReminderDateTime = DateTime(
        nextPeriodStart.year,
        nextPeriodStart.month,
        nextPeriodStart.day,
        periodReminderTime.hour,
        periodReminderTime.minute,
      );
      print("Period Reminder scheduled for: $periodReminderDateTime");
      // if (periodReminderDateTime.isBefore(DateTime.now())) {
      //   // If reminder time is in the past, notify immediately
      //   NotificationService.showInstantNotification(
      //     "Period Reminder",
      //     "Your period has started on ${nextPeriodStart.toLocal()}!",
      //   );
      // }
      NotificationService.scheduleNotification(
        1000,
        "Upcoming Period",
        "Your period is expected to start soon.",
        periodReminderDateTime,
      );
    }

    // Schedule Fertility Window Reminder
    if (isFertilityReminderOn) {
      DateTime fertilityWindowStart = nextPeriodStart.subtract(Duration(days: 14));
      DateTime fertilityReminderDateTime = DateTime(
        fertilityWindowStart.year,
        fertilityWindowStart.month,
        fertilityWindowStart.day,
        fertilityReminderTime.hour,
        fertilityReminderTime.minute,
      );
      // if (fertilityReminderDateTime.isBefore(DateTime.now())) {
      //   // If reminder time is in the past, notify immediately
      //   NotificationService.showInstantNotification(
      //     "Fertility Reminder",
      //     "Your fertility window has started on ${nextPeriodStart.toLocal()}!",
      //   );
      // }
      print("Fertility Reminder scheduled for: $fertilityReminderDateTime");

      NotificationService.scheduleNotification(
        2000,
        "Fertility Window",
        "Your fertility window starts soon.",
        fertilityReminderDateTime,
      );
    }

    // Schedule Luteal Phase Reminder
    if (isLutealReminderOn) {
      DateTime lutealPhaseStart = nextPeriodStart.subtract(Duration(days: 7));
      DateTime lutealReminderDateTime = DateTime(
        lutealPhaseStart.year,
        lutealPhaseStart.month,
        lutealPhaseStart.day,
        lutealReminderTime.hour,
        lutealReminderTime.minute,
      );
      // if (lutealReminderDateTime.isBefore(DateTime.now())) {
      //   // If reminder time is in the past, notify immediately
      //   NotificationService.showInstantNotification(
      //     "Luteal Reminder",
      //     "Your luteal has started on ${nextPeriodStart.toLocal()}!",
      //   );
      // }
      print("Luteal Reminder scheduled for: $lutealReminderDateTime");

      NotificationService.scheduleNotification(
        3000,
        "Luteal Phase",
        "Your luteal phase starts soon.",
        lutealReminderDateTime,
      );
    }
  }


  // Helper function to cancel notifications in a specific ID range
  void cancelNotification(int id) {
    NotificationService.cancelScheduledTask(id); // Cancel the specific notification by its ID
  }


  String _selectedOption = "Last 1 Month"; // Default option
  bool _useAverage = false; // Default state for average usage

  String get selectedOption => _selectedOption;
  bool get useAverage => _useAverage;

  // Method to update useAverage and selectedOption
  void updateUseAverage(bool useAverage, String selectedOption) {
    _useAverage = useAverage;
    _selectedOption = selectedOption;
    notifyListeners();
  }

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
    endDate = endDate.add(Duration(days: 1)); // Adjust the end date to include the last day

    String endDateStr = endDate.toIso8601String();

    int existingPeriodIndex = _pastPeriods.indexWhere((period) =>
    period['startDate'] == startDateStr);

    if (existingPeriodIndex != -1) {
      // Update the existing period's end date
      _pastPeriods[existingPeriodIndex]['endDate'] = endDateStr;
      print("Period updated: Start: $startDateStr, End: $endDateStr");
    } else {
      _pastPeriods.add({'startDate': startDateStr, 'endDate': endDateStr});
      updateLastPeriodStart(startDate);
      print("New period added: Start: $startDateStr, End: $endDateStr");
    }

    _saveToHive(); // Sync with Hive storage
    notifyListeners(); // Notify listeners to update UI
  }

  void removePastPeriod(String startDate) {
    // Remove the period by start date
    _pastPeriods.removeWhere((period) => period['startDate'] == startDate);

    // Print the updated list of past periods
    print("Updated Past Periods List: ");
    _pastPeriods.forEach((period) {
      print("Start Date: ${period['startDate']}, End Date: ${period['endDate']}");
    });

    // After removal, calculate the latest date from remaining periods
    if (_pastPeriods.isNotEmpty) {
      // Find the latest start date from the remaining periods
      updateLastPeriodStart(_calculateLatestDate());
    }

    // Print the new last period start date
    print("New Last Period Start Date: $_lastPeriodStart");

    _saveToHive(); // Sync with Hive storage
    notifyListeners(); // Notify listeners to update UI
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

  int logCycle() {
    _totalCyclesLogged = _pastPeriods.where((period) => period.containsKey('endDate')).length;
    return _totalCyclesLogged;
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
    // return getNextPeriodDate().difference(DateTime.now()).inDays;
      DateTime nextPeriodDate = getNextPeriodDate(); // Ensure this returns the correct next period date
      DateTime currentDate = DateTime.now();

      // Normalize both dates to the start of the day
      DateTime normalizedNextPeriodDate = DateTime(nextPeriodDate.year, nextPeriodDate.month, nextPeriodDate.day);
      DateTime normalizedCurrentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

      // Calculate the difference in days
      int daysLeft = normalizedNextPeriodDate.difference(normalizedCurrentDate).inDays;

      // Return the number of days left
      return daysLeft;

  }

  // Initialize and calculate all dynamic cycle data
  void _initializeCycleData() {
  //  rescheduleNotifications();
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

// Get the fertility window start and end dates
  DateTime getFertilityWindowStart() {
    return lastPeriodStart.add(Duration(days: cycleLength - lutealPhaseLength - 5));
  }


  DateTime getFertilityWindowEnd() {
    return getFertilityWindowStart().add(Duration(days: 7));
  }


// Get the ovulation date
  DateTime getOvulationDate() {
    return lastPeriodStart.add(Duration(days: cycleLength - lutealPhaseLength)); // Ovulation date
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
    logCycle();

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
    rescheduleNotifications();
  }


  void MergeCycleData({
    required int cycleLength,
    required int periodLength,
    DateTime? lastPeriodStart,
    List<Map<String, String>>? pastPeriods,
  }) {
    // Update cycle length, period length, and last period start
    cycleLength = cycleLength;
    periodLength = periodLength;
    lastPeriodStart = lastPeriodStart;

    // Merge fetched past periods with current past periods
    if (pastPeriods != null && pastPeriods.isNotEmpty) {
      for (var fetchedPeriod in pastPeriods) {
        DateTime fetchedStartDate = DateTime.parse(fetchedPeriod['startDate']!);
        DateTime fetchedEndDate = DateTime.parse(fetchedPeriod['endDate']!);

        // Check if the fetched period already exists in the current past periods
        bool exists = _pastPeriods.any((period) =>
        period['startDate'] == fetchedPeriod['startDate']);

        if (!exists) {
          // If the period doesn't exist, add it using the addPastPeriod method
          addPastPeriod(fetchedStartDate, fetchedEndDate);
        } else {
          // If it exists, you can choose to update it or skip
          // In this case, we'll skip adding duplicate periods.
          print("Fetched period already exists: ${fetchedPeriod['startDate']}");
        }
      }
    }

    _initializeCycleData(); // Initialize the cycle data
    notifyListeners(); // Notify listeners to update UI
  }

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
          'pastPeriods': _pastPeriods.map((e) => {'startDate': e['startDate'], 'endDate': e['endDate']}).toList(),

        };

        final pregnancyProvider = Provider.of<PregnancyModeProvider>(_context, listen: false);

        cycleData.addAll({
          'pregnancyMode': pregnancyProvider.isPregnancyMode,
          'gestationStart': pregnancyProvider.gestationStart?.toIso8601String(),
        });


        // Check if document exists
        final docRef = cycles.doc(userId);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          // Document exists, update it
          await docRef.update(cycleData);
          print("Cycle data updated successfully.");
        } else {
          // Document does not exist, create it
          await docRef.set(cycleData, SetOptions(merge: true));
          print("Cycle data saved successfully.");
        }
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
  final Box _cycleBox = Hive.box('partnerCycleData');
  String? user1Id;
  DateTime? _lastMenstrualPeriod;
  DateTime? _cycleEndDate;

  int _cycleLength = 4;
  int? _periodLength;
  DateTime? _dueDate;
  bool _pregnancyMode = false;
  DateTime? _gestationStart;
  List<Map<String, String>> _pastPeriods = [];  // Store all past period start dates as strings
  List<Map<String, String>> get pastPeriods => _pastPeriods;


  bool get isPregnancyMode => _cycleBox.get('pregnancyMode') ?? false;

  int? get cycleLength => _cycleBox.get('cycleLength');

  int? get periodLength => _cycleBox.get('periodLength');

  bool get pregnancyMode => _cycleBox.get('pregnancyMode') ?? false;

  DateTime? get lastMenstrualPeriod => _cycleBox.get('lastMenstrualPeriod') != null
      ? DateTime.parse(_cycleBox.get('lastMenstrualPeriod'))
      : null;

  DateTime? get gestationStart => _cycleBox.get('gestationStart') != null
      ? DateTime.parse(_cycleBox.get('gestationStart'))
      : null;

  DateTime? get dueDate => _cycleBox.get('dueDate') != null
      ? DateTime.parse(_cycleBox.get('dueDate'))
      : null;

  List<DateTime> periodDays = [];
  List<DateTime> predictedDays = [];
  List<DateTime> fertileDays = [];

  Future<void> fetchUser1CycleData(String user1Id) async {
    this.user1Id = user1Id; // Store user1Id for later use in the class
    _cycleBox.put('user1Id', user1Id);

    try {
      DocumentSnapshot user1Doc = await FirebaseFirestore.instance
          .collection('cycles')
          .doc(user1Id)
          .get();

      if (user1Doc.exists) {
        var pregnancyData = user1Doc.data() as Map<String, dynamic>;

        // Parse mandatory fields
        DateTime cycleStartDate = DateTime.parse(pregnancyData['cycleStartDate']);
        int cycleLength = (pregnancyData['cycleLength'] as int?) ?? 28; // Default to 28 days if null
        int periodLength = (pregnancyData['periodLength'] as int?) ?? 5; // Default to 5 days if null

        // Calculate the cycle end date
        DateTime cycleEndDate = cycleStartDate.add(Duration(days: cycleLength));

        // Handle optional fields safely
        bool isPregnancyMode = pregnancyData['pregnancyMode'] ?? false; // Default to false if null
        DateTime? gestationStart = pregnancyData['gestationStart'] != null
            ? DateTime.parse(pregnancyData['gestationStart'])
            : null; // Keep it null if not provided

        // Fetch list of past periods (string maps for start and end dates)
        List<Map<String, String>> pastPeriods = [];
        if (pregnancyData['pastPeriods'] != null) {
          for (var item in pregnancyData['pastPeriods']) {
            if (item is Map<String, dynamic>) {
              String startDate = item['startDate'] ?? '';
              String endDate = item['endDate'] ?? '';
              pastPeriods.add({
                'startDate': startDate,
                'endDate': endDate,
              });
            }
          }
        }

        // Create PartnerData object
        PartnerData partnerData = PartnerData(
          cycleStartDate: cycleStartDate,
          cycleLength: cycleLength,
          periodLength: periodLength,
          cycleEndDate: cycleEndDate,
          pregnancyMode: isPregnancyMode,
          pastPeriods: pastPeriods,
        );

        // Save the PartnerData object in Hive
        await _cycleBox.put('partnerData', partnerData);

        // Save to Hive individual fields (optional, if needed)
        _cycleBox.put('lastMenstrualPeriod', cycleStartDate.toIso8601String());
        _cycleBox.put('cycleLength', cycleLength);
        _cycleBox.put('periodLength', periodLength);
        _cycleBox.put('pregnancyMode', isPregnancyMode);
        _cycleBox.put('gestationStart', gestationStart?.toIso8601String());
        _cycleBox.put('cycleEndDate', cycleEndDate.toIso8601String());
        _cycleBox.put('pastPeriods', pastPeriods);

        // Update class variables
        _lastMenstrualPeriod = cycleStartDate;
        _cycleLength = cycleLength;
        _periodLength = periodLength;
        _pregnancyMode = isPregnancyMode;
        _gestationStart = gestationStart;
        _cycleEndDate = cycleEndDate;
        _pastPeriods = pastPeriods;

        if (_pregnancyMode && _gestationStart != null) {
          _dueDate = _gestationStart!.add(Duration(days: 280));
          _cycleBox.put('dueDate', _dueDate?.toIso8601String());
        } else {
          _dueDate = null;
          _cycleBox.delete('dueDate');
        }

        initializeCycleData();
        notifyListeners();

        print("Data fetched");
      } else {
        print("No data found for User 1.");
      }
    } catch (e) {
      print("Error fetching User 1's cycle data: $e");
    }
  }


  Future<void> fetchUser22CycleData(String user1Id) async {
    this.user1Id = user1Id; // Store user1Id for later use in the class
    _cycleBox.put('user1Id', user1Id);

    try {
      DocumentSnapshot user1Doc = await FirebaseFirestore.instance
          .collection('cycles')
          .doc(user1Id)
          .get();

      if (user1Doc.exists) {
        var pregnancyData = user1Doc.data() as Map<String, dynamic>;

        // Print the fetched data for debugging
        print("Fetched pregnancy data: $pregnancyData");

        // Ensure mandatory fields are present
        if (pregnancyData['cycleStartDate'] == null) {
          throw Exception("cycleStartDate is missing");
        }

        // Parse mandatory fields with null checks
        DateTime cycleStartDate = DateTime.parse(pregnancyData['cycleStartDate']);

        // Check if cycleLength and periodLength are null, and set defaults
        int cycleLength = (pregnancyData['cycleLength'] as int?) ?? 28; // Default to 28 days if null
        int periodLength = (pregnancyData['periodLength'] as int?) ?? 5; // Default to 5 days if null
        print("cycleLength: $cycleLength (type: ${cycleLength.runtimeType})");
        print("periodLength: $periodLength (type: ${periodLength.runtimeType})");

        // Calculate the cycle end date
        DateTime cycleEndDate = cycleStartDate.add(Duration(days: cycleLength));

        // Handle optional fields safely
        bool isPregnancyMode = pregnancyData['pregnancyMode'] ?? false; // Default to false if null
        DateTime? gestationStart; // Nullable to handle case when it's missing
        if (isPregnancyMode) {
          // If pregnancyMode is true, fetch gestationStart
          if (pregnancyData['gestationStart'] != null) {
            gestationStart = DateTime.parse(pregnancyData['gestationStart'] as String);
          }
        }

        if (!isPregnancyMode) {
          // If pregnancyMode is false, skip gestationStart and handle accordingly
          print("Pregnancy mode is off, skipping gestationStart.");
        }

        print("gestationStart: ${gestationStart?.toString() ?? 'null'}");

        // Fetch list of past periods and map them to Map<String, String>
        List<Map<String, String>> pastPeriods = [];
        if (pregnancyData['pastPeriods'] != null) {
          for (var item in pregnancyData['pastPeriods']) {
            if (item is Map<String, dynamic>) {
              String startDate = item['startDate'] as String? ?? '';
              String endDate = item['endDate'] as String? ?? '';
              if (startDate.isNotEmpty && endDate.isNotEmpty) {
                pastPeriods.add({'startDate': startDate, 'endDate': endDate});
              }
            }
          }
        }

        // Create the PartnerData instance
        PartnerData partnerData = PartnerData(
          cycleStartDate: cycleStartDate,
          cycleLength: cycleLength,
          periodLength: periodLength,
          cycleEndDate: cycleEndDate,
          pregnancyMode: isPregnancyMode,
          pastPeriods: pastPeriods,
        );

        // Save the PartnerData object in Hive
        await _cycleBox.put('partnerData', partnerData);

        // Update class variables
        _lastMenstrualPeriod = partnerData.cycleStartDate;
        _cycleLength = partnerData.cycleLength;
        _periodLength = partnerData.periodLength;
        _pregnancyMode = partnerData.pregnancyMode;
        _pastPeriods = partnerData.pastPeriods;
        _cycleEndDate = partnerData.cycleEndDate;

        // Calculate due date only if pregnancyMode is true
        _dueDate = isPregnancyMode && gestationStart != null ? gestationStart.add(Duration(days: 280)) : null;
        await _cycleBox.put('dueDate', _dueDate?.toIso8601String());

        initializeCycleData();
        notifyListeners();

        print("Data fetched successfully");
      } else {
        print("No data found for User 1.");
      }
    } catch (e) {
      print("Error fetching User 1's cycle data: $e");
    }
  }

  void initializeCycleData() {
    if (_cycleBox.isNotEmpty) {
      _lastMenstrualPeriod = _cycleBox.get('lastMenstrualPeriod') != null
          ? DateTime.parse(_cycleBox.get('lastMenstrualPeriod'))
          : null;
      _cycleLength = _cycleBox.get('cycleLength');
      _periodLength = _cycleBox.get('periodLength');
      _pregnancyMode = _cycleBox.get('pregnancyMode') ?? false;
      _gestationStart = _cycleBox.get('gestationStart') != null
          ? DateTime.parse(_cycleBox.get('gestationStart'))
          : null;
      _dueDate = _cycleBox.get('dueDate') != null
          ? DateTime.parse(_cycleBox.get('dueDate'))
          : null;
    }

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
  int getCurrentDay() {
    if (!_pregnancyMode || _gestationStart == null) return 0;

    final daysPregnant = DateTime.now().difference(_gestationStart!).inDays;

    return daysPregnant + 1; // Adding 1 because gestation starts from day 1, not day 0
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

  DateTime getNextPeriodDate() {
    return _lastMenstrualPeriod!.add(Duration(days: cycleLength!));
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

  int getDaysUntilNextPeriod() {
    return getNextPeriodDate().difference(DateTime.now()).inDays;
  }

   listenForCycleUpdates() {
    String? savedUser1Id = _cycleBox.get('user1Id');

    if (savedUser1Id != null) {
      FirebaseFirestore.instance
          .collection('cycles')
          .doc(savedUser1Id)
          .snapshots()
          .listen((snapshot) {
        try {
          if (snapshot.exists) {
            var pregnancyData = snapshot.data() as Map<String, dynamic>;

            // Parse mandatory fields with null safety
            DateTime cycleStartDate = DateTime.parse(pregnancyData['cycleStartDate']);
            int cycleLength = pregnancyData['cycleLength'] ?? 0;
            int periodLength = pregnancyData['periodLength'] ?? 0;

            // Optional fields
            bool isPregnancyMode = pregnancyData['pregnancyMode'] ?? false;
            DateTime? gestationStart = pregnancyData['gestationStart'] != null
                ? DateTime.parse(pregnancyData['gestationStart'])
                : null;

            // Validate past periods
            List<Map<String, String>> pastPeriods = [];
            if (pregnancyData['pastPeriods'] != null && pregnancyData['pastPeriods'] is List) {
              for (var item in pregnancyData['pastPeriods']) {
                if (item is Map<String, dynamic>) {
                  String startDate = item['startDate'] ?? '';
                  String endDate = item['endDate'] ?? '';
                  if (startDate.isNotEmpty && endDate.isNotEmpty) {
                    pastPeriods.add({'startDate': startDate, 'endDate': endDate});
                  }
                }
              }
            }

            // Create and save PartnerData
            PartnerData partnerData = PartnerData(
              cycleStartDate: cycleStartDate,
              cycleLength: cycleLength,
              periodLength: periodLength,
              cycleEndDate: cycleStartDate.add(Duration(days: cycleLength)),
              pregnancyMode: isPregnancyMode,
              pastPeriods: pastPeriods,
            );

            _cycleBox.put('partnerData', partnerData);

            // Update class variables
            _lastMenstrualPeriod = partnerData.cycleStartDate;
            _cycleLength = partnerData.cycleLength;
            _periodLength = partnerData.periodLength;
            _pregnancyMode = partnerData.pregnancyMode;
            _pastPeriods = partnerData.pastPeriods;
            _cycleEndDate = partnerData.cycleEndDate;

            if (_pregnancyMode && gestationStart != null) {
              _dueDate = gestationStart.add(Duration(days: 280));
              _cycleBox.put('dueDate', _dueDate?.toIso8601String());
            } else {
              _dueDate = null;
              _cycleBox.delete('dueDate');
            }

            initializeCycleData();
            notifyListeners();
            print("Cycle data updated.");
          } else {
            print("No data found for User 1.");
          }
        } catch (e) {
          print("Error processing cycle data: $e");
        }
      });
    } else {
      print("User 1 ID not found in Hive.");
    }
  }

}
