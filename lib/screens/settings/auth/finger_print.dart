import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class FingerprintDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Center(
        child: Column(
         // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fingerprint, size: 100, color: Colors.pink),
            SizedBox(height: 20),
            Text(
              'Use Fingerprint to Unlock',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: primaryColor,
                text: 'Cancel',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage
void showFingerprintDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FingerprintDialog();
    },
  );
}
