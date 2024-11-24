import 'package:flutter/material.dart';
import '../../widgets/backgroundcontainer.dart';
import '../../widgets/buttons.dart';
import '../../widgets/question_appbar.dart';// Import your custom button

class QuestionScreen extends StatelessWidget {
  final String statement;
  final String caption;
  final Widget wheel;
  final VoidCallback onNextPressed;

  QuestionScreen({
    Key? key,
    required this.statement,
    required this.caption,
    required this.wheel,
    required this.onNextPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bgContainer(

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              statement,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              caption,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Container(height: 200, child: wheel),
            // Use CustomButton with a custom color
            CustomButton(
              text: "Next",
              onPressed: onNextPressed,
              backgroundColor: Color(0xFFEB1D98), // Example of a different color
            ),

          ],
        ),
      ),
    );
  }
}
