import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';
import '../../l10n/generated/app_localizations.dart';

/// One conversation. The messages, the input and the quick replies come in
/// the next part of VST-44; for now it only receives the conversation id.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      icon: Icons.chat_bubble_outline,
      title: AppLocalizations.of(context).chatTitle,
    );
  }
}
