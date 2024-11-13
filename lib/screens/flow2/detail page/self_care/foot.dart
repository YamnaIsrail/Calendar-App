import 'package:calender_app/screens/flow2/detail%20page/self_care/pain_relief.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/background.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class foot extends StatelessWidget {
  const foot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:  Color(0x86F5D2F3),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE8EAF6),

                Color(0xFFF3E5F5)
              ], // Light gradient background
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Foot massage to relieve cramps",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "It provides a cost-effective, easier, and non-invasive solution to manage menstrual discomfort instead of medication.",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10,),

                    Text(
                      "3 min, 2 Poses",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Image.asset("assets/self_care/left_foot.png"),
                            ),
                            Text(
                              "Left foot massage",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              child: Image.asset("assets/self_care/right_foot.png"),
                            ),
                            Text(
                              "Right foot massage",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(text: "Start", onPressed: (){

              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context)=> painRelief()
              )
              );

            }, backgroundColor: primaryColor,)

          ],
        )

      ),
    );
  }
}
