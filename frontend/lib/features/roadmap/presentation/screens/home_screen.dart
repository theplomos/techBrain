import 'package:flutter/material.dart';

import '../../../../shared/widgets/coming_soon_view.dart';

/// Pantalla de inicio. La Etapa 4 la implementa con la ruta activa,
/// las rutas guardadas y las métricas del usuario.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(title: 'Home', stage: 4);
  }
}
