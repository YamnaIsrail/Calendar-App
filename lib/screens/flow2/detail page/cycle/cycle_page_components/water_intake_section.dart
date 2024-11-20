import 'package:flutter/material.dart';

import '../water.dart';


class WaterIntakeSection extends StatefulWidget {
  @override
  _WaterIntakeSectionState createState() => _WaterIntakeSectionState();
}

class _WaterIntakeSectionState extends State<WaterIntakeSection> {
  int selectedGlasses = 0; // Keeps track of the number of glasses selected
  int totalGlasses = 8;    // Total number of glasses available for selection

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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalGlasses, (index) {
              return IconButton(
                icon: Icon(
                  Icons.local_drink,
                  size: 50,
                  color: index < selectedGlasses ? Colors.blue : Colors.grey[300],
                ),
                onPressed: () {
                  setState(() {
                    selectedGlasses = index + 1;  // Update selected glasses based on the clicked glass
                  });
                },
              );
            }),
          ),
        ),
        SizedBox(height: 8),
        Text('Selected Glasses: $selectedGlasses', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
