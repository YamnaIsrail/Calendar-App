import 'package:calender_app/kegel_excercise//kegel_excercise_home.dart';
import 'package:flutter/material.dart';

import 'kegel_screen5.dart';
import 'textStyles.dart';

class HowToDoKegelScreen extends StatelessWidget {
  const HowToDoKegelScreen({super.key});

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
            Text(
              "How to do Kegel?",
              style: headingStyle,
            ),

            const Text(
                'Kegel requires a rhythmic contraction of pelvic floor muscles to strengthen them.'),
            const SizedBox(height: 20),
            Center(
              child: Image.asset('assets/kegel/pc_muscles.png', height: 150),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HowToDoKegel1()),
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
              child: const Text('How to find the pelvic\n floor muscles?'),
            ),
          ],
        ),
      ),
    );
  }
}
