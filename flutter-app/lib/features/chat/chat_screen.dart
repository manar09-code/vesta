import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';
import '../../l10n/generated/app_localizations.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      icon: Icons.chat_bubble_outline,
      title: AppLocalizations.of(context).chatTitle,
    );
  }
}
