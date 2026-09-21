import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/features/roadmap/presentation/screens/home_screen.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/layout/app_bottom_nav_bar.dart';
import 'package:techbrain/shared/layout/app_top_nav_bar.dart';
import 'package:techbrain/shared/widgets/category_badge.dart';
import 'package:techbrain/shared/widgets/coming_soon_view.dart';
import 'package:techbrain/shared/widgets/glass_container.dart';
import 'package:techbrain/shared/widgets/level_badge.dart';
import 'package:techbrain/shared/widgets/pill_button.dart';

import '../helpers/pump_at_size.dart';

Future<void> pumpHome(WidgetTester tester, Size size) =>
    pumpScreenAt(tester, const HomeScreen(), size);

void main() {
  testWidgets('muestra las 4 variantes de PillButton', (tester) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.byType(PillButton), findsNWidgets(4));
  });

  testWidgets('muestra los 3 niveles y las 6 categorías', (tester) async {
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

  testWidgets(
    'a 1280 px el contenido empieza por debajo de la barra superior',
    (tester) async {
      await pumpAppAt(tester, const Size(1280, 800));

      final double contentTop = tester
          .getTopLeft(find.byType(ComingSoonView))
          .dy;
      expect(contentTop, greaterThanOrEqualTo(AppTopNavBar.height));
    },
  );

  // El de 34 px es el indicador de inicio de un iPhone, que es el caso que
  // pide el criterio de aceptación; el de 48 px es la navegación por gestos
  // de Android, donde el hueco fijo de 96 px que había antes solapaba la
  // barra por 10 px.
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
        await tester.drag(find.byType(ListView), const Offset(0.0, -3000.0));
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
