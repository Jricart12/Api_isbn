import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_api/affichepage.dart';
import 'package:flutter_api/myhomepage.dart';
import 'package:flutter_api/bibliotheque.dart'; // <-- IMPORTANT

late final SupabaseClient supabase;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xyzcompany.supabase.co',
    anonKey:
        'postgresql://postgres:[YOUR_PASSWORD]@db.pzxpfyulwyubixkpvjxq.supabase.co:5432/postgres',
  );

  supabase = Supabase.instance.client;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CollecOthèque',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'CollecOthèque'),
      routes: {
        '/affiche': (context) => const AffichePage(title: 'Affichage'),
        '/bibliotheques': (context) => const BibliothequePage(), // <-- ROUTE OK
      },
    );
  }
}
