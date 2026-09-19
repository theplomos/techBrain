import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Tema de TechBrain. Solo hay modo oscuro.
abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Transparente para que se vea el CosmicBackground que envuelve las rutas.
    scaffoldBackgroundColor: Colors.transparent,

    textTheme: buildAppTextTheme(),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentElectric,
      onPrimary: Colors.white,
      secondary: AppColors.accentVivid,
      onSecondary: AppColors.textOnVivid,
      surface: AppColors.bgBox,
      onSurface: AppColors.textMain,
      error: AppColors.errorRed,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.cardBorder,
      thickness: 1.0,
    ),
  );
}
