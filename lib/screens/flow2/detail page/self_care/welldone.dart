import 'package:calender_app/screens/flow2/detail%20page/self_care/foot.dart';
import 'package:calender_app/screens/flow2/flow_2_screens_main/self_care.dart';
import 'package:calender_app/screens/flow2/home_flow2.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../../../globals.dart';

class Welldone extends StatelessWidget {
  const Welldone({super.key});

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
                        MaterialPageRoute(builder: (context) => SelfCare()));
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
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> foot()))
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
