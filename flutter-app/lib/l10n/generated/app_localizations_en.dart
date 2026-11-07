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
  String get chatEmptyTitle => 'No conversations yet';

  @override
  String get chatEmptyBody => 'Open a listing and tap Contact owner to start.';

  @override
  String get chatContactOwner => 'Contact owner';

  @override
  String get chatOwnListing => 'This is your own listing';

  @override
  String get chatContactError => 'Could not open the chat, try again';

  @override
  String get chatUnknownUser => 'Vesta user';

  @override
  String get chatLoadError => 'Could not load your messages';

  @override
  String get chatRetry => 'Try again';

  @override
  String get chatListingRemoved => 'Listing no longer available';

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
  String get listingErrorPriceInvalid =>
      'Enter a price between 1 and 50,000,000';

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

  @override
  String get listingDetailNotFound => 'Listing not found';

  @override
  String get listingDetailLoadError => 'Could not load this listing.';

  @override
  String get listingDetailRetry => 'Try again';

  @override
  String get listingDetailNoPhoto => 'No photo';

  @override
  String get listingDetailBedrooms => 'Bedrooms';

  @override
  String get listingDetailBathrooms => 'Bathrooms';

  @override
  String get listingDetailArea => 'Area (m²)';

  @override
  String get listingDetailPerNight => '/ night';

  @override
  String get listingDetailPerMonth => '/ month';

  @override
  String get listingDetailPerYear => '/ year';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileNameLabel => 'Name';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileSaveButton => 'Save';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profilePhotoGallery => 'Choose from gallery';

  @override
  String get profilePhotoCamera => 'Take a photo';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profileMyListings => 'My listings';

  @override
  String get profileNoListings => 'You have no listings yet';

  @override
  String get profileListingsLoadError => 'Could not load your listings';

  @override
  String get profileEditListing => 'Edit this listing';

  @override
  String get profileDeleteListing => 'Delete this listing';

  @override
  String get profileDeleteConfirmTitle => 'Delete this listing?';

  @override
  String get profileDeleteConfirmBody =>
      'Its photos will be deleted too. This cannot be undone.';

  @override
  String get profileDeleteConfirm => 'Delete';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileListingDeleted => 'Listing deleted';

  @override
  String get profileErrorNameRequired => 'Name is required';

  @override
  String get profileErrorNoNetwork => 'No connection. Please try again.';

  @override
  String get profileErrorPermission => 'You are not allowed to do this';

  @override
  String get profileErrorNotSignedIn => 'Please sign in';

  @override
  String get profileErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get profilePhotoErrorTooLarge => 'This photo is too large';

  @override
  String get profilePhotoErrorRead => 'Could not read this photo';

  @override
  String get favoritesEmptyTitle => 'No favorites yet';

  @override
  String get favoritesEmptyBody =>
      'Tap the heart on a listing to save it here.';

  @override
  String get favoritesUnavailable => 'This listing is no longer available';

  @override
  String get favoritesRemove => 'Remove';

  @override
  String get favoritesRetry => 'Try again';

  @override
  String get favoritesErrorNoNetwork =>
      'No connection. Check your internet and try again.';

  @override
  String get favoritesErrorPermission => 'You are not allowed to do this.';

  @override
  String get favoritesErrorNotSignedIn => 'Sign in to save favorites.';

  @override
  String get favoritesErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get listingsEmpty => 'No listings yet';

  @override
  String get favoritesFilterAll => 'All';

  @override
  String get favoritesFilterBuy => 'Buy';

  @override
  String get favoritesFilterRent => 'Rent';

  @override
  String get favoritesFilterStay => 'Stay';

  @override
  String get favoritesFilterEmpty => 'No favorites in this category';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAbout => 'About Vesta';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPrivacy => 'Privacy and account deletion';

  @override
  String get settingsContact => 'Contact us';

  @override
  String get settingsDeleteAccount => 'Delete my account';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountBody =>
      'This permanently deletes your account, your profile, your listings and their photos, and your favorites. Messages you sent stay in the other person\'s conversation. This cannot be undone.';

  @override
  String get deleteAccountPassword => 'Enter your password to confirm';

  @override
  String get deleteAccountConfirm => 'Delete';

  @override
  String get deleteAccountDone => 'Your account has been deleted.';

  @override
  String get settingsLinkError => 'Could not open the link';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get forgotPasswordTitle => 'Reset your password';

  @override
  String get forgotPasswordBody =>
      'Enter your email. If an account exists, we send you a link to choose a new password.';

  @override
  String get forgotPasswordSend => 'Send link';

  @override
  String get forgotPasswordSent =>
      'If an account exists for this email, a reset link has been sent.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get verifyBannerText => 'Please verify your email address.';

  @override
  String get verifyBannerResend => 'Send again';

  @override
  String get verifyBannerSent => 'Verification email sent';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts, please try again in a few minutes';
}
