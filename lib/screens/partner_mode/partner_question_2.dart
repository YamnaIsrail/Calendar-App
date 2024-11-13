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
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            TextButton(
              onPressed: () {}, // Add skip functionality here
              child: Text("Skip", style: TextStyle(color: Colors.grey[700])),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
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
