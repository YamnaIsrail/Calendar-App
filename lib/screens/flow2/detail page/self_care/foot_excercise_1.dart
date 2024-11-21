import 'package:flutter/material.dart';
import 'dart:async';  // Import for the Timer
import 'package:calender_app/screens/flow2/detail%20page/self_care/pose_1.dart';
import 'package:calender_app/screens/globals.dart';

class FootExercise extends StatefulWidget {
  final String title;
  final Widget goto;
  final String time;
  final String imagePath;

  const FootExercise({
    required this.title,
    required this.goto,
    required this.imagePath,
    required this.time,
  });

  @override
  _FootExerciseState createState() => _FootExerciseState();
}

class _FootExerciseState extends State<FootExercise> with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _start = 180; // Countdown from 3 minutes (180 seconds)
  bool _isTimerRunning = false;  // Flag to track timer state
  late AnimationController _controller;
  late Animation _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup for image
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);  // Repeating the animation (zoom in/out effect)
    _scaleAnimation = Tween(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  // Countdown Timer tick handler
  void _onTimerTick(Timer timer) {
    setState(() {
      if (_start > 0) {
        _start--;
      } else {
        _timer.cancel();  // Stop the timer when it reaches 0
        _isTimerRunning = false;  // Timer stops
      }
    });
  }

  // Start the timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), _onTimerTick);
    setState(() {
      _isTimerRunning = true;
    });
  }

  // Stop the timer
  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  // Convert seconds to a time format (mm:ss)
  String get formattedTime {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE8EAF6),
                Color(0xFFF3E5F5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Exercise'),
        actions: [
          IconButton(
            icon: Icon(Icons.music_note, color: Colors.pink),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Image.asset(
                    widget.imagePath,
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(widget.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(formattedTime, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: primaryColor, size: 40),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_isTimerRunning) {
                      _stopTimer();  // Stop the timer if it's running
                    } else {
                      _startTimer();  // Start the timer if it's stopped
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.all(20),
                  ),
                  child: Icon(
                    _isTimerRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: primaryColor, size: 40),
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => widget.goto,
                    ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
