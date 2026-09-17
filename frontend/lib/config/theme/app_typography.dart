import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Familias empaquetadas en `assets/fonts/`.
///
/// Los nombres coinciden con la clave `family` de `pubspec.yaml`.
abstract final class AppFonts {
  /// Títulos, cifras y marca.
  static const String heading = 'SpaceGrotesk';

  /// Texto corrido, botones, chips y navegación.
  static const String body = 'DMSans';
}

/// Estilos que Material 3 no cubre.
abstract final class AppTextStyles {
  /// Texto de PillButton en sus variantes primary y secondary.
  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    letterSpacing: 2.0,
  );

  /// Texto de PillButton en la variante vivid.
  static const TextStyle buttonVivid = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: 13.0,
    letterSpacing: 1.5,
  );

  /// Texto de LevelBadge y CategoryBadge.
  static const TextStyle chip = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    letterSpacing: 1.5,
  );

  /// Encabezado de las columnas REQUERIDO / RECOMENDADO / OPCIONAL.
  static const TextStyle columnHeader = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    letterSpacing: 2.5,
    color: AppColors.textSub,
  );
}

/// TextTheme de Material 3 con las familias de TechBrain aplicadas.
///
/// Se conservan los tamaños de Material 3 y solo se cambian familia, peso y
/// color: `display*`, `headline*` y `title*` en Space Grotesk; `body*` y
/// `label*` en DM Sans.
TextTheme buildAppTextTheme() {
  final TextTheme base = Typography.material2021(
    platform: TargetPlatform.android,
  ).white.apply(bodyColor: AppColors.textMain, displayColor: AppColors.textMain);

  TextStyle heading(TextStyle? style, FontWeight weight) =>
      style!.copyWith(fontFamily: AppFonts.heading, fontWeight: weight);

  TextStyle body(TextStyle? style) =>
      style!.copyWith(fontFamily: AppFonts.body);

  return base.copyWith(
    displayLarge: heading(base.displayLarge, FontWeight.w700),
    displayMedium: heading(base.displayMedium, FontWeight.w700),
    displaySmall: heading(base.displaySmall, FontWeight.w700),
    headlineLarge: heading(base.headlineLarge, FontWeight.w600),
    headlineMedium: heading(base.headlineMedium, FontWeight.w600),
    headlineSmall: heading(base.headlineSmall, FontWeight.w600),
    titleLarge: heading(base.titleLarge, FontWeight.w600),
    titleMedium: heading(base.titleMedium, FontWeight.w600),
    titleSmall: heading(base.titleSmall, FontWeight.w600),
    bodyLarge: body(base.bodyLarge),
    bodyMedium: body(base.bodyMedium),
    bodySmall: body(base.bodySmall),
    labelLarge: body(base.labelLarge),
    labelMedium: body(base.labelMedium),
    labelSmall: body(base.labelSmall),
  );
}
