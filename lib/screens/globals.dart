// globals.dart
library my_project.globals;

import 'dart:ui';
import 'package:flutter/material.dart';

int selectedDays = 4; // Default value for the length of the period
int selectedCycleDays = 28; // Default value for cycle length
DateTime lastPeriodStartDate = DateTime(2020, 1, 1); // Default start date

Color primaryColor= Color(0xFFEB1D98);

Color secondaryColor= Color(0xFFCFDCFF);

class AppTheme {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFFFFE0B2), // equivalent to Colors.deepOrange[50]
      Color(0xFFFFAB91), // equivalent to Colors.deepOrange[200]
      Color(0xFFFF5722), // equivalent to Colors.deepOrange
    ],
    stops: [0.0, 0.5, 1.0],
  );
}