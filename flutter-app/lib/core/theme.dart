import 'package:flutter/material.dart';

/// Jetons de design Vesta — palette navy / or / crème (maquette de refonte).
class VestaColors {
  VestaColors._();

  static const ink = Color(0xFF13294B); // texte principal / navy
  static const inkSoft = Color(0xFF1B3760); // onglet actif, chips actives
  static const primary = Color(0xFF13294B); // bouton principal
  static const primaryHover = Color(0xFF1C3A64);
  static const link = Color(0xFF1B3760);

  static const gold = Color(0xFFC6973F); // marque + CTA
  static const goldDeep = Color(0xFFAF7F2E); // eyebrow sur crème
  static const goldTab = Color(0xFFC6973F); // piste / onglet actif
  static const goldEm = Color(0xFFD9A75C); // <em> doré sur navy
  static const goldCard = Color(0xFFAF7F2E); // sur-titre carte
  static const focus = Color(0xFFC6973F); // anneau de focus

  static const page = Color(0xFFEFEAE0); // fond de page
  static const shell = Color(0xFFF8F4EC); // fond de l'« app shell »
  static const header = Color(0xFFF1ECDF); // en-tête de la liste
  static const spec = Color(0xFFF0ECE1); // pastilles surface/chambres
  static const badgeBg = Color(0xFFF6EFDF);
  static const badgeText = Color(0xFF8A6522);

  static const border = Color(0xFFE7E1D4);
  static const borderInput = Color(0xFFE2DCCE);
  static const borderCard = Color(0xFFEEE9DD);
  static const borderSoft = Color(0xFFE7E1D4);

  static const muted = Color(0xFF6E7688);
  static const muted2 = Color(0xFF7E8595);
  static const muted3 = Color(0xFF868D9C);
  static const muted4 = Color(0xFF868D9A);
  static const placeholder = Color(0xFFA5A9B4);

  static const errorBg = Color(0xFFFFF0ED);
  static const errorText = Color(0xFF9C4031);

  static const heart = Color(0xFFBF624C);
  static const navActive = Color(0xFF13294B);
  static const navIdle = Color(0xFF9AA0AE);

  // ——— Héros d'authentification (refonte) ———
  static const authTop1 = Color(0xFF1E3A66);
  static const authTop2 = Color(0xFF16305A);
  static const authTop3 = Color(0xFF0F2445);
  static const heroPhoto = Color(0xFF24406B); // repli si l'image manque
  static const sheet = Color(0xFFF7F2E8); // panneau crème
  static const sheetTrack = Color(0xFFEBE5D8); // piste des onglets segmentés
  static const wave = Color(0xFFEFE3CB); // vague décorative
  static const eyebrowOnDark = Color(0xFFD9A75C);
}

/// Typographies Vesta : DM Serif Display (titres) + DM Sans (texte).
class VestaFonts {
  VestaFonts._();

  static const serif = 'DM Serif Display';
  static const sans = 'DM Sans';
}

/// Typographies Vesta : accessibles via `Theme.of(context).extension<VestaTextStyle>()`.
class VestaTextStyle extends ThemeExtension<VestaTextStyle> {
  const VestaTextStyle();

  TextStyle serifStyle(double size, {Color? color, double? height, double? letterSpacing}) => TextStyle(
        fontFamily: VestaFonts.serif,
        fontSize: size,
        height: height,
        letterSpacing: letterSpacing,
        color: color ?? VestaColors.ink,
      );

  TextStyle body(double size, {Color? color, FontWeight weight = FontWeight.w400, double? height}) => TextStyle(
        fontFamily: VestaFonts.sans,
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color ?? VestaColors.ink,
      );

  @override
  VestaTextStyle copyWith() => const VestaTextStyle();

  @override
  VestaTextStyle lerp(VestaTextStyle? other, double t) => const VestaTextStyle();
}

/// Thème global de l'application Vesta.
class VestaTheme {
  VestaTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: VestaColors.shell,
      colorScheme: ColorScheme.fromSeed(
        seedColor: VestaColors.primary,
        primary: VestaColors.primary,
        surface: VestaColors.shell,
        error: VestaColors.errorText,
      ),
      splashFactory: InkRipple.splashFactory,
    );

    return base.copyWith(
      extensions: const <ThemeExtension<dynamic>>[VestaTextStyle()],
      textTheme: base.textTheme.apply(
        fontFamily: VestaFonts.sans,
        bodyColor: VestaColors.ink,
        displayColor: VestaColors.ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: const TextStyle(
          fontFamily: VestaFonts.sans,
          fontSize: 13,
          color: VestaColors.placeholder,
        ),
        labelStyle: const TextStyle(
          fontFamily: VestaFonts.sans,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: VestaColors.ink,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: VestaColors.borderInput),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: VestaColors.borderInput),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: VestaColors.focus, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: VestaColors.focus),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: VestaColors.focus, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: VestaColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontFamily: VestaFonts.sans,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: VestaColors.inkSoft,
          side: const BorderSide(color: VestaColors.inkSoft),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontFamily: VestaFonts.sans,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: VestaColors.link,
          textStyle: const TextStyle(
            fontFamily: VestaFonts.sans,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(color: VestaColors.border, thickness: 1),
    );
  }
}
