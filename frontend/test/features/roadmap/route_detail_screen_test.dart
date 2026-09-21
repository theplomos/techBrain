import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/features/roadmap/presentation/screens/route_detail_screen.dart';
import 'package:techbrain/features/roadmap/presentation/widgets/level_column.dart';
import 'package:techbrain/shared/domain/course_level.dart';
import 'package:techbrain/shared/mock/mock_data.dart';
import 'package:techbrain/shared/widgets/course_card.dart';
import 'package:techbrain/shared/widgets/level_badge.dart';
import 'package:techbrain/shared/widgets/pill_button.dart';

import '../../helpers/pump_at_size.dart';

void main() {
  group('RouteDetailScreen', () {
    const String routeId = 'frontend-react';

    testWidgets(
      'a 1280 px muestra 3 LevelColumn encabezadas por LevelBadge y sin ChoiceChips',
      (tester) async {
        await pumpScreenAt(
          tester,
          const RouteDetailScreen(routeId: routeId),
          const Size(1280, 1000),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(LevelColumn), findsNWidgets(3));
        expect(find.byType(ChoiceChip), findsNothing);

        // Cada columna tiene su LevelBadge
        expect(find.byType(LevelBadge), findsNWidgets(3));

        // Las tarjetas dentro de LevelColumn tienen showLevel: false
        final Iterable<CourseCard> cards = tester.widgetList<CourseCard>(
          find.byType(CourseCard),
        );
        for (final card in cards) {
          expect(card.showLevel, isFalse);
        }
      },
    );

    testWidgets(
      'a 375 px muestra chips de nivel y al elegir Requerido filtra la lista',
      (tester) async {
        await pumpScreenAt(
          tester,
          const RouteDetailScreen(routeId: routeId),
          const Size(375, 812),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(LevelColumn), findsNothing);

        // Hay 4 chips: Todos + los 3 niveles
        expect(find.byType(ChoiceChip), findsNWidgets(4));
        expect(find.textContaining('Todos'), findsOneWidget);
        expect(find.textContaining('Requerido'), findsOneWidget);

        final route = MockData.routeById(routeId)!;
        final totalCourses = route.courses.length;
        final requiredCourses = route.courses
            .where((c) => c.level == CourseLevel.required)
            .length;

        // Inicialmente en 'Todos'
        expect(find.byType(CourseCard), findsNWidgets(totalCourses));

        // Pulsar el chip 'Requerido'
        await tester.tap(find.textContaining('Requerido'));
        await tester.pumpAndSettle();

        // Solo deben quedar los cursos requeridos
        expect(find.byType(CourseCard), findsNWidgets(requiredCourses));

        final Iterable<CourseCard> filteredCards = tester
            .widgetList<CourseCard>(find.byType(CourseCard));
        for (final card in filteredCards) {
          expect(card.course.level, equals(CourseLevel.required));
          expect(card.showLevel, isTrue);
        }
      },
    );

    testWidgets(
      'botón Guardar cambia a Guardada y queda deshabilitado al pulsarlo',
      (tester) async {
        await pumpScreenAt(
          tester,
          const RouteDetailScreen(routeId: routeId),
          const Size(1280, 1000),
        );

        final Finder saveButtonFinder = find.widgetWithText(
          PillButton,
          'GUARDAR EN MIS RUTAS',
        );
        expect(saveButtonFinder, findsOneWidget);

        final PillButton initialButton = tester.widget<PillButton>(
          saveButtonFinder,
        );
        expect(initialButton.onPressed, isNotNull);

        await tester.tap(saveButtonFinder);
        await tester.pumpAndSettle();

        final Finder savedButtonFinder = find.widgetWithText(
          PillButton,
          'GUARDADA',
        );
        expect(savedButtonFinder, findsOneWidget);

        final PillButton disabledButton = tester.widget<PillButton>(
          savedButtonFinder,
        );
        expect(disabledButton.onPressed, isNull);
      },
    );
  });
}
