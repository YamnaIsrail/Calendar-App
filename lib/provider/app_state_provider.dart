import 'package:flutter/material.dart';
import 'cycle_provider.dart';
import 'preg_provider.dart';

class AppStateProvider with ChangeNotifier {
  final CycleProvider cycleProvider = CycleProvider();
  final PregnancyProvider pregnancyProvider = PregnancyProvider();

// Handle other app-wide states if needed (e.g., dark mode, settings)
}
