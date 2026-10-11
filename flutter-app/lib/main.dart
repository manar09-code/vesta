import 'package:flutter/material.dart';

import 'app_state.dart';
import 'core/theme.dart';
import 'data/auth_repository.dart';
import 'data/chat_repository.dart';
import 'data/listing_repository.dart';
import 'home_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VestaApp());
}

/// Racine de l'application Vesta (version Flutter).
class VestaApp extends StatefulWidget {
  const VestaApp({super.key});

  @override
  State<VestaApp> createState() => _VestaAppState();
}

class _VestaAppState extends State<VestaApp> {
  /// Couche de données unique : les écrans ne parlent jamais à Firebase
  /// directement (architecture C4 niveau 3/4). Ici, démo en mémoire.
  late final AppState _state = AppState(
    listings: DemoListingRepository(),
    auth: DemoAuthRepository(),
    chat: DemoChatRepository(),
  );

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VestaScope(
      state: _state,
      child: MaterialApp(
        title: 'Vesta',
        debugShowCheckedModeBanner: false,
        theme: VestaTheme.light,
        home: const RootGate(),
      ),
    );
  }
}
