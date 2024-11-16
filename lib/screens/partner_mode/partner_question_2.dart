import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import 'partner_flow/home_partner_flow.dart';

class PartnerSweetNicknameScreen extends StatelessWidget {
  const PartnerSweetNicknameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      widthFactor: 1.0, // Adjust based on progress (0.0 to 1.0)
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
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePartnerFlow()),
                );
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                "Any sweet nickname for your partner?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "It will be shown in the reminders you receive.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  _buildNicknameOption("Honey"),
                  SizedBox(height: 12),
                  _buildNicknameOption("Sweetie"),
                  SizedBox(height: 12),
                  _buildEditableNicknameOption("Create a new one"),
                ],
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
                      MaterialPageRoute(builder: (context) => HomePartnerFlow()),
                    );
                  },
                  backgroundColor: greyBlueColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNicknameOption(String text) {
    return OutlinedButton(
      onPressed: () {
        // Define the action on option select if needed
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(color: Colors.grey), // Set outline color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Set border radius
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildEditableNicknameOption(String placeholder) {
    return OutlinedButton(
      onPressed: () {
        // Define the action for editing nickname
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(color: Colors.grey), // Set outline color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Set border radius
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            placeholder,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Icon(Icons.edit, color: Colors.grey[600]),
        ],
      ),
    );
  }

}
