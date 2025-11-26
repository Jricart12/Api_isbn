import 'package:flutter/material.dart';

class LivrePage extends StatefulWidget {
  final Map<String, dynamic> etagere;

  const LivrePage({super.key, required this.etagere});

  @override
  State<LivrePage> createState() => _LivrePageState();
}

class _LivrePageState extends State<LivrePage> {
  List<Map<String, dynamic>> livres = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Livres - ${widget.etagere['nom']}")),
      body: livres.isEmpty
          ? const Center(child: Text("Aucun livre sur cette étagère"))
          : ListView.builder(
              itemCount: livres.length,
              itemBuilder: (_, i) {
                final l = livres[i];
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(l["titre"]),
                  subtitle: Text("ISBN : ${l['isbn']}"),
                );
              },
            ),
    );
  }
}
