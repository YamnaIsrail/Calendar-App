import '../globals.dart';
import 'cycle_phase_widgets/phase_header.dart';
import 'package:flutter/material.dart';

import 'cycle_phase_widgets/CervicalMucusSection.dart';
import 'cycle_phase_widgets/SymptomsSection.dart';
import 'cycle_phase_widgets/phase_info.dart';
import 'fertile.dart';

class Ovulation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ovulation Phase"),
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

              phaseName: "Ovulation Phase",
            leftPage: fertile(),

          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFFC3D8FF),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Possible Symptoms",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Prevent text overflow
                ),
                SizedBox(height: 4),
                Text(
                    "Due to the release of an egg , you may feel discomfort or "
                    "pain on one side of your lower abdomen, "
                    "occasionally accompanied by light spotting."
                    " This generally lasts for 1 to 2 days."),
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
                  "Cervical Mucus",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Prevent text overflow
                ),
                SizedBox(height: 4),
                Text(
                    "On the day of ovulation, you may observe that the cervical mucus becomes notably wet and viscous."),
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
                Text("This is the best day for Conception! "
                    "If you're trying to conceive, it's important to have intercourse as soon as you can, since an egg only survives for roughly 24 hours after ovulation."),
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
