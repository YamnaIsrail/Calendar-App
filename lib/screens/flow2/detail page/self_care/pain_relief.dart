import 'package:calender_app/screens/flow2/detail%20page/self_care/exercise_model.dart';
import 'package:calender_app/screens/flow2/home_flow2.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/background.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'pose_2.dart';

class painRelief extends StatelessWidget {
  const painRelief({super.key});

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
        appBar: AppBar(
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
                      Text("Period pain relief",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Text("Here are some gentle, "
                          "easy-to-do poses to help relax your mind and soothe physical discomfort,"
                          " providing relief from pain and tension.",
                        style: TextStyle( fontSize: 16),
                      ),
                      Text("3 min, 2 Poses",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),

                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                color: secondaryColor,

                                child: Image.asset("assets/self_care/pose1.png",
                                  height: 100, width: 120,
                                ),
                              ),
                              SizedBox(width: 5,),

                              Text("Supported child’s pose",
                                style: TextStyle( fontSize: 16),

                              ),
                            ],
                          ),
                          SizedBox(height: 10,),

                          Row(
                            children: [
                              Container(
                                color: secondaryColor,

                                child: Image.asset("assets/self_care/pose2.png",
                                  height: 100, width: 120,

                                ),
                              ),
                              SizedBox(width: 5,),

                              Text("Supported pigeon pose",
                                style: TextStyle( fontSize: 16),

                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                color: secondaryColor,
                                child: Image.asset("assets/self_care/pose3.png",
                                  height: 100, width: 120,

                                ),
                              ),
                              SizedBox(width: 5,),

                              Text("Supported reclining \n bound angle pose",
                                style: TextStyle( fontSize: 16),

                              ),
                            ],
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),
              CustomButton(text: "Start",
              backgroundColor: primaryColor,
                  onPressed: ()
              {

                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context)=>ExerciseModel(
                      title: 'Supported pigeon pose',
                      time: '03:00',
                      imagePath: 'assets/self_care/pose2.png',
                      goto: pose2(),
                      onBackPress: painRelief(),

                    )
                )
                );

              }
              )

            ],
          ),
        ),
      ),
    );
  }
}
