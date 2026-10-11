import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../core/theme.dart';
import '../../widgets/brand.dart';
import '../../widgets/toast.dart';
import 'publish_controller.dart';

/// Écran Publication : formulaire de mise en ligne d'une annonce.
class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  late final PublishController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PublishController()..addListener(_onChanged);
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

  void _submit() {
    final listing = _controller.validate();
    if (listing == null) return;
    VestaScope.of(context).publish(listing);
    _controller.clear();
    FocusScope.of(context).unfocus();
    VestaToast.show(context, 'Annonce publiée (mode démo) : visible dans « Explorer ».');
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    return Scaffold(
      backgroundColor: VestaColors.shell,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // En-tête.
          Container(
            padding: const EdgeInsets.fromLTRB(23, 34, 23, 25),
            decoration: const BoxDecoration(
              color: VestaColors.header,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(29)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLogo(),
                const SizedBox(height: 30),
                const Eyebrow('Partagez votre bien'),
                const SizedBox(height: 9),
                Text(
                  'Publiez une annonce\nen quelques lignes.',
                  style: Theme.of(context).extension<VestaTextStyle>()!.serifStyle(32, height: 1.07, letterSpacing: -0.7),
                ),
              ],
            ),
          ),

          // Formulaire.
          Padding(
            padding: const EdgeInsets.all(23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _segmented(
                  context,
                  label: 'Type de transaction',
                  value: c.transaction,
                  options: const [('À vendre', 'vente'), ('À louer', 'location')],
                  onChanged: c.setTransaction,
                ),
                _segmented(
                  context,
                  label: 'Type de bien',
                  value: c.type,
                  options: const [('Villa', 'Villa'), ('Appartement', 'Appartement')],
                  onChanged: c.setType,
                ),
                _textField(context, label: 'Titre de l’annonce', controller: c.titleController, hint: 'Ex. Villa des Oliviers'),
                _textField(context, label: 'Ville, quartier', controller: c.locationController, hint: 'Ex. La Marsa, Tunis'),
                _textField(context, label: 'Prix (TND)', controller: c.priceController, hint: 'Ex. 1250000', keyboardType: TextInputType.number),
                Row(
                  children: [
                    Expanded(child: _textField(context, label: 'Surface (m²)', controller: c.areaController, hint: 'Ex. 240', keyboardType: TextInputType.number)),
                    const SizedBox(width: 10),
                    Expanded(child: _textField(context, label: 'Chambres', controller: c.roomsController, hint: 'Ex. 4', keyboardType: TextInputType.number)),
                    const SizedBox(width: 10),
                    Expanded(child: _textField(context, label: 'S. de bain', controller: c.bathsController, hint: 'Ex. 3', keyboardType: TextInputType.number)),
                  ],
                ),
                _textField(
                  context,
                  label: 'Description',
                  controller: c.descriptionController,
                  hint: 'Décrivez les atouts du bien…',
                  maxLines: 4,
                ),
                if (c.error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: VestaColors.errorBg, borderRadius: BorderRadius.circular(8)),
                    child: Text(c.error!, style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, color: VestaColors.errorText)),
                  ),
                FilledButton(
                  onPressed: _submit,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Publier l’annonce'), SizedBox(width: 14), Text('→')],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mode démo : l’annonce reste sur cet appareil et disparaît au redémarrage.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: VestaFonts.sans, fontSize: 11, height: 1.6, color: VestaColors.muted2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmented(
    BuildContext context, {
    required String label,
    required String value,
    required List<(String, String)> options,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, fontWeight: FontWeight.w700, color: VestaColors.ink)),
          const SizedBox(height: 7),
          Row(
            children: [
              for (final (optionLabel, optionValue) in options) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(optionValue),
                    child: Container(
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: value == optionValue ? VestaColors.inkSoft : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: value == optionValue ? VestaColors.inkSoft : VestaColors.borderInput),
                      ),
                      child: Text(
                        optionLabel,
                        style: TextStyle(
                          fontFamily: VestaFonts.sans,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: value == optionValue ? Colors.white : VestaColors.ink,
                        ),
                      ),
                    ),
                  ),
                ),
                if (optionValue != options.last.$2) const SizedBox(width: 10),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _textField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 12, fontWeight: FontWeight.w700, color: VestaColors.ink)),
          const SizedBox(height: 7),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(fontFamily: VestaFonts.sans, fontSize: 13, color: VestaColors.ink),
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}
