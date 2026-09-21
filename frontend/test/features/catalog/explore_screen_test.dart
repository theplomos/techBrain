import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/features/catalog/presentation/screens/explore_screen.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/mock/mock_data.dart';
import 'package:techbrain/shared/widgets/course_card.dart';

import '../../helpers/pump_at_size.dart';

void main() {
  group('ExploreScreen', () {
    testWidgets(
      'a 375 px y a 1280 px se renderiza sin excepciones de overflow',
      (tester) async {
        await pumpScreenAt(tester, const ExploreScreen(), const Size(375, 812));
        expect(tester.takeException(), isNull);

        await pumpScreenAt(
          tester,
          const ExploreScreen(),
          const Size(1280, 800),
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('muestra título, subtítulo, buscador y chips de categorías', (
      tester,
    ) async {
      await pumpScreenAt(tester, const ExploreScreen(), const Size(1280, 800));

      expect(find.text('Catálogo de cursos'), findsOneWidget);
      expect(
        find.text('Explora los cursos oficiales de DevTalles.'),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Buscar por nombre o tecnología'), findsOneWidget);

      // Todos + 6 categorías = 7 chips
      expect(find.byType(ChoiceChip), findsNWidgets(7));
      expect(find.widgetWithText(ChoiceChip, 'Todos'), findsOneWidget);
      for (final CourseCategory cat in CourseCategory.values) {
        expect(
          find.widgetWithText(ChoiceChip, cat.datasetValue),
          findsOneWidget,
        );
      }
    });

    testWidgets(
      'inicialmente muestra los 12 cursos con showLevel: false y contador en 12',
      (tester) async {
        await pumpScreenAt(
          tester,
          const ExploreScreen(),
          const Size(1280, 800),
        );

        expect(find.text('CURSOS DISPONIBLES (12)'), findsOneWidget);
        expect(find.byType(CourseCard), findsNWidgets(12));

        final Iterable<CourseCard> cards = tester.widgetList<CourseCard>(
          find.byType(CourseCard),
        );
        for (final CourseCard card in cards) {
          expect(card.showLevel, isFalse);
        }
      },
    );

    testWidgets(
      'al escribir flutter en el buscador filtra a los cursos correspondientes y el contador coincide',
      (tester) async {
        await pumpScreenAt(
          tester,
          const ExploreScreen(),
          const Size(1280, 800),
        );

        await tester.enterText(find.byType(TextField), 'flutter');
        await tester.pumpAndSettle();

        final expectedCourses = MockData.catalog
            .where(
              (c) =>
                  c.name.toLowerCase().contains('flutter') ||
                  c.slug.toLowerCase().contains('flutter'),
            )
            .length;

        expect(
          find.text('CURSOS DISPONIBLES ($expectedCourses)'),
          findsOneWidget,
        );
        expect(find.byType(CourseCard), findsNWidgets(expectedCourses));
      },
    );

    testWidgets(
      'la búsqueda no distingue mayúsculas y limpia espacios en blanco',
      (tester) async {
        await pumpScreenAt(
          tester,
          const ExploreScreen(),
          const Size(1280, 800),
        );

        await tester.enterText(find.byType(TextField), '  REACT  ');
        await tester.pumpAndSettle();

        final expectedCourses = MockData.catalog
            .where(
              (c) =>
                  c.name.toLowerCase().contains('react') ||
                  c.slug.toLowerCase().contains('react'),
            )
            .length;

        expect(
          find.text('CURSOS DISPONIBLES ($expectedCourses)'),
          findsOneWidget,
        );
        expect(find.byType(CourseCard), findsNWidgets(expectedCourses));
      },
    );

    testWidgets(
      'al seleccionar un chip de categoría filtra los cursos correspondientes',
      (tester) async {
        await pumpScreenAt(
          tester,
          const ExploreScreen(),
          const Size(1280, 800),
        );

        // Pulsar el chip de AGENTES IA
        await tester.tap(
          find.widgetWithText(ChoiceChip, CourseCategory.aiAgents.datasetValue),
        );
        await tester.pumpAndSettle();

        final expectedCount = MockData.catalog
            .where((c) => c.category == CourseCategory.aiAgents)
            .length;

        expect(
          find.text('CURSOS DISPONIBLES ($expectedCount)'),
          findsOneWidget,
        );
        expect(find.byType(CourseCard), findsNWidgets(expectedCount));
      },
    );

    testWidgets(
      'con filtros activos muestra Limpiar filtros y al pulsarlo restablece todo',
      (tester) async {
        await pumpScreenAt(
          tester,
          const ExploreScreen(),
          const Size(1280, 800),
        );

        expect(find.text('Limpiar filtros'), findsNothing);

        // Aplicar filtro de búsqueda
        await tester.enterText(find.byType(TextField), 'nest');
        await tester.pumpAndSettle();

        expect(find.text('Limpiar filtros'), findsOneWidget);

        // Pulsar Limpiar filtros
        await tester.tap(find.text('Limpiar filtros'));
        await tester.pumpAndSettle();

        expect(find.text('Limpiar filtros'), findsNothing);
        expect(find.text('CURSOS DISPONIBLES (12)'), findsOneWidget);
        expect(find.byType(CourseCard), findsNWidgets(12));
      },
    );

    testWidgets('sin resultados muestra el estado vacío con mensaje e icono', (
      tester,
    ) async {
      await pumpScreenAt(tester, const ExploreScreen(), const Size(1280, 800));

      await tester.enterText(find.byType(TextField), 'busqueda-inexistente');
      await tester.pumpAndSettle();

      expect(find.text('CURSOS DISPONIBLES (0)'), findsOneWidget);
      expect(find.byType(CourseCard), findsNothing);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.text('No se encontraron cursos'), findsOneWidget);
      expect(
        find.text('Intenta con otro término o limpia los filtros.'),
        findsOneWidget,
      );
    });
  });
}
