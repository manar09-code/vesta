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
  String get listingErrorPriceInvalid => 'Entrez un prix supérieur ou égal à 0';

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
  String get contactPhoneLabel => 'Numéro de téléphone';

  @override
  String get contactPhoneHint => '20 123 456';

  @override
  String get contactWhatsappSwitch => 'J\'accepte les messages WhatsApp';

  @override
  String get contactErrorPhoneInvalid =>
      'Entrez 8 chiffres commençant par 2, 3, 4, 5, 7 ou 9';

  @override
  String get contactCallButton => 'Appeler';

  @override
  String get contactWhatsappButton => 'WhatsApp';

  @override
  String get contactSignInToSee => 'Connectez-vous pour voir le contact';

  @override
  String get contactNotAvailable => 'Contact indisponible';

  @override
  String get contactNoWhatsapp =>
      'WhatsApp n\'est pas installé sur ce téléphone';

  @override
  String get contactCallFailed => 'Impossible d\'ouvrir le composeur';

  @override
  String contactWhatsappMessage(String title) {
    return 'Bonjour, votre annonce $title sur Vesta m\'intéresse';
  }

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
}
