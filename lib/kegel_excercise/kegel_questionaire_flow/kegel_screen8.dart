import 'package:calender_app/kegel_excercise//kegel_questionaire_flow/kegel_screen9.dart';
import 'package:flutter/material.dart';
import '../kegel_excercise_home.dart';

import 'textStyles.dart';
class CanIDoKegel extends StatelessWidget {
  const CanIDoKegel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () =>   Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const KegelExercisesScreen()),
        ), icon: const Icon(Icons.close))],

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Can I do Kegel?", style: headingStyle,),

            const Text('Kegel is suitable for people who have weak pelvic floor muscles because of pregnancy, childbirth, aging, being overweight, etc.'),
            const SizedBox(height: 20),
            Center(
              child: Image.asset('assets/kegel/bxs_heart.png', height: 150),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotSuitable()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffe5ebff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: const Size(
                    double.infinity, 50), // Full width with minimum height
              ),

              child: const Text('Who is not suitable?'),
            ),
          ],
        ),
      ),
    );
  }
}
