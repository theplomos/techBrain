import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import '../models/course.dart';
import 'app_glass_card.dart';
import 'category_badge.dart';
import 'level_badge.dart';

/// Tarjeta de Curso DevTalles.
/// Single Responsibility: Renderizar la información de un curso en la interfaz.
class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
  });

  final Course course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Fila superior con insignias
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CategoryBadge(category: course.category),
              LevelBadge(level: course.level),
            ],
          ),
          const SizedBox(height: 12.0),

          // Título del curso
          Text(
            course.name,
            style: AppTypography.h3.copyWith(fontSize: 16.0),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8.0),

          // Descripción breve
          Text(
            course.description,
            style: AppTypography.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14.0),

          // Fila inferior: horas, lecciones y estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14.0,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        '${course.hours}h • ${course.lessons} lecc.',
                        style: AppTypography.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (course.isCompleted) ...<Widget>[
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentVividLime.withAlpha(40),
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                      color: AppColors.accentVividLime,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 12.0,
                        color: AppColors.accentVividLime,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        'COMPLETO',
                        style: AppTypography.badgeText.copyWith(
                          color: AppColors.accentVividLime,
                          fontSize: 9.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
