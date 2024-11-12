import 'package:flutter/material.dart';

class MyCyclesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        elevation: 0,
        title: Text('Cycles', style: TextStyle(color: Colors.black)),
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
            Text(
              'My Cycles',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text('+ Add Period'),
            ),
            SizedBox(height: 20),
            Text('History', style: TextStyle(fontSize: 20)),
            Row(
              children: [
                FilterChip(label: Text('All'), onSelected: (_) {}),
                SizedBox(width: 8),
                FilterChip(label: Text('Period'), onSelected: (_) {}),
                SizedBox(width: 8),
                FilterChip(label: Text('Ovulation'), onSelected: (_) {}),
                SizedBox(width: 8),
                FilterChip(label: Text('Fertile'), onSelected: (_) {}),
              ],
            ),
            SizedBox(height: 20),
            // Add your Timeline or History here
          ],
        ),
      ),
    );
  }
}
