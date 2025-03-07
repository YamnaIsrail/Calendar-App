import 'package:calender_app/auth/auth_provider.dart';
import 'package:calender_app/screens/globals.dart';
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
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  String _pin = "";
  bool _isPinValid = true;

  // Function to handle PIN submission
  void _submitPin() {
    _pin = _controllers.map((controller) => controller.text).join();
    if (_pin.length != 4) {
      setState(() => _isPinValid = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PIN must be 4 digits")),
      );
    } else {
      setState(() => _isPinValid = true);
      Provider.of<AuthProvider>(context, listen: false).savePin(_pin);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PIN Saved Successfully")),
      );

      Navigator.pop(context);
    }
  }

  // Function to handle fingerprint authentication
  Future<void> _authenticateWithFingerprint() async {
    final LocalAuthentication _auth = LocalAuthentication();
    bool authenticated = await _auth.authenticate(
      localizedReason: 'Please authenticate to proceed',
      options: AuthenticationOptions(
        stickyAuth: true,
        useErrorDialogs: true,
        biometricOnly: true,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(authenticated ? "Fingerprint authentication successful" : "Fingerprint authentication failed")),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
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
                children: List.generate(4, (index) => _buildPinField(index)),
              ),
              SizedBox(height: 20),
              if (!_isPinValid)
                Text(
                  'PIN must be 4 digits',
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 30),
              CustomButton(
                onPressed: _submitPin,
                text: 'Save',
                backgroundColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Pin input field widget with focus movement logic
  Widget _buildPinField(int index) {
    return Container(
      width: 50,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        onChanged: (value) {
          setState(() {
            _pin = _controllers.map((controller) => controller.text).join();
          });

          // Move to next field if filled
          if (value.length == 1 && index < 3) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
          // Move to previous field on backspace
          else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
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
