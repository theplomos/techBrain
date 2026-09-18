import 'package:flutter/material.dart';

import '../../../../shared/widgets/coming_soon_view.dart';

/// Pantalla de catálogo y búsqueda. La Etapa 3 la implementa.
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(title: 'Explorar', stage: 3);
  }
}
