import 'package:calender_app/kegel_excercise//kegel_excercises_pro/kegelDaysUnlocked_hive.dart';
import 'package:calender_app/kegel_excercise/kegel_excercises_pro/day_intro.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:hive/hive.dart';
import 'dart:math';

import '../kegel_excercise_home.dart';

class CongratsScreen extends StatefulWidget {
  final int day;
  final int totalcount;

  const CongratsScreen({Key? key, required this.day, required this.totalcount,}) : super(key: key);

  @override
  _CongratsScreenState createState() => _CongratsScreenState();
}

class _CongratsScreenState extends State<CongratsScreen> {
  late ConfettiController _confettiController;
  bool _isLoading = true;
  int completedRepetitions = 1;
  int totalRepetitions = 3;

  @override
  void initState() {
    super.initState();
    _initializeKegelStorage();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await KegelStorage.init();  // Ensure Hive box is initialized
      completedRepetitions = await KegelStorage.getCompletedRepetitionsForDay(widget.day);
      totalRepetitions = await KegelStorage.getRepetitionsForDay(widget.day);

      setState(() {});  // Rebuild after initialization
      _confettiController.play();
    });
  }

  Future<void> _initializeKegelStorage() async {
    await KegelStorage.init();
    setState(() {
      _isLoading = false;

    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: KegelStorage.getUnlockedDay(),  // Get value asynchronously
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(body: Center(child: CircularProgressIndicator())); // Show loader until data is ready
        }

        int unlockedDay = snapshot.data!;

        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            body: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple.shade100,
                            ),
                            child: Center(
                              child: Text(
                                "👍", // Thumbs up emoji
                                style: TextStyle(fontSize: 50),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Congrats",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text("3 times a day to achieve the best results"),
                          SizedBox(height: 32),

                          // Repeat Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              if (completedRepetitions < totalRepetitions) {
                                await KegelStorage.incrementCompletedRepetitionsForDay(widget.day);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => ExcerciseDayScreen(
                                    day: widget.day,
                                    totalcount: widget.totalcount,
                                    duration: 5, // Adjust as necessary
                                  )),
                                );
                              }
                              else{
                                if (unlockedDay == widget.day) {
                                  await KegelStorage.setUnlockedDay(unlockedDay + 1);
                                }
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => KegelExercisesScreen()),
                                );

                              }
                            },
                            child:Text(
                                completedRepetitions < totalRepetitions
                                    ? (completedRepetitions == 0
                                    ? "Repeat for 1st Time"
                                    : completedRepetitions == 1
                                    ? "Repeat for 2nd Time"
                                    : "Repeat for Last Time")
                                    : "End",
                                style: TextStyle(color: Colors.white)
                            ),
                          ),
                          SizedBox(height: 16),
                          // Continue to Next Day Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              if (unlockedDay == widget.day) {
                                await KegelStorage.setUnlockedDay(unlockedDay + 1);
                              }
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => KegelExercisesScreen()),
                              );
                            },
                            child: Text("Continue to Next Day", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

                // Stack Confetti behind the thumb
                Positioned.fill(
                  left: 100,
                  bottom: 300,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirection: 2 * pi,  // Circular blast direction (right)
                      shouldLoop: false,
                      emissionFrequency: 0.05,
                      numberOfParticles: 100,
                      minBlastForce: 5.0,
                      maxBlastForce: 10.0,
                      gravity: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
