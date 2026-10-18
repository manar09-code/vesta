# Vesta brand assets (VST-65)

## Files

| File | Size | Use |
|---|---|---|
| `logo.png` | 1024×1024, transparent | Login screen, reports, slides |
| `app-icon-1024.png` | 1024×1024, full-bleed | Home-screen app icon (Flutter and React Native) |
| `play-icon-512.png` | 512×512 | Google Play store icon |
| `feature-graphic-1024x500.png` | 1024×500 | Google Play feature graphic |

The same files are used by the Flutter app (`flutter-app/assets/images/`) and the React Native app (`react-native-app/assets/`) so both apps look identical.

## Design

- Mark: a thin-line arched door with the wordmark "Vesta".
- App icon: the door in white on the brand blue, lines slightly thickened so it stays readable at 48 px.
- Logo and feature graphic: the door and wordmark in blue on cream.

## Colors

| Name | Hex |
|---|---|
| Primary blue | `#176AAB` |
| Background cream | `#F7F3EB` |

These are the Figma palette values, also used in `app_colors.dart` (Flutter) and `theme.ts` (React Native).

## How the logo was made

Generated with an online logo maker (logomaker.com), then cleaned up: background removed, recolored to the brand blue, and resized into the files above.

## License status

**Academic use only.** The logo comes from the free preview of an online logo maker (logomaker.com). Its commercial-use license was not purchased or confirmed, so these files are for the academic app and the demo only.

Before publishing on Google Play, replace them with an original design under the same file names (`logo.png`, `app-icon-1024.png`, `play-icon-512.png`, `feature-graphic-1024x500.png`) so no code change is needed.
## Still missing

- `logo.svg` (a clean vector export was not available).
