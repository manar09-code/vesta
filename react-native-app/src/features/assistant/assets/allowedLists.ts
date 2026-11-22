import { ListingCategory } from '../../../data/models/listingCategory';

/** Same lists as the search filters. The AI can only choose from them. */
export const allowedOfferTypes: ListingCategory[] = ['buy', 'rent', 'stay'];

export const allowedPropertyTypes = [
  'apartment',
  'house',
  'villa',
  'studio',
  'riad',
  'guest_house',
  'land',
  'commercial',
] as const;

/** Same maximum as the Firestore rules for a price. */
export const maxAllowedPrice = 50000000;
