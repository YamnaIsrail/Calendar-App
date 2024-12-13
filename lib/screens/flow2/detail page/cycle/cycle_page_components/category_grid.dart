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
   final Function(String, String)? onItemSelected;
  final bool Function(String)? isSelected;

  const CategoryGrid({
    required this.folderName,
    this.itemCount,
    this.onItemSelected,
    this.isSelected,
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

        if (itemCount != null && itemCount! < categoryItems.length) {
          categoryItems = categoryItems.sublist(0, itemCount!);
        }

        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categoryItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final item = categoryItems[index];
            final isSelectedItem = isSelected?.call(item.label) ?? false;

            return GestureDetector(
              onTap: () => onItemSelected?.call(item.iconPath, item.label),
              child: Container(
                 decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isSelectedItem
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensure it only takes the necessary space
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    item.iconPath.endsWith('.svg')
                        ? SvgPicture.asset(item.iconPath, height: 30, width: 30)
                        : Image.asset(item.iconPath, height: 30, width: 30),
                      Text(
                        item.label,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                  ],
                )
              ),
            );
          },
        );
      },
    );
  }
}
