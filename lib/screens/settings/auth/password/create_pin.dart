import 'package:calender_app/auth/auth_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/auth/password/enter_pin.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class CreatePinScreen extends StatefulWidget {
  @override
  _CreatePinScreenState createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  String _pin = "";
  bool _isPinValid = true;

  // Function to handle PIN submission
  void _submitPin() {
    _pin = _controllers.map((controller) => controller.text).join();
    if (_pin.length != 4) {
      setState(() {
        _isPinValid = false; // PIN is invalid
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PIN must be 4 digits")),
      );
    } else {
      setState(() {
        _isPinValid = true;
      });
      // If valid,

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PIN Saved")),
      );
    }
  }

  // Function to handle fingerprint authentication
  Future<void> _authenticateWithFingerprint() async {
    // Assuming you have the LocalAuthentication plugin set up
    final LocalAuthentication _auth = LocalAuthentication();
    bool authenticated = await _auth.authenticate(
      localizedReason: 'Please authenticate to proceed',
      options: AuthenticationOptions(
        stickyAuth: true,
        useErrorDialogs: true,
        biometricOnly: true,
      ),
    );
    if (authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fingerprint authentication successful")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fingerprint authentication failed")),
      );
    }
  }

  // Function to handle 'Forgot PIN' action
  void _forgotPin() {
    // Logic for forgot PIN (e.g., reset PIN process)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Forgot PIN functionality is under construction")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Create PIN"),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your PIN',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPinField(0),
                  _buildPinField(1),
                  _buildPinField(2),
                  _buildPinField(3),
                ],
              ),
              SizedBox(height: 20),
              if (!_isPinValid)
                Text(
                  'PIN must be 4 digits',
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _forgotPin,
                    child: Text(
                      'Forgot PIN?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: _authenticateWithFingerprint,
                    child: Text(
                      'Use Fingerprint',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              CustomButton(
                onPressed: () {
                  if (_pin.length == 4) {
                    Provider.of<AuthProvider>(context, listen: false).savePin(_pin);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PIN saved successfully")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PIN must be 4 digits")));
                  }
                },
                text: 'Save',
                backgroundColor: primaryColor,
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Pin input field widget
  Widget _buildPinField(int index) {
    return Container(
      width: 50,
      child: TextField(
        controller: _controllers[index], // Using the corresponding controller
        onChanged: (value) {
          setState(() {
            // Ensure PIN is updated as user types
            _pin = _controllers.map((controller) => controller.text).join();
          });
        },
        obscureText: true,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
      ),
    );
  }
}
