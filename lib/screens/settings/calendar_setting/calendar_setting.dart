import 'package:calender_app/screens/settings/item.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import '../dialog.dart';
class CalendarSetting extends StatefulWidget {
  @override
  _CalendarSettingState createState() => _CalendarSettingState();
}

class _CalendarSettingState extends State<CalendarSetting> {
  String _selectedFirstDayOfWeek = "Sunday";
  String _selectedDateFormat = "System Default";

  @override
  Widget build(BuildContext context) {
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
                    _selectedFirstDayOfWeek,
                        (newValue) {
                      setState(() {
                        _selectedFirstDayOfWeek = newValue;
                      });
                    },
                  );
                },
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.topLeft,
                  child: SectionHeader(title: 'First Day of Week', caption: _selectedFirstDayOfWeek),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Show/hide Option",
                style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              CustomItem(title: 'Intercourse Option'),
              CustomItem(title: 'Condom Option'),
              CustomItem(title: 'Chance of getting pregnant'),
              CustomItem(title: 'Ovulation / Fertile'),
              CustomItem(title: 'Future Period'),
              CustomItem(title: 'Contraceptive Medicine'),
            ],
          ),
        ),
      ),
    );
  }
}
