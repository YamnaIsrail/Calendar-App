import 'package:calender_app/auth/auth_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

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
                onPressed: () {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  if (passwordController.text == authProvider.password) {
                    // Navigate to the next screen upon successful authentication
                    Navigator.pushReplacementNamed(context, '/home');
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
}
