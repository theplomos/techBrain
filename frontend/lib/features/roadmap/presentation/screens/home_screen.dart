import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_typography.dart';
import '../../../../shared/domain/course_category.dart';
import '../../../../shared/domain/course_level.dart';
import '../../../../shared/layout/breakpoints.dart';
import '../../../../shared/mock/mock_data.dart';
import '../../../../shared/mock/mock_models.dart';
import '../../../../shared/widgets/category_badge.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/level_badge.dart';
import '../../../../shared/widgets/metric_card.dart';
import '../../../../shared/widgets/pill_button.dart';
import '../../../../shared/widgets/section_header.dart';
import '../widgets/active_route_card.dart';
import '../widgets/saved_route_tile.dart';

/// Pantalla de inicio con ruta activa, métricas, rutas guardadas y muestrario de componentes.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final MockUser user = MockData.user;
    final MockRoute? activeRoute = MockData.routeById(MockData.activeRouteId);

    final List<MockCourse> completed = uniqueCompletedCourses(MockData.routes);
    final int completedCourses = completed.length;
    final double totalHours = completed.fold<double>(
      0.0,
      (double acc, MockCourse c) => acc + c.hours,
    );
    final int savedRoutesCount = MockData.routes.length;

    return ListView(
      // El hueco de las barras lo deja el Scaffold en MediaQuery.padding:
      // arriba el alto de AppTopNavBar y abajo el de la barra flotante con su
      // área segura. Sumarlo evita escribir esos números a mano.
      padding:
          MediaQuery.paddingOf(context) +
          const EdgeInsets.symmetric(vertical: 24.0),
      children: <Widget>[
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 1. Saludo y racha
                Text(
                  'Hola, ${user.name}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '🔥 ${user.streakDays} días de racha',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 24.0),

                // 2. Ruta activa
                if (activeRoute != null) ...<Widget>[
                  ActiveRouteCard(route: activeRoute),
                  const SizedBox(height: 32.0),
                ],

                // 3. Mis métricas
                const SectionHeader('Mis métricas'),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool isRow = constraints.maxWidth >= 600.0;
                    final Widget cardHours = MetricCard(
                      value: '${totalHours.round()}',
                      label: 'Horas totales',
                      icon: Icons.schedule,
                    );
                    final Widget cardCourses = MetricCard(
                      value: '$completedCourses',
                      label: 'Cursos completados',
                      icon: Icons.check_circle_outline,
                    );
                    final Widget cardRoutes = MetricCard(
                      value: '$savedRoutesCount',
                      label: 'Rutas guardadas',
                      icon: Icons.bookmark_border,
                    );

                    if (isRow) {
                      return Row(
                        children: <Widget>[
                          Expanded(child: cardHours),
                          const SizedBox(width: 16.0),
                          Expanded(child: cardCourses),
                          const SizedBox(width: 16.0),
                          Expanded(child: cardRoutes),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        cardHours,
                        const SizedBox(height: 12.0),
                        cardCourses,
                        const SizedBox(height: 12.0),
                        cardRoutes,
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32.0),

                // 4. Mis rutas guardadas
                const SectionHeader('Mis rutas guardadas'),
                for (final MockRoute route in MockData.routes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: SavedRouteTile(route: route),
                  ),
                const SizedBox(height: 20.0),

                // 5. Muestrario de componentes (temporal)
                const _ShowcaseHeader(),
                const SizedBox(height: 16.0),
                const _ShowcaseSection(
                  title: 'Botones',
                  child: _ButtonShowcase(),
                ),
                const SizedBox(height: 16.0),
                _ShowcaseSection(
                  title: 'Niveles',
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: <Widget>[
                      for (final CourseLevel level in CourseLevel.values)
                        LevelBadge(level: level),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                _ShowcaseSection(
                  title: 'Categorías',
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: <Widget>[
                      for (final CourseCategory category
                          in CourseCategory.values)
                        CategoryBadge(category: category),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                _ShowcaseSection(
                  title: 'Tarjeta interactiva',
                  child: GlassContainer(
                    padding: const EdgeInsets.all(20.0),
                    semanticLabel: 'Tarjeta de ejemplo',
                    onTap: () {},
                    child: Text(
                      'Pasa el cursor o enfócala con Tab.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ShowcaseHeader extends StatelessWidget {
  const _ShowcaseHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Muestrario de componentes (temporal)',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class _ShowcaseSection extends StatelessWidget {
  const _ShowcaseSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title.toUpperCase(), style: AppTextStyles.columnHeader),
        const SizedBox(height: 8.0),
        child,
      ],
    );
  }
}

class _ButtonShowcase extends StatelessWidget {
  const _ButtonShowcase();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: <Widget>[
        PillButton(label: 'Primario', onPressed: _noop),
        PillButton(
          label: 'Secundario',
          variant: PillButtonVariant.secondary,
          onPressed: _noop,
        ),
        PillButton(
          label: 'Generar ruta',
          variant: PillButtonVariant.vivid,
          onPressed: _noop,
        ),
        PillButton(label: 'Deshabilitado', onPressed: null),
      ],
    );
  }
}

/// Callback vacío del muestrario: los botones no hacen nada todavía.
void _noop() {}
