import 'package:calender_app/screens/question/ques_screen.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/cycle_provider.dart';
import '../globals.dart' as globals; // Import the globals file
import 'package:calender_app/screens/question/q3.dart';
import '../../widgets/background.dart';
import '../../widgets/question_appbar.dart';
import '../../widgets/wheel.dart';

class QuestionScreen2 extends StatefulWidget {
  final int selectedDays;

  QuestionScreen2({required this.selectedDays});

  @override
  _QuestionScreen2State createState() => _QuestionScreen2State();
}

class _QuestionScreen2State extends State<QuestionScreen2> {
  @override
  Widget build(BuildContext context) {
    List<String> cycleDays = List.generate(33, (index) => (index + 15).toString());

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: QuestionAppBar(
          currentPage: 2,
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
            statement: "How often does your cycle occur?",
            caption: "Your cycle usually happens every 21-35 days.",
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
                      items: cycleDays,
                      selectedColor: Colors.black,
                      unselectedColor: Colors.grey,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          globals.selectedCycleDays = index + 15; // Use the global variable
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
              // Update the cycle length
              Provider.of<CycleProvider>(context, listen: false).updateCycleLength(globals.selectedCycleDays);
              print("Selected Cycle Days: ${globals.selectedCycleDays}");

              // Navigate to the next screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    QuestionScreen3(
                  selectedDays: widget.selectedDays,
                  selectedCycleDays: globals.selectedCycleDays,
                ),),
              );
            },
          ),
        ),
      ),
    );
  }
}
