# Handover : Mahmoud

## Tickets réalisés

- VST-79 : boutons Appeler / WhatsApp sur la fiche annonce, champ téléphone / WhatsApp dans le formulaire Publier (PR #66)
- VST-46 : Favoris (ajout, retrait, liste, filtres Tous / Acheter / Louer / Séjourner), PR #40
- VST-48 : Profil (modification du nom et de la photo, mes annonces), PR #46
- Tests des règles Firestore de l'application
- Build Android signé pour Google Play (version 1.0.0+1 publiée en test fermé)

## Écrans

- Fiche annonce : boutons Appeler et WhatsApp
- Formulaire Publier : champ téléphone / WhatsApp avec validation
- Profil : informations de l'utilisateur connecté, mes annonces
- Favoris : liste des annonces enregistrées, avec filtres

## Fichiers et dossiers principaux

- `phone_utils.dart` : normalisation et validation des numéros tunisiens (`formatPhone`)
- Widget `ContactButtons` : boutons Appeler et WhatsApp (via `url_launcher`)
- Repository des annonces : enregistrement du téléphone à la publication
- `AndroidManifest.xml` : déclarations `queries` pour lancer l'appel et WhatsApp
- `l10n/` : fichiers de traduction en / fr / ar (contact inclus)
- `tools/check-colors.js` : vérification des couleurs du design

## Données utilisées

- Profil : données de l'utilisateur connecté, lues depuis Firestore via un provider
- Favoris : un document par favori, `favorites/{uid}_{listingId}`
- `listings/{id}/contact/info` : numéro de téléphone, séparé du document de l'annonce. Il est lisible seulement par un utilisateur **connecté** (règle `signedIn()`).
- Règles Firestore : testées avec des tests automatisés (accès autorisé / refusé selon l'utilisateur)
- Release Google Play : build Android signé, puis publication via la Play Console. Aucune clé, mot de passe ni emplacement du keystore n'est écrit dans ce document ni dans le dépôt.

## État de la release Google Play

- L'application est en **test fermé** (canal Alpha), pas encore en production.
- La version publiée en test fermé est la 1.0.0 (code de version 1). La version 1.0.0+2 n'est pas encore envoyée : elle attend la clé d'upload.
- La demande d'accès à la production n'est pas encore faite.

## Comment tester

1. Ouvrir une annonce : les boutons Appeler et WhatsApp s'affichent.
2. Appuyer sur Appeler puis WhatsApp : le numéro normalisé s'ouvre dans l'application du téléphone.
3. Publier une annonce avec un numéro valide, puis avec un numéro invalide : le formulaire refuse l'invalide.
4. Ouvrir Profil et Favoris, ajouter puis retirer un favori.
5. Lancer `flutter analyze`, `flutter test` ([À VÉRIFIER] tests) et `node tools/check-colors.js`.
6. Tester sur un téléphone Android réel : appel, WhatsApp, langue arabe (écran inversé, numéros restant de gauche à droite).

## Limites connues

- **Règle `notAnonymous` pas encore déployée** : dans `firestore.rules` de `develop`, `contact/info` utilise `signedIn()`. Un visiteur non connecté est bloqué (test automatisé), mais un compte Firebase **anonyme** compte comme connecté et peut lire le numéro. La règle `notAnonymous()` a été écrite et testée sur une ancienne branche (PR #44), jamais mergée. Elle reste à reporter dans `develop` (les règles sont déployées par Manar).
- Pas de téléphone Android réel utilisé pour mes tests : validés sur Chrome, et sur la tablette de Manar.
- Clé d'upload Google Play détenue par Manar : je ne peux pas signer un nouveau build seul.
- Éditer une annonce existante : pas d'écran.

## Questions de VST-113

[À VÉRIFIER] Les 3 questions demandées dans le ticket VST-113 : à compléter avec le texte du ticket.