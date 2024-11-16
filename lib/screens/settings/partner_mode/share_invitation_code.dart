
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class ShareCodeScreen extends StatelessWidget {
  final String code = "VKjMd9"; // Example code

  @override
  Widget build(BuildContext context) {
    return bgContainer(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Partner Mode",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 27),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body:  Padding(
            padding: const EdgeInsets.all(35),
            child: Center(
              child: Column(
                children: [
                  SvgPicture.asset("assets/partner_mode/Isolation_Mode.svg"),
                  SizedBox(height: 30),
                 Text(
                    'Share your invitation code',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),

                  Text(
                    'The code is valid for 24 hours',
                    style: TextStyle(fontSize: 14,),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Text(
                    '$code',
                    style: TextStyle(fontSize: 14,),
                    textAlign: TextAlign.center,
                  ),

                  Text(
                    'The code is valid until 23:55:23',
                    style: TextStyle(fontSize: 8,),
                    textAlign: TextAlign.center,
                  ),


                  Center(
                    child: CustomButton(
                      backgroundColor: primaryColor,
                      onPressed: () {

                        },
                      text: "Share my code",

                    ),
                  ),


                ],
              ),
            ),
          ),
        ));
  }
}

