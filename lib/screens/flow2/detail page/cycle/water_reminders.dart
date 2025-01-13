import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/contain.dart';
import 'package:flutter/material.dart';
import 'package:calender_app/widgets/wheel.dart';

class WaterReminderScreen extends StatefulWidget {
  final bool initialNotificationsEnabled; // New parameter

  WaterReminderScreen({required this.initialNotificationsEnabled});

  @override
  _WaterReminderScreenState createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  double interval = 1.0; // Interval in hours
  String message = "It's time to drink water";
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = widget.initialNotificationsEnabled; // Set initial state
  }
  void _pickStartTime() async {
    _showTimePicker((selectedTime) {
      setState(() {
        startTime = selectedTime;
      });
    });
  }

  void _pickEndTime() async {
    _showTimePicker((selectedTime) {
      setState(() {
        endTime = selectedTime;
      });
    });
  }

  void _showTimePicker(ValueChanged<TimeOfDay> onSelected) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        int selectedHour = 1;
        bool isAm = true;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Pick Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wheel(
                  items: List.generate(12, (index) => (index + 1).toString()),
                  selectedColor: Colors.blue,
                  unselectedColor: Colors.grey,
                  onSelectedItemChanged: (index) {
                    selectedHour = index + 1;
                  },
                ),
                Wheel(
                  items: ["AM", "PM"],
                  selectedColor: Colors.blue,
                  unselectedColor: Colors.grey,
                  onSelectedItemChanged: (index) {
                    isAm = index == 0;
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                backgroundColor: primaryColor,
                onPressed: () {
                  final time = TimeOfDay(
                    hour: isAm ? selectedHour : (selectedHour % 12) + 12,
                    minute: 0,
                  );
                  Navigator.pop(context);
                  onSelected(time);
                },
                text: "Set Time",
              ),
            ),
          ],
        );
      },
    );
  }

  void _pickInterval() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select Interval",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Wheel(
              items: List.generate(
                  8, (index) => "${(index + 1) * 0.5} hr"),
              selectedColor: Colors.blue,
              unselectedColor: Colors.grey,
              onSelectedItemChanged: (index) {
                setState(() {
                  interval = 0.5 * (index + 1);
                });
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                backgroundColor: primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Set Interval",
              ),
            ),
          ],
        );
      },
    );
  }
  void _saveReminder() async {
    if (startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select start and end times")),
      );
      return;
    }

    final now = DateTime.now();
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime!.hour,
      startTime!.minute,
    );
    final endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      endTime!.hour,
      endTime!.minute,
    );

    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("End time cannot be before start time")),
      );
      return;
    }

    // Schedule notifications with unique IDs
    int notificationIdBase = 100; // Base ID for water reminders
    DateTime current = startDateTime;

    while (current.isBefore(endDateTime)) {
      if (current.isAfter(now)) {
        // Schedule the notification with a unique ID
        await NotificationService.scheduleNotification(
          notificationIdBase++, // Increment ID for each reminder
          "Water Reminder",
          "It's time to drink water.",
          current,
        );
      }
      current = current.add(Duration(minutes: (interval * 60).toInt()));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Water reminders saved successfully")),
    );
    if (_notificationsEnabled) {
      await NotificationService.showInstantNotification(
        "Notifications Enabled",
        "You will now receive reminders.",
      );
    }
    Navigator.pop(context, _notificationsEnabled); // Return the current state
  }

  void _editMessage() async {
    final newMessage = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: message);
        return AlertDialog(
          title: Text("Edit Message"),
          content: TextField(
            controller: controller,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: "Reminder Message",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text("Save"),
            ),
          ],
        );
      },
    );

    if (newMessage != null && newMessage.isNotEmpty) {
      setState(() {
        message = newMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Water Reminder"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              CardContain(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Notifications', style: TextStyle(fontSize: 20)),
                    Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) async {
                        setState(() {
                          _notificationsEnabled = value;
                        });

                        if (!_notificationsEnabled) {
                          for (int i = 1; i <= 10; i++) {
                            await NotificationService.cancelScheduledTask(100 + i); // Use the same base ID
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Notifications Disabled")),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              CardContain(
                child: ListTile(
                  title: Text("Start Time"),
                  subtitle: Text(
                    startTime != null
                        ? startTime!.format(context)
                        : "Select Start Time",
                  ),
                  trailing: Icon(Icons.access_time),
                  onTap: _pickStartTime,
                ),
              ),
              CardContain(
                child: ListTile(
                  title: Text("End Time"),
                  subtitle: Text(
                    endTime != null
                        ? endTime!.format(context)
                        : "Select End Time",
                  ),
                  trailing: Icon(Icons.access_time),
                  onTap: _pickEndTime,
                ),
              ),
              CardContain(
                child: ListTile(
                  title: Text("Interval"),
                  subtitle: Text("$interval hours"),
                  trailing: Icon(Icons.access_time),
                  onTap: _pickInterval,
                ),
              ),
              CardContain(
                child: ListTile(
                  title: Text("Message"),
                  subtitle: Text(message),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: _editMessage,
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomButton(
                backgroundColor: primaryColor,
                onPressed: _saveReminder,
                text: "Save Reminder",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
