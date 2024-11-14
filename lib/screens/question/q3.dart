import 'package:calender_app/screens/question/ques_screen.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals; // Import the globals file
import '../../widgets/background.dart';
import '../../widgets/question_appbar.dart';
import '../../widgets/wheel.dart';
import '../flow2/home_flow2.dart';

class QuestionScreen3 extends StatefulWidget {
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        image: DecorationImage(

          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          colors: [Color(0xFFE8EAF6), Color(0xFFF3E5F5)], // Light gradient background
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
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
        body: QuestionScreen(
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
          onNextPressed: () {
            globals.lastPeriodStartDate = DateTime(selectedYear, selectedMonthIndex + 1, selectedDate); // Save the last period date
            print("Selected Date: ${globals.lastPeriodStartDate}");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Flow2Page()),
            );
          },
        ),
      ),
    );
  }
}
