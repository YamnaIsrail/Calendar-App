import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/settings/dialog.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CycleLength extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Cycle",
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
              color: Colors.white,
              child: ListTile(
                title: Text("Cycle Length"),
                trailing: Text("${cycleProvider.cycleLength} days"),
                onTap: () {
                  CalendarDialogHelper.showCycleLengthDialog(
                    context
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("We use this cycle length to predict your next period start date."),
            ),
          ],
        ),
      ),
    );
  }
}
