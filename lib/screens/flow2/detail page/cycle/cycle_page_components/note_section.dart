// lib/widgets/note_section.dart
import 'package:calender_app/screens/flow2/detail%20page/cycle/notes.dart';
import 'package:calender_app/widgets/contain.dart';
import 'package:flutter/material.dart';
class NoteSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Notes()));

      },
      child: CardContain(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: Colors.grey,) ,
                  SizedBox(width: 5,),
                  Text("Write Something here", style: TextStyle(color: Colors.grey),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
