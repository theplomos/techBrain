import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/app.dart';
import 'package:techbrain/features/roadmap/presentation/screens/home_screen.dart';
import 'package:techbrain/shared/widgets/cosmic_background.dart';

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: TechBrainApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('la app arranca en Home', (tester) async {
    await pumpApp(tester);

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('envuelve las rutas en el fondo cósmico', (tester) async {
    await pumpApp(tester);

    expect(find.byType(CosmicBackground), findsOneWidget);
  });

  testWidgets('resuelve el locale español y el tema oscuro', (tester) async {
    await pumpApp(tester);

    final BuildContext context = tester.element(find.byType(HomeScreen));
    expect(Localizations.localeOf(context), const Locale('es'));
    expect(Theme.of(context).brightness, Brightness.dark);
  });

  testWidgets('oculta el banner de depuración', (tester) async {
    await pumpApp(tester);

    final MaterialApp app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.debugShowCheckedModeBanner, isFalse);
  });
}
