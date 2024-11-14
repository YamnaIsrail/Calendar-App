import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  CustomAppBar({
    required this.pageTitle,
    required this.onBack,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.transparent, // Set transparent to show the gradient
        elevation: 0, // Remove shadow if needed
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: onBack,
        ),
        title: Text(
          pageTitle,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
