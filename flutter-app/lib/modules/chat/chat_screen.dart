import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../core/theme.dart';
import '../../models/listing.dart';
import '../../widgets/listing_illustration.dart';
import 'chat_controller.dart';

/// Messagerie avec le propriétaire d'un bien (démo : réponses automatiques).
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.listing});

  final Listing listing;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatController _controller;
  var _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _controller = ChatController(VestaScope.of(context))..addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    return Scaffold(
      backgroundColor: VestaColors.shell,
      appBar: AppBar(
        backgroundColor: VestaColors.header,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: VestaColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ListingIllustration(widget.listing.image, width: 38, height: 38),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.listing.title,
                    style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 13, fontWeight: FontWeight.w700, color: VestaColors.ink),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.listing.location,
                    style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 10, color: VestaColors.muted2),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: c.messages.length,
              itemBuilder: (context, index) {
                final message = c.messages[index];
                return Align(
                  alignment: message.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    decoration: BoxDecoration(
                      color: message.fromMe ? VestaColors.primary : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: Radius.circular(message.fromMe ? 14 : 3),
                        bottomRight: Radius.circular(message.fromMe ? 3 : 14),
                      ),
                      border: message.fromMe ? null : Border.all(color: VestaColors.borderCard),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        fontFamily: VestaFonts.sans,
                        fontSize: 12.5,
                        height: 1.45,
                        color: message.fromMe ? Colors.white : VestaColors.ink,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: VestaColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: c.inputController,
                      onChanged: (_) => c.onInputChanged(),
                      onSubmitted: (_) => c.send(),
                      style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 13, color: VestaColors.ink),
                      decoration: const InputDecoration(hintText: 'Votre message…'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: c.canSend ? c.send : null,
                    style: FilledButton.styleFrom(minimumSize: const Size(48, 48), padding: const EdgeInsets.symmetric(horizontal: 16)),
                    child: const Icon(Icons.send, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
