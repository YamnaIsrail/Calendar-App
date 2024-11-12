import 'package:calender_app/screens/flow2/detail%20page/self_care/pose_1.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:flutter/material.dart';

import 'foot_excercise_2.dart';

class footExcercise extends StatelessWidget {
  final String title;
  final Widget goto;
  final String time;
  final String imagePath;


  const footExcercise({required this.title,required this.goto, required this.imagePath, required this.time,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Exercise'),
        actions: [
          IconButton(
            icon: Icon(Icons.music_note, color: Colors.pink),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 250, width: 250, fit: BoxFit.contain
              ,),  // Replace Icon with Image.asset
            SizedBox(height: 20),
            Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(time, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: primaryColor, size: 40),
                  onPressed: () {},
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: ()  {

                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context)=> pose1()
                    )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), backgroundColor: primaryColor,
                    padding: EdgeInsets.all(20), // background color
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.white , size: 40),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: primaryColor, size: 40),
                  onPressed: ()  {

                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context)=> goto
                    )
                    );

                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
