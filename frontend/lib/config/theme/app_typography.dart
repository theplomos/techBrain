import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Jerarquía tipográfica oficial de DevTalles:
/// - Space Grotesk: Títulos, branding, números y métricas.
/// - DM Sans: Párrafos, botones, chips y navegación.
abstract final class AppTypography {
  // Familias con fallbacks robustos
  static const String headingFamily = 'Space Grotesk';
  static const String bodyFamily = 'DM Sans';
  static const List<String> fontFallbacks = <String>[
    '-apple-system',
    'BlinkMacSystemFont',
    'Segoe UI',
    'Roboto',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  // Headings (Space Grotesk)
  static const TextStyle h1 = TextStyle(
    fontFamily: headingFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textMain,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: headingFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textMain,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: headingFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textMain,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle numberHighlight = TextStyle(
    fontFamily: headingFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textMain,
  );

  // Body & UI (DM Sans)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textMain,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // Botones (Píldora: mayúsculas, tracking amplio)
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: bodyFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 13.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
    color: Colors.white,
  );

  static const TextStyle buttonVivid = TextStyle(
    fontFamily: bodyFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: Color(0xFF0F172A),
  );

  // Tags y encabezados de columna
  static const TextStyle columnHeader = TextStyle(
    fontFamily: bodyFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.5,
    color: AppColors.textSub,
  );

  static const TextStyle badgeText = TextStyle(
    fontFamily: bodyFamily,
    fontFamilyFallback: fontFallbacks,
    fontSize: 11.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );
}
