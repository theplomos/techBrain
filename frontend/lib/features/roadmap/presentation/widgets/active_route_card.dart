import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_typography.dart';
import '../../../../shared/mock/mock_models.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/pill_button.dart';
import '../../../../shared/widgets/progress_bar.dart';

/// Tarjeta destacada de la ruta activa del usuario en Home.
class ActiveRouteCard extends StatelessWidget {
  const ActiveRouteCard({super.key, required this.route, this.onContinue});

  final MockRoute route;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('RUTA ACTIVA', style: AppTextStyles.columnHeader),
          const SizedBox(height: 8.0),
          Text(
            route.title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.textMain,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            route.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16.0),
          ProgressBar(value: route.progress),
          const SizedBox(height: 20.0),
          PillButton(
            label: 'Continuar ruta',
            variant: PillButtonVariant.primary,
            onPressed:
                onContinue ??
                () {
                  context.push(AppRoutes.route(route.id));
                },
          ),
        ],
      ),
    );
  }
}
