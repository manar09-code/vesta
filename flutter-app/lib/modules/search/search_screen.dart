import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../core/theme.dart';
import '../../models/listing.dart';
import '../../widgets/brand.dart';
import '../../widgets/listing_card.dart';
import '../../widgets/toast.dart';
import '../details/details_screen.dart';
import 'search_controller.dart';

/// Écran liste — sert l'onglet « Explorer » (tous les biens) et
/// l'onglet « Favoris » (favoris uniquement), comme dans la maquette.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.favoritesOnly});

  /// true = onglet Favoris (titre et état vide adaptés).
  final bool favoritesOnly;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchPageController _controller;
  var _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _controller = SearchPageController(VestaScope.of(context))..addListener(_onChanged);
    _controller.setFavoritesOnly(widget.favoritesOnly);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _openDetails(Listing listing) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailsScreen(listingId: listing.id)),
    );
  }

  void _toggleFavorite(Listing listing) {
    final app = VestaScope.of(context);
    app.toggleFavorite(listing.id);
    VestaToast.show(
      context,
      app.isFavorite(listing.id)
          ? 'Bien ajouté aux favoris (mode démo).'
          : 'Bien retiré des favoris (mode démo).',
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final results = c.results;
    final emptyState = _EmptyState(controller: c, onAction: _onEmptyAction);

    return Scaffold(
      backgroundColor: VestaColors.shell,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _ListHeader(controller: c),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionHead(controller: c),
                _TransactionChips(controller: c),
                if (c.filtersOpen) _FilterPanel(controller: c),
                _ResultsRow(label: c.resultCountLabel),
                for (final listing in results) ...[
                  ListingCard(
                    listing: listing,
                    isFavorite: c.app.isFavorite(listing.id),
                    onToggleFavorite: () => _toggleFavorite(listing),
                    onOpen: () => _openDetails(listing),
                  ),
                  const SizedBox(height: 17),
                ],
                if (results.isEmpty) emptyState,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onEmptyAction() {
    final c = _controller;
    if (c.favoritesOnly && c.app.favorites.isEmpty) {
      // « Voir les annonces » : bascule l'écran courant en mode liste complète.
      c.setFavoritesOnly(false);
    } else {
      c.resetFilters();
    }
  }
}

/// En-tête vert : marque, pastille localisation, accroche et recherche.
class _ListHeader extends StatelessWidget {
  const _ListHeader({required this.controller});

  final SearchPageController controller;

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).extension<VestaTextStyle>()!;
    final favorites = controller.favoritesOnly;

    return Container(
      padding: const EdgeInsets.fromLTRB(23, 34, 23, 25),
      decoration: const BoxDecoration(
        color: VestaColors.header,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(29)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BrandLogo(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xA8FFFFFF),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: VestaColors.borderInput),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.place_outlined, size: 14, color: VestaColors.link),
                    SizedBox(width: 5),
                    Text(
                      'Tunisie',
                      style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 11, fontWeight: FontWeight.w700, color: VestaColors.ink),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 38),
          const Eyebrow('Votre prochain chapitre commence ici'),
          const SizedBox(height: 9),
          RichText(
            text: TextSpan(
              style: body.serifStyle(favorites ? 32 : 37, height: 1.07, letterSpacing: -0.7),
              children: favorites
                  ? const [
                      TextSpan(text: 'Vos biens\n'),
                      TextSpan(text: 'préférés.', style: TextStyle(color: VestaColors.goldEm, fontStyle: FontStyle.italic)),
                    ]
                  : const [
                      TextSpan(text: 'Le bon endroit\npour '),
                      TextSpan(text: 'vivre mieux.', style: TextStyle(color: VestaColors.goldEm, fontStyle: FontStyle.italic)),
                    ],
            ),
          ),
          const SizedBox(height: 26),
          _SearchBox(controller: controller),
        ],
      ),
    );
  }
}

/// Boîte de recherche.
class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.controller});

  final SearchPageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [BoxShadow(color: Color(0x10184239), blurRadius: 24, offset: Offset(0, 9))],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: VestaColors.ink),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: controller.setQuery,
              style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, color: VestaColors.ink),
              decoration: const InputDecoration(
                hintText: 'Ville, quartier ou type de bien',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Titre de section + bouton Filtres.
class _SectionHead extends StatelessWidget {
  const _SectionHead({required this.controller});

  final SearchPageController controller;

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).extension<VestaTextStyle>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Découvrez'),
              const SizedBox(height: 3),
              Text(controller.favoritesOnly ? 'Mes favoris' : 'Biens à explorer', style: body.serifStyle(25)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: controller.toggleFilters,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 38),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            side: const BorderSide(color: VestaColors.borderInput),
            foregroundColor: VestaColors.ink,
            textStyle: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 11, fontWeight: FontWeight.w700),
          ),
          icon: const Icon(Icons.tune, size: 16),
          label: const Text('Filtres'),
        ),
      ],
    );
  }
}

/// Chips de transaction : Tous les biens / À acheter / À louer.
class _TransactionChips extends StatelessWidget {
  const _TransactionChips({required this.controller});

  final SearchPageController controller;

  static const _options = [('Tous les biens', 'all'), ('À acheter', 'vente'), ('À louer', 'location')];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 17, bottom: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final (label, value) in _options) ...[
              _Chip(
                label: label,
                active: controller.transaction == value,
                onTap: () => controller.setTransaction(value),
              ),
              if (value != 'location') const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: active ? VestaColors.inkSoft : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: active ? VestaColors.inkSoft : VestaColors.borderInput),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: VestaFonts.sans,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : VestaColors.muted2,
          ),
        ),
      ),
    );
  }
}

/// Panneau de filtres avancés (type + prix maximum).
class _FilterPanel extends StatelessWidget {
  const _FilterPanel({required this.controller});

  final SearchPageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VestaColors.borderSoft),
        boxShadow: const [BoxShadow(color: Color(0x10173B37), blurRadius: 18, offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _Dropdown(
                  label: 'Type de bien',
                  value: controller.type,
                  onChanged: controller.setType,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _NumberField(controller: controller),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: controller.resetFilters,
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 3)),
            child: const Text('Réinitialiser les filtres', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({required this.label, required this.value, required this.onChanged});

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, fontWeight: FontWeight.w700, color: VestaColors.ink)),
        const SizedBox(height: 7),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: VestaColors.borderInput),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, color: VestaColors.ink),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('Tous')),
                DropdownMenuItem(value: 'Appartement', child: Text('Appartement')),
                DropdownMenuItem(value: 'Villa', child: Text('Villa')),
              ],
              onChanged: (v) => onChanged(v ?? 'all'),
            ),
          ),
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.controller});

  final SearchPageController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Prix maximum (TND)', style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, fontWeight: FontWeight.w700, color: VestaColors.ink)),
        const SizedBox(height: 7),
        SizedBox(
          height: 42,
          child: TextField(
            onChanged: controller.setMaxPrice,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, color: VestaColors.ink),
            decoration: const InputDecoration(
              hintText: 'Sans limite',
              contentPadding: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}

/// Ligne « N biens trouvés » + mention.
class _ResultsRow extends StatelessWidget {
  const _ResultsRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            key: const Key('result-count'),
            style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 11, fontWeight: FontWeight.w700, color: VestaColors.inkSoft),
          ),
          const Text('Choisis pour vous ✦', style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 11, color: VestaColors.muted4)),
        ],
      ),
    );
  }
}

/// État vide : aucun bien trouvé ou aucun favori.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.controller, required this.onAction});

  final SearchPageController controller;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final noFavorites = controller.favoritesOnly && controller.app.favorites.isEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          const Text('⌕', style: TextStyle(fontSize: 54, color: Color(0xFFCFC9B8), height: 1)),
          const SizedBox(height: 6),
          Text(
            noFavorites ? 'Aucun favori pour le moment' : 'Aucun bien trouvé',
            style: Theme.of(context).extension<VestaTextStyle>()!.serifStyle(23),
          ),
          const SizedBox(height: 7),
          Text(
            noFavorites ? 'Enregistrez un bien avec le cœur pour le retrouver ici.' : 'Essayez une autre ville ou élargissez vos filtres.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, color: VestaColors.muted),
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: onAction,
            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44), side: const BorderSide(color: VestaColors.inkSoft)),
            child: Text(noFavorites ? 'Voir les annonces' : 'Effacer les filtres'),
          ),
        ],
      ),
    );
  }
}
