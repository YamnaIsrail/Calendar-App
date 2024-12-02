import 'package:calender_app/hive/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../hive/cycle_model.dart';
import '../hive/medicine_model.dart';
import 'cycle_provider.dart';

class AppDataProvider with ChangeNotifier {
  Box<MedicineReminder> _medicineReminderBox;
  Box<Note> _noteBox;
  Box<CycleData> _cycleDataBox;

  AppDataProvider()
      : _medicineReminderBox = Hive.box('medicine_reminders'),
        _noteBox = Hive.box('notes'),
        _cycleDataBox = Hive.box('cycle_data');

  List<MedicineReminder> get medicineReminders => _medicineReminderBox.values.toList();
  List<Note> get notes => _noteBox.values.toList();
  List<CycleData> get cycleData => _cycleDataBox.values.toList();

  void addMedicineReminder(MedicineReminder reminder) {
    _medicineReminderBox.add(reminder);
    notifyListeners();
  }

  void removeMedicineReminder(MedicineReminder reminder) {
    _medicineReminderBox.delete(reminder);
    notifyListeners();
  }

  void addNote(Note note) {
    _noteBox.add(note);
    notifyListeners();
  }

  void removeNote(Note note) {
    _noteBox.delete(note);
    notifyListeners();
  }

  void updateCycleData(CycleData cycle) {
    _cycleDataBox.put(0, cycle); // Assuming only one cycle data entry
    notifyListeners();
  }
}
