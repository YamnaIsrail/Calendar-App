// lib/widgets/note_section.dart
import 'package:flutter/material.dart';

class NoteSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notes",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          //maxLines: 4,
          decoration: InputDecoration(
            hintText: "Add any notes or observations...",
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(12),
            // ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
