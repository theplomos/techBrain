import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import '../models/course.dart';

/// Chip distintivo de categoría tecnológica DevTalles.
/// Single Responsibility: Renderizar la etiqueta de especialidad (Bases, Frontend, Backend, etc.)
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.category});

  final CourseCategory category;

  @override
  Widget build(BuildContext context) {
    final (bgColor, borderColor, textColor) = _resolveColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Text(
        category.label,
        style: AppTypography.badgeText.copyWith(
          color: textColor,
          fontSize: 10.0,
        ),
      ),
    );
  }

  (Color, Color, Color) _resolveColors() {
    switch (category) {
      case CourseCategory.bases:
        return (
          AppColors.catBasesBg,
          AppColors.catBasesBorder,
          AppColors.catBasesBorder
        );
      case CourseCategory.frontend:
        return (
          AppColors.catFrontendBg,
          AppColors.catFrontendBorder,
          AppColors.textMain
        );
      case CourseCategory.backend:
        return (
          AppColors.catBackendBg,
          AppColors.catBackendBorder,
          AppColors.textMain
        );
      case CourseCategory.movil:
        return (
          AppColors.catMovilBg,
          AppColors.catMovilBorder,
          AppColors.accentVividLime
        );
      case CourseCategory.web:
        return (
          AppColors.catWebBg,
          AppColors.catWebBorder,
          AppColors.catWebBorder
        );
      case CourseCategory.ai:
        return (
          AppColors.catAiBg,
          AppColors.catAiBorder,
          AppColors.textMain
        );
    }
  }
}
