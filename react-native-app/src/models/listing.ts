/**
 * Modèle d'annonce — partagé par tous les modules (Search, Détails,
 * Favoris, Publication…). Version TS du modèle décrit au C4 niveau 4.
 */
export type Transaction = 'vente' | 'location';

export interface Listing {
  id: string;
  title: string;
  /** Ex. « La Marsa, Tunis ». */
  location: string;
  /** Ex. « Villa », « Appartement ». */
  type: string;
  transaction: Transaction;
  /** Prix en TND (par mois si location). */
  price: number;
  area: number;
  rooms: number;
  baths: number;
  /** Illustration principale (assets/images/<image>.png). */
  image: string;
  description: string;
}

export const isSale = (listing: Listing): boolean => listing.transaction === 'vente';

export const transactionLabel = (listing: Listing): string =>
  isSale(listing) ? 'À vendre' : 'À louer';

/** Galerie : illustration principale + deux visuels d'intérieur, comme la maquette. */
export const galleryOf = (listing: Listing): string[] => [listing.image, 'living-room', 'kitchen'];

/** Jeu de données de démonstration — identique à la maquette web. */
export const demoListings: Listing[] = [
  {
    id: 'marsa',
    title: 'Villa des Oliviers',
    location: 'La Marsa, Tunis',
    type: 'Villa',
    transaction: 'vente',
    price: 1250000,
    area: 240,
    rooms: 4,
    baths: 3,
    image: 'villa',
    description:
      'Une villa lumineuse avec terrasse et jardin, à deux pas de la mer. De beaux espaces pour imaginer votre prochain quotidien.',
  },
  {
    id: 'lac',
    title: 'L’Appartement Lumière',
    location: 'Les Berges du Lac, Tunis',
    type: 'Appartement',
    transaction: 'vente',
    price: 420000,
    area: 108,
    rooms: 3,
    baths: 2,
    image: 'apartment',
    description:
      'Un appartement chaleureux avec un séjour ouvert et de grandes baies vitrées. Un cadre paisible, proche des commerces et des services.',
  },
  {
    id: 'sousse',
    title: 'Le Patio Bleu',
    location: 'Sousse, Sousse',
    type: 'Appartement',
    transaction: 'location',
    price: 1800,
    area: 82,
    rooms: 2,
    baths: 1,
    image: 'coast',
    description:
      'Un cocon clair et accueillant avec un patio ensoleillé, idéal pour profiter de la ville et de la côte.',
  },
  {
    id: 'menzah',
    title: 'Maison des Jasmins',
    location: 'El Menzah, Tunis',
    type: 'Villa',
    transaction: 'location',
    price: 3200,
    area: 165,
    rooms: 3,
    baths: 2,
    image: 'villa',
    description:
      'Une maison familiale avec jardin et espace de vie généreux, dans un quartier calme et bien desservi.',
  },
];
