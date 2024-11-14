import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'partner_question_1.dart';

class PartnerPairing extends StatelessWidget {
  const PartnerPairing({super.key});

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

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/partner_mode/Isolation_Mode.svg", height: 100), // Adjust height as needed
                    const SizedBox(height: 24),
                    Text(
                      "Partner pairing successful",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                    "Explore with your partner together now!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: CustomButton(
                  text: "Done",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        PartnerNicknameScreen()));
                  },
                  backgroundColor: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
