import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/wheel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DialogHelper {
  // New Dialog: showRatingPopup
  static void showRatingPopup(
      BuildContext context, ValueChanged<int> onRatingSelected) {
    int _rating = 0; // Initial rating set to 0

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
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: primaryColor,
              text: 'Submit',
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
          content: const Text('Are you sure to reset app and delete all data?'),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
              backgroundColor: primaryColor,
              text: 'Delete',
            ),
            SizedBox(height: 5),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: secondaryColor,
              text: 'Cancel',
              textColor: Colors.black,
            ),
          ],
        );
      },
    );
  }

  // New Dialog: Sign Out Confirmation
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: blueColor,
                    text: 'Sign out',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: blueColor,
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

  // New Dialog: Delete Account
  static void showDeleteAccountPopup(
      BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account?"),
          content:
              Text("All your cloud and local data will be completely cleared."),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDelete();
                    },
                    backgroundColor: blueColor,
                    text: 'Delete',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: blueColor,
                    text: 'Keep',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // New Dialog: Data Lost
  static void showDataLostPopup(BuildContext context, VoidCallback onRecover) {
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
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      onRecover();
                    },
                    leading: Icon(Icons.g_mobiledata_outlined),
                    title: Text('Google Account'),
                    textColor: primaryColor,
                  ),
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

  // New Dialog: Rename
  static void showRenamePopup(
      BuildContext context, ValueChanged<String> onRename) {
    TextEditingController _nameController = TextEditingController();

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
                child: Text("M"),
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
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: secondaryColor,
              text: 'Cancel',
              textColor: Colors.black,
            ),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRename(_nameController.text);
              },
              backgroundColor: primaryColor,
              text: 'OK',
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

  //showtranferdata
  static void showTransferDataDialog(BuildContext context) {
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                        Text("Transfer to Ios"),
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

  // Select Reminder Frequency Dialog
  static void showReminderFrequencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select reminder frequency"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text("Weekly data backup reminder"),
                value: 1,
                groupValue: 1, // replace with actual state variable
                onChanged: (value) {
                  // setState or update logic here
                },
              ),
              RadioListTile(
                title: Text("Monthly data backup reminder"),
                value: 2,
                groupValue: 1, // replace with actual state variable
                onChanged: (value) {
                  // setState or update logic here
                },
              ),
            ],
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
