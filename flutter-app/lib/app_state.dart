import 'package:flutter/material.dart';

import 'data/auth_repository.dart';
import 'data/listing_repository.dart';
import 'models/listing.dart';

/// État global de l'application : session, favoris, annonces publiées.
/// Exposé aux écrans via [VestaScope] (InheritedNotifier).
class AppState extends ChangeNotifier {
  AppState({
    required this.listings,
    required this.auth,
  });

  final ListingRepository listings;
  final AuthRepository auth;

  /// Utilisateur connecté (null = visiteur « sans compte »).
  String? userName;
  String? userEmail;
  bool get isSignedIn => userEmail != null;

  final Set<String> _favorites = <String>{};
  Set<String> get favorites => Set.unmodifiable(_favorites);

  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }

  void signIn({required String email, String? name}) {
    userEmail = email.trim();
    userName = (name == null || name.trim().isEmpty) ? null : name.trim();
    notifyListeners();
  }

  void signOut() {
    userName = null;
    userEmail = null;
    notifyListeners();
  }

  /// Publie une nouvelle annonce (en tête de liste) et notifie les écrans.
  void publish(Listing listing) {
    listings.add(listing);
    notifyListeners();
  }

  /// Annonces filtrées — logique identique à `renderListings()` de la maquette.
  List<Listing> filteredListings({
    String query = '',
    String transaction = 'all',
    String type = 'all',
    int? maxPrice,
    bool favoritesOnly = false,
  }) {
    final q = normalizedQuery(query);
    return listings.all().where((item) {
      if (favoritesOnly && !_favorites.contains(item.id)) return false;
      if (transaction != 'all' && item.transaction != transaction) return false;
      if (type != 'all' && item.type != type) return false;
      if (maxPrice != null && item.price > maxPrice) return false;
      if (q.isNotEmpty &&
          !normalizedQuery('${item.title} ${item.location} ${item.type}').contains(q)) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Même normalisation que `normalized()` côté web (minuscules + sans accents).
  static String normalizedQuery(String text) {
    const accents = 'ÀÁÂÃÄÅàáâãäåÇçÈÉÊËèéêëÌÍÎÏìíîïÑñÒÓÔÕÖØòóôõöøÙÚÛÜùúûüÝŸýÿŠšŽžÆæŒœß';
    const plain = 'AAAAAAaaaaaaacceeeeeeeeeiiiiiinnooooooooouuuuuuyyYySsZzAEaeOoes';
    final buffer = StringBuffer();
    for (final char in text.toLowerCase().split('')) {
      final index = accents.indexOf(char);
      buffer.write(index == -1 ? char : plain[index]);
    }
    return buffer.toString();
  }
}

/// Point d'accès à [AppState] depuis l'arbre de widgets.
class VestaScope extends InheritedNotifier<AppState> {
  const VestaScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VestaScope>()!.notifier!;
}
