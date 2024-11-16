import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../analysis/intercourse_analysis.dart';
import 'cycle_section_dialogs.dart';


class IntercourseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Intercourse', style: TextStyle(color: Colors.black)),
          leading: CircleAvatar(
            backgroundColor: Color(0xffFFC4E8),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.remove_red_eye, color: Colors.black),
              onPressed: () {
                IntercourseDialogs.showHideOptionDialog(
                  context,
                  true,  (bool value) {
                    print("Dialog toggle state: $value");
                  },
                  Color(0xFFEB1D98),       );
              },
            )
          ],
        ),


        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(30),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Condom Option', style: TextStyle(fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/intercourse/Condom.png', // Replace with your SVG asset path
                          height: 50, // Set desired height
                          width: 50, // Set desired width
                        ),
                        SizedBox(height: 8), // Spacing between SVG and text
                        Text(
                          "Protected",
                          style: TextStyle(fontSize: 16, color: Colors.pink),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(
                          'assets/intercourse/candom2.png', // Replace with your SVG asset path
                          height: 50, // Set desired height
                          width: 50, // Set desired width
                        ),
                        SizedBox(height: 8), // Spacing between SVG and text
                        Text(
                          "UnProtected",
                          style: TextStyle(fontSize: 16, color: Colors.pink),
                        ),
                      ],
                    ),

                  ],
                ),
                SizedBox(height: 20),
                Text('Female Orgasm', style: TextStyle(fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/intercourse/Orgasm.png', // Replace with your SVG asset path
                          height: 50, // Set desired height
                          width: 50, // Set desired width
                        ),
                        SizedBox(height: 8), // Spacing between SVG and text
                        Text(
                          "Protected",
                          style: TextStyle(fontSize: 16, color: Colors.pink),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset(
                          "assets/intercourse/Don't Have.png",
                          height: 50, // Set desired height
                          width: 50, // Set desired width
                        ),
                        SizedBox(height: 8), // Spacing between SVG and text
                        Text(
                          "UnProtected",
                          style: TextStyle(fontSize: 16, color: Colors.pink),
                        ),
                      ],
                    ),

                  ],
                ),
                SizedBox(height: 20),
                Text('Times', style: TextStyle(fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    IconButton(icon: Icon(Icons.remove), onPressed: () {}),
                    SizedBox(width: 50,),
                    Text('1', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 50,),

                    IconButton(icon: Icon(Icons.add), onPressed: () {}),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child:CustomButton(text: "Save",
                      onPressed: (){},
                      backgroundColor: primaryColor),
                ),
                SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child:CustomButton(text: "Analysis",
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> IntercourseAnalysis()));
                      },
                      textColor: Colors.black,
                      backgroundColor: secondaryColor),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
