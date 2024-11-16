// import 'package:calender_app/screens/settings/calendar_setting/calendar_setting_date.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../dialog.dart';
import 'backup_and_restore_screen.dart';

class BackupAndRestoreScreen2 extends StatefulWidget {
  const BackupAndRestoreScreen2({Key? key}) : super(key: key);

  @override
  _BackupAndRestoreScreen2State createState() => _BackupAndRestoreScreen2State();
}

class _BackupAndRestoreScreen2State extends State<BackupAndRestoreScreen2> {
  bool isTrackingOthers = false;
  bool isBackupReminderEnabled = false;

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.all(2.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SyncAccountSection(),


                SettingsOption(
                  icon: Icons.notifications,
                  title: "Backup reminder",
                  onTap: () {
      DialogHelper.showReminderFrequencyDialog(context);
      },
                  trailing: Switch(
                    value: isBackupReminderEnabled,
                    onChanged: (value) {
                      setState(() {
                        isBackupReminderEnabled = value;
                      });

                    },
                  ),
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
                // Import From Others
                SettingsOption(
                  icon: Icons.import_export,
                  title: "Import from others",
                  onTap: () {
                    DialogHelper.showImportFromOthersDialog(context);
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
                    DialogHelper.showOtherBackupMethods(context);

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

class SyncAccountSection extends StatelessWidget {
  const SyncAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal:40),
      child: Column(
        children: [
          Text("Sign in and Synchronize your data",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 19),),
          SizedBox(height: 20,),
          Text("So your data won’t be lost when your device changed",
            style: TextStyle(color: Colors.black, fontSize: 16),),

          SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(text: "Google Account", onPressed: (){},
                backgroundColor: blueColor),
          )
        ],
      ),
    );
  }
}


