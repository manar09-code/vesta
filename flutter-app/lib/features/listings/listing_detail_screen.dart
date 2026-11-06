import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/router/app_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/require_sign_in.dart';
import '../chat/chat_controller.dart';
import '../chat/chat_repository.dart';
import 'listing_controller.dart';
import 'listing.dart';
/// Details of one listing (VST-73, part 1): photos, price, city, facts and
/// description. Read only. The favorite heart and the contact buttons are
/// added later by their own tickets, in the slots marked SLOT below.
class ListingDetailScreen extends ConsumerWidget {
  const ListingDetailScreen({super.key, required this.listingId});

  final String listingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(listingDetailProvider(listingId));

    return detail.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _Message(
        text: l10n.listingDetailLoadError,
        actionLabel: l10n.listingDetailRetry,
        onAction: () => ref.invalidate(listingDetailProvider(listingId)),
      ),
      data: (data) => data == null
          ? _Message(text: l10n.listingDetailNotFound)
          : _DetailBody(data: data),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.actionLabel, this.onAction});

  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.data});

  final ListingDetail data;

  /// "Contact owner" (VST-44): a guest signs in first, then the chat of this
  /// listing opens. The owner never talks to himself.
  Future<void> _contactOwner(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!await requireSignIn(context, ref)) return;
    if (!context.mounted) return;
    try {
      final id =
          ref.read(chatRepositoryProvider).conversationIdForListing(data.listing);
      context.push(AppRoutes.chatRoomPath(id));
    } on ChatFailure catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text(
          e.error == ChatError.ownListing
              ? l10n.chatOwnListing
              : l10n.chatContactError,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final listing = data.listing;
    final myUid = ref.watch(myUidProvider);
    final isOwner = myUid != null && myUid == listing.ownerId;

    return ListView(
      children: [
        _PhotoGallery(
          photos: data.photos,
          emptyLabel: l10n.listingDetailNoPhoto,
        ),
        if (listing.isUnavailable)
          Container(
            width: double.infinity,
            color: theme.colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.favoritesUnavailable,
              style: theme.textTheme.labelLarge,
            ),
          ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _priceText(l10n, listing),
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // SLOT: favorite heart (VST-46, Mahmoud)
                ],
              ),
              // SLOT: Call and WhatsApp buttons under the price (VST-79,
              // Mahmoud). A guest must sign in first (requireSignIn).
              if (!isOwner) ...[
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => _contactOwner(context, ref),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: Text(l10n.chatContactOwner),
                ),
              ],
              const SizedBox(height: 8),
              Text(listing.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                listing.city,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (listing.bedrooms != null)
                    Chip(
                      label: Text(
                        '${l10n.listingDetailBedrooms}: ${_number(listing.bedrooms!)}',
                      ),
                    ),
                  if (listing.bathrooms != null)
                    Chip(
                      label: Text(
                        '${l10n.listingDetailBathrooms}: ${_number(listing.bathrooms!)}',
                      ),
                    ),
                  if (listing.areaSqm != null)
                    Chip(
                      label: Text(
                        '${l10n.listingDetailArea}: ${_number(listing.areaSqm!)}',
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(listing.description, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}

/// formatPrice is the only function that formats a price. The unit is added
/// for a stay (night) and for a rental (month or year). The offer type comes
/// from offerTypeOf: the rule is not written a second time here.
String _priceText(AppLocalizations l10n, Listing listing) {
  final price = formatPrice(listing.price, currency: listing.currency);
  switch (offerTypeOf(listing)) {
    case OfferType.sale:
      return price;
    case OfferType.stay:
      return '$price ${l10n.listingDetailPerNight}';
    case OfferType.rent:
      switch (listing.rentPeriod) {
        case 'year':
          return '$price ${l10n.listingDetailPerYear}';
        case 'month':
          return '$price ${l10n.listingDetailPerMonth}';
        default:
          return price;
      }
  }
}

/// 3.0 is shown as 3.
String _number(num value) =>
    value == value.roundToDouble() ? value.toInt().toString() : '$value';

class _PhotoGallery extends StatefulWidget {
  const _PhotoGallery({required this.photos, required this.emptyLabel});

  final List<Uint8List> photos;
  final String emptyLabel;

  @override
  State<_PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<_PhotoGallery> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.photos.isEmpty) {
      return AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          color: theme.colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.home_work_outlined, size: 48),
              const SizedBox(height: 8),
              Text(widget.emptyLabel),
            ],
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.photos.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => Image.memory(
              widget.photos[i],
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image_outlined)),
            ),
          ),
          if (widget.photos.length > 1)
            PositionedDirectional(
              bottom: 8,
              end: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${_index + 1} / ${widget.photos.length}'),
              ),
            ),
        ],
      ),
    );
  }
}
