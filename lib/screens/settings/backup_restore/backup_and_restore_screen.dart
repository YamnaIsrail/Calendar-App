// import 'package:calender_app/screens/settings/calendar_setting/calendar_setting_date.dart';
import 'package:calender_app/auth/auth_services.dart';
import 'package:calender_app/firebase/user_session.dart';
import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/settings/backup_restore/google_signin.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../firebase/analytics/analytics_service.dart';
import '../dialog.dart';

class BackupAndRestoreScreen extends StatefulWidget {
  const BackupAndRestoreScreen({Key? key}) : super(key: key);

  @override
  _BackupAndRestoreScreenState createState() => _BackupAndRestoreScreenState();
}

class _BackupAndRestoreScreenState extends State<BackupAndRestoreScreen> {
  bool isTrackingOthers = false; // State variable for tracking others' cycles
  bool isBackupReminderEnabled = false; // State variable for backup reminder
  DateTime? _startTime;

  String   selectedFrequency = "Daily";
  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now(); // Store the entry time
    _loadSettings(); // Load settings when the screen initializes
  }

  @override
  void dispose() {
    int duration = DateTime.now().difference(_startTime!).inSeconds; // Calculate time spent
    AnalyticsService.logScreenTime("BackupAndRestoreScreen", duration); // Pass both arguments
    super.dispose();
  }

  Future<void> _loadSettings() async {
    var box = await Hive.openBox('backupSettings');
    setState(() {
      isBackupReminderEnabled = box.get('backupReminderEnabled', defaultValue: false);
      selectedFrequency = box.get('backupFrequency', defaultValue: "Daily");
    });
  }
  Future<void> _saveSettings() async {
    var box = await Hive.openBox('backupSettings');
    await box.put('backupReminderEnabled', isBackupReminderEnabled);
    await box.put('backupFrequency', selectedFrequency);
  }

  @override
  Widget build(BuildContext context) {
    return bgContainer(

      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
          return false; // Prevent default back navigation
        },
        child: Scaffold(

          appBar: AppBar(
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(3),
                child: Icon(Icons.arrow_back),
              ),
              onPressed: () =>   Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              ),
            ),

          ),
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
                      AnalyticsService.logEvent("rename_option_selected", parameters: {
                        "action": "Opened rename dialog",
                      });
                      DialogHelper.showRenamePopup(context);
                    },
                  ),


        //backup reminder

                  SettingsOption(
                    icon: Icons.notifications,
                    title: "Backup reminder",
                    onTap: () {
                      AnalyticsService.logEvent("backup_reminder_option_selected", parameters: {
                        "action": "Opened backup reminder settings",
                      });
                    },
                    trailing: Switch(
                      value: isBackupReminderEnabled,
                      onChanged: (value) {
                        setState(() {
                          isBackupReminderEnabled = value;
                          _saveSettings(); // Save the state when changed


                          if (isBackupReminderEnabled) {

                            List<String> frequencyOptions = ["Daily", "Weekly", "Monthly"];

                                DialogHelper.showReminderFrequencyDialog(
                              context,
                              selectedFrequency,
                                  (newFrequencyIndex) {
                                setState(() {
                                  // Assign the string value from the frequencyOptions list
                                  selectedFrequency = frequencyOptions[newFrequencyIndex]; // This should be a String
                                  _saveSettings(); // Save the frequency when changed
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


                  SettingsOption(
                    icon: Icons.logout,
                    title: "Sign Out",
                    onTap: () {
                      AnalyticsService.logEvent("sign_out_option_selected", parameters: {
                        "action": "Opened sign out dialog",
                      });
                      DialogHelper.showSignOutPopup(context, () {
                         });
                    },
                  ),


                  // Delete Account
                  SettingsOption(
                    icon: Icons.delete_forever,
                    title: "Delete Account",
                    onTap: () {
                      AnalyticsService.logEvent("delete_account_option_selected", parameters: {
                        "action": "Opened delete account dialog",
                      });
                      DialogHelper.showDeleteAccountPopup(context, () {
                        // print("Account deleted");
                        // Perform account deletion here
                      });
                    },
                  ),

                  // Transfer data to new device
                  SettingsOption(
                    icon: Icons.sync,
                    title: "Transfer data to new device",
                    onTap: () {
                      AnalyticsService.logEvent("transfer_data_option_selected", parameters: {
                        "action": "Opened transfer data dialog",
                      });
                      DialogHelper.showTransferDataDialog(context);
                      // print("Transfer data to new device selected");
                      // Add transfer data functionality here
                    },
                  ),

                   // Data lost?
                  SettingsOption(
                    icon: Icons.warning,
                    title: "Data lost?",
                    onTap: () async {
                      AnalyticsService.logEvent("data_lost_option_selected", parameters: {
                        "action": "Handled data lost scenario",
                      });
                      // Directly call handleDataLost and let it manage the snack bar and data retrieval
                      await DataHandler.handleDataLost(context);
                    },
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class UserProfileSection extends StatefulWidget {
  @override
  _UserProfileSectionState createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends State<UserProfileSection> {
  bool? isSignedIn; // Nullable bool to handle loading state
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Fetch login status when widget is initialized
  }
  String? userImageUrl;
  String? userName;

  Future<void> _checkLoginStatus() async {
    final status = await SessionManager.checkUserLoginStatus();
    if (status) {
      userImageUrl = await SessionManager.getUserProfileImage();
      userName = await SessionManager.getUserName();
    }
    setState(() {
      isSignedIn = status; // Update state with login status
    });
    // print('Login status: $isSignedIn, Name: $userName, Image: $userImageUrl'); // Debugging check
  }


  @override
  Widget build(BuildContext context) {
    if (isSignedIn == null) {
      // Show loading indicator while fetching login status
      return Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: isSignedIn! && userImageUrl != null
                ? NetworkImage(userImageUrl!)
                : null,
            child: isSignedIn! && userImageUrl != null
                ? null
                : Icon(Icons.person, size: 35),
          ),
          if (isSignedIn! && userName != null)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                userName!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          SizedBox(height: 16),
          Text(
            isSignedIn!
                ? "Synchronize your data"
                : "Sign in and Synchronize your data",
            softWrap: true,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center, // Center the text
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
            child: TextButton(
              child: Text(
                isSignedIn! ? "Sync Data" : "Sign In",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                if (isSignedIn!) {
                  AnalyticsService.logEvent("sync_data_initiated", parameters: {
                    "action": "Syncing Data",
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Syncing Data..."),
                      backgroundColor: Colors.blue,
                    ),
                  );
                  Provider.of<CycleProvider>(context, listen: false)
                      .saveCycleDataToFirestore();
                } else {
                  AnalyticsService.logEvent("sign_in_initiated", parameters: {
                    "action": "User  initiated sign-in",
                  });
                  setState(() {
                    _isLoading = true; // Set loading to true during sign-in
                  });

                  await AuthService().signInWithGoogle(context, (bool isLoading) {
                    setState(() {
                      _isLoading = isLoading; // Update loading state
                    });
                  });

                  await _checkLoginStatus();
                }
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
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