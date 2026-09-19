import 'package:flutter/material.dart';

import '../../../../shared/widgets/coming_soon_view.dart';

/// Pantalla de configuración y perfil. La Etapa 5 la implementa.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(title: 'Configuración', stage: 5);
  }
}
