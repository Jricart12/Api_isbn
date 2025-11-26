// collection.dart
import 'package:flutter/material.dart';
import 'package:flutter_api/etagere.dart';

class CollectionPageAll extends StatefulWidget {
  final Map<String, dynamic> bibliotheque;

  const CollectionPageAll({super.key, required this.bibliotheque});

  @override
  State<CollectionPageAll> createState() => _CollectionPageAllState();
}

class _CollectionPageAllState extends State<CollectionPageAll> {
  List<Map<String, dynamic>> collections = [];
  int _idIncrement = 1;

  void ajouterCollection() {
    final TextEditingController ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Nouvelle collection"),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: "Nom de la collection"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final nom = ctrl.text.trim();
              if (nom.isEmpty) return;

              final newCollection = {
                "id": _idIncrement++,
                "nom": nom,
              };

              setState(() {
                collections.add(newCollection);
              });

              Navigator.pop(ctx);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Collection '$nom' créée !")),
              );
            },
            child: const Text("Créer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            AppBar(title: Text("Collections - ${widget.bibliotheque['nom']}")),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: ajouterCollection,
          child: const Icon(Icons.add),
        ),
        body: collections.isEmpty
            ? const Center(
                child: Text(
                  "Aucune collection pour le moment",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: collections.length,
                itemBuilder: (_, i) {
                  final c = collections[i];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ListTile(
                      title:
                          Text(c["nom"], style: const TextStyle(fontSize: 18)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EtagerePage(collection: c),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
