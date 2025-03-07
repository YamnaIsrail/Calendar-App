import 'package:flutter/material.dart';

class NoteDetailPage extends StatelessWidget {
  final String note;

  NoteDetailPage({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            note,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}