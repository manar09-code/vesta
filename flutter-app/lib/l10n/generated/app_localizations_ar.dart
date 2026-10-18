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
}
