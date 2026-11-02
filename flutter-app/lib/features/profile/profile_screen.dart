import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/auth_controller.dart';
import '../auth/require_sign_in.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  /// Publishing needs an account: a guest gets the sign-in sheet first.
  Future<void> _publish(BuildContext context, WidgetRef ref) async {
    if (!await requireSignIn(context, ref)) return;
    if (context.mounted) context.push(AppRoutes.publish);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final signedIn = ref.watch(authStateProvider).value != null;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: () => _publish(context, ref),
            icon: const Icon(Icons.add_home_work_outlined),
            label: Text(l10n.publishButton),
          ),
          const SizedBox(height: 12),
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
      ),
    );
  }
}
