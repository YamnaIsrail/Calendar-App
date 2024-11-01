import 'package:calender_app/widgets/scrollable%20wheel.dart';
import 'package:flutter/material.dart';

class ques extends StatelessWidget {
  String Statement;
  String Caption;
   ques({required String this.Statement, required String this.Caption});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(Statement, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          Text(Caption),
          Container(
            height: 200,
              child: wheel()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEB1D98),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity,
                    50), // Expand to full width with a minimum height
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ques(
                        Statement: "How many days does your period usually last?",
                        Caption: "Bleeding usually lasts between 4-7 days"

                    )
                    )
                );
              },
              child: Text("Next", style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),),
            ),
          ),
          Text("I am not sure")
        ],
      ),
    );
  }
}
