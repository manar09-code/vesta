import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../listings/listing.dart';
import '../listings/listing_controller.dart';
import 'location_service.dart';

/// How many of the newest listings the map reads. Same idea as the search:
/// one small read, no index (see search_filters.dart).
const int mapListLimit = 100;

/// The listings to draw on the map: they have a position and are still
/// available. Pure function, easy to test.
List<Listing> listingsOnMap(Iterable<Listing> listings) => [
  for (final listing in listings)
    if (listing.hasLocation && !listing.isUnavailable) listing,
];

final mapListingsProvider = FutureProvider.autoDispose<List<Listing>>((
  ref,
) async {
  final all = await ref
      .watch(listingRepositoryProvider)
      .getLatestListings(limit: mapListLimit);
  return listingsOnMap(all);
});

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);
