
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'category_grid.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final String folderName;
  final Widget targetPage;

  const CategorySection({required this.title, required this.folderName, required this.targetPage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetPage),
                  );
                },
                child: Icon(Icons.arrow_forward_ios, size: 20),
              ),
            ],
          ),
          CategoryGrid(folderName: folderName, itemCount:4),
        ],
      ),
    );
  }
}
