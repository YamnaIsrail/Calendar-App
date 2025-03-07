import 'dart:io';

import 'package:calender_app/hive/partner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

class PartnerProvider with ChangeNotifier {
  final Box _cycleBox = Hive.box('partnerCycleData');
  String? user1Id;
  DateTime? _lastMenstrualPeriod;
  DateTime? _cycleEndDate;
  int lutealPhaseLength = 14;
  int _cycleLength = 4;
  int? _periodLength;
  DateTime? _dueDate;
  bool _pregnancyMode = false;
  DateTime? _gestationStart;
  List<Map<String, String>> _pastPeriods = [];  // Store all past period start dates as strings
  List<Map<String, String>> get pastPeriods => _pastPeriods;

  DateTime? get cycleEndDate => _cycleEndDate;

  bool get isPregnancyMode => _cycleBox.get('pregnancyMode') ?? false;

  int? get cycleLength => _cycleBox.get('cycleLength');

  int? get periodLength => _cycleBox.get('periodLength');

  bool get pregnancyMode => _cycleBox.get('pregnancyMode') ?? false;


  int get daysSinceGestation => _gestationStart == null ? 0 : DateTime.now().difference(_gestationStart!).inDays;

  int get gestationWeeks => _gestationStart == null ? 0 : daysSinceGestation ~/ 7;

  // Calculate remaining gestation days within the week
  int get gestationDays => _gestationStart == null ? 0 : daysSinceGestation % 7;


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

        } else {
        // print("No data found for User 1.");
      }
    } catch (e) {
      // print("Error fetching User 1's cycle data: $e");
    }

    initializeCycleData();
    notifyListeners();  // Ensure UI updates

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


        // Ensure mandatory fields are present
        if (pregnancyData['cycleStartDate'] == null) {
          throw Exception("cycleStartDate is missing");
        }

        // Parse mandatory fields with null checks
        DateTime cycleStartDate = DateTime.parse(pregnancyData['cycleStartDate']);

        // Check if cycleLength and periodLength are null, and set defaults
        int cycleLength = (pregnancyData['cycleLength'] as int?) ?? 28; // Default to 28 days if null
        int periodLength = (pregnancyData['periodLength'] as int?) ?? 5; // Default to 5 days if null

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

      } else {
        // print("No data found for User 1.");
      }
    } catch (e) {
      // print("Error fetching User 1's cycle data: $e");
    }

    initializeCycleData();
    notifyListeners();  // Ensure UI updates

  }
  void updateFertileDays(DateTime lastPeriodStart, int cycleLength,
      int lutealPhaseLength) {
    DateTime fertileStart = getFertilityWindowStart();
    DateTime fertileEnd = getFertilityWindowEnd();
    fertileDays = List.generate(
      fertileEnd.difference(fertileStart).inDays + 1,
          (index) => fertileStart.add(Duration(days: index)),
    );

    predictedDays = List.generate(
      periodLength!,
          (index) => lastPeriodStart.add(Duration(days: cycleLength + index)),
    );
    periodDays = List.generate(
      periodLength!,
          (index) => lastPeriodStart.add(Duration(days: index)),
    );


  }

  DateTime getFertilityWindowStart() {
    return lastMenstrualPeriod!.add(Duration(days: cycleLength! - lutealPhaseLength - 5));
  }


  DateTime getFertilityWindowEnd() {
    return lastMenstrualPeriod!.add(Duration(days: cycleLength! - lutealPhaseLength)); // Ovulation day
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
      // print("Cycle data is incomplete.");
      return;
    }

    // lutealPhaseLength = getDynamicLutealPhase();

    updateFertileDays(lastMenstrualPeriod!, cycleLength!, lutealPhaseLength);

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

  Future<bool> listenForCycleUpdates() async {
    try {
      // Check internet connectivity
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw SocketException("No internet connection");
      }

      String? savedUser1Id = _cycleBox.get('user1Id');

      if (savedUser1Id == null) {
        throw Exception("User 1 ID not found in Hive.");
      }

      var snapshot = await FirebaseFirestore.instance
          .collection('cycles')
          .doc(savedUser1Id)
          .get(); // Fetch data once instead of listening

      if (!snapshot.exists) {
        throw Exception("No data found for User 1 in Firebase.");
      }

      var pregnancyData = snapshot.data() as Map<String, dynamic>;

      // Parse mandatory fields with default values
      DateTime cycleStartDate = DateTime.parse(pregnancyData['cycleStartDate']);
      int cycleLength = (pregnancyData['cycleLength'] as int?) ?? 28;
      int periodLength = (pregnancyData['periodLength'] as int?) ?? 5;
      bool isPregnancyMode = pregnancyData['pregnancyMode'] ?? false; // Fetch updated pregnancy mode

      // Update Hive storage
      _cycleBox.put('lastMenstrualPeriod', cycleStartDate.toIso8601String());
      _cycleBox.put('cycleLength', cycleLength);
      _cycleBox.put('periodLength', periodLength);
      _cycleBox.put('pregnancyMode', isPregnancyMode); // Update pregnancy mode in Hive

      // Update class variables
      _lastMenstrualPeriod = cycleStartDate;
      _cycleLength = cycleLength;
      _periodLength = periodLength;

      _pregnancyMode = isPregnancyMode; // Update the class variable
      initializeCycleData();
      notifyListeners(); // Notify listeners to update UI
      return true;

    } on SocketException {
      // print("No internet connection.");
      return false;
    } on FirebaseException catch (e) {
      // print("Firebase error: ${e.message}");
      return false;
    } catch (e) {
      // print("Sync failed: $e");
      return false;
    }
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

}
