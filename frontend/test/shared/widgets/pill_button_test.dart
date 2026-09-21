import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_colors.dart';
import 'package:techbrain/config/theme/app_tokens.dart';
import 'package:techbrain/config/theme/app_typography.dart';
import 'package:techbrain/shared/widgets/pill_button.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

/// Decoración frontal del botón: es donde vive el anillo de foco.
BoxDecoration? _ring(WidgetTester tester) {
  final AnimatedContainer button = tester.widget<AnimatedContainer>(
    find.descendant(
      of: find.byType(PillButton),
      matching: find.byType(AnimatedContainer),
    ),
  );
  return button.foregroundDecoration as BoxDecoration?;
}

void main() {
  testWidgets('escribe la etiqueta en mayúsculas', (tester) async {
    await tester.pumpWidget(
      _host(PillButton(label: 'Empezar ahora', onPressed: () {})),
    );

    expect(find.text('EMPEZAR AHORA'), findsOneWidget);
    expect(find.text('Empezar ahora'), findsNothing);
  });

  testWidgets('llama a onPressed al pulsarlo', (tester) async {
    var presses = 0;
    await tester.pumpWidget(
      _host(PillButton(label: 'Pulsar', onPressed: () => presses++)),
    );

    await tester.tap(find.byType(PillButton));
    await tester.pump();

    expect(presses, 1);
  });

  testWidgets('con onPressed null no reacciona al toque', (tester) async {
    await tester.pumpWidget(
      _host(const PillButton(label: 'Inactivo', onPressed: null)),
    );

    await tester.tap(find.byType(PillButton));
    await tester.pump();

    expect(tester.takeException(), isNull);
    final Opacity opacity = tester.widget<Opacity>(
      find.descendant(
        of: find.byType(PillButton),
        matching: find.byType(Opacity),
      ),
    );
    expect(opacity.opacity, 0.5);
  });

  testWidgets('cumple el área táctil mínima de 44 px', (tester) async {
    await tester.pumpWidget(_host(PillButton(label: 'OK', onPressed: () {})));

    final Size size = tester.getSize(find.byType(PillButton));
    expect(size.height, greaterThanOrEqualTo(44.0));
    expect(size.width, greaterThanOrEqualTo(44.0));
  });

  testWidgets('se ajusta a su contenido y no ocupa todo el ancho', (
    tester,
  ) async {
    // El host es un Center sobre la superficie de 800 px de los tests: si el
    // botón se estirase al ancho acotado mediría los 800 px enteros.
    await tester.pumpWidget(
      _host(PillButton(label: 'Primario', onPressed: () {})),
    );

    final Size size = tester.getSize(find.byType(PillButton));
    expect(size.width, lessThan(300.0));
    expect(size.height, greaterThanOrEqualTo(44.0));
  });

  testWidgets('con el foco pinta el anillo de 2 px en accentLavender', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(PillButton(label: 'Guardar', onPressed: () {})),
    );

    expect(_ring(tester), isNull);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    final BoxDecoration? ring = _ring(tester);
    expect(ring, isNotNull);
    expect((ring!.border! as Border).top.color, AppColors.accentLavender);
    expect((ring.border! as Border).top.width, AppFocus.ringWidth);
    expect(ring.borderRadius, BorderRadius.circular(AppRadii.pill));
  });

  testWidgets('deshabilitado no recibe el anillo de foco', (tester) async {
    await tester.pumpWidget(
      _host(const PillButton(label: 'Inactivo', onPressed: null)),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    expect(_ring(tester), isNull);
  });

  testWidgets('la variante vivid usa su propio estilo de texto', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        PillButton(
          label: 'Generar',
          variant: PillButtonVariant.vivid,
          onPressed: () {},
        ),
      ),
    );

    final Text text = tester.widget<Text>(find.text('GENERAR'));
    expect(text.style!.fontWeight, AppTextStyles.buttonVivid.fontWeight);
    expect(text.style!.letterSpacing, AppTextStyles.buttonVivid.letterSpacing);
  });

  testWidgets('la variante secondary tiene borde y no degradado', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        PillButton(
          label: 'Reintentar',
          variant: PillButtonVariant.secondary,
          onPressed: () {},
        ),
      ),
    );

    final AnimatedContainer container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(PillButton),
        matching: find.byType(AnimatedContainer),
      ),
    );
    final BoxDecoration decoration = container.decoration! as BoxDecoration;
    expect(decoration.gradient, isNull);
    expect(decoration.border, isNotNull);
  });

  testWidgets('muestra el icono cuando se le pasa uno', (tester) async {
    await tester.pumpWidget(
      _host(
        PillButton(
          label: 'Ir a Home',
          icon: Icons.home_rounded,
          onPressed: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
  });

  testWidgets('expone SemanticsAction.tap e invocarla llama a onPressed', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    var presses = 0;
    await tester.pumpWidget(
      _host(PillButton(label: 'Guardar', onPressed: () => presses++)),
    );

    final SemanticsNode node = tester.getSemantics(find.byType(PillButton));
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    tester.semantics.performAction(
      find.semantics.byLabel('GUARDAR'),
      SemanticsAction.tap,
    );
    await tester.pump();

    expect(presses, 1);
    handle.dispose();
  });

  testWidgets('deshabilitado no expone SemanticsAction.tap', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(const PillButton(label: 'Inactivo', onPressed: null)),
    );

    final SemanticsNode node = tester.getSemantics(find.byType(PillButton));
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
    handle.dispose();
  });

  testWidgets('se anuncia como botón con su etiqueta', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(PillButton(label: 'Guardar', onPressed: () {})),
    );

    expect(find.bySemanticsLabel('GUARDAR'), findsOneWidget);
    handle.dispose();
  });
}
