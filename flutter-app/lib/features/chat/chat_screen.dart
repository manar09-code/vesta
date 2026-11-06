import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../core/theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';
import '../auth/require_sign_in.dart';
import 'chat_controller.dart';
import 'chat_models.dart';
import 'chat_repository.dart';

/// One conversation: realtime messages, newest at the bottom, and a box to
/// write (VST-44). The conversation is between the buyer (from the id) and
/// the owner of the listing.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  bool _sending = false;
  int _lastCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String _errorText(AppLocalizations l10n, ChatError error) {
    switch (error) {
      case ChatError.noNetwork:
        return l10n.chatSendError;
      case ChatError.permissionDenied:
      case ChatError.notSignedIn:
      case ChatError.ownListing:
      case ChatError.unknown:
        return l10n.chatSendFailed;
    }
  }

  Future<void> _send(String ownerId) async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _sending = true);
    final error = await sendChatMessage(
      ref,
      conversationId: widget.conversationId,
      ownerId: ownerId,
      text: text,
    );
    if (!mounted) return;
    setState(() => _sending = false);
    if (error == null || error == ChatError.noNetwork) {
      // Offline: the message stays in the list as "sending" and leaves by
      // itself when the network is back, so the box is emptied either way.
      _controller.clear();
    }
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(_errorText(l10n, error))));
    }
  }

  /// Marks the conversation as read when new messages arrive while it is open.
  void _markReadIfNeeded(String myUid) {
    final conversations = ref.read(conversationsProvider).value;
    final mine = conversations
        ?.where((c) => c.id == widget.conversationId)
        .firstOrNull;
    if (mine != null && mine.unreadFor(myUid) > 0) {
      ref
          .read(chatRepositoryProvider)
          .markRead(widget.conversationId)
          .catchError((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final myUid = ref.watch(myUidProvider);
    if (myUid == null) {
      return SignInPrompt(
        icon: Icons.chat_bubble_outline,
        title: l10n.chatTitle,
      );
    }

    final ids = parseConversationId(widget.conversationId);
    if (ids == null) {
      return Center(child: Text(l10n.chatLoadError));
    }
    final listingAsync = ref.watch(conversationListingProvider(ids.listingId));
    final listing = listingAsync.value;
    final ownerId = listing?.ownerId ?? '';
    final otherId = myUid == ids.buyerId ? ownerId : ids.buyerId;
    final otherName = ref.watch(userNameProvider(otherId)).value;

    // Opening or receiving messages clears the unread badge.
    ref.listen(conversationsProvider, (_, _) => _markReadIfNeeded(myUid));
    ref.listen(messagesProvider(widget.conversationId), (_, next) {
      final count = next.value?.length ?? 0;
      _markReadIfNeeded(myUid);
    if (count > _lastCount && _scroll.hasClients) {
        // The list is reversed: 0 is the bottom, where the newest message is.
        _scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
      _lastCount = count;
    });

    final messages = ref.watch(messagesProvider(widget.conversationId));

    return Column(
      children: [
        _Header(
          name: otherName ?? l10n.chatUnknownUser,
          listingTitle: listingAsync.isLoading
              ? ''
              : (listing?.title ?? l10n.chatListingRemoved),
        ),
        const Divider(height: 1),
        Expanded(
          child: messages.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.chatLoadError, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => ref
                        .invalidate(messagesProvider(widget.conversationId)),
                    child: Text(l10n.chatRetry),
                  ),
                ],
              ),
            ),
            data: (list) => list.isEmpty
                ? Center(child: Text(l10n.chatNoMessages))
                : ListView.builder(
                    controller: _scroll,
                    reverse: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (context, index) => _Bubble(
                      message: list[index],
                      mine: list[index].senderId == myUid,
                    ),
                  ),
          ),
        ),
        _Composer(
          controller: _controller,
          sending: _sending,
          enabled: ownerId.isNotEmpty,
          onSend: () => _send(ownerId),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.listingTitle});

  final String name;
  final String listingTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: theme.textTheme.titleMedium),
            if (listingTitle.isNotEmpty)
              Text(
                listingTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.mine});

  final ChatMessage message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final background = mine ? AppColors.primary : AppColors.sand;
    final foreground = mine ? AppColors.white : AppColors.navy;
    final time = message.createdAt;
    final locale = Localizations.localeOf(context).toString();

    return Align(
      // My messages on the end side, the other person's on the start side.
      alignment:
          mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // The direction follows the message, not the app language.
            Text(
              message.text,
              textDirection: textDirectionFor(message.text),
              style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
            ),
            const SizedBox(height: 2),
            Text(
              time == null
                  ? l10n.chatSending
                  : DateFormat.Hm(locale).format(time.toLocal()),
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: foreground.withValues(alpha: 0.75)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.sending,
    required this.enabled,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool sending;
  final bool enabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) => TextField(
                  controller: controller,
                  enabled: enabled,
                  maxLength: maxMessageLength,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  // Arrow and cursor follow what the person types.
                  textDirection: textDirectionFor(
                    value.text,
                    fallback: Directionality.of(context),
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.chatMessageHint,
                    counterText: '',
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) => IconButton.filled(
                tooltip: l10n.chatSend,
                onPressed: enabled && !sending && value.text.trim().isNotEmpty
                    ? onSend
                    : null,
                icon: sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
