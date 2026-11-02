import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Vesta'**
  String get appName;

  /// No description provided for @tabExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get tabExplore;

  /// No description provided for @tabSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tabSearch;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @tabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get tabFavorites;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get chatTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authDisplayNameLabel;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get authLoginButton;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authSignUpTitle;

  /// No description provided for @authSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUpButton;

  /// No description provided for @authGoToSignUp.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Sign up'**
  String get authGoToSignUp;

  /// No description provided for @authGoToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get authGoToLogin;

  /// No description provided for @authLogoutButton.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get authLogoutButton;

  /// No description provided for @signInToContinueTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinueTitle;

  /// No description provided for @signInToContinueBody.
  ///
  /// In en, this message translates to:
  /// **'Log in or create an account to save favorites, message owners and publish listings.'**
  String get signInToContinueBody;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must have at least 8 characters'**
  String get authErrorPasswordShort;

  /// No description provided for @authErrorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get authErrorNameRequired;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already used'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorNoNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get authErrorNoNetwork;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again'**
  String get authErrorUnknown;

  /// No description provided for @publishTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish a listing'**
  String get publishTitle;

  /// No description provided for @publishButton.
  ///
  /// In en, this message translates to:
  /// **'Publish a listing'**
  String get publishButton;

  /// No description provided for @publishSubmit.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publishSubmit;

  /// No description provided for @publishSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your listing has been published'**
  String get publishSuccess;

  /// No description provided for @publishFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get publishFieldTitle;

  /// No description provided for @publishFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get publishFieldDescription;

  /// No description provided for @publishFieldPrice.
  ///
  /// In en, this message translates to:
  /// **'Price (TND)'**
  String get publishFieldPrice;

  /// No description provided for @publishFieldCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get publishFieldCity;

  /// No description provided for @publishFieldBedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms (optional)'**
  String get publishFieldBedrooms;

  /// No description provided for @publishFieldBathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms (optional)'**
  String get publishFieldBathrooms;

  /// No description provided for @publishFieldArea.
  ///
  /// In en, this message translates to:
  /// **'Area in m² (optional)'**
  String get publishFieldArea;

  /// No description provided for @publishListingType.
  ///
  /// In en, this message translates to:
  /// **'Listing type'**
  String get publishListingType;

  /// No description provided for @publishTypeSale.
  ///
  /// In en, this message translates to:
  /// **'For sale'**
  String get publishTypeSale;

  /// No description provided for @publishTypeRent.
  ///
  /// In en, this message translates to:
  /// **'For rent'**
  String get publishTypeRent;

  /// No description provided for @publishRentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Rent period'**
  String get publishRentPeriod;

  /// No description provided for @publishPeriodNight.
  ///
  /// In en, this message translates to:
  /// **'Per night'**
  String get publishPeriodNight;

  /// No description provided for @publishPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'Per month'**
  String get publishPeriodMonth;

  /// No description provided for @publishPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'Per year'**
  String get publishPeriodYear;

  /// No description provided for @publishPropertyType.
  ///
  /// In en, this message translates to:
  /// **'Property type'**
  String get publishPropertyType;

  /// No description provided for @propertyApartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get propertyApartment;

  /// No description provided for @propertyHouse.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get propertyHouse;

  /// No description provided for @propertyVilla.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get propertyVilla;

  /// No description provided for @propertyStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get propertyStudio;

  /// No description provided for @propertyRiad.
  ///
  /// In en, this message translates to:
  /// **'Riad'**
  String get propertyRiad;

  /// No description provided for @propertyGuestHouse.
  ///
  /// In en, this message translates to:
  /// **'Guest house'**
  String get propertyGuestHouse;

  /// No description provided for @publishPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos (up to 5)'**
  String get publishPhotosTitle;

  /// No description provided for @publishAddFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get publishAddFromGallery;

  /// No description provided for @publishAddFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get publishAddFromCamera;

  /// No description provided for @publishRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get publishRemovePhoto;

  /// No description provided for @listingErrorTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get listingErrorTitleRequired;

  /// No description provided for @listingErrorDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a description'**
  String get listingErrorDescriptionRequired;

  /// No description provided for @listingErrorPriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a price of 0 or more'**
  String get listingErrorPriceInvalid;

  /// No description provided for @listingErrorCityRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a city'**
  String get listingErrorCityRequired;

  /// No description provided for @listingErrorRentPeriodRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a rent period'**
  String get listingErrorRentPeriodRequired;

  /// No description provided for @listingErrorNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get listingErrorNumberInvalid;

  /// No description provided for @listingErrorNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Please sign in first'**
  String get listingErrorNotSignedIn;

  /// No description provided for @listingErrorNoPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add at least one photo'**
  String get listingErrorNoPhotos;

  /// No description provided for @listingErrorTooManyPhotos.
  ///
  /// In en, this message translates to:
  /// **'You can add up to 5 photos'**
  String get listingErrorTooManyPhotos;

  /// No description provided for @listingErrorNoNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get listingErrorNoNetwork;

  /// No description provided for @listingErrorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to do this'**
  String get listingErrorPermissionDenied;

  /// No description provided for @listingErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again'**
  String get listingErrorUnknown;

  /// No description provided for @photoErrorTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This photo is too large, choose another one'**
  String get photoErrorTooLarge;

  /// No description provided for @photoErrorReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read this photo'**
  String get photoErrorReadFailed;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About Vesta'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy and account deletion'**
  String get settingsPrivacy;

  /// No description provided for @settingsContact.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get settingsContact;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsLinkError.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link'**
  String get settingsLinkError;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your email. If an account exists, we send you a link to choose a new password.'**
  String get forgotPasswordBody;

  /// No description provided for @forgotPasswordSend.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get forgotPasswordSend;

  /// No description provided for @forgotPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for this email, a reset link has been sent.'**
  String get forgotPasswordSent;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @verifyBannerText.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email address.'**
  String get verifyBannerText;

  /// No description provided for @verifyBannerResend.
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get verifyBannerResend;

  /// No description provided for @verifyBannerSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent'**
  String get verifyBannerSent;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts, please try again in a few minutes'**
  String get authErrorTooManyRequests;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
