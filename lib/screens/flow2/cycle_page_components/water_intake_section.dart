// lib/widgets/water_intake_section.dart
import 'package:flutter/material.dart';

import '../detail page/settings.dart';

class WaterIntakeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Water Intake",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            IconButton(
              icon: Icon(Icons.settings),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()));
              },
            )
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(8, (index) {
              return IconButton(
                icon: Icon(
                  Icons.local_drink,
                  color: index < 4 ? Colors.blue : Colors.grey[300],
                ),
                onPressed: () {
                  // Update water intake state here if needed
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
