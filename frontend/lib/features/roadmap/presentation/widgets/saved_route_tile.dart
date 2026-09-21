import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/mock/mock_models.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/progress_bar.dart';

/// Elemento interactivo de la lista de rutas guardadas en Home.
class SavedRouteTile extends StatelessWidget {
  const SavedRouteTile({super.key, required this.route, this.onTap});

  final MockRoute route;
  final VoidCallback? onTap;

  String _formatHours(double hours) {
    if (hours % 1 == 0) {
      return '${hours.toInt()}';
    }
    return '$hours';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.all(20.0),
      semanticLabel: 'Abrir ruta ${route.title}',
      onTap:
          onTap ??
          () {
            context.push(AppRoutes.route(route.id));
          },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            route.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textMain,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '${route.courses.length} cursos · ${_formatHours(route.totalHours)} h',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12.0),
          ProgressBar(value: route.progress),
        ],
      ),
    );
  }
}
