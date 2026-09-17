import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/roadmap.dart';
import '../../../shared/widgets/app_glass_card.dart';
import '../../../shared/widgets/app_pill_button.dart';
import '../../../shared/widgets/category_badge.dart';
import '../../../shared/widgets/devtalles_logo.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/progress_bar_widget.dart';

/// Pantalla Principal (Dashboard del Estudiante).
/// Single Responsibility: Presentar el resumen de aprendizaje, ruta activa y métricas del usuario.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const user = MockData.demoUser;
    final activeRoadmap = MockData.initialRoadmaps.firstWhere(
      (r) => r.isActive,
      orElse: () => MockData.initialRoadmaps.first,
    );
    final savedRoadmaps =
        MockData.initialRoadmaps.where((r) => !r.isActive).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Barra superior móvil con logo y racha
              _buildHeader(user.name, user.streakDays),
              const SizedBox(height: 24.0),

              // Hero Card: Mi Ruta Activa
              _buildActiveRoadmapCard(context, activeRoadmap),
              const SizedBox(height: 28.0),

              // Sección: Mis Métricas
              const Text('MIS MÉTRICAS', style: AppTypography.columnHeader),
              const SizedBox(height: 12.0),
              _buildMetricsGrid(user),
              const SizedBox(height: 28.0),

              // Sección: Mis Rutas Guardadas
              const Text(
                'MIS RUTAS GUARDADAS',
                style: AppTypography.columnHeader,
              ),
              const SizedBox(height: 12.0),
              _buildSavedRoadmapsList(savedRoadmaps),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name, int streak) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const DevTallesLogo(fontSize: 18.0),
              const SizedBox(height: 6.0),
              Text(
                '¡Hola, $name! 🚀',
                style: AppTypography.h2.copyWith(fontSize: 20.0),
                overflow: TextOverflow.ellipsis,
              ),
              const Text(
                'Continúa con tu ruta de aprendizaje',
                style: AppTypography.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(color: AppColors.accentLavender.withAlpha(60)),
          ),
          child: Row(
            children: <Widget>[
              const Text('🔥', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4.0),
              Text(
                '$streak Días',
                style: const TextStyle(
                  color: AppColors.accentVividLime,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveRoadmapCard(BuildContext context, Roadmap roadmap) {
    return AppGlassCard(
      padding: const EdgeInsets.all(20.0),
      borderColor: AppColors.accentLavender.withAlpha(80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CategoryBadge(category: roadmap.category),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.accentElectric.withAlpha(40),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: const Text(
                  'RUTA ACTIVA',
                  style: TextStyle(
                    color: AppColors.accentLavender,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),
          Text(
            roadmap.title,
            style: AppTypography.h1.copyWith(fontSize: 22.0),
          ),
          const SizedBox(height: 6.0),
          Text(
            roadmap.description,
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 18.0),
          ProgressBarWidget(progress: roadmap.progressPercentage),
          const SizedBox(height: 8.0),
          Text(
            '${roadmap.completedCourses} de ${roadmap.totalCourses} cursos completados • Quedan aprox. ${roadmap.estimatedWeeks} semanas',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 20.0),
          AppPillButton(
            label: 'Ver y Continuar Ruta ▶',
            variant: AppPillButtonVariant.vivid,
            isFullWidth: true,
            onPressed: () {
              context.push('/roadmap-detail', extra: roadmap);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(dynamic user) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        return GridView.count(
          crossAxisCount: isNarrow ? 2 : 3,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: isNarrow ? 1.6 : 2.0,
          children: <Widget>[
            MetricCard(
              icon: Icons.timer_outlined,
              value: '${user.totalHoursLearned}h',
              label: 'Horas Totales',
              highlightColor: AppColors.accentVividLime,
            ),
            MetricCard(
              icon: Icons.school_outlined,
              value: '${user.completedCoursesCount}',
              label: 'Cursos Listos',
              highlightColor: AppColors.accentLavender,
            ),
            MetricCard(
              icon: Icons.auto_awesome_outlined,
              value: '${user.quizAccuracyPercentage}%',
              label: 'Afinidad Quizzes',
              highlightColor: AppColors.catFrontendBorder,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSavedRoadmapsList(List<Roadmap> roadmaps) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: roadmaps.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12.0),
      itemBuilder: (context, index) {
        final r = roadmaps[index];
        return AppGlassCard(
          padding: const EdgeInsets.all(16.0),
          onTap: () {
            context.push('/roadmap-detail', extra: r);
          },
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CategoryBadge(category: r.category),
                        const SizedBox(width: 8.0),
                        Text(
                          '${r.completedCourses}/${r.totalCourses} cursos',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      r.title,
                      style: AppTypography.h3.copyWith(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.accentLavender,
              ),
            ],
          ),
        );
      },
    );
  }
}
