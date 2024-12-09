  import 'package:calender_app/provider/cycle_provider.dart';
  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';

  class PregnancyModeProvider with ChangeNotifier {
    final CycleProvider cycleProvider = CycleProvider();

    // State variables
    bool _isPregnancyMode = false; // Single source of truth
    DateTime? _gestationStart;
    DateTime? _dueDate;
    List<String> _loggedSymptoms = [];
    int? _gestationWeeks;
    int? _gestationDays;

    // Getters
    bool get isPregnancyMode => _isPregnancyMode;
    DateTime? get gestationStart => _gestationStart;
    DateTime? get dueDate => _dueDate;
    List<String> get loggedSymptoms => _loggedSymptoms;
    int? get gestationWeeks => _gestationWeeks;
    int? get gestationDays => _gestationDays;

    /// Toggles pregnancy mode and handles related logic
    void togglePregnancyMode(bool value) {
      _isPregnancyMode = value;

      if (_isPregnancyMode) {
        // If pregnancy mode is enabled, initialize gestation logic
        _gestationStart = cycleProvider.lastPeriodStart;
        _calculateGestationWeeksAndDays();
      } else {
        // Clear any pregnancy-related states
        _gestationStart = null;
        _gestationWeeks = null;
        _gestationDays = null;
      }

      notifyListeners();
    }

    /// Log symptoms to Firebase & local state
    Future<void> logSymptom(String symptom, String userId) async {
      try {
        await FirebaseFirestore.instance
            .collection('pregnancy')
            .doc(userId)
            .update({
          'symptoms': FieldValue.arrayUnion([symptom]),
        });

        _loggedSymptoms.add(symptom);
        notifyListeners();
      } catch (e) {
        print("Could not log symptom: $e");
      }
    }

    /// Calculates gestational weeks and days since the gestation start date
    void _calculateGestationWeeksAndDays() {
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
            _calculateGestationWeeksAndDays();
            notifyListeners();
          }
        }
      } catch (e) {
        print("Error fetching initial gestation data: $e");
      }
    }
  }
