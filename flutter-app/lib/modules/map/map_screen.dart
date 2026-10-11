import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../core/formatters.dart';
import '../../core/theme.dart';
import '../../models/listing.dart';
import '../../widgets/brand.dart';
import '../../widgets/listing_illustration.dart';
import '../details/details_screen.dart';

/// Écran Carte : les biens positionnés sur une carte stylisée.
/// La carte réelle (Google Maps) sera branchée avec la clé API ; le
/// comportement et le style restent identiques.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = VestaScope.of(context);
    final listings = app.listings.all();

    return Scaffold(
      backgroundColor: VestaColors.shell,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(23, 34, 23, 25),
            decoration: const BoxDecoration(
              color: VestaColors.header,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(29)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLogo(),
                const SizedBox(height: 30),
                const Eyebrow('Explorer par région'),
                const SizedBox(height: 9),
                Text(
                  'La carte des\nbons plans.',
                  style: Theme.of(context).extension<VestaTextStyle>()!.serifStyle(32, height: 1.07, letterSpacing: -0.7),
                ),
              ],
            ),
          ),

          // Carte stylisée avec pastilles des biens.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Container(
              height: 320,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFDCE2EC), Color(0xFFECEAE0), Color(0xFFDCE2EC)],
                ),
              ),
              child: Stack(
                children: [
                  for (var i = 0; i < listings.length; i++)
                    Positioned(
                      left: _positions[i % _positions.length].$1,
                      top: _positions[i % _positions.length].$2,
                      child: _MapPin(listing: listings[i], onTap: () => _openDetails(context, listings[i])),
                    ),
                  const Positioned(
                    left: 12,
                    bottom: 12,
                    child: Text(
                      'Carte interactive dans l’application finale',
                      style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 10, color: Color(0xFF5A6B84)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Liste des biens sous la carte.
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              children: [
                for (final listing in listings) ...[
                  _MapListTile(listing: listing, onTap: () => _openDetails(context, listing)),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _openDetails(BuildContext context, Listing listing) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailsScreen(listingId: listing.id)),
    );
  }

  /// Positions approximatives des pins sur la carte de démo.
  static const _positions = <(double, double)>[
    (58, 46),
    (188, 118),
    (96, 208),
    (240, 232),
  ];
}

/// Pin cliquable sur la carte.
class _MapPin extends StatelessWidget {
  const _MapPin({required this.listing, required this.onTap});

  final Listing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: VestaColors.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Color(0x33173B37), blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: Text(
              money(listing.price),
              style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const Icon(Icons.place, size: 26, color: VestaColors.gold),
        ],
      ),
    );
  }
}

/// Ligne de la liste sous la carte.
class _MapListTile extends StatelessWidget {
  const _MapListTile({required this.listing, required this.onTap});

  final Listing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: VestaColors.borderCard),
        ),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(10), child: ListingIllustration(listing.image, width: 58, height: 58)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 13, fontWeight: FontWeight.w700, color: VestaColors.ink),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '⌖ ${listing.location}',
                    style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 11, color: VestaColors.muted3),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              money(listing.price),
              style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, fontWeight: FontWeight.w700, color: VestaColors.ink),
            ),
          ],
        ),
      ),
    );
  }
}
