import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_typography.dart';
import 'package:techbrain/shared/widgets/section_header.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('SectionHeader', () {
    testWidgets(
      'escribe el título en mayúsculas y aplica el estilo columnHeader',
      (tester) async {
        await tester.pumpWidget(_host(const SectionHeader('Mis rutas')));

        expect(find.text('MIS RUTAS'), findsOneWidget);
        expect(find.text('Mis rutas'), findsNothing);

        final Text textWidget = tester.widget<Text>(find.text('MIS RUTAS'));
        expect(textWidget.style, equals(AppTextStyles.columnHeader));
      },
    );

    testWidgets(
      'muestra el widget trailing alineado a la derecha cuando se pasa',
      (tester) async {
        await tester.pumpWidget(
          _host(const SectionHeader('Categorías', trailing: Text('Ver todas'))),
        );

        expect(find.text('CATEGORÍAS'), findsOneWidget);
        expect(find.text('Ver todas'), findsOneWidget);
      },
    );

    testWidgets('tiene Semantics con header: true', (tester) async {
      await tester.pumpWidget(_host(const SectionHeader('Encabezado')));

      final Semantics semanticsWidget = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(SectionHeader),
          matching: find.byType(Semantics),
        ),
      );
      expect(semanticsWidget.properties.header, isTrue);
    });

    testWidgets('tiene separación inferior de 12 px', (tester) async {
      await tester.pumpWidget(_host(const SectionHeader('Encabezado')));

      final Padding paddingWidget = tester.widget<Padding>(
        find.descendant(
          of: find.byType(SectionHeader),
          matching: find.byType(Padding),
        ),
      );
      expect(
        paddingWidget.padding,
        equals(const EdgeInsets.only(bottom: 12.0)),
      );
    });
  });
}
