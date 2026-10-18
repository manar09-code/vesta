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
}
