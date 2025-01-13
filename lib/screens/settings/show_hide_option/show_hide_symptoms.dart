import 'package:calender_app/provider/moods_symptoms_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/cycle_page_components/category_grid.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ShowHideSymptomScreen extends StatefulWidget {
  const ShowHideSymptomScreen({Key? key}) : super(key: key);

  @override
  _ShowHideSymptomScreenState createState() => _ShowHideSymptomScreenState();
}

class _ShowHideSymptomScreenState extends State<ShowHideSymptomScreen> {
  late Future<List<CategoryItem>> _symptomList;

  @override
  void initState() {
    super.initState();
    _symptomList = _loadAllSymptoms();

  }

  Future<List<CategoryItem>> _loadAllSymptoms() async {
    // List of folders containing symptoms
    const symptomFolders = ['head', 'body', 'cervix', 'fluid', 'abdomen', 'mental'];

    // Load items from each folder and combine them into one list
    List<CategoryItem> allSymptoms = [];
    for (String folder in symptomFolders) {
      final symptoms = await loadCategoryItems(folder); // Load items dynamically from each folder
      allSymptoms.addAll(symptoms); // Combine symptoms from all folders
    }
    return allSymptoms;
  }

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Symptoms",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          ),
          actions: [
            Icon(Icons.check_box, color: primaryColor),
          ],
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
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
    if (symptomsProvider.visibleSymptoms.isEmpty) {
    symptomsProvider.initializeVisibleSymptoms(symptoms.map((symptom) => symptom.label).toList());
    }

            return ListView.builder(
              itemCount: symptoms.length,
              itemBuilder: (context, index) {
                final symptom = symptoms[index];
                final isSwitched = symptomsProvider.isSymptomVisible(symptom.label);

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.white,
                  child: ListTile(
                    leading: symptom.iconPath.endsWith('.svg')
                        ? SvgPicture.asset(symptom.iconPath, height: 30, width: 30)
                        : Image.asset(symptom.iconPath, height: 30, width: 30),
                    title: Text(symptom.label),
                    trailing: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        if (value) {
                          symptomsProvider.addVisibleSymptom(symptom.label);
                        } else {
                          symptomsProvider.removeVisibleSymptom(symptom.label);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
