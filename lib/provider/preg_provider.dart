import 'package:flutter/material.dart';

class PregnancyProvider with ChangeNotifier {
  DateTime _lastMenstrualPeriod = DateTime.now();
  DateTime _dueDate = DateTime.now().add(Duration(days: 280)); // Default due date (40 weeks from LMP)

  DateTime get lastMenstrualPeriod => _lastMenstrualPeriod;
  DateTime get dueDate => _dueDate;

  // Update pregnancy info
  void updatePregnancyInfo(DateTime lmp, DateTime due) {
    _lastMenstrualPeriod = lmp;
    _dueDate = due;
    notifyListeners();
  }

  // Calculate current week of pregnancy
  int getCurrentWeek() {
    return DateTime.now().difference(_lastMenstrualPeriod).inDays ~/ 7;
  }

  // Days until due date
  int getDaysUntilDueDate() {
    return _dueDate.difference(DateTime.now()).inDays;
  }
}
