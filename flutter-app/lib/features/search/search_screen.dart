import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';
import '../../l10n/generated/app_localizations.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      icon: Icons.search,
      title: AppLocalizations.of(context).tabSearch,
    );
  }
}
