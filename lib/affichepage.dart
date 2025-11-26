import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_api/main.dart';
import 'dart:convert' as convert;

class AffichePage extends StatefulWidget {
  const AffichePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AffichePage> createState() => _AffichePageState();
}

class _AffichePageState extends State<AffichePage> {
  String? isbn;
  Map<String, dynamic>? livre;
  Map<String, dynamic>? auteur;

  bool isLoading = false;
  String? errorMessage;
  bool _fetchedOnce = false; // évite plusieurs fetch

  // déclenché une fois que le widget a un context valide et les arguments
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_fetchedOnce) {
      final maybeIsbn = ModalRoute.of(context)?.settings.arguments;
      if (maybeIsbn is String && maybeIsbn.isNotEmpty) {
        isbn = maybeIsbn;
        _fetchAll(isbn!);
        _fetchedOnce = true;
      } else {
        setState(() {
          errorMessage = "ISBN manquant ou invalide.";
        });
      }
    }
  }

  Future<void> _fetchAll(String isbn) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _recupLivres(isbn);
      // _recupLivres appelle _recupAuteurs si nécessaire
    } catch (e) {
      setState(() {
        errorMessage = "Erreur lors de la récupération : $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _recupLivres(String isbn) async {
    final url = "https://openlibrary.org/isbn/$isbn.json";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = convert.jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        livre = decoded;
        // récupère l'auteur seulement si présent
        if (livre!['authors'] != null &&
            (livre!['authors'] as List).isNotEmpty) {
          await _recupAuteurs(livre!);
        } else {
          // pas d'auteur dispo : on laisse auteur null
          auteur = null;
        }
      } else {
        throw 'Format inattendu pour le livre';
      }
    } else {
      throw 'Livre non trouvé (status ${response.statusCode})';
    }
  }

  Future<void> _recupAuteurs(Map<String, dynamic> livreData) async {
    try {
      final auteurs = livreData['authors'] as List<dynamic>;
      if (auteurs.isEmpty) return;
      final key = auteurs[0]['key'] as String;
      final url = "https://openlibrary.org/$key.json";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = convert.jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          auteur = decoded;
        }
      }
    } catch (_) {
      // laisse auteur null si problème
      auteur = null;
    }
  }

  Widget afficheLivre() {
    final List<Widget> elements = [];

    // couverture basée sur ISBN si disponible
    if (isbn != null) {
      elements.add(Image.network(
        "https://covers.openlibrary.org/b/isbn/$isbn-L.jpg",
        errorBuilder: (context, error, stackTrace) =>
            const SizedBox.shrink(), // si pas d'image
      ));
    }

    final titre = livre != null ? livre!['title'] ?? "Titre inconnu" : null;
    if (titre != null) {
      elements.add(
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text("Titre : $titre",
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      );
    }

    final auteurNom = auteur != null ? auteur!['name'] : null;
    if (auteurNom != null) {
      elements.add(
        Text("Auteur : $auteurNom", style: const TextStyle(fontSize: 18)),
      );
    } else {
      // si pas d'auteur récupéré, on peut afficher la clé author ou rien
      if (livre != null && livre!['authors'] != null) {
        final a0 = (livre!['authors'] as List).isNotEmpty
            ? livre!['authors'][0]['key']
            : null;
        if (a0 != null) elements.add(Text("Auteur : $a0"));
      }
    }

    elements.add(const SizedBox(height: 20));

    elements.add(
      ElevatedButton(
        onPressed: () => choisirEmplacementEtAjouter(context),
        child: const Text("Ajouter à la bibliothèque"),
      ),
    );

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: elements,
        ),
      ),
    );
  }

  Widget attente() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'En attente des données',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? attente()
          : (errorMessage != null
              ? Center(child: Text(errorMessage!))
              : afficheLivre()),
    );
  }

  void choisirEmplacementEtAjouter(BuildContext context) async {
    // 1) CHOISIR BIBLIOTHÈQUE
    final biblios = await supabase.from("bibliotheques").select();
    if (!mounted) return;

    final biblio = await showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Choisir une bibliothèque"),
        children: biblios
            .map((b) => SimpleDialogOption(
                  child: Text(b["nom"]),
                  onPressed: () => Navigator.pop(context, b),
                ))
            .toList(),
      ),
    );

    if (biblio == null) return;

    // 2) CHOISIR ÉTAGÈRE
    final etag = await supabase
        .from("etageres")
        .select()
        .eq("bibliotheque_id", biblio["id"]);

    final etagere = await showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Choisir une étagère"),
        children: etag
            .map((e) => SimpleDialogOption(
                  child: Text(e["nom"]),
                  onPressed: () => Navigator.pop(context, e),
                ))
            .toList(),
      ),
    );

    if (etagere == null) return;

    // 3) CHOISIR COLLECTION
    final colls = await supabase
        .from("collections")
        .select()
        .eq("etagere_id", etagere["id"]);

    final collection = await showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Choisir une collection"),
        children: colls
            .map((c) => SimpleDialogOption(
                  child: Text(c["nom"]),
                  onPressed: () => Navigator.pop(context, c),
                ))
            .toList(),
      ),
    );

    if (collection == null) return;

    // 4) AJOUT DU LIVRE
    await supabase.from("livres").insert({
      "isbn": isbn,
      "image_url": "https://covers.openlibrary.org/b/isbn/$isbn-L.jpg",
      "collection_id": collection["id"]
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Livre ajouté !")),
    );
  }
}
