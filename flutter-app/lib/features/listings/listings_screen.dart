import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';
import '../../l10n/generated/app_localizations.dart';

class ListingsScreen extends StatelessWidget {
  const ListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      icon: Icons.home_work_outlined,
      title: AppLocalizations.of(context).tabExplore,
    );
  }
}
