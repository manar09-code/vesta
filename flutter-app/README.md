# Vesta — Flutter app

Version Flutter de Vesta, calquée sur la maquette web (`docs/mockups/`) :
mêmes écrans, même thème (DM Sans / DM Serif Display, palette navy `#13294B` /
or `#C6973F` / crème `#F8F4EC`), même structure de modules. L'écran de
connexion est refondu : héros navy avec photo en arche, panneau crème,
onglets segmentés et CTA doré.

**Mode démo** : aucun fichier de configuration Firebase n'est disponible pour
le moment, donc toutes les données (annonces, session, chat) vivent en mémoire.
La couche de données est déjà isolée derrière des repositories, il suffira de
réécrire ces classes pour brancher Firebase — aucun écran ne change.

## Démarrer

```sh
flutter pub get

# Windows (démo visuelle sur ce poste)
flutter run -d windows

# Android (nécessite un émulateur ou un appareil)
flutter run -d android
```

## Vérifications

```sh
flutter analyze   # 0 issue
flutter test      # 3 tests : écran de connexion, entrée sans compte, erreurs de formulaire
```

## Structure (C4 niveau 4)

```
lib/
├── main.dart                 Point d'entrée + thème
├── home_shell.dart           Coquille 5 onglets + RootGate (session)
├── app_state.dart            État global (session, favoris, annonces) — VestaScope
├── core/
│   ├── theme.dart            Couleurs, polices, VestaTextStyle (ThemeExtension)
│   └── formatters.dart       money() — 1 250 000 TND — et normalisation sans accents
├── models/listing.dart       Modèle d'annonce + 4 annonces de démo
├── data/                     Repositories (listing, auth, chat) — couche Firebase future
├── widgets/                  Logo, toast, carte d'annonce, illustration
└── modules/<module>/         screen → controller (le cas échéant)
    ├── auth/                 Connexion / Inscription / visiteur
    ├── search/               Liste + recherche + filtres (+ Favoris)
    ├── details/              Détail : héros, galerie, specs, carte, contact
    ├── publish/              Formulaire de publication (validation FR)
    ├── map/                  Carte stylisée + biens
    ├── chat/                 Messagerie (réponses automatiques de démo)
    ├── notifications/        Liste de notifications de démo
    └── profile/              Compte, statistiques, déconnexion
```

Chaque module est consommé par le contrôleur : les écrans n'accèdent jamais
directement aux données, ils passent par `VestaScope.of(context)`.

## Identité Android

Package : `com.vesta.flutter.vesta` (distinct de `com.vesta.reactnative`).

## Passer à Firebase (plus tard)

1. Déposer `google-services.json` dans `android/app/` (ignoré par git).
2. Ajouter les dépendances Firebase dans `pubspec.yaml`.
3. Réécrire `lib/data/*_repository.dart` avec Firestore/Auth/FCM en gardant
   les signatures d'interface actuelles.
