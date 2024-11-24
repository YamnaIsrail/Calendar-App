import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../globals.dart' as globals; // Import the globals file
import 'package:calender_app/screens/question/q2.dart';
import '../../widgets/background.dart';
import '../../widgets/question_appbar.dart';
import '../../widgets/wheel.dart';
import 'ques_screen.dart';

class QuestionScreen1 extends StatefulWidget {
  @override
  _QuestionScreen1State createState() => _QuestionScreen1State();
}

class _QuestionScreen1State extends State<QuestionScreen1> {
  @override
  Widget build(BuildContext context) {
    List<String> dates = List.generate(9, (index) => (index + 3).toString());

    return bgContainer(
      child: Scaffold(

        backgroundColor: Colors.transparent,
        appBar: QuestionAppBar(
          currentPage: 1,
          totalPages: 3,
          onBack: () {
            Navigator.pop(context);
          },
          onCancel: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          },
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: QuestionScreen(
              statement: "How many days does your period usually last?",
              caption: "Bleeding usually lasts between 4-7 days.",
              wheel: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Align(
                      alignment: Alignment(0, -0.5),
                      child: Container(
                        color: Color(0xFFAFD1F3).withOpacity(0.3),
                        height: 40,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wheel(
                        items: dates,
                        selectedColor: Colors.black,
                        unselectedColor: Colors.grey,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            globals.selectedDays = index + 3; // Use the global variable
                          });
                        },
                      ),
                      Text(
                        "Days",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),

              onNextPressed: () {
              // Save the period length and cycle days using globals
              Provider.of<CycleProvider>(context, listen: false).updatePeriodLength(globals.selectedDays);
              print("Selected Days: ${globals.selectedDays}");

              // Navigate to the next screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuestionScreen2(selectedDays: globals.selectedDays)),
              );
            },
                 ),
        ),
      ),
    );
  }
}
