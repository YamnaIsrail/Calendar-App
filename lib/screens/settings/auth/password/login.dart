import 'package:calender_app/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'enter_password.dart';
import 'enter_pin.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
       body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to either PIN or Password screen based on saved authentication mode
            if (authProvider.usePassword) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EnterPasswordScreen()),
              );
            }
            else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EnterPinScreen()),
              );
            }
          },
          child: Text('Proceed to Authentication'),
        ),
      ),
    );
  }
}
