import 'package:calender_app/provider/notes_provider.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notes extends StatelessWidget {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

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
              child: FutureBuilder(
                future: noteProvider.initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: noteProvider.notes.length,
                          itemBuilder: (context, index) {
                            final note = noteProvider.notes[index];
                            return ListTile(
                              title: Text(note.content),
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
                                            decoration: InputDecoration(
                                              hintText: 'Enter updated note',
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                noteProvider.updateNoteAt(
                                                  index,
                                                  _noteController.text,
                                                );
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
                                    onPressed: () =>
                                        noteProvider.deleteNoteAt(index),
                                  ),
                                ],
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
                      ElevatedButton(
                        onPressed: () {
                          noteProvider.addNote(_noteController.text);
                          _noteController.clear();
                        },
                        child: Text('Add Note'),
                      ),
                    ],
                  );
                },
              ),
            )));
  }
}
