/// Anchos que gobiernan el layout.
abstract final class Breakpoints {
  /// A partir de aquí se usa la barra superior en lugar de la inferior.
  static const double desktop = 1024.0;

  /// Ancho mínimo que la app soporta sin desbordes.
  static const double minSupported = 360.0;

  /// Ancho máximo del contenido en escritorio.
  static const double maxContentWidth = 1200.0;
}
