import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/auth/password/enter_pin.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class CreatePinScreen extends StatelessWidget {
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
                _buildPinField(),
                _buildPinField(),
                _buildPinField(),
                _buildPinField(),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle "Forgot PIN?" action
                  },
                  child: Text(
                    'Forgot PIN?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle "Use Fingerprint" action
                  },
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> EnterPinScreen()));
              },
              text: 'Submit',
              backgroundColor: primaryColor,
            ),
          ],
        ),
      ),
        )    );
  }

  Widget _buildPinField() {
    return Container(
      width: 50,
      child: TextField(
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
