import 'package:calender_app/screens/flow2/detail%20page/cycle/medicine_reminder/set_time_dose.dart';
import 'package:calender_app/screens/flow2/flow_2_screens_main/my_cycle_main.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class MedicineReminderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Reminder'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Medicine Name",
                border: OutlineInputBorder(),
              ),
            ),
            SwitchListTile(
              title: Text("Notifications"),
              value: true,
              onChanged: (value) {},
            ),
            SettingsOption(
              icon: Icons.calendar_today,
              title: "Start Date",
              trailing: Text("Oct 23, 2024"),
              onTap: () {
                // Show date picker logic
              },
            ),
            SettingsOption(
              icon: Icons.repeat,
              title: "Interval",
              trailing: Text("Every day"),
            ),
            SettingsOption(
              icon: Icons.timer,
              title: "Duration",
              trailing: Text("7 Days"),
            ),
            SettingsOption(
              icon: Icons.alarm,
              title: "Time & Dose",
              trailing: Text("09:00 AM | 1 Dose"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SetTimeAndDoseScreen()),
                );
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),
            SwitchListTile(
              title: Text("Snooze"),
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text("Vibrate"),
              value: true,
              onChanged: (value) {},
            ),
            SettingsOption(
              icon: Icons.music_note,
              title: "Ringtone",
              trailing: Text("Default"),
            ),
            SizedBox(height: 16),
            CustomButton(text: "Save",
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CycleTrackerScreen()),
                  );
                },
                backgroundColor: primaryColor),

          ],
        ),
      ),
    );
  }
}