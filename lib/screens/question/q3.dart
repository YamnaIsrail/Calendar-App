import 'package:calender_app/hive/cycle_model.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/question/ques_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../widgets/backgroundcontainer.dart';
import '../globals.dart' as globals;
import '../../widgets/question_appbar.dart';
import '../../widgets/wheel.dart';
import '../flow2/home_flow2.dart';

class QuestionScreen3 extends StatefulWidget {
  final int selectedDays;
  final int selectedCycleDays;

  QuestionScreen3({required this.selectedDays, required this.selectedCycleDays});

  @override
  _QuestionScreen3State createState() => _QuestionScreen3State();
}

class _QuestionScreen3State extends State<QuestionScreen3> {
  int selectedYear = 2020;
  int selectedMonthIndex = 0;
  int selectedDate = 1;

  @override
  Widget build(BuildContext context) {
    List<String> years = List.generate(6, (index) => (2020 + index).toString());
    List<String> dates = List.generate(31, (index) => (index + 1).toString());
    List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent, // Set transparent to show the gradient
        appBar: QuestionAppBar(
          currentPage: 3,
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
            statement: "What’s the start date of your last period?",
            caption: "",
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
                  children: [
                    Wheel(
                      items: years,
                      selectedColor: Colors.black,
                      unselectedColor: Colors.grey,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedYear = 2020 + index;
                        });
                      },
                    ),
                    Wheel(
                      items: months,
                      selectedColor: Colors.black,
                      unselectedColor: Colors.grey,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMonthIndex = index;
                        });
                      },
                    ),
                    Wheel(
                      items: dates,
                      selectedColor: Colors.black,
                      unselectedColor: Colors.grey,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedDate = index + 1;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            onNextPressed: () async {
              DateTime lastPeriodStart = DateTime(selectedYear, selectedMonthIndex + 1, selectedDate);

              // Create the cycle data object
              CycleData cycleData = CycleData(
                cycleStartDate: lastPeriodStart.toIso8601String(),  // Use ISO 8601 string format for DateTime
                cycleEndDate: lastPeriodStart.add(Duration(days: globals.selectedCycleDays)).toIso8601String(),
                periodLength: widget.selectedDays,
                cycleLength: widget.selectedCycleDays,
                pastPeriods: [
                  ...Provider.of<CycleProvider>(context, listen: false).pastPeriods.map((date) => date.toIso8601String()),  // Convert DateTime to String
                  lastPeriodStart.toIso8601String(),  // Add the new period start date as String
                ],
              );

              // Store the cycle data in Hive
              var box = await Hive.openBox<CycleData>('cycleData');
              await box.put('cycle', cycleData); // Save data with key 'cycle'

              // Update the CycleProvider with the new period
              Provider.of<CycleProvider>(context, listen: false).addPeriod(lastPeriodStart);  // Add the new period to the provider

              print("Selected Date: $lastPeriodStart");

              // Navigate to the next screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Flow2Page()), // Go to next screen
              );
            },

          ),
        ),
      ),
    );
  }
}
