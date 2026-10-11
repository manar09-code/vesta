import {useState} from 'react';
import {galleryOf, Listing} from '../models/listing';

/**
 * Contrôleur de l'écran de détail : galerie et illustration sélectionnée.
 * Miroir de `DetailsController` côté Flutter.
 */
export function useDetailsController(listing: Listing) {
  const gallery = galleryOf(listing);
  const [selectedImage, setSelectedImage] = useState(0);

  const index = Math.min(selectedImage, gallery.length - 1);

  return {
    gallery,
    selectedImage: index,
    selectedImageKey: gallery[index],
    /** « 2 / 3 » sur le compteur du héros. */
    counterLabel: `${index + 1} / ${gallery.length}`,
    selectImage: (value: number) => setSelectedImage(value),
  };
}
