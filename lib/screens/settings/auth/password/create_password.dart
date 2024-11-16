import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import 'enter_password.dart';

class CreatePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  bgContainer(

      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Password"),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('Password', style: TextStyle(fontSize: 16)),
                TextField(

                  obscureText: true,
                  decoration: InputDecoration(
                    helperText: 'Only use letters, numbers, and symbols.',
                    helperStyle: TextStyle(fontSize: 12, color: Colors.grey),

                    hintText: '',  // Empty hint text
                    filled: true,
                    fillColor: Colors.white,  // White background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),  // Rounded corners
                      borderSide: BorderSide.none,  // No border line
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Confirm Password', style: TextStyle(fontSize: 16)),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '',  // Empty hint text
                    filled: true,
                    fillColor: Colors.white,  // White background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),  // Rounded corners
                      borderSide: BorderSide.none,  // No border line
                    ),
                  ),
                ),
                SizedBox(height: 16),
                  Text('Email', style: TextStyle(fontSize: 16)),
                TextField(
                  decoration: InputDecoration(
                    helperText: 'Email is required for the purpose of backing up your password.',
                    helperStyle: TextStyle(fontSize: 12, color: Colors.grey),

                    hintText: '',
                    filled: true,
                    fillColor: Colors.white,  // White background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),  // Rounded corners
                      borderSide: BorderSide.none,  // No border line
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Security Question TextField with label above
                Text('Security Question', style: TextStyle(fontSize: 16)),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(12),  // Rounded corners
                  ),
                  child: ExpansionTile(
                    title: Text('__Select__'),
                    children: [
                      ListTile(
                        title: Text('What is your pet\'s name?'),
                        onTap: () {
                          // Handle selection here
                        },
                      ),
                      ListTile(
                        title: Text('What was the name of your first school?'),
                        onTap: () {
                          // Handle selection here
                        },
                      ),
                      ListTile(
                        title: Text('What is your mother\'s maiden name?'),
                        onTap: () {
                          // Handle selection here
                        },
                      ),
                      ListTile(
                        title: Text('What is your favorite color?'),
                        onTap: () {
                          // Handle selection here
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                // Answer TextField with label above
                Text('Answer', style: TextStyle(fontSize: 16)),
                TextField(
                  controller: TextEditingController(text: 'Fluffy'),  // Default value
                  decoration: InputDecoration(
                    hintText: '',  // Empty hint text
                    filled: true,
                    fillColor: Colors.white,  // White background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),  // Rounded corners
                      borderSide: BorderSide.none,  // No border line
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  backgroundColor: primaryColor,
                  onPressed: () {

                    Navigator.push(context, MaterialPageRoute(builder: (context)=> EnterPasswordScreen()));
                  },
                   text: 'Save',


                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}