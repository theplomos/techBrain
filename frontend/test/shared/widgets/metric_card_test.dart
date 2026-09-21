import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_colors.dart';
import 'package:techbrain/config/theme/app_typography.dart';
import 'package:techbrain/shared/widgets/glass_container.dart';
import 'package:techbrain/shared/widgets/metric_card.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('MetricCard', () {
    testWidgets('muestra value y label con los estilos esperados', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const MetricCard(value: '42', label: 'Cursos completados')),
      );

      expect(find.text('42'), findsOneWidget);
      expect(find.text('Cursos completados'), findsOneWidget);

      final Text valueText = tester.widget<Text>(find.text('42'));
      expect(valueText.style?.fontFamily, equals(AppFonts.heading));
      expect(valueText.style?.fontWeight, equals(FontWeight.w700));
      expect(valueText.style?.fontSize, equals(28.0));
      expect(valueText.style?.color, equals(AppColors.textMain));
    });

    testWidgets(
      'muestra icono a 20 px en accentLavender cuando se proporciona',
      (tester) async {
        await tester.pumpWidget(
          _host(
            const MetricCard(
              value: '120',
              label: 'Horas totales',
              icon: Icons.schedule,
            ),
          ),
        );

        expect(find.byIcon(Icons.schedule), findsOneWidget);
        final Icon iconWidget = tester.widget<Icon>(
          find.byIcon(Icons.schedule),
        );
        expect(iconWidget.size, equals(20.0));
        expect(iconWidget.color, equals(AppColors.accentLavender));
      },
    );

    testWidgets('no muestra icono si no se proporciona', (tester) async {
      await tester.pumpWidget(
        _host(const MetricCard(value: '3', label: 'Rutas guardadas')),
      );

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets(
      'se monta dentro de un GlassContainer con 20 px de padding sin onTap',
      (tester) async {
        await tester.pumpWidget(
          _host(const MetricCard(value: '5', label: 'Días de racha')),
        );

        final GlassContainer glass = tester.widget<GlassContainer>(
          find.byType(GlassContainer),
        );
        expect(glass.padding, equals(const EdgeInsets.all(20.0)));
        expect(glass.onTap, isNull);
      },
    );
  });
}
