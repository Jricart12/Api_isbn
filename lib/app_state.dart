// lib/app_state.dart
import 'package:flutter_api/data_service.dart';

class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  final DataService _dataService = DataService();

  List<Map<String, dynamic>> _bibliotheques = [];
  List<Map<String, dynamic>> _collections = [];
  List<Map<String, dynamic>> _etageres = [];
  List<Map<String, dynamic>> _livres = [];
  int _lastId = 1;

  // Getters
  List<Map<String, dynamic>> get bibliotheques => _bibliotheques;
  List<Map<String, dynamic>> get collections => _collections;
  List<Map<String, dynamic>> get etageres => _etageres;
  List<Map<String, dynamic>> get livres => _livres;
  int get lastId => _lastId;

  // Charger toutes les données
  Future<void> loadAllData() async {
    print('🔄 Chargement de toutes les données...');
    _bibliotheques = await _dataService.loadBibliotheques();
    _collections = await _dataService.loadCollections();
    _etageres = await _dataService.loadEtageres();
    _livres = await _dataService.loadLivres();
    _lastId = await _dataService.loadLastId();

    print(' Données chargées:');
    print('   - ${_bibliotheques.length} bibliothèques');
    print('   - ${_collections.length} collections');
    print('   - ${_etageres.length} étagères');
    print('   - ${_livres.length} livres');
    print('   - ID: $_lastId');
  }

  // Sauvegarder toutes les données
  Future<void> saveAllData() async {
    print('Sauvegarde de toutes les données...');
    await _dataService.saveBibliotheques(_bibliotheques);
    await _dataService.saveCollections(_collections);
    await _dataService.saveEtageres(_etageres);
    await _dataService.saveLivres(_livres);
    await _dataService.saveLastId(_lastId);
    print(' Toutes les données sauvegardées');
  }

  // Méthodes pour ajouter des éléments
  void addBibliotheque(Map<String, dynamic> biblio) {
    _bibliotheques.add(biblio);
    _lastId++;
    saveAllData();
  }

  void addCollection(Map<String, dynamic> collection) {
    _collections.add(collection);
    _lastId++;
    saveAllData();
  }

  void addEtagere(Map<String, dynamic> etagere) {
    _etageres.add(etagere);
    _lastId++;
    saveAllData();
  }

  void addLivre(Map<String, dynamic> livre) {
    _livres.add(livre);
    saveAllData();
  }

  // Méthodes pour filtrer
  List<Map<String, dynamic>> getCollectionsForBibliotheque(int biblioId) {
    return _collections.where((c) => c["bibliotheque_id"] == biblioId).toList();
  }

  List<Map<String, dynamic>> getEtageresForCollection(int collectionId) {
    return _etageres.where((e) => e["collection_id"] == collectionId).toList();
  }

  List<Map<String, dynamic>> getLivresForEtagere(int etagereId) {
    return _livres.where((l) => l["etagere_id"] == etagereId).toList();
  }
}
