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
  final dynamic folderName;  // Allow String or List<String>

  final int? itemCount;
  final Function(String, String)? onItemSelected;
  final bool Function(String)? isSelected;
  final bool Function(String)? isVisible; // New parameter for visibility check


  const CategoryGrid({
    required this.folderName,
    this.itemCount,
    this.onItemSelected,
    this.isSelected,
    this.isVisible, // Initialize the new parameter

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
    List<CategoryItem> allItems = [];
    if (widget.folderName is List<String>) {
      for (String folder in widget.folderName) {
        final items = await loadCategoryItems(folder);
        allItems.addAll(items);
      }
    } else {
      final items = await loadCategoryItems(widget.folderName);
      allItems.addAll(items);
    }
    setState(() {
      categoryItems = allItems.where((item) {
        return widget.isVisible?.call(item.label) ?? true;
      }).toList();
    });
  }

  // Future<void> _loadCategoryItems() async {
  //   final items = await loadCategoryItems(widget.folderName);
  //   setState(() {
  //     // Filter categoryItems based on isVisible if provided
  //     categoryItems = items.where((item) {
  //       return widget.isVisible?.call(item.label) ?? true;
  //     }).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return categoryItems.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.itemCount ?? categoryItems.length,
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
              },
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isSelectedItem)
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.blue.withOpacity(0.2),
                            ),
                          item.iconPath.endsWith('.svg')
                              ? SvgPicture.asset(item.iconPath, height: 40, width: 40)
                              : Image.asset(item.iconPath, height: 40, width: 40),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelectedItem ? Colors.blue : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              )

              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Stack(
              //       alignment: Alignment.center,
              //       children: [
              //         if (isSelectedItem)
              //           CircleAvatar(
              //             radius: 28,
              //             backgroundColor: Colors.blue.withOpacity(0.2),
              //           ),
              //         item.iconPath.endsWith('.svg')
              //             ? SvgPicture.asset(item.iconPath, height: 40, width: 40)
              //             : Image.asset(item.iconPath, height: 40, width: 40),
              //       ],
              //     ),
              //     const SizedBox(height: 2),
              //     Text(
              //       item.label,
              //       style: TextStyle(
              //         fontSize: 10,
              //         color: isSelectedItem ? Colors.blue : Colors.black,
              //       ),
              //       textAlign: TextAlign.center,
              //       overflow: TextOverflow.ellipsis,  // To handle long text
              //     ),
              //   ],
              // ),
              //
            );
          },
        );
  }
}


