import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../core/theme.dart';
import '../../widgets/brand.dart';
import '../../widgets/toast.dart';
import '../notifications/notifications_screen.dart';

/// Écran Compte : identité, raccourcis et déconnexion.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.onOpenFavorites});

  /// Bascule vers l'onglet Favoris (navigation par onglets).
  final VoidCallback onOpenFavorites;

  @override
  Widget build(BuildContext context) {
    final app = VestaScope.of(context);
    final body = Theme.of(context).extension<VestaTextStyle>()!;
    final name = app.userName ?? 'Visiteur Vesta';
    final email = app.userEmail ?? 'visiteur@vesta.tn';

    return Scaffold(
      backgroundColor: VestaColors.shell,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(23, 34, 23, 30),
            decoration: const BoxDecoration(
              color: VestaColors.header,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(29)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLogo(),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: VestaColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        name.characters.first.toUpperCase(),
                        style: const TextStyle(fontFamily: VestaFonts.serif, fontSize: 28, color: VestaColors.ink),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: body.serifStyle(24)),
                          const SizedBox(height: 2),
                          Text(email, style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, color: VestaColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _Stat(label: 'Favoris', value: '${app.favorites.length}'),
                    const SizedBox(width: 10),
                    _Stat(label: 'Annonces', value: '${app.listings.all().length}'),
                    const SizedBox(width: 10),
                    const _Stat(label: 'Ville', value: 'Tunis'),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.favorite_border,
                  label: 'Mes favoris',
                  onTap: onOpenFavorites,
                ),
                _MenuTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  ),
                ),
                _MenuTile(
                  icon: Icons.description_outlined,
                  label: 'Conditions et aide',
                  onTap: () => VestaToast.show(context, 'Aide : voir docs/mockups/README.md (mode démo).'),
                ),
                const SizedBox(height: 10),
                _MenuTile(
                  icon: Icons.logout,
                  label: 'Se déconnecter',
                  danger: true,
                  onTap: () {
                    app.signOut();
                    VestaToast.show(context, 'Vous êtes déconnecté (mode démo).');
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'Vesta — version Flutter · prototype sans Firebase',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 11, color: VestaColors.muted2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Petite statistique du profil.
class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: VestaColors.borderCard)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 16, fontWeight: FontWeight.w700, color: VestaColors.inkSoft)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 10, color: VestaColors.muted2)),
          ],
        ),
      ),
    );
  }
}

/// Ligne de menu du profil.
class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap, this.danger = false});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? VestaColors.errorText : VestaColors.ink;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: VestaColors.borderCard),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, size: 20, color: color),
          title: Text(
            label,
            style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 13, fontWeight: FontWeight.w700, color: color),
          ),
          trailing: Icon(Icons.chevron_right, size: 20, color: danger ? VestaColors.errorText : VestaColors.muted2),
        ),
      ),
    );
  }
}
