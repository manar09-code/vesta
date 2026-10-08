# Vesta — Flutter app

Flutter version of the Vesta real estate app (buy / rent). Created in Sprint 0 (Eya) for ticket VST-21.

## Requirements

- Flutter 3.47.5 (stable). Check yours with `flutter --version`.
- Android Studio with the Android SDK. `flutter doctor` must show a green "Android toolchain".
- An Android phone with USB debugging enabled (a real device is required to validate tickets).

## Android package

`com.vesta.flutterapp`

This is the package registered in Firebase. Do not change it. 

## Run the app

From the `flutter-app/` folder, with the phone plugged in and unlocked:

```
flutter pub get
flutter devices
flutter run -d <device-id>
```

Or in one line: `flutter pub get && flutter run`

Expected result: a white screen with the word "Vesta" in the center.

The first build downloads about 180 MB of Android components and can take 10 to 25 minutes on a slow connection. Do not close the terminal. If it fails with a network error, run `flutter run` again: files already downloaded are kept.

## Secrets (never commit)

- `google-services.json` and `local.properties` are never committed.
- API keys (for example Google Maps) are never committed. Ask Manar for them privately.
- Firebase config is not set up in this app yet. It comes in a later ticket.

## Project structure

Structure per module: `screen → controller → repository → service` (see C4 level 4).