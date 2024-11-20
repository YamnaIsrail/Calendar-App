import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/contain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'cycle_section_dialogs.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true; // Default notification setting
  String _cupCapacityUnit = "ml"; // Default cup capacity unit
  int _cupCapacity = 450; // Default cup capacity
  int _targetWaterIntake = 3000; // Default target water intake
  int _selectedCupSize = 1; // Default selected cup size

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notifications Toggle
              CardContain(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Notifications', style: TextStyle(fontSize: 20)),
                    Switch(
                      value: _notificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
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

                      IntercourseDialogs.showCupCapacityDialog(context, primaryColor, (String value) {
                      setState(() {
                        _cupCapacityUnit = value;
                      });
                    }, _cupCapacityUnit);
                  },
                ),
              ),

              // Target Water Intake
              CardContain(
                child: ListTile(
                  title: Text('Target', style: TextStyle(fontSize: 20)),
                  trailing: Text("$_targetWaterIntake $_cupCapacityUnit", style: TextStyle(color: blueColor)),
                  onTap: () {
                    IntercourseDialogs.showTargetDialog(context, primaryColor, (int value) {
                      setState(() {
                        _targetWaterIntake = value;
                      });
                    }, _cupCapacityUnit, _targetWaterIntake);
                  },
                ),
              ),

              // Cup Capacity
              CardContain(
                child: ListTile(
                  title: Text('Cup capacity', style: TextStyle(fontSize: 20)),
                  trailing: Text("$_cupCapacity $_cupCapacityUnit", style: TextStyle(color: blueColor)),
                  onTap: () {
                    IntercourseDialogs.showCupCapacityDialog(context, primaryColor, (String value) {
                      setState(() {
                        _cupCapacity = int.parse(value);
                      });
                    }, _cupCapacityUnit);
                  },
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
                  // Save settings logic can be implemented here
                  print("Settings saved: Notifications: $_notificationsEnabled, "
                      "Cup Capacity: $_cupCapacity $_cupCapacityUnit, "
                      "Target Intake: $_targetWaterIntake $_cupCapacityUnit, "
                      "Selected Cup Size: $_selectedCupSize");
                },
                backgroundColor: primaryColor,
                text: 'Save',
              ),
            ],
          ),
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
            });
          },
          activeColor: Colors.purple,
        ),
      ],
    );
  }


}
