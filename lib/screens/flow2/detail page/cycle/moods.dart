import 'package:calender_app/provider/moods_symptoms_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'cycle_page_components/category_grid.dart';

class Moods extends StatelessWidget {
  const Moods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recentMoods = context.watch<MoodsProvider>().recentMoods;

    return Scaffold(
      appBar: AppBar(title: Text('Moods')),
      body: Column(
        children: [
          // Recent moods section
          if (recentMoods.isNotEmpty)
            Container(
              height: 80,
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentMoods.length,
                itemBuilder: (context, index) {
                  final item = recentMoods[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(item['iconPath']!, height: 30, width: 30),
                        Text(item['label']!, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CategoryGrid(
                folderName: 'emoji',
                isLabel: false,
                onItemSelected: (iconPath, label) {
                  context.read<MoodsProvider>().addMood(iconPath, label);
                },
                isSelected: (label) => context.watch<MoodsProvider>().isSelected(label),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
