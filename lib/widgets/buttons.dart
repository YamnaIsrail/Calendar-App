import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? textColor; // Optional text color parameter

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.textColor, // Allow passing a custom text color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: const Size(double.infinity, 50), // Full width with minimum height
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white, // Use provided textColor or default to white
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor; final Color? textColor; // Optional text color parameter

  const CustomButton2({
    Key? key,
    required this.text,
    this.textColor,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFCFDCFF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 50), // Full width with minimum height
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Color(0xFF301B86),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
