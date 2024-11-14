import 'package:flutter/material.dart';

class QuestionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  QuestionAppBar({
    required this.currentPage,
    required this.totalPages,
    required this.onBack,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,  
      appBar: AppBar(
        backgroundColor: Colors.transparent,  
        elevation: 0, // Remove shadow if needed
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text(
          '$currentPage/$totalPages',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
