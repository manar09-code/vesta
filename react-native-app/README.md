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
