import 'package:calender_app/hive/settingsPageNotifications.dart';
import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/medicine_reminder_form.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/water_reminders.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../flow2/detail page/cycle/medicine.dart';
import '../flow2/detail page/cycle/water.dart';
import 'reminder_times.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isPeriodReminderOn = true;
  bool isFertilityReminderOn = true;
  bool isLutealReminderOn = true;
  bool _waterReminderEnabled = false; // Water reminder toggle

  @override
  void initState() {
    super.initState();
    NotificationService.init();
    _requestPermission();

    _loadToggleStates(); // Load toggle states when the page is initialized
  }

  void _requestPermission() async {
    bool granted = await NotificationService.requestNotificationPermission();
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Notification permissions are required to schedule reminders.")),
      );
    }
  }
  // Load the toggle states from Hive
  void _loadToggleStates() async {
    final states = await ToggleStateService.loadToggleState();
    setState(() {
      isPeriodReminderOn = states['isPeriodReminderOn'] ?? true;
      isFertilityReminderOn = states['isFertilityReminderOn'] ?? true;
      isLutealReminderOn = states['isLutealReminderOn'] ?? true;
      _waterReminderEnabled = states['waterReminderEnabled'] ?? true; // Load water reminder state
    });
  }

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Reminder",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'Period & Ovulation'),

              CustomItem(
                title: "Next Period Reminder",
                onChanged: (bool value) async {
                  setState(() {
                    isPeriodReminderOn = value;
                  });

                  ToggleStateService.saveToggleState(
                    isPeriodReminderOn: isPeriodReminderOn,
                    isFertilityReminderOn: isFertilityReminderOn,
                    isLutealReminderOn: isLutealReminderOn,
                  );

                  if (value) {
                    // Show time picker when the user turns on the toggle
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 9, minute: 0), // Default time
                    );

                    // Use default time if the user doesn't select one
                    TimeOfDay reminderTime = selectedTime ?? TimeOfDay(hour: 9, minute: 0);

                    // Save the selected time
                    await NotificationTimeService.saveNotificationTime(
                      key: NotificationTimeService.periodTimeKey,
                      time: reminderTime,
                    );

                    // Reschedule notifications with the updated time
                    cycleProvider.rescheduleNotifications();
                  } else {
                    NotificationService.showInstantNotification(
                      "Reminder Canceled",
                      "Next period reminder has been canceled.",
                    );
                    cycleProvider.cancelNotification(7);
                    cycleProvider.cancelNotification(8);
                    cycleProvider.cancelNotification(9);
                    cycleProvider.cancelNotification(10);
                    cycleProvider.cancelNotification(11);
                    cycleProvider.cancelNotification(12);
                  }
                },
                isSwitched: isPeriodReminderOn,
              ),

              CustomItem(
                title: "Fertile Window Reminder",
                onChanged: (bool value) async {
                  setState(() {
                    isFertilityReminderOn = value;
                  });

                  ToggleStateService.saveToggleState(
                    isPeriodReminderOn: isPeriodReminderOn,
                    isFertilityReminderOn: isFertilityReminderOn,
                    isLutealReminderOn: isLutealReminderOn,
                  );

                  if (value) {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 8, minute: 0), // Default time
                    );

                    TimeOfDay reminderTime = selectedTime ?? TimeOfDay(hour: 8, minute: 0);

                    await NotificationTimeService.saveNotificationTime(
                      key: NotificationTimeService.fertilityTimeKey,
                      time: reminderTime,
                    );

                    cycleProvider.rescheduleNotifications();
                  } else {
                    NotificationService.showInstantNotification(
                      "Reminder Canceled",
                      "Fertile window reminder has been canceled.",
                    );
                    cycleProvider.cancelNotification(13);
                  }
                },
                isSwitched: isFertilityReminderOn,
              ),

              CustomItem(
                title: "Luteal Phase Reminder",
                onChanged: (bool value) async {
                  setState(() {
                    isLutealReminderOn = value;
                  });

                  ToggleStateService.saveToggleState(
                    isPeriodReminderOn: isPeriodReminderOn,
                    isFertilityReminderOn: isFertilityReminderOn,
                    isLutealReminderOn: isLutealReminderOn,
                  );

                  if (value) {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 10, minute: 0), // Default time
                    );

                    TimeOfDay reminderTime = selectedTime ?? TimeOfDay(hour: 10, minute: 0);

                    await NotificationTimeService.saveNotificationTime(
                      key: NotificationTimeService.lutealTimeKey,
                      time: reminderTime,
                    );

                    cycleProvider.rescheduleNotifications();
                  } else {
                    NotificationService.showInstantNotification(
                      "Reminder Canceled",
                      "Luteal phase reminder has been canceled.",
                    );
                    cycleProvider.cancelNotification(14);
                  }
                },
                isSwitched: isLutealReminderOn,
              ),


              const SectionHeader(title: 'Add Medicine'),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: Colors.white,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContraceptivePage(),
                      ),
                    ).then((result) {
                      if (result != null && result is bool && result) {
                        setState(() {
                          // Update the state if the user successfully added a medicine
                        });
                      }
                    });
                  },
                  title: Text("Medicine Reminders"),
                  trailing: IconButton(
                    icon: Icon(Icons.add, color: Colors.red,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContraceptivePage(),
                        ),
                      ).then((result) {
                        if (result != null && result is bool && result) {
                          setState(() {
                            // Update the state if the user successfully added a medicine
                          });
                        }
                      });
                    },
                  ),
                ),
              ),
              const SectionHeader(title: 'Life Style'),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: Colors.white,
                 child: ListTile(
                   onTap: () {
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (_) => WaterReminderScreen(),
                         )
                     );
                   },

                   title: Text("Drink Water"),
                  trailing:  Icon(Icons.local_drink_rounded, color: Colors.blueAccent,),

                 ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class CustomItem extends StatelessWidget {
  final String title;
  final bool isSwitched;
  final ValueChanged<bool> onChanged;

  const CustomItem({
    required this.title,
    required this.isSwitched,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: ListTile(
        title: Text(title),
        trailing: Switch(
          value: isSwitched,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? caption;

  const SectionHeader({required this.title, this.caption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (caption != null)
            Text(
              caption!,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1C1CAD)),
            ),
        ],
      ),
    );
  }
}