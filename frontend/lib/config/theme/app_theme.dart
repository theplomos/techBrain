import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Configuración global del tema DevTalles (Dark Mode First).
abstract final class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgPrimary,
      primaryColor: AppColors.accentElectric,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentElectric,
        secondary: AppColors.accentVividLime,
        surface: AppColors.bgBox,
        error: AppColors.levelRequired,
        onPrimary: Colors.white,
        onSecondary: Color(0xFF0F172A),
        onSurface: AppColors.textMain,
      ),
      fontFamily: AppTypography.bodyFamily,
      fontFamilyFallback: AppTypography.fontFallbacks,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.h3,
        iconTheme: IconThemeData(color: AppColors.textMain),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: const BorderSide(color: AppColors.cardBorder, width: 1.0),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.cardBorder,
        thickness: 1.0,
      ),
    );
  }
}
