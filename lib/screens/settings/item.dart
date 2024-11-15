
import 'package:flutter/material.dart';

class CustomItem extends StatelessWidget {
  final String title;
  const CustomItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: ListTile(
        title: Text(title,
        style: TextStyle(
          fontSize: 16
        ),
        ),
        trailing: Switch(value: false, onChanged: (bool value) {}),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? caption;

  const SectionHeader({required this.title, this.caption, });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if(caption!=null) Text(
            caption!,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff1C1CAD)),
          )

        ],
      ),

    );
  }
}
