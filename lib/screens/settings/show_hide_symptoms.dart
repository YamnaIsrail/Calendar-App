import 'package:calender_app/screens/flow2/detail%20page/cycle/cycle_page_components/category_grid.dart';
import 'package:calender_app/screens/settings/item.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';


class MoodSymptomScreen extends StatefulWidget {
  final String folderName;

  MoodSymptomScreen({required this.folderName});

  @override
  _MoodSymptomScreenState createState() => _MoodSymptomScreenState();
}

class _MoodSymptomScreenState extends State<MoodSymptomScreen> {
  late Future<List<CategoryItem>> _items;

  @override
  void initState() {
    super.initState();
    _items = loadCategoryItems(widget.folderName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName == 'moods' ? 'Moods' : 'Symptoms'),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<List<CategoryItem>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found'));
          }
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Image.asset(item.iconPath, width: 40, height: 40),
                title: Text(item.label),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // Update the toggle state here
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
