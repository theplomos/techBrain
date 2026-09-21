import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/domain/course_level.dart';
import 'package:techbrain/shared/mock/mock_data.dart';
import 'package:techbrain/shared/mock/mock_models.dart';

MockCourse _course(String slug, double hours, {bool completed = true}) =>
    MockCourse(
      slug: slug,
      name: slug,
      hours: hours,
      lessons: 1,
      instructor: 'Fernando Herrera',
      category: CourseCategory.bases,
      level: CourseLevel.required,
      isCompleted: completed,
    );

MockRoute _route(String id, List<MockCourse> courses) =>
    MockRoute(id: id, title: id, description: id, courses: courses);

void main() {
  group('uniqueCompletedCourses', () {
    test('cuenta una sola vez un curso completado en varias rutas', () {
      final List<MockCourse> result = uniqueCompletedCourses(<MockRoute>[
        _route('a', <MockCourse>[_course('git', 11.5), _course('ts', 8.5)]),
        _route('b', <MockCourse>[_course('git', 11.5)]),
      ]);

      expect(result.map((c) => c.slug), <String>['git', 'ts']);
    });

    test('ignora los cursos no completados', () {
      final List<MockCourse> result = uniqueCompletedCourses(<MockRoute>[
        _route('a', <MockCourse>[
          _course('git', 11.5),
          _course('nest', 24.5, completed: false),
        ]),
      ]);

      expect(result.map((c) => c.slug), <String>['git']);
    });

    test('distingue slugs que solo difieren en mayúsculas', () {
      final List<MockCourse> result = uniqueCompletedCourses(<MockRoute>[
        _route('a', <MockCourse>[
          _course('flutter-intermedio', 1),
          _course('flutter-Intermedio', 1),
        ]),
      ]);

      expect(result, hasLength(2));
    });

    test('devuelve una lista vacía si no hay rutas', () {
      expect(uniqueCompletedCourses(const <MockRoute>[]), isEmpty);
    });

    test('con MockData hay 4 cursos completados distintos que suman 76 h', () {
      final List<MockCourse> result = uniqueCompletedCourses(MockData.routes);

      expect(result, hasLength(4));
      expect(
        result.fold<double>(0.0, (double acc, MockCourse c) => acc + c.hours),
        76.0,
      );
    });
  });
}
