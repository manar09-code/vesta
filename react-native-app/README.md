# Vesta — React Native app (VST-22)

Point de départ React Native de Vesta : une application « hello world »
qui démarre sur Expo (SDK 57) et s'ouvre dans **Expo Go**.

- **Package Android / bundle iOS** : `com.vesta.rnapp` (celui enregistré
  dans Firebase).
- Aucun écran ni contrôleur pour l'instant : ils arrivent en Sprint 2
  avec la structure commune `screen → controller → repository → service`
  (voir C4 niveau 4).

## Démarrer

```sh
npm install

npm start          # Metro / serveur Expo (clear cache : npm start -- -c)
```

Scanne le QR code affiché avec **Expo Go** (même Wi-Fi que le PC), ou saisis
`exp://<IP-du-pc>:8081` manuellement dans l'application.

Build natif classique (sans Expo Go) : `npm run android` / `npm run ios`.

## Tests

```sh
npm test     # Jest
npx tsc --noEmit
```
## Test carte OSM dans Expo Go (VST-19)

**Date :** 12/10/2026
**Appareil :** Redmi (Android), Expo Go, SDK 57
**Paquet testé :** react-native-maps 1.27.2

### Résultat

La carte ne s'affiche pas sur Android dans Expo Go. Le journal Android
(`adb logcat`) montre une erreur « Authorization failure » du Google
Android Maps SDK pour le package `host.exp.exponent` (Expo Go).

### Explication

Sur Android, react-native-maps utilise le SDK Google Maps, même avec
`mapType="none"` et des tuiles OSM (`UrlTile`). Expo Go embarque une clé
restreinte à son propre package, qui ne peut pas être utilisée par Vesta.

### Ce que ce test ne prouve pas

Il ne dit rien sur une version compilée de l'app avec une clé Vesta
restreinte (package + SHA-1). Ce test reste à faire en Sprint 1.

### Options pour la suite

1. Compilation native + clé Google restreinte (plan initial VST-19).
2. Carte OSM avec Leaflet dans une WebView (devrait fonctionner dans Expo Go (non testé)).
3. MapLibre (OSM sans Google), qui demande une compilation native.

### Dépannage rencontré

Si Expo Go affiche « Cannot connect to Expo CLI » (téléphone en 4G ou
Wi-Fi partagé) : lancer `adb reverse tcp:8081 tcp:8081`, puis ouvrir
`exp://localhost:8081` dans Expo Go.

Aucune clé API n'est stockée dans le dépôt.