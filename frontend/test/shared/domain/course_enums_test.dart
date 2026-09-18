import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/domain/course_level.dart';
import 'package:techbrain/shared/errors/failure.dart';

void main() {
  group('CourseLevel', () {
    test('convierte los tres valores del dataset', () {
      expect(CourseLevel.fromDataset('REQUERIDO'), CourseLevel.required);
      expect(CourseLevel.fromDataset('RECOMENDADO'), CourseLevel.recommended);
      expect(
        CourseLevel.fromDataset('OPCIONAL PERO MUY ÚTIL'),
        CourseLevel.optional,
      );
    });

    test('la comparación es exacta: no normaliza mayúsculas', () {
      expect(
        () => CourseLevel.fromDataset('Requerido'),
        throwsA(isA<LocalDataFailure>()),
      );
    });

    test('un valor desconocido lanza LocalDataFailure', () {
      expect(
        () => CourseLevel.fromDataset('IMPRESCINDIBLE'),
        throwsA(isA<LocalDataFailure>()),
      );
    });

    test('el orden de declaración es el orden de fuerza', () {
      expect(CourseLevel.values, <CourseLevel>[
        CourseLevel.required,
        CourseLevel.recommended,
        CourseLevel.optional,
      ]);
      expect(CourseLevel.required.index, lessThan(CourseLevel.optional.index));
    });

    test('la etiqueta visible es más corta que el valor del dataset', () {
      expect(CourseLevel.optional.label, 'Opcional');
      expect(CourseLevel.required.label, 'Requerido');
      expect(CourseLevel.recommended.label, 'Recomendado');
    });
  });

  group('CourseCategory', () {
    test('convierte las seis categorías del dataset', () {
      expect(CourseCategory.fromDataset('BASES'), CourseCategory.bases);
      expect(CourseCategory.fromDataset('FRONTEND'), CourseCategory.frontend);
      expect(CourseCategory.fromDataset('BACKEND'), CourseCategory.backend);
      expect(CourseCategory.fromDataset('MÓVIL'), CourseCategory.mobile);
      expect(CourseCategory.fromDataset('AGENTES IA'), CourseCategory.aiAgents);
      expect(CourseCategory.fromDataset('FULLSTACK'), CourseCategory.fullstack);
    });

    test('no acepta MOVIL sin tilde', () {
      expect(
        () => CourseCategory.fromDataset('MOVIL'),
        throwsA(isA<LocalDataFailure>()),
      );
    });

    test('no existe la categoría WEB, que ningún curso usa', () {
      expect(
        () => CourseCategory.fromDataset('WEB'),
        throwsA(isA<LocalDataFailure>()),
      );
    });
  });
}
