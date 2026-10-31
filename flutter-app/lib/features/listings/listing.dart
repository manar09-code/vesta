import 'package:cloud_firestore/cloud_firestore.dart';

/// One listing, as read from the `listings` collection.
/// Photos are NOT here: they live in `listings/{id}/photos` and are read
/// separately (see ListingRepository.getCoverPhotoBase64).
class Listing {
  const Listing({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.listingType,
    required this.propertyType,
    required this.city,
    required this.status,
    required this.photoCount,
    this.rentPeriod,
    this.bedrooms,
    this.bathrooms,
    this.areaSqm,
  });

  final String id;
  final String ownerId;
  final String title;
  final String description;
  final num price;
  final String currency;
  final String listingType; // 'sale' or 'rent'
  final String? rentPeriod; // 'night', 'month' or 'year' (rent only)
  final String propertyType;
  final String city;
  final String status;
  final int photoCount;
  final num? bedrooms;
  final num? bathrooms;
  final num? areaSqm;

  factory Listing.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Listing(
      id: doc.id,
      ownerId: (data['ownerId'] as String?) ?? '',
      title: (data['title'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      price: (data['price'] as num?) ?? 0,
      currency: (data['currency'] as String?) ?? '',
      listingType: (data['listingType'] as String?) ?? 'sale',
      rentPeriod: data['rentPeriod'] as String?,
      propertyType: (data['propertyType'] as String?) ?? '',
      city: (data['city'] as String?) ?? '',
      // A missing status means "available" (see docs/data-model.md).
      status: (data['status'] as String?) ?? 'available',
      photoCount: (data['photoCount'] as num?)?.toInt() ?? 0,
      bedrooms: data['bedrooms'] as num?,
      bathrooms: data['bathrooms'] as num?,
      areaSqm: data['areaSqm'] as num?,
    );
  }
}
