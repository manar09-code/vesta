import { parseSearchIntent } from '../src/features/assistant/searchIntent';
import {
  checkLimit,
  dailyLimit,
} from '../src/features/assistant/requestLimit';

describe('parseSearchIntent', () => {
  test('reads a clean JSON answer', () => {
    const result = parseSearchIntent(
      '{"city":"Sousse","offerType":"stay","propertyType":"villa","maxPrice":300}',
    );
    expect(result).toEqual({
      city: 'Sousse',
      offerType: 'stay',
      propertyType: 'villa',
      minPrice: null,
      maxPrice: 300,
    });
  });

  test('reads JSON inside a code block', () => {
    const result = parseSearchIntent('```json\n{"city":"Tunis"}\n```');
    expect(result?.city).toBe('Tunis');
  });

  test('drops values outside the allowed lists', () => {
    const result = parseSearchIntent(
      '{"city":"Tozeur","offerType":"hack","propertyType":"castle"}',
    );
    expect(result?.offerType).toBeNull();
    expect(result?.propertyType).toBeNull();
    expect(result?.city).toBe('Tozeur');
  });

  test('swaps min and max when they are reversed', () => {
    const result = parseSearchIntent('{"minPrice":500,"maxPrice":100}');
    expect(result?.minPrice).toBe(100);
    expect(result?.maxPrice).toBe(500);
  });

  test('refuses bad prices', () => {
    const result = parseSearchIntent('{"minPrice":-5,"maxPrice":"cheap"}');
    expect(result).toBeNull();
  });

  test('returns null for text without JSON or without filters', () => {
    expect(parseSearchIntent('Sorry, I did not understand')).toBeNull();
    expect(parseSearchIntent('{}')).toBeNull();
  });
});

describe('checkLimit', () => {
  const noon = new Date(2026, 10, 22, 12, 0, 0);

  test('first request is allowed', () => {
    expect(checkLimit(null, noon).allowed).toBe(true);
  });

  test('a second request within 3 seconds is refused', () => {
    const first = checkLimit(null, noon);
    if (!first.allowed) {
      throw new Error('first request must be allowed');
    }
    const soon = new Date(noon.getTime() + 1000);
    expect(checkLimit(first.next, soon)).toEqual({
      allowed: false,
      reason: 'tooFast',
    });
    const later = new Date(noon.getTime() + 3000);
    expect(checkLimit(first.next, later).allowed).toBe(true);
  });

  test('the 21st request of the day is refused', () => {
    const state = { day: '2026-11-22', count: dailyLimit, lastAt: 0 };
    expect(checkLimit(state, noon)).toEqual({
      allowed: false,
      reason: 'dailyLimit',
    });
  });

  test('the counter restarts the next day', () => {
    const state = { day: '2026-11-21', count: dailyLimit, lastAt: 0 };
    expect(checkLimit(state, noon).allowed).toBe(true);
  });
});
