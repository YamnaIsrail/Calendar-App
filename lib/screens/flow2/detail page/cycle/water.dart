import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/water_reminders.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/contain.dart';
import 'package:calender_app/screens/globals.dart';
import 'cycle_section_dialogs.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false; // Default notification setting
  String _cupCapacityUnit = "ml"; // Default cup capacity unit
  int _cupCapacity = 250; // Default cup capacity
  int _targetWaterIntake = 3000; // Default target water intake
  int _selectedCupSize = 1; // Default selected cup size

  final Map<int, int> _cupSizes = {
    1: 250, // Glass
    2: 450, // Cup
    3: 750, // Bottle
  };

  @override
  void initState() {
    super.initState();
    _loadNotificationState(); // Load the notification state
  }

  Future<void> _loadNotificationState() async {
    var box = Hive.box('settingsBox');
    setState(() {
      _notificationsEnabled = box.get('notificationsEnabled', defaultValue: false); // Load saved state
    });
  }

  Future<void> _saveNotificationState(bool value) async {
    var box = Hive.box('settingsBox');
    await box.put('notificationsEnabled', value); // Save the state
  }

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Settings', style: TextStyle(color: Colors.black)),
          leading: CircleAvatar(
            backgroundColor: Color(0xffFFC4E8),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(16.0),
          children: [
            CardContain(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifications', style: TextStyle(fontSize: 20)),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) async {
                      if (value) {
                        // Navigate to WaterReminderScreen to set up reminders
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WaterReminderScreen(
                              initialNotificationsEnabled: _notificationsEnabled,
                            ),
                          ),
                        );

                        // If the user sets up reminders, update the notification state
                        if (result != null) {
                          setState(() {
                            _notificationsEnabled = result; // Update state based on return value
                          });
                          await _saveNotificationState(result); // save the new state
                        }
                      } else {
                        setState(() {
                          _notificationsEnabled = false;
                        });
                        // Cancel the scheduled notification for water reminders
                        await NotificationService.cancelScheduledTask(1); // Use the same ID
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Notifications Disabled")),
                        );
                        await _saveNotificationState(false); // Save the new state
                      }
                    },
                  ),

                ],
              ),
            ),

            // Cup Capacity Unit
            CardContain(
              child: ListTile(
                title: Text('Cup capacity unit', style: TextStyle(fontSize: 20)),
                trailing: Text(_cupCapacityUnit, style: TextStyle(color: blueColor)),
                onTap: () {
                  IntercourseDialogs.showCupCapacityDialogUnit(
                    context,
                    primaryColor,
                        (String value) {
                      setState(() {
                        _cupCapacityUnit = value;
                      });
                    },
                    _cupCapacityUnit,
                  );
                },
              ),
            ),

            // Target Water Intake
            CardContain(
              child: ListTile(
                title: Text('Target', style: TextStyle(fontSize: 20)),
                trailing: Text("$_targetWaterIntake $_cupCapacityUnit", style: TextStyle(color: blueColor)),
                onTap: () {
                  IntercourseDialogs.showTargetDialog(
                    context,
                    primaryColor,
                        (int value) {
                      setState(() {
                        _targetWaterIntake = value;
                      });
                    },
                    _cupCapacityUnit,
                    _targetWaterIntake,
                  );
                },
              ),
            ),

            // Cup Capacity
            CardContain(
              child: ListTile(
                title: Text('Cup capacity', style: TextStyle(fontSize: 20)),
                trailing: Text("$_cupCapacity $_cupCapacityUnit", style: TextStyle(color: blueColor)),
                subtitle: Text('Select Cup Size', style: TextStyle(fontSize: 10)),
              ),
            ),

            // Cup Size Selection
            SizedBox(height: 16),
            Text('Cup Size', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCupOption(1, 'assets/drink/glass-of-water.png'),
                buildCupOption(2, 'assets/drink/plastic-cup.png'),
                buildCupOption(3, 'assets/drink/water-bottle1.png'),
              ],
            ),

            Spacer(),
            CustomButton(
              onPressed: () {
                final selectedSize = _cupSizes[_selectedCupSize] ?? _cupCapacity;
                debugPrint(
                    "Settings saved: Notifications: $_notificationsEnabled, "
                        "Cup Capacity: $_cupCapacity $_cupCapacityUnit, "
                        "Target Intake: $_targetWaterIntake $_cupCapacityUnit, "
                        "Selected Cup Size: $_selectedCupSize ($selectedSize $_cupCapacityUnit)"
                );
              },
              backgroundColor: primaryColor,
              text: 'Save',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCupOption(int value, String imagePath) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          height: 60,
          width: 60,
        ),
        Radio<int>(
          value: value,
          groupValue: _selectedCupSize,
          onChanged: (int? newValue) {
            setState(() {
              _selectedCupSize = newValue!;
              _cupCapacity = _cupSizes[newValue]!;
            });
          },
          activeColor: Colors.purple,
        ),
      ],
    );
  }
}