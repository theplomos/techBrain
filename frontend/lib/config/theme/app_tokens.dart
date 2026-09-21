import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Radios de esquina.
abstract final class AppRadii {
  /// Tarjetas glass (RNF-03).
  static const double card = 18.0;

  /// Elementos dentro de una tarjeta, como la pestaña activa de la barra.
  static const double inner = 10.0;

  /// Botones e insignias en forma de píldora.
  static const double pill = 50.0;
}

/// Sombras y resplandores.
abstract final class AppShadows {
  /// Estado de reposo de una tarjeta glass.
  static const List<BoxShadow> glowSm = <BoxShadow>[
    BoxShadow(color: Color.fromRGBO(192, 185, 252, 0.06), spreadRadius: 1),
    BoxShadow(
      color: Color.fromRGBO(58, 20, 196, 0.18),
      offset: Offset(0, 8),
      blurRadius: 32,
    ),
  ];

  /// Tarjeta glass interactiva con el cursor encima o con el foco.
  static const List<BoxShadow> glowLg = <BoxShadow>[
    BoxShadow(color: Color.fromRGBO(192, 185, 252, 0.10), spreadRadius: 1),
    BoxShadow(
      color: Color.fromRGBO(58, 20, 196, 0.35),
      offset: Offset(0, 16),
      blurRadius: 48,
    ),
  ];

  static const List<BoxShadow> buttonPrimary = <BoxShadow>[
    BoxShadow(
      color: Color.fromRGBO(58, 20, 196, 0.39),
      offset: Offset(0, 4),
      blurRadius: 14,
    ),
  ];

  static const List<BoxShadow> buttonPrimaryHover = <BoxShadow>[
    BoxShadow(
      color: Color.fromRGBO(58, 20, 196, 0.55),
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  static const List<BoxShadow> buttonVivid = <BoxShadow>[
    BoxShadow(color: Color.fromRGBO(200, 221, 9, 0.35), blurRadius: 20),
  ];

  static const List<BoxShadow> buttonVividHover = <BoxShadow>[
    BoxShadow(color: Color.fromRGBO(200, 221, 9, 0.60), blurRadius: 30),
  ];
}

/// Duraciones y curvas.
abstract final class AppMotion {
  static const Duration hover = Duration(milliseconds: 200);
  static const Curve hoverCurve = Cubic(0.16, 1, 0.3, 1);
}

/// Anillo de foco común a todos los controles enfocables (RNF-11).
///
/// Se pinta siempre con `foregroundDecoration`, nunca con `border`: así el
/// control no cambia de tamaño al enfocarlo y no desplaza el layout. El radio
/// del anillo es el del control que lo lleva.
abstract final class AppFocus {
  static const double ringWidth = 2.0;
  static const Color ringColor = AppColors.accentLavender;
}

/// Intensidad de los desenfoques.
abstract final class AppBlur {
  /// Sigma del BackdropFilter de las barras de navegación.
  static const double bar = 16.0;
}
