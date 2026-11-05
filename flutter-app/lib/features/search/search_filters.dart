import '../listings/listing.dart';

/// Filters of the search screen. Pure data and logic: no Firebase here,
/// so it is easy to test.
///
/// WHY THE FILTERING IS DONE IN THE APP (VST-40, point 3):
/// Firestore needs one composite index per filter combination, and a price
/// range forces the first sort on `price` (so no "newest first"). The
/// repository only reads the newest listings (no index needed) and this
/// class filters that small list. If the app grows to thousands of
/// listings, move the main filters into the Firestore query.
class SearchFilters {
  const SearchFilters({
    this.minPrice,
    this.maxPrice,
    this.city = '',
    this.listingType,
    this.propertyType,
  });

  final num? minPrice;
  final num? maxPrice;
  final String city; // free text, matched with "contains"
  final String? listingType; // 'sale' or 'rent', null = both
  final String? propertyType; // null = all

  static const Object _keep = Object();

  /// Pass an explicit null to clear a field; omit it to keep the value.
  SearchFilters copyWith({
    Object? minPrice = _keep,
    Object? maxPrice = _keep,
    String? city,
    Object? listingType = _keep,
    Object? propertyType = _keep,
  }) {
    return SearchFilters(
      minPrice: identical(minPrice, _keep) ? this.minPrice : minPrice as num?,
      maxPrice: identical(maxPrice, _keep) ? this.maxPrice : maxPrice as num?,
      city: city ?? this.city,
      listingType: identical(listingType, _keep)
          ? this.listingType
          : listingType as String?,
      propertyType: identical(propertyType, _keep)
          ? this.propertyType
          : propertyType as String?,
    );
  }

  /// Number of active filters (for a badge on the filter button).
  int get activeCount =>
      (minPrice != null || maxPrice != null ? 1 : 0) +
      (city.trim().isNotEmpty ? 1 : 0) +
      (listingType != null ? 1 : 0) +
      (propertyType != null ? 1 : 0);

  bool get isEmpty => activeCount == 0;

  bool matches(Listing listing) {
    if (minPrice != null && listing.price < minPrice!) return false;
    if (maxPrice != null && listing.price > maxPrice!) return false;
    if (listingType != null && listing.listingType != listingType) {
      return false;
    }
    if (propertyType != null && listing.propertyType != propertyType) {
      return false;
    }
    final query = city.trim().toLowerCase();
    if (query.isNotEmpty && !listing.city.toLowerCase().contains(query)) {
      return false;
    }
    return true;
  }

  /// Keeps the order of [listings] (already newest first).
  List<Listing> apply(List<Listing> listings) =>
      listings.where(matches).toList();
}