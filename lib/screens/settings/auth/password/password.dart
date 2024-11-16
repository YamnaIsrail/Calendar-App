import 'package:calender_app/screens/settings/auth/finger_print.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'create_password.dart';
import 'create_pin.dart';
import 'password_screens_toggle_widget.dart';

class PasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Password"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildToggleOption(
            title: 'PIN',
            value: false,
            onChanged: (bool value) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CreatePinScreen()));

            },
          ),
       buildToggleOption(
            title: 'Password',
            value: true,
         onChanged: (bool value) {
           Navigator.push(context, MaterialPageRoute(builder: (context)=> CreatePasswordScreen()));

         },

       ),
          buildToggleOption(
            title: 'Change Fingerprint',
             value: true,
              onChanged: (bool value) { showFingerprintDialog(context);
              },

          ),
          ],
      ),
    ));
  }


}
