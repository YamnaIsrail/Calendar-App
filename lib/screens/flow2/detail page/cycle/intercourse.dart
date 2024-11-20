import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../analysis/intercourse_analysis.dart';
import 'cycle_section_dialogs.dart';


class IntercourseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IntercourseProvider>(context);

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Intercourse', style: TextStyle(color: Colors.black)),
          leading: CircleAvatar(
            backgroundColor: Color(0xffFFC4E8),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                IntercourseDialogs.showHideOptionDialog(
                  context,
                  Color(0xFFEB1D98),
                );
              },
              icon: Icon(Icons.remove_red_eye, color: Colors.black),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (provider.isSectionVisible('Condom Option')) _buildCondomOptions(provider),
                if (provider.isSectionVisible('Female Orgasm')) _buildFemaleOrgasmOptions(provider),
                if (provider.isSectionVisible('Times')) _buildTimesOptions(provider),
                Spacer(),
                _buildSaveAndAnalysisButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCondomOptions(IntercourseProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Condom Option', style: TextStyle(fontSize: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildOptionItem("Protected", "assets/intercourse/Condom.png", provider),
            _buildOptionItem("Unprotected", "assets/intercourse/candom2.png", provider),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFemaleOrgasmOptions(IntercourseProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Female Orgasm', style: TextStyle(fontSize: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildOptionItem("Not Happened", "assets/intercourse/Don't Have.png", provider),
            _buildOptionItem("Happened", "assets/intercourse/Orgasm.png", provider),
          ],
        ),
        Divider(height: 30),
      ],
    );
  }

  Widget _buildTimesOptions(IntercourseProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Times', style: TextStyle(fontSize: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: Icon(Icons.remove),
                onPressed: () {
                  provider.decrementTimes();
                  provider.updateActivityData({
                    'condomOption': provider.condomOption,
                    'femaleOrgasm': provider.femaleOrgasm,
                    'times': provider.times,
                  });
                }
            ),
            SizedBox(width: 50),
            Text(provider.times.toString(), style: TextStyle(fontSize: 24)),
            SizedBox(width: 50),
            IconButton(icon: Icon(Icons.add),
                onPressed: () {
                  provider.incrementTimes();
                  provider.updateActivityData({
                    'condomOption': provider.condomOption,
                    'femaleOrgasm': provider.femaleOrgasm,
                    'times': provider.times,
                  });
                }
            ),
          ],
        ),
        Divider(height: 30),
      ],
    );
  }

  Widget _buildOptionItem(String label, String image, IntercourseProvider provider) {
    bool isSelected = false;

    // Determine if the option is selected
    if (label == "Protected" || label == "Unprotected") {
      isSelected = provider.condomOption == label;
    } else if (label == "Not Happened" || label == "Happened") {
      isSelected = provider.femaleOrgasm == label;
    }

    return GestureDetector(
      onTap: () {
        // Update the provider based on selection
        if (label == "Protected" || label == "Unprotected") {
          if (provider.condomOption != label) {
            provider.updateCondomOption(label);
          }
        } else if (label == "Not Happened" || label == "Happened") {
          if (provider.femaleOrgasm != label) {
            provider.updateFemaleOrgasm(label);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent, // Highlight selected option
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey, // Border color for selected item
            width: 0.1,
          ),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Image.asset(image, width: 50),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black, // Text color for selected option
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveAndAnalysisButtons(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: CustomButton(
            text: "Save",
            onPressed: () {
              final provider = Provider.of<IntercourseProvider>(context, listen: false);

              // Check if the required selections have been made
              if (provider.condomOption == null || provider.femaleOrgasm == null) {
                // Show a snackbar if selections are not made
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please make all the required selections before saving.'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                // Call the saveSelections method to save the data if selections are made
                provider.saveSelections();
                // Add save logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Data saved successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            backgroundColor: primaryColor,
          ),

        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: CustomButton(
            text: "Analysis",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IntercourseAnalysis()),
              );
            },
            textColor: Colors.black,
            backgroundColor: secondaryColor,
          ),
        ),
      ],
    );
  }
}
