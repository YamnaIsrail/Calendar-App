import 'package:calender_app/screens/flow2/home_flow2.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'cycle_phase_widgets/phase_header.dart';
import 'package:flutter/material.dart';
import 'fertile.dart';

class PeriodPhaseScreen extends StatelessWidget {
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
              phaseName: "Period Phase",
              rightPage: fertile(),
            ),
            SizedBox(height: 16),
            Text(
              "Menstruation is when your body sheds the lining "
              "of the uterus through the vagina if you aren’t pregnant."
              " It usually lasts about three to five days, "
              "but it can be as short as three days or as long as seven days,"
              " which is normal. ",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      colors: [Color(0xFFFFABCB), Color(0xFFC3D8FF)])),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Menstrual Cramps Relief",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, // Prevent text overflow
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Practice guided exercises at home to ease cramps and tension.",
                    //overflow: TextOverflow.ellipsis,  // Prevent text overflow
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                              Container(
                                width: 200,
                                height: 100,
                                child: Image.asset(
                                  fit: BoxFit.cover,

                                  'assets/self_care/massage.png',),
                              ),
                          Text("Foot Massage"),
                          Text("4 min"),
                        ],
                      )),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: Column(
                        children: [

                          Container(
                            width: 200,
                            height: 100,
                            child: Image.asset('assets/self_care/pain.PNG',  fit: BoxFit.cover,
                             ),
                          ),
                          Text("Period pain relief"),
                          Text("4 min"),
                        ],
                      ))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
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
                  Text("You may experience cramps, bloating, mood swings,"
                      " headaches, fatigue, breast tenderness, nausea, back pain,"
                      " digestive issues, and acne during your period."
                      "Don't worry , these symptoms tend to disappear after your period."),
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
                    "Low",
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
                  Text("An egg is not being released,"
                      " and the uterine lining is breaking down,"
                      " creating an environment that does not support the implantation of a fertilized egg."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
