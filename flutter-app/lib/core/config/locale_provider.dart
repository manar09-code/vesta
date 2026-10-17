import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Selected app language. `null` means "follow the phone language".
class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  void setLocale(Locale? locale) => state = locale;
}

final localeProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);
