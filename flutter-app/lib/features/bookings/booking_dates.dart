import 'package:intl/intl.dart';

/// A night is the evening of a day. A stay from 12 Dec to 15 Dec has 3 nights:
/// 12, 13 and 14 (the check-out day is not a night).

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Number of nights between [checkIn] and [checkOut].
int nightsCount(DateTime checkIn, DateTime checkOut) {
  final a = DateTime.utc(checkIn.year, checkIn.month, checkIn.day);
  final b = DateTime.utc(checkOut.year, checkOut.month, checkOut.day);
  final days = b.difference(a).inDays;
  return days < 0 ? 0 : days;
}

/// The nights of the stay, one date per night.
List<DateTime> nightsOf(DateTime checkIn, DateTime checkOut) {
  final start = _dayOnly(checkIn);
  final count = nightsCount(checkIn, checkOut);
  return [
    for (var i = 0; i < count; i++)
      DateTime(start.year, start.month, start.day + i),
  ];
}

/// Key of a night in `listings/{id}/blockedNights/{yyyy-MM-dd}`.
/// Always Latin digits, whatever the language of the app.
/// Key of a night in `listings/{id}/blockedNights/{yyyy-MM-dd}`.
/// Always Latin digits, whatever the language of the app.
String nightKey(DateTime night) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${night.year.toString().padLeft(4, '0')}-${two(night.month)}-${two(night.day)}';
}
/// True when at least one night of the stay is already blocked.
bool hasBlockedNight(
  DateTime checkIn,
  DateTime checkOut,
  Set<String> blockedKeys,
) => nightsOf(checkIn, checkOut).any((n) => blockedKeys.contains(nightKey(n)));

/// Total price: number of nights x price per night.
num totalPrice(int nights, num pricePerNight) => nights * pricePerNight;