import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';
import '../../l10n/generated/app_localizations.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      icon: Icons.favorite_border,
      title: AppLocalizations.of(context).tabFavorites,
    );
  }
}
