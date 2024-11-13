import 'package:flutter/material.dart';

import 'partner_mode_setting.dart';

class PartnerModeToday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PartnerModeSetting()),
          );
        },
            icon: Icon(Icons.menu)),

        title: Text('Partner Mode'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'), // Use AssetImage for local images
            fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, fill, etc.)
          ),
        ),

        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.asset("assets/cal.png"),
                  Positioned(
                    top: 130, // Adjust this value to position vertically
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          "13 Days Left",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.black), // Style as needed
                        ),
                        SizedBox(height: 5), // Add space between texts
                        Text(
                          "Next periods will start on",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black), // Style as needed
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [

                      // Today - Cycle Day 11 Section
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today - Cycle Day 11',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'HIGH - Chance of getting periods',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 16),

                            // Progress Bar
                            Row(
                              children: [
                                Text("Oct 3"),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: 0.55, // Adjust this value as needed
                                    color: Colors.pink,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                ),
                                Text("Today"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

extension on DateTime {
  String toShortDateString() {
    return "${this.day}/${this.month}/${this.year}";
  }}
