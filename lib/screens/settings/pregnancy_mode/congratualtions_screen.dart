import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/dialog.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CongratulationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pregnancyModeProvider = context.watch<PregnancyModeProvider>();
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

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomButton(text: "Continue",
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsPage()),
                        );
                        pregnancyModeProvider.togglePregnancyMode(false);

                        CalendarDialogHelper.showPregnancyDateDialog(context, (selectedLength) {
                            print("Selected period length: $selectedLength days");
                          });

                      },


                      backgroundColor: primaryColor),
                )
              ],
            ),
          ],
        ),
      ),
        )    );
  }
}
