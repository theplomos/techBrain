import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';
import '../../config/theme/app_typography.dart';
import '../domain/course_category.dart';

/// Insignia de la categoría de un curso dentro de una ruta.
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.category});

  final CourseCategory category;

  ({Color background, Color border}) get _style => switch (category) {
    CourseCategory.bases => (
      background: AppColors.catBasesBg,
      border: AppColors.catBasesBorder,
    ),
    CourseCategory.frontend => (
      background: AppColors.catFrontendBg,
      border: AppColors.catFrontendBorder,
    ),
    CourseCategory.backend => (
      background: AppColors.catBackendBg,
      border: AppColors.catBackendBorder,
    ),
    CourseCategory.mobile => (
      background: AppColors.catMobileBg,
      border: AppColors.catMobileBorder,
    ),
    CourseCategory.aiAgents => (
      background: AppColors.catAiAgentsBg,
      border: AppColors.catAiAgentsBorder,
    ),
    CourseCategory.fullstack => (
      background: AppColors.catFullstackBg,
      border: AppColors.catFullstackBorder,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final style = _style;

    return Semantics(
      label: 'Categoría: ${category.datasetValue}',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            border: Border.all(color: style.border),
          ),
          child: Text(
            category.datasetValue,
            style: AppTextStyles.chip.copyWith(color: AppColors.textMain),
          ),
        ),
      ),
    );
  }
}
