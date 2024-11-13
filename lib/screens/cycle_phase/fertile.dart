import 'package:calender_app/screens/cycle_phase/ovulation.dart';
import 'package:calender_app/screens/cycle_phase/period_phase.dart';

import '../globals.dart';
import 'cycle_phase_widgets/phase_header.dart';
import 'package:flutter/material.dart';

import 'cycle_phase_widgets/CervicalMucusSection.dart';
import 'cycle_phase_widgets/SymptomsSection.dart';
import 'cycle_phase_widgets/phase_info.dart';

class fertile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fertile Phase"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
         padding: EdgeInsets.all(8.0),
        children: [
          PhaseHeader(
              iconPath: 'assets/phases/periods_phase_icon.svg',
              phaseName: "Fertile Phase",
            leftPage: PeriodPhaseScreen(),
            rightPage: Ovulation(),
          ),
          SizedBox(height: 16),
          Text(
            "This phase starts on the first day of your period and"
            " ends when you ovulate. During this time, female "
            "hormones makes the uterus lining grow thicker, and"
            " FSH helps eggs in the ovaries grow. "
            "By days 10 to 14, one egg becomes fully mature. ",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0x91FFABCB),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cervical Mucus",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Prevent text overflow
                ),
                SizedBox(height: 4),
                Text(
                    "In this phase, cervical mucus may be creamy white and opaque."
                    "As ovulation gets closer, it turns more plentiful, clear,"
                    " and elastic, resembling egg whites."),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0x91FFABCB),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HIGH",
                  style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Prevent text overflow
                ),
                Text(
                  "Chance of Conception",
                  style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Prevent text overflow
                ),
                Image.asset("assets/graph.png"),
                SizedBox(height: 4),
                Text(
                    "Your LH levels, which trigger ovulation, are nearing their peak, indicating that ovulation is approaching."
                    "The chances of getting pregnant are high, as sperm can survive in the body for up to five days."),
              ],
            ),
          ),
          // CervicalMucusSection(
          //   mucusType: "Sticky",
          //   chanceOfConception: "LOW",
          //   chartData: [1, 2, 1.5, 2.5, 3],
          // ),
        ],
      ),
    );
  }
}
