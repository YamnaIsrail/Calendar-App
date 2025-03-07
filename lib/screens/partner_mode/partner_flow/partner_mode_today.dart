
import 'package:calender_app/admob/banner_ad.dart';
import 'dart:math';
import 'package:calender_app/widgets/cycle_info_card.dart';
import 'package:calender_app/screens/partner_mode/partner_flow/partner_mode_progress_arcs.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'partner_mode_setting.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:calender_app/provider/partner_provider.dart';
class PartnerStatusScreen extends StatelessWidget {

  String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final partnerProvider = Provider.of<PartnerProvider>(context);


    final currentCycleDay = partnerProvider.daysElapsed + 1;

    final isPregnancyMode = partnerProvider.pregnancyMode;

    // Extract data dynamically
    final lastMenstrualPeriod = partnerProvider.lastMenstrualPeriod;
    final cyclePhase = partnerProvider.currentPhase;
    final dueDate = partnerProvider.dueDate;
    final gestationStart = partnerProvider.gestationStart;
    final currentPregWeek = partnerProvider.gestationWeeks ?? 0; // Default to 0 if null
    final currentPregDay = partnerProvider.gestationDays ?? 0; // Default to 0 if null
    final daysUntilDueDate = isPregnancyMode ? partnerProvider.daysUntilDueDate : null;
    final daysUntilNextPeriod = partnerProvider.getDaysUntilNextPeriod() ?? 0; // Default to 0 if null
    final daysElapsed = partnerProvider.daysElapsed;
    final cycleLength = partnerProvider.cycleLength ?? 0;


    double pregProgress =  (currentPregWeek + (currentPregDay / 7)) / 40;
    double cycleProgress =  (daysElapsed /
        cycleLength)

        .clamp(0.0, 1.0);


    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Partner Mode"),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PartnerModeSetting()),
              );
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: partnerProvider.isPregnancyMode
              ? pregnancyUI(partnerProvider,
              dueDate, currentPregWeek, daysUntilDueDate!,currentPregDay,pregProgress, context)
              : cycleUI(partnerProvider, cycleProgress,context),
        ),
      ),
    );
  }

  /// UI for Pregnancy Information
  Widget pregnancyUI(
      PartnerProvider partnerProvider,
      DateTime? dueDate,
      int currentWeek,
      int daysUntilDueDate,
      int currentPregDay,
      double progress,

      BuildContext context
      ) {
    final screenSize = MediaQuery.of(context).size;
    final containerSize =
        screenSize.width * 0.5; // Adjust the multiplier as needed

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [


        Stack(
          children: [
            Container(
              height: containerSize,
              width: containerSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/cal.png"),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    dueDate != null ? "Expected due date\n ${formatDate(dueDate)}" : "Pregnancy Data Unavailable",
                    style: TextStyle(fontSize: 12, color: Colors.black, ),textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    dueDate != null
                        ? "Week $currentWeek Day $currentPregDay"
                        : "Due Date: Not Available",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: containerSize,
              width: containerSize,
              child: CustomPaint(
                painter: PregnancyProgress(partnerProvider: PartnerProvider()),
              ),
            ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Color(0xc24396ea), // End button color
                foregroundColor:
                Colors.white, // Text color
                padding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12), // Rounded corners
                ),
              ),

              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Syncing data...'),
                    backgroundColor: Colors.blue,
                  ),
                );

                bool isSuccess = await Provider.of<PartnerProvider>(context, listen: false).listenForCycleUpdates();

                if (isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Data synced successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sync failed. Check your internet or try again later.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

              },


              child: Text('Sync with Partner Data'),
            ),
          ),
        ),


        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CycleInfoCard(
                  title: 'Pregnancy Progress',
                  subtitle: daysUntilDueDate < 0
                      ? "You are overdue. Contact your doctor."
                      : "Your pregnancy is progressing normally.",
                  progressLabelStart: "Week 1",
                  progressLabelEnd: "Week 40",
                  progressValue: (progress ?? 0) * 100,  ),
                BannerAdWidget(),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),


      ],
    );
  }

  /// UI for Cycle/Period Information
  Widget cycleUI(PartnerProvider partnerProvider,cycleProgress ,BuildContext context) {
    final currentCycleDay = partnerProvider.daysElapsed + 1;
    int daysUntilNextPeriod = partnerProvider.getDaysUntilNextPeriod();
    String nextPeriodDate = formatDate(partnerProvider.getNextPeriodDate() ?? DateTime.now());
    String endDate = formatDate(partnerProvider.cycleEndDate ?? DateTime.now());
    final screenSize = MediaQuery.of(context).size;
    final containerSize =
        screenSize.width * 0.5;

    String subtitle;
    if (daysUntilNextPeriod < 0) {
      // If the period is late
      subtitle = "Next cycle was expected on $nextPeriodDate ";
    } else {
      // If the period is on time or upcoming
      subtitle = "Next cycle: $nextPeriodDate";
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [


        Stack(
          children: [
            //buttons for testing

            Container(
              height: containerSize,
              width: containerSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/cal.png"),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentCycleDay <= partnerProvider.periodLength! - 1) ...[
                    // Show current cycle details
                    Text(
                      "Periods",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 8, color: Colors.black),
                    ),
                    Text(
                      "Day ${currentCycleDay}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Period will end on \n ${endDate}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  ] else ...[
                    // Period is over, show future period details
                    Text(
                      daysUntilNextPeriod == 0
                          ? "Today"
                          : (daysUntilNextPeriod < 0
                          ? "${daysUntilNextPeriod.abs()} Day(s) Late"
                          : "${daysUntilNextPeriod} Day(s) Left"),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Text(
                      daysUntilNextPeriod == 0
                          ? "Period is expected to begin \n ${nextPeriodDate}"
                          : (daysUntilNextPeriod < 0
                          ? "Your partner's period was expected\non ${nextPeriodDate}."
                          : "Next period will start\non $nextPeriodDate"),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(
              height: containerSize,
              width: containerSize,
              child: CustomPaint(
                painter: PartnerProgressPainter(
                  partnerProvider: partnerProvider,
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Color(0xc24396ea), // End button color
                foregroundColor:
                Colors.white, // Text color
                padding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12), // Rounded corners
                ),
              ),

              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Syncing data...'),
                    backgroundColor: Colors.blue,
                  ),
                );

                bool isSuccess = await Provider.of<PartnerProvider>(context, listen: false).listenForCycleUpdates();

                if (isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Data synced successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sync failed. Check your internet or try again later.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

              },


              child: Text('Sync with Partner Data'),
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CycleInfoCard(
                  title: "Today Cycle Day ${currentCycleDay}",
                  subtitle:"$subtitle",
                  progressLabelStart: "Start",
                  progressLabelEnd: "Next Period",
                  progressValue:  (cycleProgress ?? 0) * 100,
                ),
              SizedBox(height: 10),

                BannerAdWidget(),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Shared card builder
  Widget CycleInfoCard({
   required String title,
    required String subtitle,
    required String progressLabelStart,
    required String progressLabelEnd,
    required double progressValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 16),
          CustomProgressBar(
            progress: progressValue,
          ),
          Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(progressLabelStart),

              Text(progressLabelEnd),
            ],
          ),
        ],
      ),
    );
  }
}

class PartnerProgressPainter extends CustomPainter {
  final PartnerProvider partnerProvider;

  PartnerProgressPainter({required this.partnerProvider});

  @override
  void paint(Canvas canvas, Size size) {
    final today = DateTime.now();
    final daysSinceLastPeriod = today.difference(partnerProvider.lastMenstrualPeriod!).inDays;
    final currentCycleDay = (daysSinceLastPeriod % partnerProvider.cycleLength!) + 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 10;

    // Background Paint
    final backgroundPaint = Paint()
      ..color = const Color(0xFFE0E0E0) // Light gray
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Check if the period is late
    final expectedPeriodStart = partnerProvider.lastMenstrualPeriod!.add(Duration(days: partnerProvider.cycleLength!));
    final isPeriodLate = today.isAfter(expectedPeriodStart) && daysSinceLastPeriod >= partnerProvider.cycleLength!;

    final anglePerDay = 2 * pi / partnerProvider.cycleLength!;

    // Check if the period is late
    if (isPeriodLate) {
      // Draw the entire circle in dark red (indicating period is late)
      final latePeriodPaint = Paint()
        ..color = const Color(0xFFD72626) // Dark Red for late periods
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15;

      canvas.drawCircle(center, radius, latePeriodPaint);
      return; // Exit the painting as the entire circle is dark red
    }

    // Draw progress for current cycle
    for (int day = 1; day <= partnerProvider.cycleLength!; day++) {
      // Get the color for each day
      final paint = Paint()
        ..color = getDayColor(day, currentCycleDay, today)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15;

      drawArcForDay(canvas, day, center, radius, paint, anglePerDay);

      if (day == currentCycleDay) break; // Stop drawing after the current day
    }
  }

  // Function to determine the color of each day
  Color getDayColor(int day, int currentCycleDay, DateTime today) {
    final periodStartDay = 1; // Assuming period starts on the first day of the cycle
    final periodEndDay = partnerProvider.periodLength; // Period end day


    // Return colors for different conditions
    if (day <= 3 && day <= periodEndDay!) {
      return const Color(0xFFFF4D4D); // Bright Red for the first 3 days of the period
    }

    // After the first 3 days but within the period, use Warm Pink
    if (day > 3 && day <= periodEndDay!) {
      return const Color(0xFFFF6F91); // Warm Pink for the rest of the period
    }

    final daysUntilNextPeriod = partnerProvider.cycleLength! - currentCycleDay;
    return (daysUntilNextPeriod < 3)
        ? const Color(0xFF90CAF9) // Light Blue if period is near
        : const Color(0xFFA7E5A5); // Pastel Green for normal days
  }

  // Function to draw arc for each day
  void drawArcForDay(Canvas canvas, int day, Offset center, double radius, Paint paint, double anglePerDay) {
    final startAngle = -pi / 2 + (day - 1) * anglePerDay;
    final sweepAngle = anglePerDay;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant PartnerProgressPainter oldDelegate) {
    return oldDelegate.partnerProvider.lastMenstrualPeriod != partnerProvider.lastMenstrualPeriod ||
        oldDelegate.partnerProvider.cycleLength != partnerProvider.cycleLength ||
        oldDelegate.partnerProvider.periodLength != partnerProvider.periodLength;
  }
}