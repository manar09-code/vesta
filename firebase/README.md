# Firebase
One Firebase project shared by both apps. Rules here are **deny-all placeholders**; the real rules are written in Sprint 1 (Firestore: Eya, Storage: Mahmoud, Auth review: Ahmed) and tested with the Firebase emulator.
Never commit service-account keys or the app config files.
## Firestore security rules (VST-33)

Rules for data model v3 (docs/data-model.md) are in `firestore.rules`.
`storage.rules` is no longer used since the decision of 8 Oct (photos are stored in Firestore).

### Run the emulator and the tests
1. Start the emulator: `cd firebase` then `firebase emulators:start --project demo-vesta`
   (Auth 9099, Firestore 8085, UI 4000)
2. In another terminal: `cd firebase/tests`, `npm install` (first time only), then `npm test`

Never run `firebase deploy` or `firebase login`. The project id `demo-vesta` keeps everything local.
The Emulator UI ignores the rules when you write data by hand: use the tests to check refusals.

### What the tests cover (45 tests)
Listings (3-letter currency, rentPeriod only for rent, propertyType list, photoCount 0 to 5), photos (ids p0 to p4, any free id, owner only, size limit, batch with the listing), private contact, favorites, conversations (id {listingId}_{buyerId}, other participant = listing owner, participantIds and listingId immutable), messages (no edit or delete).

### Auth and users tests (VST-34)
`tests/auth.test.js` (24 tests) covers the sign-in and `users` rules: a signed-out user can do nothing, a signed-in user can read public profiles, sign-up creates only `users/{uid}` and `users/{uid}/private/contact` for the user's own uid, nobody can update or delete another user's data, `displayName` and `photoBase64` are validated, and any collection not described in the data model is refused.
`npm test` runs both test files one after the other (same emulator, same project id).

### Known limits
- Rules check that photoCount is between 0 and 5, not that it equals the real number of photos.
- Deleting a listing without deleting its photos in the same batch leaves orphan photos (the app must delete them).
- The photo size limit is 280000 characters (about 200 KB once encoded in base64).
- Search indexes are added with VST-40 (`firestore.indexes.json` is empty for now).

## Photo contract for the app (VST-35)

Photos of a listing live in `listings/{listingId}/photos/{photoId}`.

- `photoId` must be `p0`, `p1`, `p2`, `p3` or `p4`. This enforces the maximum of 5 photos per listing. The id gives the display order (`p0` first). After a delete, a free id can be reused: the new photo then takes the position of that id.
- Fields: `base64` (a string of 1 to 280000 characters, without the `data:image/...` prefix) and `createdAt`. No other field is accepted.
- Compress on the phone before upload: about 800 px wide, JPEG, under 200 KB (about 273000 base64 characters).
- Adding or deleting a photo and updating `photoCount` on the listing must be done in the same batch.
- Deleting a listing: delete its photos in the same batch, otherwise they stay orphaned and nobody can delete them afterwards.
- Only the owner of the listing writes photos. Any signed-in user can read them.