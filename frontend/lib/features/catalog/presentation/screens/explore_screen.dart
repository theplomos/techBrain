import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_tokens.dart';
import '../../../../config/theme/app_typography.dart';
import '../../../../shared/domain/course_category.dart';
import '../../../../shared/layout/breakpoints.dart';
import '../../../../shared/mock/mock_data.dart';
import '../../../../shared/mock/mock_models.dart';
import '../../../../shared/widgets/course_card.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/section_header.dart';

/// Pantalla de catálogo y búsqueda de cursos.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  CourseCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedCategory = null;
    });
  }

  List<MockCourse> _getFilteredCourses() {
    final String query = _searchQuery.trim().toLowerCase();
    return MockData.catalog.where((MockCourse course) {
      if (_selectedCategory != null && course.category != _selectedCategory) {
        return false;
      }
      if (query.isNotEmpty) {
        final bool nameMatches = course.name.toLowerCase().contains(query);
        final bool slugMatches = course.slug.toLowerCase().contains(query);
        if (!nameMatches && !slugMatches) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<MockCourse> filteredCourses = _getFilteredCourses();
    final bool hasActiveFilters =
        _searchQuery.trim().isNotEmpty || _selectedCategory != null;

    return ListView(
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
                // Título y subtítulo
                Text(
                  'Catálogo de cursos',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Explora los cursos oficiales de DevTalles.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 24.0),

                // Buscador
                TextField(
                  controller: _searchController,
                  onChanged: (String value) {
                    setState(() => _searchQuery = value);
                  },
                  style: const TextStyle(color: AppColors.textMain),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o tecnología',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textMuted,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.textMuted,
                            ),
                            tooltip: 'Borrar búsqueda',
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.cardBg,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 14.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.card),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.card),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.card),
                      borderSide: const BorderSide(
                        color: AppColors.accentLavender,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Fila de chips de categoría
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      ChoiceChip(
                        label: const Text('Todos'),
                        selected: _selectedCategory == null,
                        onSelected: (_) {
                          setState(() => _selectedCategory = null);
                        },
                        selectedColor: AppColors.accentElectric,
                        backgroundColor: AppColors.cardBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                        side: BorderSide(
                          color: _selectedCategory == null
                              ? AppColors.accentLavender
                              : AppColors.cardBorder,
                        ),
                        labelStyle: AppTextStyles.chip.copyWith(
                          color: _selectedCategory == null
                              ? AppColors.textMain
                              : AppColors.textMuted,
                        ),
                        showCheckmark: false,
                      ),
                      for (final CourseCategory category
                          in CourseCategory.values) ...<Widget>[
                        const SizedBox(width: 8.0),
                        ChoiceChip(
                          label: Text(category.datasetValue),
                          selected: _selectedCategory == category,
                          onSelected: (_) {
                            setState(() => _selectedCategory = category);
                          },
                          selectedColor: AppColors.accentElectric,
                          backgroundColor: AppColors.cardBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                          ),
                          side: BorderSide(
                            color: _selectedCategory == category
                                ? AppColors.accentLavender
                                : AppColors.cardBorder,
                          ),
                          labelStyle: AppTextStyles.chip.copyWith(
                            color: _selectedCategory == category
                                ? AppColors.textMain
                                : AppColors.textMuted,
                          ),
                          showCheckmark: false,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Encabezado de resultados con acción de limpiar
                SectionHeader(
                  'Cursos disponibles (${filteredCourses.length})',
                  trailing: hasActiveFilters
                      ? TextButton(
                          onPressed: _clearFilters,
                          child: const Text(
                            'Limpiar filtros',
                            style: TextStyle(color: AppColors.accentLavender),
                          ),
                        )
                      : null,
                ),

                // Rejilla de cursos o estado vacío
                if (filteredCourses.isEmpty)
                  GlassContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 40.0,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.search_off,
                            size: 48.0,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'No se encontraron cursos',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Intenta con otro término o limpia los filtros.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final int columns;
                          if (constraints.maxWidth < 600.0) {
                            columns = 1;
                          } else if (constraints.maxWidth < 1024.0) {
                            columns = 2;
                          } else {
                            columns = 3;
                          }

                          final List<Widget> rows = <Widget>[];
                          for (
                            int i = 0;
                            i < filteredCourses.length;
                            i += columns
                          ) {
                            if (i > 0) {
                              rows.add(const SizedBox(height: 16.0));
                            }
                            final List<Widget> rowChildren = <Widget>[];
                            for (int j = 0; j < columns; j++) {
                              if (j > 0) {
                                rowChildren.add(const SizedBox(width: 16.0));
                              }
                              if (i + j < filteredCourses.length) {
                                rowChildren.add(
                                  Expanded(
                                    child: CourseCard(
                                      course: filteredCourses[i + j],
                                      showLevel: false,
                                    ),
                                  ),
                                );
                              } else {
                                rowChildren.add(
                                  const Expanded(child: SizedBox()),
                                );
                              }
                            }
                            rows.add(
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: rowChildren,
                              ),
                            );
                          }
                          return Column(children: rows);
                        },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
