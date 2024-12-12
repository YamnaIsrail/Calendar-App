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
import '../question/q1.dart';
import 'backup_restore/google_signin.dart';

class DialogHelper {

  // New Dialog: showRatingPopup
  static void showRatingPopup(
      BuildContext context,
      ValueChanged<int> onRatingSelected,
      ) {
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
                              (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _rating = index + 1;
                              });
                              onRatingSelected(_rating);
                            },
                            child: Icon(
                              _rating > index ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Current Rating: $_rating',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  // New Dialog: Delete account showConfirmPopup
  static void showConfirmPopup(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to reset the app and delete all data?'),
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
                      await deleteUserAccount();
                      onDelete();
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
                    text: 'Keep',textColor: Colors.black,
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
        final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

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

                      // Check if user is already signed in
                      if (FirebaseAuth.instance.currentUser != null) {
                        // User already signed in, proceed with data retrieval
                        await Provider.of<CycleProvider>(context, listen: false).retrieveCycleDataFromFirestore(context);
                      } else {
                        // User is not signed in, sign in through Google
                        bool success = await GoogleSignInService().signInWithGoogle();
                        if (success) {
                          await Provider.of<CycleProvider>(context, listen: false).retrieveCycleDataFromFirestore(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign-in failed. Please try again!')));
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


//   static void showDataLostPopup(BuildContext context, VoidCallback onRecover) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Data Lost?"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "We've upgraded our backup system to make it more secure and convenient."
//                 "\n If you find data lost, please log in to the previous backup account again, we will help to retrieve your data.",
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 10),
//               Column(
//                 children: [
//                   ListTile(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                       onRecover();
//                     },
//                     leading: Icon(Icons.g_mobiledata_outlined),
//                     title: Text('Google Account'),
//                     textColor: primaryColor,
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                       onRecover();
//                     },
//                     leading: Icon(Icons.mail),
//                     title: Text('Email Attachment'),
//                     textColor: primaryColor,
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                       onRecover();
//                     },
//                     leading: Icon(Icons.draw),
//                     title: Text("Dropbox"),
//                     textColor: primaryColor,
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                       onRecover();
//                     },
//                     leading: Icon(Icons.cloud_download),
//                     title: Text('Cloud Storage'),
//                     textColor: primaryColor,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

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
                SizedBox(height: 5,width: 5,),
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
  static void showFirstDayOfWeekDialog(
      BuildContext context, String selectedDay, Function(String) onSelected) {
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
  static void showReminderFrequencyDialog(BuildContext context, int currentFrequency, Function(int) onFrequencyChanged) {
    int selectedOption = currentFrequency; // Use the current frequency as the initial selection

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select reminder frequency"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Weekly Reminder Option
              RadioListTile<int>(
                title: Text("Weekly data backup reminder"),
                value: 1,
                groupValue: selectedOption,
                onChanged: (value) {
                  selectedOption = value!;
                },
              ),
              // Monthly Reminder Option
              RadioListTile<int>(
                title: Text("Monthly data backup reminder"),
                value: 2,
                groupValue: selectedOption,
                onChanged: (value) {
                  selectedOption = value!;
                },
              ),
            ],
          ),
          actions: [
            CustomButton(
              onPressed: () async {
                // Update the parent widget with the new frequency selection
                onFrequencyChanged(selectedOption); // Pass the selected option to the callback

                // Cancel any existing notifications for the current frequency
                NotificationService.cancelNotification(currentFrequency as String); // Cancel the existing notification

                final now = DateTime.now();
                DateTime nextNotificationTime = now;

                // Schedule the new notification based on the selected frequency
                if (selectedOption == 1) {
                  nextNotificationTime = now.add(Duration(days: 7)); // Weekly
                } else if (selectedOption == 2) {
                  nextNotificationTime = now.add(Duration(days: 30)); // Monthly
                }

                // Schedule the notification with the new frequency
                await NotificationService.showScheduleNotification(
                  title: "Backup Reminder",
                  body: "Time to back up your data.",
                  scheduleDate: nextNotificationTime,
                  id: selectedOption, // Use frequency as id
                );

                Navigator.of(context).pop(); // Close the dialog after scheduling
              },
              backgroundColor: primaryColor,
              text: 'Save',
            ),
          ],
        );
      },
    );
  }


   void showTransferDataDialog(BuildContext context) {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    bool _isLoading = false;

    Future<void> _handleGoogleSignIn() async {
      _isLoading = true;

      try {
        // Trigger the Google Sign-In flow
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

          // Store user session
          await SessionManager.storeUserSession(userCredential.user?.uid ?? '');

          // Call saveCycleDataToFirestore after successful sign-in
          await saveCycleDataToFirestore();
          Navigator.pop(context); // Close the dialog
        } else {
          // User canceled the sign-in process
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-in canceled by user')),
          );
        }
      } catch (error) {
        // Handle any errors
        print('Google Sign-In Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In failed. Please try again.')),
        );
      } finally {
        _isLoading = false;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Transfer data to new device"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else ...[
                ElevatedButton.icon(
                  onPressed: _handleGoogleSignIn,
                  icon: Icon(Icons.login),
                  label: Text("Sign in with Google"),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Transfer to Android"),
                          Icon(
                            Icons.android_rounded,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                          Icon(
                            Icons.apple,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text("Cloud storage"),
                  leading: Icon(
                    Icons.cloud,
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text("Email attachment"),
                  leading: Icon(
                    Icons.mail,
                    color: Colors.black,
                  ),
                ),
              ],
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

  Future<void> saveCycleDataToFirestore() async {
    if (await SessionManager.checkUserLoginStatus()) {
      try {
        String? userId = await SessionManager.getUserId();
        if (userId != null) {
          final cycles = FirebaseFirestore.instance.collection('cycles');

          Map<String, dynamic> cycleData = {
            // Populate your data here
          };

          await cycles.doc(userId).set(cycleData, SetOptions(merge: true));
          print("Cycle data saved successfully.");
        }
      } catch (e) {
        print("Error saving data: $e");
      }
    } else {
      print("User is not logged in.");
    }
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
