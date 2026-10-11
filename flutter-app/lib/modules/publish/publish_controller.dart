import 'package:flutter/widgets.dart';

import '../../models/listing.dart';

/// Contrôleur du formulaire de publication. Validation en français,
/// création d'une [Listing] qui rejoint la liste (démo, en mémoire).
class PublishController extends ChangeNotifier {
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  final areaController = TextEditingController();
  final roomsController = TextEditingController();
  final bathsController = TextEditingController();
  final descriptionController = TextEditingController();

  /// `vente` ou `location`.
  String transaction = 'vente';

  /// `Villa` ou `Appartement`.
  String type = 'Villa';

  String? error;
  bool submitting = false;

  static const _illustrations = ['villa', 'apartment', 'coast'];
  var _illustrationIndex = 0;

  void setTransaction(String value) {
    transaction = value;
    notifyListeners();
  }

  void setType(String value) {
    type = value;
    notifyListeners();
  }

  /// Valide le formulaire ; retourne l'annonce créée ou null.
  Listing? validate() {
    error = null;
    if (titleController.text.trim().isEmpty) {
      error = 'Indiquez un titre pour l’annonce.';
    } else if (locationController.text.trim().isEmpty) {
      error = 'Indiquez la ville ou le quartier.';
    } else if (int.tryParse(priceController.text.trim()) == null) {
      error = 'Entrez un prix valide en TND.';
    } else if (int.tryParse(areaController.text.trim()) == null) {
      error = 'Entrez une surface valide en m².';
    }
    notifyListeners();
    return error == null ? _build() : null;
  }

  Listing _build() {
    final illustration = _illustrations[_illustrationIndex % _illustrations.length];
    _illustrationIndex++;
    return Listing(
      id: 'pub-${DateTime.now().millisecondsSinceEpoch}',
      title: titleController.text.trim(),
      location: locationController.text.trim(),
      type: type,
      transaction: transaction,
      price: int.parse(priceController.text.trim()),
      area: int.parse(areaController.text.trim()),
      rooms: int.tryParse(roomsController.text.trim()) ?? 1,
      baths: int.tryParse(bathsController.text.trim()) ?? 1,
      image: illustration,
      description: descriptionController.text.trim().isEmpty
          ? 'Annonce publiée depuis l’application Vesta.'
          : descriptionController.text.trim(),
    );
  }

  void clear() {
    titleController.clear();
    locationController.clear();
    priceController.clear();
    areaController.clear();
    roomsController.clear();
    bathsController.clear();
    descriptionController.clear();
    transaction = 'vente';
    type = 'Villa';
    error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    priceController.dispose();
    areaController.dispose();
    roomsController.dispose();
    bathsController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
