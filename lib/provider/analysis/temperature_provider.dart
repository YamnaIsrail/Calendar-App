import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TemperatureProvider with ChangeNotifier {
  List<Map<String, dynamic>> _temperatureData = [];
  String _lastDate = ''; // To store the last entered date

  List<Map<String, dynamic>> get temperatureData => _temperatureData;
  String get lastDate => _lastDate;

  // Method to add a new temperature entry
  void addTemperature(double temperature, [String? date]) {
    String currentDate = date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());

    _temperatureData.add({
      'temperature': temperature,
      'date': currentDate,
    });
    _lastDate = currentDate; // Update the last entered date
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
