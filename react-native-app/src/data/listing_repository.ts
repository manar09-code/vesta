import {demoListings, Listing} from '../models/listing';

/**
 * Accès aux annonces. Implémenté en mémoire pour la démo ; sera doublé
 * d'une implémentation Firestore une fois la configuration Firebase
 * disponible — les écrans ne changent pas (C4 niveau 3 : une seule
 * couche de données devant Firebase).
 */
export interface ListingRepository {
  all(): Listing[];
  byId(id: string): Listing | null;
  add(listing: Listing): void;
}

/** Repository de démonstration : données en mémoire, aucun réseau. */
export class DemoListingRepository implements ListingRepository {
  private items: Listing[];

  constructor(seed: Listing[] = demoListings) {
    this.items = [...seed];
  }

  all(): Listing[] {
    return [...this.items];
  }

  byId(id: string): Listing | null {
    return this.items.find(item => item.id === id) ?? null;
  }

  add(listing: Listing): void {
    this.items.unshift(listing);
  }
}
