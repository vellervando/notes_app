import 'package:flutter/material.dart';
import 'package:notes_app/note.dart';
import 'package:notes_app/note_database.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _noteDatabase = NoteDatabase();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: StreamBuilder(
        stream: _noteDatabase.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Gagal memuat notes:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // loading ...
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!;

          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada note. Tekan tombol + untuk menambah catatan.',
              ),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(notes[index].content),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => editNote(notes[index]),
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => deleteNote(notes[index]),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Note'),
        content: TextField(controller: textController),
        actions: [
          TextButton(
            onPressed: () {
              final note = Note(content: textController.text);
              _noteDatabase.insertNote(note);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void editNote(Note note) {
    textController.text = note.content;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(controller: textController),
        actions: [
          TextButton(
            onPressed: () {
              note.content = textController.text;
              _noteDatabase.updateNote(note);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        actions: [
          TextButton(
            onPressed: () {
              _noteDatabase.deleteNote(note.id!);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
