import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/features/listings/listing_controller.dart';
import 'package:flutterapp/features/listings/listing_detail_screen.dart';
import 'package:flutterapp/features/listings/listing_model.dart';
import 'package:flutterapp/l10n/generated/app_localizations.dart';

const _sale = Listing(
  id: 'l1',
  ownerId: 'u1',
  title: 'Sea view flat',
  description: 'Bright flat close to the beach.',
  price: 120000,
  currency: 'TND',
  listingType: 'sale',
  propertyType: 'apartment',
  city: 'Sousse',
  bedrooms: 2,
  bathrooms: 1,
  areaSqm: 85,
);

const _rent = Listing(
  id: 'l1',
  ownerId: 'u1',
  title: 'Studio near the station',
  description: 'Quiet studio.',
  price: 900,
  currency: 'TND',
  listingType: 'rent',
  rentPeriod: 'month',
  propertyType: 'studio',
  city: 'Tunis',
);

/// Shows the details screen with a fake loader, so no Firebase is needed.
Future<void> _pumpDetail(
  WidgetTester tester,
  Future<ListingDetail?> Function() load, {
  Locale locale = const Locale('en'),
  bool settle = true,
}) async {
    // Tall test screen: the 4:3 photo area is 600 px high on an 800 px wide
  // screen and would hide the texts below it from the lazy ListView.
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        listingDetailProvider('l1').overrideWith((ref) => load()),
      ],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: ListingDetailScreen(listingId: 'l1')),
      ),
    ),
  );
  if (settle) await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows a loader, then the sale listing', (tester) async {
    await _pumpDetail(
      tester,
      () async => const ListingDetail(listing: _sale, photos: []),
      settle: false,
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Sea view flat'), findsOneWidget);
    expect(find.text('Sousse'), findsOneWidget);
    expect(find.text('Bright flat close to the beach.'), findsOneWidget);
    expect(find.textContaining('120'), findsOneWidget);
    expect(find.text('Bedrooms: 2'), findsOneWidget);
    expect(find.text('Bathrooms: 1'), findsOneWidget);
    expect(find.text('Area (m²): 85'), findsOneWidget);
    expect(find.text('No photo'), findsOneWidget);
  });

  testWidgets('shows the unit for a monthly rental', (tester) async {
    await _pumpDetail(
      tester,
      () async => const ListingDetail(listing: _rent, photos: []),
    );
    expect(find.text('Studio near the station'), findsOneWidget);
    expect(find.textContaining('/ month'), findsOneWidget);
  });

  testWidgets('shows a message when the listing does not exist',
      (tester) async {
    await _pumpDetail(tester, () async => null);
    expect(find.text('Listing not found'), findsOneWidget);
  });

  testWidgets('shows an error message and a retry button', (tester) async {
    await _pumpDetail(tester, () async => throw Exception('boom'));
    expect(find.text('Could not load this listing.'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('texts are translated in French and Arabic', (tester) async {
    await _pumpDetail(tester, () async => null, locale: const Locale('fr'));
    expect(find.text('Annonce introuvable'), findsOneWidget);

    await _pumpDetail(tester, () async => null, locale: const Locale('ar'));
    expect(find.text('الإعلان غير موجود'), findsOneWidget);
  });
}