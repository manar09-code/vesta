import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/phone_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/filter_tag.dart';
import '../../l10n/generated/app_localizations.dart';
import 'listing_controller.dart';
import 'listing_labels.dart';
import 'listing_repository.dart';
import 'photo_service.dart';

class PublishListingScreen extends ConsumerStatefulWidget {
  const PublishListingScreen({super.key});

  @override
  ConsumerState<PublishListingScreen> createState() =>
      _PublishListingScreenState();
}

class _PublishListingScreenState extends ConsumerState<PublishListingScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _city = TextEditingController();
  final _bedrooms = TextEditingController();
  final _bathrooms = TextEditingController();
  final _area = TextEditingController();
  final _phone = TextEditingController();
  final _guests = TextEditingController();
  final _photoService = PhotoService();

  String _listingType = 'sale';
  String? _rentPeriod;
  String _propertyType = 'apartment';
  bool _whatsapp = false;
  final List<String> _photos = []; // base64 strings, index 0 = cover
  final Set<String> _amenities = {};
  final Set<String> _houseRules = {};
  TimeOfDay? _checkIn;
  TimeOfDay? _checkOut;
  String? _photoMessage;
  bool _rentPeriodMissing = false;

  /// Field key -> error text, filled when the user taps Publish.
  Map<String, String> _errors = {};
  int _bannerCount = 0;

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
      _phone,
      _guests,
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
      case ListingFieldError.guestsInvalid:
        return l.listingErrorGuestsInvalid;
      case ListingFieldError.roomsInvalid:
        return l.listingErrorRoomsInvalid;
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

  // ---- time: shown with the device format, stored as HH:mm ----
  String _hhmm(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime({required bool checkIn}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          (checkIn ? _checkIn : _checkOut) ??
          TimeOfDay(hour: checkIn ? 14 : 11, minute: 0),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (checkIn) {
        _checkIn = picked;
      } else {
        _checkOut = picked;
      }
    });
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

  // ---- validation ----
  Map<String, String> _validate(AppLocalizations l) {
    final errors = <String, String>{};
    void check(
      String key,
      TextEditingController c,
      ListingFieldError? Function(String?) validator,
    ) {
      final e = validator(c.text);
      if (e != null) errors[key] = _fieldError(l, e);
    }

    check('title', _title, validateTitle);
    check('description', _description, validateDescription);
    check('price', _price, validatePrice);
    check('city', _city, validateCity);
    check('guests', _guests, validateGuests);
    check('bedrooms', _bedrooms, validateRooms);
    check('bathrooms', _bathrooms, validateRooms);
    check('area', _area, validateOptionalNumber);
    if (!isValidTunisianPhone(_phone.text)) {
      errors['phone'] = l.listingErrorPhoneInvalid;
    }
    return errors;
  }

  void _clearError(String key) {
    if (_errors.containsKey(key)) setState(() => _errors.remove(key));
  }

  // ---- submit ----
  num? _optional(TextEditingController c) {
    final text = c.text.trim();
    return text.isEmpty ? null : num.tryParse(text);
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final errors = _validate(l);
    final periodMissing = validateRentPeriod(_listingType, _rentPeriod) != null;
    final noPhotos = _photos.isEmpty;
    setState(() {
      _errors = errors;
      _rentPeriodMissing = periodMissing;
      if (noPhotos) _photoMessage = l.listingErrorNoPhotos;
      _bannerCount =
          errors.length + (periodMissing ? 1 : 0) + (noPhotos ? 1 : 0);
    });
    if (_bannerCount > 0) return;

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
      contactPhone: normalizeTunisianPhone(_phone.text),
      whatsappEnabled: _whatsapp,
      maxGuests: _optional(_guests),
      // Keep the order of amenityKeys / houseRuleKeys, whatever the taps.
      amenities: [
        for (final k in amenityKeys)
          if (_amenities.contains(k)) k,
      ],
      checkIn: _checkIn == null ? null : _hhmm(_checkIn!),
      checkOut: _checkOut == null ? null : _hhmm(_checkOut!),
      houseRules: [
        for (final k in houseRuleKeys)
          if (_houseRules.contains(k)) k,
      ],
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

  // ---- small builders ----
  Widget _section(String text) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
    child: Text(
      text,
      style: AppTextStyles.subtitle.copyWith(color: AppColors.navy),
    ),
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(
      text,
      style: AppTextStyles.caption.copyWith(color: AppColors.grey),
    ),
  );

  Widget _errorText(String text) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.xs),
    child: Text(
      text,
      style: AppTextStyles.caption.copyWith(color: AppColors.error),
    ),
  );

  Widget _gap() => const SizedBox(height: AppSpacing.md);

  Widget _field({
    required String keyName,
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool ltr = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppTextField(
        label: label,
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        ltr: ltr,
        errorText: _errors[keyName],
        onChanged: (_) => _clearError(keyName),
      ),
    );
  }

  Widget _banner(AppLocalizations l) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.field),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              l.publishErrorBanner(_bannerCount),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeButton({
    required String label,
    required TimeOfDay? value,
    required String emptyLabel,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: SecondaryButton(
        icon: Icons.schedule,
        label: '$label: ${value == null ? emptyLabel : value.format(context)}',
        onPressed: onTap,
      ),
    );
  }

  Widget _tags({
    required List<String> keys,
    required Set<String> selected,
    required String Function(String) labelOf,
  }) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final key in keys)
          FilterTag(
            label: labelOf(key),
            selected: selected.contains(key),
            onTap: () => setState(() {
              if (!selected.remove(key)) selected.add(key);
            }),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = ref.watch(listingControllerProvider);
    final loading = state.isLoading;

    return Scaffold(
      appBar: AppTopBar(title: l.publishTitle),
      body: AbsorbPointer(
        absorbing: loading,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (_bannerCount > 0) _banner(l),
            _field(
              keyName: 'title',
              label: l.publishFieldTitle,
              controller: _title,
            ),
            _field(
              keyName: 'description',
              label: l.publishFieldDescription,
              controller: _description,
              maxLines: 4,
            ),
            _label(l.publishListingType),
            Row(
              children: [
                FilterTag(
                  label: l.publishTypeSale,
                  selected: _listingType == 'sale',
                  onTap: () => setState(() {
                    _listingType = 'sale';
                    _rentPeriod = null;
                    _rentPeriodMissing = false;
                  }),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilterTag(
                  label: l.publishTypeRent,
                  selected: _listingType == 'rent',
                  onTap: () => setState(() {
                    _listingType = 'rent';
                    _rentPeriodMissing = false;
                  }),
                ),
              ],
            ),
            if (_listingType == 'rent') ...[
              _gap(),
              _label(l.publishRentPeriod),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final p in rentPeriods)
                    FilterTag(
                      label: _periodLabel(l, p),
                      selected: _rentPeriod == p,
                      onTap: () => setState(() {
                        _rentPeriod = p;
                        _rentPeriodMissing = false;
                      }),
                    ),
                ],
              ),
              if (_rentPeriodMissing)
                _errorText(l.listingErrorRentPeriodRequired),
            ],
            _gap(),
            _field(
              keyName: 'price',
              label: l.publishFieldPrice,
              controller: _price,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              ltr: true,
            ),
            _label(l.publishPropertyType),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final t in propertyTypes)
                  FilterTag(
                    label: _propertyLabel(l, t),
                    selected: _propertyType == t,
                    onTap: () => setState(() => _propertyType = t),
                  ),
              ],
            ),
            _gap(),
            _field(
              keyName: 'city',
              label: l.publishFieldCity,
              controller: _city,
            ),
            _field(
              keyName: 'phone',
              label: l.publishFieldPhone,
              controller: _phone,
              keyboardType: TextInputType.phone,
              ltr: true,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.publishWhatsapp),
              value: _whatsapp,
              onChanged: (v) => setState(() => _whatsapp = v),
            ),
            _gap(),
            _field(
              keyName: 'guests',
              label: l.publishFieldGuests,
              controller: _guests,
              keyboardType: TextInputType.number,
              ltr: true,
            ),
            _field(
              keyName: 'bedrooms',
              label: l.publishFieldBedrooms,
              controller: _bedrooms,
              keyboardType: TextInputType.number,
              ltr: true,
            ),
            _field(
              keyName: 'bathrooms',
              label: l.publishFieldBathrooms,
              controller: _bathrooms,
              keyboardType: TextInputType.number,
              ltr: true,
            ),
            _field(
              keyName: 'area',
              label: l.publishFieldArea,
              controller: _area,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              ltr: true,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.publishAmenitiesTitle,
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.navy,
                    ),
                  ),
                ),
                Text(
                  l.publishAmenitiesCounter(_amenities.length),
                  style: AppTextStyles.caption.copyWith(color: AppColors.grey),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            _tags(
              keys: amenityKeys,
              selected: _amenities,
              labelOf: (k) => amenityLabel(l, k),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                _timeButton(
                  label: l.publishCheckIn,
                  value: _checkIn,
                  emptyLabel: l.publishTimeNotSet,
                  onTap: () => _pickTime(checkIn: true),
                ),
                const SizedBox(width: AppSpacing.md),
                _timeButton(
                  label: l.publishCheckOut,
                  value: _checkOut,
                  emptyLabel: l.publishTimeNotSet,
                  onTap: () => _pickTime(checkIn: false),
                ),
              ],
            ),
            _section(l.publishRulesTitle),
            _tags(
              keys: houseRuleKeys,
              selected: _houseRules,
              labelOf: (k) => houseRuleLabel(l, k),
            ),
            _section(
              '${l.publishPhotosTitle}  ${_photos.length}/$maxListingPhotos',
            ),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                SecondaryButton(
                  icon: Icons.photo_library_outlined,
                  label: l.publishAddFromGallery,
                  expanded: false,
                  onPressed: () => _addPhoto(ImageSource.gallery),
                ),
                SecondaryButton(
                  icon: Icons.photo_camera_outlined,
                  label: l.publishAddFromCamera,
                  expanded: false,
                  onPressed: () => _addPhoto(ImageSource.camera),
                ),
              ],
            ),
            if (_photoMessage != null) _errorText(_photoMessage!),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.thumb),
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
                        color: AppColors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.navy.withValues(
                            alpha: 0.6,
                          ),
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
            if (state.error != null) _errorText(_listingError(l, state.error!)),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: l.publishSubmit,
              loading: loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}