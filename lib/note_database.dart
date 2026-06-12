import 'package:notes_app/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDatabase {
  final database = Supabase.instance.client.from('notes');

  Future<void> insertNote(Note note) async {
    await database.insert(note.toJson());
  }

  Stream<List<Note>> getNotesStream() {
    return database
        .stream(primaryKey: ['id'])
        .map((data) => data.map((json) => Note.fromJson(json)).toList());
  }

  Future<void> deleteNote(int id) async {
    await database.delete().eq('id', id);
  }

  Future<void> updateNote(Note note) async {
    await database.update(note.toJson()).eq('id', note.id!);
  }
}
