import 'dart:async';

import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/contain.dart';
import 'package:flutter/material.dart';
import 'package:calender_app/widgets/wheel.dart';
import 'package:hive/hive.dart';

class WaterReminderScreen extends StatefulWidget {
  @override
  _WaterReminderScreenState createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  double interval = 0.5; // Interval in hours
  String message = "It's time to drink water";
  bool _notificationsEnabled = true;
  String durationSelection = "Forever"; // Default duration selection

  bool isLoading = false;
int nextdaystarttime= 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _requestNotificationPermissions();
  }

  void _loadSettings() async {
    var box = await Hive.openBox('settingsBox');
    setState(() {
      startTime = TimeOfDay.fromDateTime(DateTime.parse(
          box.get('startTime', defaultValue: DateTime.now().toString())));
      endTime = TimeOfDay.fromDateTime(DateTime.parse(
          box.get('endTime', defaultValue: DateTime.now().toString())));
      interval = box.get('interval', defaultValue: 0.5);
      message = box.get('message', defaultValue: message);
      durationSelection = box.get('duration', defaultValue: "Forever");
      _notificationsEnabled =
          box.get('notificationsEnabled', defaultValue: true);
    });
  }

  void _saveSettings() async {
    var box = await Hive.openBox('settingsBox');
    await box.put(
        'startTime', _convertTimeOfDayToDateTime(startTime!).toString());
    await box.put('endTime', _convertTimeOfDayToDateTime(endTime!).toString());
    await box.put('interval', interval);
    await box.put('message', message);
    await box.put('duration', durationSelection);
    await box.put('notificationsEnabled', _notificationsEnabled);
  }
  void _saveNotificationState() async {
    var box = await Hive.openBox('settingsBox');
    await box.put('notificationsEnabled', _notificationsEnabled);
  }
  void _requestNotificationPermissions() async {
    bool granted = await NotificationService.requestNotificationPermission();
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enable notifications in settings")),
      );
    }
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
              items: List.generate(8, (index) => "${(index + 1) * 0.5} hr"),
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

  void _pickDuration() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select Duration",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text("1 Day", textAlign: TextAlign.center,),
              onTap: () {
                setState(() {
                  durationSelection = "1 Day";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("1 Week", textAlign: TextAlign.center,),
              onTap: () {
                setState(() {
                  durationSelection = "1 Week";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("1 Month", textAlign: TextAlign.center,),
              onTap: () {
                setState(() {
                  durationSelection = "1 Month";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Forever", textAlign: TextAlign.center,),
              onTap: () {
                setState(() {
                  durationSelection = "Forever";
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _saveReminder() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    // print("nextdaystarttime $nextdaystarttime");
    _requestNotificationPermissions();

    if (startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select start and end times")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (interval <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a valid interval")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a reminder message")),
      );
      return;
    }

    DateTime startDateTime = _convertTimeOfDayToDateTime(startTime!);
    DateTime endDateTime = _convertTimeOfDayToDateTime(endTime!);

    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reminder end time should before the start time")),
      );
      return;
    }

    int repeatDays = _getRepeatDays(durationSelection);

    // Store remaining days in Hive
    var box = await Hive.openBox('reminderBox');
    box.put('remainingDays', repeatDays);


    // Schedule new reminders
    int notificationIdBase = 100;
    _scheduleDailyReminders(notificationIdBase, startDateTime, endDateTime);

    _saveSettings();

    if (_notificationsEnabled) {

      await NotificationService.showInstantNotification(
        "Notifications Enabled",
        "You will now receive reminders.",
      );
    }
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context, _notificationsEnabled);
  }

  void _scheduleDailyReminders(int notificationIdBase, DateTime startDateTime,
      DateTime endDateTime) async {
    DateTime now = DateTime.now();

    // Ensure scheduling starts from now if the start time has already passed
    // if (startDateTime.isBefore(now) && endDateTime.isAfter(now)) {
    //   startDateTime = now;
    // }
    DateTime lastNotificationTime = startDateTime;

      while (startDateTime.isBefore(now)) {
        startDateTime = startDateTime.add(Duration(minutes: 30)); // Move to the next interval
      }


    while (startDateTime.isBefore(endDateTime)) {
      await NotificationService.scheduleNotification(
        notificationIdBase++,
        "Water Reminder",
        message,
        startDateTime,
      );

      startDateTime =
          startDateTime.add(Duration(minutes: (interval * 60).toInt()));
    }
    // print("startDateTime for today $startDateTime and start time for tomorrow $lastNotificationTime");

    // Schedule the next day's reminders **after the last notification is received**
    _scheduleNextDayReminder(lastNotificationTime, endDateTime);
  }

  DateTime _convertTimeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  /// Schedule the next day's reminders if duration is not completed
  void _scheduleNextDayReminder(DateTime lastNotificationTime, DateTime endTime,) async {
    var box = await Hive.openBox('reminderBox');
    int remainingDays = box.get('remainingDays', defaultValue: 0);
    int nextdaystarttime= lastNotificationTime.hour;
// print("nextdaystarttime $nextdaystarttime");
    if (remainingDays <= 0) {
      return; // Stop rescheduling if duration is complete
    }

    // Schedule the next batch of reminders at the last notification time for the next day
    DateTime nextStartTime = lastNotificationTime.add(Duration(days: 1));
    DateTime nextEndTime = DateTime(
      nextStartTime.year,
      nextStartTime.month,
      nextStartTime.day,
      endTime.hour,
      endTime.minute,
    );


    Timer(
      Duration(milliseconds: nextStartTime.difference(DateTime.now()).inMilliseconds),
          () {
        int notificationIdBase = 100;

        _scheduleDailyReminders(notificationIdBase, nextStartTime, nextEndTime);
      },
    );

    // Reduce remaining days
    box.put('remainingDays', remainingDays - 1);
  }

  /// Helper function to determine repeat days
  int _getRepeatDays(String durationSelection) {
    switch (durationSelection) {
      case "1 Week":
        return 7;
      case "1 Month":
        return 30;
      case "Forever":
        return 365;
      default:
        return 1; // Default to 1 day
    }
  }

  void _disableNotifications() async {
    for (int i = 100; i < 200; i++) {
      // Ensure range covers scheduled notifications
      await NotificationService.cancelScheduledTask(i);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Notifications Disabled")),
    );
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
                           _saveNotificationState(); // Save state immediately when toggled off
                          _disableNotifications();
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
                  title: Text("Duration"),
                  subtitle: Text(durationSelection),
                  trailing: Icon(Icons.access_time),
                  onTap: _pickDuration,
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
              // CustomButton(
              //   backgroundColor: primaryColor,
              //   onPressed: _saveReminder,
              //   text: "Save Reminder",
              // ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size(
                      double.infinity, 50), // Full width with minimum height
                ),
                onPressed: isLoading ? null : _saveReminder,
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white, // Match button text color
                        ),
                      )
                    : Text(
                        "Save Reminder",
                        style: TextStyle(
                          color: Colors.white, // Use provided textColor or default to white
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
