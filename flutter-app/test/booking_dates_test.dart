import 'package:flutter_test/flutter_test.dart';

import '../lib/features/bookings/booking_dates.dart';

void main() {
  test('12 Dec to 15 Dec is 3 nights', () {
    expect(nightsCount(DateTime(2026, 12, 12), DateTime(2026, 12, 15)), 3);
  });

  test('check-out day is not a night', () {
    final keys = nightsOf(
      DateTime(2026, 12, 12),
      DateTime(2026, 12, 15),
    ).map(nightKey).toList();
    expect(keys, ['2026-12-12', '2026-12-13', '2026-12-14']);
  });

  test('a blocked night inside the range is detected', () {
    expect(
      hasBlockedNight(DateTime(2026, 12, 12), DateTime(2026, 12, 15), {
        '2026-12-13',
      }),
      isTrue,
    );
  });

  test('the check-out day can be a blocked night', () {
    expect(
      hasBlockedNight(DateTime(2026, 12, 12), DateTime(2026, 12, 15), {
        '2026-12-15',
      }),
      isFalse,
    );
  });

  test('total price', () {
    expect(totalPrice(3, 120), 360);
  });
}