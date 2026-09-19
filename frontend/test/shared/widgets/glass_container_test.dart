import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/widgets/glass_container.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('sin blur no monta ningún BackdropFilter', (tester) async {
    await tester.pumpWidget(
      _host(const GlassContainer(child: Text('contenido'))),
    );

    expect(find.byType(BackdropFilter), findsNothing);
    expect(find.text('contenido'), findsOneWidget);
  });

  testWidgets('con blur monta un BackdropFilter', (tester) async {
    await tester.pumpWidget(
      _host(const GlassContainer(blur: true, child: Text('contenido'))),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
  });

  testWidgets('dispara onTap al tocarlo', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(GlassContainer(onTap: () => taps++, child: const Text('tocable'))),
    );

    await tester.tap(find.text('tocable'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('se activa con Enter cuando tiene el foco', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(GlassContainer(onTap: () => taps++, child: const Text('tocable'))),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('se activa con Espacio cuando tiene el foco', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(GlassContainer(onTap: () => taps++, child: const Text('tocable'))),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('sin onTap no es enfocable', (tester) async {
    await tester.pumpWidget(
      _host(const GlassContainer(child: Text('estático'))),
    );

    expect(find.byType(FocusableActionDetector), findsNothing);
  });

  testWidgets('expone la etiqueta semántica recibida', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        GlassContainer(
          semanticLabel: 'Tarjeta de ejemplo',
          onTap: () {},
          child: const Text('contenido'),
        ),
      ),
    );

    expect(find.bySemanticsLabel(RegExp('Tarjeta de ejemplo')), findsOneWidget);
    handle.dispose();
  });
}
