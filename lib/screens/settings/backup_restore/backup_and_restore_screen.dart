// import 'package:calender_app/screens/settings/calendar_setting/calendar_setting_date.dart';
import 'package:calender_app/firebase/user_session.dart';
import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/screens/settings/track_cycle.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
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

  int selectedFrequency = 1; // Default to weekly (1 fo

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
            ),

//backup reminder

                SettingsOption(
                  icon: Icons.notifications,
                  title: "Backup reminder",
                  onTap: () {

                    },
                  trailing: Switch(
                    value: isBackupReminderEnabled,
                    onChanged: (value) {
                      setState(() {
                        isBackupReminderEnabled = value;

                        if (isBackupReminderEnabled) {
                          // Show the frequency selection dialog
                          DialogHelper.showReminderFrequencyDialog(
                            context,
                            selectedFrequency,  // Pass the current frequency
                                (newFrequency) {
                              setState(() {
                                selectedFrequency = newFrequency; // Update selectedFrequency
                              });
                              },
                          );
                        } else {
                          // Cancel the backup reminder notification when switch is turned off
                          NotificationService.cancelNotification(selectedFrequency as String); // Use the selected frequency as the id
                        }
                      });
                    },
                  ),
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
                  onTap: () {
                    DialogHelper dialogHelper = DialogHelper();
                    dialogHelper.showDataLostPopup(context, () {
                      print("Data recovery initiated");
                      // Handle data recovery
                    });
                  },
                ),


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


