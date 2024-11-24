import 'package:calender_app/hive/cycle_model.dart';
import 'package:calender_app/screens/question/q1.dart';
import 'package:flutter/material.dart';
import '../widgets/background.dart';
import 'flow2/home_flow2.dart';
import 'partner_mode/partner_enter_code.dart';


import 'package:hive/hive.dart';

class HomeScreen extends StatelessWidget {
  // Check if the cycle data exists in Hive
  Future<bool> checkIfCycleDataExists() async {
    var box = await Hive.openBox<CycleData>('cycleData');
    CycleData? cycleData = box.get('cycle'); // Retrieve the cycle data
    return cycleData != null; // Return true if data exists, otherwise false
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/img.png"),
              height: 234,
              width: 345,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEB1D98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () async {
                  bool hasCycleData = await checkIfCycleDataExists();
                  if (hasCycleData) {
                    // If data exists, navigate to the main screen or the next page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Flow2Page()), // Replace with the screen you want
                    );
                  } else {
                    // If no data exists, navigate to the question screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuestionScreen1()),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Let's start\n",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "I am a new member",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC6E1FC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PartnerEnterCode()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Partner mode \n",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "I have an invitation code",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BackgroundWidget(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image(
//               image: AssetImage("assets/img.png"),
//               height: 234,
//               width: 345,
//             ),
//             SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.all(15),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFEB1D98),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   minimumSize: Size(double.infinity, 50),
//                 ),
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => QuestionScreen1()));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Text.rich(
//                     textAlign: TextAlign.center,
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: "Let's start\n",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextSpan(
//                           text: "I am a new member",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.all(15),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFC6E1FC),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   minimumSize: Size(double.infinity, 50),
//                 ),
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => PartnerEnterCode()));
//
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Text.rich(
//                     textAlign: TextAlign.center,
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: "Partner mode \n",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextSpan(
//                           text: "I have an invitation code",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
