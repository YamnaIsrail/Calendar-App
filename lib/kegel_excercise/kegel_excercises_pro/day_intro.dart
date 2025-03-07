import 'package:calender_app/firebase/analytics/analytics_service.dart';
import 'package:calender_app/kegel_excercise//kegel_questionaire_flow/kegel_screen1.dart';
import 'package:flutter/material.dart';
import '../kegel_excercise_home.dart';
import 'excercise_page.dart';

class ExcerciseDayScreen extends StatefulWidget {
  final int day;
  final int duration;
  final int totalcount;

  const ExcerciseDayScreen({super.key, required this.day,
    required this.totalcount, required this.duration});

  @override
  State<ExcerciseDayScreen> createState() => _ExcerciseDayScreenState();
}

class _ExcerciseDayScreenState extends
State<ExcerciseDayScreen> {
  bool isAudio = true;
  bool vibrate = true;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now(); // Record the entry time
    AnalyticsService.logScreenView("KegelExcerciseDayScreen");
  }

  @override
  void dispose() {
    if (_startTime != null) {
      int duration = DateTime.now().difference(_startTime!).inSeconds;
      AnalyticsService.logScreenTime("kegelExcerciseDayScreen", duration);
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => KegelExercisesScreen()), // Replace with your desired screen
        );
        return false; // Prevent default back navigation
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xff647BCD),
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => KegelExercisesScreen()));
                          },
                        ),
                        Text(
                          " ${widget.totalcount} / ${widget.totalcount}   ", // Display current state and total states
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.lightbulb,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => FractionallySizedBox(
                                heightFactor: 0.7, // Covers 70% of screen height
                                child: IntroScreen(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(isAudio ?
                          Icons.volume_down : Icons.volume_off, color: Colors.white,),
                          onPressed: () {
                            setState(() {
                              isAudio = !isAudio; // Toggle state
                            });
                          },
                        ),
                        Transform.rotate(
                          angle:
                          -0.4,
                          child: IconButton(
                            icon: Icon(vibrate ? Icons.vibration : Icons.smartphone, color: Colors.white,),
                            onPressed: () {
                              setState(() {
                                vibrate = !vibrate; // Toggle state
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                          "KEGEL EXERCISES",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Day ${widget.day}",
                          style: TextStyle(
                              color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${widget.duration} min",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        SizedBox(height: 30),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width *
                              0.7, //
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              minimumSize:  Size(
                                 double.infinity, 50), // Full width with minimum height
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BreathingApp(
                              isAudio: isAudio,
                                  vibrate: vibrate,


                                  totalCount: widget.totalcount,
                                  totalDurationMinutes: widget.duration,
                                  day: widget.day,))

                              );
                            },
                            child: Center(
                              child: ListTile(
                                                    title: Text("Start", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                leading: Icon(Icons.play_arrow_sharp, color: Colors.black,),
                              ),
                            ),
                          ),
                        )
                      ],
                ),
              ),

              Expanded(
                child: SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }
}