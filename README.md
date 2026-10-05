# Vesta: Real Estate & Homes

Mobile app to search, view and publish real-estate listings (sale and rent), built **twice**: with **Flutter** and with **React Native**, on one shared **Firebase** backend.

Mini-project: *Application Mobile Services Immobilier* — Wahid Hamdi — due **24 Nov 2026, 08:30**. Code freeze: **17 Nov 2026**.

## Team
Manar · Eya · Ahmed · Mahmoud

## Repository layout
```
vesta/
├── flutter-app/         Flutter version (Dart)
├── react-native-app/    React Native version (JavaScript/TypeScript)
├── firebase/            Firestore + Storage security rules
├── docs/
│   ├── c4/              C4 model, levels 1-4
│   ├── jira/            Jira backlog CSV
│   └── vesta_plan_de_travail.pdf
└── scripts/             Repo/GitHub setup helpers
```

## MVP features
Auth · Search with filters · Listing details with photos · Publish listings · Map and geolocation · Chat · Favorites · Profile · Push notifications.

## Architecture (see `docs/c4/`)
Both apps share the same module structure: Auth, Search, Listing details, Publish, Map, Chat, Favorites, Profile, Notifications, and a single data layer in front of Firebase (Auth, Firestore, Storage, FCM) and Google Maps. No module talks to Firebase directly.

## Getting started
1. Clone: `git clone <repo-url> && cd vesta && git checkout develop`
2. Ask Manar for the Firebase project access, then download **your own copy** of `google-services.json` (Android) into the app's `android/app/` folder. It is git-ignored, never commit it.
3. Flutter: see `flutter-app/README.md` · React Native: see `react-native-app/README.md`.

## Workflow
Read [CONTRIBUTING.md](CONTRIBUTING.md). Tasks live in Jira (project key **VST**).
