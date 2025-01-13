import 'package:calender_app/provider/date_day_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class TemperatureProvider with ChangeNotifier {
  List<Map<String, dynamic>> _temperatureData = [];
  String _lastDate = ''; // To store the last entered date

  List<Map<String, dynamic>> get temperatureData => _temperatureData;
  String get lastDate => _lastDate;

  // Hive Box instance
  Box _temperatureBox = Hive.box('temperatureBox');

  TemperatureProvider() {
    _loadTemperatureData();
  }
  void _loadTemperatureData() {
    List<dynamic> storedData = _temperatureBox.get('temperatures', defaultValue: []);

    // Ensure the data is in the correct format
    _temperatureData = storedData.map((item) {
      if (item is Map) {
        return Map<String, dynamic>.from(item);
      } else {
        return {'temperature': 0.0, 'date': 'Invalid Date'}; // Default value for invalid entries
      }
    }).toList();

    if (_temperatureData.isNotEmpty) {
      _lastDate = _temperatureData.last['date'];
    }
    notifyListeners();
  }
  // Method to add a new temperature entry
  void addTemperature(double temperature,  [String? date] ) {
    String currentDate = date ?? DateFormat("yyyy-MM-dd").format(DateTime.now());

    // Create a new entry as a map
    Map<String, dynamic> newEntry = {
      'temperature': temperature,
      'date': currentDate,
    };

    // Add the new entry to the existing list
    _temperatureData.add(newEntry);

    // Save the updated list to Hive
    _temperatureBox.put('temperatures', _temperatureData);

    notifyListeners(); // Notify listeners to update the UI
  }
  String getLatestTemperatureDate() {
    return _temperatureData.isNotEmpty ? _temperatureData.last['date'] : 'No Data';
  }

  // Method to get the latest temperature
  double getLatestTemperature() {
    return _temperatureData.isNotEmpty
        ? _temperatureData.last['temperature']
        : 0.0;
  }
}

//
// class TemperatureProvider with ChangeNotifier {
//   List<Map<String, dynamic>> _temperatureData = [];
//   String _lastDate = ''; // To store the last entered date
//
//   List<Map<String, dynamic>> get temperatureData => _temperatureData;
//   String get lastDate => _lastDate;
//
//   // Method to add a new temperature entry
//   void addTemperature(double temperature, [String? date]) {
//     String currentDate = date ?? DateFormat(context.watch<SettingsModel>().dateFormat).format(DateTime.now());
//
//     _temperatureData.add({
//       'temperature': temperature,
//       'date': currentDate,
//     });
//     _lastDate = currentDate; // Update the last entered date
//     notifyListeners(); // Notify listeners to update the UI
//   }
//
//
//   String getLatestTemperatureDate() {
//     return _temperatureData.isNotEmpty ? _temperatureData.last['date'] : 'No Data';
//   }
//   // Method to get the latest temperature
//   double getLatestTemperature() {
//     return _temperatureData.isNotEmpty
//         ? _temperatureData.last['temperature']
//         : 0.0;
//   }
// }
