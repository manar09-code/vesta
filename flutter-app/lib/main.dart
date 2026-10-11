import 'package:flutter/material.dart';

import 'app_state.dart';
import 'core/theme.dart';
import 'data/auth_repository.dart';
import 'data/listing_repository.dart';
import 'modules/auth/auth_screen.dart';
import 'modules/search/search_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VestaApp());
}

/// Racine de l'application Vesta (version Flutter).
///
/// Périmètre de ce ticket : les écrans de la maquette uniquement —
/// connexion/inscription, liste des annonces, détail d'un bien.
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

/// Choix de l'écran d'accueil selon la session : authentification tant que
/// personne n'est entré, puis directement la liste des biens.
class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    final signedIn = VestaScope.of(context).isSignedIn;
    return signedIn
        ? const SearchScreen(favoritesOnly: false)
        : const AuthScreen();
  }
}
