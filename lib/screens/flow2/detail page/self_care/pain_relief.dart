import 'package:calender_app/screens/flow2/detail%20page/self_care/foot_excercise_1.dart';
import 'package:calender_app/screens/flow2/detail%20page/self_care/foot_excercise_2.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/background.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class painRelief extends StatelessWidget {
  const painRelief({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            CustomButton(text: "Start", onPressed: ()
            {

              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context)=> footExcercise(
                    title: 'Left Foot Massage',
                    time: '03:00',
                    imagePath: 'assets/self_care/left_foot.png',
                    goto: FootExcercise2(),
                  )
              )
              );

            }
            )

          ],
        ),
      ),
    );
  }
}
