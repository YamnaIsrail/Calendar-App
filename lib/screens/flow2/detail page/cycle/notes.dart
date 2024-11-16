import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../analysis/intercourse_analysis.dart';
import 'cycle_section_dialogs.dart';


class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Add Note', style: TextStyle(color: Colors.black)),
          leading: CircleAvatar(
            backgroundColor: Color(0xffFFC4E8),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),

        ),


        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // To push the button to the bottom
            children: [
              // TextField for note input
              Container(
                color: Colors.white,  // Background color for TextField
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your note here...',
                     border: InputBorder.none,
                  ),
                  maxLines: 8,  // Adjust height of the TextField
                ),
              ),

                Spacer(),

             CustomButton(text: "Save Note", onPressed: (){
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Note saved!')));

             }, backgroundColor: primaryColor)
            ],
          ),
        ),
      ),
    );
  }
}
