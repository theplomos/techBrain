import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/router/app_routes.dart';
import 'package:techbrain/shared/layout/breakpoints.dart';

import '../../helpers/pump_at_size.dart';

/// Primer texto de cada pestaña: su borde izquierdo es el del contenido.
const List<(String, String)> _tabs = <(String, String)>[
  (AppRoutes.home, 'Hola, Alex Rivera'),
  (AppRoutes.explore, 'Catálogo de cursos'),
  (AppRoutes.quiz, 'EVALUACIÓN DIAGNÓSTICA'),
  (AppRoutes.settings, 'Configuración y perfil'),
];

void main() {
  // El margen lateral lo pone AppShell (SPEC 01): las pantallas no lo repiten.
  testWidgets('a 375 px el contenido de cada pestaña empieza a 16 px', (
    tester,
  ) async {
    for (final (String path, String firstText) in _tabs) {
      await pumpAppAt(tester, const Size(375, 812), initialLocation: path);

      expect(
        tester.getTopLeft(find.text(firstText)).dx,
        16.0,
        reason: 'pestaña $path',
      );
    }
  });

  testWidgets(
    'a 1280 px el contenido de cada pestaña empieza a 32 px del ancho máximo',
    (tester) async {
      const double width = 1280.0;
      const double expected = (width - Breakpoints.maxContentWidth) / 2 + 32.0;

      for (final (String path, String firstText) in _tabs) {
        await pumpAppAt(tester, const Size(width, 800), initialLocation: path);

        expect(
          tester.getTopLeft(find.text(firstText)).dx,
          expected,
          reason: 'pestaña $path',
        );
      }
    },
  );
}
