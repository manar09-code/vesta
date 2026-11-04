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
  String get signInToContinueTitle => 'Connectez-vous pour continuer';

  @override
  String get signInToContinueBody =>
      'Connectez-vous ou créez un compte pour ajouter des favoris, écrire aux propriétaires et publier des annonces.';

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

  @override
  String get publishTitle => 'Publier une annonce';

  @override
  String get publishButton => 'Publier une annonce';

  @override
  String get publishSubmit => 'Publier';

  @override
  String get publishSuccess => 'Votre annonce a été publiée';

  @override
  String get publishFieldTitle => 'Titre';

  @override
  String get publishFieldDescription => 'Description';

  @override
  String get publishFieldPrice => 'Prix (TND)';

  @override
  String get publishFieldCity => 'Ville';

  @override
  String get publishFieldBedrooms => 'Chambres (facultatif)';

  @override
  String get publishFieldBathrooms => 'Salles de bain (facultatif)';

  @override
  String get publishFieldArea => 'Surface en m² (facultatif)';

  @override
  String get publishListingType => 'Type d\'annonce';

  @override
  String get publishTypeSale => 'À vendre';

  @override
  String get publishTypeRent => 'À louer';

  @override
  String get publishRentPeriod => 'Période de location';

  @override
  String get publishPeriodNight => 'Par nuit';

  @override
  String get publishPeriodMonth => 'Par mois';

  @override
  String get publishPeriodYear => 'Par an';

  @override
  String get publishPropertyType => 'Type de bien';

  @override
  String get propertyApartment => 'Appartement';

  @override
  String get propertyHouse => 'Maison';

  @override
  String get propertyVilla => 'Villa';

  @override
  String get propertyStudio => 'Studio';

  @override
  String get propertyRiad => 'Riad';

  @override
  String get propertyGuestHouse => 'Maison d\'hôtes';

  @override
  String get publishPhotosTitle => 'Photos (jusqu\'à 5)';

  @override
  String get publishAddFromGallery => 'Galerie';

  @override
  String get publishAddFromCamera => 'Appareil photo';

  @override
  String get publishRemovePhoto => 'Supprimer la photo';

  @override
  String get listingErrorTitleRequired => 'Entrez un titre';

  @override
  String get listingErrorDescriptionRequired => 'Entrez une description';

  @override
  String get listingErrorPriceInvalid => 'Entrez un prix entre 1 et 50 000 000';

  @override
  String get listingErrorCityRequired => 'Entrez une ville';

  @override
  String get listingErrorRentPeriodRequired =>
      'Choisissez une période de location';

  @override
  String get listingErrorNumberInvalid => 'Entrez un nombre valide';

  @override
  String get listingErrorNotSignedIn => 'Connectez-vous d\'abord';

  @override
  String get listingErrorNoPhotos => 'Ajoutez au moins une photo';

  @override
  String get listingErrorTooManyPhotos =>
      'Vous pouvez ajouter 5 photos au maximum';

  @override
  String get listingErrorNoNetwork => 'Pas de connexion internet';

  @override
  String get listingErrorPermissionDenied =>
      'Vous n\'avez pas le droit de faire cela';

  @override
  String get listingErrorUnknown => 'Une erreur est survenue, réessayez';

  @override
  String get photoErrorTooLarge =>
      'Cette photo est trop lourde, choisissez-en une autre';

  @override
  String get photoErrorReadFailed => 'Impossible de lire cette photo';

  @override
  String get profileEditTitle => 'Modifier le profil';

  @override
  String get profileNameLabel => 'Nom';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileSaveButton => 'Enregistrer';

  @override
  String get profileChangePhoto => 'Changer la photo';

  @override
  String get profilePhotoGallery => 'Choisir dans la galerie';

  @override
  String get profilePhotoCamera => 'Prendre une photo';

  @override
  String get profileSaved => 'Profil enregistré';

  @override
  String get profileMyListings => 'Mes annonces';

  @override
  String get profileNoListings => 'Aucune annonce pour le moment';

  @override
  String get profileListingsLoadError => 'Impossible de charger vos annonces';

  @override
  String get profileEditListing => 'Modifier cette annonce';

  @override
  String get profileDeleteListing => 'Supprimer cette annonce';

  @override
  String get profileDeleteConfirmTitle => 'Supprimer cette annonce ?';

  @override
  String get profileDeleteConfirmBody =>
      'Ses photos seront aussi supprimées. Cette action est irréversible.';

  @override
  String get profileDeleteConfirm => 'Supprimer';

  @override
  String get profileCancel => 'Annuler';

  @override
  String get profileListingDeleted => 'Annonce supprimée';

  @override
  String get profileErrorNameRequired => 'Le nom est obligatoire';

  @override
  String get profileErrorNoNetwork => 'Pas de connexion. Veuillez réessayer.';

  @override
  String get profileErrorPermission => 'Action non autorisée';

  @override
  String get profileErrorNotSignedIn => 'Veuillez vous connecter';

  @override
  String get profileErrorUnknown =>
      'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get profilePhotoErrorTooLarge => 'Cette photo est trop lourde';

  @override
  String get profilePhotoErrorRead => 'Impossible de lire cette photo';

  @override
  String get favoritesEmptyTitle => 'Aucun favori pour l\'instant';

  @override
  String get favoritesEmptyBody =>
      'Appuie sur le cœur d\'une annonce pour la retrouver ici.';

  @override
  String get favoritesUnavailable => 'Cette annonce n\'est plus disponible';

  @override
  String get favoritesRemove => 'Retirer';

  @override
  String get favoritesRetry => 'Réessayer';

  @override
  String get favoritesErrorNoNetwork =>
      'Pas de connexion. Vérifie ton internet et réessaie.';

  @override
  String get favoritesErrorPermission => 'Tu n\'as pas le droit de faire cela.';

  @override
  String get favoritesErrorNotSignedIn =>
      'Connecte-toi pour enregistrer des favoris.';

  @override
  String get favoritesErrorUnknown => 'Une erreur est survenue. Réessaie.';

  @override
  String get listingsEmpty => 'Aucune annonce pour l\'instant';

  @override
  String get favoritesFilterAll => 'Tous';

  @override
  String get favoritesFilterBuy => 'Acheter';

  @override
  String get favoritesFilterRent => 'Louer';

  @override
  String get favoritesFilterStay => 'Séjourner';

  @override
  String get favoritesFilterEmpty => 'Aucun favori dans cette catégorie';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAbout => 'À propos de Vesta';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPrivacy => 'Confidentialité et suppression du compte';

  @override
  String get settingsContact => 'Nous contacter';

  @override
  String get settingsDeleteAccount => 'Supprimer mon compte';

  @override
  String get settingsLinkError => 'Impossible d’ouvrir le lien';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get forgotPasswordBody =>
      'Saisissez votre e-mail. Si un compte existe, nous vous envoyons un lien pour choisir un nouveau mot de passe.';

  @override
  String get forgotPasswordSend => 'Envoyer le lien';

  @override
  String get forgotPasswordSent =>
      'Si un compte existe pour cet e-mail, un lien a été envoyé.';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get verifyBannerText => 'Veuillez confirmer votre adresse e-mail.';

  @override
  String get verifyBannerResend => 'Renvoyer';

  @override
  String get verifyBannerSent => 'E-mail de vérification envoyé';

  @override
  String get authErrorTooManyRequests =>
      'Trop de tentatives, réessayez dans quelques minutes';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingStart => 'Commencer';

  @override
  String get onboardingTitle1 => 'Trouvez votre bien en Tunisie';

  @override
  String get onboardingBody1 =>
      'Parcourez des maisons d’hôtes, appartements et maisons pour séjourner, louer ou acheter.';

  @override
  String get onboardingTitle2 => 'Contactez le propriétaire';

  @override
  String get onboardingBody2 =>
      'Discutez avec lui par message, ou appelez-le ou écrivez-lui sur WhatsApp.';

  @override
  String get onboardingTitle3 => 'Publiez votre bien';

  @override
  String get onboardingBody3 =>
      'Ajoutez votre annonce avec des photos en quelques minutes.';
}
