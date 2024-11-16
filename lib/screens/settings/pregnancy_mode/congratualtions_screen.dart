import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/dialog.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';


class CongratulationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
        child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
        child: Stack(
          children: [
            Image(image: AssetImage("assets/obj.png")),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage("assets/pregnancy/baby_cart.png")),
                Text(
                  "Congratulations!",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                 Text(
                  "Click continue to turn off your pregnancy mode.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                CustomButton(text: "Continue",
                    onPressed: (){
                        CalendarDialogHelper.showPregnancyDateDialog(context, (selectedLength) {
                          print("Selected period length: $selectedLength days");
                        });

    },


                    backgroundColor: primaryColor)
              ],
            ),
          ],
        ),
      ),
        )    );
  }
}
