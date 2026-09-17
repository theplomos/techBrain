import 'package:flutter/foundation.dart';

/// Modelo inmutable de Perfil de Usuario (Single Responsibility)
@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.discordTag,
    required this.avatarUrl,
    required this.streakDays,
    required this.weeklyHours,
    required this.completedCoursesCount,
    required this.totalHoursLearned,
    required this.quizAccuracyPercentage,
  });

  final String id;
  final String name;
  final String discordTag;
  final String avatarUrl;
  final int streakDays;
  final int weeklyHours;
  final int completedCoursesCount;
  final int totalHoursLearned;
  final int quizAccuracyPercentage;

  UserProfile copyWith({
    String? id,
    String? name,
    String? discordTag,
    String? avatarUrl,
    int? streakDays,
    int? weeklyHours,
    int? completedCoursesCount,
    int? totalHoursLearned,
    int? quizAccuracyPercentage,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      discordTag: discordTag ?? this.discordTag,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      streakDays: streakDays ?? this.streakDays,
      weeklyHours: weeklyHours ?? this.weeklyHours,
      completedCoursesCount: completedCoursesCount ?? this.completedCoursesCount,
      totalHoursLearned: totalHoursLearned ?? this.totalHoursLearned,
      quizAccuracyPercentage:
          quizAccuracyPercentage ?? this.quizAccuracyPercentage,
    );
  }
}
