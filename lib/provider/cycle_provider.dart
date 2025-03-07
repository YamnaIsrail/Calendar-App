import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

    bool isPeriodReminderOn = toggleStates[ToggleStateService.periodReminderKey] ?? true;
    bool isFertilityReminderOn = toggleStates[ToggleStateService.fertilityReminderKey] ?? true;
    bool isLutealReminderOn = toggleStates[ToggleStateService.lutealReminderKey] ?? true;

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

    DateTime nextPeriodStart = getNextPeriodDate();

    // Schedule Period Reminder
    if (isPeriodReminderOn) {
      DateTime periodReminderDateTime = DateTime(
        nextPeriodStart.year,
        nextPeriodStart.month,
        nextPeriodStart.day,
        periodReminderTime.hour,
        periodReminderTime.minute,
      );
      if (periodReminderDateTime.isAfter(DateTime.now()))
        NotificationService.rscheduleNotification(
          7,
          "Period Updates",
          "Your period is predicted to start tomorrow. Tap to confirm when it begins.",
          periodReminderDateTime,
        );
      // print("Period Reminder scheduled for: $periodReminderDateTime");

      // On the day of the predicted period start
      DateTime periodStartDateTime = DateTime(
        nextPeriodStart.year,
        nextPeriodStart.month,
        nextPeriodStart.day,
        periodReminderTime.hour,
        periodReminderTime.minute,
      ).add(Duration(days: 1)); // The reminder on the actual start date
      if (periodStartDateTime.isAfter(DateTime.now())) {
        NotificationService.rscheduleNotification(
          8,
          "Period Updates",
          "Your period is expected to start today. Tap to log your period.",
          periodStartDateTime,
        );
      }

      // If user hasn't logged the period after 1 day
      DateTime latePeriodReminderDateTime = periodStartDateTime.add(Duration(days: 1));
      if (latePeriodReminderDateTime.isAfter(DateTime.now())) {
        NotificationService.rscheduleNotification(
          9,
          "Period Updates",
          "Haven’t logged your period yet? If it started, tap to track.",
          latePeriodReminderDateTime,
        );
      }
    }
    // Delayed Period Notifications
    if (isPeriodReminderOn) {
      DateTime periodStartDate = getNextPeriodDate(); // Predicted start date
      DateTime threeDaysLateReminder = periodStartDate.add(Duration(days: 3));
      DateTime fiveDaysLateReminder = periodStartDate.add(Duration(days: 5));
      DateTime sevenDaysLateReminder = periodStartDate.add(Duration(days: 7));

      // Three Days Late
      if (threeDaysLateReminder.isAfter(DateTime.now())) {
        NotificationService.rscheduleNotification(
          10,
          "Period Reminder",
          "Your period is 3 days late. Tap to update or check insights.",
          threeDaysLateReminder,
        );
      }

      // Five Days Late
      if (fiveDaysLateReminder.isAfter(DateTime.now())) {
        NotificationService.rscheduleNotification(
          11,
          "Period Reminder",
          "Your period is 5 days late. Want to track symptoms or take a pregnancy test?",
          fiveDaysLateReminder,
        );
      }

      // Seven Days Late
      if (sevenDaysLateReminder.isAfter(DateTime.now())) {
        NotificationService.rscheduleNotification(
          12,
          "Period Reminder",
          "Your period is 7 days late. Consider consulting a doctor for guidance.",
          sevenDaysLateReminder,
        );
      }
    }


    // Schedule Fertility Window Reminder
    if (isFertilityReminderOn) {
      DateTime fertilityWindowStart = getFertilityWindowStart(); // Get Fertile Window Start

      DateTime fertilityReminderDateTime = DateTime(
        fertilityWindowStart.year,
        fertilityWindowStart.month,
        fertilityWindowStart.day,
        fertilityReminderTime.hour,
        fertilityReminderTime.minute,
      );

      if (fertilityReminderDateTime.isAfter(DateTime.now())) {
        NotificationService.rscheduleNotification(
          13,
          "Fertile Window Alert",
          "Your fertile window starts tomorrow! This is your most fertile time if you're trying to conceive. Tap to view details.",
          fertilityReminderDateTime.subtract(Duration(days: 1)), // 1 day before
        );
      }
      // print("Fertility Reminder scheduled for: $fertilityReminderDateTime");
    }


    // Schedule Luteal Phase Reminder
    if (isLutealReminderOn) {
      DateTime ovulationDate = getOvulationDate();
      DateTime lutealPhaseStart = ovulationDate.add(Duration(days: 1));

      DateTime lutealReminderDateTime = DateTime(
        lutealPhaseStart.year,
        lutealPhaseStart.month,
        lutealPhaseStart.day,
        lutealReminderTime.hour,
        lutealReminderTime.minute,
      );

      if (lutealReminderDateTime.isAfter(DateTime.now())) {
        NotificationService.rscheduleNotification(
          14,
          "Luteal Phase",
          "Your luteal phase starts soon.",
          lutealReminderDateTime,
        );
      }
      // print("Luteal Reminder scheduled for: $lutealReminderDateTime");
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

  void updateFertileDays(DateTime lastPeriodStart, int cycleLength,
      int lutealPhaseLength) {
  _lutealPhaseLength = lutealPhaseLength;

   DateTime fertileStart = getFertilityWindowStart();
    DateTime fertileEnd = getFertilityWindowEnd();
    fertileDays = List.generate(
      fertileEnd.difference(fertileStart).inDays + 1,
          (index) => fertileStart.add(Duration(days: index)),
    );
    predictedDays = List.generate(
      periodLength,
          (index) => lastPeriodStart.add(Duration(days: cycleLength + index)),
    );
    periodDays = List.generate(
      periodLength,
          (index) => lastPeriodStart.add(Duration(days: index)),
    );

    }

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
    // print("User name saved to Hive.");
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





  int _totalCyclesLogged = 0;
  int get totalCyclesLogged => _totalCyclesLogged;


  void addPastPeriod(DateTime startDate, DateTime endDate) {
    String startDateStr = startDate.toIso8601String();
    endDate = endDate.add(Duration(days: 1));
    String endDateStr = endDate.toIso8601String();

    int existingPeriodIndex = _pastPeriods.indexWhere((period) =>
    period['startDate'] == startDateStr);

    if (existingPeriodIndex != -1) {
      // Update the existing period's end date
      _pastPeriods[existingPeriodIndex]['endDate'] = endDateStr;
      // print("Period updated: Start: $startDateStr, End: $endDateStr");
    } else {
      _pastPeriods.add({'startDate': startDateStr, 'endDate': endDateStr});
      updateLastPeriodStart(startDate);
      // print("New period added: Start: $startDateStr, End: $endDateStr");
    }

    _saveToHive(); // Sync with Hive storage
    notifyListeners(); // Notify listeners to update UI
  }

  void removePastPeriod(String startDate) {
    // Remove the period by start date
    _pastPeriods.removeWhere((period) => period['startDate'] == startDate);
    _pastPeriods.forEach((period) {
    });

    if (_pastPeriods.isNotEmpty) {
      // Find the latest start date from the remaining periods
      updateLastPeriodStart(_calculateLatestDate());
    }
    refinePastPeriods();
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
        // print("Added new period: Start: $startDateStr, End: $endDateStr");
      } else {
        // print("Period already exists: Start: $startDateStr, End: $endDateStr");
      }
    }

    // Notify listeners to update the UI
    notifyListeners();
  }

  List<Map<String, String>> _mergePeriods(List<Map<String, String>> periods) {
    if (periods.isEmpty) return periods;

    // Sort periods by start date
    periods.sort((a, b) => DateTime.parse(a['startDate']!).compareTo(DateTime.parse(b['startDate']!)));

    final mergedPeriods = <Map<String, String>>[];
    Map<String, String>? currentPeriod;

    for (var period in periods) {
      if (currentPeriod == null) {
        currentPeriod = period;
      } else {
        final currentStart = DateTime.parse(currentPeriod['startDate']!);
        final currentEnd = DateTime.parse(currentPeriod['endDate']!);
        final nextStart = DateTime.parse(period['startDate']!);
        final nextEnd = DateTime.parse(period['endDate']!);

        // Check for overlap or adjacency
        if (nextStart.isBefore(currentEnd.add(Duration(days: 1)))) {
          // Merge periods
          currentPeriod['endDate'] = currentEnd.isAfter(nextEnd)
              ? currentEnd.toIso8601String()
              : nextEnd.toIso8601String();
        } else {
          // Add the current period and start a new one
          mergedPeriods.add(currentPeriod);
          currentPeriod = period;
        }
      }
    }

    // Add the last period
    if (currentPeriod != null) {
      mergedPeriods.add(currentPeriod);
    }
    refinePastPeriods();
    return mergedPeriods;
  }
  void refinePastPeriods() {
    final uniquePeriods = <String, Map<String, String>>{};
    final duplicates = <String>{}; // To track start dates that have duplicates

    // First pass: Identify duplicates
    for (var period in _pastPeriods) {
      final startDate = period['startDate']!;

      if (uniquePeriods.containsKey(startDate)) {
        duplicates.add(startDate); // Mark this start date as having duplicates
      } else {
        uniquePeriods[startDate] = period; // Add the original period
      }
    }

    // Second pass: Adjust end dates for duplicates and create new entries
    final refinedPeriods = <Map<String, String>>[];

    for (var period in uniquePeriods.values) {
      final startDate = period['startDate']!;

      if (duplicates.contains(startDate)) {
        // Calculate the new end date based on the period length
        final newEndDate = DateTime.parse(startDate).add(Duration(days: _periodLength - 1)).toIso8601String();

        // Create a new period with the adjusted end date
        refinedPeriods.add({
          'startDate': startDate,
          'endDate': newEndDate,
          // You can add other fields from the original period if needed
        });
      } else {
        // If it's not a duplicate, keep the original period
        refinedPeriods.add(period);
      }
    }

    // Update the past periods with the refined periods
    _pastPeriods = refinedPeriods;
    notifyListeners(); // Notify listeners to update UI
  }
  void setPastPeriods(List<Map<String, String>> newPeriods) {

    final uniqueNewPeriods = {
      for (var period in newPeriods) period['startDate']!: period
    }.values.toList();

    // Remove existing periods that overlap with the new periods
    for (var newPeriod in uniqueNewPeriods) {
      final newStartDate = DateTime.parse(newPeriod['startDate']!);
      final newEndDate = DateTime.parse(newPeriod['endDate']!);

      _pastPeriods.removeWhere((period) {
        final startDate = DateTime.parse(period['startDate']!);
        final endDate = DateTime.parse(period['endDate']!);
        // Check for overlap
        return (newStartDate.isBefore(endDate) && newEndDate.isAfter(startDate));
      });
    }
    _pastPeriods = List<Map<String, String>>.from(newPeriods);

    // Determine the latest start date
    String latestStartDate = _pastPeriods
        .map((period) => period['startDate']!)
        .reduce((a, b) => DateTime.parse(a).isAfter(DateTime.parse(b)) ? a : b);

    // Update the last period start if it's different
    if (DateTime.parse(latestStartDate) != lastPeriodStart) {
      updateLastPeriodStart(DateTime.parse(latestStartDate));
    }

    // Calculate and update period length if needed
    for (var period in _pastPeriods) {
      final startDate = DateTime.parse(period['startDate']!);
      final endDate = DateTime.parse(period['endDate']!);
      final periodLength = endDate.difference(startDate).inDays + 1;

      // Update the period length if it differs from the current length
      if (periodLength != _periodLength) {
        _periodLength = periodLength; // Update the period length
        updatePeriodLength(periodLength);
      }
    }
    predictedDays = List.generate(
      _periodLength,
          (index) => _lastPeriodStart.add(Duration(days: _cycleLength + index)),
    );

    refinePastPeriods();
    _initializeCycleData();
    _saveToHive(); // Persist the updated periods
    notifyListeners(); // Notify listeners to update UI
  }



  Future<void> retrieveCycleDataFromFirestore(BuildContext context) async {
    try {
      String? userId = await SessionManager.getUserId();
      if (userId == null) {
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
    // Count the number of valid periods (those with both 'startDate' and 'endDate')
    _totalCyclesLogged = _pastPeriods.where((period) {
      return period.containsKey('startDate') && period.containsKey('endDate');
    }).length;
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
  Future<void> _initializeCycleData() async {
    await rescheduleNotifications();

    updateFertileDays(lastPeriodStart, cycleLength, lutealPhaseLength);


    notifyListeners(); // Notify listeners to update the UI
  }


  void updateLutealPhaseLength(int length) {
    if (length <= 0) throw Exception("Luteal phase length must be positive.");
    _lutealPhaseLength = length;

    // Recalculate the ovulation date
    DateTime ovulationDate = _lastPeriodStart.add(Duration(days: _cycleLength - _lutealPhaseLength));

    // Update fertile days
    updateFertileDays(lastPeriodStart, cycleLength, lutealPhaseLength);

    _saveToHive();
    notifyListeners();
  }

// Get the fertility window start and end dates
  DateTime getFertilityWindowStart() {
    return lastPeriodStart.add(Duration(days: cycleLength - lutealPhaseLength - 5));
  }


  DateTime getFertilityWindowEnd() {
    return lastPeriodStart.add(Duration(days: cycleLength - lutealPhaseLength)); // Ovulation day
  }
  int getDynamicLutealPhase() {
    if (_pastPeriods.length < 2) {
      return 14; // Default if not enough data
    }

    List<int> lutealPhases = [];

    for (int i = 1; i < _pastPeriods.length; i++) {
      DateTime prevPeriodStart = DateTime.parse(_pastPeriods[i - 1]['startDate']!);
      DateTime ovulationDate = prevPeriodStart.add(Duration(days: (_cycleLength ~/ 2)));

      DateTime currentPeriodStart = DateTime.parse(_pastPeriods[i]['startDate']!);
      int lutealPhase = currentPeriodStart.difference(ovulationDate).inDays;

      if (lutealPhase > 8 && lutealPhase < 20) { // Reasonable luteal phase range
        lutealPhases.add(lutealPhase);
      }
    }

    if (lutealPhases.isNotEmpty) {
      return (lutealPhases.reduce((a, b) => a + b) / lutealPhases.length).round();
    }

    return 14; // Default if no valid calculations
  }


  List<DateTime> generateFertileDays() {
    DateTime start = getFertilityWindowStart();
    DateTime end = getFertilityWindowEnd();

    // Generate a list of fertile days
    List<DateTime> fertileDays = List.generate(
      end.difference(start).inDays + 1, // +1 to include the end date
          (index) => start.add(Duration(days: index)),
    );

    return fertileDays;
  }


  DateTime getOvulationDate() {
    return lastPeriodStart.add(Duration(days: cycleLength - lutealPhaseLength));
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

    saveCycleDataToFirestore();
    await rescheduleNotifications();
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
          // print("Fetched period already exists: ${fetchedPeriod['startDate']}");
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
      // print("No cycle data found in Hive.");
    }
  }

  Future<void> saveCycleDataToFirestore() async {
    if (await SessionManager.checkUserLoginStatus()) {
      try {
        String? userId = await SessionManager.getUserId();
        if (userId == null) {
          // print("User ID is null. Cannot save data.");
          return;
        }

        final cycles = FirebaseFirestore.instance.collection('cycles');
        Map<String, dynamic> cycleData = {
          'cycleStartDate': _lastPeriodStart.toIso8601String(),
          'cycleEndDate': _lastPeriodStart
              .add(Duration(days: _cycleLength-1))
              .toUtc()
              .toIso8601String(),
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
          // print("Cycle data updated successfully.");
        } else {
          // Document does not exist, create it
          await docRef.set(cycleData, SetOptions(merge: true));
          // print("Cycle data saved successfully.");
        }
      } catch (e, stackTrace) {
        // print("Error saving data: $e");
        // print("Stack trace: $stackTrace");
      }
    } else {
      // print("User is not logged in.");
    }
  }


  void updateCycleLength(int cycleLength) {
    if (cycleLength <= 0) {
      throw Exception("Cycle length must be a positive integer.");
    }
    _cycleLength = cycleLength;

    // Recalculate all related cycle data when cycle length is updated
    _initializeCycleData();
   updateFertileDays(_lastPeriodStart, _cycleLength, lutealPhaseLength);

    // Sync updated data with Hive
    _saveToHive();
    notifyListeners();

  }

  // Method to update only the period length
  void updatePeriodLength(int periodLength) {
    if (periodLength <= 0) {
      throw Exception("Period length must be a positive integer.");
    }
    _periodLength = periodLength;
    final endDate = lastPeriodStart.add(Duration(days: _periodLength));
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
    _lastPeriodStart = _calculateLatestDate();
    _saveToHive();
    _initializeCycleData();
    notifyListeners();
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


  // Method to get the fertile window days (usually between cycleLength - 14 and cycleLength - 6)
  List<DateTime> get fertileDaysRange {
    return fertileDays;
  }
List<DateTime> get predictedPeriodDays {
    return predictedDays;
  }
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
