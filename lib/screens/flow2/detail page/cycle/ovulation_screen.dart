import 'package:flutter/material.dart';

import '../../../widgets/buttons.dart';

class OvulationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ovulation Predictor"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LH Test',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'A urinary ovulation predictor detects the surge of luteinizing '
                  'hormone (LH), indicating the approach of ovulation. It is a test '
                  'that measures LH levels in urine, typically occurring 24 to 36 hours '
                  'before ovulation, helping identify the most fertile days in a woman’s '
                  'cycle for conception.\n\nFor more detail, please check the link below:\n'
                  'https://en.wikipedia.org/wiki/Luteinizing_hormone',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Save',
              onPressed: () {  }
              ,)
          ],
        ),
      ),
    );
  }
}
