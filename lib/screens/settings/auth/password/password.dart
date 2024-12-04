import 'package:calender_app/auth/auth_provider.dart';
import 'package:calender_app/screens/settings/auth/finger_print.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_password.dart';
import 'create_pin.dart';
import 'password_screens_toggle_widget.dart';

class PasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Listen to the AuthProvider to get the current authentication mode (PIN/Password)
    final authProvider = context.watch<AuthProvider>();

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Password Setup"),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: Column(
          children: [
            // PIN Toggle
            buildToggleOption(
              title: 'PIN',
              value: !authProvider.usePassword, // This reflects the current state (PIN is enabled if usePassword is false)
              onChanged: (bool value) {
                if (value) {
                  // If the user enables PIN, disable Password and navigate to PIN screen
                  context.read<AuthProvider>().toggleAuthMode(false); // Disable Password
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreatePinScreen()),
                  );
                } else {
                  // If the user disables PIN, remove the PIN but leave Password as is
                  context.read<AuthProvider>().savePin('');
                }
              },
            ),

            // Password Toggle
            buildToggleOption(
              title: 'Password',
              value: authProvider.usePassword, // This reflects the current state (Password is enabled if usePassword is true)
              onChanged: (bool value) {
                if (value) {
                  // If the user enables Password, disable PIN and navigate to Password screen
                  context.read<AuthProvider>().toggleAuthMode(true); // Enable Password
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreatePasswordScreen()),
                  );
                } else {
                  // If the user disables Password, remove the Password but leave PIN as is
                  context.read<AuthProvider>().savePassword('');
                }
              },
            ),

            // Fingerprint Change Option (Optional)
            buildToggleOption(
              title: 'Change Fingerprint',
              value: true,
              onChanged: (bool value) {
                showFingerprintDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build toggle option for each setting
  Widget buildToggleOption({required String title, required bool value, required Function(bool) onChanged}) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
