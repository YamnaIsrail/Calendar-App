import 'dart:io';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> generateAndSharePdf(String fileName, CycleProvider cycleProvider) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Cycle Data Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text("Name: ${cycleProvider.userName}", style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text("Last Period Start: ${cycleProvider.lastPeriodStart}"),
            pw.Text("Cycle Length: ${cycleProvider.cycleLength} days"),
            pw.Text("Period Length: ${cycleProvider.periodLength} days"),
            pw.Text("Luteal Phase Length: ${cycleProvider.lutealPhaseLength} days"),
            pw.Text("Total Cycles Logged: ${cycleProvider.totalCyclesLogged}"),
            pw.Text("Days Until Next Period: ${cycleProvider.getDaysUntilNextPeriod()}"),
          ],
        );
      },
    ),
  );

  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/$fileName.pdf";
    final file = File(filePath);

    // Save the PDF
    await file.writeAsBytes(await pdf.save());

    // Share the PDF
    await Share.shareXFiles([XFile(filePath)], text: "Cycle Data Report");
  } catch (e) {
    // Handle errors if any
    print("Error generating or sharing PDF: $e");
  }
}
