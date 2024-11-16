import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CategoryItem {
  final String iconPath;
  final String label;

  CategoryItem({required this.iconPath, required this.label});
}

Future<List<CategoryItem>> loadCategoryItems(String folderName) async {
  final List<CategoryItem> categoryItems = [];
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestJson);

  // Filter paths to load images in the specified folder (supporting SVG and PNG formats)
  final iconPaths = manifestMap.keys
      .where((path) => path.contains('assets/$folderName/') && (path.endsWith('.svg') || path.endsWith('.png')))
      .toList();

  for (var path in iconPaths) {
    final label = path.split('/').last.split('.').first;
    categoryItems.add(CategoryItem(iconPath: path, label: label));
  }

  return categoryItems;
}

class CategoryGrid extends StatelessWidget {
  final String folderName;
  final int? itemCount;

  final bool isLabel; // New optional parameter

  const CategoryGrid({
    required this.folderName,
    this.itemCount,
    this.isLabel = true, // Default value is true
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryItem>>(
      future: loadCategoryItems(folderName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var categoryItems = snapshot.data ?? [];

        // Limit the list to `itemCount` if it's provided
        if (itemCount != null && itemCount! < categoryItems.length) {
          categoryItems = categoryItems.sublist(0, itemCount!);
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: categoryItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 items per row
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final item = categoryItems[index];
            return Column(
              children: [
                item.iconPath.endsWith('.svg')
                    ? SvgPicture.asset(item.iconPath,height: 30, width: 30, fit: BoxFit.contain)
                    : Image.asset(item.iconPath, height: 30, width: 30, fit: BoxFit.contain),
                 if (isLabel)

                  Text(
                    item.label,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
            );
          },
        );
      },
    );
  }
}
