import 'package:flutter/material.dart';

import 'app_state.dart';
import 'core/theme.dart';
import 'modules/auth/auth_screen.dart';
import 'modules/map/map_screen.dart';
import 'modules/profile/profile_screen.dart';
import 'modules/publish/publish_screen.dart';
import 'modules/search/search_screen.dart';

/// Coquille de l'application : contenu + barre de navigation du bas.
/// N'apparaît qu'une fois la session ouverte (connexion ou visiteur).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  /// Index de l'onglet courant.
  int _index = 0;

  static const _tabs = <_Tab>[
    _Tab(label: 'Explorer', icon: Icons.explore_outlined, activeIcon: Icons.explore),
    _Tab(label: 'Favoris', icon: Icons.favorite_outline, activeIcon: Icons.favorite),
    _Tab(label: 'Publier', icon: Icons.add_circle_outline, activeIcon: Icons.add_circle),
    _Tab(label: 'Carte', icon: Icons.map_outlined, activeIcon: Icons.map),
    _Tab(label: 'Compte', icon: Icons.person_outline, activeIcon: Icons.person),
  ];

  void _openFavorites() => setState(() => _index = 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VestaColors.shell,
      body: IndexedStack(
        index: _index,
        children: [
          const SearchScreen(favoritesOnly: false),
          SearchScreen(favoritesOnly: true, key: const Key('favorites-tab')),
          const PublishScreen(),
          const MapScreen(),
          ProfileScreen(onOpenFavorites: _openFavorites),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: VestaColors.border)),
          boxShadow: [BoxShadow(color: Color(0x10143B37), blurRadius: 30, offset: Offset(0, -6))],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
            child: Row(
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: _NavButton(
                      tab: _tabs[i],
                      active: _index == i,
                      onTap: () => setState(() => _index = i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Description d'un onglet de la barre du bas.
class _Tab {
  const _Tab({required this.label, required this.icon, required this.activeIcon});

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// Bouton d'onglet : icône + libellé, actif en vert foncé.
class _NavButton extends StatelessWidget {
  const _NavButton({required this.tab, required this.active, required this.onTap});

  final _Tab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? VestaColors.navActive : VestaColors.navIdle;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(active ? tab.activeIcon : tab.icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 10, fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

/// Écran d'authentification ou coquille selon l'état de session.
/// Le widget est reconstruit à chaque changement de session grâce à
/// l'écoute de l'[AppState] portée par [VestaScope].
class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    final signedIn = VestaScope.of(context).isSignedIn;
    return signedIn ? const HomeShell() : const AuthScreen();
  }
}
