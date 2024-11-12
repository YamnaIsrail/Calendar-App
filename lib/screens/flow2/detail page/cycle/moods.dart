import 'package:flutter/material.dart';

import 'cycle_page_components/category_grid.dart';
class moods extends StatelessWidget {
  const moods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Moods')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CategoryGrid(folderName: 'emoji'), // Use the folder name for "Moods"
      ),
    );
  }
}

