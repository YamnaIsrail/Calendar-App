import 'package:flutter/material.dart';
import '../kegel_excercise_home.dart';
import 'kegel_screen2.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xffe5ebff),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(15),
                        right: Radius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Hi',
                      style: TextStyle(
                        fontWeight: FontWeight.normal, // Similar to Semi-Bold
                        fontSize: 18,
                      ),
                    )),
                const SizedBox(height: 10),
                Container(
                    decoration: BoxDecoration(
                        color: Color(0xffe5ebff),
                        borderRadius: BorderRadius.circular(15)),
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.all(3),
                    child: const Text(
                      'May I share some knowledge '
                      'about Kegel with you?',
                      style: TextStyle(
                        fontWeight: FontWeight.normal, // Similar to Semi-Bold
                        fontSize: 18,
                      ),
                    )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WhatIsKegelScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff6356f2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: const Size(
                        double.infinity, 50), // Full width with minimum height
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600, // Similar to Semi-Bold
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const KegelExercisesScreen()),
                    // );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Not now',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, // Similar to Semi-Bold
                        fontSize: 16,
                        color: Color(0xff6356F2)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
