import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/locale_provider.dart';
import '../../core/router/app_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.languageLabel,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          // Language names are always written in their own language.
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'en', label: Text('English')),
              ButtonSegment(value: 'fr', label: Text('Français')),
              ButtonSegment(value: 'ar', label: Text('العربية')),
            ],
            selected: {current},
            onSelectionChanged: (selection) => ref
                .read(localeProvider.notifier)
                .setLocale(Locale(selection.first)),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.publish),
            icon: const Icon(Icons.add_home_work_outlined),
            label: Text(l10n.publishButton),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            child: Text(l10n.authLogoutButton),
          ),
        ],
      ),
    );
  }
}