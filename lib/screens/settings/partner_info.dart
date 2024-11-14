import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'sign_in_partner.dart';

class PartnerModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "For Partner",
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 27),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize
                .min, // Use MainAxisSize.min to avoid unbounded height error
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Hormones can affect your relationship...',
                      style: TextStyle(fontSize: 22),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Your partner may not completely understand '
                      'what you go through during your cycle. '
                      'Let Partner Mode provide the support you need!',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    SvgPicture.asset(
                      "assets/partner_mode/partner_mood.svg",
                      height: 206,
                      width: 309,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0xffcdc6fc),

                ),
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),

                child: Column(
                  children: [
                    Text(
                      "With the Partner Mode",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "•\tYour partner will better know your cycle.\n"
                      "•\tYou'll get more support and care.\n"
                      "•\tPlan your life and intimate time together.\n"
                      "•\tShare the experience of tracking pregnancy together.\n",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PartnerModeSignInScreen()),
                    );
                  },
                  text: "Link with my Partner",
                  backgroundColor: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
