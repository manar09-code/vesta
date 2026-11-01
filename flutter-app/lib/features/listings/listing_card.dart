import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../favorites/favorite_button.dart';
import '../../l10n/generated/app_localizations.dart';
import 'listing.dart';
import 'listing_repository.dart';

/// Cover photo (base64) of a listing. Cached per listing id, so scrolling
/// back up does not read Firestore again.
final listingCoverPhotoProvider = FutureProvider.family<String?, String>(
  (ref, listingId) => ListingRepository().getCoverPhotoBase64(listingId),
);

/// Card used in the favorites list (and later in the search results).
class ListingCard extends ConsumerWidget {
  const ListingCard({super.key, required this.listing, this.onTap});

  final Listing listing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final unavailable = listing.isUnavailable;
    final cover = ref.watch(listingCoverPhotoProvider(listing.id)).value;

    ImageProvider? image;
    if (cover != null && cover.isNotEmpty) {
      try {
        image = MemoryImage(base64Decode(cover));
      } catch (_) {
        image = null; // bad base64: show the placeholder
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (image != null)
                    Image(
                      image: image,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    )
                  else
                    ColoredBox(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.home_work_outlined,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  if (unavailable) ...[
                    // Grey veil over the photo.
                    ColoredBox(color: Colors.black.withValues(alpha: 0.45)),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.favoritesUnavailable,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                  Positioned(
                    top: 8,
                    right: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: FavoriteButton(listingId: listing.id),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.city,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_formatPrice(listing.price)} ${listing.currency}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 250000 instead of 250000.0 when the price has no decimals.
  String _formatPrice(num price) {
    return price == price.roundToDouble()
        ? price.toInt().toString()
        : price.toString();
  }
}
