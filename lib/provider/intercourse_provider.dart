import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cycle_provider.dart';
class IntercourseProvider with ChangeNotifier {
  // Sections visibility for toggling visibility of different parts of the UI
  final Map<String, bool> _sectionsVisibility = {
    'Condom Option': true, // Set to true by default
    'Female Orgasm': true, // Set to true by default
    'Times': true,         // Set to true by default
    'Intercourse Chart': true, // Set to true by default
    'Intercourse Activity': true, // Set to true by default
    'Forum': true,         // Set to true by default
    'Frequency Statistics': true, // Set to true by default
  };

  // Getter for visibility
  bool isSectionVisible(String section) => _sectionsVisibility[section] ?? false;

  // Toggle visibility for a section
  void toggleSection(String section) {
    if (_sectionsVisibility.containsKey(section)) {
      _sectionsVisibility[section] = !_sectionsVisibility[section]!; // Toggle the section visibility
      notifyListeners();
    }
  }

  // Getter for all sections
  Map<String, bool> get sections => _sectionsVisibility;

  // Times counter
  int _times = 0;
  String _condomOption = "Unprotected"; // Default option
  String _femaleOrgasm = "Unprotected"; // Default option

  int get times => _times;
  String get condomOption => _condomOption;
  String get femaleOrgasm => _femaleOrgasm;

  // Method to increment the times value
  void incrementTimes() {
    _times++;
    notifyListeners();
  }

  // Method to decrement the times value
  void decrementTimes() {
    if (_times > 0) {
      _times--;
      notifyListeners();
    }
  }

  // Method to update the condom option
  void updateCondomOption(String option) {
    _condomOption = option;
    notifyListeners();
  }

  // Method to update the female orgasm option
  void updateFemaleOrgasm(String option) {
    _femaleOrgasm = option;
    notifyListeners();
  }

  // Getter for intercourse activity data
  List<Map<String, dynamic>> _intercourseActivityData = [];

  List<Map<String, dynamic>> get intercourseActivityData => _intercourseActivityData;

  // Method to update intercourse activity data (if needed)
  void updateActivityData(Map<String, dynamic> newData) {
    _intercourseActivityData.add(newData); // Store the new data
    notifyListeners();
  }

  // Method to save all selections
  void saveSelections() {
    final activityData = {
      'condomOption': _condomOption,
      'femaleOrgasm': _femaleOrgasm,
      'times': _times,
    };

    _intercourseActivityData.add(activityData); // Save the selections
    notifyListeners();
  }

  DateTime? intercourseDate; // Declare intercourseDate to use in logic

  bool didIntercourseHappenDuringFertileWindow(BuildContext context) {
    // Accessing the CycleProvider using the context inside the method
    final cycleProvider = Provider.of<CycleProvider>(context, listen: false);

    // Logic to check if intercourse happened during the fertile window
    if (intercourseDate != null) {
      return cycleProvider.isInFertileWindow();
    }
    return false;
  }
}
