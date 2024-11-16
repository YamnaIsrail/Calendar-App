// lib/widgets/note_section.dart
import 'package:calender_app/screens/flow2/detail%20page/cycle/notes.dart';
import 'package:calender_app/widgets/contain.dart';
import 'package:flutter/material.dart';

class NoteSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardContain(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Notes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios_rounded),
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Notes()));

                },
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter your note here...',
              border: InputBorder.none
            ),
            maxLines: 1,  // Adjust height of the TextField
          )

        ],
      ),
    );
  }
}
