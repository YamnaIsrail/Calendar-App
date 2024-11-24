import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../provider/moods_symptoms_provider.dart';
import 'cycle_page_components/category_grid.dart';

class Symptoms extends StatelessWidget {
  const Symptoms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recentSymptoms = context.watch<SymptomsProvider>().recentSymptoms;

    return Scaffold(
      appBar: AppBar(title: Text('Symptoms')),
      body: Column(
        children: [
          // Recent symptoms section
          if (recentSymptoms.isNotEmpty)
            Container(
              height: 80,
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentSymptoms.length,
                itemBuilder: (context, index) {
                  final item = recentSymptoms[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(item['iconPath']!, height: 30, width: 30),
                        Text(item['label']!, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
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
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, String folderName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        CategoryGrid(
          folderName: folderName,
          onItemSelected: (iconPath, label) {
            context.read<SymptomsProvider>().addSymptom(iconPath, label);
          },
          isSelected: (label) => context.watch<SymptomsProvider>().isSelected(label),
        ),
      ],
    );
  }
}
