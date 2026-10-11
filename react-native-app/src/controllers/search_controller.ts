import {normalized} from '../core/formatters';
import {Listing} from '../models/listing';

/** Options des filtres — libellés repris de la maquette. */
export const TRANSACTION_OPTIONS: Array<[string, string]> = [
  ['Tous les biens', 'all'],
  ['À acheter', 'vente'],
  ['À louer', 'location'],
];

export const TYPE_OPTIONS: Array<[string, string]> = [
  ['Tous', 'all'],
  ['Appartement', 'Appartement'],
  ['Villa', 'Villa'],
];

export interface FilterOptions {
  query?: string;
  /** `all` | `vente` | `location`. */
  transaction?: string;
  /** `all` | `Appartement` | `Villa`. */
  type?: string;
  maxPrice?: number | null;
  favoritesOnly?: boolean;
}

/**
 * Filtre les annonces (recherche insensible aux accents/casse,
 * transaction, type, prix maximum, favoris).
 * Miroir du filtrage de la maquette (app.js) et du contrôleur Flutter.
 */
export function filterListings(
  listings: Listing[],
  favorites: string[],
  options: FilterOptions,
): Listing[] {
  const q = normalized(options.query ?? '');
  const transaction = options.transaction ?? 'all';
  const type = options.type ?? 'all';
  const maxPrice = options.maxPrice ?? null;
  const favoritesOnly = options.favoritesOnly ?? false;

  return listings.filter(item => {
    if (favoritesOnly && !favorites.includes(item.id)) {
      return false;
    }
    if (transaction !== 'all' && item.transaction !== transaction) {
      return false;
    }
    if (type !== 'all' && item.type !== type) {
      return false;
    }
    if (maxPrice != null && item.price > maxPrice) {
      return false;
    }
    if (
      q.length > 0 &&
      !normalized(`${item.title} ${item.location} ${item.type}`).includes(q)
    ) {
      return false;
    }
    return true;
  });
}
