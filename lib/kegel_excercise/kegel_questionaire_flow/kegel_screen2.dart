import 'package:flutter/material.dart';

import 'kegel_screen10.dart';
import 'kegel_screen4.dart';
import 'kegel_screen3.dart';
import 'kegel_screen8.dart';

class WhatIsKegelScreen extends StatelessWidget {
  const WhatIsKegelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("What's Kegel?",
                  style: TextStyle(
                    fontWeight: FontWeight.w600, // Similar to Semi-Bold
                    fontSize: 22,
                  ),
                ),
                const Text(
                 "Kegel is a form of exercise that strengthens your pelvic floor muscles, which support your uterus and bladder."
                     "\nStudies show that Kegel can prevent or control "
                     "urinary incontinence, and also prevent pelvic organ prolapse."  ,
                  style: TextStyle(
                    fontWeight: FontWeight.normal, // Similar to Semi-Bold
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BenefitsScreen()),
                    );
                  },
                  child: const Text('What are the benefits?',  style: TextStyle(
                    fontWeight: FontWeight.w500, // Similar to Semi-Bold
                    fontSize: 17,
                  )),
                ),
                SizedBox(height: 20),

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HowToDoKegelScreen()),
                    );
                  },
                  child: const Text('How to do Kegel?',  style: TextStyle(
                    fontWeight: FontWeight.w500, // Similar to Semi-Bold
                    fontSize: 17,
                  )),
                ),
                SizedBox(height: 20),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CanIDoKegel()),
                    );
                  },
                  child: const Text('Can I do Kegel?',
                      style: TextStyle(
                    fontWeight: FontWeight.w500, // Similar to Semi-Bold
                    fontSize: 17,
                  )),
                ),
                SizedBox(height: 20),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KegelNote()),
                    );
                  },
                  child: const Text('Please note',
                    style: TextStyle(
                    fontWeight: FontWeight.w500, // Similar to Semi-Bold
                    fontSize: 17,
                  ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
