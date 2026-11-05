import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../listings/listing.dart';
import '../listings/listing_repository.dart';
import 'search_filters.dart';

/// Wait this long after the last keystroke before filtering.
const Duration searchDebounce = Duration(milliseconds: 400);

/// How many listings the search reads (newest first). See search_filters.dart.
const int searchListLimit = 100;

/// The listings the search works on. Read once, then filtered in memory.
final searchableListingsProvider = FutureProvider<List<Listing>>(
  (ref) => ListingRepository().getLatestListings(limit: searchListLimit),
);

class SearchFiltersNotifier extends Notifier<SearchFilters> {
  Timer? _debounce;

  @override
  SearchFilters build() {
    ref.onDispose(() => _debounce?.cancel());
    return const SearchFilters();
  }

  /// Called on every keystroke: only the last one, 400 ms later, counts.
  void setCity(String text) {
    _debounce?.cancel();
    _debounce = Timer(searchDebounce, () {
      state = state.copyWith(city: text);
    });
  }

  void setPriceRange({num? min, num? max}) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void setListingType(String? type) {
    state = state.copyWith(listingType: type);
  }

  void setPropertyType(String? type) {
    state = state.copyWith(propertyType: type);
  }

  void reset() {
    _debounce?.cancel();
    state = const SearchFilters();
  }
}

final searchFiltersProvider =
    NotifierProvider<SearchFiltersNotifier, SearchFilters>(
      SearchFiltersNotifier.new,
    );

/// Listings after the filters. Loading and error come from the read.
final searchResultsProvider = Provider<AsyncValue<List<Listing>>>((ref) {
  final filters = ref.watch(searchFiltersProvider);
  return ref.watch(searchableListingsProvider).whenData(filters.apply);
});