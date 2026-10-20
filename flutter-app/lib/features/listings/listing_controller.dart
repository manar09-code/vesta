import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'listing_repository.dart';

final listingRepositoryProvider = Provider<ListingRepository>(
  (ref) => ListingRepository(),
);

/// Form validation errors. The screen turns them into translated messages.
enum ListingFieldError {
  titleRequired,
  descriptionRequired,
  priceInvalid,
  cityRequired,
  rentPeriodRequired,
  numberInvalid,
}

ListingFieldError? validateTitle(String? v) =>
    (v ?? '').trim().isEmpty ? ListingFieldError.titleRequired : null;

ListingFieldError? validateDescription(String? v) =>
    (v ?? '').trim().isEmpty ? ListingFieldError.descriptionRequired : null;

ListingFieldError? validateCity(String? v) =>
    (v ?? '').trim().isEmpty ? ListingFieldError.cityRequired : null;

/// Price must be a number >= 0.
ListingFieldError? validatePrice(String? v) {
  final price = num.tryParse((v ?? '').trim());
  return (price == null || price < 0) ? ListingFieldError.priceInvalid : null;
}

/// Optional number (bedrooms, bathrooms, area): empty is fine,
/// otherwise it must be a number >= 0.
ListingFieldError? validateOptionalNumber(String? v) {
  final text = (v ?? '').trim();
  if (text.isEmpty) return null;
  final n = num.tryParse(text);
  return (n == null || n < 0) ? ListingFieldError.numberInvalid : null;
}

/// Rent period is required only for a rental.
ListingFieldError? validateRentPeriod(String? listingType, String? period) =>
    (listingType == 'rent' && period == null)
        ? ListingFieldError.rentPeriodRequired
        : null;

class PublishState {
  const PublishState({this.isLoading = false, this.error, this.publishedId});

  final bool isLoading;
  final ListingError? error;
  final String? publishedId; // set on success
}

class ListingController extends Notifier<PublishState> {
  @override
  PublishState build() => const PublishState();

  ListingRepository get _repository => ref.read(listingRepositoryProvider);

  /// Returns true when the listing was created.
  Future<bool> publish({
    required NewListing listing,
    required List<String> photosBase64,
  }) async {
    if (state.isLoading) return false; // no double submit
    state = const PublishState(isLoading: true);
    try {
      final id = await _repository.createListing(
        listing: listing,
        photosBase64: photosBase64,
      );
      state = PublishState(publishedId: id);
      return true;
    } on ListingFailure catch (e) {
      state = PublishState(error: e.error);
    } catch (_) {
      state = const PublishState(error: ListingError.unknown);
    }
    return false;
  }

  void reset() => state = const PublishState();
}

final listingControllerProvider =
    NotifierProvider<ListingController, PublishState>(ListingController.new);