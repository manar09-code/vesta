import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../core/router/app_router.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/auth_controller.dart';
import '../auth/require_sign_in.dart';
import 'chat_controller.dart';
import 'chat_models.dart';

/// All the conversations of the signed-in user, newest first (VST-44).
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authStateProvider);
    final me = auth.value;

    // The router already sends a guest away; this covers a sign-out while
    // the screen is open.
    if (me == null) {
      return SignInPrompt(
        icon: Icons.chat_bubble_outline,
        title: l10n.chatTitle,
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
      data: (list) => list.isEmpty
          ? _EmptyChats(title: l10n.chatEmptyTitle, body: l10n.chatEmptyBody)
          : ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) =>
                  _ConversationTile(conversation: list[index], myUid: me.uid),
            ),
    );
  }
}

class _EmptyChats extends StatelessWidget {
  const _EmptyChats({required this.title, required this.body});

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
              Icons.chat_bubble_outline,
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

class _ConversationTile extends ConsumerWidget {
  const _ConversationTile({required this.conversation, required this.myUid});

  final Conversation conversation;
  final String myUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final otherId = conversation.otherUserId(myUid);
    final name = ref.watch(userNameProvider(otherId)).value;
    final displayName = name ?? l10n.chatUnknownUser;

    final listingAsync =
        ref.watch(conversationListingProvider(conversation.listingId));
    final listingTitle = listingAsync.when(
      data: (listing) => listing?.title ?? l10n.chatListingRemoved,
      loading: () => '',
      error: (_, _) => '',
    );

    final unread = conversation.unreadFor(myUid);
    final lastMessage = conversation.lastMessage;

    return ListTile(
      leading: CircleAvatar(
        child: Text(displayName.characters.first.toUpperCase()),
      ),
      title: Text(displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (listingTitle.isNotEmpty)
            Text(
              listingTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
          if (lastMessage.isNotEmpty)
            // The direction follows the message, not the app language.
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: textDirectionFor(lastMessage),
              ),
            ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _timeText(context, conversation.lastMessageAt),
            style: theme.textTheme.labelSmall,
          ),
          if (unread > 0) ...[
            const SizedBox(height: 4),
            Badge(label: Text('$unread')),
          ],
        ],
      ),
      onTap: () => context.push(AppRoutes.chatRoomPath(conversation.id)),
    );
  }
}

/// "14:05" for today, "5 Nov" for older messages, in the app language.
String _timeText(BuildContext context, DateTime? time) {
  if (time == null) return '';
  final locale = Localizations.localeOf(context).toString();
  final now = DateTime.now();
  final local = time.toLocal();
  final today = local.year == now.year &&
      local.month == now.month &&
      local.day == now.day;
  return today
      ? DateFormat.Hm(locale).format(local)
      : DateFormat.MMMd(locale).format(local);
}
