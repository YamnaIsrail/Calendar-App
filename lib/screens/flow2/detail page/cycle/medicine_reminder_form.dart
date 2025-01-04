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
  DateTime? startDate;
  TimeOfDay? reminderTime;
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
          final timeParts = reminder['reminderTime'].split(':');
          reminderTime = TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]),
          );
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

  void _pickReminderTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        reminderTime = pickedTime;
      });
    }
  }

  Future<void> _saveReminder() async {
    if (medicineController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a medicine name")),
      );
      return;
    }

    if (startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a start date")),
      );
      return;
    }

    if (reminderTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a reminder time")),
      );
      return;
    }

    // Combine start date and reminder time
    final scheduleDate = DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      reminderTime!.hour,
      reminderTime!.minute,
    );

    if (scheduleDate.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Scheduled time cannot be in the past")),
      );
      return;
    }

    // Create a reminder object
    final reminder = {
      'startDate': startDate!.toIso8601String(),
      'reminderTime': "${reminderTime!.hour}:${reminderTime!.minute}",
      'interval': interval,
      'duration': duration,
      'isNotificationEnabled': isNotificationEnabled,
    };

    // Save to Hive
    final box = Hive.box<Map>('medicineReminders');
    box.put(medicineController.text, reminder);

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

  // Future<void> _saveReminder() async {
  //   // Validate input
  //   if (medicineController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please enter a medicine name")),
  //     );
  //     return;
  //   }
  //
  //   if (startDate == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please select a start date")),
  //     );
  //     return;
  //   }
  //
  //   if (reminderTime == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please select a reminder time")),
  //     );
  //     return;
  //   }
  //
  //   // Combine start date and reminder time
  //   final scheduleDate = DateTime(
  //     startDate!.year,
  //     startDate!.month,
  //     startDate!.day,
  //     reminderTime!.hour,
  //     reminderTime!.minute,
  //   );
  //
  //   // Check if the schedule date/time is in the past
  //   if (scheduleDate.isBefore(DateTime.now())) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Scheduled time cannot be in the past")),
  //     );
  //     return;
  //   }
  //
  //   // Schedule notification using the medicine name as the tag
  //   await NotificationService.scheduleBackgroundTask(
  //     medicineController.text, // Use the medicine name as the tag
  //     {
  //       'title': "Medicine Reminder",
  //       'body': "It's time to take your medicine: ${medicineController.text}",
  //     },
  //     scheduleDate,
  //   );
  //
  //   // Provide feedback
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Reminder saved successfully")),
  //   );
  //
  //   // Show instant notification if notifications are enabled
  //   if (isNotificationEnabled) {
  //     await NotificationService.showInstantNotification(
  //       "Notifications Enabled",
  //       "You will now receive reminders for ${medicineController.text}.",
  //     );
  //   }
  //
  //   Navigator.pop(context, true); // Return true to indicate success
  // }
  //
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
              Container(

                child:SwitchListTile(
                  title: Text("Notifications"),
                  value: isNotificationEnabled,
                  onChanged: (value) async {
                    setState(() {
                      isNotificationEnabled = value;
                    });

                    if (!isNotificationEnabled) {
                      // Cancel the notification using the medicine name as the tag
                      await NotificationService.cancelScheduledTask(medicineController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Notifications Disabled")),
                      );
                    }
                  },
                ),

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
              ListTile(
                title: Text("Reminder Time"),
                subtitle: Text(
                  reminderTime != null
                      ? reminderTime!.format(context)
                      : "Select Time",
                ),
                trailing: Icon(Icons.access_time),
                onTap: _pickReminderTime,
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

