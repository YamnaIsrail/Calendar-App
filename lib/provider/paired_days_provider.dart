// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class PairedDaysProvider with ChangeNotifier {
//   int _daysPaired = 1;
//   DateTime? _loginDate;
//
//   int get daysPaired => _daysPaired;
//
//   // Fetch stored login date and calculate the days difference
//   Future<void> initializePairedDays() async {
//     //SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedLoginDate = prefs.getString('loginDate');
//     DateTime currentDate = DateTime.now();
//
//     if (storedLoginDate == null) {
//       // First login, set current date as login date
//       await prefs.setString('loginDate', DateFormat('yyyy-MM-dd').format(currentDate));
//       _daysPaired = 1;
//     } else {
//       // Calculate the difference in days
//       DateTime loginDate = DateFormat('yyyy-MM-dd').parse(storedLoginDate);
//       _daysPaired = currentDate.difference(loginDate).inDays + 1;
//     }
//     notifyListeners();
//   }
//
//   // Reset the paired days if needed (optional)
//   Future<void> resetPairedDays() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('loginDate');
//     _daysPaired = 1;
//     notifyListeners();
//   }
// }
