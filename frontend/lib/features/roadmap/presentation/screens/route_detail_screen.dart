import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_typography.dart';
import '../../../../shared/errors/failure.dart';
import '../../../../shared/layout/breakpoints.dart';
import '../../../../shared/mock/mock_data.dart';
import '../../../../shared/mock/mock_models.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/pill_button.dart';
import '../../../../shared/widgets/progress_bar.dart';

/// Pantalla de detalle de ruta de aprendizaje a pantalla completa.
class RouteDetailScreen extends StatefulWidget {
  const RouteDetailScreen({super.key, required this.routeId});

  final String routeId;

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  bool _isSaved = false;

  String _formatHours(double hours) {
    if (hours % 1 == 0) {
      return '${hours.toInt()}';
    }
    return '$hours';
  }

  @override
  Widget build(BuildContext context) {
    final MockRoute? route = MockData.routeById(widget.routeId);

    if (route == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: ErrorView(
              error: const NotFoundFailure(),
              onRetry: () => context.go(AppRoutes.home),
              retryLabel: 'Ir a Home',
            ),
          ),
        ),
      );
    }

    final ThemeData theme = Theme.of(context);
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double horizontalPadding = screenWidth >= Breakpoints.desktop
        ? 32.0
        : 16.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24.0,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: Breakpoints.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Cabecera: Botón volver
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textMain,
                    ),
                    tooltip: 'Volver',
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                  ),
                  const SizedBox(height: 12.0),

                  // Etiqueta de ruta
                  const Text(
                    'RUTA DE APRENDIZAJE',
                    style: AppTextStyles.columnHeader,
                  ),
                  const SizedBox(height: 8.0),

                  // Título
                  Text(
                    route.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Descripción
                  Text(
                    route.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Métricas de progreso
                  Text(
                    '${route.courses.length} cursos · ${_formatHours(route.totalHours)} h · ${route.completedCount} completados',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ProgressBar(value: route.progress),
                  const SizedBox(height: 20.0),

                  // Botón Guardar en mis rutas
                  PillButton(
                    label: _isSaved ? 'Guardada' : 'Guardar en mis rutas',
                    variant: PillButtonVariant.primary,
                    onPressed: _isSaved
                        ? null
                        : () => setState(() => _isSaved = true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
