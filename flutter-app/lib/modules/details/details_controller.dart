import 'package:flutter/widgets.dart';

import '../../models/listing.dart';

/// État de l'écran de détail : visuel sélectionné dans la galerie.
class DetailsController extends ChangeNotifier {
  DetailsController(this.listing);

  final Listing listing;

  int selectedImage = 0;

  void selectImage(int index) {
    if (index == selectedImage || index < 0 || index >= listing.gallery.length) return;
    selectedImage = index;
    notifyListeners();
  }

  void resetSelection() {
    selectedImage = 0;
    notifyListeners();
  }

  String get counterLabel => 'Illustration ${selectedImage + 1} / ${listing.gallery.length}';

  String get selectedImageKey => listing.gallery[selectedImage];
}
