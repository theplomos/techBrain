import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_tokens.dart';
import '../../../../config/theme/app_typography.dart';
import '../../../../shared/domain/course_level.dart';
import '../../../../shared/errors/failure.dart';
import '../../../../shared/layout/breakpoints.dart';
import '../../../../shared/mock/mock_data.dart';
import '../../../../shared/mock/mock_models.dart';
import '../../../../shared/widgets/course_card.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/pill_button.dart';
import '../../../../shared/widgets/progress_bar.dart';
import '../widgets/level_column.dart';

/// Pantalla de detalle de ruta de aprendizaje a pantalla completa.
class RouteDetailScreen extends StatefulWidget {
  const RouteDetailScreen({super.key, required this.routeId});

  final String routeId;

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  bool _isSaved = false;
  CourseLevel? _selectedLevel; // null representa 'Todos'

  String _formatHours(double hours) {
    if (hours % 1 == 0) {
      return '${hours.toInt()}';
    }
    return '$hours';
  }

  List<MockCourse> _getFilteredCourses(List<MockCourse> allCourses) {
    if (_selectedLevel != null) {
      return allCourses.where((c) => c.level == _selectedLevel).toList();
    }
    // Agrupado en orden de nivel: Requerido -> Recomendado -> Opcional
    final List<MockCourse> sorted = <MockCourse>[];
    for (final CourseLevel level in CourseLevel.values) {
      sorted.addAll(allCourses.where((c) => c.level == level));
    }
    return sorted;
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
    final bool isDesktop = screenWidth >= Breakpoints.desktop;
    final double horizontalPadding = isDesktop ? 32.0 : 16.0;

    final List<MockCourse> filteredCourses = _getFilteredCourses(route.courses);

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
                  const SizedBox(height: 32.0),

                  // Contenido adaptable por breakpoint
                  if (isDesktop) ...<Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (
                          int i = 0;
                          i < CourseLevel.values.length;
                          i++
                        ) ...<Widget>[
                          if (i > 0) const SizedBox(width: 16.0),
                          Expanded(
                            child: LevelColumn(
                              level: CourseLevel.values[i],
                              courses: route.courses
                                  .where(
                                    (c) => c.level == CourseLevel.values[i],
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ] else ...<Widget>[
                    // Vista móvil: chips de nivel y lista vertical
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          ChoiceChip(
                            label: Text('Todos (${route.courses.length})'),
                            selected: _selectedLevel == null,
                            onSelected: (_) {
                              setState(() => _selectedLevel = null);
                            },
                            selectedColor: AppColors.accentElectric,
                            backgroundColor: AppColors.cardBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadii.pill,
                              ),
                            ),
                            side: BorderSide(
                              color: _selectedLevel == null
                                  ? AppColors.accentLavender
                                  : AppColors.cardBorder,
                            ),
                            labelStyle: AppTextStyles.chip.copyWith(
                              color: _selectedLevel == null
                                  ? AppColors.textMain
                                  : AppColors.textMuted,
                            ),
                            showCheckmark: false,
                          ),
                          const SizedBox(width: 8.0),
                          for (final CourseLevel level
                              in CourseLevel.values) ...<Widget>[
                            ChoiceChip(
                              label: Text(
                                '${level.label} (${route.courses.where((c) => c.level == level).length})',
                              ),
                              selected: _selectedLevel == level,
                              onSelected: (_) {
                                setState(() => _selectedLevel = level);
                              },
                              selectedColor: AppColors.accentElectric,
                              backgroundColor: AppColors.cardBg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadii.pill,
                                ),
                              ),
                              side: BorderSide(
                                color: _selectedLevel == level
                                    ? AppColors.accentLavender
                                    : AppColors.cardBorder,
                              ),
                              labelStyle: AppTextStyles.chip.copyWith(
                                color: _selectedLevel == level
                                    ? AppColors.textMain
                                    : AppColors.textMuted,
                              ),
                              showCheckmark: false,
                            ),
                            const SizedBox(width: 8.0),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (filteredCourses.isEmpty)
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
                      for (final MockCourse course in filteredCourses)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: CourseCard(course: course, showLevel: true),
                        ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
