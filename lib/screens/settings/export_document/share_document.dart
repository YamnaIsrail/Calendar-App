import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/export_document/share_text.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dialog.dart';
import 'generate_pdf.dart';

class ExportCyclePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Export Data"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<CycleProvider>(
            builder: (context, cycleProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${cycleProvider.userName}"),
                  Text("Last Period Start: ${cycleProvider.lastPeriodStart}"),
                  Text("Cycle Length: ${cycleProvider.cycleLength} days"),
                  Text("Period Length: ${cycleProvider.periodLength} days"),
                  Text("Luteal Phase Length: ${cycleProvider.lutealPhaseLength} days"),
                  Text("Total Cycles Logged: ${cycleProvider.logCycle()}"),
                  Text("Days Until Next Period: ${cycleProvider.getDaysUntilNextPeriod()}"),
                  Text("Past Periods:"),
                  ...cycleProvider.pastPeriods.map((period) {
                    return Text("Start: ${period['startDate']}, End: ${period['endDate']}");
                  }).toList(),
                  Spacer(),
                  CustomButton(
                    onPressed: () {
                      _showShareOptions(context);
                    },
                    backgroundColor: primaryColor,
                    text: "Export to Doctor",
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
void _showShareOptions(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Share Data"),
        content: Text("Choose how you want to share the data:"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              // Call PDF generation and sharing
              final cycleProvider = Provider.of<CycleProvider>(context, listen: false);
              generateAndSharePdf("Cycle_Data_Report", cycleProvider);
            },
            child: Text("Share as PDF"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              // Call text sharing function
              final cycleProvider = Provider.of<CycleProvider>(context, listen: false);
              shareAsText(cycleProvider);
            },
            child: Text("Share as Text"),
          ),
        ],
      );
    },
  );
}

