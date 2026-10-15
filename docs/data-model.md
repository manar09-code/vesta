# Vesta Firestore data model (v3 draft, after Manar's and Eya's feedback)

Single reference for the Firestore collections used by both apps (Flutter and React Native).
Prices are stored as a number with a currency code. The currency code is read from the app config (TND) and is never hardcoded in the apps or in the rules.

| Collection | Document id | Fields (type) | Rules summary |
|---|---|---|---|
| `users` | Auth `uid` | `displayName` (string), `photoBase64` (string, optional, compressed, under 200 KB), `createdAt` (server timestamp) | Create/update/delete: the user only. Read: any signed-in user (public profile, shown in listings and chat). |
| `users/{uid}/private/contact` | `contact` | `email` (string), `phone` (string, optional) | Read/write: the user only. |
| `listings` | auto-id | `ownerId` (string), `title` (string), `description` (string), `price` (number), `currency` (string of 3 letters, from the app config, TND), `rentPeriod` (`"night"`, `"month"` or `"year"`, required only when `listingType` is `"rent"`), `listingType` (`"sale"` or `"rent"`), `propertyType` (string, see values below), `city` (string), `latitude` (number, optional), `longitude` (number, optional), `bedrooms` (number, optional), `bathrooms` (number, optional), `areaSqm` (number, optional, square meters), `photoCount` (number), `createdAt` (server timestamp), `updatedAt` (server timestamp) | Read: any signed-in user. Create: signed-in user with `ownerId == uid`. Update/delete: owner only. Optional numbers must be numbers when present. |
| `listings/{id}/photos` | fixed ids `p0` to `p4` | `base64` (string, compressed, under 200 KB), `createdAt` (server timestamp) | Read: signed-in user. Create/update/delete: listing owner only. The 5 fixed ids enforce the maximum of 5 photos. The id gives the display order. |
| `favorites` | `{uid}_{listingId}` | `userId` (string), `listingId` (string), `createdAt` (server timestamp) | Read/create/delete: the user only. |
| `conversations` | `{listingId}_{buyerId}` | `participantIds` (array of exactly 2 uids), `listingId` (string), `lastMessage` (string), `lastMessageAt` (server timestamp) | Read/create/update: participants only. |
| `conversations/{id}/messages` | auto-id | `senderId` (string), `text` (string), `createdAt` (server timestamp) | Read: participants (rules read the parent conversation). Create: participant with `senderId == uid`. No edit or delete. |

## `propertyType` values (final list)

`apartment`, `house`, `villa`, `studio`, `riad`, `guest_house`

The same list is used everywhere: data model, rules, filters and mockups.

## Decisions

- `messages` is a subcollection of `conversations` (simpler for realtime and rules).
- `currency` is a string of 3 letters filled from the app config (TND). The rules only check that it is 3 letters.
- Photos are stored as compressed base64 in `listings/{id}/photos` with fixed ids `p0` to `p4`, because rules cannot count documents (max 5, decision of 8 Oct). The field `order` is removed: the id gives the order.
- Search fields (`listingType`, `propertyType`, `price`, `city`, `createdAt`) are top-level fields of `listings`.
- `latitude`, `longitude`, `bedrooms`, `bathrooms` and `areaSqm` are optional. The map only shows listings that have coordinates.
- A conversation id is `{listingId}_{buyerId}`, so there is one conversation per buyer and per listing. `participantIds` always holds exactly 2 uids.
- The user profile has a public part (`users/{uid}`: name and photo, readable by any signed-in user, so names and photos show in listings and chat) and a private part (`users/{uid}/private/contact`: email and phone, readable only by the user).
- `createdAt` and `updatedAt` are server timestamps.

## Indexes (start, final list comes from the Search queries, VST-40)

- `listingType` + `price`
- `listingType` + `createdAt` (descending)
- `propertyType` + `createdAt` (descending)
- `city` + `price`
- `city` + `createdAt` (descending)

## Class diagram

See `docs/c4/level4-classes.png` (source: `docs/c4/level4-classes.mmd`).
