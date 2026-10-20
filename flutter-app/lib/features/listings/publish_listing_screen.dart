import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n/generated/app_localizations.dart';
import 'listing_controller.dart';
import 'listing_repository.dart';
import 'photo_service.dart';

class PublishListingScreen extends ConsumerStatefulWidget {
  const PublishListingScreen({super.key});

  @override
  ConsumerState<PublishListingScreen> createState() =>
      _PublishListingScreenState();
}

class _PublishListingScreenState extends ConsumerState<PublishListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _city = TextEditingController();
  final _bedrooms = TextEditingController();
  final _bathrooms = TextEditingController();
  final _area = TextEditingController();
  final _photoService = PhotoService();

  String _listingType = 'sale';
  String? _rentPeriod;
  String _propertyType = 'apartment';
  final List<String> _photos = []; // base64 strings, index 0 = cover
  String? _photoMessage;
  bool _rentPeriodMissing = false;

  @override
  void dispose() {
    for (final c in [
      _title,
      _description,
      _price,
      _city,
      _bedrooms,
      _bathrooms,
      _area,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ---- translation of error enums (no text in the logic files) ----
  String _fieldError(AppLocalizations l, ListingFieldError e) {
    switch (e) {
      case ListingFieldError.titleRequired:
        return l.listingErrorTitleRequired;
      case ListingFieldError.descriptionRequired:
        return l.listingErrorDescriptionRequired;
      case ListingFieldError.priceInvalid:
        return l.listingErrorPriceInvalid;
      case ListingFieldError.cityRequired:
        return l.listingErrorCityRequired;
      case ListingFieldError.rentPeriodRequired:
        return l.listingErrorRentPeriodRequired;
      case ListingFieldError.numberInvalid:
        return l.listingErrorNumberInvalid;
    }
  }

  String _listingError(AppLocalizations l, ListingError e) {
    switch (e) {
      case ListingError.notSignedIn:
        return l.listingErrorNotSignedIn;
      case ListingError.noPhotos:
        return l.listingErrorNoPhotos;
      case ListingError.tooManyPhotos:
        return l.listingErrorTooManyPhotos;
      case ListingError.noNetwork:
        return l.listingErrorNoNetwork;
      case ListingError.permissionDenied:
        return l.listingErrorPermissionDenied;
      case ListingError.unknown:
        return l.listingErrorUnknown;
    }
  }

  String _photoError(AppLocalizations l, PhotoError e) {
    switch (e) {
      case PhotoError.tooManyPhotos:
        return l.listingErrorTooManyPhotos;
      case PhotoError.tooLarge:
        return l.photoErrorTooLarge;
      case PhotoError.readFailed:
        return l.photoErrorReadFailed;
    }
  }

  String _propertyLabel(AppLocalizations l, String type) {
    switch (type) {
      case 'apartment':
        return l.propertyApartment;
      case 'house':
        return l.propertyHouse;
      case 'villa':
        return l.propertyVilla;
      case 'studio':
        return l.propertyStudio;
      case 'riad':
        return l.propertyRiad;
      default:
        return l.propertyGuestHouse;
    }
  }

  String _periodLabel(AppLocalizations l, String period) {
    switch (period) {
      case 'night':
        return l.publishPeriodNight;
      case 'month':
        return l.publishPeriodMonth;
      default:
        return l.publishPeriodYear;
    }
  }

  // ---- photos ----
  Future<void> _addPhoto(ImageSource source) async {
    final l = AppLocalizations.of(context);
    try {
      final encoded = await _photoService.pickPhoto(
        source: source,
        currentCount: _photos.length,
        maxPhotos: maxListingPhotos,
      );
      if (encoded == null || !mounted) return;
      setState(() {
        _photos.add(encoded);
        _photoMessage = null;
      });
    } on PhotoFailure catch (e) {
      if (!mounted) return;
      setState(() => _photoMessage = _photoError(l, e.error));
    } catch (_) {
      if (!mounted) return;
      setState(() => _photoMessage = l.photoErrorReadFailed);
    }
  }

  // ---- submit ----
  num? _optional(TextEditingController c) {
    final text = c.text.trim();
    return text.isEmpty ? null : num.tryParse(text);
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final formOk = _formKey.currentState!.validate();
    final periodMissing = validateRentPeriod(_listingType, _rentPeriod) != null;
    setState(() {
      _rentPeriodMissing = periodMissing;
      if (_photos.isEmpty) _photoMessage = l.listingErrorNoPhotos;
    });
    if (!formOk || periodMissing || _photos.isEmpty) return;

    final listing = NewListing(
      title: _title.text.trim(),
      description: _description.text.trim(),
      price: num.parse(_price.text.trim()),
      listingType: _listingType,
      rentPeriod: _listingType == 'rent' ? _rentPeriod : null,
      propertyType: _propertyType,
      city: _city.text.trim(),
      bedrooms: _optional(_bedrooms),
      bathrooms: _optional(_bathrooms),
      areaSqm: _optional(_area),
    );

    final ok = await ref
        .read(listingControllerProvider.notifier)
        .publish(listing: listing, photosBase64: List.of(_photos));
    if (!mounted) return;

    if (ok) {
      messenger.showSnackBar(SnackBar(content: Text(l.publishSuccess)));
      ref.read(listingControllerProvider.notifier).reset();
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = ref.watch(listingControllerProvider);
    final loading = state.isLoading;

    String? fieldValidator(
      String? v,
      ListingFieldError? Function(String?) check,
    ) {
      final e = check(v);
      return e == null ? null : _fieldError(l, e);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.publishTitle)),
      body: AbsorbPointer(
        absorbing: loading,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _title,
                decoration: InputDecoration(labelText: l.publishFieldTitle),
                validator: (v) => fieldValidator(v, validateTitle),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l.publishFieldDescription,
                ),
                validator: (v) => fieldValidator(v, validateDescription),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'sale', label: Text(l.publishTypeSale)),
                  ButtonSegment(value: 'rent', label: Text(l.publishTypeRent)),
                ],
                selected: {_listingType},
                onSelectionChanged: (s) => setState(() {
                  _listingType = s.first;
                  if (_listingType == 'sale') _rentPeriod = null;
                  _rentPeriodMissing = false;
                }),
              ),
              if (_listingType == 'rent') ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _rentPeriod,
                  decoration: InputDecoration(
                    labelText: l.publishRentPeriod,
                    errorText: _rentPeriodMissing
                        ? l.listingErrorRentPeriodRequired
                        : null,
                  ),
                  items: [
                    for (final p in rentPeriods)
                      DropdownMenuItem(
                        value: p,
                        child: Text(_periodLabel(l, p)),
                      ),
                  ],
                  onChanged: (v) => setState(() {
                    _rentPeriod = v;
                    _rentPeriodMissing = false;
                  }),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: l.publishFieldPrice),
                validator: (v) => fieldValidator(v, validatePrice),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _propertyType,
                decoration: InputDecoration(labelText: l.publishPropertyType),
                items: [
                  for (final t in propertyTypes)
                    DropdownMenuItem(
                      value: t,
                      child: Text(_propertyLabel(l, t)),
                    ),
                ],
                onChanged: (v) =>
                    setState(() => _propertyType = v ?? _propertyType),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _city,
                decoration: InputDecoration(labelText: l.publishFieldCity),
                validator: (v) => fieldValidator(v, validateCity),
              ),
              const SizedBox(height: 12),
              for (final entry in [
                (_bedrooms, l.publishFieldBedrooms),
                (_bathrooms, l.publishFieldBathrooms),
                (_area, l.publishFieldArea),
              ]) ...[
                TextFormField(
                  controller: entry.$1,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(labelText: entry.$2),
                  validator: (v) => fieldValidator(v, validateOptionalNumber),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              Text(
                l.publishPhotosTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _addPhoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(l.publishAddFromGallery),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => _addPhoto(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: Text(l.publishAddFromCamera),
                  ),
                ],
              ),
              if (_photoMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _photoMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              SizedBox(
                height: 96,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _photos.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          base64Decode(_photos[i]),
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                      PositionedDirectional(
                        top: 0,
                        end: 0,
                        child: IconButton(
                          tooltip: l.publishRemovePhoto,
                          iconSize: 18,
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() {
                            _photos.removeAt(i);
                            _photoMessage = null;
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _listingError(l, state.error!),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: loading ? null : _submit,
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l.publishSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
