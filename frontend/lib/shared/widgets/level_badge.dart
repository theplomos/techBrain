import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';
import '../../config/theme/app_typography.dart';
import '../domain/course_level.dart';

/// Insignia del nivel de un curso dentro de una ruta.
class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key, required this.level});

  final CourseLevel level;

  ({Color background, Color border, Color icon, IconData symbol}) get _style =>
      switch (level) {
        CourseLevel.required => (
          background: AppColors.levelRequiredBg,
          border: AppColors.levelRequiredBorder,
          icon: AppColors.levelRequiredFg,
          symbol: Icons.hexagon,
        ),
        CourseLevel.recommended => (
          background: AppColors.levelRecommendedBg,
          border: AppColors.levelRecommendedBorder,
          icon: AppColors.levelRecommendedFg,
          symbol: Icons.star,
        ),
        CourseLevel.optional => (
          background: AppColors.levelOptionalBg,
          border: AppColors.levelOptionalBorder,
          icon: AppColors.levelOptionalFg,
          symbol: Icons.circle,
        ),
      };

  @override
  Widget build(BuildContext context) {
    final style = _style;

    return Semantics(
      label: 'Nivel: ${level.label}',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            border: Border.all(color: style.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(style.symbol, size: 14.0, color: style.icon),
              const SizedBox(width: 6.0),
              Text(
                level.label.toUpperCase(),
                style: AppTextStyles.chip.copyWith(color: AppColors.textMain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
