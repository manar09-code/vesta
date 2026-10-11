# Vesta — React Native app

Version React Native de Vesta (TypeScript), calquée sur la maquette web
(`docs/mockups/`) : mêmes écrans, même thème (DM Sans / DM Serif Display,
palette navy `#13294B` / or `#C6973F` / crème `#F8F4EC`), même structure de
modules que la version Flutter. L'écran de connexion est refondu : héros navy
avec photo en arche, panneau crème, onglets segmentés et CTA doré.

**Mode démo** : aucun fichier de configuration Firebase n'est disponible pour
le moment, donc toutes les données (annonces, session, chat) vivent en mémoire.
Les écrans passent par des repositories (`src/data/`) qu'il suffira de réécrire
pour brancher Firebase.

## Démarrer

```sh
npm install

npm start          # Metro

# Dans une seconde fenêtre, avec un émulateur Android ou un appareil :
npm run android

# iOS (sur macOS, après bundle install && bundle exec pod install) :
npm run ios
```

## Vérifications

```sh
npx tsc --noEmit   # 0 erreur TypeScript
npm test           # 3 tests : écran de connexion, entrée sans compte, erreurs de formulaire
npm run lint       # 0 erreur ESLint
```

## Structure (C4 niveau 4)

```
App.tsx                   Point d'entrée : providers + RootGate (session) + pile de routes
src/
├── home_shell.tsx        Coquille 5 onglets (les onglets restent montés)
├── app_state.tsx         État global (session, favoris, annonces) — contexte React
├── navigation.tsx        Mini-navigateur (pile de routes), sans dépendance externe
├── core/
│   ├── theme.ts          Couleurs, polices, helpers de style
│   └── formatters.ts     money() — 1 250 000 TND — et normalisation sans accents
├── models/listing.ts     Modèle d'annonce + 4 annonces de démo
├── data/                 Repositories (listing, auth, chat) — couche Firebase future
├── controllers/          search, details, publish, chat (logique testable)
├── widgets/              Logo, toast, carte d'annonce, illustration, pictogrammes
└── screens/              auth, search, details, publish, map, chat,
                          notifications, profile
```

Navigation : `useNavigator()` empile `details`, `chat` et `notifications`
au-dessus des onglets ; la session est gérée par `RootGate`. Aucune dépendance
de navigation native n'a été ajoutée.

## Polices

- **Android** : `android/app/src/main/assets/fonts/` (DMSans.ttf,
  DMSerifDisplay.ttf) — utilisées via `fontFamily: 'DMSans'` / `'DMSerifDisplay'`.
- **iOS** : `UIAppFonts` est déjà déclaré dans `ios/Vesta/Info.plist` et les
  fichiers sont dans `ios/Vesta/Fonts/` — il reste à les ajouter au projet
  Xcode (glisser le dossier dans Xcode, cible Vesta) lors du premier build macOS.

## Identité Android

Application ID : `com.vesta.reactnative` (distinct de `com.vesta.flutter.vesta`).

## Passer à Firebase (plus tard)

1. Déposer `google-services.json` dans `android/app/` (ignoré par git) et
   `GoogleService-Info.plist` dans `ios/Vesta/`.
2. Installer `@react-native-firebase/app` (+ auth, firestore, messaging).
3. Réécrire `src/data/*_repository.ts` avec Firebase en gardant les signatures
   d'interface actuelles.
