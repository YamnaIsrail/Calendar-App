import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/provider/showhide.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:flutter/material.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../firebase/analytics/analytics_service.dart';
import '../../../../widgets/buttons.dart';
import 'medicine_reminder_form.dart';

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

  List<String> selectedMedicines = [];
  Map<String, bool> notificationsStatus = {};
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now(); // Record the entry time
    AnalyticsService.logScreenView("Medicine Reminder");
    _loadMedicines(); // Load saved medicines from Hive
  }

  @override
  void dispose() {
    if (_startTime != null) {
      int duration = DateTime.now().difference(_startTime!).inSeconds;
      AnalyticsService.logScreenTime("Medicine Reminder", duration);
    }
    super.dispose();
  }


  Future<void> _loadMedicines() async {
    var box = await Hive.openBox<List<String>>('medicinesBox');
    setState(() {
      selectedMedicines =
          box.get('selectedMedicines', defaultValue: [])!.cast<String>();
    });
  }

  // Save selected medicines to Hive
  Future<void> _saveMedicines() async {
    var box = await Hive.openBox<List<String>>('medicinesBox');
    box.put('selectedMedicines',
        selectedMedicines); // Save the list of selected medicines
  }

  void showContraceptiveDialog() {
    final showHideProvider = Provider.of<ShowHideProvider>(context,
        listen: false); // Access the provider

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
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
              if (showHideProvider.visibilityMap['Contraceptive Medicine'] ==
                  true)
                SizedBox(
                  height: 300,
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          setState(() {
                            if (!selectedMedicines
                                .contains(contraceptive['name'])) {
                              selectedMedicines.add(contraceptive['name']);
                            }
                          });

                          _saveMedicines();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MedicineReminderScreen(
                                selectedMedicines: selectedMedicines,
                                editingMedicine: contraceptive['name'],
                              ),
                            ),
                          );
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
                  Navigator.pop(context);
                  _showCustomPillDialog();
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
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  backgroundColor: secondaryColor,
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  textColor: Colors.black,
                  text: "Cancel",
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: CustomButton(
                  backgroundColor: primaryColor,
                  onPressed: () {
                    if (customPillController.text.isNotEmpty) {
                      setState(() {
                        selectedMedicines.add(customPillController.text);
                      });
                      _saveMedicines(); // Save the updated list

                      // Close the dialog first
                      Navigator.pop(context);

                      // Navigate to MedicineReminderScreen after adding the custom pill
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MedicineReminderScreen(
                            selectedMedicines: selectedMedicines,
                            editingMedicine: customPillController.text,
                          ),
                        ),
                      );
                    }
                  },
                  text: "Add",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text("Medicine Reminder"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: selectedMedicines.length,
                  itemBuilder: (context, index) {
                    final medicine = selectedMedicines[index];
                    return Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          medicine,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Click to edit",
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                final box = Hive.box<Map>('medicineReminders');
                                final reminder = box.get(medicine);

                                if (reminder != null &&
                                    reminder['notificationIds'] != null) {
                                  final notificationIds =
                                      reminder['notificationIds'] as List;

                                  // Cancel all notifications using the stored notification IDs
                                  for (var notificationId in notificationIds) {
                                    NotificationService.cancelScheduledTask(
                                        notificationId);
                                  }
                                }

                                setState(() {
                                  selectedMedicines.removeAt(index);
                                  notificationsStatus.remove(medicine);
                                });
                                box.delete(medicine);
                                _saveMedicines(); // Save the updated list
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MedicineReminderScreen(
                                selectedMedicines: selectedMedicines,
                                editingMedicine:
                                    medicine, // Pass the medicine to be edited
                              ),
                            ),
                          ).then((updatedMedicine) {
                            if (updatedMedicine != null &&
                                updatedMedicine is String) {
                              // Update the medicine if edited and returned
                              setState(() {
                                final index =
                                    selectedMedicines.indexOf(medicine);
                                if (index != -1) {
                                  selectedMedicines[index] = updatedMedicine;
                                }
                              });
                            }
                          });
                        },
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
          ),
        ),
      ),
    );
  }

  Map<String, int> notificationIds = {};

  bool isNotificationEnabled(String medicine) {
    return notificationsStatus[medicine] ?? false;
  }
}
