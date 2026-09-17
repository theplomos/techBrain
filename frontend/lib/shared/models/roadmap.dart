import 'package:flutter/foundation.dart';
import 'course.dart';

/// Modelo inmutable de Ruta de Aprendizaje (Single Responsibility)
@immutable
class Roadmap {
  const Roadmap({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.progressPercentage,
    required this.totalCourses,
    required this.completedCourses,
    required this.estimatedWeeks,
    required this.courses,
    this.isActive = false,
  });

  final String id;
  final String title;
  final String description;
  final CourseCategory category;
  final double progressPercentage;
  final int totalCourses;
  final int completedCourses;
  final int estimatedWeeks;
  final List<Course> courses;
  final bool isActive;

  Roadmap copyWith({
    String? id,
    String? title,
    String? description,
    CourseCategory? category,
    double? progressPercentage,
    int? totalCourses,
    int? completedCourses,
    int? estimatedWeeks,
    List<Course>? courses,
    bool? isActive,
  }) {
    return Roadmap(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      totalCourses: totalCourses ?? this.totalCourses,
      completedCourses: completedCourses ?? this.completedCourses,
      estimatedWeeks: estimatedWeeks ?? this.estimatedWeeks,
      courses: courses ?? this.courses,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Roadmap && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
