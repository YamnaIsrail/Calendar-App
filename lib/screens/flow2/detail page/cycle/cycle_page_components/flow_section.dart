import 'package:flutter/material.dart';

class FlowSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(
            Icons.water_drop,
            color: Colors.pink[300],
          ),
        );
      }),
    );
  }
}
