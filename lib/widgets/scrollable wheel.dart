import 'package:calender_app/widgets/tile.dart';
import 'package:flutter/material.dart';

import 'cycle.dart';

class wheel extends StatefulWidget {
  const wheel({super.key});

  @override
  State<wheel> createState() => _wheelState();
}

class _wheelState extends State<wheel> {
  int cycle_value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              child: ListWheelScrollView.useDelegate(
                onSelectedItemChanged: (value){
                  setState(() {
                    cycle_value= value;
                  });
                },
                itemExtent: 50,//height of each tile
                perspective: 0.005,
                diameterRatio: 1.2,

                physics: FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(

                  childCount: 36,
                  builder: (context, index){
                    return Cycle(
                      cycle_days: index,
                    );
                  }
                ),
              ),
            ),
            SizedBox(width: 10,),

          Container(
            width: 100,
                child: Text("Days",    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),))
          ],
        ),
      ),
    );
  }
}
