// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Vesta';

  @override
  String get tabExplore => 'Explorer';

  @override
  String get tabSearch => 'Recherche';

  @override
  String get tabMap => 'Carte';

  @override
  String get tabFavorites => 'Favoris';

  @override
  String get tabProfile => 'Profil';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get chatTitle => 'Messages';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get languageLabel => 'Langue';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Mot de passe';

  @override
  String get authDisplayNameLabel => 'Nom complet';

  @override
  String get authLoginButton => 'Se connecter';

  @override
  String get authSignUpTitle => 'Créer un compte';

  @override
  String get authSignUpButton => 'Inscription';

  @override
  String get authGoToSignUp => 'Pas de compte ? Inscrivez-vous';

  @override
  String get authGoToLogin => 'Déjà un compte ? Connectez-vous';

  @override
  String get authLogoutButton => 'Se déconnecter';

  @override
  String get authErrorInvalidEmail => 'Entrez une adresse email valide';

  @override
  String get authErrorPasswordShort =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get authErrorNameRequired => 'Entrez votre nom';

  @override
  String get authErrorEmailInUse => 'Cet email est déjà utilisé';

  @override
  String get authErrorWrongPassword => 'Email ou mot de passe incorrect';

  @override
  String get authErrorNoNetwork => 'Pas de connexion internet';

  @override
  String get authErrorUnknown => 'Une erreur est survenue, réessayez';
}
