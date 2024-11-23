import 'package:calender_app/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
//
// class TimeLine extends StatelessWidget {
//   const TimeLine({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("TimeLine"),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,  // Remove shadow for a cleaner gradient effect
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFFE8EAF6),
//
//                 Color(0xFFF3E5F5)
//               ], // Light gradient background
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//
//       ),
//
//       body: SingleChildScrollView(
//         child: ListView(
//           shrinkWrap: true, // Adjust height to content size
//           physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
//           padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//           children: [
//             // First Card
//             Card(
//               margin: EdgeInsets.symmetric(vertical: 8.0),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Row(
//                   children: [
//                     // Date Container
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[100],
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Wed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//
//                           Text("16", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                           Text("Oct", style: TextStyle(fontSize: 16, color: Colors.black54)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     // Content Column
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Note", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                           SizedBox(height: 4),
//                           Text("I have to take medicine at 2:00 pm."),
//                         ],
//                       ),
//                     ),
//                     // Icon
//                     Icon(Icons.favorite, color: Colors.pink),
//                   ],
//                 ),
//               ),
//             ),
//             // Second Card
//             Card(
//               margin: EdgeInsets.symmetric(vertical: 8.0),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Row(
//                   children: [
//                     // Date Container
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.pink[100],
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Thu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//
//                           Text("15", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                           Text("Oct", style: TextStyle(fontSize: 16, color: Colors.black54)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     // Content Column
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Symptoms", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                           SizedBox(height: 4),
//                           Text("Diarrhea"),
//                           SizedBox(height: 4),
//                           Text("Water Intake: 1350 ml", style: TextStyle(color: Colors.blue)),
//                         ],
//                       ),
//                     ),
//                     // Icon
//                     Icon(Icons.favorite, color: Colors.pink),
//                   ],
//                 ),
//               ),
//             ),
//             // Third Card
//             Card(
//               margin: EdgeInsets.symmetric(vertical: 8.0),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Row(
//                   children: [
//                     // Date Container
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.purple[100],
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Wed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//
//                           Text("03", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                           Text("Oct", style: TextStyle(fontSize: 16, color: Colors.black54)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     // Content Column
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Period Starts", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                         ],
//                       ),
//                     ),
//                     // Icon
//                     Icon(Icons.favorite, color: Colors.pink),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimelineItem {
  final String type;
  final String title;
  final String time;
  final String date;

  TimelineItem({required this.type, required this.title, required this.time, required this.date});
}

class TimelineCard extends StatelessWidget {
  final TimelineItem item;

  const TimelineCard({required this.item});

  @override
  Widget build(BuildContext context) {
    Widget cardContent;

    switch (item.type) {
      case 'medicine':
        cardContent = MedicineReminderCard(item: item);
        break;
      case 'note':
        cardContent = NoteCard(item: item);
        break;
      case 'cycle':
        cardContent = CycleCard(item: item);
        break;
      default:
        cardContent = Container();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Date Container
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.date.split(',')[0], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(item.date.split(',')[1].trim(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text("Oct", style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
              SizedBox(width: 16),
              // Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.type[0].toUpperCase() + item.type.substring(1), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    SizedBox(height: 4),
                    Text(item.title),
                  ],
                ),
              ),
              // Icon
              Icon(Icons.favorite, color: Colors.pink),
            ],
          ),
        ),
      ),
    );
  }
}

class MedicineReminderCard extends StatelessWidget {
  final TimelineItem item;

  const MedicineReminderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(); // No changes needed here as the card layout is handled by the TimelineCard
  }
}

class NoteCard extends StatelessWidget {
  final TimelineItem item;

  const NoteCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(); // No changes needed here as the card layout is handled by the TimelineCard
  }
}

class CycleCard extends StatelessWidget {
  final TimelineItem item;

  const CycleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(); // No changes needed here as the card layout is handled by the TimelineCard
  }
}

class TimeLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, dataProvider, child) {
          // Combine all the data items
          final items = [
            ...dataProvider.medicineReminders.map((reminder) => TimelineItem(type: 'medicine', title: reminder.title, time: reminder.time, date: reminder.date)),
            ...dataProvider.notes.map((note) => TimelineItem(type: 'note', title: note.title, time: '', date: DateFormat('yyyy-MM-dd HH:mm:ss').format(note.date)
            )),
            ...dataProvider.cycleData.map((cycle) => TimelineItem(type: 'cycle', title: 'Cycle Start: ${cycle.cycleStartDate}', time: '', date: '')),
          ];

          // Display message for no data based on category
          if (dataProvider.medicineReminders.isEmpty && dataProvider.notes.isEmpty && dataProvider.cycleData.isEmpty) {
            return Center(
              child: Text(
                'No data available. Add some notes, reminders, or cycle data.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return TimelineCard(item: item);
            },
          );
        },
      ),
    );
  }
}
