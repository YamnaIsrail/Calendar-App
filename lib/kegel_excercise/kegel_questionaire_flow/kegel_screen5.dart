import 'package:calender_app/kegel_excercise//kegel_excercise_home.dart';
import 'package:flutter/material.dart';

import 'kegel_screen6.dart';
import 'textStyles.dart';
class HowToDoKegel1 extends StatelessWidget {
  const HowToDoKegel1({super.key});

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
            Text("Method 1", style: headingStyle,),

            const Text('Muscles that can slow or stop the urination are pelvic floor muscles. Don’t tense your buttocks, legs and abdomen when stopping midstream.'),
            const SizedBox(height: 20),
            Center(
              child: Image.asset('assets/kegel/tapglass.png', height: 150),
            ),


            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HowToDoKegel2()),
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

              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
