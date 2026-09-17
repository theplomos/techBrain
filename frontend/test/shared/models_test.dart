import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/data/mock_data.dart';
import 'package:frontend/shared/models/course.dart';

void main() {
  group('Domain Models & Data Tests', () {
    test('Course model instantiation and helpers work correctly', () {
      const course = Course(
        slug: 'react-de-cero-a-experto',
        name: 'React: De cero a experto',
        description: 'Aprende React',
        hours: 40.5,
        lessons: 320,
        instructor: 'Fernando Herrera',
        category: CourseCategory.frontend,
        level: CourseLevel.required,
      );

      expect(course.devTallesUrl,
          equals('https://cursos.devtalles.com/courses/react-de-cero-a-experto'));
      expect(course.isCompleted, isFalse);

      final completedCourse = course.copyWith(isCompleted: true);
      expect(completedCourse.isCompleted, isTrue);
      expect(completedCourse == course, isTrue);
    });

    test('CourseLevel and CourseCategory parsing works reliably', () {
      expect(CourseLevel.fromString('REQUERIDO'), equals(CourseLevel.required));
      expect(CourseLevel.fromString('RECOMENDADO'),
          equals(CourseLevel.recommended));
      expect(CourseLevel.fromString('OPCIONAL PERO MUY ÚTIL'),
          equals(CourseLevel.optional));

      expect(CourseCategory.fromString('FRONTEND'),
          equals(CourseCategory.frontend));
      expect(
          CourseCategory.fromString('BACKEND'), equals(CourseCategory.backend));
      expect(CourseCategory.fromString('MÓVIL'), equals(CourseCategory.movil));
      expect(CourseCategory.fromString('AGENTES IA'),
          equals(CourseCategory.ai));
      expect(CourseCategory.fromString('UNKNOWN'), equals(CourseCategory.bases));
    });

    test('Roadmap model has correct active state and courses', () {
      final activeRoadmap = MockData.initialRoadmaps.firstWhere((r) => r.isActive);
      expect(activeRoadmap.title, contains('React'));
      expect(activeRoadmap.progressPercentage, equals(0.68));
      expect(activeRoadmap.totalCourses, equals(18));
      expect(activeRoadmap.completedCourses, equals(12));
    });

    test('UserProfile reflects student stats', () {
      const user = MockData.demoUser;
      expect(user.name, equals('Alex Rivera'));
      expect(user.streakDays, equals(5));
      expect(user.weeklyHours, equals(10));
    });
  });
}
