import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/auth_controller.dart';
import '../auth/require_sign_in.dart';
import '../listings/listing.dart';
import 'profile_avatar.dart';
import 'profile_controller.dart';
import 'profile_messages.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  /// Publishing needs an account: a guest gets the sign-in sheet first.
  Future<void> _publish(BuildContext context, WidgetRef ref) async {
    if (!await requireSignIn(context, ref)) return;
    if (context.mounted) context.push(AppRoutes.publish);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Listing listing,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profileDeleteConfirmTitle),
        content: Text(l10n.profileDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.profileCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.profileDeleteConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final controller = ref.read(profileControllerProvider.notifier);
    final ok = await controller.deleteListing(listing);
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    if (ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.profileListingDeleted)),
      );
    } else {
      final error = ref.read(profileControllerProvider).error;
      if (error != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(profileErrorMessage(l10n, error))),
        );
        controller.clearError();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authStateProvider).value;
    final signedIn = user != null;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        if (signedIn) ...[
          _ProfileHeader(email: user.email),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.editProfile),
            icon: const Icon(Icons.edit_outlined),
            label: Text(l10n.profileEditTitle),
          ),
          const SizedBox(height: 24),
        ],
        FilledButton.icon(
          onPressed: () => _publish(context, ref),
          icon: const Icon(Icons.add_home_work_outlined),
          label: Text(l10n.publishButton),
        ),
        if (signedIn) ...[
          const SizedBox(height: 24),
          Text(
            l10n.profileMyListings,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _MyListings(
            onDelete: (listing) => _confirmDelete(context, ref, listing),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: () => context.push(AppRoutes.settings),
          icon: const Icon(Icons.settings_outlined),
          label: Text(l10n.settingsTitle),
        ),
        if (!signedIn) ...[
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => requireSignIn(context, ref),
            child: Text(l10n.authLoginButton),
          ),
        ],
      ],
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  const _ProfileHeader({this.email});

  final String? email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myProfileProvider).value;
    return Column(
      children: [
        ProfileAvatar(photoBase64: profile?.photoBase64),
        const SizedBox(height: 12),
        Text(
          profile?.displayName ?? '',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (email != null && email!.isNotEmpty)
          Text(
            email!,
            style: Theme.of(context).textTheme.bodyMedium,
            textDirection: TextDirection.ltr,
          ),
      ],
    );
  }
}

class _MyListings extends ConsumerWidget {
  const _MyListings({required this.onDelete});

  final void Function(Listing listing) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final listings = ref.watch(myListingsProvider);
    final busy = ref.watch(profileControllerProvider).isLoading;

    return listings.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(l10n.profileListingsLoadError),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.profileNoListings),
          );
        }
        return Column(
          children: [
            for (final listing in items)
              Card(
                child: ListTile(
                  // Opens the details, like any listing of the Explore tab.
                  onTap: () => context.push(
                    AppRoutes.listingDetailPath(listing.id),
                  ),
                  title: Text(listing.title),
                  subtitle: Text(
                    '${listing.city} · ${listing.price} ${listing.currency}'
                    ' · ${listing.listingType == 'rent' ? l10n.publishTypeRent : l10n.publishTypeSale}',
                  ),
                  trailing: IconButton(
                    tooltip: l10n.profileDeleteListing,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: busy ? null : () => onDelete(listing),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
