import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../core/theme.dart';
import '../models/listing.dart';
import 'listing_illustration.dart';

/// Carte d'annonce (liste et favoris) — même anatomy que la maquette :
/// visuel + badge + cœur, puis type, titre, localisation, prix et surface.
class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.listing,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onOpen,
  });

  final Listing listing;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = theme.extension<VestaTextStyle>()!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: VestaColors.borderCard),
        boxShadow: const [
          BoxShadow(color: Color(0x10213E34), blurRadius: 25, offset: Offset(0, 8)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ——— Visuel, badge et favori ———
          SizedBox(
            height: 185,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: onOpen,
                    child: ListingIllustration(listing.image),
                  ),
                ),
                Positioned(
                  top: 13,
                  left: 13,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      listing.transactionLabel,
                      style: const TextStyle(
                        fontFamily: VestaFonts.sans,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: VestaColors.badgeText,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: const Color(0xF2FFFFFF),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onToggleFavorite,
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isFavorite ? VestaColors.heart : VestaColors.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ——— Contenu ———
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        listing.type.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: VestaFonts.sans,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: VestaColors.goldCard,
                        ),
                      ),
                    ),
                    const Text(
                      '✦ Sélection Vesta',
                      style: TextStyle(
                        fontFamily: VestaFonts.sans,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: VestaColors.goldCard,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                GestureDetector(
                  onTap: onOpen,
                  child: Text(
                    listing.title,
                    style: body.serifStyle(21),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '⌖ ${listing.location}',
                  style: const TextStyle(
                    fontFamily: VestaFonts.sans,
                    fontSize: 11,
                    color: VestaColors.muted3,
                  ),
                ),
                const SizedBox(height: 13),
                Container(height: 1, color: VestaColors.borderCard),
                const SizedBox(height: 11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            child: Text(
                              money(listing.price),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: VestaFonts.sans,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: VestaColors.ink,
                              ),
                            ),
                          ),
                          if (!listing.isSale)
                            const Text(
                              ' / mois',
                              style: TextStyle(
                                fontFamily: VestaFonts.sans,
                                fontSize: 10,
                                color: VestaColors.muted3,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${listing.area} m² · ${listing.rooms} ch.',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontFamily: VestaFonts.sans,
                          fontSize: 11,
                          color: Color(0xFF5E6575),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
