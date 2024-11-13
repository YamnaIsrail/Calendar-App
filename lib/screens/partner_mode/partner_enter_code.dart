import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/partner_mode/partner_pairing_successful.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PartnerEnterCode extends StatelessWidget {
  const PartnerEnterCode({super.key});

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
          appBar: AppBar(
            title: Text("Partner Mode"),
            leading: CircleAvatar(
              backgroundColor: Colors.transparent, // to remove extra background color
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
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
                      SvgPicture.asset("assets/partner_mode/arrowFrame.svg", height: 100), // Adjust height as needed
                      const SizedBox(height: 24),
                      Text(
                        "Enter invitation code",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "The code can be found in the message your partner has sent you.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Enter code",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: CustomButton(
                    text: "Next",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          PartnerPairing()));
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
}
