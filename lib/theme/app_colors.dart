import 'package:flutter/material.dart';

import '../const.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color neutral0;
  final Color neutral50;
  final Color neutral100;
  final Color neutral200;
  final Color neutral300;
  final Color neutral400;
  final Color neutral500;
  final Color neutral600;
  final Color neutral700;
  final Color neutral800;
  final Color neutral850;
  final Color neutral900;

  final Color success50;
  final Color success100;
  final Color success200;
  final Color success300;
  final Color success400;
  final Color success500;
  final Color success600;
  final Color success700;
  final Color success800;
  final Color success900;

  final Color warning50;
  final Color warning100;
  final Color warning200;
  final Color warning300;
  final Color warning400;
  final Color warning500;
  final Color warning600;
  final Color warning700;
  final Color warning800;
  final Color warning900;

  final Color error50;
  final Color error100;
  final Color error200;
  final Color error300;
  final Color error400;
  final Color error500;
  final Color error600;
  final Color error700;
  final Color error800;
  final Color error900;

  // Semantic colors for cross-mapped light/dark patterns
  final Color cardSurface; // light: lightNeutral0, dark: darkNeutral100
  final Color scaffoldSurface; // light: lightNeutral100, dark: darkNeutral0
  final Color tileSurface; // light: lightNeutral0, dark: darkNeutral50
  final Color bodyText; // light: lightNeutral850, dark: darkNeutral900
  final Color iconPrimary; // light: lightNeutral700, dark: darkNeutral850
  final Color iconSecondary; // light: lightNeutral600, dark: darkNeutral700
  final Color subtleElement; // light: lightNeutral300, dark: darkNeutral500
  final Color textOnGradient; // light: lightNeutral50, dark: lightNeutral100

  const AppColors({
    required this.neutral0,
    required this.neutral50,
    required this.neutral100,
    required this.neutral200,
    required this.neutral300,
    required this.neutral400,
    required this.neutral500,
    required this.neutral600,
    required this.neutral700,
    required this.neutral800,
    required this.neutral850,
    required this.neutral900,
    required this.success50,
    required this.success100,
    required this.success200,
    required this.success300,
    required this.success400,
    required this.success500,
    required this.success600,
    required this.success700,
    required this.success800,
    required this.success900,
    required this.warning50,
    required this.warning100,
    required this.warning200,
    required this.warning300,
    required this.warning400,
    required this.warning500,
    required this.warning600,
    required this.warning700,
    required this.warning800,
    required this.warning900,
    required this.error50,
    required this.error100,
    required this.error200,
    required this.error300,
    required this.error400,
    required this.error500,
    required this.error600,
    required this.error700,
    required this.error800,
    required this.error900,
    required this.cardSurface,
    required this.scaffoldSurface,
    required this.tileSurface,
    required this.bodyText,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.subtleElement,
    required this.textOnGradient,
  });

  static const light = AppColors(
    neutral0: lightNeutral0,
    neutral50: lightNeutral50,
    neutral100: lightNeutral100,
    neutral200: lightNeutral200,
    neutral300: lightNeutral300,
    neutral400: lightNeutral400,
    neutral500: lightNeutral500,
    neutral600: lightNeutral600,
    neutral700: lightNeutral700,
    neutral800: lightNeutral800,
    neutral850: lightNeutral850,
    neutral900: lightNeutral900,
    success50: lightSuccess50,
    success100: lightSuccess100,
    success200: lightSuccess200,
    success300: lightSuccess300,
    success400: lightSuccess400,
    success500: lightSuccess500,
    success600: lightSuccess600,
    success700: lightSuccess700,
    success800: lightSuccess800,
    success900: lightSuccess900,
    warning50: lightWarning50,
    warning100: lightWarning100,
    warning200: lightWarning200,
    warning300: lightWarning300,
    warning400: lightWarning400,
    warning500: lightWarning500,
    warning600: lightWarning600,
    warning700: lightWarning700,
    warning800: lightWarning800,
    warning900: lightWarning900,
    error50: lightError50,
    error100: lightError100,
    error200: lightError200,
    error300: lightError300,
    error400: lightError400,
    error500: lightError500,
    error600: lightError600,
    error700: lightError700,
    error800: lightError800,
    error900: lightError900,
    cardSurface: lightNeutral0,
    scaffoldSurface: lightNeutral100,
    tileSurface: lightNeutral0,
    bodyText: lightNeutral850,
    iconPrimary: lightNeutral700,
    iconSecondary: lightNeutral600,
    subtleElement: lightNeutral300,
    textOnGradient: lightNeutral50,
  );

  static const dark = AppColors(
    neutral0: darkNeutral0,
    neutral50: darkNeutral50,
    neutral100: darkNeutral100,
    neutral200: darkNeutral200,
    neutral300: darkNeutral300,
    neutral400: darkNeutral400,
    neutral500: darkNeutral500,
    neutral600: darkNeutral600,
    neutral700: darkNeutral700,
    neutral800: darkNeutral800,
    neutral850: darkNeutral850,
    neutral900: darkNeutral900,
    success50: darkSuccess50,
    success100: darkSuccess100,
    success200: darkSuccess200,
    success300: darkSuccess300,
    success400: darkSuccess400,
    success500: darkSuccess500,
    success600: darkSuccess600,
    success700: darkSuccess700,
    success800: darkSuccess800,
    success900: darkSuccess900,
    warning50: darkWarning50,
    warning100: darkWarning100,
    warning200: darkWarning200,
    warning300: darkWarning300,
    warning400: darkWarning400,
    warning500: darkWarning500,
    warning600: darkWarning600,
    warning700: darkWarning700,
    warning800: darkWarning800,
    warning900: darkWarning900,
    error50: darkError50,
    error100: darkError100,
    error200: darkError200,
    error300: darkError300,
    error400: darkError400,
    error500: darkError500,
    error600: darkError600,
    error700: darkError700,
    error800: darkError800,
    error900: darkError900,
    cardSurface: darkNeutral100,
    scaffoldSurface: darkNeutral0,
    tileSurface: darkNeutral50,
    bodyText: darkNeutral900,
    iconPrimary: darkNeutral850,
    iconSecondary: darkNeutral700,
    subtleElement: darkNeutral500,
    textOnGradient: lightNeutral100,
  );

  @override
  AppColors copyWith({
    Color? neutral0,
    Color? neutral50,
    Color? neutral100,
    Color? neutral200,
    Color? neutral300,
    Color? neutral400,
    Color? neutral500,
    Color? neutral600,
    Color? neutral700,
    Color? neutral800,
    Color? neutral850,
    Color? neutral900,
    Color? success50,
    Color? success100,
    Color? success200,
    Color? success300,
    Color? success400,
    Color? success500,
    Color? success600,
    Color? success700,
    Color? success800,
    Color? success900,
    Color? warning50,
    Color? warning100,
    Color? warning200,
    Color? warning300,
    Color? warning400,
    Color? warning500,
    Color? warning600,
    Color? warning700,
    Color? warning800,
    Color? warning900,
    Color? error50,
    Color? error100,
    Color? error200,
    Color? error300,
    Color? error400,
    Color? error500,
    Color? error600,
    Color? error700,
    Color? error800,
    Color? error900,
    Color? cardSurface,
    Color? scaffoldSurface,
    Color? tileSurface,
    Color? bodyText,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? subtleElement,
    Color? textOnGradient,
  }) {
    return AppColors(
      neutral0: neutral0 ?? this.neutral0,
      neutral50: neutral50 ?? this.neutral50,
      neutral100: neutral100 ?? this.neutral100,
      neutral200: neutral200 ?? this.neutral200,
      neutral300: neutral300 ?? this.neutral300,
      neutral400: neutral400 ?? this.neutral400,
      neutral500: neutral500 ?? this.neutral500,
      neutral600: neutral600 ?? this.neutral600,
      neutral700: neutral700 ?? this.neutral700,
      neutral800: neutral800 ?? this.neutral800,
      neutral850: neutral850 ?? this.neutral850,
      neutral900: neutral900 ?? this.neutral900,
      success50: success50 ?? this.success50,
      success100: success100 ?? this.success100,
      success200: success200 ?? this.success200,
      success300: success300 ?? this.success300,
      success400: success400 ?? this.success400,
      success500: success500 ?? this.success500,
      success600: success600 ?? this.success600,
      success700: success700 ?? this.success700,
      success800: success800 ?? this.success800,
      success900: success900 ?? this.success900,
      warning50: warning50 ?? this.warning50,
      warning100: warning100 ?? this.warning100,
      warning200: warning200 ?? this.warning200,
      warning300: warning300 ?? this.warning300,
      warning400: warning400 ?? this.warning400,
      warning500: warning500 ?? this.warning500,
      warning600: warning600 ?? this.warning600,
      warning700: warning700 ?? this.warning700,
      warning800: warning800 ?? this.warning800,
      warning900: warning900 ?? this.warning900,
      error50: error50 ?? this.error50,
      error100: error100 ?? this.error100,
      error200: error200 ?? this.error200,
      error300: error300 ?? this.error300,
      error400: error400 ?? this.error400,
      error500: error500 ?? this.error500,
      error600: error600 ?? this.error600,
      error700: error700 ?? this.error700,
      error800: error800 ?? this.error800,
      error900: error900 ?? this.error900,
      cardSurface: cardSurface ?? this.cardSurface,
      scaffoldSurface: scaffoldSurface ?? this.scaffoldSurface,
      tileSurface: tileSurface ?? this.tileSurface,
      bodyText: bodyText ?? this.bodyText,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      subtleElement: subtleElement ?? this.subtleElement,
      textOnGradient: textOnGradient ?? this.textOnGradient,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      neutral0: Color.lerp(neutral0, other.neutral0, t)!,
      neutral50: Color.lerp(neutral50, other.neutral50, t)!,
      neutral100: Color.lerp(neutral100, other.neutral100, t)!,
      neutral200: Color.lerp(neutral200, other.neutral200, t)!,
      neutral300: Color.lerp(neutral300, other.neutral300, t)!,
      neutral400: Color.lerp(neutral400, other.neutral400, t)!,
      neutral500: Color.lerp(neutral500, other.neutral500, t)!,
      neutral600: Color.lerp(neutral600, other.neutral600, t)!,
      neutral700: Color.lerp(neutral700, other.neutral700, t)!,
      neutral800: Color.lerp(neutral800, other.neutral800, t)!,
      neutral850: Color.lerp(neutral850, other.neutral850, t)!,
      neutral900: Color.lerp(neutral900, other.neutral900, t)!,
      success50: Color.lerp(success50, other.success50, t)!,
      success100: Color.lerp(success100, other.success100, t)!,
      success200: Color.lerp(success200, other.success200, t)!,
      success300: Color.lerp(success300, other.success300, t)!,
      success400: Color.lerp(success400, other.success400, t)!,
      success500: Color.lerp(success500, other.success500, t)!,
      success600: Color.lerp(success600, other.success600, t)!,
      success700: Color.lerp(success700, other.success700, t)!,
      success800: Color.lerp(success800, other.success800, t)!,
      success900: Color.lerp(success900, other.success900, t)!,
      warning50: Color.lerp(warning50, other.warning50, t)!,
      warning100: Color.lerp(warning100, other.warning100, t)!,
      warning200: Color.lerp(warning200, other.warning200, t)!,
      warning300: Color.lerp(warning300, other.warning300, t)!,
      warning400: Color.lerp(warning400, other.warning400, t)!,
      warning500: Color.lerp(warning500, other.warning500, t)!,
      warning600: Color.lerp(warning600, other.warning600, t)!,
      warning700: Color.lerp(warning700, other.warning700, t)!,
      warning800: Color.lerp(warning800, other.warning800, t)!,
      warning900: Color.lerp(warning900, other.warning900, t)!,
      error50: Color.lerp(error50, other.error50, t)!,
      error100: Color.lerp(error100, other.error100, t)!,
      error200: Color.lerp(error200, other.error200, t)!,
      error300: Color.lerp(error300, other.error300, t)!,
      error400: Color.lerp(error400, other.error400, t)!,
      error500: Color.lerp(error500, other.error500, t)!,
      error600: Color.lerp(error600, other.error600, t)!,
      error700: Color.lerp(error700, other.error700, t)!,
      error800: Color.lerp(error800, other.error800, t)!,
      error900: Color.lerp(error900, other.error900, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      scaffoldSurface: Color.lerp(scaffoldSurface, other.scaffoldSurface, t)!,
      tileSurface: Color.lerp(tileSurface, other.tileSurface, t)!,
      bodyText: Color.lerp(bodyText, other.bodyText, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      subtleElement: Color.lerp(subtleElement, other.subtleElement, t)!,
      textOnGradient: Color.lerp(textOnGradient, other.textOnGradient, t)!,
    );
  }
}

extension AppColorsExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
