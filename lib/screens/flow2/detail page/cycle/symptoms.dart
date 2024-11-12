import 'package:flutter/material.dart';

import '../cycle_page_components/category_grid.dart';
import '../cycle_page_components/category_selection.dart';

class symptoms extends StatelessWidget {
  const symptoms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Symptoms')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            CategoryGrid(folderName: 'head',),
            CategoryGrid(folderName: 'body',),
            CategoryGrid(folderName: 'cervix',),
            CategoryGrid(folderName: 'fluid',),
            CategoryGrid(folderName: 'head',),


          ],
        ),
      ),
    );
  }
}
