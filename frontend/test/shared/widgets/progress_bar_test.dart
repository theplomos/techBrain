import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_typography.dart';
import 'package:techbrain/shared/widgets/progress_bar.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(
    body: Center(child: SizedBox(width: 200, child: child)),
  ),
);

void main() {
  group('ProgressBar', () {
    testWidgets('limita valores fuera de rango entre 0.0 y 1.0', (
      tester,
    ) async {
      // Menor a 0.0 -> 0 %
      await tester.pumpWidget(_host(const ProgressBar(value: -0.5)));
      expect(find.text('0 %'), findsOneWidget);

      // Mayor a 1.0 -> 100 %
      await tester.pumpWidget(_host(const ProgressBar(value: 1.5)));
      expect(find.text('100 %'), findsOneWidget);

      // En rango -> 50 %
      await tester.pumpWidget(_host(const ProgressBar(value: 0.5)));
      expect(find.text('50 %'), findsOneWidget);
    });

    testWidgets(
      'muestra el porcentaje por defecto con estilo AppTextStyles.chip',
      (tester) async {
        await tester.pumpWidget(_host(const ProgressBar(value: 0.75)));

        expect(find.text('75 %'), findsOneWidget);
        final Text labelText = tester.widget<Text>(find.text('75 %'));
        expect(labelText.style, equals(AppTextStyles.chip));
      },
    );

    testWidgets('oculta el porcentaje cuando showLabel es false', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const ProgressBar(value: 0.75, showLabel: false)),
      );

      expect(find.text('75 %'), findsNothing);
    });

    testWidgets('expone la etiqueta semántica con el progreso formateado', (
      tester,
    ) async {
      await tester.pumpWidget(_host(const ProgressBar(value: 0.6)));

      final Semantics semanticsWidget = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(ProgressBar),
          matching: find.byType(Semantics),
        ),
      );
      expect(semanticsWidget.properties.label, equals('Progreso: 60 %'));
    });
  });
}
