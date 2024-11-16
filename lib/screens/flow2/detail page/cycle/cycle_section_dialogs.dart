import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

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

  static void showCupCapacityDialog(BuildContext context, Color primaryColor) {
    showCustomDialog(
      context: context,
      dialogContent: Column(
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
            groupValue: "unit",
            onChanged: (value) {},
            title: Text("ml"),
          ),
          RadioListTile(
            value: "fl oz",
            groupValue: "unit",
            onChanged: (value) {},
            title: Text("fl oz"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onPressed: () => Navigator.pop(context),
              text: "OK",
              backgroundColor: primaryColor,  // Pass primaryColor here
            ),
          ),
        ],
      ),
    );
  }

  static void showHideOptionDialog(BuildContext context, bool isFeatureVisible, ValueChanged<bool> onChanged, Color primaryColor) {
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
              SwitchListTile(
                value: isFeatureVisible,
                onChanged: (value) {
                  setState(() {
                    onChanged(value); // Call the parent callback
                  });
                },
                title: Text("Feature Visibility"),
              ),
              // List of options with switches
              _buildOptionSwitch("Condom Option", isFeatureVisible, setState, onChanged),
              _buildOptionSwitch("Female Orgasm", isFeatureVisible, setState, onChanged),
              _buildOptionSwitch("Times", isFeatureVisible, setState, onChanged),
              _buildOptionSwitch("Intercourse Chat", isFeatureVisible, setState, onChanged),
              _buildOptionSwitch("Intercourse Activity", isFeatureVisible, setState, onChanged),
              _buildOptionSwitch("Forum", isFeatureVisible, setState, onChanged),
              _buildOptionSwitch("Frequency Statistics", isFeatureVisible, setState, onChanged),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  onPressed: () => Navigator.pop(context),
                  text: "OK",
                  backgroundColor: primaryColor,  // Pass primaryColor here
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper function to build the SwitchListTile for each option
  static Widget _buildOptionSwitch(String title, bool isFeatureVisible, StateSetter setState, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: isFeatureVisible,
      onChanged: (value) {
        setState(() {
          onChanged(value);
        });
      },
      title: Text(title),
    );
  }

  static void showTargetDialog(BuildContext context, Color primaryColor) {
    showCustomDialog(
      context: context,
      dialogContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Target",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Divider(),
          ListTile(
            title: Text("2750 ml"),
            onTap: () {},
          ),
          ListTile(
            title: Text("3000 ml"),
            onTap: () {},
          ),
          ListTile(
            title: Text("3250 ml"),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onPressed: () => Navigator.pop(context),
              text: "OK",
              backgroundColor: primaryColor,  // Pass primaryColor here
            ),
          ),
        ],
      ),
    );
  }
}
