import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cycle_provider.dart';
import 'package:hive/hive.dart';


class IntercourseProvider with ChangeNotifier {
  // Box for storing data in Hive
  Box? _box;

  // Sections visibility map
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
  int _times = 1;
  String _condomOption = "Unprotected"; // Default option
  String _femaleOrgasm = "Not Happened"; // Default option

  int get times => _times;
  String get condomOption => _condomOption;
  String get femaleOrgasm => _femaleOrgasm;

  // Method to increment the times value
  void incrementTimes() {
    _times++;
    _saveData(); // Save to Hive after update
    notifyListeners();
  }

  // Method to decrement the times value
  void decrementTimes() {
    if (_times > 0) {
      _times--;
      _saveData(); // Save to Hive after update
      notifyListeners();
    }
  }

  // Method to update the condom option
  void updateCondomOption(String option) {
    _condomOption = option;
    _saveData(); // Save to Hive after update
    notifyListeners();
  }

  // Method to update the female orgasm option
  void updateFemaleOrgasm(String option) {
    _femaleOrgasm = option;
    _saveData(); // Save to Hive after update
    notifyListeners();
  }

  // Initialize Hive box
  Future<void> _initHive() async {
    if (_box == null) {
      _box = await Hive.openBox('intercourseData');
    }
  }

  // Method to save data in Hive
  Future<void> _saveData() async {
    await _initHive();
    await _box?.put('times', _times);
    await _box?.put('condomOption', _condomOption);
    await _box?.put('femaleOrgasm', _femaleOrgasm);
  }

  // Method to load data from Hive
  Future<void> loadData() async {
    await _initHive();
    _times = _box?.get('times', defaultValue: 1) ?? 1;
    _condomOption = _box?.get('condomOption', defaultValue: "Unprotected") ?? "Unprotected";
    _femaleOrgasm = _box?.get('femaleOrgasm', defaultValue: "Not Happened") ?? "Not Happened";
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
    _saveData(); // Save to Hive
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

class xIntercourseProvider with ChangeNotifier {
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
  int _times = 1;
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

  // Method to calculate pregnancy chance for each cycle day
  // double calculatePregnancyChance(CycleProvider cycleProvider, DateTime intercourseDate) {
  //   DateTime lastPeriodDate = cycleProvider.lastPeriodStart;
  //   int cycleLength = cycleProvider.cycleLength;
  //
  //   // Ovulation window (typically days 10-15 of the cycle)
  //   int ovulationStart = cycleLength ~/ 2 - 1;
  //   int ovulationEnd = ovulationStart + 4;
  //
  //   // Check if intercourse happened during the fertile window
  //   if (intercourseDate.isAfter(lastPeriodDate.add(Duration(days: ovulationStart))) &&
  //       intercourseDate.isBefore(lastPeriodDate.add(Duration(days: ovulationEnd)))) {
  //     // Higher chance if intercourse is during ovulation window
  //     return 80.0; // 80% chance
  //   } else if (intercourseDate.isBefore(lastPeriodDate)) {
  //     // Intercourse before the period, less chance
  //     return 20.0; // 20% chance
  //   } else {
  //     // Outside of fertile window but after ovulation, low chance
  //     return 10.0; // 10% chance
  //   }
  // }

}

