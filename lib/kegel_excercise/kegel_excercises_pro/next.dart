// import 'dart:async';
// import 'package:flutter/material.dart';
// class NextScreen extends StatefulWidget {
//   final VoidCallback onContinue;
//
//   NextScreen({required this.onContinue});
//
//   @override
//   State<NextScreen> createState() => _NextScreenState();
// }
//
// class _NextScreenState extends State<NextScreen> {
//   int countdown = 3;
//   @override
//   void initState() {
//     super.initState();
//     startCountdown();
//   }
//   void startCountdown() {
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       if (countdown == 1) {
//         timer.cancel();
//         Navigator.pop(context);
//         widget.onContinue();
//       } else {
//         setState(() {
//           countdown--;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             stops: [0.06, 1.0],
//             colors: [
//               Color(0xFF795DEA),
//               Color(0xFFBA63F5),
//             ],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,  // Align the top texts to start
//           children: [
//             // First Text: "Next" at the top of the page
//             Padding(
//               padding: EdgeInsets.only(top: 60.0), // Add padding to move it down slightly
//               child: Text(
//                 "Next",
//                 style: TextStyle(
//                   fontSize: 24,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//
//             // Second Text: "Tense and relax quickly"
//             Text(
//               "Tense and relax quickly",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white70,
//               ),
//             ),
//             SizedBox(height: 30),
//
//             // Expanded widget to center the countdown text
//             Expanded(
//               child: Center(
//                 child: Text(
//                   "$countdown",  // Use the variable for countdown
//                   style: TextStyle(
//                     fontSize: 80,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class NextScreen extends StatefulWidget {
  final bool isAudio;
  final VoidCallback onContinue;

  NextScreen({required this.isAudio, required this.onContinue});

  @override
  _NextScreenState createState() => _NextScreenState();
}
class _NextScreenState extends State<NextScreen>
    with SingleTickerProviderStateMixin {
  int countdown = 3;
  bool showCounter = false;
  bool showNextText = false;
  bool showTenseText = false;
  bool isPlayingAudio = false;
  final AudioPlayer _introAudioPlayer = AudioPlayer();
  final AudioPlayer _countdownAudioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Reduced animation duration
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
        .animate(_animationController);

    // Show "Next" after 1 second
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        showNextText = true;
      });
    });

    // Show "Tense and relax quickly" after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showTenseText = true;
      });
    });

    if (widget.isAudio) {
      playIntroAudio();
    } else {
      // Start countdown immediately if audio is disabled
      startCountdown();
    }
  }

  Future<void> playIntroAudio() async {
    try {
      await _introAudioPlayer.setAsset('assets/kegel/audio/nextQuickly.mp3');
      await _introAudioPlayer.play();

      // Wait for the audio to complete
      await _introAudioPlayer.processingStateStream.firstWhere(
              (state) => state == ProcessingState.completed
      );

      startCountdown();
    } catch (e) {
      // print("Error playing intro audio: $e");
      startCountdown();
    }
  }

  void startCountdown() async {
    while (countdown > 0) {
      if (widget.isAudio) {
        await playCountdownAudio(countdown);
      }

      setState(() {
        showCounter = true;
      });
      _animationController.forward(from: 0.0);

      await Future.delayed(Duration(milliseconds: 600)); // Reduced delay

      setState(() {
        showCounter = false;
        countdown--;
      });

      await Future.delayed(Duration(milliseconds: 10)); // Reduced delay
    }

    Navigator.pop(context);
    widget.onContinue();
  }

  Future<void> playCountdownAudio(int number) async {
    if (isPlayingAudio) return;
    isPlayingAudio = true;
    String audioFile = 'assets/kegel/audio/$number.mp3';

    try {
      await _countdownAudioPlayer.setAsset(audioFile);
      await _countdownAudioPlayer.play();
      await _countdownAudioPlayer.processingStateStream.firstWhere(
              (state) => state == ProcessingState.completed);
    } catch (e) {
      // print("Error playing countdown audio ($audioFile): $e");
    } finally {
      isPlayingAudio = false;
    }
  }

  @override
  void dispose() {
    _introAudioPlayer.dispose();
    _countdownAudioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.06, 1.0],
            colors: [Color(0xFF795DEA), Color(0xFFBA63F5)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: AnimatedOpacity(
                opacity: showNextText ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            AnimatedOpacity(
              opacity: showTenseText ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Text(
                "Tense and relax quickly",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: showCounter ? _slideAnimation : Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0)).animate(_animationController),
                      child: Opacity(
                        opacity: showCounter ? _fadeAnimation.value : 0,
                        child: Text(
                          showCounter ? "$countdown" : "",
                          style: TextStyle(
                            fontSize: 80,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}