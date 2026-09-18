import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/app.dart';
import 'package:techbrain/shared/widgets/cosmic_background.dart';

void main() {
  testWidgets('TechBrainApp arranca y muestra el nombre de la app', (tester) async {
    await tester.pumpWidget(const TechBrainApp());

    expect(find.text('TechBrain'), findsOneWidget);
  });

  testWidgets('TechBrainApp resuelve el locale español', (tester) async {
    await tester.pumpWidget(const TechBrainApp());

    final context = tester.element(find.text('TechBrain'));
    expect(Localizations.localeOf(context), const Locale('es'));
  });

  testWidgets('TechBrainApp oculta el banner de depuración', (tester) async {
    await tester.pumpWidget(const TechBrainApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.debugShowCheckedModeBanner, isFalse);
  });

  testWidgets('TechBrainApp envuelve las rutas en el fondo cósmico', (tester) async {
    await tester.pumpWidget(const TechBrainApp());

    expect(find.byType(CosmicBackground), findsOneWidget);
  });

  testWidgets('TechBrainApp aplica el tema oscuro', (tester) async {
    await tester.pumpWidget(const TechBrainApp());

    final context = tester.element(find.text('TechBrain'));
    expect(Theme.of(context).brightness, Brightness.dark);
  });
}
