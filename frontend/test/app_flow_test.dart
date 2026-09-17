import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/main.dart';

void main() {
  testWidgets('TechBrainApp boots up and navigates across tabs', (tester) async {
    // Definir tamaño de pantalla mobile para probar barra inferior
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const ProviderScope(child: TechBrainApp()));
    await tester.pumpAndSettle();

    // Comprobar que carga el Dashboard de Home
    expect(find.text('¡Hola, Alex Rivera! 🚀'), findsOneWidget);
    expect(find.text('MIS RUTAS GUARDADAS'), findsOneWidget);
    expect(find.text('MIS MÉTRICAS'), findsOneWidget);

    // Navegar a Explorar
    await tester.tap(find.text('Explorar'));
    await tester.pumpAndSettle();

    expect(find.text('Catálogo de Cursos'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Navegar a Cuestionarios
    await tester.tap(find.text('Cuestionarios'));
    await tester.pumpAndSettle();

    expect(find.text('Evaluación Diagnóstica'), findsOneWidget);
    expect(find.textContaining('¿Cuál es tu área tecnológica'), findsOneWidget);

    // Navegar a Ajustes
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();

    expect(find.text('Configuración y Perfil'), findsOneWidget);
    expect(find.text('TechBrain • Equipo #13'), findsOneWidget);
  });
}
