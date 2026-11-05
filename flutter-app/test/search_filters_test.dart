import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/features/listings/listing.dart';
import 'package:flutterapp/features/search/search_filters.dart';
import 'package:flutterapp/features/search/search_filters_notifier.dart';

Listing _listing({
  required String id,
  num price = 100,
  String listingType = 'sale',
  String propertyType = 'apartment',
  String city = 'Tunis',
}) {
  return Listing(
    id: id,
    ownerId: 'owner',
    title: 't$id',
    description: '',
    price: price,
    currency: 'TND',
    listingType: listingType,
    propertyType: propertyType,
    city: city,
    status: 'available',
    photoCount: 1,
  );
}

void main() {
  final all = [
    _listing(id: 'a', price: 500, listingType: 'rent', city: 'Sousse'),
    _listing(id: 'b', price: 900000, propertyType: 'villa', city: 'Tunis'),
    _listing(id: 'c', price: 300, listingType: 'rent', city: 'Sousse'),
    _listing(id: 'd', price: 250000, propertyType: 'house', city: 'Sfax'),
  ];

  List<String> ids(SearchFilters f) => f.apply(all).map((l) => l.id).toList();

  test('no filter keeps everything, in the same order', () {
    expect(ids(const SearchFilters()), ['a', 'b', 'c', 'd']);
  });

  test('price range', () {
    expect(ids(const SearchFilters(minPrice: 300, maxPrice: 500)), ['a', 'c']);
    expect(ids(const SearchFilters(minPrice: 400000)), ['b']);
  });

  test('city: contains, case-insensitive', () {
    expect(ids(const SearchFilters(city: 'sou')), ['a', 'c']);
    expect(ids(const SearchFilters(city: '  TUN ')), ['b']);
  });

  test('listing type', () {
    expect(ids(const SearchFilters(listingType: 'rent')), ['a', 'c']);
  });

  test('property type', () {
    expect(ids(const SearchFilters(propertyType: 'villa')), ['b']);
  });

  test('combination of 3 filters', () {
    const f = SearchFilters(
      city: 'sousse',
      listingType: 'rent',
      maxPrice: 400,
    );
    expect(ids(f), ['c']);
    expect(f.activeCount, 3);
  });

  test('copyWith clears a field with null and keeps it when omitted', () {
    const f = SearchFilters(minPrice: 10, listingType: 'rent');
    expect(f.copyWith(minPrice: null).minPrice, isNull);
    expect(f.copyWith(city: 'x').minPrice, 10);
  });

  test('city is applied only 400 ms after the last keystroke', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(searchFiltersProvider.notifier);

    notifier.setCity('s');
    notifier.setCity('so');
    notifier.setCity('sou');
    expect(container.read(searchFiltersProvider).city, '');

    await Future<void>.delayed(const Duration(milliseconds: 500));
    expect(container.read(searchFiltersProvider).city, 'sou');
  });
}
