/// Origen de los datos de autenticación.
enum AuthSource {
  /// Se habla con el backend real.
  api,

  /// Se usan datos locales, sin red.
  mock;

  /// Convierte el valor textual de `AUTH_SOURCE`.
  ///
  /// Devuelve null si no coincide exactamente con `api` ni con `mock`.
  static AuthSource? tryParse(String value) => switch (value) {
    'api' => AuthSource.api,
    'mock' => AuthSource.mock,
    _ => null,
  };
}

/// Configuración que llega por `--dart-define` o `--dart-define-from-file`.
///
/// Los valores se resuelven en tiempo de compilación, así que no hay ningún
/// archivo `.env` que leer en tiempo de ejecución.
abstract final class Env {
  /// Raíz de la API del backend.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.techbrain.arcentales.dev/api',
  );

  static const String _rawAuthSource = String.fromEnvironment(
    'AUTH_SOURCE',
    defaultValue: 'api',
  );

  /// Origen de autenticación configurado.
  ///
  /// Un valor desconocido cae en [AuthSource.api] y dispara un assert en
  /// debug: fallar al arrancar dejaría la demo en blanco.
  static AuthSource get authSource {
    final AuthSource? parsed = AuthSource.tryParse(_rawAuthSource);
    assert(
      parsed != null,
      'AUTH_SOURCE="$_rawAuthSource" no es válido. Usa "api" o "mock".',
    );
    return parsed ?? AuthSource.api;
  }
}
