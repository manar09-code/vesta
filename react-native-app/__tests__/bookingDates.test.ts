import {
  hasBlockedNight,
  nightKey,
  nightsCount,
  nightsOf,
  totalPrice,
} from '../src/features/bookings/bookingDates';

describe('bookingDates', () => {
  test('12 Dec to 15 Dec is 3 nights', () => {
    expect(nightsCount(new Date(2026, 11, 12), new Date(2026, 11, 15))).toBe(3);
  });

  test('check-out day is not a night', () => {
    const keys = nightsOf(new Date(2026, 11, 12), new Date(2026, 11, 15)).map(
      nightKey,
    );
    expect(keys).toEqual(['2026-12-12', '2026-12-13', '2026-12-14']);
  });

  test('a blocked night inside the range is detected', () => {
    expect(
      hasBlockedNight(
        new Date(2026, 11, 12),
        new Date(2026, 11, 15),
        new Set(['2026-12-13']),
      ),
    ).toBe(true);
  });

  test('the check-out day can be a blocked night', () => {
    expect(
      hasBlockedNight(
        new Date(2026, 11, 12),
        new Date(2026, 11, 15),
        new Set(['2026-12-15']),
      ),
    ).toBe(false);
  });

  test('total price', () => {
    expect(totalPrice(3, 120)).toBe(360);
  });
});