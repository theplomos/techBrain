import 'package:flutter/material.dart';

import 'glass_container.dart';

/// Marcador de una pantalla que implementa una etapa posterior.
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key, required this.title, required this.stage});

  final String title;

  /// Número de etapa que construirá esta pantalla.
  final int stage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420.0),
        child: GlassContainer(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12.0),
              Text(
                'Disponible en la Etapa $stage.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
