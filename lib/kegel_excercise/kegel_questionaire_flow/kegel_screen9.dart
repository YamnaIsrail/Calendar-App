import 'package:flutter/material.dart';

import 'textStyles.dart';
import '../kegel_excercise_home.dart';

class NotSuitable extends StatelessWidget {
  const NotSuitable({super.key});

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Who’s not suitable?", style: headingStyle,),
              const Text(' 1. Women who have an episiotomy or a perineal tear dur to vaginal birth should do Kegel after recovery.'),

              const SizedBox(height: 20),
              Center(
                child: Image.asset('assets/kegel/med_add.png', height: 150),
              ),

              const SizedBox(height: 20),
              const Text(' 2. Women who just gave birth, and with a lochia that is heavy and dark red in color. You can try to do Kegel whenthe lochia is light and the color turns white.'),

              const SizedBox(height: 20),
              Center(
                child: Image.asset('assets/kegel/baby_preg.png', height: 150),
              ),

              const SizedBox(height: 20),
              const Text(' 3. Women who are on their period.'),


            ],
          ),
        ),
      ),
    );
  }
}
