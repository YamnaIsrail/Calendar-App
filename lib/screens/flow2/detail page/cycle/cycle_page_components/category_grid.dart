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


class CategoryGrid extends StatefulWidget {
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
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  List<CategoryItem> categoryItems = [];

  @override
  void initState() {
    super.initState();
    _loadCategoryItems();
  }

  Future<void> _loadCategoryItems() async {
    final items = await loadCategoryItems(widget.folderName);
    setState(() {
      categoryItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return categoryItems.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.itemCount ?? categoryItems.length, // Use itemCount if provided
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final item = categoryItems[index];
        final isSelectedItem = widget.isSelected?.call(item.label) ?? false;

        return GestureDetector(
          onTap: () {
            widget.onItemSelected?.call(item.iconPath, item.label);
            setState(() {
              // Update the UI locally by marking the selected mood
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isSelectedItem)
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.withOpacity(0.2),
                    ),
                  item.iconPath.endsWith('.svg')
                      ? SvgPicture.asset(item.iconPath, height: 40, width: 40)
                      : Image.asset(item.iconPath, height: 40, width: 40),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelectedItem ? Colors.blue : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
