import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../core/formatters.dart';
import '../../core/theme.dart';
import '../../models/listing.dart';
import '../../widgets/listing_illustration.dart';
import '../../widgets/toast.dart';
import '../chat/chat_screen.dart';
import 'details_controller.dart';

/// Écran de détail d'un bien : héros + galerie + specs + carte + contact.
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.listingId});

  final String listingId;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  DetailsController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= DetailsController(VestaScope.of(context).listings.byId(widget.listingId)!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = VestaScope.of(context);
    final c = _controller!;
    final listing = c.listing;
    final body = Theme.of(context).extension<VestaTextStyle>()!;
    final isFavorite = app.isFavorite(listing.id);

    return Scaffold(
      backgroundColor: VestaColors.shell,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ——— Héros ———
          SizedBox(
            height: 315,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ListingIllustration(c.selectedImageKey),
                Positioned(
                  top: 18,
                  left: 19,
                  right: 19,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _RoundButton(
                        icon: Icons.arrow_back,
                        label: 'Retour aux annonces',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      _RoundButton(
                        icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                        label: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                        color: isFavorite ? VestaColors.heart : VestaColors.ink,
                        onTap: () {
                          app.toggleFavorite(listing.id);
                          VestaToast.show(
                            context,
                            app.isFavorite(listing.id)
                                ? 'Bien ajouté aux favoris (mode démo).'
                                : 'Bien retiré des favoris (mode démo).',
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 19,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xCC173B37), borderRadius: BorderRadius.circular(99)),
                    child: Text(
                      c.counterLabel,
                      style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ——— Contenu ———
          Padding(
            padding: const EdgeInsets.fromLTRB(23, 22, 23, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: VestaColors.badgeBg, borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        listing.transactionLabel,
                        style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 10, fontWeight: FontWeight.w700, color: VestaColors.badgeText),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(listing.type, style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 11, color: Color(0xFF9A8268))),
                  ],
                ),
                const SizedBox(height: 14),
                Text(listing.title, style: body.serifStyle(32, height: 1.09)),
                const SizedBox(height: 9),
                Text('⌖ ${listing.location}', style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, color: VestaColors.muted2)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(bottom: 19),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: VestaColors.borderSoft))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(money(listing.price), style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 25, fontWeight: FontWeight.w700, color: VestaColors.ink)),
                      if (!listing.isSale)
                        const Text(' / mois', style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 11, color: VestaColors.muted2)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 19),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 22),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: VestaColors.borderSoft))),
                    child: Row(
                      children: [
                        _Spec(label: '${listing.area} m² de surface'),
                        _Spec(label: '${listing.rooms} chambres'),
                        _Spec(label: '${listing.baths} s. de bain'),
                      ],
                    ),
                  ),
                ),

                // Description.
                _Section(
                  title: 'À propos de ce bien',
                  child: Text(
                    listing.description,
                    style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, height: 1.65, color: Color(0xFF6B7385)),
                  ),
                ),

                // Galerie.
                _Section(
                  title: 'Aperçu des visuels',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 13),
                        child: Text(
                          'Illustrations temporaires pour la maquette ; les photos réelles seront chargées depuis Firebase Storage dans l’application.',
                          style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 11, height: 1.5, color: VestaColors.muted2),
                        ),
                      ),
                      Row(
                        children: [
                          for (var i = 0; i < listing.gallery.length; i++) ...[
                            _GalleryThumb(
                              imageKey: listing.gallery[i],
                              selected: c.selectedImage == i,
                              label: 'Afficher l’illustration ${i + 1}',
                              onTap: () => setState(() => c.selectImage(i)),
                            ),
                            if (i < listing.gallery.length - 1) const SizedBox(width: 9),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Carte.
                _Section(
                  title: 'Localisation',
                  child: Container(
                    height: 145,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFDCE2EC), Color(0xFFECEAE0), Color(0xFFDCE2EC)],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⌖', style: TextStyle(fontSize: 30, color: Color(0xFF1D3F6B))),
                        const SizedBox(height: 3),
                        Text(listing.location, style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1D3F6B))),
                        const SizedBox(height: 3),
                        const Text('Carte interactive dans l’application finale', style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 10, color: Color(0xFF5A6B84))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ——— Pied de page : prix + Contacter ———
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(21, 12, 21, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color(0x11143B37), blurRadius: 25, offset: Offset(0, -7))],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Prix affiché', style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 10, color: VestaColors.muted2)),
                    const SizedBox(height: 3),
                    Text(
                      '${money(listing.price)}${listing.isSale ? '' : ' / mois'}',
                      style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 15, fontWeight: FontWeight.w700, color: VestaColors.ink),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChatScreen(listing: listing)),
                ),
                style: FilledButton.styleFrom(minimumSize: const Size(0, 44), padding: const EdgeInsets.symmetric(horizontal: 17)),
                child: const Row(children: [Text('Contacter'), SizedBox(width: 10), Text('↗')]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bouton rond translucide du héros.
class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.label, required this.onTap, this.color});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xF0FFFFFF),
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 20, color: color ?? VestaColors.ink),
        ),
      ),
    );
  }
}

/// Pastille de spécification (surface, chambres, sdb).
class _Spec extends StatelessWidget {
  const _Spec({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(color: VestaColors.spec, borderRadius: BorderRadius.circular(10)),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2E4066)),
        ),
      ),
    );
  }
}

/// Titre + contenu de section.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).extension<VestaTextStyle>()!.serifStyle(23)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

/// Vignette de galerie sélectionnable.
class _GalleryThumb extends StatelessWidget {
  const _GalleryThumb({required this.imageKey, required this.selected, required this.label, required this.onTap});

  final String imageKey;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 76,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: selected ? VestaColors.gold : Colors.transparent, width: 2),
          ),
          child: ListingIllustration(imageKey, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

/// Raccourci utilisé par les autres modules (favoris → détails).
Future<void> openListingDetails(BuildContext context, Listing listing) {
  return Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => DetailsScreen(listingId: listing.id)),
  );
}
