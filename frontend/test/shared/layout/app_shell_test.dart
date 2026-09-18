import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/app.dart';
import 'package:techbrain/config/theme/app_colors.dart';
import 'package:techbrain/features/catalog/presentation/screens/explore_screen.dart';
import 'package:techbrain/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:techbrain/features/roadmap/presentation/screens/home_screen.dart';
import 'package:techbrain/shared/layout/app_bottom_nav_bar.dart';
import 'package:techbrain/shared/layout/app_top_nav_bar.dart';
import 'package:techbrain/shared/layout/breakpoints.dart';
import 'package:techbrain/shared/widgets/tech_brain_logo.dart';

/// Monta la app con un viewport de [size] lógicos.
Future<void> pumpAppAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const ProviderScope(child: TechBrainApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a 390 px muestra la barra inferior', (tester) async {
    await pumpAppAt(tester, const Size(390, 844));

    expect(find.byType(AppBottomNavBar), findsOneWidget);
  });

  testWidgets('la barra inferior lista las 4 pestañas', (tester) async {
    await pumpAppAt(tester, const Size(390, 844));

    expect(
      find.descendant(
        of: find.byType(AppBottomNavBar),
        matching: find.text('Home'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AppBottomNavBar),
        matching: find.text('Explorar'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AppBottomNavBar),
        matching: find.text('Cuestionarios'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(AppBottomNavBar),
        matching: find.text('Configuración'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('pulsar Explorar abre ExploreScreen', (tester) async {
    await pumpAppAt(tester, const Size(390, 844));

    await tester.tap(find.text('Explorar'));
    await tester.pumpAndSettle();

    expect(find.byType(ExploreScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('cada pestaña cumple el área táctil de 44 x 44 px',
      (tester) async {
    await pumpAppAt(tester, const Size(390, 844));

    for (final String label in <String>[
      'Home',
      'Explorar',
      'Cuestionarios',
      'Configuración',
    ]) {
      final Size size = tester.getSize(
        find.ancestor(
          of: find.descendant(
            of: find.byType(AppBottomNavBar),
            matching: find.text(label),
          ),
          matching: find.byType(ConstrainedBox),
        ).first,
      );
      expect(size.height, greaterThanOrEqualTo(44.0), reason: 'pestaña $label');
      expect(size.width, greaterThanOrEqualTo(44.0), reason: 'pestaña $label');
    }
  });

  testWidgets('a 360 px no hay desbordes', (tester) async {
    await pumpAppAt(tester, const Size(360, 640));

    expect(tester.takeException(), isNull);
  });

  testWidgets('a 1023 px sigue mostrando la barra inferior', (tester) async {
    await pumpAppAt(tester, const Size(1023, 800));

    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(find.byType(AppTopNavBar), findsNothing);
  });

  testWidgets('a 1024 px cambia a la barra superior', (tester) async {
    await pumpAppAt(tester, const Size(1024, 800));

    expect(find.byType(AppTopNavBar), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsNothing);
  });

  testWidgets('a 1280 px la barra superior lleva el logotipo', (tester) async {
    await pumpAppAt(tester, const Size(1280, 800));

    expect(find.byType(AppTopNavBar), findsOneWidget);
    expect(find.byType(TechBrainLogo), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsNothing);
  });

  testWidgets('en escritorio el contenido no pasa del ancho máximo',
      (tester) async {
    await pumpAppAt(tester, const Size(1600, 900));

    final Size size = tester.getSize(find.byType(HomeScreen));
    expect(size.width, lessThanOrEqualTo(Breakpoints.maxContentWidth));
  });

  testWidgets('en escritorio se navega entre pestañas', (tester) async {
    await pumpAppAt(tester, const Size(1280, 800));

    await tester.tap(find.text('Cuestionarios'));
    await tester.pumpAndSettle();

    expect(find.byType(QuizScreen), findsOneWidget);
  });

  testWidgets(
      'cada pestaña de la barra superior cumple el área táctil de 44 x 44 px',
      (tester) async {
    await pumpAppAt(tester, const Size(1280, 800));

    for (final String label in <String>[
      'Home',
      'Explorar',
      'Cuestionarios',
      'Configuración',
    ]) {
      final Size size = tester.getSize(
        find.ancestor(
          of: find.descendant(
            of: find.byType(AppTopNavBar),
            matching: find.text(label),
          ),
          matching: find.byType(ConstrainedBox),
        ).first,
      );
      expect(size.height, greaterThanOrEqualTo(44.0), reason: 'pestaña $label');
      expect(size.width, greaterThanOrEqualTo(44.0), reason: 'pestaña $label');
    }
  });

  testWidgets('la pestaña activa en la barra superior tiene indicador de acento',
      (tester) async {
    await pumpAppAt(tester, const Size(1280, 800));

    final DecoratedBox decoratedBox = tester.widget<DecoratedBox>(
      find.ancestor(
        of: find.descendant(
          of: find.byType(AppTopNavBar),
          matching: find.text('Home'),
        ),
        matching: find.byType(DecoratedBox),
      ).first,
    );
    final BoxDecoration decoration = decoratedBox.decoration as BoxDecoration;
    expect(decoration.border?.bottom.color, AppColors.accentVivid);
    expect(decoration.border?.bottom.width, 2.0);
  });
}
