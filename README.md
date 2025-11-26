# 📚 CollecOthèque

**Une application mobile Flutter pour gérer et organiser votre collection de livres**

[![Flutter](https://img.shields.io/badge/Flutter-3.19-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

<img width="2255" height="720" alt="collecotheque" src="https://github.com/user-attachments/assets/dbb4f7fe-a8f1-456e-8bf0-c9033f04c7da" />

##  Description

CollecOthèque est une application mobile développée avec Flutter qui permet aux utilisateurs de gérer leur collection de livres de manière organisée et intuitive. L'application suit une structure hiérarchique : **Bibliothèques → Étagères → Collections → Livres**.

<img width="508" height="649" alt="Capture d’écran_2025-11-26_16-22-04" src="https://github.com/user-attachments/assets/5256fa27-a518-4802-a487-c93f5828baef" />

<img width="548" height="682" alt="Capture d’écran_2025-11-26_15-51-06" src="https://github.com/user-attachments/assets/768a979f-b40f-4c11-966c-ff6c9a408003" />

<img width="553" height="649" alt="Capture d’écran_2025-11-26_15-49-53" src="https://github.com/user-attachments/assets/0b1ca681-3662-4d33-bcd6-3c49351685ef" />

<img width="549" height="681" alt="Capture d’écran_2025-11-26_15-54-25" src="https://github.com/user-attachments/assets/448dd06e-b742-48fe-91e1-7b079e064172" />


##  Fonctionnalités

###  Organisation Modulaire
- **Bibliothèques multiples** (ex: Salon, Chambre, Bureau)
- **Étagères thématiques** (ex: Romans, BD, Cuisine)
- **Collections spécifiques** (ex: Policier, Science-Fiction, Recettes)
- **Gestion hiérarchique complète**

###  Gestion des Livres
- **Ajout par code ISBN** (13 chiffres)
- **Recherche automatique** via l'API Open Library
- **Récupération des métadonnées** (titre, auteur, couverture)
- **Affichage des détails complets**

###  Données
- **Stockage local persistant** avec Shared Preferences
- **Sauvegarde automatique**
- **Données conservées** entre les sessions

## 🚀 Installation

### Prérequis
- Flutter SDK 3.19 ou supérieur
- Dart 3.3 ou supérieur
- Un émulateur ou device Android/iOS

### Étapes d'installation
```bash
# Cloner le repository
git clone https://github.com/votre-username/collecotheque.git

# Se déplacer dans le dossier
cd collecotheque

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run

lib/
├── main.dart              # Point d'entrée de l'application
├── myhomepage.dart        # Page d'accueil avec saisie ISBN
├── affichepage.dart       # Affichage des détails du livre
├── bibliotheque.dart      # Gestion des bibliothèques
├── collection.dart        # Gestion des collections
├── etagere.dart           # Gestion des étagères
├── livre.dart             # Affichage des livres
└── data_service.dart      # Service de persistance des données

Bibliothèque "Salon"
├── Étagère "Romans"
│   ├── Collection "Policier"
│   └── Collection "Science-Fiction"
└── Étagère "Art"
    └── Collection "Peinture"
```bash

Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.
 Auteur

    GitHub: @jricart12

    LinkedIn: https://www.linkedin.com/in/julien-ricart-684763347/

 Remerciements

    Open Library pour l'API livres

    Flutter pour le framework extraordinaire

    La communauté Dart/Flutter pour le support
