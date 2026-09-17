import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/config/theme/app_theme.dart';
import 'package:frontend/features/roadmap/presentation/roadmap_detail_view.dart';
import 'package:frontend/shared/data/mock_data.dart';

Widget _wrapView(Widget child, [Size size = const Size(1200, 800)]) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: child,
    ),
  );
}

void main() {
  group('RoadmapDetailView Tests', () {
    testWidgets('renders desktop 3-column priority layout on wide screens',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _wrapView(const RoadmapDetailView()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ruta Personalizada: Fullstack React & Agentes IA'),
          findsOneWidget);
      expect(find.text('ESTRUCTURA DE APRENDIZAJE RECOMENDADA'), findsOneWidget);

      // Los 3 niveles deben aparecer en desktop
      expect(find.text('REQUERIDO'), findsOneWidget);
      expect(find.text('RECOMENDADO'), findsOneWidget);
      expect(find.text('OPCIONAL'), findsOneWidget);

      // Cursos de cada nivel
      expect(find.text('Dart: De cero hasta los detalles'), findsOneWidget);
      expect(find.text('React: De cero a experto (Hooks y MERN)'), findsOneWidget);
      expect(find.text('TanStack Query: Manejo de estado asíncrono'), findsOneWidget);
      expect(find.text('Agentes de IA y Model Context Protocol (MCP)'),
          findsOneWidget);
      expect(find.text('Go (Golang): Microservicios y sistemas distribuidos'),
          findsOneWidget);
    });

    testWidgets('renders mobile segmented filter on narrow screens',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _wrapView(
          RoadmapDetailView(roadmap: MockData.generatedDemoRoadmap),
          const Size(390, 844),
        ),
      );
      await tester.pumpAndSettle();

      // Pestañas segmentadas en móvil
      expect(find.textContaining('Todos (6)'), findsOneWidget);
      expect(find.textContaining('⬢ Requerido (2)'), findsOneWidget);
      expect(find.textContaining('★ Recomendado (3)'), findsOneWidget);
      expect(find.textContaining('● Opcional (1)'), findsOneWidget);
    });

    testWidgets('toggles course completion and updates progress', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_wrapView(const RoadmapDetailView()));
      await tester.pumpAndSettle();

      expect(find.text('1/6 completados'), findsOneWidget);

      // Tocar el curso de React para completarlo
      final reactFinder = find.text('React: De cero a experto (Hooks y MERN)');
      await tester.ensureVisible(reactFinder);
      await tester.tap(reactFinder);
      await tester.pumpAndSettle();

      expect(find.text('2/6 completados'), findsOneWidget);
    });

    testWidgets('tapping Guardar en Mis Rutas provides feedback', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_wrapView(const RoadmapDetailView()));
      await tester.pumpAndSettle();

      expect(find.text('Guardar en Mis Rutas 💾'.toUpperCase()), findsOneWidget);
      await tester.tap(find.text('Guardar en Mis Rutas 💾'.toUpperCase()));
      await tester.pump();

      expect(find.text('¡Guardada en Mis Rutas! ✓'.toUpperCase()), findsOneWidget);
    });
  });
}
