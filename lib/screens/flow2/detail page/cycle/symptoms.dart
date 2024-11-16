import 'package:flutter/material.dart';

import 'cycle_page_components/category_grid.dart';
class symptoms extends StatelessWidget {
  const symptoms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(title: Text('Symptoms')),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true, // Keeps the scrollbar thumb visible
        thickness: 8.0, // Adjust the thickness of the scrollbar
        radius: Radius.circular(8), // Make the scrollbar rounded
        child: SingleChildScrollView(
          controller: _scrollController, // Link the ScrollController
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Head",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CategoryGrid(folderName: 'head'),

              Text(
                "Body",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CategoryGrid(folderName: 'body'),

              Text(
                "Cervix",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CategoryGrid(folderName: 'cervix'),

              Text(
                "Fluid",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CategoryGrid(folderName: 'fluid'),

              Text(
                "Abdomen",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CategoryGrid(folderName: 'abdomen'),

              Text(
                "Mental",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CategoryGrid(folderName: 'mental'),
            ],
          ),
        ),
      ),
    );
  }
}


