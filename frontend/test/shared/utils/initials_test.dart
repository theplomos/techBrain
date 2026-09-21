import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/utils/initials.dart';

void main() {
  group('initialsOf', () {
    test('nombre y apellido', () {
      expect(initialsOf('Alex Rivera'), 'AR');
    });

    test('usa la primera y la última palabra', () {
      expect(initialsOf('ana maría de la cruz'), 'AC');
    });

    test('una sola palabra', () {
      expect(initialsOf('fernando'), 'F');
    });

    test('ignora espacios al principio, al final y repetidos', () {
      expect(initialsOf('  Alex   Rivera  '), 'AR');
    });

    test('nombre vacío devuelve cadena vacía', () {
      expect(initialsOf(''), '');
    });

    test('nombre de solo espacios devuelve cadena vacía', () {
      expect(initialsOf('   '), '');
    });

    test('no parte un emoji por la mitad', () {
      expect(initialsOf('🚀 Dev'), '🚀D');
    });
  });
}
