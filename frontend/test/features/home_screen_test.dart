import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/features/roadmap/presentation/screens/home_screen.dart';
import 'package:techbrain/features/roadmap/presentation/screens/route_detail_screen.dart';
import 'package:techbrain/features/roadmap/presentation/widgets/active_route_card.dart';
import 'package:techbrain/features/roadmap/presentation/widgets/saved_route_tile.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/layout/app_bottom_nav_bar.dart';
import 'package:techbrain/shared/layout/app_top_nav_bar.dart';
import 'package:techbrain/shared/widgets/category_badge.dart';
import 'package:techbrain/shared/widgets/coming_soon_view.dart';
import 'package:techbrain/shared/widgets/glass_container.dart';
import 'package:techbrain/shared/widgets/level_badge.dart';
import 'package:techbrain/shared/widgets/metric_card.dart';
import 'package:techbrain/shared/widgets/pill_button.dart';

import '../helpers/pump_at_size.dart';

Future<void> pumpHome(WidgetTester tester, Size size) =>
    pumpScreenAt(tester, const HomeScreen(), size);

void main() {
  testWidgets('muestra 5 PillButton (1 en ruta activa y 4 en el muestrario)', (
    tester,
  ) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.byType(PillButton), findsNWidgets(5));
  });

  testWidgets('ComingSoonView ya no aparece en Home', (tester) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.byType(ComingSoonView), findsNothing);
  });

  testWidgets('muestra el saludo y la racha del usuario', (tester) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.textContaining('Hola, Alex'), findsOneWidget);
    expect(find.textContaining('días de racha'), findsOneWidget);
  });

  testWidgets('muestra ActiveRouteCard con la ruta activa', (tester) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.byType(ActiveRouteCard), findsOneWidget);
    expect(find.text('RUTA ACTIVA'), findsOneWidget);
  });

  testWidgets('muestra la sección de métricas con 3 MetricCard', (
    tester,
  ) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.text('MIS MÉTRICAS'), findsOneWidget);
    expect(find.byType(MetricCard), findsNWidgets(3));
  });

  testWidgets('muestra las rutas guardadas con SavedRouteTile', (tester) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.text('MIS RUTAS GUARDADAS'), findsOneWidget);
    expect(find.byType(SavedRouteTile), findsNWidgets(3));
  });

  testWidgets('muestra los 3 niveles y las 6 categorías en el muestrario', (
    tester,
  ) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.byType(LevelBadge), findsNWidgets(3));
    expect(
      find.byType(CategoryBadge),
      findsNWidgets(CourseCategory.values.length),
    );
  });

  testWidgets('anuncia que el muestrario es temporal', (tester) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.text('Muestrario de componentes (temporal)'), findsOneWidget);
  });

  testWidgets('a 360 px no desborda', (tester) async {
    await pumpHome(tester, const Size(360, 640));

    expect(tester.takeException(), isNull);
  });

  testWidgets('a 1280 px no desborda', (tester) async {
    await pumpHome(tester, const Size(1280, 800));

    expect(tester.takeException(), isNull);
  });

  testWidgets('"Continuar ruta" navega al detalle de la ruta activa', (
    tester,
  ) async {
    await pumpAppAt(tester, const Size(1280, 800));

    final Finder continueButton = find.widgetWithText(
      PillButton,
      'CONTINUAR RUTA',
    );
    expect(continueButton, findsOneWidget);

    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.byType(RouteDetailScreen), findsOneWidget);
    expect(find.text('RUTA DE APRENDIZAJE'), findsOneWidget);
  });

  testWidgets('pulsar un SavedRouteTile navega al detalle de esa ruta', (
    tester,
  ) async {
    await pumpAppAt(tester, const Size(1280, 800));

    final Finder savedTile = find.byType(SavedRouteTile).first;
    expect(savedTile, findsWidgets);

    await tester.tap(savedTile);
    await tester.pumpAndSettle();

    expect(find.byType(RouteDetailScreen), findsOneWidget);
    expect(find.text('RUTA DE APRENDIZAJE'), findsOneWidget);
  });

  testWidgets(
    'a 1280 px el contenido empieza por debajo de la barra superior',
    (tester) async {
      await pumpAppAt(tester, const Size(1280, 800));

      final double contentTop = tester
          .getTopLeft(find.textContaining('Hola,'))
          .dy;
      expect(contentTop, greaterThanOrEqualTo(AppTopNavBar.height));
    },
  );

  for (final double inset in <double>[34.0, 48.0]) {
    testWidgets(
      'a 390 px con un área segura de $inset px el contenido termina por '
      'encima de la barra inferior',
      (tester) async {
        await pumpAppAt(
          tester,
          const Size(390, 844),
          padding: FakeViewPadding(bottom: inset),
        );

        // Desplaza la lista hasta el final: es ahí donde se ve si el hueco de
        // la barra flotante es suficiente.
        await tester.drag(find.byType(ListView), const Offset(0.0, -5000.0));
        await tester.pumpAndSettle();

        final double contentBottom = tester
            .getBottomLeft(
              find
                  .ancestor(
                    of: find.text('Pasa el cursor o enfócala con Tab.'),
                    matching: find.byType(GlassContainer),
                  )
                  .first,
            )
            .dy;
        final double barTop = tester
            .getTopLeft(find.byType(AppBottomNavBar))
            .dy;

        expect(contentBottom, lessThanOrEqualTo(barTop));
      },
    );
  }
}
