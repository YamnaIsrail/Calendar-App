import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsModel with ChangeNotifier {
  final Box _formatsettingsBox = Hive.box('formatsettingsBox');

  String get firstDayOfWeek => _formatsettingsBox.get('firstDayOfWeek', defaultValue: "Sunday");
  String get dateFormat => _formatsettingsBox.get('dateFormat', defaultValue: "dd/MM/yyyy");

  void setFirstDayOfWeek(String day) {
    _formatsettingsBox.put('firstDayOfWeek', day);
    notifyListeners();
  }

  void setDateFormat(String format) {
    _formatsettingsBox.put('dateFormat', format);
    notifyListeners();
  }
}