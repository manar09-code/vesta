import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/placeholder_screen.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/auth_controller.dart';
import '../auth/require_sign_in.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = AppLocalizations.of(context).tabFavorites;
    final signedIn = ref.watch(authStateProvider).value != null;

    // Favorites belong to an account: a guest is asked to sign in.
    if (!signedIn) {
      return SignInPrompt(icon: Icons.favorite_border, title: title);
    }
    return PlaceholderScreen(icon: Icons.favorite_border, title: title);
  }
}
