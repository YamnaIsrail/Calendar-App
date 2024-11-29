import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

class PairedDaysProvider with ChangeNotifier {
  int _daysPaired = 1;
  DateTime? _loginDate;

  int get daysPaired => _daysPaired;

  // Initialize the paired days by fetching the login date from Hive
  Future<void> initializePairedDays() async {
    try {
      // Open the Hive box where we will store the login date
      var box = await Hive.openBox('userData');

      // Fetch stored login date from Hive
      String? storedLoginDate = box.get('loginDate');
      DateTime currentDate = DateTime.now();

      if (storedLoginDate == null) {
        // First login, set current date as login date
        await box.put('loginDate', DateFormat('yyyy-MM-dd').format(currentDate));
        _daysPaired = 1;
      } else {
        // Calculate the difference in days
        DateTime loginDate = DateFormat('yyyy-MM-dd').parse(storedLoginDate);
        _daysPaired = currentDate.difference(loginDate).inDays + 1;
      }

      notifyListeners();
    } catch (e) {
      print("Error initializing paired days: $e");
    }
  }

  // Reset the paired days and remove the login date from Hive
  Future<void> resetPairedDays() async {
    try {
      var box = await Hive.openBox('userData');
      await box.delete('loginDate');  // Remove the login date from Hive
      _daysPaired = 1;
      notifyListeners();
    } catch (e) {
      print("Error resetting paired days: $e");
    }
  }
}
