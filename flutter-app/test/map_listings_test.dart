import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/features/listings/listing.dart';
import 'package:flutterapp/features/map/map_controller.dart';
import 'package:flutterapp/features/map/map_listing_preview.dart';
import 'package:flutterapp/l10n/generated/app_localizations.dart';

Listing _listing({
  String id = 'a',
  double? latitude = 36.8,
  double? longitude = 10.18,
  String status = 'available',
  String listingType = 'sale',
  String? rentPeriod,
}) {
  return Listing(
    id: id,
    ownerId: 'owner',
    title: 'Riad à Tozeur',
    description: '',
    price: 120,
    currency: 'TND',
    listingType: listingType,
    rentPeriod: rentPeriod,
    propertyType: 'riad',
    city: 'Tozeur',
    status: status,
    photoCount: 0,
    latitude: latitude,
    longitude: longitude,
  );
}

void main() {
  group('hasLocation', () {
    test('needs both numbers', () {
      expect(_listing().hasLocation, isTrue);
      expect(_listing(latitude: null).hasLocation, isFalse);
      expect(_listing(longitude: null).hasLocation, isFalse);
    });

    test('refuses values outside the globe', () {
      expect(_listing(latitude: 91).hasLocation, isFalse);
      expect(_listing(longitude: -181).hasLocation, isFalse);
      expect(_listing(latitude: 0, longitude: 0).hasLocation, isTrue);
    });
  });

  test('the map keeps listings with a position that are still available', () {
    final shown = listingsOnMap([
      _listing(id: 'ok'),
      _listing(id: 'no-position', latitude: null),
      _listing(id: 'sold', status: 'sold'),
      _listing(id: 'rented', status: 'rented'),
      _listing(id: 'hidden', status: 'hidden'),
      _listing(id: 'reserved', status: 'reserved'),
    ]);
    expect(shown.map((l) => l.id), ['ok', 'reserved']);
  });

  group('preview card', () {
    Future<void> pump(
      WidgetTester tester,
      Listing listing, {
      VoidCallback? onOpen,
    }) {
      return tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: MapListingPreview(listing: listing, onOpen: onOpen ?? () {}),
          ),
        ),
      );
    }

    testWidgets('shows title, city and a sale price without unit',
        (tester) async {
      await pump(tester, _listing());
      expect(find.text('Riad à Tozeur'), findsOneWidget);
      expect(find.text('Tozeur'), findsOneWidget);
      expect(find.text('TND 120'), findsOneWidget);
    });

    testWidgets('shows the unit for a stay and for a monthly rent',
        (tester) async {
      await pump(tester, _listing(listingType: 'rent', rentPeriod: 'night'));
      expect(find.text('TND 120 / night'), findsOneWidget);

      await pump(tester, _listing(listingType: 'rent', rentPeriod: 'month'));
      expect(find.text('TND 120 / month'), findsOneWidget);
    });

    testWidgets('a tap on the card opens the details', (tester) async {
      var opened = 0;
      await pump(tester, _listing(), onOpen: () => opened++);
      await tester.tap(find.text('Riad à Tozeur'));
      expect(opened, 1);
      await tester.tap(find.text('View details'));
      expect(opened, 2);
    });
  });
}
