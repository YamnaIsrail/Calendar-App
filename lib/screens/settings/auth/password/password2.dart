import 'package:calender_app/screens/settings/auth/password/password_screens_toggle_widget.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

import '../finger_print.dart';
import 'create_password.dart';
import 'create_pin.dart';

class Password2Screen extends StatelessWidget {
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
            title: 'Fingerprint',
            subtitle: 'Use device fingerprint to unlock',
            value: true,
            onChanged: (bool value) {
              showFingerprintDialog(context);
            },
          ),
          SizedBox(height:10),
          Container(padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),

              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(12),  // Rounded corners
              ),
              child: ListTile(
              title: Text('Change Password'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Handle Change PIN action
              },
            ),
          ),
        ],
      ),
    ));
  }

}
