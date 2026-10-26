# Vesta offer types: sale, rent, stay (spec, VST-100)

Vesta is an app to **buy, rent, sell and stay** in Tunisia: houses, apartments, villas, riads, guest houses, Airbnbs, land and commercial places. This page is the single reference for the product behaviour in **both apps** (Flutter for Google Play, React Native for the academic demo). The data model (`docs/data-model.md`) and the rules (`firebase/firestore.rules`) are changed from this page in VST-74.

## 1. The three offer types

The Firestore fields already exist and **do not change**: `listingType` (`sale` | `rent`) and `rentPeriod` (`night` | `month` | `year`, required when rent). The three offer types are a **product view** on those two fields. No `offerType` field is stored.

| Offer type | Stored as | Price shown as | Who | Main contact |
|---|---|---|---|---|
| **Sale** | `listingType = sale` | `120 000 TND` | Seller to buyer | Chat, call, WhatsApp, visit request (S3) |
| **Rent** | `listingType = rent` and `rentPeriod` = `month` or `year` | `900 TND / month` | Landlord to tenant | Chat, call, WhatsApp, visit request (S3) |
| **Stay** | `listingType = rent` and `rentPeriod = night` | `150 TND / night` | Host to guest | Chat, call, WhatsApp, booking request (S3) |

Both apps use one helper, `offerTypeOf(listing)`, that returns `sale`, `rent` or `stay` from those two fields. Nobody re-implements the rule inside a screen.

## 2. Property types

Existing values (do not rename): `apartment`, `house`, `villa`, `studio`, `riad`, `guest_house`.
**New values (rules change in VST-74):** `land`, `commercial` (shop or office).

| Offer type | Allowed property types |
|---|---|
| Stay | `guest_house`, `riad`, `apartment`, `villa`, `studio`, `house` |
| Rent | `apartment`, `house`, `villa`, `studio`, `riad`, `commercial` |
| Sale | all of them, including `land` and `commercial` |

## 3. Fields by offer type

R = required, O = optional, - = not used. Existing fields are in **bold**.

| Field | Sale | Rent | Stay | Note |
|---|---|---|---|---|
| **title, description, price, currency, city** | R | R | R | description at least 40 characters |
| **propertyType** | R | R | R | see section 2 |
| **latitude, longitude** | O | O | O | map shows only listings with coordinates |
| **bedrooms, bathrooms, areaSqm** | R (area) | R (area) | O | |
| 1 to 5 photos | R | R | R | at least 1 |
| `contactPhone` (E.164 `+216XXXXXXXX`) | R | R | R | shown only to signed-in users |
| `whatsappEnabled` (bool) | O | O | O | default false |
| `status` | `available`, `reserved`, `sold`, `hidden` | `available`, `reserved`, `rented`, `hidden` | `available`, `unavailable`, `hidden` | default `available` |
| `negotiable` (bool) | O | - | - | |
| `yearBuilt` (number) | O | - | - | |
| `documentsNote` (string, max 200) | O | - | - | text only, no upload ("title deed available") |
| `furnished` (bool) | - | R | O | |
| `depositMonths` (number) | - | O | - | |
| `availableFrom` (date) | - | O | - | |
| `minMonths` (number) | - | O | - | |
| `maxGuests`, `beds` (numbers) | - | - | R | |
| `amenities` (array of keys) | - | O | O | `wifi`, `ac`, `heating`, `kitchen`, `parking`, `pool`, `breakfast`, `washing_machine`, `tv`, `garden` |
| `checkIn`, `checkOut` (text `HH:mm`) | - | - | O | |
| `houseRules` (array of keys) | - | - | O | `no_smoking`, `no_pets`, `no_parties`, `quiet_hours` |
| `minNights` (number) | - | - | O | default 1 |
| `viewCount` (number) | O | O | O | dashboard, Sprint 3, +1 per user per day |
| `verified` (bool) | O | O | O | set only by Manar in the console, "Verified" badge |

The phone is stored **on the listing** (`contactPhone`), not in `users/{uid}/private/contact`, because other users must read it. The rules let any **signed-in** user read it; guests never get it from the app. The number is prefilled from the profile when publishing and the owner can change it per listing.

## 4. Behaviour rules (both apps)

1. **Publish:** the first step is "What do you want to do?" with three choices: Sell / Rent out / Offer a stay. The next fields depend on the choice. Changing the choice clears the fields that no longer apply.
2. **Cards:** photo, title, city, price with its unit, ribbon with the offer type.
3. **Search:** three tabs **Buy / Rent / Stay** are the first filter. Price slider unit follows the tab. Only `status = available` listings appear in search, map and home.
4. **Map:** pins use the offer type color. Tap shows a mini card.
5. **Details:** the "key facts" row depends on the type (section 3). Contact buttons sit under the price.
6. **Statuses:** the owner changes the status in "My listings". `sold` and `rented` stay visible to people who favorited or chatted about the listing, with a ribbon, and disappear from search.
7. **Booking (stay) and visit request (sale, rent):** Sprint 3 (VST-92).
8. **Guests** can browse, search and read details. Favorite, chat, contact numbers, publish and requests ask to sign in and come back to the same screen.
9. **Every user can publish.** There is no buyer/owner role.

## 5. Colors (Figma theme only)

| Offer type | Color | Hex |
|---|---|---|
| Stay | primary blue | `#176AAB` |
| Rent | navy | `#20394A` |
| Sale | terracotta | `#A65D42` |

Ribbons use the color as background with cream text (`#F7F3EB`). No other color is added.

## 6. Labels (first version, the glossary ticket VST-77 validates the final wording)

| Key | English | Français | العربية (تونسي) |
|---|---|---|---|
| `offer.sale` | For sale | À vendre | للبيع |
| `offer.rent` | For rent | À louer | للكراء |
| `offer.stay` | Stay | Séjour | إقامة |
| `tab.buy` | Buy | Acheter | شراء |
| `tab.rent` | Rent | Louer | كراء |
| `tab.stay` | Stay | Séjourner | إقامة |
| `unit.night` | / night | / nuit | / ليلة |
| `unit.month` | / month | / mois | / شهر |
| `unit.year` | / year | / an | / سنة |
| `status.sold` | Sold | Vendu | مباع |
| `status.rented` | Rented | Loué | مكري |
| `status.reserved` | Reserved | Réservé | محجوز |
| `field.furnished` | Furnished | Meublé | مفروش |
| `field.negotiable` | Negotiable | Négociable | قابل للتفاوض |

Numbers and `TND` stay left-to-right inside Arabic sentences; `formatPrice` is the only function that formats a price.

## 7. What each ticket does with this page

| Ticket | Uses |
|---|---|
| VST-74 data model + rules | sections 2, 3 (new fields, new property types, status values per type, phone format) |
| VST-93 UI kit | section 5 colors, `OfferTypeBadge`, `PriceText`, `KeyFactsRow` |
| VST-73, VST-81 | sections 3 and 4 (publish, cards, details) |
| VST-40 | section 4.3 (tabs and filters) |
| VST-42 | section 4.4 and 5 (pins) |
| VST-96 | section 3 `status` per type |
| VST-79 | contact rules |
| VST-77, VST-70 | section 6 labels |
| VST-92 (S3) | booking for stay, visit request for sale and rent |
