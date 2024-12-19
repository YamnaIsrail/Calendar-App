import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../water.dart';


class WaterIntakeSection extends StatefulWidget {
  @override
  _WaterIntakeSectionState createState() => _WaterIntakeSectionState();
}

class _WaterIntakeSectionState extends State<WaterIntakeSection> {
  int selectedGlasses = 0; // Keeps track of the number of glasses selected
  int totalGlasses = 8;    // Total number of glasses available for selection

  @override
  void initState() {
    super.initState();
    _loadSelectedGlasses();  // Load the saved selected glasses
  }

  // Load the selected glasses from Hive
  Future<void> _loadSelectedGlasses() async {
    var box = await Hive.openBox('waterIntakeBox');
    setState(() {
      selectedGlasses = box.get('selectedGlasses', defaultValue: 0);
    });
  }

  // Save the selected glasses to Hive
  Future<void> _saveSelectedGlasses() async {
    var box = await Hive.openBox('waterIntakeBox');
    await box.put('selectedGlasses', selectedGlasses);
  }

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
                  _saveSelectedGlasses();  // Save the updated number of selected glasses
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
