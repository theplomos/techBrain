import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/course.dart';
import '../../../shared/widgets/course_card.dart';

/// Pantalla de Exploración de Cursos y Rutas Oficiales.
/// Single Responsibility: Proveer navegación, búsqueda y filtrado en el catálogo.
class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  String _searchQuery = '';
  CourseCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final filteredCourses = MockData.catalogCourses.where((course) {
      final matchesQuery = course.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          course.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == null || course.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Encabezado
              Text(
                'Catálogo de Cursos',
                style: AppTypography.h1.copyWith(fontSize: 22.0),
              ),
              const SizedBox(height: 6.0),
              const Text(
                'Explora los cursos oficiales de DevTalles para potenciar tus habilidades.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 20.0),

              // Buscador en tiempo real
              _buildSearchBar(),
              const SizedBox(height: 16.0),

              // Filtros por Categoría
              _buildCategoryFilters(),
              const SizedBox(height: 24.0),

              // Conteo de resultados
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'CURSOS DISPONIBLES (${filteredCourses.length})',
                    style: AppTypography.columnHeader,
                  ),
                  if (_selectedCategory != null || _searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = null;
                          _searchQuery = '';
                        });
                      },
                      child: const Text(
                        'Limpiar filtros',
                        style: TextStyle(
                          color: AppColors.accentLavender,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12.0),

              // Lista de Cursos
              if (filteredCourses.isEmpty)
                _buildEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredCourses.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14.0),
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    return CourseCard(
                      course: course,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Curso seleccionado: ${course.name}',
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: AppColors.cardBorder, width: 1.0),
      ),
      child: TextField(
        style: const TextStyle(color: AppColors.textMain, fontSize: 14.0),
        decoration: InputDecoration(
          hintText: 'Buscar por tecnología (React, Flutter, Go, NestJS...)',
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13.0),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.accentLavender,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 14.0,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => setState(() => _searchQuery = ''),
                )
              : null,
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _buildFilterChip(null, 'Todos'),
          for (final cat in CourseCategory.values) ...<Widget>[
            const SizedBox(width: 8.0),
            _buildFilterChip(cat, cat.label),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(CourseCategory? category, String label) {
    final isSelected = _selectedCategory == category;

    return FilterChip(
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
      checkmarkColor: const Color(0xFF0F172A),
      side: BorderSide(
        color: isSelected
            ? AppColors.accentVividLime
            : AppColors.cardBorderHover,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      onSelected: (_) => setState(() => _selectedCategory = category),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 12.0),
            const Text(
              'No se encontraron cursos',
              style: AppTypography.h3,
            ),
            const SizedBox(height: 6.0),
            const Text(
              'Intenta con otro término o limpia los filtros.',
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
