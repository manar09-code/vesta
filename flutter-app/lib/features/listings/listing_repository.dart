import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/config/app_config.dart';
import 'listing_summary.dart';

/// Errors the UI can show. Screens turn them into translated messages.
enum ListingError {
  notSignedIn,
  noPhotos,
  tooManyPhotos,
  noNetwork,
  permissionDenied,
  unknown,
}

class ListingFailure implements Exception {
  const ListingFailure(this.error);

  final ListingError error;
}

/// Maximum photos per listing (ids p0 to p4, see docs/data-model.md).
const int maxListingPhotos = 5;

/// Values allowed by the rules and the data model.
const List<String> listingTypes = ['sale', 'rent'];
const List<String> rentPeriods = ['night', 'month', 'year'];
const List<String> propertyTypes = [
  'apartment',
  'house',
  'villa',
  'studio',
  'riad',
  'guest_house',
];

/// Data entered in the publish form.
class NewListing {
  const NewListing({
    required this.title,
    required this.description,
    required this.price,
    required this.listingType,
    required this.propertyType,
    required this.city,
    this.rentPeriod,
    this.bedrooms,
    this.bathrooms,
    this.areaSqm,
  });

  final String title;
  final String description;
  final num price;
  final String listingType; // 'sale' or 'rent'
  final String? rentPeriod; // required only when listingType == 'rent'
  final String propertyType;
  final String city;
  final num? bedrooms;
  final num? bathrooms;
  final num? areaSqm;
}

/// Only place that talks to the `listings` collection and its photos.
class ListingRepository {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;

  /// Creates the listing and its photos in ONE batch write.
  /// [photosBase64] holds 1 to 5 already compressed base64 strings.
  /// Returns the id of the new listing.
  Future<String> createListing({
    required NewListing listing,
    required List<String> photosBase64,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw const ListingFailure(ListingError.notSignedIn);
    if (photosBase64.isEmpty) {
      throw const ListingFailure(ListingError.noPhotos);
    }
    if (photosBase64.length > maxListingPhotos) {
      throw const ListingFailure(ListingError.tooManyPhotos);
    }

    try {
      final ref = _db.collection('listings').doc(); // auto-id
      final batch = _db.batch();

      batch.set(ref, {
        'ownerId': user.uid,
        'title': listing.title,
        'description': listing.description,
        'price': listing.price,
        'currency': AppConfig.currency,
        'listingType': listing.listingType,
        // rentPeriod only for rentals, the field is absent for a sale
        if (listing.listingType == 'rent') 'rentPeriod': listing.rentPeriod,
        'propertyType': listing.propertyType,
        'city': listing.city,
        // optional fields are written only when filled
        if (listing.bedrooms != null) 'bedrooms': listing.bedrooms,
        if (listing.bathrooms != null) 'bathrooms': listing.bathrooms,
        if (listing.areaSqm != null) 'areaSqm': listing.areaSqm,
        'photoCount': photosBase64.length,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Fixed ids p0..p4: the id gives the display order, p0 = cover.
      for (var i = 0; i < photosBase64.length; i++) {
        batch.set(ref.collection('photos').doc('p$i'), {
          'base64': photosBase64[i],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      return ref.id;
    } on FirebaseException catch (e) {
      throw ListingFailure(_mapCode(e.code));
    }
  }

  /// Live list of the signed-in user's own listings, newest first.
  /// Needs the index (ownerId, createdAt desc) from firestore.indexes.json.
  Stream<List<ListingSummary>> watchMyListings() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(const []);
    return _db
        .collection('listings')
        .where('ownerId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ListingSummary.fromDoc).toList());
  }

  /// Deletes the listing, its photos and its contact in ONE batch
  /// (otherwise they stay orphaned, see docs/data-model.md).
  Future<void> deleteListing(ListingSummary listing) async {
    final user = _auth.currentUser;
    if (user == null) throw const ListingFailure(ListingError.notSignedIn);

    try {
      final ref = _db.collection('listings').doc(listing.id);
      final batch = _db.batch();
      for (var i = 0; i < listing.photoCount; i++) {
        batch.delete(ref.collection('photos').doc('p$i'));
      }
      batch.delete(ref.collection('contact').doc('info'));
      batch.delete(ref);
      await batch.commit();
    } on FirebaseException catch (e) {
      throw ListingFailure(_mapCode(e.code));
    }
  }

  ListingError _mapCode(String code) {
    switch (code) {
      case 'unavailable':
      case 'network-request-failed':
        return ListingError.noNetwork;
      case 'permission-denied':
        return ListingError.permissionDenied;
      default:
        return ListingError.unknown;
    }
  }
}