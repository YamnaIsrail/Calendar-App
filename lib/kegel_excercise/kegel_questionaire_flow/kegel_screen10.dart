import 'package:flutter/material.dart';

import '../kegel_excercise_home.dart';
import 'textStyles.dart';
import '../kegel_excercise_home.dart';

class KegelNote extends StatelessWidget {
  const KegelNote({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First two widgets wrapped in a Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Please note", style: headingStyle),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      leading: Icon(Icons.circle, size: 6),
                      title: Text('Empty your bladder before exercising.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.circle, size: 6),
                      title: Text('Stopping the urination is not an exercise. It’s not recommended to do it regularly as it can increase the risk of a urinary tract infection.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.circle, size: 6),
                      title: Text('Relax your body and mind.'),
                    ),
                  ],
                ),
              ],
            ),

            Spacer(), // Pushes the button towards the bottom

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const KegelExercisesScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffe5ebff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: const Size(double.infinity, 50), // Full width with minimum height
              ),
              child: const Text('Got it'),
            ),
          ],
        )

      ),
    );
  }
}
