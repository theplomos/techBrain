import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/course.dart';
import '../../../shared/models/roadmap.dart';
import '../../../shared/widgets/app_glass_card.dart';
import '../../../shared/widgets/app_pill_button.dart';
import '../../../shared/widgets/category_badge.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/devtalles_logo.dart';
import '../../../shared/widgets/level_badge.dart';
import '../../../shared/widgets/progress_bar_widget.dart';

/// Visualizador de Ruta de Aprendizaje (3 Columnas de Prioridad: Requerido, Recomendado, Opcional).
/// Single Responsibility: Renderizar el árbol pedagógico y el progreso de la ruta generada.
class RoadmapDetailView extends StatefulWidget {
  const RoadmapDetailView({
    super.key,
    this.roadmap,
  });

  final Roadmap? roadmap;

  @override
  State<RoadmapDetailView> createState() => _RoadmapDetailViewState();
}

class _RoadmapDetailViewState extends State<RoadmapDetailView> {
  late Roadmap _currentRoadmap;
  late List<Course> _courses;
  int _selectedMobileTabIndex = 0; // 0: Todos, 1: Requerido, 2: Recomendado, 3: Opcional
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _currentRoadmap = widget.roadmap ?? MockData.generatedDemoRoadmap;
    _courses = List<Course>.from(_currentRoadmap.courses);
  }

  void _toggleCourseCompletion(int index) {
    setState(() {
      final course = _courses[index];
      _courses[index] = course.copyWith(isCompleted: !course.isCompleted);
      final completedCount = _courses.where((c) => c.isCompleted).length;
      final newPercentage =
          _courses.isEmpty ? 0.0 : completedCount / _courses.length;
      _currentRoadmap = _currentRoadmap.copyWith(
        courses: _courses,
        completedCourses: completedCount,
        progressPercentage: newPercentage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1024;

    final requiredCourses =
        _courses.where((c) => c.level == CourseLevel.required).toList();
    final recommendedCourses =
        _courses.where((c) => c.level == CourseLevel.recommended).toList();
    final optionalCourses =
        _courses.where((c) => c.level == CourseLevel.optional).toList();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CosmicBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Barra Superior con Botón Atrás y Logo
                  _buildTopBar(context),
                  const SizedBox(height: 24.0),

                  // Hero Banner de la Ruta
                  _buildRoadmapHero(),
                  const SizedBox(height: 32.0),

                  // Título de la Sección de Carriles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          'ESTRUCTURA DE APRENDIZAJE RECOMENDADA',
                          style: AppTypography.columnHeader,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '${_currentRoadmap.completedCourses}/${_courses.length} completados',
                        style: AppTypography.columnHeader.copyWith(
                          color: AppColors.accentVividLime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Visualizador de Carriles (3 Columnas en Desktop / Segmentado en Móvil)
                  if (isDesktop)
                    _buildDesktopThreeColumns(
                      requiredCourses,
                      recommendedCourses,
                      optionalCourses,
                    )
                  else
                    _buildMobileLaneView(
                      requiredCourses,
                      recommendedCourses,
                      optionalCourses,
                    ),

                  const SizedBox(height: 48.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/quiz');
            }
          },
          tooltip: 'Volver',
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.accentLavender,
            size: 22,
          ),
        ),
        const DevTallesLogo(fontSize: 18.0),
        const SizedBox(width: 8.0),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.accentMid.withAlpha(40),
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(color: AppColors.accentLavender.withAlpha(60)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('⚡', style: TextStyle(fontSize: 12)),
                SizedBox(width: 4.0),
                Flexible(
                  child: Text(
                    'RUTA IA',
                    style: TextStyle(
                      color: AppColors.accentLavender,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoadmapHero() {
    final totalHours =
        _courses.fold<double>(0.0, (acc, c) => acc + c.hours).toStringAsFixed(1);

    return AppGlassCard(
      padding: const EdgeInsets.all(24.0),
      borderColor: AppColors.accentLavender.withAlpha(90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Fila de Badges
          Wrap(
            spacing: 8.0,
            runSpacing: 6.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              CategoryBadge(category: _currentRoadmap.category),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.catMovilBg,
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(
                    color: AppColors.accentVividLime,
                    width: 0.8,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 12,
                      color: AppColors.accentVividLime,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      '98% Afinidad',
                      style: TextStyle(
                        color: AppColors.accentVividLime,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Título de la Ruta
          Text(
            _currentRoadmap.title,
            style: AppTypography.h1.copyWith(fontSize: 26.0),
          ),
          const SizedBox(height: 8.0),

          // Descripción
          Text(
            _currentRoadmap.description,
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 20.0),

          // Barra de Progreso
          ProgressBarWidget(progress: _currentRoadmap.progressPercentage),
          const SizedBox(height: 20.0),

          // Métricas Rápidas
          Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
            children: <Widget>[
              _buildStatChip(
                Icons.schedule_rounded,
                '$totalHours Horas Totales',
              ),
              _buildStatChip(
                Icons.menu_book_rounded,
                '${_courses.length} Cursos Estructurados',
              ),
              _buildStatChip(
                Icons.calendar_today_rounded,
                '~${_currentRoadmap.estimatedWeeks} semanas (10h/sem)',
              ),
            ],
          ),
          const SizedBox(height: 24.0),

          // Botones de Acción
          Row(
            children: <Widget>[
              Expanded(
                child: AppPillButton(
                  label: _isSaved ? '¡Guardada en Mis Rutas! ✓' : 'Guardar en Mis Rutas 💾',
                  variant: _isSaved
                      ? AppPillButtonVariant.secondary
                      : AppPillButtonVariant.vivid,
                  onPressed: () {
                    setState(() => _isSaved = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Ruta guardada exitosamente en tu perfil de TechPrime.',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              AppPillButton(
                label: 'Compartir',
                variant: AppPillButtonVariant.secondary,
                icon: const Icon(Icons.share_outlined, size: 16),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enlace de la ruta copiado al portapapeles.'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: AppColors.bgBox,
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14.0, color: AppColors.accentLavender),
          const SizedBox(width: 6.0),
          Flexible(
            child: Text(
              text,
              style: AppTypography.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Vista en 3 Columnas para Desktop (>= 1024px)
  Widget _buildDesktopThreeColumns(
    List<Course> required,
    List<Course> recommended,
    List<Course> optional,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Columna 1: REQUERIDO
        Expanded(
          child: _buildLaneColumn(
            level: CourseLevel.required,
            courses: required,
            description: 'Fundamentos críticos y prerrequisitos obligatorios.',
            accentColor: AppColors.levelRequired,
          ),
        ),
        const SizedBox(width: 16.0),

        // Columna 2: RECOMENDADO
        Expanded(
          child: _buildLaneColumn(
            level: CourseLevel.recommended,
            courses: recommended,
            description: 'Especialización, frameworks y demanda del mercado.',
            accentColor: AppColors.levelRecommended,
          ),
        ),
        const SizedBox(width: 16.0),

        // Columna 3: OPCIONAL
        Expanded(
          child: _buildLaneColumn(
            level: CourseLevel.optional,
            courses: optional,
            description: 'Herramientas complementarias y superpoderes electivos.',
            accentColor: AppColors.levelOptional,
          ),
        ),
      ],
    );
  }

  /// Vista con selector segmentado para Móvil (< 1024px)
  Widget _buildMobileLaneView(
    List<Course> required,
    List<Course> recommended,
    List<Course> optional,
  ) {
    final filteredCourses = switch (_selectedMobileTabIndex) {
      1 => required,
      2 => recommended,
      3 => optional,
      _ => _courses,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Selector de Pestaña de Nivel
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              _buildFilterPill(0, 'Todos (${_courses.length})'),
              const SizedBox(width: 8.0),
              _buildFilterPill(1, '⬢ Requerido (${required.length})'),
              const SizedBox(width: 8.0),
              _buildFilterPill(2, '★ Recomendado (${recommended.length})'),
              const SizedBox(width: 8.0),
              _buildFilterPill(3, '● Opcional (${optional.length})'),
            ],
          ),
        ),
        const SizedBox(height: 16.0),

        // Lista de cursos filtrados
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredCourses.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12.0),
          itemBuilder: (context, index) {
            final course = filteredCourses[index];
            final globalIndex = _courses.indexOf(course);
            return _buildLaneCourseCard(course, globalIndex);
          },
        ),
      ],
    );
  }

  Widget _buildFilterPill(int index, String label) {
    final isSelected = _selectedMobileTabIndex == index;

    return ChoiceChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        fontFamily: AppTypography.bodyFamily,
        fontFamilyFallback: AppTypography.fontFallbacks,
        fontSize: 11.0,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? const Color(0xFF0F172A) : AppColors.textMain,
      ),
      backgroundColor: AppColors.cardBg,
      selectedColor: AppColors.accentVividLime,
      side: BorderSide(
        color: isSelected ? AppColors.accentVividLime : AppColors.cardBorder,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      onSelected: (_) => setState(() => _selectedMobileTabIndex = index),
    );
  }

  Widget _buildLaneColumn({
    required CourseLevel level,
    required List<Course> courses,
    required String description,
    required Color accentColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Encabezado del Carril
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: accentColor.withAlpha(20),
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: accentColor.withAlpha(80)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  LevelBadge(level: level),
                  const Spacer(),
                  Text(
                    '${courses.length} cursos',
                    style: AppTypography.bodySmall.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Text(
                description,
                style: AppTypography.bodySmall.copyWith(fontSize: 11.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14.0),

        // Lista de Tarjetas del Carril
        for (final course in courses) ...<Widget>[
          _buildLaneCourseCard(course, _courses.indexOf(course)),
          const SizedBox(height: 12.0),
        ],
      ],
    );
  }

  Widget _buildLaneCourseCard(Course course, int globalIndex) {
    return AppGlassCard(
      padding: const EdgeInsets.all(16.0),
      borderColor: course.isCompleted
          ? AppColors.accentVividLime.withAlpha(120)
          : AppColors.cardBorder,
      onTap: () => _toggleCourseCompletion(globalIndex),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Fila Superior: Paso e Insignia de Categoría
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: AppColors.bgBox,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'PASO 0${globalIndex + 1}',
                  style: const TextStyle(
                    fontFamily: AppTypography.headingFamily,
                    fontFamilyFallback: AppTypography.fontFallbacks,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentLavender,
                  ),
                ),
              ),
              CategoryBadge(category: course.category),
            ],
          ),
          const SizedBox(height: 10.0),

          // Título del Curso
          Text(
            course.name,
            style: AppTypography.h3.copyWith(fontSize: 15.0),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6.0),

          // Descripción
          Text(
            course.description,
            style: AppTypography.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12.0),

          // Fila de Metadatos y Checkbox de Completado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.schedule_rounded,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        '${course.hours}h • ${course.lessons} lecc.',
                        style: AppTypography.bodySmall.copyWith(fontSize: 11.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    course.isCompleted ? 'COMPLETADO' : 'PENDIENTE',
                    style: TextStyle(
                      fontFamily: AppTypography.bodyFamily,
                      fontFamilyFallback: AppTypography.fontFallbacks,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: course.isCompleted
                          ? AppColors.accentVividLime
                          : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Icon(
                    course.isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 18.0,
                    color: course.isCompleted
                        ? AppColors.accentVividLime
                        : AppColors.textMuted,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
