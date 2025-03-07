import 'package:calender_app/provider/notes_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../firebase/analytics/analytics_service.dart';
import 'note_detail.dart';

class Notes extends StatefulWidget {
  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final TextEditingController _noteController = TextEditingController();
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now(); // Record the entry time
    AnalyticsService.logScreenView("Notes");
  }

  @override
  void dispose() {
    if (_startTime != null) {
      int duration = DateTime.now().difference(_startTime!).inSeconds;
      AnalyticsService.logScreenTime("Notes", duration);
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    // Trigger initialization once using FutureBuilder
    return FutureBuilder(
      future: noteProvider.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Main UI after initialization
        return bgContainer(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text('Add Note', style: TextStyle(color: Colors.black)),
              leading: CircleAvatar(
                backgroundColor: Color(0xffFFC4E8),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<NoteProvider>(
                builder: (context, provider, child) {
                  if (provider.notesWithDates.isEmpty) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _noteController,
                            decoration: InputDecoration(
                              hintText: 'Enter your note here...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        CustomButton(
                          backgroundColor: primaryColor,
                          onPressed: () {
                            if (_noteController.text.isNotEmpty) {
                              provider.addNote(context,_noteController.text);
                              _noteController.clear();
                            }
                          },
                          text: "Add Note",
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.notesWithDates.length,
                          itemBuilder: (context, index) {
                            final note = provider.notesWithDates[index];
                            return  Container(
                              color: Colors.white,
                              margin: EdgeInsets.all(5),
                              child: ListTile(
                                title: Text(
                                  note.content,
                                  style: TextStyle(height: 1.2),
                                  maxLines: 2, // Limit to 2 lines
                                  overflow: TextOverflow.ellipsis, // Show ellipsis if text overflows
                                ),
                                onTap: () {
                                  // Navigate to the detail page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NoteDetailPage(note: note.content),
                                    ),
                                  );
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        _noteController.text = note.content;
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Edit Note'),
                                            content: TextField(
                                              controller: _noteController,
                                              decoration:
                                              InputDecoration(hintText: 'Enter updated note'),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  provider.updateNoteAt(
                                                      index, _noteController.text);
                                                  _noteController.clear();
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Save'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => provider.deleteNoteAt(index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            hintText: 'Enter your note here...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      CustomButton(
                        backgroundColor: primaryColor,
                        onPressed: () {
                          if (_noteController.text.isNotEmpty) {
                            provider.addNote(context,_noteController.text);
                            _noteController.clear();
                          }
                        },
                        text: "Add Note",
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
