import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'progress_circle.dart';

class Resty extends StatefulWidget {
  final bool isAudio;
  final VoidCallback onContinue;

  Resty({required this.isAudio, required this.onContinue});

  @override
  _RestyState createState() => _RestyState();
}
class _RestyState extends State<Resty>
    with SingleTickerProviderStateMixin {
  int countdown = 20;
  int initCount = 20;
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
      await _introAudioPlayer.setAsset('assets/kegel/audio/takeARest.mp3');
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
      if (widget.isAudio && (countdown == 3 || countdown == 2 || countdown == 1)) {
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
    int totalRestTime = initCount; // Total rest time
    int timeSpentInRest = (totalRestTime - countdown).toInt(); // Time spent in rest
    double progress = timeSpentInRest / totalRestTime; // Calculate progress

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.06, 1.0],
            colors: [Color(0xff2B0B4D),
              Color(0xff141575)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: AnimatedOpacity(
                opacity: showNextText ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Text(
                  "Take a Rest",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(220.0, 220.0),
                  painter: CircleProgressPainter(progress: progress),
                ),
                Container(
                  width: 2 * 110.0,
                  height: 2 * 110.0,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    child: Text(
                      "$countdown",
                      style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (countdown <= 5)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        initCount += 20;
                        countdown += 20;
                      });
                    },
                    child: Text("+20s"),
                  ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onContinue();
                  },
                  child: Text("SKIP"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}