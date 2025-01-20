import 'package:calender_app/provider/date_day_format.dart';
import 'package:calender_app/provider/showhide.dart';
import 'package:calender_app/screens/settings/item.dart';
import 'package:calender_app/screens/settings/show_hide_option/show_hide_mood.dart';
import 'package:calender_app/screens/settings/show_hide_option/show_hide_symptoms.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dialog.dart';

class CalendarSetting extends StatefulWidget {
  @override
  _CalendarSettingState createState() => _CalendarSettingState();
}

class _CalendarSettingState extends State<CalendarSetting> {
  String firstDayOfWeek = "";


  @override
  Widget build(BuildContext context) {
    firstDayOfWeek = context.watch<SettingsModel>().firstDayOfWeek;
    String _selectedDateFormat = context.watch<SettingsModel>().dateFormat;

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Calendar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  DialogHelper.showDateFormatDialog(
                    context,
                    _selectedDateFormat,
                        (newValue) {
                      setState(() {
                        _selectedDateFormat = newValue;
                      });
                    },
                  );
                },
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.topLeft,
                  child: SectionHeader(title: 'DateFormat', caption: _selectedDateFormat),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Call showFirstDayOfWeekDialog
                  DialogHelper.showFirstDayOfWeekDialog(
                    context,
                    firstDayOfWeek,
                        (newDay) {
                      // Update the first day of the week in the model
                      context.read<SettingsModel>().setFirstDayOfWeek(newDay);
                    },
                  );
                },
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.topLeft,
                  child: SectionHeader(title: 'First Day of Week', caption: firstDayOfWeek),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Show/hide Option",
                style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Container(
                color: Colors.white,

                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                    title: Text("Symptoms",
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShowHideSymptomScreen()
                        ),
                      );
                    },
                    trailing: IconButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShowHideSymptomScreen()
                        ),
                      );
                    },
                        icon: Icon(Icons.arrow_forward_ios)
                    )
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                color: Colors.white,
                child: ListTile(
                    title: Text("Moods",
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShowHideMood()
                        ),
                      );
                    },
                    trailing: IconButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShowHideMood()
                        ),
                      );
                    },
                        icon: Icon(Icons.arrow_forward_ios)
                    )
                ),
              ),
              ShowHideItem(title: 'Intercourse Option'),
              // ShowHideItem(title: 'Condom Option'),
              ShowHideItem(title: 'Chance of getting pregnant'),
              ShowHideItem(title: 'Ovulation / Fertile'),
              ShowHideItem(title: 'Future Period'),
              ShowHideItem(title: 'Contraceptive Medicine'),
            ],
          ),
        ),
      ),
    );
  }
}


class ShowHideItem extends StatelessWidget {
  final String title;

  ShowHideItem({required this.title});

  @override
  Widget build(BuildContext context) {
    final showHideProvider = context.watch<ShowHideProvider>();
    final isVisible = showHideProvider.visibilityMap[title] ?? true;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 16)),
        trailing: Switch(
          value: isVisible,
          onChanged: (value) {
            showHideProvider.toggleVisibility(title); // Toggle visibility
          },
        ),
      ),
    );
  }
}

