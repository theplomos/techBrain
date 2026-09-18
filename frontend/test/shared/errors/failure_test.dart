import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/errors/failure.dart';

void main() {
  group('mensajes por defecto', () {
    test('cada subtipo trae su texto en español', () {
      expect(const NetworkFailure().message,
          'No hay conexión. Revisa tu red e inténtalo de nuevo.');
      expect(const ServerFailure().message,
          'El servidor no respondió como esperábamos. Inténtalo más tarde.');
      expect(const UnauthorizedFailure().message,
          'Tu sesión expiró. Inicia sesión de nuevo.');
      expect(const NotFoundFailure().message, 'No encontramos lo que buscas.');
      expect(const LocalDataFailure().message,
          'No pudimos leer los datos de la app.');
      expect(const UnexpectedFailure().message,
          'Algo salió mal. Inténtalo de nuevo.');
    });

    test('se puede sustituir el mensaje por uno más concreto', () {
      const failure = LocalDataFailure(message: 'El nivel "Requerido" no existe.');
      expect(failure.message, 'El nivel "Requerido" no existe.');
    });
  });

  group('contexto adicional', () {
    test('ServerFailure guarda el código de estado', () {
      expect(const ServerFailure(statusCode: 503).statusCode, 503);
      expect(const ServerFailure().statusCode, isNull);
    });

    test('UnexpectedFailure guarda la causa original', () {
      final error = StateError('roto');
      expect(UnexpectedFailure(cause: error).cause, same(error));
    });
  });

  test('es una excepción, así que los repositorios pueden lanzarla', () {
    expect(
      () => throw const NetworkFailure(),
      throwsA(isA<Failure>().having((f) => f.message, 'message',
          contains('conexión'))),
    );
  });

  test('el switch sobre Failure es exhaustivo sin rama por defecto', () {
    String describe(Failure failure) => switch (failure) {
      NetworkFailure() => 'red',
      ServerFailure() => 'servidor',
      UnauthorizedFailure() => 'sesión',
      NotFoundFailure() => 'no encontrado',
      LocalDataFailure() => 'datos locales',
      UnexpectedFailure() => 'inesperado',
    };

    expect(describe(const NotFoundFailure()), 'no encontrado');
  });
}
