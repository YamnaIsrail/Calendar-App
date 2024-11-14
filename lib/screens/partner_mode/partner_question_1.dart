import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/background.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import 'partner_question_2.dart';

class PartnerNicknameScreen extends StatelessWidget {
  const PartnerNicknameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, fill, etc.)
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gradient Progress Bar
              Container(
                width: 100, // Adjust width for the progress bar
                height: 4,  // Height for the progress bar
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Background color of progress bar
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Stack(
                  children: [
                    // Background of the progress bar
                    Container(
                      width: double.infinity,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Gradient-filled progress
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.5, // Adjust based on progress (0.0 to 1.0)
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [
                              Colors.purpleAccent, // Start color of gradient
                              Colors.pinkAccent,   // End color of gradient
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Define skip functionality
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            ),
          ],
          centerTitle: true,
        ),

        body: Center(

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  "What does your partner usually call you",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter a nickname that your partner prefers.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      //hintText: "Enter nickname",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: CustomButton(
                    text: "Next",
                    onPressed: () {
                      // Navigate to next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PartnerSweetNicknameScreen()),
                      );
                    },
                    backgroundColor: greyBlueColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

