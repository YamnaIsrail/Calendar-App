import 'package:calender_app/firebase/user_session.dart';
import 'package:calender_app/hive/cycle_model.dart';
import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/wheel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../auth/auth_model.dart';
import '../../hive/notes_model.dart';
import '../../hive/timeline_entry.dart';
import '../question/q1.dart';
import 'backup_restore/google_signin.dart';
import 'backup_restore/transfer_data_page.dart';

class DialogHelper {

  // New Dialog: showRatingPopup
  static void showRatingPopup(BuildContext context,
      ValueChanged<int> onRatingSelected,) {
    int _rating = 0; // Default rating is 0

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "We are working hard for a better user experience. "
                    "We would greatly appreciate it if you can rate us.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Tap the star to rate it.".toUpperCase(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                              (index) =>
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rating = index + 1;
                                  });
                                  onRatingSelected(_rating);
                                },
                                child: Icon(
                                  _rating > index ? Icons.star : Icons
                                      .star_border,
                                  color: Colors.amber,
                                  size: 40,
                                ),
                              ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Current Rating: $_rating',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final googlePlayUri = Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.popularapp.periodcalendar&hl=en',
                );
                if (await canLaunchUrl(googlePlayUri)) {
                  await launchUrl(googlePlayUri);
                } else {
                  throw 'Could not launch $googlePlayUri';
                }

                Navigator.of(context).pop(); // Close the popup
              },
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showConfirmPopup(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
              'Are you sure you want to reset the app and delete all data?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close popup
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close popup
                onDelete(); // Call the delete logic
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuestionScreen1()),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  static void deleteAllHiveData() async {
    // Clear all Hive boxes
    var authBox = await Hive.openBox<AuthData>('authBox');
    var partnerCodesBox = await Hive.openBox('partner_codes');
    var notesBox = await Hive.openBox<Note>('notesBox');
    var notificationStorageBox = await Hive.openBox('myBox');
    var cycleDataBox = await Hive.openBox<CycleData>('cycleData');
    var timelineBox = await Hive.openBox<TimelineEntry>('timelineBox');

    await authBox.clear();  // Clear the authBox
    await partnerCodesBox.clear();  // Clear partner codes box
    await notesBox.clear();  // Clear notes box
    await notificationStorageBox.clear();  // Clear notification box
    await cycleDataBox.clear();  // Clear cycle data box
    await timelineBox.clear();  // Clear timeline box

    // Optionally, delete from disk if you want to remove all data permanently
    await Hive.deleteFromDisk();
  }


  static void showSignOutPopup(BuildContext context, VoidCallback onSignOut) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are You Sure You Want To Sign Out Of Your Account?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () async {
                      // Sign out logic
                      await SessionManager.logoutUser();
                      Navigator.of(context).pop();
                      onSignOut();

                      // Show Snackbar indicating successful sign-out
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Successfully signed out."),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    backgroundColor: primaryColor,
                    text: 'Sign Out',
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: secondaryColor,
                    textColor: Colors.black,
                    text: 'Cancel',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static void showDeleteAccountPopup(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account?"),
          content: Text(
            "All your cloud and local data will be completely cleared.",
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await deleteUserAccount(); // Perform account deletion
                      onDelete();

                      // Automatically sign out after account deletion
                      await SessionManager.logoutUser();

                      // Show Snackbar indicating successful account deletion
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Your account has been deleted and logged out."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    backgroundColor: primaryColor,
                    text: 'Delete',
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: secondaryColor,
                    text: 'Keep',
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Deletes user's account data from Firebase & Hive
  static Future<void> deleteUserAccount() async {
    try {
      String? userId = await SessionManager.getUserId();
      if (userId != null) {
        // Firestore logic: Delete user data from Firebase
        final userDocRef = FirebaseFirestore.instance.collection('users').doc(
            userId);

        await userDocRef.delete();
        print("User's Firestore account deleted.");

        // Also clear session and local Hive data
        await SessionManager.logoutUser();
        final box = await Hive.openBox('user_session');
        await box.clear();
        print("Local session cleared.");
      }
    } catch (e) {
      print("Error during account deletion: $e");
    }
  }

// New Dialog: Data Lost
  void showDataLostPopup(BuildContext context, VoidCallback onRecover) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Data Lost?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "We've upgraded our backup system to make it more secure and convenient."
                    "\n If you find data lost, please log in to the previous backup account again, we will help to retrieve your data.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  // Google Account Sign-In
                  ListTile(
                    onTap: () async {
                      Navigator.of(context).pop();
                      if (FirebaseAuth.instance.currentUser != null) {
                         await retrieveCycleDataFromFirestore(context);
                      } else {
                        // User is not signed in, sign in through Google
                        bool success = await GoogleSignInService()
                            .signInWithGoogle();
                        if (success) {
                          await retrieveCycleDataFromFirestore(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Sign-in failed. Please try again!')));
                        }
                      }
                    },
                    leading: Icon(Icons.g_mobiledata_outlined),
                    title: Text('Google Account'),
                    textColor: primaryColor,
                  ),
                  // Other recovery methods
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      onRecover();
                    },
                    leading: Icon(Icons.mail),
                    title: Text('Email Attachment'),
                    textColor: primaryColor,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      onRecover();
                    },
                    leading: Icon(Icons.draw),
                    title: Text("Dropbox"),
                    textColor: primaryColor,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      onRecover();
                    },
                    leading: Icon(Icons.cloud_download),
                    title: Text('Cloud Storage'),
                    textColor: primaryColor,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void showRenamePopup(BuildContext context) {
    TextEditingController _nameController = TextEditingController();

    // Use the provider from the context
    final provider = Provider.of<CycleProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Rename"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                child: Text(provider.userName[0]), // Show initial
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Name",
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: secondaryColor,
                    text: 'Cancel',
                    textColor: Colors.black,
                  ),
                ),
                SizedBox(height: 5, width: 5,),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty) {
                        provider.updateUserName(_nameController.text.trim());
                      }
                      Navigator.of(context).pop();
                    },
                    backgroundColor: primaryColor,
                    text: 'Save',
                    textColor: Colors.white,
                  ),
                ),

              ],
            ),
          ],
        );
      },
    );
  }


  //Calendar Setting Day
  static void showFirstDayOfWeekDialog(BuildContext context, String selectedDay,
      Function(String) onSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> daysOfWeek = [
          "Sunday",
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday"
        ];
        return AlertDialog(
          title: Text("Select first day of week"),
          content: Container(
            width:
            double.maxFinite, // Allow the container to take the max width
            child: ListView(
              shrinkWrap: true,
              children: daysOfWeek.map((day) {
                return RadioListTile<String>(
                  title: Text(day),
                  value: day,
                  groupValue: selectedDay,
                  onChanged: (value) {
                    onSelected(value!); // Notify the caller of the change
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: primaryColor,
              text: 'Save',
            ),
          ],
        );
      },
    );
  }

  //Calendar Setting Date
  static void showDateFormatDialog(BuildContext context, String selectedFormat,
      Function(String) onSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime currentDate = DateTime.now();
        List<String> dateFormats = [
          "System Default",
          DateFormat('dd/MM/yyyy').format(currentDate),
          DateFormat('MM/dd/yyyy').format(currentDate),
          DateFormat('yyyy MM dd').format(currentDate),
          DateFormat('yyyy-MM-dd').format(currentDate),
          DateFormat('MMM dd, yyyy').format(currentDate),
          DateFormat('dd MMM, yyyy').format(currentDate),
          DateFormat('yyyy MMM dd').format(currentDate),
          DateFormat('dd MM yyyy').format(currentDate),
        ];
        return AlertDialog(
          title: Text("Select Date Format"),
          content: Container(
            width:
            double.maxFinite, // Allow the container to take the max width
            child: ListView(
              shrinkWrap: true,
              children: dateFormats.map((format) {
                return RadioListTile<String>(
                  title: Text(format),
                  value: format,
                  groupValue: selectedFormat,
                  onChanged: (value) {
                    onSelected(value!); // Notify the caller of the change
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: primaryColor,
              text: 'Save',
            ),
          ],
        );
      },
    );
  }

//**************************
// Select Reminder Frequency Dialog
  static void showReminderFrequencyDialog(
      BuildContext context,
      String currentFrequency,
      Function(int) onFrequencyChanged,
      ) {
    int selectedOption = currentFrequency == "Daily" ? 0 : currentFrequency == "Weekly" ? 1 : 2;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Reminder Frequency"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<int>(
                    title: Text("Daily Data Backup Reminder"),
                    value: 0,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: Text("Weekly Data Backup Reminder"),
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: Text("Monthly Data Backup Reminder"),
                    value: 2,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                onFrequencyChanged(selectedOption);
                Navigator.of(context).pop(); // Close the dialog after selection
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }


  static void showTransferDataDialog(BuildContext context) async {
    // Initialize GoogleSignIn instance
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Transfer data to new device"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Android button
                  GestureDetector(
                    onTap: ()  {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransferDataPage(transferTo: "Android"),
                        ),
                      );
                      },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffE893FF),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Transfer to Android"),
                          Icon(Icons.android_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  // iOS button
                  GestureDetector(
                    onTap: ()  {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransferDataPage(transferTo: "Ios"),
                        ),
                      );
                    },

                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        color: Color(0xff939AFF),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Transfer to iOS"),
                          Icon(Icons.apple, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text("Cloud storage"),
                leading: Icon(Icons.cloud, color: Colors.blue),
                onTap: ()  {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransferDataPage(transferTo: "Cloud"),
                    ),
                  );
                },

              ),
              ListTile(
                title: Text("Email attachment"),
                leading: Icon(Icons.mail, color: Colors.black),
                onTap: ()  {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransferDataPage(transferTo: "Email"),
                    ),
                  );
                },

              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }







    //other backups
  static void showOtherBackupMethods(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Other Backup Methods"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Email Attachment"),
              Text("Cloud Storage"),
            ],
          ),
        );
      },
    );
  }
  // Import From Others Dialog
  static void showImportFromOthersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Import from others"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Email Attachment"),
              Text("Cloud Storage"),
              Text("Dropbox"),
              Text("Local Storage"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }


}

class CalendarDialogHelper {
  // 1. Pregnancy Date Picker Dialog
  static void showPregnancyDateDialog(
      BuildContext context, ValueChanged<DateTime> onDateSelected) {
    // Implementation remains the same as before
  }

  // 2. Period Length Dialog
  static void showPeriodLengthDialog(BuildContext context) {
    List<String> days = List.generate(31, (index) => (index + 1).toString());
    int selectedIndex = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Period Length",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wheel(
                    items: days,
                    selectedColor: Colors.black,
                    unselectedColor: Colors.grey,
                    onSelectedItemChanged: (index) {
                      selectedIndex = index;
                    },
                  ),
                  Text("Days", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 20),
              CustomButton(
                onPressed: () {
                  // Update Provider with the selected value
                  context
                      .read<CycleProvider>()
                      .updatePeriodLength(int.parse(days[selectedIndex]));
                  Navigator.of(context).pop();
                },
                backgroundColor: primaryColor,
                text: 'Save',
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. Last Months Dialog
  static void showLastMonthsDialog(
      BuildContext context, ValueChanged<String> onSelectionChanged) {
    List<String> options = [
      "Last 1 Month",
      "Last 3 Months",
      "Last 6 Months",
      "Smart Calculate"
    ];
    int selectedIndex = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Last Months",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(options.length, (index) {
              return ListTile(
                leading: Radio<int>(
                  value: index,
                  groupValue: selectedIndex,
                  onChanged: (value) {
                    selectedIndex = value!;
                    onSelectionChanged(options[selectedIndex]);
                    Navigator.pop(context); // Close after selection
                  },
                ),
                title: Text(options[index]),
              );
            }),
          ),
        );
      },
    );
  }

  // 4. Cycle Length Dialog
  static void showCycleLengthDialog(BuildContext context) {
    List<String> days = List.generate(50, (index) => (index + 15).toString());
    int selectedIndex = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cycle Length",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wheel(
                    items: days,
                    selectedColor: Colors.black,
                    unselectedColor: Colors.grey,
                    onSelectedItemChanged: (index) {
                      selectedIndex = index;
                    },
                  ),
                  Text("Days", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 20),
              CustomButton(
                onPressed: () {
                  // Update Provider with the selected value
                  context
                      .read<CycleProvider>()
                      .updateCycleLength(int.parse(days[selectedIndex]));
                  Navigator.of(context).pop();
                },
                backgroundColor: primaryColor,
                text: 'Save',
              ),
            ],
          ),
        );
      },
    );
  }

  // 5. LUTEAL Phase Length Dialog
  static void showLutealLengthDialog(
      BuildContext context, Function(int) onUpdate) {
    showDialog(
      context: context,
      builder: (context) {
        int selectedLength = 14; // Default value
        return AlertDialog(
          title: Text("Update Luteal Phase Length"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Enter luteal phase length"),
            onChanged: (value) => selectedLength = int.parse(value),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onUpdate(selectedLength); // Pass new length to update
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
}



class ShowTransferDialog {
  static void showTransferDataDialog(BuildContext context) async {
    // Check if the user is logged in through the session
    bool isLoggedIn = await SessionManager.checkUserLoginStatus();

    if (isLoggedIn) {
      // If the user is logged in, proceed directly to the data transfer logic
      // Call the method to save data or transfer data
      await _handleDataTransfer(context);
    } else {
      // If the user is not logged in, show the Google Sign-In option
      _showGoogleSignInDialog(context);
    }
  }

  // This method handles the data transfer process
  static Future<void> _handleDataTransfer(BuildContext context) async {
    bool _isLoading = false;

    // Start loading
    _isLoading = true;

    try {
      await Provider.of<CycleProvider>(context, listen: false).saveCycleDataToFirestore();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data transfer successful')));
      Navigator.pop(context);
    } catch (error) {
      print('Data Transfer Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data transfer failed. Please try again.')));
    } finally {
      _isLoading = false;
    }
  }

  // This method shows the Google Sign-In dialog
  static void _showGoogleSignInDialog(BuildContext context) {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    bool _isLoading = false;

    Future<void> _handleGoogleSignIn() async {
      _isLoading = true;

      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

          await SessionManager.storeUserSession(userCredential.user?.uid ?? '');

          // After successful Google Sign-In, proceed with data transfer
          await _handleDataTransfer(context);
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-in canceled by user')),
          );
        }
      } catch (error) {
        print('Google Sign-In Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In failed. Please try again.')),
        );
      } finally {
        _isLoading = false;
      }
    }

    // Show dialog for Google Sign-In if user is not logged in
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Transfer Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  onPressed: _handleGoogleSignIn,
                  icon: Icon(Icons.login),
                  label: Text("Sign in with Google"),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

  Future<void> retrieveCycleDataFromFirestore(BuildContext context) async {
    try {
      String? userId = await SessionManager.getUserId();

      // Check if user is logged in
      if (userId == null) {
        // Open login dialog instead of showing a snackbar
        showLoginDialog(context);
        return;
      }

      var data = await FirebaseFirestore.instance
          .collection('cycles')
          .doc(userId)
          .get();

      if (data.exists) {
        // Retrieve data from Firestore
        int? fetchedCycleLength = data['cycleLength'];
        int? fetchedPeriodLength = data['periodLength'];
        DateTime? fetchedLastPeriodStart =
        data['cycleStartDate'] != null ? DateTime.parse(data['cycleStartDate']) : null;

        List<String> restoredPastPeriods = [];
        if (data['pastPeriods'] != null) {
          List<String> pastPeriodsFromFirestore = List<String>.from(data['pastPeriods'] ?? []);
          restoredPastPeriods.addAll(pastPeriodsFromFirestore);
        }

        // Update the provider with the fetched periods
        final provider = Provider.of<CycleProvider>(context, listen: false);
        provider.addPastPeriodsFromFirestore(restoredPastPeriods.cast<Map<String, String>>());

        // Show popup to ask the user if they want to update the cycle details
        showCycleUpdateDialog(context, provider, fetchedCycleLength, fetchedPeriodLength, fetchedLastPeriodStart);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No cycle data found for your account.")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred while fetching data.")));
    }
  }

  void showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Required"),
          content: Text("Please log in to access your cycle data."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Redirect user to login screen or trigger login flow
              },
              child: Text("Log In"),
            ),
          ],
        );
      },
    );
  }

  void showCycleUpdateDialog(BuildContext context, CycleProvider provider, int? fetchedCycleLength, int? fetchedPeriodLength, DateTime? fetchedLastPeriodStart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool updateCycleLength = false;
        bool updatePeriodLength = false;
        bool updateLastPeriodStart = false;

        return AlertDialog(
          title: Text("Update Cycle Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (fetchedCycleLength != null)
                Row(
                  children: [
                    Expanded(child: Text("Update Cycle Length?")),
                    Switch(
                      value: updateCycleLength,
                      onChanged: (value) {
                        updateCycleLength = value;
                      },
                    ),
                  ],
                ),
              if (fetchedPeriodLength != null)
                Row(
                  children: [
                    Expanded(child: Text("Update Period Length?")),
                    Switch(
                      value: updatePeriodLength,
                      onChanged: (value) {
                        updatePeriodLength = value;
                      },
                    ),
                  ],
                ),
              if (fetchedLastPeriodStart != null)
                Row(
                  children: [
                    Expanded(child: Text("Update Last Period Start?")),
                    Switch(
                      value: updateLastPeriodStart,
                      onChanged: (value) {
                        updateLastPeriodStart = value;
                      },
                    ),
                  ],
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            CustomButton(
                backgroundColor: primaryColor,
                onPressed: () {
                  if (updateCycleLength && fetchedCycleLength != null) {
                    provider.updateCycleLength(fetchedCycleLength);
                  }
                  if (updatePeriodLength && fetchedPeriodLength != null) {
                    provider.updatePeriodLength(fetchedPeriodLength);
                  }
                  if (updateLastPeriodStart && fetchedLastPeriodStart != null) {
                    provider.updateLastPeriodStart(fetchedLastPeriodStart);
                  }

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Cycle data updated successfully!")),
                  );
                },
                text: "Submit"),
          ],
        );
      },
    );
  }

