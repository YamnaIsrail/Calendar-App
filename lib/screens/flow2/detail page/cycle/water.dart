import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        elevation: 0,
        title: Text('Settings', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notifications', style: TextStyle(fontSize: 20)),
                Switch(value: true, onChanged: (bool value) {}),
              ],
            ),
            SizedBox(height: 20),
            Text('Cup capacity unit', style: TextStyle(fontSize: 20)),
            TextField(
              decoration: InputDecoration(
                hintText: 'ml',
              ),
            ),
            SizedBox(height: 20),
            Text('Target', style: TextStyle(fontSize: 20)),
            TextField(
              decoration: InputDecoration(
                hintText: '3000 ml',
              ),
            ),
            SizedBox(height: 20),
            Text('Cup capacity', style: TextStyle(fontSize: 20)),
            TextField(
              decoration: InputDecoration(
                hintText: '450 ml',
              ),
            ),
            SizedBox(height: 20),
            Text('Cup Size', style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.local_drink, color: Colors.blue),
                Icon(Icons.local_drink, color: Colors.blueAccent),
                Icon(Icons.local_drink, color: Colors.blue.shade700),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
