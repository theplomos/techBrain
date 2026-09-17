import 'package:flutter/foundation.dart';

/// Categorías oficiales de cursos en DevTalles
enum CourseCategory {
  bases('BASES'),
  frontend('FRONTEND'),
  backend('BACKEND'),
  movil('MÓVIL'),
  web('WEB'),
  ai('AGENTES IA');

  const CourseCategory(this.label);
  final String label;

  static CourseCategory fromString(String value) {
    return CourseCategory.values.firstWhere(
      (e) => e.label.toUpperCase() == value.toUpperCase(),
      orElse: () => CourseCategory.bases,
    );
  }
}

/// Niveles de prioridad pedagógica de ruta (WCAG 2.2)
enum CourseLevel {
  required('REQUERIDO', '⬢'),
  recommended('RECOMENDADO', '★'),
  optional('OPCIONAL', '●');

  const CourseLevel(this.label, this.symbol);
  final String label;
  final String symbol;

  static CourseLevel fromString(String value) {
    final upper = value.toUpperCase();
    if (upper.contains('REQUERIDO')) return CourseLevel.required;
    if (upper.contains('RECOMENDADO')) return CourseLevel.recommended;
    return CourseLevel.optional;
  }
}

/// Modelo inmutable de Curso (Single Responsibility: Representar datos de curso)
@immutable
class Course {
  const Course({
    required this.slug,
    required this.name,
    required this.description,
    required this.hours,
    required this.lessons,
    required this.instructor,
    required this.category,
    required this.level,
    this.isCompleted = false,
  });

  final String slug;
  final String name;
  final String description;
  final double hours;
  final int lessons;
  final String instructor;
  final CourseCategory category;
  final CourseLevel level;
  final bool isCompleted;

  String get devTallesUrl => 'https://cursos.devtalles.com/courses/$slug';

  Course copyWith({
    String? slug,
    String? name,
    String? description,
    double? hours,
    int? lessons,
    String? instructor,
    CourseCategory? category,
    CourseLevel? level,
    bool? isCompleted,
  }) {
    return Course(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      description: description ?? this.description,
      hours: hours ?? this.hours,
      lessons: lessons ?? this.lessons,
      instructor: instructor ?? this.instructor,
      category: category ?? this.category,
      level: level ?? this.level,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course && runtimeType == other.runtimeType && slug == other.slug;

  @override
  int get hashCode => slug.hashCode;
}
