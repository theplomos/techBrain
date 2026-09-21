import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/domain/course_level.dart';
import '../../../../shared/mock/mock_models.dart';
import '../../../../shared/widgets/course_card.dart';
import '../../../../shared/widgets/level_badge.dart';

/// Columna de nivel de cursos para la vista de escritorio del detalle de ruta.
class LevelColumn extends StatelessWidget {
  const LevelColumn({super.key, required this.level, required this.courses});

  final CourseLevel level;
  final List<MockCourse> courses;

  static String levelDescription(CourseLevel level) => switch (level) {
    CourseLevel.required => 'Fundamentos y prerrequisitos obligatorios.',
    CourseLevel.recommended => 'Especialización y frameworks más demandados.',
    CourseLevel.optional => 'Herramientas complementarias.',
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        LevelBadge(level: level),
        const SizedBox(height: 8.0),
        Text(
          levelDescription(level),
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 16.0),
        if (courses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'Sin cursos en este nivel.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          )
        else
          ...courses.map(
            (MockCourse course) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CourseCard(course: course, showLevel: false),
            ),
          ),
      ],
    );
  }
}
