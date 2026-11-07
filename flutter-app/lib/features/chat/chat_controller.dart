import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_controller.dart';
import '../listings/listing.dart';
import '../listings/listing_controller.dart';
import 'chat_models.dart';
import 'chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(),
);

/// Uid of the signed-in user (null for a guest). Screens use this instead of
/// reading Firebase directly, so tests can replace it.
final myUidProvider = Provider<String?>(
  (ref) => ref.watch(authStateProvider).value?.uid,
);

/// Live conversations of the signed-in user, newest first. Restarts by
/// itself when the user signs in or out, and stops listening when the list
/// screen is closed (no leaked listener).
final conversationsProvider =
    StreamProvider.autoDispose<List<Conversation>>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(chatRepositoryProvider).watchConversations();
});

/// Public name of a user, for the conversation list and the chat header.
final userNameProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, uid) {
  return ref.watch(chatRepositoryProvider).getUserName(uid);
});

/// Listing a conversation is about (null if it was deleted).
final conversationListingProvider =
    FutureProvider.autoDispose.family<Listing?, String>((ref, listingId) {
  return ref.watch(listingRepositoryProvider).getListing(listingId);
});
