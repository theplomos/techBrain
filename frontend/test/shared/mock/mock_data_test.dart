import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/domain/course_level.dart';
import 'package:techbrain/shared/mock/mock_data.dart';
import 'package:techbrain/shared/mock/mock_models.dart';

void main() {
  group('MockData tests', () {
    test('catálogo contiene exactamente 12 cursos', () {
      expect(MockData.catalog.length, equals(12));
    });

    test('catálogo cubre las 6 categorías del dataset', () {
      final categoriesInCatalog = MockData.catalog
          .map((course) => course.category)
          .toSet();

      expect(categoriesInCatalog, equals(CourseCategory.values.toSet()));
    });

    test('hay exactamente 3 rutas mock con los IDs esperados', () {
      final routeIds = MockData.routes.map((route) => route.id).toList();

      expect(
        routeIds,
        equals(<String>['frontend-react', 'backend-nest', 'movil-flutter']),
      );
    });

    test('cada ruta tiene entre 5 y 8 cursos sin slugs repetidos', () {
      for (final route in MockData.routes) {
        expect(
          route.courses.length,
          greaterThanOrEqualTo(5),
          reason: 'La ruta ${route.id} debe tener al menos 5 cursos',
        );
        expect(
          route.courses.length,
          lessThanOrEqualTo(8),
          reason: 'La ruta ${route.id} debe tener como máximo 8 cursos',
        );

        final slugs = route.courses.map((c) => c.slug).toList();
        final uniqueSlugs = slugs.toSet();
        expect(
          uniqueSlugs.length,
          equals(slugs.length),
          reason: 'La ruta ${route.id} tiene slugs repetidos: $slugs',
        );
      }
    });

    test('cada ruta contiene cursos de los 3 niveles', () {
      for (final route in MockData.routes) {
        final levels = route.courses.map((c) => c.level).toSet();
        expect(
          levels,
          containsAll(<CourseLevel>[
            CourseLevel.required,
            CourseLevel.recommended,
            CourseLevel.optional,
          ]),
          reason: 'La ruta ${route.id} debe tener cursos de los 3 niveles',
        );
      }
    });

    test('cada ruta tiene al menos un curso completado y uno pendiente', () {
      for (final route in MockData.routes) {
        final hasCompleted = route.courses.any((c) => c.isCompleted);
        final hasPending = route.courses.any((c) => !c.isCompleted);

        expect(
          hasCompleted,
          isTrue,
          reason: 'La ruta ${route.id} debe tener al menos un curso completado',
        );
        expect(
          hasPending,
          isTrue,
          reason: 'La ruta ${route.id} debe tener al menos un curso pendiente',
        );
      }
    });

    test('la ruta activa tiene progreso estrictamente entre 0 y 1', () {
      final activeRoute = MockData.routeById(MockData.activeRouteId);

      expect(activeRoute, isNotNull);
      expect(activeRoute!.progress, greaterThan(0.0));
      expect(activeRoute.progress, lessThan(1.0));
    });

    test('routeById devuelve la ruta correcta o null si no existe', () {
      expect(MockData.routeById('frontend-react'), isNotNull);
      expect(
        MockData.routeById('frontend-react')!.id,
        equals('frontend-react'),
      );

      expect(MockData.routeById('no-existe'), isNull);
      expect(MockData.routeById(''), isNull);
    });

    test('getters de MockRoute calculan correctamente completados y horas', () {
      const route = MockRoute(
        id: 'test-route',
        title: 'Ruta de prueba',
        description: 'Descripción de prueba',
        courses: <MockCourse>[
          MockCourse(
            slug: 'curso-1',
            name: 'Curso 1',
            hours: 10.0,
            lessons: 100,
            instructor: 'Profesor A',
            category: CourseCategory.frontend,
            level: CourseLevel.required,
            isCompleted: true,
          ),
          MockCourse(
            slug: 'curso-2',
            name: 'Curso 2',
            hours: 5.5,
            lessons: 50,
            instructor: 'Profesor B',
            category: CourseCategory.backend,
            level: CourseLevel.optional,
            isCompleted: false,
          ),
        ],
      );

      expect(route.completedCount, equals(1));
      expect(route.progress, equals(0.5));
      expect(route.totalHours, equals(15.5));
    });

    test('datos de usuario y cuestionario son consistentes', () {
      expect(MockData.user.name, equals('Alex Rivera'));
      expect(MockData.user.weeklyHours, equals(10));
      expect(MockData.user.streakDays, equals(5));
      expect(MockData.user.discordTag.isNotEmpty, isTrue);

      expect(MockData.quizQuestions.length, equals(3));
      for (final q in MockData.quizQuestions) {
        expect(q.prompt.isNotEmpty, isTrue);
        expect(q.options.length, inInclusiveRange(3, 4));
      }
    });
  });
}
