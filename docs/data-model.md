# Vesta Firestore data model (v1)

Single reference for the Firestore collections used by both apps (Flutter and React Native).
Prices are stored as a number with the currency code `AED`.

| Collection | Document id | Fields (type) | Rules summary |
|---|---|---|---|
| `users` | Auth `uid` | `displayName` (string), `email` (string), `phone` (string, optional), `createdAt` (timestamp) | Create/update/delete: the user only. Read: any signed-in user. |
| `listings` | auto-id | `ownerId` (string), `title` (string), `description` (string), `price` (number), `currency` (string, always `"AED"`), `rentPeriod` (`"year"` or `"month"`, only for rent), `listingType` (`"sale"` or `"rent"`), `propertyType` (string), `city` (string), `latitude` (number), `longitude` (number), `bedrooms` (number), `bathrooms` (number), `areaSqft` (number), `photoCount` (number), `createdAt` (timestamp), `updatedAt` (timestamp) | Read: any signed-in user. Create: signed-in user with `ownerId == uid`. Update/delete: owner only. |
| `listings/{id}/photos` | auto-id | `base64` (string, compressed, under 200 KB), `order` (number), `createdAt` (timestamp) | Read: signed-in user. Create/delete: listing owner only. Maximum 5 photos per listing. |
| `favorites` | `{uid}_{listingId}` | `userId` (string), `listingId` (string), `createdAt` (timestamp) | Read/create/delete: the user only. |
| `conversations` | auto-id | `participantIds` (array of 2 uids), `listingId` (string), `lastMessage` (string), `lastMessageAt` (timestamp) | Read/create/update: participants only. |
| `conversations/{id}/messages` | auto-id | `senderId` (string), `text` (string), `createdAt` (timestamp) | Read: participants. Create: participant with `senderId == uid`. No edit or delete. |

## Decisions

- `messages` is a subcollection of `conversations` (simpler for realtime and rules).
- Price is a number plus `currency: "AED"`, never a string.
- Photos are stored as compressed base64 in `listings/{id}/photos` (max 5, decision of 8 Oct).
- Search fields (`listingType`, `propertyType`, `price`, `city`, `latitude`, `longitude`, `createdAt`) are top-level fields of `listings`.

## Indexes needed

- `listingType` + `price`
- `listingType` + `createdAt` (descending)
- `propertyType` + `createdAt` (descending)