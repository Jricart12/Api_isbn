// lib/etagere.dart
import 'package:flutter/material.dart';
import 'package:flutter_api/livre.dart';
import 'package:flutter_api/data_service.dart'; // <-- IMPORT MANQUANT

class EtagerePage extends StatefulWidget {
  final Map<String, dynamic> collection;

  const EtagerePage({super.key, required this.collection});

  @override
  State<EtagerePage> createState() => _EtagerePageState();
}

class _EtagerePageState extends State<EtagerePage> {
  List<Map<String, dynamic>> etageres = [];
  final DataService _dataService =
      DataService(); // <-- CORRECTION : espace manquant
  int _idIncrement = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedEtageres = await _dataService.loadEtageres();
    final lastId = await _dataService.loadLastId();

    // Filtrer les étagères pour cette collection
    final etageresFiltrees = loadedEtageres
        .where((e) => e["collection_id"] == widget.collection["id"])
        .toList();

    setState(() {
      etageres = etageresFiltrees;
      _idIncrement = lastId;
    });
  }

  Future<void> _saveData() async {
    // Sauvegarder toutes les étagères, pas seulement celles filtrées
    final allEtageres = await _dataService.loadEtageres();
    final autresEtageres = allEtageres
        .where((e) => e["collection_id"] != widget.collection["id"])
        .toList();

    await _dataService.saveEtageres([...autresEtageres, ...etageres]);
    await _dataService.saveLastId(_idIncrement);
  }

  void ajouterEtagere() {
    TextEditingController ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nouvelle étagère"),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: "Nom de l'étagère"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final nom = ctrl.text.trim();
              if (nom.isEmpty) return;

              final newEtagere = {
                "id": _idIncrement++,
                "nom": nom,
                "collection_id": widget.collection["id"],
                "created_at": DateTime.now().toIso8601String(),
              };

              setState(() {
                etageres.add(newEtagere);
              });

              await _saveData();
              Navigator.pop(context);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Étagère '$nom' créée !")),
              );
            },
            child: const Text("Créer"),
          ),
        ],
      ),
    );
  }

  void _supprimerEtagere(int index) async {
    final etagere = etageres[index];

    final confirmation = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: Text("Supprimer l'étagère '${etagere['nom']}' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmation == true && mounted) {
      setState(() {
        etageres.removeAt(index);
      });
      await _saveData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Étagère '${etagere['nom']}' supprimée")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Étagères - ${widget.collection['nom']}")),
      floatingActionButton: FloatingActionButton(
        onPressed: ajouterEtagere,
        child: const Icon(Icons.add),
      ),
      body: etageres.isEmpty
          ? const Center(
              child: Text(
                "Aucune étagère pour le moment",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: etageres.length,
              itemBuilder: (_, i) {
                final e = etageres[i];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(e["nom"], style: const TextStyle(fontSize: 18)),
                    subtitle: Text(
                      "Créée le ${DateTime.parse(e['created_at']).day}/${DateTime.parse(e['created_at']).month}/${DateTime.parse(e['created_at']).year}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LivrePage(etagere: e),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _supprimerEtagere(i),
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
