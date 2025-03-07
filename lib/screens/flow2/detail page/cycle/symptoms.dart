import 'package:calender_app/firebase/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../provider/moods_symptoms_provider.dart';
import 'cycle_page_components/category_grid.dart';

class Symptoms extends StatefulWidget {
  const Symptoms({Key? key}) : super(key: key);

  @override
  _SymptomsState createState() => _SymptomsState();
}

class _SymptomsState extends State<Symptoms> {
  late Future<List<CategoryItem>> _symptomList;

  DateTime _startTime = DateTime.now(); // Track screen time start

  @override
  void initState() {
    super.initState();
    _symptomList = _loadAllSymptoms();
    _startTime = DateTime.now();
    AnalyticsService.logScreenView("Symptoms Screen");
    // Add this line in initState
  }

  // Load symptoms from multiple folders
  Future<List<CategoryItem>> _loadAllSymptoms() async {
    const symptomFolders = ['head', 'body', 'cervix', 'fluid', 'abdomen', 'mental'];

    List<CategoryItem> allSymptoms = [];
    for (String folder in symptomFolders) {
      final symptoms = await loadCategoryItems(folder);  // Load items dynamically from each folder
      allSymptoms.addAll(symptoms); // Combine symptoms from all folders
    }

    return allSymptoms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Symptoms')),
      body: FutureBuilder<List<CategoryItem>>(
        future: _symptomList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final symptoms = snapshot.data ?? [];
          final symptomsProvider = Provider.of<SymptomsProvider>(context);

          // Initialize visible symptoms if not already initialized
          if (symptomsProvider.visibleSymptoms.isEmpty) {
            symptomsProvider.initializeVisibleSymptoms(symptoms.map((symptom) => symptom.label).toList());
          }

          return Column(
            children: [
              // Recent symptoms section
              if (symptomsProvider.recentSymptoms.isNotEmpty)
                Container(
                  height: 80,
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey[200],
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: symptomsProvider.recentSymptoms.length,
                    itemBuilder: (context, index) {
                      final item = symptomsProvider.recentSymptoms[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(item['iconPath']!, height: 30, width: 30),
                            Text(item['label']!, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategory(context, "Head", "head"),
                      _buildCategory(context, "Body", "body"),
                      _buildCategory(context, "Cervix", "cervix"),
                      _buildCategory(context, "Fluid", "fluid"),
                      _buildCategory(context, "Abdomen", "abdomen"),
                      _buildCategory(context, "Mental", "mental"),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  @override
  void dispose() {
    int duration = DateTime.now().difference(_startTime).inSeconds;
    AnalyticsService.logScreenTime("Symptoms Screen", duration);
    super.dispose();
  }
  Widget _buildCategory(BuildContext context, String title, String folderName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        CategoryGrid(
          folderName: folderName,
          onItemSelected: (iconPath, label) {
            context.read<SymptomsProvider>().addSymptom(context, iconPath, label);
          },
          isSelected: (label) => context.watch<SymptomsProvider>().isSelected(label),
          isVisible: (label) =>
              context.read<SymptomsProvider>().isSymptomVisible(label), // Visibility logic added
        ),
      ],
    );
  }
}
