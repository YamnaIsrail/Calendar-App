import 'package:calender_app/provider/moods_symptoms_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../firebase/analytics/analytics_service.dart';
import 'cycle_page_components/category_grid.dart';

class Moods extends StatefulWidget {
  const Moods({Key? key}) : super(key: key);

  @override
  State<Moods> createState() => _MoodsState();
}

class _MoodsState extends State<Moods> {
  late Future<List<CategoryItem>> _emojiList;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _emojiList = loadCategoryItems('emoji');
    _startTime = DateTime.now();  // Stores start time locally for THIS screen instance
    AnalyticsService.logScreenView("Moods Screen");
  }

  @override
  void dispose() {
    if (_startTime != null) {
      final duration = DateTime.now().difference(_startTime!).inSeconds;
      AnalyticsService.logScreenTime("Moods Screen", duration);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoodsProvider>(
      builder: (context, moodsProvider, child) {
        return FutureBuilder<List<CategoryItem>>(
          future: _emojiList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading spinner while waiting for the data
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              // Handle error case
              return Center(child: Text('Error loading emojis'));
            }

            final emojis = snapshot.data ?? [];
            if (moodsProvider.visibleMoods.isEmpty) {
              moodsProvider.initializeVisibleMoods(emojis.map((emoji) => emoji.label).toList());
            }
            final recentMoods = moodsProvider.recentMoods;

            return Scaffold(
              appBar: AppBar(title: Text('Moods')),
              body: Column(
                children: [
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
                        onItemSelected: (iconPath, label) {
                          if (Provider.of<MoodsProvider>(context, listen: false).isMoodVisible(label)) {
                            moodsProvider.addMood(context, iconPath, label);
                          }
                        },
                        isSelected: (label) => moodsProvider.isSelected(label),
                        isVisible: (label) => Provider.of<MoodsProvider>(context, listen: false).isMoodVisible(label),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
