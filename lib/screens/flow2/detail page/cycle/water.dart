import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/contain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'cycle_section_dialogs.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
              CardContain(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Notifications', style: TextStyle(fontSize: 20)),
                    Switch(value: true, onChanged: (bool value) {}),
                  ],
                ),
              ),
              CardContain(
                child: ListTile(
                  title: Text('Cup capacity unit', style: TextStyle(fontSize: 20)),
                  trailing: Text("ml", style: TextStyle(color: blueColor)),
                  onTap: () {
                      IntercourseDialogs.showCupCapacityDialog(context, primaryColor);
                  },
                ),
              ),
              CardContain(
                child: ListTile(
                  title: Text('Target', style: TextStyle(fontSize: 20)),
                  trailing: Text("3000 ml", style: TextStyle(color: blueColor)),
                  onTap: () {
                       IntercourseDialogs.showTargetDialog(context, primaryColor);
                  },
                ),
              ),
              CardContain(
                child: ListTile(
                  title: Text('Cup capacity', style: TextStyle(fontSize: 20)),
                  trailing: Text("450 ml", style: TextStyle(color: blueColor)),
                  onTap: () {
                    IntercourseDialogs.showCupCapacityDialog(context, primaryColor);
                  },
                ),
              ),


              SizedBox(height: 16),
              Text('Cup Size', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildCupOption(1, 'assets/drink/water_glass_add.svg'),
                  buildCupOption(2, 'assets/drink/water_glass_add.svg'),
                  buildCupOption(3, 'assets/drink/water_glass_add.svg'),
                ],
              ),
              Spacer(),
              CustomButton(
                onPressed: () {

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
        SvgPicture.asset(
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
