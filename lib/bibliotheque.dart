import 'package:flutter/material.dart';
import 'package:flutter_api/etagere.dart';
import 'package:flutter_api/collection.dart';

class BibliothequePage extends StatefulWidget {
  const BibliothequePage({super.key});

  @override
  State<BibliothequePage> createState() => _BibliothequePageState();
}

class _BibliothequePageState extends State<BibliothequePage> {
  List<Map<String, dynamic>> bibliotheques = [];
  int _idIncrement = 1; // générateur d'ID local

  void ajouterBibliotheque() {
    TextEditingController ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nouvelle bibliothèque"),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: "Nom de la bibliothèque",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final nom = ctrl.text.trim();
              if (nom.isEmpty) return;

              // créer un objet local (comme Supabase mais en mémoire)
              final newBiblio = {
                "id": _idIncrement++,
                "nom": nom,
              };

              // ajouter dans la liste
              setState(() {
                bibliotheques.add(newBiblio);
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Bibliothèque '$nom' créée !")),
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
    return Scaffold(
      appBar: AppBar(title: const Text("Mes bibliothèques")),
      floatingActionButton: FloatingActionButton(
        onPressed: ajouterBibliotheque,
        child: const Icon(Icons.add),
      ),
      body: bibliotheques.isEmpty
          ? const Center(
              child: Text(
                "Aucune bibliothèque pour le moment",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: bibliotheques.length,
              itemBuilder: (_, i) {
                final b = bibliotheques[i];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(
                      b["nom"],
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: const Text("Options :"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Bouton Collections
                        IconButton(
                          icon: const Icon(Icons.collections_bookmark),
                          tooltip: "Voir les collections",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CollectionPageAll(bibliotheque: b),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
