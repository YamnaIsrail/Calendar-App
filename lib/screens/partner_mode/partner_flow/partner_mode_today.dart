//be2e48
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/date_day_format.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'partner_mode_setting.dart';
import 'package:provider/provider.dart';


import 'package:intl/intl.dart';
class PregnancyStatusScreen extends StatelessWidget {

  String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date); // "Feb 12, 2024"
  }

  @override
  Widget build(BuildContext context) {
    final partnerProvider = Provider.of<PartnerProvider>(context);


    final currentCycleDay = partnerProvider.daysElapsed + 1;


    // Extract data dynamically
    final lastMenstrualPeriod = partnerProvider.lastMenstrualPeriod;
    final cyclePhase = partnerProvider.currentPhase;
    final dueDate = partnerProvider.dueDate;
    final currentWeek = partnerProvider.getCurrentWeek() ?? 0; // Default to 0 if null
    final daysUntilDueDate = partnerProvider.getDaysIntoPregnancy() ?? 0; // Default to 0 if null

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
              ? pregnancyUI(partnerProvider, dueDate, currentWeek, daysUntilDueDate)
              : cycleUI(partnerProvider),
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
      ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 280,
          width: 280,
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
                dueDate != null ? "Pregnancy\n Week $currentWeek" : "Pregnancy Data Unavailable",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                dueDate != null
                    ? "Day: $daysUntilDueDate"
                    : "Due Date: Not Available",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildCycleInfoCard(
                  icon: Icons.baby_changing_station,
                  title: 'Pregnancy Progress',
                  subtitle: daysUntilDueDate < 0
                      ? "You are overdue. Contact your doctor."
                      : "Your pregnancy is progressing normally.",
                  progressLabelStart: "Week 1",
                  progressLabelEnd: "Week 40",
                  progressValue: currentWeek / 40,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// UI for Cycle/Period Information
  Widget cycleUI(PartnerProvider partnerProvider) {
    // Assuming you have access to partnerProvider in your widget
    int daysUntilNextPeriod = partnerProvider.getDaysUntilNextPeriod();
    String nextPeriodDate = formatDate(partnerProvider.getNextPeriodDate());

// Construct the subtitle
    String subtitle;
    if (daysUntilNextPeriod < 0) {
      // If the period is late
      subtitle = "Next cycle was expected on $nextPeriodDate ";
    } else {
      // If the period is on time or upcoming
      subtitle = "Next cycle: $nextPeriodDate (In: $daysUntilNextPeriod days)";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Container(
          height: 280,
          width: 280,
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
              Text(
                daysUntilNextPeriod > 0
                    ? "Periods\n${daysUntilNextPeriod} days Left"
                    : "Periods\n${daysUntilNextPeriod.abs()} days Late",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              SizedBox(height: 8),

              Text(
                partnerProvider.currentPhase,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),

            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildCycleInfoCard(
                  icon: Icons.date_range,
                  title: "Today Cycle Day ${partnerProvider.daysElapsed}",
                  // subtitle:"Next cycle: ${formatDate(partnerProvider.getNextPeriodDate())}",
                  subtitle:"$subtitle",
                  progressLabelStart: "Start",
                  progressLabelEnd: "Next Period",
                  progressValue: partnerProvider.daysElapsed + 1 / partnerProvider.cycleLength!,

                ),
              ],
            ),
          ),
        ),


      ],
    );
  }

  /// Shared card builder
  Widget buildCycleInfoCard({
    required IconData icon,
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(progressLabelStart),
              Expanded(
                child: LinearProgressIndicator(
                  value: progressValue,
                  color: Colors.blue,
                  backgroundColor: Colors.grey[300],
                ),
              ),
              Text(progressLabelEnd),
            ],
          ),
        ],
      ),
    );
  }
}
