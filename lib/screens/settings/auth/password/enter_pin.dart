import 'package:calender_app/auth/auth_provider.dart';
import 'package:calender_app/hive/cycle_model.dart';
import 'package:calender_app/screens/flow2/home_flow2.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/homeScreen.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class EnterPinScreen extends StatelessWidget {
  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Text("Enter PIN"),
          backgroundColor: Colors.transparent,
          centerTitle: true
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter PIN',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: pinController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'PIN',
                    filled: true,
                    fillColor: Color(0xffD5D6EE),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  backgroundColor: primaryColor,
                  onPressed: () async {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    if (pinController.text == authProvider.pin) {
                      bool hasCycleData = await checkIfCycleDataExists();
                      if (hasCycleData) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Flow2Page()),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }
                      // Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      // Show error if PIN doesn't match
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid PIN')));
                    }
                  },
                 text: 'Submit'
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> checkIfCycleDataExists() async {
    var box = await Hive.openBox<CycleData>('cycleData');
    CycleData? cycleData = box.get('cycle'); // Retrieve the cycle data
    return cycleData != null; // Return true if data exists, otherwise false
  }

}
