import 'cycle_phase_widgets/phase_header.dart';
import 'ovulation.dart';
import 'package:calender_app/screens/flow2/home_flow2.dart';

import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

import 'phase.dart';

class luteal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Flow2Page()),
                )),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          PhaseHeader(
            iconPath: 'assets/phases/periods_phase_icon.svg',
            phaseName: "Luteal Phase",
            leftPage: Ovulation(),
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
                Text("This phase lasts from day 15 to 28."
                    " The egg moves from the ovary to the uterus,"
                    " and progesterone levels rise to prepare the"
                    " uterus for pregnancy."
                    " If the egg is fertilized, you become pregnant."
                    " If not, hormone levels drop, and the uterus lining sheds during "
                    "your period."),
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
                    "Cervical mucus may become less,"
                        " milky white and cloudy again."
                       ),
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
                Text("You still have the opportunity to conceive during the luteal phase,"
                    " as the egg can remain viable for some time after its release."),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
