import 'package:calender_app/screens/flow2/detail%20page/self_care/exercise_model.dart';
import 'package:calender_app/screens/flow2/detail%20page/self_care/left_foot.dart';
import 'package:calender_app/screens/flow2/home_flow2.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../../flow_2_screens_main/self_care.dart';

class foot extends StatelessWidget {
  const foot({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Flow2Page()),
        );
        return false; // Block default back navigation and perform custom navigation
      },
      child: Scaffold(
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Custom back press logic
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Flow2Page()),
              );
            },
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
                                child: Image.asset("assets/self_care/left_foot.png", width: 170,),
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
                                child: Image.asset("assets/self_care/right_foot.png", width: 170,),
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
                    builder: (context)=> ExerciseModel(
                        title: 'Left Foot Massage',
                        time: '03:00',
                        imagePath: 'assets/self_care/left_foot.png',
                        goto: LeftFoot(),
                      onBackPress: foot(),
                    )
                )
                );

              }, backgroundColor: primaryColor,)

            ],
          )

        ),
      ),
    );
  }
}
