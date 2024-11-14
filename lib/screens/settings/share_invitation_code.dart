import 'package:flutter/material.dart';
class ShareCodeScreen extends StatelessWidget {
  final String code = "VKjMd9"; // Example code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Share your invitation code',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              code,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("The code is valid for 24 hours."),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Share my code"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

