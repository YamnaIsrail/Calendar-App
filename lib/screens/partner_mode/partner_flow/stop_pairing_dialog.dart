import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/homeScreen.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calender_app/provider/paired_days_provider.dart';

class StopPairingDialogHelper {
  static void unpairPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unpair with your partner?'),
          content: const Text('If you stop, you will no longer receive your partner’s period updates and pregnancy-related information.'),
          actions: [
            CustomButton(
              onPressed: () {
                PairedDaysProvider().resetPairedDays();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                },
              backgroundColor: primaryColor,
              text: 'Unpair',
            ),
            SizedBox(height: 5),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: secondaryColor,
              text: 'Cancel',
              textColor: Colors.black,
            ),
          ],
        );
      },
    );
  }

}