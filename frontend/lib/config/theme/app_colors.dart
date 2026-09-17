import 'package:flutter/material.dart';

/// Paleta de TechBrain.
///
/// Los valores salen de las tablas de tokens de
/// `docs/references/imagen_corporativa_devtalles.md` y de la spec 01.
/// No se inventa ningún color: si hace falta uno nuevo, primero se añade al
/// sistema de diseño.
abstract final class AppColors {
  // Fondos y superficies.
  static const Color bgPrimary = Color(0xFF171027);
  static const Color bgBox = Color(0xFF1C1829);
  static const Color cardBg = Color.fromRGBO(28, 24, 41, 0.85);
  static const Color navBg = Color.fromRGBO(23, 16, 39, 0.85);

  // Bordes.
  static const Color cardBorder = Color.fromRGBO(192, 185, 252, 0.12);
  static const Color cardBorderHover = Color.fromRGBO(192, 185, 252, 0.30);

  // Acentos.
  static const Color accentElectric = Color(0xFF3A14C4);
  static const Color accentMid = Color(0xFF4725AF);
  static const Color accentDeep = Color(0xFF5A16C1);
  static const Color accentLavender = Color(0xFFC0B9FC);
  static const Color accentVivid = Color(0xFFC8DD09);
  static const Color brandDiscord = Color(0xFF5865F2);

  // Texto.
  static const Color textMain = Color(0xFFF0EEFF);
  static const Color textMuted = Color(0xFF9B93C8);
  static const Color textSub = Color.fromRGBO(192, 185, 252, 0.55);
  static const Color textOnVivid = Color(0xFF0F172A);

  /// Rojo de error del ColorScheme y del nivel REQUERIDO.
  static const Color errorRed = Color(0xFFEF4444);

  // Chips de nivel (CourseLevel).
  static const Color levelRequiredBg = Color.fromRGBO(239, 68, 68, 0.15);
  static const Color levelRequiredBorder = Color.fromRGBO(239, 68, 68, 0.40);
  static const Color levelRequiredFg = Color(0xFFEF4444);

  static const Color levelRecommendedBg = Color.fromRGBO(200, 221, 9, 0.15);
  static const Color levelRecommendedBorder = Color.fromRGBO(200, 221, 9, 0.40);
  static const Color levelRecommendedFg = Color(0xFFC8DD09);

  static const Color levelOptionalBg = Color.fromRGBO(192, 185, 252, 0.15);
  static const Color levelOptionalBorder = Color.fromRGBO(192, 185, 252, 0.30);
  static const Color levelOptionalFg = Color(0xFFC0B9FC);

  // Chips de categoría (CourseCategory).
  static const Color catBasesBg = Color.fromRGBO(192, 185, 252, 0.20);
  static const Color catBasesBorder = Color(0xFFC0B9FC);

  static const Color catFrontendBg = Color.fromRGBO(48, 10, 111, 0.55);
  static const Color catFrontendBorder = Color(0xFF7E70F9);

  static const Color catBackendBg = Color.fromRGBO(58, 20, 196, 0.50);
  static const Color catBackendBorder = Color(0xFF3A14C4);

  static const Color catMobileBg = Color.fromRGBO(200, 221, 9, 0.25);
  static const Color catMobileBorder = Color(0xFFC8DD09);

  static const Color catAiAgentsBg = Color.fromRGBO(162, 0, 255, 0.35);
  static const Color catAiAgentsBorder = Color(0xFFA200FF);

  /// FULLSTACK reutiliza los tokens que el sistema de diseño llama WEB:
  /// ningún curso usa la categoría WEB, y FULLSTACK no tenía chip propio.
  static const Color catFullstackBg = Color.fromRGBO(244, 174, 163, 0.25);
  static const Color catFullstackBorder = Color(0xFFF4AEA3);
}
