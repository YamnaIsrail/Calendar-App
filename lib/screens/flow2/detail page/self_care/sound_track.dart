import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Sound extends StatefulWidget {
  final String audioPath;
  final String title;

  Sound({required this.audioPath, required this.title});

  @override
  _SoundState createState() => _SoundState();
}

class _SoundState extends State<Sound> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLooping = false;
  double _sliderValue = 0.0;
  double _maxSliderValue = 1.0;
  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    await _audioPlayer.setAsset(widget.audioPath);

    // Update max slider value once the audio duration is loaded
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _maxSliderValue = duration.inSeconds.toDouble();
        });
      }
    });

    // Listen to position stream to update the slider in real-time
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _sliderValue = position.inSeconds.toDouble();
      });
    });
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
     _audioPlayer.pause();
    } else {
       _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // Show dialog to select timer duration
  void _showTimerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Timer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('5 minutes'),
                onTap: () => _startTimer(5),
              ),
              ListTile(
                title: Text('10 minutes'),
                onTap: () => _startTimer(10),
              ),
              ListTile(
                title: Text('15 minutes'),
                onTap: () => _startTimer(15),
              ),
            ],
          ),
        );
      },
    );
  }

  // Start looping the audio for the selected duration
  void _startTimer(int minutes) {
    Navigator.of(context).pop(); // Close the dialog
    setState(() {
      _isLooping = true;
    });

    // Start playing the audio in a loop
    _audioPlayer.setLoopMode(LoopMode.one); // Set audio to loop
    _audioPlayer.play();

    // Stop the audio after the specified time
    Future.delayed(Duration(minutes: minutes), () async {
      await _audioPlayer.pause(); // Stop the audio after the timer ends
      setState(() {
        _isPlaying = false;
        _isLooping = false;
      });

      // Show a snackbar to indicate the timer has ended
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio stopped after $minutes minutes')),
      );
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/self_care/sound.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Spacer(),
            Slider(
              value: _sliderValue,
              max: _maxSliderValue,
              onChanged: (value) async {
                await _audioPlayer.seek(Duration(seconds: value.toInt()));
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.pinkAccent,
                  ),
                  iconSize: 64,
                  onPressed: _togglePlayPause,
                ),
                // Timer button to show the timer options
                IconButton(
                  icon: Icon(
                    Icons.timer,
                    color: Colors.pinkAccent,
                  ),
                  iconSize: 64,
                  onPressed: _showTimerDialog,
                ),
              ],
            ),
            if (_isLooping)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Audio is looping for your timer...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
