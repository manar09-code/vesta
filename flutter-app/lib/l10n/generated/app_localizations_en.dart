// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Vesta';

  @override
  String get tabExplore => 'Explore';

  @override
  String get tabSearch => 'Search';

  @override
  String get tabMap => 'Map';

  @override
  String get tabFavorites => 'Favorites';

  @override
  String get tabProfile => 'Profile';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get chatTitle => 'Messages';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get languageLabel => 'Language';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authDisplayNameLabel => 'Full name';

  @override
  String get authLoginButton => 'Log in';

  @override
  String get authSignUpTitle => 'Create account';

  @override
  String get authSignUpButton => 'Sign up';

  @override
  String get authGoToSignUp => 'No account yet? Sign up';

  @override
  String get authGoToLogin => 'Already have an account? Log in';

  @override
  String get authLogoutButton => 'Log out';

  @override
  String get signInToContinueTitle => 'Sign in to continue';

  @override
  String get signInToContinueBody =>
      'Log in or create an account to save favorites, message owners and publish listings.';

  @override
  String get authErrorInvalidEmail => 'Enter a valid email address';

  @override
  String get authErrorPasswordShort =>
      'Password must have at least 8 characters';

  @override
  String get authErrorNameRequired => 'Enter your name';

  @override
  String get authErrorEmailInUse => 'This email is already used';

  @override
  String get authErrorWrongPassword => 'Wrong email or password';

  @override
  String get authErrorNoNetwork => 'No internet connection';

  @override
  String get authErrorUnknown => 'Something went wrong, please try again';

  @override
  String get publishTitle => 'Publish a listing';

  @override
  String get publishButton => 'Publish a listing';

  @override
  String get publishSubmit => 'Publish';

  @override
  String get publishSuccess => 'Your listing has been published';

  @override
  String get publishFieldTitle => 'Title';

  @override
  String get publishFieldDescription => 'Description';

  @override
  String get publishFieldPrice => 'Price (TND)';

  @override
  String get publishFieldCity => 'City';

  @override
  String get publishFieldBedrooms => 'Bedrooms (optional)';

  @override
  String get publishFieldBathrooms => 'Bathrooms (optional)';

  @override
  String get publishFieldArea => 'Area in m² (optional)';

  @override
  String get publishListingType => 'Listing type';

  @override
  String get publishTypeSale => 'For sale';

  @override
  String get publishTypeRent => 'For rent';

  @override
  String get publishRentPeriod => 'Rent period';

  @override
  String get publishPeriodNight => 'Per night';

  @override
  String get publishPeriodMonth => 'Per month';

  @override
  String get publishPeriodYear => 'Per year';

  @override
  String get publishPropertyType => 'Property type';

  @override
  String get propertyApartment => 'Apartment';

  @override
  String get propertyHouse => 'House';

  @override
  String get propertyVilla => 'Villa';

  @override
  String get propertyStudio => 'Studio';

  @override
  String get propertyRiad => 'Riad';

  @override
  String get propertyGuestHouse => 'Guest house';

  @override
  String get publishPhotosTitle => 'Photos (up to 5)';

  @override
  String get publishAddFromGallery => 'Gallery';

  @override
  String get publishAddFromCamera => 'Camera';

  @override
  String get publishRemovePhoto => 'Remove photo';

  @override
  String get listingErrorTitleRequired => 'Enter a title';

  @override
  String get listingErrorDescriptionRequired => 'Enter a description';

  @override
  String get listingErrorPriceInvalid => 'Enter a price of 0 or more';

  @override
  String get listingErrorCityRequired => 'Enter a city';

  @override
  String get listingErrorRentPeriodRequired => 'Choose a rent period';

  @override
  String get listingErrorNumberInvalid => 'Enter a valid number';

  @override
  String get listingErrorNotSignedIn => 'Please sign in first';

  @override
  String get listingErrorNoPhotos => 'Add at least one photo';

  @override
  String get listingErrorTooManyPhotos => 'You can add up to 5 photos';

  @override
  String get listingErrorNoNetwork => 'No internet connection';

  @override
  String get listingErrorPermissionDenied => 'You are not allowed to do this';

  @override
  String get listingErrorUnknown => 'Something went wrong, please try again';

  @override
  String get photoErrorTooLarge =>
      'This photo is too large, choose another one';

  @override
  String get photoErrorReadFailed => 'Could not read this photo';
}
