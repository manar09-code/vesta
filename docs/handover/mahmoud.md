\# Handover : Mahmoud



\## Tickets réalisés

\- VST-79 : boutons Appeler / WhatsApp sur la fiche annonce, champ téléphone / WhatsApp dans le formulaire Publier (PR #66)

\- Profil : écran Profil de l'utilisateur connecté

\- Favoris : ajout, retrait et liste des annonces favorites

\- Tests des règles Firestore (dont la règle `notAnonymous` sur les infos de contact)

\- Release Google Play de l'application Android



\## Écrans

\- Fiche annonce : boutons Appeler et WhatsApp

\- Formulaire Publier : champ téléphone / WhatsApp avec validation

\- Profil : informations de l'utilisateur connecté

\- Favoris : liste des annonces enregistrées



\## Fichiers et dossiers principaux

\- `phone\_utils.dart` : normalisation et validation des numéros tunisiens (`formatPhone`)

\- Widget `ContactButtons` : boutons Appeler et WhatsApp (via `url\_launcher`)

\- Repository des annonces : enregistrement du téléphone à la publication

\- `AndroidManifest.xml` : déclarations `queries` pour lancer l'appel et WhatsApp

\- `l10n/` : fichiers de traduction en / fr / ar (contact inclus)

\- `tools/check-colors.js` : vérification des couleurs du design



\## Données utilisées

\- Profil : données de l'utilisateur connecté, lues depuis Firestore via un provider

\- Favoris : liste des annonces enregistrées par chaque utilisateur

\- `listings/{id}/contact/info` : numéro de téléphone, séparé du document de l'annonce et lisible seulement par les utilisateurs non anonymes

\- Règles Firestore : testées avec des tests automatisés (accès autorisé / refusé selon l'utilisateur)

\- Release Google Play : build Android signé, puis publication via la Play Console. Aucune clé, mot de passe ni emplacement du keystore n'est écrit dans ce document ni dans le dépôt.



\## Comment tester

1\. Ouvrir une annonce : les boutons Appeler et WhatsApp s'affichent.

2\. Appuyer sur Appeler puis WhatsApp : le numéro normalisé s'ouvre dans l'application du téléphone.

3\. Publier une annonce avec un numéro valide, puis avec un numéro invalide : le formulaire refuse l'invalide.

4\. Ouvrir Profil et Favoris, ajouter puis retirer un favori.

5\. Lancer `flutter analyze`, `flutter test` (79 tests) et `node tools/check-colors.js`.

6\. Tester sur un

