
import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter/scheduler.dart';  // Add this import


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

class _MedicineReminderScreenState extends
State<MedicineReminderScreen> {
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a valid start date")),
      );
    }
  }

  void _pickReminderTime(int index) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: reminderTimes[index] ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      if (startDate == null) {
        if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select a start date first")),
        );
        return;
      }
      // Get the current time for comparison
      final pickedDateTime = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (pickedDateTime.isBefore(DateTime.now())) {
        if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select a future time or adjust the start date for the selected time.")),
        );
        return;
      }

      setState(() {
        reminderTimes[index] = pickedTime;
      });
    }
  }

  bool _isTimeInFuture(TimeOfDay time) {
    final reminderDateTime = DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      time.hour,
      time.minute,
    );
    return reminderDateTime.isAfter(DateTime.now());
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
    bool isPermissionGranted = await NotificationService.requestNotificationPermission();
    if (!isPermissionGranted) {
      if (mounted) {
        // Delay showing the alert dialog after the widget is still mounted
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Permission Required'),
                  content: Text('Notification permission is required to set reminders'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
      }
      return;
    }

    if (startDate == null) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Invalid Date'),
                  content: Text('Please select a valid start date'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
      }
      return;
    }
    if (!isNotificationEnabled) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Notification is disabled'),
                  content: Text('Please enable the notification'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
      }
      return;
    }

    if (reminderTimes.any((time) => time == null || !_isTimeInFuture(time!))) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Invalid Time'),
                  content: Text('Please select valid reminder times in the future or adjust the start date for the selected time.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
      }
      return;
    }

    if (medicineController.text.isEmpty) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Missing Medicine Name'),
                  content: Text('Please enter a medicine name'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
      }
      return;
    }

    if (isNotificationEnabled && (startDate == null || reminderTimes.any((time) => time == null))) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Invalid Data'),
                  content: Text('Please select a valid start date and all reminder times'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
      }
      return;
    }

    // Prepare the reminder data for the first day
    final reminderData = {
      'startDate': startDate!.toIso8601String(),
      'reminderTimes': reminderTimes.map((time) => "${time!.hour}:${time.minute}").toList(),
      'intakePerDay': intakePerDay,
      'interval': interval,  // "Everyday" or "Weekly"
      'duration': duration,  // "Forever", "1 Day", "7 Days", "1 Month"
      'isNotificationEnabled': isNotificationEnabled,
      'notificationIds': [], // No notification scheduled yet
    };

    final box = Hive.box<Map>('medicineReminders');

    // Save the reminder data
    await box.put(medicineController.text, reminderData);

    // Show confirmation dialog after saving, ensuring widget is mounted
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Reminder Saved'),
                content: Text('Reminder saved successfully'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      });
    }

    // Navigate back after saving
    Navigator.pop(context, true);

    // Schedule the reminders
    await _scheduleReminderForDay(reminderData);

    // After scheduling, reschedule for next days if necessary
    await _rescheduleReminderForNextDay(reminderData);
  }


  Future<void> _scheduleReminderForDay(Map reminderData) async {
    final notificationIds = [];
    DateTime currentDate = DateTime.parse(reminderData['startDate']);

    // Schedule reminders for the entire duration
    int remainingDays = _calculateRemainingDays(reminderData['duration']);

    for (int dayOffset = 0; dayOffset < remainingDays; dayOffset++) {
      DateTime scheduledDate = currentDate.add(Duration(days: dayOffset));

      for (var index = 0; index < reminderData['reminderTimes'].length; index++) {
        var time = reminderData['reminderTimes'][index];
        List<String> timeParts = time.split(":");
        DateTime notificationTime = DateTime(
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );

        if (notificationTime.isAfter(DateTime.now())) {
          // Generate a unique ID based on the current date and reminder index
          int notificationId = "${medicineController.text.hashCode}_$index".hashCode;
          await NotificationService.scheduleNotification(
            notificationId,
            "Medicine Reminder",
            "Time to take ${medicineController.text}",
            notificationTime,
          );
          notificationIds.add(notificationId);
        }
      }
    }

    // Store the notification IDs for the first day
    reminderData['notificationIds'] = notificationIds;
    final box = Hive.box<Map>('medicineReminders');
    box.put(medicineController.text, reminderData);
  }
  Future<void> _rescheduleReminderForNextDay(Map reminderData) async {
    DateTime currentDate = DateTime.parse(reminderData['startDate']);

    // Increment the current date based on the selected interval
    if (reminderData['interval'] == "Everyday") {
      currentDate = currentDate.add(Duration(days: 1)); // Move to next day
    } else if (reminderData['interval'] == "Weekly") {
      currentDate = currentDate.add(Duration(days: 7)); // Move to next week
    }

    // Handle the duration
    int remainingDays = _calculateRemainingDays(reminderData['duration']);

    // If there are still days left in the duration, reschedule for the next date
    if (remainingDays > 0) {
      reminderData['startDate'] = currentDate.toIso8601String();

      // Schedule reminder for the next day (or week)
      await _scheduleReminderForDay(reminderData);

      // Save the updated start date and reminder times in Hive
      final box = Hive.box<Map>('medicineReminders');
      box.put(medicineController.text, reminderData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reminder duration ended.")),
      );
    }
  }

  int _calculateRemainingDays(String duration) {
    switch (duration) {
      case "1 Day":
        return 1;
      case "7 Days":
        return 7;
      case "1 Month":
        return 30;
      case "Forever":
        return 365; // or some other large value, or keep it running indefinitely
      default:
        return 0;
    }
  }


  void fetchReminders() {
    final box = Hive.box<Map>('medicineReminders');
    final reminders = box.toMap();

    reminders.forEach((key, value) {
      // print("Medicine: $key, Details: $value");
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

                  final box = Hive.box<Map>('medicineReminders');
                  final reminder = box.get(medicineController.text);

                  if (reminder != null && reminder['notificationIds'] != null) {
                    final notificationIds = reminder['notificationIds'] as List;

                    // Cancel all notifications using the stored notification IDs
                    for (var notificationId in notificationIds) {
                      await NotificationService.cancelScheduledTask(notificationId);
                    }

                    // Clear the notificationIds list if notifications are disabled
                    reminder['notificationIds'] = [];
                    box.put(medicineController.text, reminder);  // Update the reminder data
                  }

                  if (!isNotificationEnabled) {
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

