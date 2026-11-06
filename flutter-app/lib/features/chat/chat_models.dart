import 'dart:ui' show TextDirection;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' show Bidi;

/// Longest message accepted by the rules (see firebase/firestore.rules).
const maxMessageLength = 2000;

/// How many messages a chat screen loads (VST-44).
const messagesPageSize = 50;

/// Conversation id: one conversation per listing and per buyer
/// (docs/data-model.md). Neither part contains an underscore: Firestore
/// auto-ids and Firebase uids are letters and digits only.
String conversationIdFor(String listingId, String buyerId) =>
    '${listingId}_$buyerId';

/// Splits a conversation id back into its two parts, or null if it is not one.
({String listingId, String buyerId})? parseConversationId(String id) {
  final cut = id.lastIndexOf('_');
  if (cut <= 0 || cut == id.length - 1) return null;
  return (listingId: id.substring(0, cut), buyerId: id.substring(cut + 1));
}

/// Text direction that follows the message itself, not the app language:
/// people write Arabic, French and English, sometimes mixed (VST-44).
/// Text without letters (digits, emoji) follows [fallback].
TextDirection textDirectionFor(
  String text, {
  TextDirection fallback = TextDirection.ltr,
}) {
  final trimmed = text.trim();
  if (trimmed.isEmpty || !Bidi.hasAnyDirectionalChars(trimmed)) {
    return fallback;
  }
  return Bidi.detectRtlDirectionality(trimmed)
      ? TextDirection.rtl
      : TextDirection.ltr;
}

/// One conversation, as read from the `conversations` collection.
class Conversation {
  const Conversation({
    required this.id,
    required this.listingId,
    required this.participantIds,
    required this.lastMessage,
    required this.lastMessageAt,
    this.unread = const {},
  });

  final String id;
  final String listingId;

  /// Exactly 2 uids: `[buyerId, ownerId]`.
  final List<String> participantIds;
  final String lastMessage;

  /// Null for a moment right after a send (the server has not answered yet).
  final DateTime? lastMessageAt;

  /// Unread messages per user: `uid -> count`.
  final Map<String, int> unread;

  factory Conversation.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    final rawUnread = data['unread'];
    return Conversation(
      id: doc.id,
      listingId: (data['listingId'] as String?) ?? '',
      participantIds: [
        for (final id in (data['participantIds'] as List?) ?? const [])
          if (id is String) id,
      ],
      lastMessage: (data['lastMessage'] as String?) ?? '',
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
      unread: {
        if (rawUnread is Map)
          for (final entry in rawUnread.entries)
            if (entry.key is String && entry.value is num)
              entry.key as String: (entry.value as num).toInt(),
      },
    );
  }

  /// The other person of the conversation, seen from [myUid].
  String otherUserId(String myUid) =>
      participantIds.firstWhere((id) => id != myUid, orElse: () => '');

  int unreadFor(String uid) => unread[uid] ?? 0;
}

/// Newest conversation first. A conversation whose time is still null was
/// just written by this phone, so it is the newest.
List<Conversation> sortNewestFirst(Iterable<Conversation> conversations) {
  final list = conversations.toList();
  list.sort((a, b) {
    final ta = a.lastMessageAt;
    final tb = b.lastMessageAt;
    if (ta == null && tb == null) return 0;
    if (ta == null) return -1;
    if (tb == null) return 1;
    return tb.compareTo(ta);
  });
  return list;
}

/// One message of a conversation.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String senderId;
  final String text;

  /// Null while the message is still being sent.
  final DateTime? createdAt;

  factory ChatMessage.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return ChatMessage(
      id: doc.id,
      senderId: (data['senderId'] as String?) ?? '',
      text: (data['text'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
