# Vesta design tokens (VST-78)

The apps use only the colors, text styles and radius of the approved design. A screen or a component never writes a color directly: it uses a token from the theme of its app.

- Flutter: `flutter-app/lib/core/theme/app_colors.dart` (`AppColors`) and `app_theme.dart`.
- React Native: `react-native-app/src/core/theme.ts` (`theme.colors`, `theme.fontSizes`, `theme.spacing`, `theme.radius`).
- The check `node tools/check-colors.js` fails when a color is written outside these files (see `CONTRIBUTING.md`). The PR template has a checkbox for it.

## Source of the values

Figma is not used anymore. The reference is the PDF `Vesta screens VST-66 and VST-67` (16 screens: favorites, profile, publish, search, filters, map, messages, chat, notification, in French and Arabic). It contains images, not vector shapes, so the values below were measured on the images (390 dp wide, 3 pixels per dp): colors are within about 3 units per channel (JPEG), sizes and radius within about 1 to 2 dp. Manar confirms the final values.

## Colors

### Tokens in the code today

| Token | Hex | Flutter | React Native |
|---|---|---|---|
| primary | `#176AAB` | `AppColors.primary` | `theme.colors.primary` |
| navy | `#20394A` | `AppColors.navy` | `theme.colors.navy` |
| grey | `#6B777B` | `AppColors.grey` | `theme.colors.grey` |
| border | `#E5E5DF` | `AppColors.border` | `theme.colors.border` |
| sand | `#F0E7DA` | `AppColors.sand` | `theme.colors.sand` |
| terracotta | `#A65D42` | `AppColors.terracotta` | `theme.colors.terracotta` |
| white | `#FFFFFF` | `AppColors.white` | `theme.colors.white` |
| background | `#F7F3EB` | `AppColors.background` | `theme.colors.background` |
| error | `#A33B32` | Material error (generated) | `theme.colors.error` |

Offer type colors (`docs/offer-types.md`, section 5): Stay = primary, Rent = navy, Sale = terracotta, with `background` text on the ribbon.

### Colors measured in the mockups

| Role in the mockups | Measured | Code token | Status |
|---|---|---|---|
| Buttons, prices, links, selected chips, sent bubble | `#176AAB` | primary | same |
| Screen background | `#F7F3EB` | background | same |
| Cards, text fields, bottom bar, received bubble | `#FFFFFF` | white | same |
| Main text (titles, body, nav labels) | about `#1B1B1B` (near black) | navy `#20394A` | **different** |
| Secondary text (city, labels, time, previews) | about `#5B5855` (warm grey) | grey `#6B777B` | **different** |
| Border of text fields and chips | about `#D2CEC3` | border `#E5E5DF` | **different** |
| Segmented control background (language, offer type) | about `#EFEBE0` | sand `#F0E7DA` | close |
| Date chip in the chat | about `#E8E2D4` | none | missing |
| Error (text, red border, Log out) | about `#B3261E` | error `#A33B32` | **different** |
| Error banner background | about `#FBE9E7` | none | missing |
| Selected tab and empty-state circle (light blue) | about `#DCE8F4` | none | missing |
| Photo placeholders | about `#CFE1EF`, `#E3ECF5`, `#BDD3E8` | none | placeholder only |
| Avatar initials | `#176AAB`, about `#5C7F9D`, `#9A5B2F`, `#3F6E5A`, `#6A5B94` | none | missing |
| Terracotta | not visible in these screens | terracotta | not checked |

The map pins in the mockups are white price pills with dark text (selected pill in primary). The offer type pin colors of `docs/offer-types.md` do not appear in these screens.

## Radius

Measured on the corner curves (about 2 dp precision):

| Element | Mockups (dp) | Code today |
|---|---|---|
| Cards (favorites card, profile cards) | 16 | RN `lg` 20, `md` 12; Flutter: none |
| Rows inside a card (my listings) | 14 | none |
| Photo thumbnails | 12 | `md` 12 |
| Text fields | 10 | none |
| Chat bubbles | 16, with a 4 dp corner on the side of the sender | none |
| Bottom bar (top corners) | about 16 | none |
| Buttons, search field, chips, segmented control | fully rounded (pill) | RN `round` 999 |

RN today has `sm` 6, `md` 12, `lg` 20, `round` 999. Flutter has no radius token (Material defaults).

## Text styles

Sizes are measured from the height of the capital letters (about 1 dp precision). Weight is estimated from the stem width.

| Style | Size | Weight | Used for |
|---|---|---|---|
| top bar title | 20 | regular | Favoris, Recherche, Carte, Filtres |
| screen title | 20 | medium | empty-state title, profile name |
| title | 16 | medium | listing title, section title, row title |
| button | 16 | bold | button labels |
| body | 15 | regular | chat bubble text, search text |
| body small | 14 | regular | descriptions, previews, chip labels |
| price | 15 | bold | `240 TND` (primary color) |
| caption | 13 | regular | city and rooms, form labels |
| nav label | 12 | regular (selected: bold) | bottom bar, chat list subtitle |
| time | 11 | regular | chat time |

Code today: RN `fontSizes` are small 14, body 16, title 24, heading 30 (no weight tokens); Flutter uses the Material `textTheme`. The largest size in the mockups is 20, so the RN `title` 24 and `heading` 30 do not appear.

## Font and Arabic

- The Latin text looks like **Roboto** and the Arabic text like **Noto Sans Arabic** (checked by eye). These are the system fonts of Android, which both apps already use (neither app sets a `fontFamily`). No font file needs to be bundled.
- Sizes and weights do not depend on the language in the code (checked: no condition on the language for any text style). The Arabic screens of the mockups use the same layout and text styles as the French screens.

## Decisions for Manar

1. The mockup colors for the main text, the secondary text, the border and the error differ from the tokens in the code. Which one is right? If the mockups, the tokens `navy` (text), `grey`, `border` and `error` must change in both apps.
2. Missing tokens to add if the mockups are the reference: date chip, error banner, light blue, avatar colors.
3. Radius: the mockups use 10, 12, 14 and 16, the RN theme has 6, 12 and 20, Flutter has no radius token.
4. Text styles: the mockups have sizes 11 to 20, the RN theme has 14, 16, 24 and 30.
