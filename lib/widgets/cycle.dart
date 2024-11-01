import 'package:flutter/material.dart';
class Cycle extends StatelessWidget {
  int cycle_days;

   Cycle({required  this.cycle_days});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(
        cycle_days.toString(),
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)),
    );
  }
}
