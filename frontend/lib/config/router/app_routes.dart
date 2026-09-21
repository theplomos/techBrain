/// Paths de la navegación.
///
/// Van en inglés para que coincidan con los nombres de carpeta de
/// `lib/features/`.
abstract final class AppRoutes {
  static const String home = '/home';
  static const String explore = '/explore';
  static const String quiz = '/quiz';
  static const String settings = '/settings';

  /// Ruta de detalle a pantalla completa fuera del shell.
  static const String routeDetail = '/routes/:id';

  /// Genera la ruta hacia el detalle de [id].
  static String route(String id) => '/routes/$id';
}
