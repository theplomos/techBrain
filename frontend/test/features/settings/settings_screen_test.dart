import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/features/settings/presentation/screens/settings_screen.dart';
import 'package:techbrain/shared/mock/mock_data.dart';
import 'package:techbrain/shared/widgets/pill_button.dart';

import '../../helpers/pump_at_size.dart';

void main() {
  group('SettingsScreen', () {
    testWidgets(
      'a 375 px y a 1280 px se renderiza sin excepciones de overflow',
      (tester) async {
        await pumpScreenAt(
          tester,
          const SettingsScreen(),
          const Size(375, 812),
        );
        expect(tester.takeException(), isNull);

        await pumpScreenAt(
          tester,
          const SettingsScreen(),
          const Size(1280, 800),
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('muestra tarjeta de perfil con iniciales AR, nombre y tag', (
      tester,
    ) async {
      await pumpScreenAt(tester, const SettingsScreen(), const Size(1280, 800));

      expect(find.text('Configuración y perfil'), findsOneWidget);
      expect(find.text('AR'), findsOneWidget);
      expect(find.text(MockData.user.name), findsOneWidget);
      expect(find.text('@${MockData.user.discordTag}'), findsOneWidget);
      expect(find.text('Miembro de DevTalles'), findsOneWidget);
    });

    testWidgets(
      'el slider empieza en 10 h/semana y actualiza el valor local al interactuar',
      (tester) async {
        await pumpScreenAt(
          tester,
          const SettingsScreen(),
          const Size(1280, 800),
        );

        expect(find.text('10 h/semana'), findsOneWidget);

        final Finder sliderFinder = find.byType(Slider);
        expect(sliderFinder, findsOneWidget);

        // Desplazar el slider hacia la derecha
        await tester.drag(sliderFinder, const Offset(120.0, 0.0));
        await tester.pumpAndSettle();

        expect(find.text('10 h/semana'), findsNothing);
        expect(find.textContaining('h/semana'), findsOneWidget);
      },
    );

    testWidgets(
      'botón Cerrar sesión está deshabilitado con variante secondary',
      (tester) async {
        await pumpScreenAt(
          tester,
          const SettingsScreen(),
          const Size(1280, 800),
        );

        expect(find.text('Conectado con Discord'), findsOneWidget);

        final Finder logoutFinder = find.widgetWithText(
          PillButton,
          'CERRAR SESIÓN',
        );
        expect(logoutFinder, findsOneWidget);

        final PillButton logoutButton = tester.widget<PillButton>(logoutFinder);
        expect(logoutButton.onPressed, isNull);
        expect(logoutButton.variant, equals(PillButtonVariant.secondary));
      },
    );

    testWidgets(
      'muestra sección Acerca de con información del equipo y licencia',
      (tester) async {
        await pumpScreenAt(
          tester,
          const SettingsScreen(),
          const Size(1280, 800),
        );

        expect(find.text('TechBrain · Equipo #13'), findsOneWidget);
        expect(
          find.text('DevTalles CodeQuest 2026 · Misión CQ03-2026'),
          findsOneWidget,
        );
        expect(find.text('Licencia MIT'), findsOneWidget);
      },
    );
  });
}
