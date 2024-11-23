import 'package:flutter/material.dart';

class TemperatureData extends ChangeNotifier {
  double _temperature = 98.0; // Default temperature
  DateTime _lastEnteredDate = DateTime.now(); // Default date

  double get temperature => _temperature;
  DateTime get lastEnteredDate => _lastEnteredDate;

  void updateTemperature(double newTemperature) {
    _temperature = newTemperature;
    _lastEnteredDate = DateTime.now();
    notifyListeners(); // Notify listeners when data changes
  }
}
