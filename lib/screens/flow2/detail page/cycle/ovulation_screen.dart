import 'package:calender_app/screens/flow2/flow_2_screens_main/my_cycle_main.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/buttons.dart';

class OvulationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text.rich(
          //   TextSpan(
          //     children: [
          //       TextSpan(
          //         text: 'A urinary ovulation predictor detects the surge of luteinizing '
          //             'hormone (LH), indicating the approach of ovulation. It is a test '
          //             'that measures LH levels in urine, typically occurring 24 to 36 hours '
          //             'before ovulation, helping identify the most fertile days in a woman’s '
          //             'cycle for conception.\n\n'
          //             'For more detail, please check the link below:\n',
          //         style: TextStyle(fontSize: 16),
          //       ),
          //       TextSpan(
          //         text: 'https://en.wikipedia.org/wiki/Luteinizing_hormone',
          //         style: TextStyle(color: Colors.blue, fontSize: 16),
          //         recognizer: TapGestureRecognizer()
          //           ..onTap = () async {
          //             // Launch the URL when the text is tapped
          //             final url = 'https://en.wikipedia.org/wiki/Luteinizing_hormone';
          //             if (await canLaunch(url)) {
          //               await launch(url);
          //             } else {
          //               throw 'Could not launch $url';
          //             }
          //           },
          //       ),
          //     ],
          //   ),
          // ),
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
                'cycle for conception.\n\n'
                'For more detail, please check the link below:\n'
                'https://en.wikipedia.org/wiki/Luteinizing_hormone',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          CustomButton(
            text: 'OK',
            onPressed: ()  {
              Navigator.pop(context);
            },
            backgroundColor: primaryColor,
          ),
        ],
      ),
    );
  }
}
