import '../models/listing.dart';

/// Accès aux annonces. Implémenté en mémoire pour la démo ; sera doublé
/// d'une implémentation Firestore (cloud_firestore) une fois la
/// configuration Firebase disponible — les écrans ne changent pas.
abstract class ListingRepository {
  List<Listing> all();
  Listing? byId(String id);
  void add(Listing listing);
}

/// Repository de démonstration : données en mémoire, aucun réseau.
class DemoListingRepository implements ListingRepository {
  DemoListingRepository({List<Listing>? seed})
      : _items = List.of(seed ?? demoListings);

  final List<Listing> _items;

  @override
  List<Listing> all() => List.unmodifiable(_items);

  @override
  Listing? byId(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  void add(Listing listing) => _items.insert(0, listing);
}
