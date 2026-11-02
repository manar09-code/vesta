import '../../core/config/app_config.dart';

/// A listing as read from Firestore (collection `listings`, see
/// docs/data-model.md). Optional fields stay null when they are absent.
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
    this.rentPeriod,
    this.bedrooms,
    this.bathrooms,
    this.areaSqm,
    this.status,
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
  final num? bedrooms;
  final num? bathrooms;
  final num? areaSqm;
  final String? status;

  factory Listing.fromMap(String id, Map<String, dynamic> data) {
    return Listing(
      id: id,
      ownerId: data['ownerId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: data['price'] as num? ?? 0,
      currency: data['currency'] as String? ?? AppConfig.currency,
      listingType: data['listingType'] as String? ?? 'sale',
      rentPeriod: data['rentPeriod'] as String?,
      propertyType: data['propertyType'] as String? ?? '',
      city: data['city'] as String? ?? '',
      bedrooms: data['bedrooms'] as num?,
      bathrooms: data['bathrooms'] as num?,
      areaSqm: data['areaSqm'] as num?,
      status: data['status'] as String?,
    );
  }
}