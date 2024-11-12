import 'package:flutter/material.dart';

class PeriodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.play_arrow, color: Colors.pink),
          label: Text("Start", style: TextStyle(color: Colors.pink)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[100],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.stop, color: Colors.blue),
          label: Text("End", style: TextStyle(color: Colors.blueAccent)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFA2BAF6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }
}
