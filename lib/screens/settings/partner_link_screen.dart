import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import 'share_invitation_code.dart';

class PartnerLinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Partner Mode",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Only 3 steps to link with your Partner',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Step 1
                      buildStep(
                        icon: Icons.code,
                        stepNumber: "1.",
                        title: "Generate an invitation code",
                        description:
                        "The code will expire if you and your partner are not paired within 24 hours.",
                      ),
                      SizedBox(height: 20),
                      // Step 2
                      buildStep(
                        icon: Icons.send,
                        stepNumber: "2.",
                        title: "Share code to your partner",
                        description:
                        "Select your preferred method to send the invitation code.",
                      ),
                      SizedBox(height: 20),
                      // Step 3
                      buildStep(
                        icon: Icons.lock_clock,
                        stepNumber: "3.",
                        title: "Wait for partner to enter code",
                        description:
                        "Both of you will be connected once your partner confirms the pairing.",
                      ),
                    ],
                  ),
                ),
              ),
              // Custom button at the end
              SizedBox(height: 20),
              Center(
                child: CustomButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ShareCodeScreen())); },
                  text: "Continue",

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create each step with icon, number, title, and description
  Widget buildStep({
    required IconData icon,
    required String stepNumber,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: Colors.pinkAccent, size: 28),
            Container(
              height: 60, // Line height between steps
              width: 2,
              color: Colors.pinkAccent,
            ),
          ],
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$stepNumber $title",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
