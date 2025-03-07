import 'package:calender_app/kegel_excercise//kegel_excercise_home.dart';
import 'package:flutter/material.dart';

import 'textStyles.dart';

class BenefitsScreen extends StatelessWidget {
  const BenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         actions: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text("What are the benefits?", style: headingStyle,),
              customSection(
                  "-Sex life",
                "Improve blood circulation to your vagina, tighten your vagina and increase vaginal lubrication.Increase sexual arousal, more pleasure during sex and make it easier for you to reach orgasm.",
                  "assets/kegel/life.png"),
               customSection(
                  "-Pregnancy",
                   "Prevents urinary incontinence by improving bladder control.Reduces labor pain and shortens the time of labor by developing the ability to relax and control the pelvic floor muscles.Speeds up the postpartum recovery. Helps heal perineal tissues, which are stretched during vaginal birth.",
                   "assets/kegel/ovula.png"),
              customSection(
                  "- Privacy",
                 "You can do it anywhere. No one will know that you are doing it.",
                  "assets/kegel/privacy.png"),
              customSection(
                  "-Self Care",
                  "It can prevent urinary incontinence, uterine and vaginal prolapse caused by increased pressure in the abdomen",
                "assets/kegel/selfcare.png"),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xff6356f2),
                  backgroundColor: Color(0xffe5ebff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size(
                      double.infinity, 50), // Full width with minimum height
                ),

                onPressed: () {
                  Navigator.pop(context);

                },
                child: const Text('Got it',
                  style: TextStyle(
                    fontWeight: FontWeight.w500, // Similar to Semi-Bold
                    fontSize: 17,
                  ),),
              ),
             ],
          ),
        ),
      ),
    );
  }
}

