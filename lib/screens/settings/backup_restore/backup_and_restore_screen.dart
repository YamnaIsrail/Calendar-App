// import 'package:calender_app/screens/settings/calendar_setting/calendar_setting_date.dart';
import 'package:calender_app/firebase/user_session.dart';
import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/settings/backup_restore/google_signin.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/screens/settings/track_cycle.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dialog.dart';

class BackupAndRestoreScreen extends StatefulWidget {
  const BackupAndRestoreScreen({Key? key}) : super(key: key);

  @override
  _BackupAndRestoreScreenState createState() => _BackupAndRestoreScreenState();
}

class _BackupAndRestoreScreenState extends State<BackupAndRestoreScreen> {
  bool isTrackingOthers = false; // State variable for tracking others' cycles
  bool isBackupReminderEnabled = false; // State variable for backup reminder

  String   selectedFrequency = "Daily";

  @override
  Widget build(BuildContext context) {
    return bgContainer(

      child: Scaffold(

        appBar: AppBar(),
        body: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(2.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserProfileSection(),

                // Rename
                SettingsOption(
                  icon: Icons.edit,
                  title: "Rename",
                  onTap: () {
                    DialogHelper.showRenamePopup(context);
                  },
                ),

                // Track others cycles
                SettingsOption(
                  icon: Icons.group,
                  title: "Track others cycles",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TrackCycleScreen()));
                  },
            ),

//backup reminder

                SettingsOption(
                  icon: Icons.notifications,
                  title: "Backup reminder",
                  onTap: () {},
                  trailing: Switch(
                    value: isBackupReminderEnabled,
                    onChanged: (value) {
                      setState(() {
                        isBackupReminderEnabled = value;

                        if (isBackupReminderEnabled) {

                          List<String> frequencyOptions = ["Daily", "Weekly", "Monthly"];

                              DialogHelper.showReminderFrequencyDialog(
                            context,
                            selectedFrequency,
                                (newFrequencyIndex) {
                              setState(() {
                                // Assign the string value from the frequencyOptions list
                                selectedFrequency = frequencyOptions[newFrequencyIndex]; // This should be a String
                              });

                              // Schedule the backup reminder notification based on the selected frequency
                              _scheduleBackupReminder(selectedFrequency); // Ensure this accepts a String
                            },
                          );
                        } else {
                          // Cancel the backup reminder notification when switch is turned off
                          NotificationService.cancelScheduledTask(2);
                        }
                      });
                    },
                  ),
                ),
                // Sign In
                SettingsOption(
                  icon: Icons.logout,
                  title: "Sign In",
                  onTap: () {
                    DialogHelper.showSignInStatus(context);
                  },
                ),

                // Sign Out

                SettingsOption(
                  icon: Icons.logout,
                  title: "Sign Out",
                  onTap: () {
                    DialogHelper.showSignOutPopup(context, () {
                      print("User signed out");
                      // Perform sign-out actions here
                    });
                  },
                ),


                // Delete Account
                SettingsOption(
                  icon: Icons.delete_forever,
                  title: "Delete Account",
                  onTap: () {
                    DialogHelper.showDeleteAccountPopup(context, () {
                      print("Account deleted");
                      // Perform account deletion here
                    });
                  },
                ),

                // Transfer data to new device
                SettingsOption(
                  icon: Icons.sync,
                  title: "Transfer data to new device",
                  onTap: () {
                    DialogHelper.showTransferDataDialog(context);
                    print("Transfer data to new device selected");
                    // Add transfer data functionality here
                  },
                ),

                 // Data lost?
                SettingsOption(
                  icon: Icons.warning,
                  title: "Data lost?",
                  onTap: () async {
                    // Directly call handleDataLost and let it manage the snack bar and data retrieval
                    await DataHandler.handleDataLost(context);
                  },
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        CircleAvatar(
          //backgroundImage: AssetImage('assets/profile.jpg'),
          child: Icon(
            Icons.person,
          ),
          radius: 35,
        ),
        SizedBox(width: 16),
        Text(
          "Sign in and Synchronize your data",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xff142d7f),
            borderRadius: BorderRadius.circular(16),
          ),
          child:TextButton(
            child: Text(
              "Sync Data",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              bool isLoggedIn = await SessionManager.checkUserLoginStatus(); // Check the user's logged-in status

              if (!isLoggedIn) {
                // If user isn't logged in, show a Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("You are not signed in. Please sign in to sync data."),
                    backgroundColor: Colors.blueGrey,
                  ),
                );
              } else {
                // If user is logged in, show syncing data Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Syncing Data..."),

                    backgroundColor: Colors.blue,
                  ),
                );

                // Call saveCycleDataToFirestore function
                Provider.of<CycleProvider>(context, listen: false).saveCycleDataToFirestore();
              }
            },
          ),

        ),
      ]),
    );
  }
}

void _scheduleBackupReminder(String frequency) {
  DateTime now = DateTime.now();
  DateTime scheduleDate;

  // Determine the schedule date based on the frequency
  if (frequency == "Daily") {
    scheduleDate = DateTime(now.year, now.month, now.day, 9, 0); // 9 AM daily
    // Reschedule for the next day
    NotificationService.scheduleNotification(
      2, // Unique ID
      "Backup Reminder",
      "It's time to back up your data.",
      scheduleDate,
    );
    // Reschedule for the next day
    NotificationService.scheduleNotification(
      2, // Unique ID
      "Backup Reminder",
      "It's time to back up your data.",
      scheduleDate.add(Duration(days: 1)),
    );
  } else if (frequency == "Weekly") {
    scheduleDate = DateTime(now.year, now.month, now.day + 7, 9, 0); // 9 AM next week
    NotificationService.scheduleNotification(
      2, // Unique ID
      "Backup Reminder",
      "It's time to back up your data.",
      scheduleDate,
    );
    // Reschedule for the next week
    NotificationService.scheduleNotification(
      2, // Unique ID
      "Backup Reminder",
      "It's time to back up your data.",
      scheduleDate.add(Duration(days: 7)),
    );
  } else if (frequency == "Monthly") {
    scheduleDate = DateTime(now.year, now.month + 1, now.day, 9, 0); // 9 AM next month
    NotificationService.scheduleNotification(
      2, // Unique ID
      "Backup Reminder",
      "It's time to back up your data.",
      scheduleDate,
    );
    // Reschedule for the next month
    NotificationService.scheduleNotification(
      2, // Unique ID
      "Backup Reminder",
      "It's time to back up your data.",
      scheduleDate.add(Duration(days: 30)), // Approximation for a month
    );
  } else {
    // Handle invalid frequency or default behavior
    return;
  }
}