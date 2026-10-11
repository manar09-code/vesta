import 'package:flutter/widgets.dart';

import '../../app_state.dart';

/// Un message de la conversation (démo).
class ChatMessage {
  const ChatMessage({required this.text, required this.fromMe});

  final String text;
  final bool fromMe;
}

/// Contrôleur de conversation : envoi + réponse automatique de démo.
class ChatController extends ChangeNotifier {
  ChatController(this._app) {
    _messages = [
      const ChatMessage(
        text: 'Bonjour ! Je suis intéressé(e) par ce bien. Est-il toujours disponible ?',
        fromMe: true,
      ),
    ];
  }

  final AppState _app;
  late final List<ChatMessage> _messages;
  final inputController = TextEditingController();

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  bool get canSend => inputController.text.trim().isNotEmpty;

  void onInputChanged() => notifyListeners();

  Future<void> send() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return;
    _messages.add(ChatMessage(text: text, fromMe: true));
    inputController.clear();
    notifyListeners();

    final reply = await _app.chat.replyTo(text);
    _messages.add(ChatMessage(text: reply, fromMe: false));
    notifyListeners();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
}
