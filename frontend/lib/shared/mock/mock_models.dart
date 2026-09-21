import '../domain/course_category.dart';
import '../domain/course_level.dart';

/// Modelo de curso para datos mock de presentación (temporal).
class MockCourse {
  const MockCourse({
    required this.slug,
    required this.name,
    required this.hours,
    required this.lessons,
    required this.instructor,
    required this.category,
    required this.level,
    this.isCompleted = false,
  });

  /// Slug real extraído de `cursos_devtalles.json`.
  final String slug;
  final String name;
  final double hours;
  final int lessons;
  final String instructor;
  final CourseCategory category;

  /// Nivel asignado dentro de la ruta mock.
  final CourseLevel level;
  final bool isCompleted;
}

/// Modelo de ruta de aprendizaje para datos mock de presentación (temporal).
class MockRoute {
  const MockRoute({
    required this.id,
    required this.title,
    required this.description,
    required this.courses,
  });

  /// Identificador kebab-case utilizado en rutas (p. ej. `/routes/:id`).
  final String id;
  final String title;
  final String description;
  final List<MockCourse> courses;

  /// Cantidad de cursos completados en la ruta.
  int get completedCount => courses.where((c) => c.isCompleted).length;

  /// Progreso de la ruta entre 0.0 y 1.0 (0.0 si la ruta está vacía).
  double get progress =>
      courses.isEmpty ? 0.0 : completedCount / courses.length;

  /// Total de horas lectivas sumando todos los cursos de la ruta.
  double get totalHours => courses.fold<double>(0.0, (acc, c) => acc + c.hours);
}

/// Modelo de usuario para datos mock de presentación (temporal).
class MockUser {
  const MockUser({
    required this.name,
    required this.discordTag,
    required this.weeklyHours,
    required this.streakDays,
  });

  final String name;
  final String discordTag;

  /// Horas de dedicación semanal (entre 1 y 40).
  final int weeklyHours;
  final int streakDays;
}

/// Modelo de pregunta de cuestionario para datos mock de presentación (temporal).
class MockQuizQuestion {
  const MockQuizQuestion({required this.prompt, required this.options});

  final String prompt;
  final List<String> options;
}
