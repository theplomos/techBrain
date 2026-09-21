import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:techbrain/features/roadmap/presentation/screens/route_detail_screen.dart';
import 'package:techbrain/shared/mock/mock_data.dart';
import 'package:techbrain/shared/widgets/pill_button.dart';
import 'package:techbrain/shared/widgets/progress_bar.dart';

import '../../helpers/pump_at_size.dart';

void main() {
  group('QuizScreen', () {
    testWidgets(
      'a 375 px y a 1280 px se renderiza sin excepciones de overflow',
      (tester) async {
        await pumpScreenAt(tester, const QuizScreen(), const Size(375, 812));
        expect(tester.takeException(), isNull);

        await pumpScreenAt(tester, const QuizScreen(), const Size(1280, 800));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'en la primera pregunta Anterior está deshabilitado y Siguiente está deshabilitado sin respuesta',
      (tester) async {
        await pumpScreenAt(tester, const QuizScreen(), const Size(1280, 800));

        expect(find.text('EVALUACIÓN DIAGNÓSTICA'), findsOneWidget);
        expect(find.text('Pregunta 1 de 3'), findsOneWidget);

        final ProgressBar progressBar = tester.widget<ProgressBar>(
          find.byType(ProgressBar),
        );
        expect(progressBar.value, closeTo(1 / 3, 0.01));
        expect(progressBar.showLabel, isFalse);

        final PillButton prevButton = tester.widget<PillButton>(
          find.widgetWithText(PillButton, 'ANTERIOR'),
        );
        expect(prevButton.onPressed, isNull);

        final PillButton nextButton = tester.widget<PillButton>(
          find.widgetWithText(PillButton, 'SIGUIENTE'),
        );
        expect(nextButton.onPressed, isNull);
      },
    );

    testWidgets(
      'al seleccionar una opción Siguiente se habilita y la opción queda seleccionada',
      (tester) async {
        final handle = tester.ensureSemantics();
        await pumpScreenAt(tester, const QuizScreen(), const Size(1280, 800));

        final firstOptionText = MockData.quizQuestions[0].options[0];
        final optionFinder = find.text(firstOptionText);

        expect(find.byIcon(Icons.radio_button_checked), findsNothing);

        await tester.tap(optionFinder);
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);

        final PillButton nextButton = tester.widget<PillButton>(
          find.widgetWithText(PillButton, 'SIGUIENTE'),
        );
        expect(nextButton.onPressed, isNotNull);

        handle.dispose();
      },
    );

    testWidgets('avance y retroceso conservan la respuesta seleccionada', (
      tester,
    ) async {
      await pumpScreenAt(tester, const QuizScreen(), const Size(1280, 800));

      final firstOptionText = MockData.quizQuestions[0].options[0];
      await tester.tap(find.text(firstOptionText));
      await tester.pumpAndSettle();

      // Avanzar a la pregunta 2
      await tester.tap(find.widgetWithText(PillButton, 'SIGUIENTE'));
      await tester.pumpAndSettle();

      expect(find.text('Pregunta 2 de 3'), findsOneWidget);

      final PillButton prevButton = tester.widget<PillButton>(
        find.widgetWithText(PillButton, 'ANTERIOR'),
      );
      expect(prevButton.onPressed, isNotNull);

      // Retroceder a la pregunta 1
      await tester.tap(find.widgetWithText(PillButton, 'ANTERIOR'));
      await tester.pumpAndSettle();

      expect(find.text('Pregunta 1 de 3'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      expect(find.text(firstOptionText), findsOneWidget);
    });

    testWidgets(
      'en la última pregunta el botón de avance es Generar mi ruta con variante vivid',
      (tester) async {
        await pumpScreenAt(tester, const QuizScreen(), const Size(1280, 800));

        // Responder Pregunta 1
        await tester.tap(find.text(MockData.quizQuestions[0].options[0]));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(PillButton, 'SIGUIENTE'));
        await tester.pumpAndSettle();

        // Responder Pregunta 2
        await tester.tap(find.text(MockData.quizQuestions[1].options[0]));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(PillButton, 'SIGUIENTE'));
        await tester.pumpAndSettle();

        // Pregunta 3
        expect(find.text('Pregunta 3 de 3'), findsOneWidget);
        expect(find.widgetWithText(PillButton, 'SIGUIENTE'), findsNothing);

        final Finder generateFinder = find.widgetWithText(
          PillButton,
          'GENERAR MI RUTA',
        );
        expect(generateFinder, findsOneWidget);

        final PillButton initialGenerateButton = tester.widget<PillButton>(
          generateFinder,
        );
        expect(initialGenerateButton.variant, equals(PillButtonVariant.vivid));
        expect(initialGenerateButton.onPressed, isNull);

        // Responder Pregunta 3
        await tester.tap(find.text(MockData.quizQuestions[2].options[0]));
        await tester.pumpAndSettle();

        final PillButton enabledGenerateButton = tester.widget<PillButton>(
          generateFinder,
        );
        expect(enabledGenerateButton.onPressed, isNotNull);
      },
    );

    testWidgets(
      'pulsar Generar mi ruta navega al detalle de la ruta generada',
      (tester) async {
        await pumpAppAt(
          tester,
          const Size(1280, 800),
          initialLocation: '/quiz',
        );

        // Responder Pregunta 1
        await tester.tap(find.text(MockData.quizQuestions[0].options[0]));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(PillButton, 'SIGUIENTE'));
        await tester.pumpAndSettle();

        // Responder Pregunta 2
        await tester.tap(find.text(MockData.quizQuestions[1].options[0]));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(PillButton, 'SIGUIENTE'));
        await tester.pumpAndSettle();

        // Responder Pregunta 3
        await tester.tap(find.text(MockData.quizQuestions[2].options[0]));
        await tester.pumpAndSettle();

        // Pulsar Generar mi ruta
        await tester.tap(find.widgetWithText(PillButton, 'GENERAR MI RUTA'));
        await tester.pumpAndSettle();

        expect(find.byType(RouteDetailScreen), findsOneWidget);
        expect(find.text('RUTA DE APRENDIZAJE'), findsOneWidget);
      },
    );
  });
}
