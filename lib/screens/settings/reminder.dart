import 'package:calender_app/hive/settingsPageNotifications.dart';
import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/medicine_reminder_form.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../flow2/detail page/cycle/medicine.dart';
import '../flow2/detail page/cycle/water.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isPeriodReminderOn = false;
  bool isFertilityReminderOn = false;
  bool isLutealReminderOn = false;
  bool _waterReminderEnabled = false; // Water reminder toggle

  @override
  void initState() {
    super.initState();
    _loadToggleStates(); // Load toggle states when the page is initialized
  }

  // Load the toggle states from Hive
  void _loadToggleStates() async {
    final states = await ToggleStateService.loadToggleState();
    setState(() {
      isPeriodReminderOn = states['isPeriodReminderOn'] ?? false;
      isFertilityReminderOn = states['isFertilityReminderOn'] ?? false;
      isLutealReminderOn = states['isLutealReminderOn'] ?? false;
      _waterReminderEnabled = states['waterReminderEnabled'] ?? false; // Load water reminder state
    });
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    await NotificationService.scheduleNotification(
      id,
      title,
      body,
      dateTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await NotificationService.cancelScheduledTask(id);
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
                onChanged: (bool value) {
                  setState(() {
                    isPeriodReminderOn = value;
                  });
                  ToggleStateService.saveToggleState(
                    isPeriodReminderOn: isPeriodReminderOn,
                    isFertilityReminderOn: isFertilityReminderOn,
                    isLutealReminderOn: isLutealReminderOn,
                  );
                  if (value) {
                    DateTime nextPeriodDate = cycleProvider.getNextPeriodDate();
                    print("Scheduling next period reminder for: $nextPeriodDate");

                    scheduleNotification(
                      id: 3,
                      title: "Period Reminder",
                      body: "Your next period is expected soon!",
                      dateTime: nextPeriodDate,
                    );

                    NotificationService.showInstantNotification(
                      "Reminder Scheduled",
                      "Next period reminder scheduled for ${nextPeriodDate.toLocal()}",
                    );
                  } else {
                    cancelNotification(3);
                    NotificationService.showInstantNotification(
                      "Reminder Canceled",
                      "Next period reminder has been canceled.",
                    );
                  }
                },
                isSwitched: isPeriodReminderOn,
              ),
              CustomItem(
                title: "Fertile Window Reminder",
                onChanged: (bool value) {
                  setState(() {
                    isFertilityReminderOn = value;
                  });
                  ToggleStateService.saveToggleState(
                    isPeriodReminderOn: isPeriodReminderOn,
                    isFertilityReminderOn: isFertilityReminderOn,
                    isLutealReminderOn: isLutealReminderOn,
                  );
                  if (value && cycleProvider.fertileDaysRange.isNotEmpty) {
                    DateTime fertileStartDate = cycleProvider.fertileDaysRange.first;

                    scheduleNotification(
                      id: 4,
                      title: "Fertile Window Reminder",
                      body: "Your fertile window starts today.",
                      dateTime: fertileStartDate,
                    );

                    NotificationService.showInstantNotification(
                      "Reminder Scheduled",
                      "Fertile window reminder scheduled for ${fertileStartDate.toLocal()}",
                    );
                  } else {
                    cancelNotification(4);
                    NotificationService.showInstantNotification(
                      "Reminder Canceled",
                      "Fertile window reminder has been canceled.",
                    );
                  }
                },
                isSwitched: isFertilityReminderOn,
              ),
              CustomItem(
                title: "Luteal Phase Reminder",
                onChanged: (bool value) {
                  setState(() {
                    isLutealReminderOn = value;
                  });
                  ToggleStateService.saveToggleState(
                    isPeriodReminderOn: isPeriodReminderOn,
                    isFertilityReminderOn: isFertilityReminderOn,
                    isLutealReminderOn: isLutealReminderOn,
                  );
                  if (value && cycleProvider.lutealPhaseDays.isNotEmpty) {
                    DateTime lutealStartDate = cycleProvider.lutealPhaseDays.first;

                    scheduleNotification(
                      id: 5,
                      title: "Luteal Phase Reminder",
                      body: "Your luteal phase starts today.",
                      dateTime: lutealStartDate,
                    );

                    NotificationService.showInstantNotification(
                      "Reminder Scheduled",
                      "Luteal phase reminder scheduled for ${lutealStartDate.toLocal()}",
                    );
                  } else {
                    cancelNotification(5);
                    NotificationService.showInstantNotification(
                      "Reminder Canceled",
                      "Luteal phase reminder has been canceled.",
                    );
                  }
                },
                isSwitched: isLutealReminderOn,
              ),

              const SectionHeader(title: 'Add Medicine'),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: Colors.white,
                child: ListTile(
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
                  title: Text("Drink Water"),
                  trailing: IconButton(
                    icon: Icon(Icons.local_drink_rounded, color: Colors.blueAccent,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(),
                        )
                      );
                    },
                  ),
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