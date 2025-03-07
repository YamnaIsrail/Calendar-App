import 'package:calender_app/firebase/analytics/analytics_service.dart';
import 'package:calender_app/provider/moods_symptoms_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/intercourse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'category_grid.dart';

import 'package:provider/provider.dart';
 List<String> symptomFolders = ['head', 'body', 'cervix', 'fluid', 'abdomen', 'mental'];

class CategorySection extends StatelessWidget {
  final String title;
  final String folderName;
  final Widget targetPage;

  const CategorySection({
    required this.title,
    required this.folderName,
    required this.targetPage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moodsProvider = Provider.of<MoodsProvider>(context);
    final symptomsProvider = Provider.of<SymptomsProvider>(context);

    // Check if visibleMoods or visibleSymptoms are empty, and initialize them
    if (title == "Moods" && moodsProvider.visibleMoods.isEmpty) {
      // Load emojis and initialize moods
      Future<List<CategoryItem>> _emojiList = loadCategoryItems('emoji');
      _emojiList.then((emojis) {
        moodsProvider.initializeVisibleMoods(emojis.map((emoji) => emoji.label).toList());
      });
    } else if (title == "Symptoms" && symptomsProvider.visibleSymptoms.isEmpty) {
      // Load symptoms and initialize symptoms
       symptomFolders = ['head', 'body', 'cervix', 'fluid', 'abdomen', 'mental'];

      Future<void> _loadAllSymptoms() async {
        List<CategoryItem> allSymptoms = [];
        for (String folder in symptomFolders) {
          final symptoms = await loadCategoryItems(folder); // Load items dynamically from each folder
          allSymptoms.addAll(symptoms);
        }
        symptomsProvider.initializeVisibleSymptoms(allSymptoms.map((symptom) => symptom.label).toList());
      }

      if (title == "Symptoms" && symptomsProvider.visibleSymptoms.isEmpty) {
        _loadAllSymptoms();
      }

    }

    return GestureDetector(
      onTap: () {
        AnalyticsService.logEvent("navigate_to_$targetPage", parameters: {
          "from_screen": "My Cycle",
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    AnalyticsService.logEvent("navigate_to_$targetPage", parameters: {
                      "from_screen": "My Cycle",
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => targetPage),
                    );
                  },
                  child: Icon(Icons.arrow_forward_ios, size: 20),
                ),
              ],
            ),
            CategoryGrid(
              folderName: title == "Symptoms" ? symptomFolders : folderName, // Use symptomFolders if title is "Symptoms"
              itemCount: 4,
              onItemSelected: (iconPath, label) {
                if (title == "Moods") {
                  moodsProvider.addMood(context, iconPath, label);
                } else if (title == "Symptoms") {
                  symptomsProvider.addSymptom(context, iconPath, label);
                } else if (title == "Intercourse") {
                  // Navigate to IntercourseScreen with selected data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntercourseScreen(),
                    ),
                  );
                }
              },
              isSelected: (label) {
                if (title == "Moods") {
                  return moodsProvider.isSelected(label);
                } else if (title == "Symptoms") {
                  return symptomsProvider.isSelected(label);
                }
                return false;
              },
              isVisible: (label) {
                if (title == "Moods") {
                  return moodsProvider.isMoodVisible(label); // Visibility logic for moods
                } else if (title == "Symptoms") {
                  return symptomsProvider.isSymptomVisible(label); // Visibility logic for symptoms
                }
                return true;
              },

            ),
          ],
        ),
      ),
    );
  }
}
