
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/wheel.dart';
import 'package:flutter/material.dart';

class SetTimeAndDoseScreen extends StatefulWidget {
  @override
  _SetTimeAndDoseScreenState createState() => _SetTimeAndDoseScreenState();
}

class _SetTimeAndDoseScreenState extends State<SetTimeAndDoseScreen> {
  int selectedDose = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Time & Dose"),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Set Dose",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Wheel(
            items: List.generate(10, (index) => "${index + 1}"), // Doses 1-10
            selectedColor: Colors.pink,
            unselectedColor: Colors.grey,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedDose = index + 1;
              });
            },
          ),
          SizedBox(height: 20),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20.0),
           child: CustomButton(text: "Save",
               onPressed: (){
                 Navigator.pop(context);
               },
               backgroundColor: primaryColor),
         ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
