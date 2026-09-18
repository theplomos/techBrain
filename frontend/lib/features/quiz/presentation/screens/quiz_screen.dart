import 'package:flutter/material.dart';

import '../../../../shared/widgets/coming_soon_view.dart';

/// Pantalla de cuestionarios generados por IA. La Etapa 6 la implementa.
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(title: 'Cuestionarios', stage: 6);
  }
}
