// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Vesta';

  @override
  String get tabExplore => 'اكتشف';

  @override
  String get tabSearch => 'بحث';

  @override
  String get tabMap => 'الخريطة';

  @override
  String get tabFavorites => 'المفضلة';

  @override
  String get tabProfile => 'حسابي';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get chatTitle => 'الرسائل';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get comingSoon => 'قريبا';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authPasswordLabel => 'كلمة السر';

  @override
  String get authDisplayNameLabel => 'الاسم الكامل';

  @override
  String get authLoginButton => 'دخول';

  @override
  String get authSignUpTitle => 'إنشاء حساب';

  @override
  String get authSignUpButton => 'تسجيل';

  @override
  String get authGoToSignUp => 'ما عندكش حساب؟ سجّل';

  @override
  String get authGoToLogin => 'عندك حساب؟ ادخل';

  @override
  String get authLogoutButton => 'خروج';

  @override
  String get signInToContinueTitle => 'ادخل باش تكمل';

  @override
  String get signInToContinueBody =>
      'ادخل لحسابك ولا اعمل حساب جديد باش تزيد في المفضلة، تبعث رسالة للمالك وتنشر إعلان.';

  @override
  String get authErrorInvalidEmail => 'أدخل بريد إلكتروني صحيح';

  @override
  String get authErrorPasswordShort => 'كلمة السر لازم تكون 8 حروف على الأقل';

  @override
  String get authErrorNameRequired => 'أدخل اسمك';

  @override
  String get authErrorEmailInUse => 'البريد هذا مستعمل من قبل';

  @override
  String get authErrorWrongPassword => 'البريد الإلكتروني أو كلمة السر غالطين';

  @override
  String get authErrorNoNetwork => 'ما فماش اتصال بالإنترنت';

  @override
  String get authErrorUnknown => 'صار مشكل، عاود جرّب';

  @override
  String get publishTitle => 'انشر إعلان';

  @override
  String get publishButton => 'انشر إعلان';

  @override
  String get publishSubmit => 'نشر';

  @override
  String get publishSuccess => 'تم نشر الإعلان متاعك';

  @override
  String get publishFieldTitle => 'العنوان';

  @override
  String get publishFieldDescription => 'الوصف';

  @override
  String get publishFieldPrice => 'السوم (دينار)';

  @override
  String get publishFieldCity => 'المدينة';

  @override
  String get publishFieldBedrooms => 'عدد البيوت (اختياري)';

  @override
  String get publishFieldBathrooms => 'عدد بيوت الماء (اختياري)';

  @override
  String get publishFieldArea => 'المساحة بالمتر مربع (اختياري)';

  @override
  String get publishListingType => 'نوع الإعلان';

  @override
  String get publishTypeSale => 'للبيع';

  @override
  String get publishTypeRent => 'للكراء';

  @override
  String get publishRentPeriod => 'مدة الكراء';

  @override
  String get publishPeriodNight => 'في الليلة';

  @override
  String get publishPeriodMonth => 'في الشهر';

  @override
  String get publishPeriodYear => 'في العام';

  @override
  String get publishPropertyType => 'نوع العقار';

  @override
  String get propertyApartment => 'شقة';

  @override
  String get propertyHouse => 'دار';

  @override
  String get propertyVilla => 'فيلا';

  @override
  String get propertyStudio => 'ستوديو';

  @override
  String get propertyRiad => 'رياض';

  @override
  String get propertyGuestHouse => 'دار ضيافة';

  @override
  String get publishPhotosTitle => 'الصور (حتى 5)';

  @override
  String get publishAddFromGallery => 'المعرض';

  @override
  String get publishAddFromCamera => 'الكاميرا';

  @override
  String get publishRemovePhoto => 'احذف الصورة';

  @override
  String get listingErrorTitleRequired => 'أدخل العنوان';

  @override
  String get listingErrorDescriptionRequired => 'أدخل الوصف';

  @override
  String get listingErrorPriceInvalid => 'أدخل سوم يساوي 0 أو أكثر';

  @override
  String get listingErrorCityRequired => 'أدخل المدينة';

  @override
  String get listingErrorRentPeriodRequired => 'اختار مدة الكراء';

  @override
  String get listingErrorNumberInvalid => 'أدخل رقم صحيح';

  @override
  String get listingErrorNotSignedIn => 'سجّل الدخول قبل';

  @override
  String get listingErrorNoPhotos => 'زيد صورة على الأقل';

  @override
  String get listingErrorTooManyPhotos => 'تنجم تزيد 5 صور كحد أقصى';

  @override
  String get listingErrorNoNetwork => 'ما فماش اتصال بالإنترنت';

  @override
  String get listingErrorPermissionDenied => 'ما عندكش الصلاحية باش تعمل هذا';

  @override
  String get listingErrorUnknown => 'صار مشكل، عاود جرّب';

  @override
  String get photoErrorTooLarge => 'الصورة هذي كبيرة برشا، اختار وحدة أخرى';

  @override
  String get photoErrorReadFailed => 'ما نجمناش نقراو الصورة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsAbout => 'على Vesta';

  @override
  String get settingsVersion => 'الإصدار';

  @override
  String get settingsPrivacy => 'الخصوصية وفسخ الحساب';

  @override
  String get settingsContact => 'اتصل بينا';

  @override
  String get settingsDeleteAccount => 'فسخ حسابي';

  @override
  String get settingsLinkError => 'ما نجمناش نحلو الرابط';

  @override
  String get authForgotPassword => 'نسيت كلمة السر؟';

  @override
  String get forgotPasswordTitle => 'بدّل كلمة السر';

  @override
  String get forgotPasswordBody =>
      'أدخل البريد الإلكتروني. كان فما حساب، باش نبعثولك رابط باش تختار كلمة سر جديدة.';

  @override
  String get forgotPasswordSend => 'ابعث الرابط';

  @override
  String get forgotPasswordSent => 'كان فما حساب بالبريد هذا، تبعثلو رابط.';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get verifyBannerText => 'لازم تأكد البريد الإلكتروني متاعك.';

  @override
  String get verifyBannerResend => 'ابعث مرة أخرى';

  @override
  String get verifyBannerSent => 'تبعث إيميل التأكيد';
}
