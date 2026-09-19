import 'package:flutter/material.dart';

import '../../../../config/theme/app_typography.dart';
import '../../../../shared/domain/course_category.dart';
import '../../../../shared/domain/course_level.dart';
import '../../../../shared/widgets/category_badge.dart';
import '../../../../shared/widgets/coming_soon_view.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/level_badge.dart';
import '../../../../shared/widgets/pill_button.dart';

/// Pantalla de inicio. La Etapa 4 la implementa con la ruta activa,
/// las rutas guardadas y las métricas del usuario, y elimina el muestrario.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      children: <Widget>[
        const ComingSoonView(title: 'Home', stage: 4),
        const SizedBox(height: 32.0),
        const _ShowcaseHeader(),
        const SizedBox(height: 16.0),
        const _ShowcaseSection(title: 'Botones', child: _ButtonShowcase()),
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
              for (final CourseCategory category in CourseCategory.values)
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
        // Deja sitio para la barra inferior flotante.
        const SizedBox(height: 96.0),
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
