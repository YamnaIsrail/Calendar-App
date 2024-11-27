import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/partner_mode/partner_pairing_successful.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

class PartnerEnterCode extends StatelessWidget {
  const PartnerEnterCode({super.key});

  Future<bool> validateCode(String enteredCode) async {
    final box = await Hive.openBox('partner_codes');
    final storedCodeData = box.get(enteredCode);

    if (storedCodeData == null) return false;

    final DateTime expirationTime = storedCodeData['expiresAt'];
    if (DateTime.now().isAfter(expirationTime)) {
      return false;
    }

    return true;
  }

  void _handleNext(BuildContext context, String enteredCode) async {
    bool isValid = await validateCode(enteredCode);
    if (isValid) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PartnerPairing()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid or expired code. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Partner Mode"),
          leading: CircleAvatar(
            backgroundColor: Color(0xffFFC4E8),
            child: IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
                        controller: codeController,
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
                  onPressed: () => _handleNext(context, codeController.text),
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
