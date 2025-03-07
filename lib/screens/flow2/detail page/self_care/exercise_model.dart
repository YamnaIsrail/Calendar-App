import 'package:flutter/material.dart';
import 'dart:async';
import 'package:calender_app/screens/flow2/detail%20page/self_care/pose_1.dart';
import 'package:calender_app/screens/globals.dart';

import '../../../../admob/banner_ad.dart';

class ExerciseModel extends StatefulWidget {
  final String title;
  final Widget goto;
  final String time;
  final String imagePath;
  final Widget? onBackPress;

  const ExerciseModel({
    required this.title,
    required this.goto,
    required this.imagePath,
    required this.time,
    this.onBackPress,
  });

  @override
  _ExerciseModelState createState() => _ExerciseModelState();
}

class _ExerciseModelState extends State<ExerciseModel> with SingleTickerProviderStateMixin {
  Timer? _timer;  // Changed to nullable to avoid LateInitializationError
  int _start = 180;
  bool _isTimerRunning = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _onTimerTick(Timer timer) {
    if (_start > 0) {
      setState(() {
        _start--;
      });
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), _onTimerTick);
    setState(() {
      _isTimerRunning = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();  // Ensure timer is canceled properly
    _controller.dispose();
    super.dispose();
  }

  String get formattedTime {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.onBackPress != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => widget.onBackPress!),
          );
          return false; // Prevent the default pop behavior
        } else {
          return true; // Allow default pop behavior
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: BannerAdWidget(), // Add the banner ad here
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8EAF6), Color(0xFFF3E5F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (widget.onBackPress != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => widget.onBackPress!),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
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
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _isTimerRunning ? _stopTimer() : _startTimer();
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => widget.goto));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
