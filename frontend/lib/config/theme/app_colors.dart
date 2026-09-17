import 'package:flutter/material.dart';

/// Paleta de colores oficial y design tokens de DevTalles.
/// Basado en docs/references/imagen_corporativa_devtalles.md
abstract final class AppColors {
  // Fondos y superficies
  static const Color bgPrimary = Color(0xFF171027);
  static const Color bgBox = Color(0xFF1C1829);
  static const Color cardBg = Color(0xD91C1829); // rgba(28, 24, 41, 0.85)
  static const Color cardBorder = Color(0x1FC0B9FC); // rgba(192, 185, 252, 0.12)
  static const Color cardBorderHover = Color(0x4DC0B9FC); // rgba(192, 185, 252, 0.30)
  static const Color navBg = Color(0xD9171027); // rgba(23, 16, 39, 0.85)

  // Acentos cósmicos
  static const Color accentElectric = Color(0xFF3A14C4);
  static const Color accentMid = Color(0xFF4725AF);
  static const Color accentDeep = Color(0xFF5A16C1);
  static const Color accentLavender = Color(0xFFC0B9FC);
  static const Color accentVividLime = Color(0xFFC8DD09);
  static const Color brandDiscord = Color(0xFF5865F2);

  // Tipografía y textos
  static const Color textMain = Color(0xFFF0EEFF);
  static const Color textMuted = Color(0xFF9B93C8);
  static const Color textSub = Color(0x8CC0B9FC); // rgba(192, 185, 252, 0.55)

  // Categorías de cursos
  static const Color catBasesBg = Color(0x33C0B9FC);
  static const Color catBasesBorder = Color(0xFFC0B9FC);

  static const Color catFrontendBg = Color(0x8C300A6F);
  static const Color catFrontendBorder = Color(0xFF7E70F9);

  static const Color catBackendBg = Color(0x803A14C4);
  static const Color catBackendBorder = Color(0xFF3A14C4);

  static const Color catMovilBg = Color(0x40C8DD09);
  static const Color catMovilBorder = Color(0xFFC8DD09);

  static const Color catWebBg = Color(0x40F4AEA3);
  static const Color catWebBorder = Color(0xFFF4AEA3);

  static const Color catAiBg = Color(0x59A200FF);
  static const Color catAiBorder = Color(0xFFA200FF);

  // Prioridades de Ruta (WCAG 2.2)
  static const Color levelRequired = Color(0xFFEF4444);
  static const Color levelRequiredBg = Color(0x26EF4444);

  static const Color levelRecommended = Color(0xFFC8DD09);
  static const Color levelRecommendedBg = Color(0x26C8DD09);

  static const Color levelOptional = Color(0xFFC0B9FC);
  static const Color levelOptionalBg = Color(0x26C0B9FC);
}
