import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../mock/mock_models.dart';
import 'category_badge.dart';
import 'glass_container.dart';
import 'level_badge.dart';

/// Tarjeta de curso con categoría, nivel opcional, título, duración y lecciones.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course, this.showLevel = true});

  final MockCourse course;
  final bool showLevel;

  String get _formattedHours {
    if (course.hours % 1 == 0) {
      return '${course.hours.toInt()} h';
    }
    return '${course.hours} h';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              CategoryBadge(category: course.category),
              if (showLevel) ...<Widget>[
                const SizedBox(width: 8.0),
                LevelBadge(level: course.level),
              ],
              const Spacer(),
              if (course.isCompleted)
                Semantics(
                  label: 'Completado',
                  child: const Icon(
                    Icons.check_circle,
                    size: 20.0,
                    color: AppColors.accentVivid,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            course.name,
            style: theme.textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12.0),
          Row(
            children: <Widget>[
              const Icon(
                Icons.schedule,
                size: 16.0,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4.0),
              Text(
                _formattedHours,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 16.0),
              const Icon(
                Icons.play_lesson_outlined,
                size: 16.0,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4.0),
              Text(
                '${course.lessons} lecciones',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
