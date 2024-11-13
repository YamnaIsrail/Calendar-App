import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class sound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // light pink background
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            // Visualizer (SVG Image)
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/self_care/sound.png', // Path to your SVG file
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Playback controls
            Column(
              children: [
                // Progress bar
                Slider(
                  value: 0.4, // Example value
                  onChanged: (value) {},
                  activeColor: Colors.orange,
                  inactiveColor: Colors.orange[200],
                ),
                // Time display
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "4:30",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Play/Pause and Forward buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous),
                      color: Colors.pinkAccent,
                      iconSize: 36,
                      onPressed: () {},
                    ),
                    SizedBox(width: 20),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.pinkAccent,
                      child: IconButton(
                        icon: Icon(Icons.pause, color: Colors.white),
                        iconSize: 36,
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: Icon(Icons.skip_next),
                      color: Colors.pinkAccent,
                      iconSize: 36,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
