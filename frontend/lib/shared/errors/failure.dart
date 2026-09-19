/// Errores que la app sabe explicar al usuario.
///
/// Los repositorios lanzan un [Failure] y Riverpod lo expone como
/// `AsyncValue.error`. No hay un `Result<T>` propio porque `AsyncValue` ya
/// distingue carga, dato y error.
///
/// La clase es sellada para que los `switch` sean exhaustivos. Los subtipos
/// nuevos se añaden en este mismo archivo: la Etapa 2 pondrá aquí los de
/// autenticación.
///
/// Todos los constructores usan parámetros con nombre para poder combinar el
/// `message` por defecto con el contexto extra de cada subtipo.
sealed class Failure implements Exception {
  const Failure({required this.message});

  /// Texto listo para mostrar al usuario, en español.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Sin conexión o tiempo de espera agotado.
final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No hay conexión. Revisa tu red e inténtalo de nuevo.',
  });
}

/// Respuesta 5xx o cuerpo que no se puede interpretar.
final class ServerFailure extends Failure {
  const ServerFailure({
    super.message =
        'El servidor no respondió como esperábamos. Inténtalo más tarde.',
    this.statusCode,
  });

  final int? statusCode;
}

/// 401 que el refresco de sesión no recupera.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Tu sesión expiró. Inicia sesión de nuevo.',
  });
}

/// Recurso o ruta que no existe.
final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'No encontramos lo que buscas.'});
}

/// Error al leer un asset o los datos guardados en el dispositivo.
final class LocalDataFailure extends Failure {
  const LocalDataFailure({
    super.message = 'No pudimos leer los datos de la app.',
  });
}

/// Cualquier otra cosa. Guarda la causa original para los logs.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Algo salió mal. Inténtalo de nuevo.',
    this.cause,
  });

  final Object? cause;
}
