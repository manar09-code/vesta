/// Messagerie avec le propriétaire d'un bien. Démo : réponses
/// automatiques, aucune donnée envoyée.
abstract class ChatRepository {
  Future<String> replyTo(String message);
}

class DemoChatRepository implements ChatRepository {
  var _turn = 0;

  static const _replies = [
    'Bonjour ! Merci pour votre intérêt, le bien est toujours disponible.',
    'Bien sûr, des visites sont possibles en semaine comme le samedi.',
    'Je vous envoie les détails compléments très vite, n’hésitez pas à me recontacter.',
  ];

  @override
  Future<String> replyTo(String message) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final reply = _replies[_turn % _replies.length];
    _turn++;
    return reply;
  }
}
