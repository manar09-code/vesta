# Favorites

`useFavorites()` in `favoritesController.ts` provides the live saved-listing ids and optimistic heart toggles. Each component using the hook owns a Firestore listener; there is no favorites provider. The hook uses the existing auth context and calls `favoritesRepository`, the only module that accesses the `favorites` collection. Screens never access Firebase directly.
