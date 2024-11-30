import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final VoidCallback onBack;
  final VoidCallback onCancel;
  final String? userImageUrl;

  CustomAppBar({
    required this.pageTitle,
    required this.onBack,
    required this.onCancel,
    this.userImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set transparent to show the gradient
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
          // Check if userImageUrl is not null, then show the image; else show default icon
          userImageUrl != null
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,  // Adjust radius for size
              backgroundImage: NetworkImage(userImageUrl!),
            ),
          )
              : IconButton(
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
