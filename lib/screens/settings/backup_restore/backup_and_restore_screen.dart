// import 'package:calender_app/screens/settings/calendar_setting/calendar_setting_date.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

import '../dialog.dart';
import 'backup2.dart';

class BackupAndRestoreScreen extends StatefulWidget {
  const BackupAndRestoreScreen({Key? key}) : super(key: key);

  @override
  _BackupAndRestoreScreenState createState() => _BackupAndRestoreScreenState();
}

class _BackupAndRestoreScreenState extends State<BackupAndRestoreScreen> {
  bool isTrackingOthers = false; // State variable for tracking others' cycles
  bool isBackupReminderEnabled = false; // State variable for backup reminder

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
                    DialogHelper.showRenamePopup(context, (newName) {
                      print("New name: $newName");
                      // Update name logic here
                    });
                  },
                ),

                // Track others cycles
                SettingsOption(
                  icon: Icons.group,
                  title: "Track others cycles",
                  trailing: Switch(
                    value: isTrackingOthers,
                    onChanged: (value) {
                      setState(() {
                        isTrackingOthers = value;
                      });
                    },
                  ),
                ),

                // Backup reminder
                SettingsOption(
                  icon: Icons.notifications,
                  title: "Backup reminder",
                  trailing: Switch(
                    value: isBackupReminderEnabled,
                    onChanged: (value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> BackupAndRestoreScreen2()));
                      setState(() {
                        isBackupReminderEnabled = value;
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

                // Other backup methods
                SettingsOption(
                  icon: Icons.backup,
                  title: "Other backup methods",
                  trailing: Text("Email attachment, Cloud storage"),
                  onTap: () {
                    DialogHelper.showDataLostPopup(context, () {
                      print("Backup method selected");
                      // Handle other backup method logic
                    });
                  },
                ),

                // Data lost?
                SettingsOption(
                  icon: Icons.warning,
                  title: "Data lost?",
                  onTap: () {
                    DialogHelper.showDataLostPopup(context, () {
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
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: Color(0xff142d7f),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            "Sync Data",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}


