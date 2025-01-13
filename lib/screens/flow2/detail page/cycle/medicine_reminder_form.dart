
import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class MedicineReminderScreen extends StatefulWidget {
  final List<String> selectedMedicines;
  final String? editingMedicine;
  MedicineReminderScreen({
    required this.selectedMedicines,
    this.editingMedicine,
  });

  @override
  _MedicineReminderScreenState createState() =>
      _MedicineReminderScreenState();
}

class _MedicineReminderScreenState extends State<MedicineReminderScreen> {
  TimeOfDay? reminderTime;
  DateTime? startDate;
  List<TimeOfDay?> reminderTimes = [TimeOfDay.now()];
  int intakePerDay = 1;
  String interval = "Everyday";
  String duration = "Forever";
  bool isNotificationEnabled = true;

  late TextEditingController medicineController;
  @override
  void initState() {
    super.initState();
    medicineController = TextEditingController(
      text: widget.editingMedicine ?? "",
    );

    if (widget.editingMedicine != null) {
      final box = Hive.box<Map>('medicineReminders');
      final reminder = box.get(widget.editingMedicine);

      if (reminder != null) {
        setState(() {
          startDate = DateTime.parse(reminder['startDate']);

          // Ensure reminder['reminderTime'] is not null before splitting
          if (reminder['reminderTimes'] != null) {
            reminderTimes = (reminder['reminderTimes'] as List)
                .map((time) {
              final timeParts = time.split(':');
              return TimeOfDay(
                hour: int.parse(timeParts[0]),
                minute: int.parse(timeParts[1]),
              );
            }).toList();
          } else {
            reminderTimes = [TimeOfDay.now()];
          }

          intakePerDay = reminder['intakePerDay'] ?? 1;
          interval = reminder['interval'];
          duration = reminder['duration'];
          isNotificationEnabled = reminder['isNotificationEnabled'];
        });
      }
    }
  }



  @override
  void dispose() {
    medicineController.dispose();
    super.dispose();
  }

  void _pickStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate;
      });
    }
  }

  void _pickReminderTime(int index) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: reminderTimes[index] ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        reminderTimes[index] = pickedTime;
      });
    }
  }
  void _updateIntakePerDay(int value) {
    setState(() {
      intakePerDay = value;
      // Ensure the list of times matches the number of intakes per day
      if (reminderTimes.length > intakePerDay) {
        reminderTimes = reminderTimes.sublist(0, intakePerDay);
      } else {
        while (reminderTimes.length < intakePerDay) {
          reminderTimes.add(TimeOfDay.now());
        }
      }
    });
  }
  Future<void> _saveReminder() async {
    // Validate input
    if (medicineController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a medicine name")),
      );
      return;
    }

    if (isNotificationEnabled) {
      if (startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select a start date")),
        );
        return;
      }

      if (reminderTimes.any((time) => time == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select all reminder times")),
        );
        return;
      }
    }

    // Combine start date and reminder times
    final initialSchedules = reminderTimes.map((time) {
      return DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        time!.hour,
        time.minute,
      );
    }).toList();

    // Ensure no past time is scheduled
    if (isNotificationEnabled) {
      if (initialSchedules.any((date) => date.isBefore(DateTime.now()))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Scheduled times cannot be in the past")),
        );
        return;
      }
    }

    // Request notification permission
    bool isPermissionGranted = await NotificationService.requestNotificationPermission();
    if (!isPermissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Notification permission is required")),
      );
      return;
    }

    // Prepare reminder data
    final reminderData = {
      'startDate': startDate!.toIso8601String(),
      'reminderTimes': reminderTimes.map((time) => "${time!.hour}:${time.minute}").toList(),
      'intakePerDay': intakePerDay,
      'interval': interval,
      'duration': duration,
      'isNotificationEnabled': isNotificationEnabled,
    };

    final box = Hive.box<Map>('medicineReminders');
    box.put(medicineController.text, reminderData);

    // Schedule notifications if enabled
    if (isNotificationEnabled) {
      List<DateTime> schedules = initialSchedules;

      // Calculate interval-based schedules
      int durationDays = 0;
      switch (duration) {
        case "1 Day":
          durationDays = 1;
          break;
        case "7 Days":
          durationDays = 7;
          break;
        case "1 Month":
          durationDays = 30;
          break;
        case "Forever":
          durationDays = 365 * 10; // Arbitrary long duration for "Forever"
          break;
      }

      DateTime currentDate = startDate!;
      while (currentDate.isBefore(startDate!.add(Duration(days: durationDays)))) {
        for (var time in reminderTimes) {
          schedules.add(DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            time!.hour,
            time.minute,
          ));
        }

        // Increment currentDate based on the interval
        currentDate = interval == "Everyday"
            ? currentDate.add(Duration(days: 1))
            : currentDate.add(Duration(days: 7));
      }

      // Schedule each notification
      for (var time in schedules) {
        int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
        await NotificationService.scheduleNotification(
          notificationId,
          "Medicine Reminder",
          "Time to take ${medicineController.text}",
          time,
        );
      }

      await NotificationService.showInstantNotification(
        'Notifications Enabled',
        'You will now receive notifications for ${medicineController.text}.',
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reminder saved successfully")),
    );

    Navigator.pop(context, true);
  }



  void fetchReminders() {
    final box = Hive.box<Map>('medicineReminders');
    final reminders = box.toMap();

    reminders.forEach((key, value) {
      print("Medicine: $key, Details: $value");
    });
  }
  void deleteReminder(String medicineName) {
    final box = Hive.box<Map>('medicineReminders');
    box.delete(medicineName);
  }


  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.editingMedicine != null
              ? "Edit Medicine Reminder"
              : "Add Medicine Reminder"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              SwitchListTile(
                title: Text("Notifications"),
                value: isNotificationEnabled,
                onChanged: (value) async {
                  setState(() {
                    isNotificationEnabled = value;
                  });

                  if (!isNotificationEnabled) {
                    final box = Hive.box<Map>('medicineReminders');
                    final reminder = box.get(medicineController.text);

                    if (reminder != null && reminder['notificationIds'] != null) {
                      final notificationIds = reminder['notificationIds'] as List;

                      // Cancel all notifications using the stored notification IDs
                      for (var notificationId in notificationIds) {
                        await NotificationService.cancelScheduledTask(notificationId);
                      }
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Notifications Disabled")),
                    );
                  }
                },
              ),

              TextField(
                controller: medicineController,
                decoration: InputDecoration(
                  labelText: "Medicine Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text("Start Date"),
                subtitle: Text(
                  startDate != null
                      ? "${startDate!.toLocal()}".split(' ')[0]
                      : "Select Start Date",
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickStartDate,
              ),
              DropdownButtonFormField<int>(
                value: intakePerDay,
                onChanged: (value) => _updateIntakePerDay(value!),
                items: List.generate(
                  5,
                      (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text("${index + 1} times per day"),
                  ),
                ),
                decoration: InputDecoration(labelText: "Intake Per Day"),
              ),
              ...List.generate(
                intakePerDay,
                    (index) => ListTile(
                  title: Text("Reminder Time ${index + 1}"),
                  subtitle: Text(
                    reminderTimes[index] != null
                        ? reminderTimes[index]!.format(context)
                        : "Select Time",
                  ),
                  trailing: Icon(Icons.access_time),
                  onTap: () => _pickReminderTime(index),
                ),
              ),

              DropdownButtonFormField<String>(
                value: interval,
                onChanged: (value) {
                  setState(() {
                    interval = value!;
                  });
                },
                items: ["Everyday", "Weekly"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(labelText: "Interval"),
              ),
              DropdownButtonFormField<String>(
                value: duration,
                onChanged: (value) {
                  setState(() {
                    duration = value!;
                  });
                },
                items: ["Forever", "1 Day", "7 Days", "1 Month"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(labelText: "Duration"),
              ),
              SizedBox(height: 20),
              CustomButton(
                  backgroundColor: primaryColor,
                  onPressed: _saveReminder,
                  text: widget.editingMedicine != null
                      ? "Update Reminder"
                      : "Save Reminder")

            ],
          ),
        ),
      ),
    );
  }


}

