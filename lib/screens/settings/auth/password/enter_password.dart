import 'package:calender_app/auth/auth_provider.dart';
import 'package:calender_app/hive/cycle_model.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/flow2/home_flow2.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/homeScreen.dart';
import 'package:calender_app/screens/partner_mode/partner_flow/home_partner_flow.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:provider/provider.dart';

import 'package:calender_app/provider/partner_provider.dart';
class EnterPasswordScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgContainer(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        title: Text("Enter Password"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
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
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  if (passwordController.text == authProvider.password) {
                    bool hasCycleData = await checkIfCycleDataExists();
                    bool hasPartnerCycleData = await checkIfPartnerCycleDataExists();

                    if (hasCycleData) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Flow2Page()),
                      );
                    }else if (hasPartnerCycleData) {
                      final partnerProvider = Provider.of<PartnerProvider>(context, listen: false);
                      await partnerProvider.listenForCycleUpdates();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePartnerFlow()),
                      );}
                    else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                    // Navigate to the next screen upon successful authentication
                    // Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    // Show error if password doesn't match
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid Password')));
                  }
                },
                text: 'Login'
              ),
            ],
          ),
        ),
      ),
    ));
  }
  Future<bool> checkIfCycleDataExists() async {
    var box = await Hive.openBox<CycleData>('cycleData');
    CycleData? cycleData = box.get('cycle'); // Retrieve the cycle data
    return cycleData != null; // Return true if data exists, otherwise false
  }

  Future<bool> checkIfPartnerCycleDataExists() async {
    try {
      var box = Hive.box('partnerCycleData');
      var partnerCycleData = box.get('partnerData');
      return partnerCycleData != null;
    } catch (e) {
      // print("Error accessing partnerCycleData box: $e");
      return false;
    }
  }

}
