import 'package:calender_app/screens/flow2/detail%20page/self_care/foot.dart';
import 'package:calender_app/screens/flow2/flow_2_screens_main/self_care.dart';
import 'package:calender_app/screens/flow2/home_flow2.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../../../globals.dart';
import 'pain_relief.dart';
import 'pose_1.dart';

class Welldone extends StatelessWidget {
  final String sourceScreen; // Add a parameter to identify the source screen

  const Welldone({super.key, required this.sourceScreen});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8EAF6),
              Color(0xFFF3E5F5)
            ], // Light gradient background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Flow2Page()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(20), // background color
                  ),
                  child: Icon(Icons.check, color: primaryColor, size: 100),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Well done!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  CustomButton(
                    backgroundColor: primaryColor,
                    text: "Done",
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Flow2Page()));
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    child: Text("Do it again"),
                    onPressed: () {
                      // Navigate based on the source screen
                      if (sourceScreen == 'pose3') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => painRelief()));
                      } else if (sourceScreen == 'footExercise2') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => foot()));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
