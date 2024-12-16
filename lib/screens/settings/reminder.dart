import 'package:calender_app/hive/settingsPageNotifications.dart';
import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/medicine_reminder/medicine_reminder_form.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/water.dart';
import 'package:calender_app/screens/settings/item.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isPeriodReminderOn = false;
  bool isFertilityReminderOn = false;
  bool isLutealReminderOn = false;

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
    });
  }
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    await NotificationService.showScheduleNotification(
      title: title,
      body: body,
      scheduleDate: dateTime, id: 2,
    );
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
                    scheduleNotification(
                      title: "Period Reminder",
                      body: "Your next period is expected soon!",
                      dateTime: cycleProvider.getNextPeriodDate(),
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
                    scheduleNotification(
                      title: "Fertile Window Reminder",
                      body: "Your fertile window starts today.",
                      dateTime: cycleProvider.fertileDaysRange.first,
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
                    scheduleNotification(
                      title: "Luteal Phase Reminder",
                      body: "Your luteal phase starts today.",
                      dateTime: cycleProvider.lutealPhaseDays.first,
                    );
                  }
                },
                isSwitched: isLutealReminderOn,
              ),

              const SectionHeader(title: 'Add Medicine'),
              CustomItem(
                title: "Add Medicine",
                onChanged: (bool value) {
                  if (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MedicineReminderScreen(selectedMedicines: [],)),
                    );
                  }
                },
                isSwitched: false, // You can add state here as needed
              ),

              const SectionHeader(title: 'Life Style'),


              CustomItem(
                title: "Drink Water",
                onChanged: (bool value) {
                  if (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SettingsScreen()),
                    );
                  }
                },
                isSwitched: false, // You can add state here as needed
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff1C1CAD)),
            ),
        ],
      ),
    );
  }
}
