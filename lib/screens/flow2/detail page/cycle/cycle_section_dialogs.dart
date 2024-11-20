import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntercourseDialogs {
  // Add primaryColor as a parameter to the static methods that require it
  static void showCustomDialog({
    required BuildContext context,
    required Widget dialogContent,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: dialogContent,
        );
      },
    );
  }


  static void showHideOptionDialog(
      BuildContext context, Color primaryColor) {
    final provider = Provider.of<IntercourseProvider>(context, listen: false);
    showCustomDialog(
      context: context,
      dialogContent: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Show/Hide Options",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Divider(),
              ...provider.sections.keys.map((section) {
                return SwitchListTile(
                  value: provider.isSectionVisible(section),
                  onChanged: (value) {
                    setState(() {
                      provider.toggleSection(section);
                    });
                  },
                  title: Text(section),
                );
              }).toList(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  onPressed: () => Navigator.pop(context),
                  text: "OK",
                  backgroundColor: primaryColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static  void showCupCapacityDialog(BuildContext context, Color primaryColor, Function(String) onValueSelected,_cupCapacityUnit ) {
    String selectedUnit = _cupCapacityUnit;

    showCustomDialog(
      context: context,
      dialogContent: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Cup Capacity Unit",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Divider(),
            RadioListTile(
              value: "ml",
              groupValue: selectedUnit,
              onChanged: (value) {
                setState(() {
                  selectedUnit = value.toString();
                });
              },
              title: Text("ml"),
            ),
            RadioListTile(
              value: "fl oz",
              groupValue: selectedUnit,
              onChanged: (value) {
                setState(() {
                  selectedUnit = value.toString();
                });
              },
              title: Text("fl oz"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                  onValueSelected(selectedUnit);
                },
                text: "OK",
                backgroundColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog for Target Water Intake
  static void showTargetDialog(BuildContext context, Color primaryColor, Function(int) onValueSelected, _cupCapacityUnit, _targetWaterIntake) {
    int targetValue = _targetWaterIntake;

    showCustomDialog(
      context: context,
      dialogContent: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Set Target Water Intake",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Divider(),
            Slider(
              value: targetValue.toDouble(),
              min: 1000,
              max: 5000,
              divisions: 40,
              label: "$targetValue $_cupCapacityUnit",
              onChanged: (double value) {
                setState(() {
                  targetValue = value.toInt();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                  onValueSelected(targetValue);
                },
                text: "OK",
                backgroundColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }



}
