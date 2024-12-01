import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/settings/dialog.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Ovulation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Ovulation and Fertile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Color(0xFFFFC4E8),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.arrow_back),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.check_box, color: Color(0xFFEB1D98)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              color: Colors.white,
              child: ListTile(
                title: Text("Luteal phase Length"),
                trailing: Text("${cycleProvider.lutealPhaseLength} days"),
                onTap: () {
                  CalendarDialogHelper.showLutealLengthDialog(context, (newLength) {
                    cycleProvider.updateLutealPhaseLength(newLength);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "From the ovulation date to the start of the next period is usually "
                    "${cycleProvider.lutealPhaseLength} days.\n\n"
                    "We use this luteal phase length to predict your next ovulation.",
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              color: Colors.white,
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Use Average ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Use Last 3 months data"),
                  ],
                ),
                trailing: Switch(
                  value: false, // Update to reflect provider's state
                  onChanged: (bool newValue) {
                    CalendarDialogHelper.showLastMonthsDialog(context, (selection) {
                      print("Selected option: $selection");
                      // Update provider or handle the selection
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Turn on the option, use average value to predict your next ovulation.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
