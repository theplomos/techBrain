import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/env.dart';

void main() {
  group('AuthSource.tryParse', () {
    test('reconoce los dos valores válidos', () {
      expect(AuthSource.tryParse('api'), AuthSource.api);
      expect(AuthSource.tryParse('mock'), AuthSource.mock);
    });

    test('devuelve null con cualquier otro valor', () {
      expect(AuthSource.tryParse('API'), isNull);
      expect(AuthSource.tryParse('firebase'), isNull);
      expect(AuthSource.tryParse(''), isNull);
    });
  });

  group('Env', () {
    test('sin defines usa la URL de la API del equipo', () {
      expect(Env.apiBaseUrl, 'https://api.techbrain.arcentales.dev/api');
    });

    test('sin defines el origen de autenticación es la API', () {
      expect(Env.authSource, AuthSource.api);
    });
  });
}
