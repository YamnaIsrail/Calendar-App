import 'package:calender_app/screens/globals.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/buttons.dart';
import 'medicine_reminder/medicine_reminder_form.dart';

class ContraceptivePage extends StatefulWidget {
  @override
  _ContraceptivePageState createState() => _ContraceptivePageState();
}

class _ContraceptivePageState extends State<ContraceptivePage> {
  final List<Map<String, dynamic>> contraceptives = [
    {'name': 'Contraceptive', 'icon': Icons.add_circle},
    {'name': 'V-Ring', 'icon': Icons.circle},
    {'name': 'Patch', 'icon': Icons.adjust},
    {'name': 'Injection', 'icon': Icons.local_hospital},
    {'name': 'IUD', 'icon': Icons.medical_services},
    {'name': 'Implant', 'icon': Icons.pause},
  ];

  final List<String> selectedMedicines = [];

  void showContraceptiveDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full height if needed
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false, // Prevents expanding to full height
        initialChildSize: 0.6, // Percentage of screen height
        maxChildSize: 0.8, // Allows a bit more scrolling space
        minChildSize: 0.4, // Minimum height percentage
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Choose Your Contraceptive',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 300, // Specific height for the list
                child: ListView.builder(
                  itemCount: contraceptives.length,
                  itemBuilder: (context, index) {
                    final contraceptive = contraceptives[index];
                    return ListTile(
                      leading: Icon(
                        contraceptive['icon'],
                        size: 40,
                        color: Color(0xff3049B2),
                      ),
                      title: Text(
                        contraceptive['name'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          if (!selectedMedicines.contains(contraceptive['name'])) {
                            selectedMedicines.add(contraceptive['name']);
                          }
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MedicineReminderScreen(
                              selectedMedicines: selectedMedicines,
                              // editingMedicine: selectedMedicines, // Pass the medicine to be edited
                            ),
                          ),
                        );
                        // Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),

    ListTile(
      leading: Icon(
       Icons.add,
        size: 40,
        color: Color(0xff3049B2),
      ),
      title: Text(
        "Add Custom Pill",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        setState(() {
    Navigator.pop(context);
    _showCustomPillDialog();
          }
    );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MedicineReminderScreen(
              selectedMedicines: selectedMedicines,
              // editingMedicine: selectedMedicines, // Pass the medicine to be edited
            ),
          ),
        );
        // Navigator.pop(context);
      },
    ),
                ],
          ),
        ),
      ),
    );
  }

  void _showCustomPillDialog() {
    TextEditingController customPillController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Custom Pill"),
        content: TextField(
          controller: customPillController,
          decoration: InputDecoration(hintText: "Enter pill name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (customPillController.text.isNotEmpty) {
                setState(() {
                  selectedMedicines.add(customPillController.text);
                });
              }
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medicine Reminder")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: selectedMedicines.length,
                itemBuilder: (context, index) {
                  final medicine = selectedMedicines[index];
                  return ListTile(
                    title: Text(
                      medicine,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Navigate to MedicineReminderScreen for editing
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MedicineReminderScreen(
                                  selectedMedicines: selectedMedicines,
                                  editingMedicine: medicine, // Pass the medicine to be edited
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              selectedMedicines.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );

                },
              ),
            ),
            CustomButton(
              backgroundColor: primaryColor,
              onPressed: showContraceptiveDialog,
              text: 'ADD/Choose Medicine',
            ),


          ],
        )
      ),
    );
  }
}

