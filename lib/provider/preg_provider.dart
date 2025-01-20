  import 'package:calender_app/provider/cycle_provider.dart';
  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
  class PregnancyModeProvider with ChangeNotifier {
    final CycleProvider cycleProvider = CycleProvider();

    // Hive box for storing data
    late Box _pregnancyBox;

    // State variables
    bool _isPregnancyMode = false;
    DateTime? _gestationStart;
    DateTime? _dueDate;
    List<String> _loggedSymptoms = [];
    int? _gestationWeeks;
    int? _gestationDays;
    int get daysSinceGestation => _gestationStart == null ? 0 : DateTime.now().difference(_gestationStart!).inDays;

    // Getters
    bool get isPregnancyMode => _isPregnancyMode;
    DateTime? get gestationStart => _gestationStart;

    DateTime? get dueDate => gestationStart!.add(Duration(days: 280)); // 280 days after gestation start

    // DateTime? get dueDate => _dueDate;

    List<String> get loggedSymptoms => _loggedSymptoms;
    int get gestationWeeks => _gestationStart == null ? 0 : daysSinceGestation ~/ 7;

    // Calculate remaining gestation days within the week
    int get gestationDays => _gestationStart == null ? 0 : daysSinceGestation % 7;

    // int? get gestationWeeks => _gestationWeeks;
    // int? get gestationDays => _gestationDays;

    // Open Hive box and load initial data
    Future<void> initHive() async {
      _pregnancyBox = await Hive.openBox('pregnancyBox');

      _isPregnancyMode = _pregnancyBox.get('isPregnancyMode', defaultValue: false);
      _gestationStart = _pregnancyBox.get('gestationStart');
      // _gestationWeeks = _pregnancyBox.get('gestationWeeks');
      // _gestationDays = _pregnancyBox.get('gestationDays');
      // _dueDate = _pregnancyBox.get('dueDate');

      notifyListeners();
    }
    /// Calculates gestational weeks and days since the gestation start date
    void calculateGestationWeeksAndDays() {
      if (_gestationStart == null) return;

      final now = DateTime.now();
      final daysSinceStart = now.difference(_gestationStart!).inDays;

      _gestationWeeks = daysSinceStart ~/ 7;
      _gestationDays = daysSinceStart % 7;
      _dueDate = _gestationStart?.add(Duration(days: 280));
      final dueDate = _gestationStart!.add(Duration(days: 280)); // 280 days after gestation start
      final remainingDays = dueDate.difference(now).inDays; // Calculate days remaining until the due date

      notifyListeners();
    }
    set gestationStart(DateTime? newStart) {
      _gestationStart = newStart;
      calculateGestationWeeksAndDays();
      // Save to Hive
      _pregnancyBox.put('gestationStart', _gestationStart);
      notifyListeners();
    }



    /// Fetch the last period start from Firebase if available and sync with the provider.
    Future<void> syncAndInitializeStart(String userId) async {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('pregnancy')
            .doc(userId)
            .get();

        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data()!;
          if (data['lastPeriodStart'] != null) {
            _gestationStart = DateTime.parse(data['lastPeriodStart']);
            calculateGestationWeeksAndDays();
            notifyListeners();
          }
        }
      } catch (e) {
        print("Error fetching initial gestation data: $e");
      }
    }

    /// Save pregnancy mode to Hive
    void togglePregnancyMode(bool value) {
      _isPregnancyMode = value;
      _pregnancyBox.put('isPregnancyMode', _isPregnancyMode);

      if (_isPregnancyMode) {
        // Initialize gestation logic
        _gestationStart = cycleProvider.lastPeriodStart;
        calculateGestationWeeksAndDays();
      } else {
        // Clear any pregnancy-related states
        _gestationStart = null;
        _gestationWeeks = null;
        _gestationDays = null;
      }

      // Save to Hive
      _pregnancyBox.put('gestationStart', _gestationStart);
      _pregnancyBox.put('gestationWeeks', _gestationWeeks);
      _pregnancyBox.put('gestationDays', _gestationDays);
      _pregnancyBox.put('dueDate', _dueDate);

      notifyListeners();
    }

  }

