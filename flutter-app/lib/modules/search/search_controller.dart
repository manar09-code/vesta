import 'package:flutter/widgets.dart';

import '../../app_state.dart';
import '../../models/listing.dart';

/// Filtres de l'écran de liste — miroir de l'état `state` + champs de la
/// maquette (recherche, transaction, type, prix maximum).
///
/// Nommé `SearchPageController` pour éviter la collision avec le widget
/// Material `SearchController`.
class SearchPageController extends ChangeNotifier {
  SearchPageController(this._app) {
    _app.addListener(refresh);
  }

  final AppState _app;

  String query = '';

  /// `all` | `vente` | `location`.
  String transaction = 'all';

  /// `all` | `Appartement` | `Villa`.
  String type = 'all';

  String maxPriceInput = '';
  bool filtersOpen = false;
  bool favoritesOnly = false;

  AppState get app => _app;

  bool get hasActiveFilters =>
      query.isNotEmpty || transaction != 'all' || type != 'all' || maxPriceInput.isNotEmpty;

  int? get _maxPrice => int.tryParse(maxPriceInput.replaceAll(RegExp(r'\s'), ''));

  List<Listing> get results => _app.filteredListings(
        query: query,
        transaction: transaction,
        type: type,
        maxPrice: _maxPrice,
        favoritesOnly: favoritesOnly,
      );

  void refresh() => notifyListeners();

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void setTransaction(String value) {
    transaction = value;
    notifyListeners();
  }

  void setType(String value) {
    type = value;
    notifyListeners();
  }

  void setMaxPrice(String value) {
    maxPriceInput = value;
    notifyListeners();
  }

  void toggleFilters() {
    filtersOpen = !filtersOpen;
    notifyListeners();
  }

  void resetFilters() {
    query = '';
    transaction = 'all';
    type = 'all';
    maxPriceInput = '';
    notifyListeners();
  }

  void setFavoritesOnly(bool value) {
    favoritesOnly = value;
    notifyListeners();
  }

  String get resultCountLabel {
    final count = results.length;
    return '$count bien${count > 1 ? 's' : ''} trouvé${count > 1 ? 's' : ''}';
  }

  @override
  void dispose() {
    _app.removeListener(refresh);
    super.dispose();
  }
}
