import 'package:flutter/material.dart';

class Wheel extends StatefulWidget {
  final List<String> items; // List of items to display
  final String? label; // Optional label for the wheel
  final Color selectedColor; // Color for the selected item
  final Color unselectedColor; // Color for the unselected items
  final ValueChanged<int> onSelectedItemChanged; // Callback for item change

  // Constructor with optional label and colors
  const Wheel({
    Key? key,
    required this.items,
    this.label,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onSelectedItemChanged,
  }) : super(key: key);

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  int selectedIndex = 0; // Track the currently selected index

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50, // Height of each item, as specified
        perspective: 0.005, // Creates a subtle 3D effect
        diameterRatio: 1.2, // Controls the curvature of the wheel
        physics: const FixedExtentScrollPhysics(), // Ensures it "snaps" to items
        onSelectedItemChanged: (index) {
          setState(() {
            selectedIndex = index; // Update selected index
            widget.onSelectedItemChanged(index); // Call the provided callback
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final item = widget.items[index];
            return Center(
              child: Text(
                item,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: index == selectedIndex ? widget.selectedColor : widget.unselectedColor, // Set color based on selection
                ),
              ),
            );
          },
          childCount: widget.items.length,
        ),
      ),
    );
  }
}
