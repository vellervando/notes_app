import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notes_pages.dart';

void main() async {
  // Supabase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://csqmdwkkarjgtanggxkc.supabase.co',
    anonKey: 'sb_publishable_FK-rpRdhWvuRMe-ZCX1suQ_x2vLi4bD',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NotesPage());
  }
}
