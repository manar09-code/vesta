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
- API keys are never committed. Google Maps is not used anymore (see "Map" below), so no map key is needed.
- Firebase config is not set up in this app yet. It comes in a later ticket.

## Project structure

Structure per module: `screen → controller → repository → service` (see C4 level 4).

## Map (OpenStreetMap)

The app will use OpenStreetMap for the map (VST-42): free, no API key, no billing. Decided on 8 Oct (VST-19).

Packages tested on a real phone (Redmi 2209116AG, Android 13, debug build):
- `flutter_map` 8.3.2
- `latlong2` 0.10.1
- `geolocator` 14.1.1

These packages were tested in a throwaway test app. They are not in `pubspec.yaml` yet: they are added when the map is built (VST-42).

Setup:
- Tile URL: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
- Set `userAgentPackageName: 'com.vesta.flutterapp'` on the `TileLayer`.
- Keep the attribution visible on the map: "© OpenStreetMap contributors" (`RichAttributionWidget`). Use `alignment: AttributionAlignment.bottomLeft` so it is not covered by a floating button at the bottom right.
- Android permissions in `AndroidManifest.xml`: `INTERNET`, `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`.
- `INTERNET` is only added to debug builds by default. Add it to the main manifest before the Google Play release build (VST-53).

Test results (throwaway test app, debug build on the phone):
- Map displays OSM tiles (Tunis), pan and zoom work: yes
- Marker displayed: yes
- Location permission asked and position found: yes (blue marker at the phone position, map recentered)
- Attribution: with the default placement (bottom right) the attribution button was hidden behind the floating button and could not be tapped. With `bottomLeft` it is visible and shows "© OpenStreetMap contributors".

Limits:
- The free OSM tile server is meant for light use (fine for a demo).
- No key to store, nothing secret to commit.

## Troubleshooting (Windows)

- If the project and the Pub cache are on different drives (for example project on `F:`, cache on `C:`), the Android build can fail with the Kotlin error "this and base files have different roots". Fix: add `kotlin.incremental=false` to `%USERPROFILE%\.gradle\gradle.properties` (your PC only, do not commit it), then run `flutter clean`.
- The first build downloads about 180 MB of Android engine files. On a slow connection it can take a long time. If it fails with a network error, run `flutter run` again: files already downloaded are kept.