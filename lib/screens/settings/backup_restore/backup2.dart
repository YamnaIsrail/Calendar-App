// import 'package:calender_app/screens/settings/calendar_setting/calendar_setting_date.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
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
                UserProfileSection(),
               SettingsOption(
                  icon: Icons.sync,
                  title: "Transfer data to new device",
                  onTap: () {
                    DialogHelper.showTransferDataDialog(context);
                  },
                ),

                // Select Reminder Frequency
                SettingsOption(
                  icon: Icons.notifications_active,
                  title: "Select reminder frequency",
                  onTap: () {
                    DialogHelper.showReminderFrequencyDialog(context);
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
