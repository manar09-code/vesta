import 'package:cloud_firestore/cloud_firestore.dart';

/// Light version of a listing, enough for the "my listings" list.
class ListingSummary {
  const ListingSummary({
    required this.id,
    required this.title,
    required this.price,
    required this.currency,
    required this.city,
    required this.listingType,
    required this.status,
    required this.photoCount,
    this.rentPeriod,
  });

  final String id;
  final String title;
  final num price;
  final String currency;
  final String city;
  final String listingType; // 'sale' or 'rent'
  final String? rentPeriod;
  final String status; // missing in old listings = 'available'
  final int photoCount;

  factory ListingSummary.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data();
    return ListingSummary(
      id: doc.id,
      title: (d['title'] as String?) ?? '',
      price: (d['price'] as num?) ?? 0,
      currency: (d['currency'] as String?) ?? '',
      city: (d['city'] as String?) ?? '',
      listingType: (d['listingType'] as String?) ?? 'sale',
      rentPeriod: d['rentPeriod'] as String?,
      status: (d['status'] as String?) ?? 'available',
      photoCount: (d['photoCount'] as num?)?.toInt() ?? 0,
    );
  }
}