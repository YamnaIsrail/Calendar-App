import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import '../kegel_questionaire_flow/kegel_screen1.dart';
import 'congrats.dart';
import 'day_intro.dart';
import 'kegelDaysUnlocked_hive.dart';
import 'next.dart';
import 'resty.dart';

class BreathingApp extends StatefulWidget {
  final int totalDurationMinutes; // Accept total duration in minutes
  final int day; // Accept day
  final int totalCount;

  bool isAudio;
  bool vibrate;

  BreathingApp(
      {Key? key,
      required this.totalDurationMinutes,
      required this.totalCount,
      required this.isAudio,
      required this.vibrate,
      required this.day})
      : super(key: key);

  @override
  _BreathingAppState createState() => _BreathingAppState();
}

class _BreathingAppState extends State<BreathingApp>
    with SingleTickerProviderStateMixin {
  bool _hasShownRestScreen = false;
  int _counter = 3;
  int _initTenseCounter = 3;
  int _initRelaxCounter = 3;
  int totalCountsInSection1 = 0;

  int _initcounter = 3;
  Timer? _timer;
  String _state = "tense";
  int initialRestTime = 5;
  bool _isPaused = false;
  int _elapsedTime = 0; // To track the total elapsed time
  int totalDuration = 0; // Total duration in seconds
  int totalStates = 0; // Total number of states (tense + relax)
  int currentState = 0; // Current state index
  int currentSection = 1; // Current section (1 to 4)
  List<int> sectionStates = []; // States for each section
  bool _isCompleted = false; // Flag to check if the timer has completed
  // Boolean to enable/disable audio
  bool _isInitialCountdown = true; // Track if the initial countdown is active

  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Audio player for state changes

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 136, end: 292).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    totalDuration = widget.totalDurationMinutes * 60;
    _calculateTotalStates();
    _initializeCounters(); // Initialize counters based on duration
    _counter = _initTenseCounter;
    _startInitialCountdown(); // Start the initial countdown
  }
  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }
  void _resumeCurrentState() {
    setState(() {
      // Reset the counter based on the current section
      _counter = (currentSection == 1)
          ? 3
          : 1; // Adjust countdown for the current section
      _state = "tense"; // Reset to "tense" state
    });
    _startCountdown(); // Restart the countdown
  }

  void _startInitialCountdown() async {
    for (int i = 3; i > 0; i--) {
      setState(() {
        _initcounter = i; // Update the counter
      });
      if (widget.isAudio) {
        await _playAudio(
            'assets/kegel/audio/$i.mp3'); // Play sound for the current number
      }
      await Future.delayed(Duration(
          milliseconds: 800)); // Wait for 800ms (animation duration + delay)
    }

    // After the countdown is complete
    setState(() {
      _isInitialCountdown = false; // End the initial countdown
      _state = "tense"; // Set the initial state to "tense"
      _counter = _initTenseCounter; // Set the counter for tense state
    });

    // Play audio for the tense state when the countdown is finished
    if (widget.isAudio) {
      await _playAudio('assets/kegel/audio/tense.mp3');
    }
    if (widget.vibrate) {
      Vibration.vibrate(duration: 500);

    }

    _startCountdown(); // Start the main countdown after the initial countdown
  }

  void _nextState() async {
    if (!mounted) return; // Check if the widget is still mounted

    setState(() {
      if (currentState >= totalStates && !_isCompleted) {
        _isCompleted = true;
        _navigateToCongratsScreen();
        return;
      }

      if (_state == "tense") {
        _state = "relax";
        _counter = currentSection == 1 ? _initRelaxCounter : 1;
        _controller.forward();
        if (widget.isAudio && currentSection == 1) {
          _playAudio('assets/kegel/audio/relax.mp3');
        }
        // Trigger vibration for section 1 state change
        if (currentSection == 1 && widget.vibrate) {
          Vibration.vibrate(duration: 500);

        }
      } else {
        _state = "tense";
        _counter = currentSection == 1 ? _initTenseCounter : 1;
        _controller.reverse();
        if (widget.isAudio && currentSection == 1) {
          _playAudio('assets/kegel/audio/tense.mp3');
        }
        if (currentSection == 1 && widget.vibrate) {
          Vibration.vibrate(duration: 500);

        }
        currentState++;
      }

      _elapsedTime += _counter;

      // Show rest screen if halfway through
      if (currentState >= totalStates ~/ 2 && !_hasShownRestScreen) {
        _hasShownRestScreen = true;
        _navigateToRestScreen();
        return; // Exit early
      }

      // Show "Next Screen" at the start of every section except the first one
      if (currentState >=
          sectionStates.sublist(0, currentSection).reduce((a, b) => a + b)) {
        currentSection++;
        if (currentSection > 1) {
          _showNextScreen();
        }
      }
    });

    _startCountdown();
  }

  void _navigateToRestScreen() {
    setState(() {
      _isPaused = true; // Ensure it is always paused before navigating
    });

    if (widget.vibrate) {
      Vibration.vibrate(duration: 500);

    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Resty(
          onContinue: () {
            _resumeCurrentState(); // Resume from the current state
          },
          isAudio: widget.isAudio,
        ),
      ),
    ).then((_) {
      setState(() {
        _isPaused = false; // Ensure it is unpaused after returning
      });
      _resumeCurrentState(); // Resume from the current state
    });
  }

  void _showNextScreen() {
    setState(() {
      _isPaused = true; // Ensure it is always paused before navigating
    });
    if (widget.vibrate) {
      Vibration.vibrate(duration: 500);

    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NextScreen(
          onContinue: () {
            _resumeCurrentState(); // Resume from the current state
          },
          isAudio: widget.isAudio,
        ),
      ),
    ).then((_) {
      setState(() {
        _isPaused = false; // Ensure it is unpaused after returning
      });
      _resumeCurrentState(); // Resume from the current state
    });
  }

  Future<void> _playAudio(String audioFile) async {
    try {
      await _audioPlayer.setAsset(audioFile);
      await _audioPlayer.play();
    } catch (e) {
      // print("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(" sec1 is $totalCountsInSection1");

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ExcerciseDayScreen(
                  day: widget.day,
                  totalcount: widget.totalCount,
                  duration: widget
                      .totalDurationMinutes)), // Replace with your desired screen
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.06, 1.0],
              colors: [Color(0xFF795DEA), Color(0xFFBA63F5)],
            ),
          ),
          child: Center(
            child: _isInitialCountdown
                ? _buildInitialCountdownUI() // Show initial countdown UI
                : _buildTenseRelaxUI(), // Show main UI
          ),
        ),
      ),
    );
  }

  Widget _buildTenseRelaxUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              _buildProgressBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "${totalStates - currentState} / $totalStates  ", // Display current state and total states
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
                    icon: Icon(
                      widget.isAudio ? Icons.volume_down : Icons.volume_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.isAudio = !widget.isAudio; // Toggle state
                      });
                    },
                  ),
                  Transform.rotate(
                    angle: -0.4,
                    child: IconButton(
                      icon: Icon(
                        widget.vibrate ? Icons.vibration : Icons.smartphone,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.vibrate = !widget.vibrate; // Toggle state
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
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: _animation.value + 5, // Animated width
                height: _animation.value * (309 / 292), // Keep aspect ratio
                decoration: BoxDecoration(
                  color: Colors.white54,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _state.toUpperCase(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (currentSection ==
                          1) // Show counter only for section 1
                        SizedBox(height: 10),
                      if (currentSection == 1)
                        Text(
                          "$_counter",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Show back button only if not in the first section
            SizedBox(
              width: 48,
              child: currentSection > 1
                  ? IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded),
                      color: Colors.white,
                      onPressed: () {
                        _skipState(
                            false);
                      },
                    )
                  : null,
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white54,
              ),
              child: IconButton(
                icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                color: Colors.white,
                onPressed: _togglePlayPause,
              ),
            ),
            SizedBox(
              width: 48,
              child: currentSection < sectionStates.length
                  ? IconButton(
                      icon: Icon(Icons.arrow_forward_ios_rounded),
                      color: Colors.white,
                      onPressed: () => _skipState(true),
                    )
                  : null,
            ),
          ],
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildInitialCountdownUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Slide transition from top to bottom
            final slideAnimation = Tween<Offset>(
              begin: Offset(0, -1), // Start from the top
              end: Offset(0, 0), // End at the center
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut, // Smooth easing
            ));

            // Fade transition
            return FadeTransition(
              opacity: animation, // Fading effect
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
          child: Text(
            "$_initcounter",
            key: ValueKey<int>(_initcounter), // Unique key for each number
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _skipState(bool isForward) async {
    await _audioPlayer.stop();

    _showNextScreen(); // Show next screen before updating state

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        if (isForward) {
          if (currentSection < sectionStates.length) {
            currentSection++; // Move to next section
            currentState = sectionStates
                .take(currentSection - 1)
                .fold(0, (a, b) => a + b); // Start of next section
          } else {
            _navigateToCongratsScreen();
            return;
          }
        } else {
          if (currentSection > 1) {
            setState(() {
              _isPaused = true; // Ensure it is always paused before navigating
            });
            currentSection--; // Move to previous section
            currentState =
                sectionStates.take(currentSection - 1).fold(0, (a, b) => a + b);
            // setState(() {
            //   _isPaused = false; // Ensure it is unpaused after returning
            // });
          }
        }
      });

      _startCountdown();
    });
  }

  //static

  Widget _buildProgressBar() {
    double screenWidth = MediaQuery.of(context).size.width * 0.7;

    return Padding(
      padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            // Background Bar (Grey)
            Container(
              height: 8,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Progress Bar with Gaps
            Row(
              children: List.generate(sectionStates.length * 2 - 1, (index) {
                bool isGap = index.isOdd;
                int sectionIndex = index ~/ 2;

                if (isGap) {
                  return Container(
                    height: 8,
                    width: 4,
                    color: Color(0xFF795DEA),
                  );
                } else {
                  int startState = sectionStates
                      .sublist(0, sectionIndex)
                      .fold(0, (a, b) => a + b);
                  int endState = startState + sectionStates[sectionIndex];

                  double sectionWidth;
                  if (sectionIndex == 0) {
                    // First section takes half of the total width
                    sectionWidth = screenWidth * 0.5;
                  } else {
                    // Remaining sections share the other half equally
                    sectionWidth =
                        screenWidth * 0.5 / 3; // Divide the remaining half by 3
                  }

                  double sectionProgress = (currentState - startState)
                          .clamp(0, sectionStates[sectionIndex]) /
                      sectionStates[sectionIndex];

                  double completedWidth = sectionWidth * sectionProgress;
                  double remainingWidth = sectionWidth * (1 - sectionProgress);

                  return Row(
                    children: [
                      Container(
                        height: 8,
                        width: completedWidth,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: remainingWidth,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateTotalStates() {
    int sectionSize = widget.totalCount ~/ 4; // Base size for each section
    int remainder = widget.totalCount % 4; // Remaining states after division

    // Assign remainder to the first section
    int firstSectionSize = sectionSize + remainder;

    // Randomize the first section’s distribution between tense and relax
    int randomTenseCount = firstSectionSize ~/ 2;
    int randomRelaxCount = firstSectionSize - randomTenseCount;

    totalCountsInSection1 = (randomTenseCount * _initTenseCounter) +
        (randomRelaxCount * _initRelaxCounter);
    // print(" sec1 is $totalCountsInSection1");

    // Set states for the first section
    sectionStates.add(randomTenseCount + randomRelaxCount);

    // Assign equal states to the remaining 3 sections
    for (int i = 0; i < 3; i++) {
      sectionStates.add(sectionSize);
    }

    // Ensure totalStates reflects the sum of all sections
    totalStates = sectionStates.reduce((a, b) => a + b);
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        if (_counter > 1) {
          setState(() {
            _counter--;
            _elapsedTime++;
          });
        } else {
          _nextState();
        }
      }

      // Check if the total duration is completed
      // if (_elapsedTime >= totalDuration && !_isCompleted) {
      //   _isCompleted = true;
      //   _timer?.cancel();
      //   _navigateToCongratsScreen(); // Navigate to the new screen when time is up
      // }
    });
  }

  Future<void> _navigateToCongratsScreen() async {
    await KegelStorage.init(); // Reinitialize if needed

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CongratsScreen(
          day: widget.day,
        totalcount: widget.totalCount,

      )),
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _initializeCounters() {
    // Initialize counters based on totalDurationMinutes
    switch (widget.totalDurationMinutes) {
      case 3:
        _initTenseCounter = 3; // Tense counts for 3 minutes
        _initRelaxCounter = 3; // Relax counts for 3 minutes
        break;
      case 4:
        _initTenseCounter = 6; // Tense counts for 4 minutes
        _initRelaxCounter = 4; // Relax counts for 4 minutes
        break;
      case 5:
        _initTenseCounter = 8; // Tense counts for 5 minutes
        _initRelaxCounter = 4; // Relax counts for 5 minutes
        break;
      case 6:
        _initTenseCounter = 10; // Tense counts for 6 minutes
        _initRelaxCounter = 5; // Relax counts for 6 minutes
        break;
      case 7:
        _initTenseCounter = 12; // Tense counts for 7 minutes
        _initRelaxCounter = 5; // Relax counts for 7 minutes
        break;
      default:
        _initTenseCounter = 1; // Default case
        _initRelaxCounter = 1; // Default case
        break;
    }
  }
}
