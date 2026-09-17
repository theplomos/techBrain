import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import '../models/course.dart';

/// Insignia de prioridad de ruta con símbolo geométrico accesible (WCAG 2.2).
/// Single Responsibility: Renderizar la prioridad del curso (`⬢`, `★`, `●`).
class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key, required this.level});

  final CourseLevel level;

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            level.symbol,
            style: TextStyle(
              color: textColor,
              fontSize: 11.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4.0),
          Text(
            level.label,
            style: AppTypography.badgeText.copyWith(
              color: textColor,
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, Color) _resolveColors() {
    switch (level) {
      case CourseLevel.required:
        return (
          AppColors.levelRequiredBg,
          AppColors.levelRequired.withAlpha(100),
          AppColors.levelRequired,
        );
      case CourseLevel.recommended:
        return (
          AppColors.levelRecommendedBg,
          AppColors.levelRecommended.withAlpha(100),
          AppColors.levelRecommended,
        );
      case CourseLevel.optional:
        return (
          AppColors.levelOptionalBg,
          AppColors.levelOptional.withAlpha(100),
          AppColors.levelOptional,
        );
    }
  }
}
