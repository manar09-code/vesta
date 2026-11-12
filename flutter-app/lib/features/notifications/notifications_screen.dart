import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../auth/require_sign_in.dart';
import '../chat/chat_controller.dart';
import '../chat/chat_list_screen.dart';
import '../chat/chat_models.dart';

/// Notification center (VST-99). The app has no server push, so a
/// "notification" is a conversation with messages the user has not read yet.
/// It disappears from here when the chat is opened (the unread counter is
/// reset there). It reuses the conversation list, so no second Firestore
/// listener is opened.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final myUid = ref.watch(myUidProvider);

    // The router already sends a guest away; this covers a sign-out while
    // the screen is open.
    if (myUid == null) {
      return SignInPrompt(
        icon: Icons.notifications_none,
        title: l10n.notificationsTitle,
      );
    }

    final conversations = ref.watch(conversationsProvider);
    return conversations.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.chatLoadError, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(conversationsProvider),
                child: Text(l10n.chatRetry),
              ),
            ],
          ),
        ),
      ),
      data: (list) {
        final unread = unreadConversations(list, myUid);
        if (unread.isEmpty) {
          return _EmptyNotifications(
            title: l10n.notificationsEmptyTitle,
            body: l10n.notificationsEmptyBody,
          );
        }
        return ListView.separated(
          itemCount: unread.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) =>
              ConversationTile(conversation: unread[index], myUid: myUid),
        );
      },
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
