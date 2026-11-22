import {
  activeFilterCount,
  emptyFilters,
  SearchFilters,
} from '../search/searchFilters';
import {
  allowedOfferTypes,
  allowedPropertyTypes,
  maxAllowedPrice,
} from './assets/allowedLists';

function extractJson(text: string): unknown {
  const start = text.indexOf('{');
  const end = text.lastIndexOf('}');
  if (start === -1 || end <= start) {
    return null;
  }
  try {
    return JSON.parse(text.slice(start, end + 1));
  } catch {
    return null;
  }
}

function priceOrNull(value: unknown): number | null {
  return typeof value === 'number' &&
    Number.isFinite(value) &&
    value >= 0 &&
    value <= maxAllowedPrice
    ? Math.round(value)
    : null;
}

/**
 * Turns the answer of the AI into search filters. Anything outside the
 * allowed lists is dropped. Returns null when nothing usable is left.
 */
export function parseSearchIntent(text: string): SearchFilters | null {
  const raw = extractJson(text);
  if (typeof raw !== 'object' || raw === null) {
    return null;
  }
  const data = raw as Record<string, unknown>;

  const city = typeof data.city === 'string' ? data.city.trim().slice(0, 40) : '';
  const offerType = allowedOfferTypes.find(item => item === data.offerType);
  const propertyType = allowedPropertyTypes.find(
    item => item === data.propertyType,
  );
  let minPrice = priceOrNull(data.minPrice);
  let maxPrice = priceOrNull(data.maxPrice);
  if (minPrice !== null && maxPrice !== null && minPrice > maxPrice) {
    [minPrice, maxPrice] = [maxPrice, minPrice];
  }

  const filters: SearchFilters = {
    ...emptyFilters,
    city,
    offerType: offerType ?? null,
    propertyType: propertyType ?? null,
    minPrice,
    maxPrice,
  };
  return activeFilterCount(filters) === 0 ? null : filters;
}
