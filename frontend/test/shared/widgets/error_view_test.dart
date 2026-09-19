import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/errors/failure.dart';
import 'package:techbrain/shared/widgets/error_view.dart';
import 'package:techbrain/shared/widgets/pill_button.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('muestra el mensaje de la Failure recibida', (tester) async {
    await tester.pumpWidget(_host(const ErrorView(error: NotFoundFailure())));

    expect(find.text('No encontramos lo que buscas.'), findsOneWidget);
  });

  testWidgets('ante un error que no es Failure muestra el mensaje genérico', (
    tester,
  ) async {
    await tester.pumpWidget(_host(ErrorView(error: StateError('roto'))));

    expect(find.text('Algo salió mal. Inténtalo de nuevo.'), findsOneWidget);
    expect(find.textContaining('roto'), findsNothing);
  });

  testWidgets('sin onRetry no muestra botón', (tester) async {
    await tester.pumpWidget(_host(const ErrorView(error: NetworkFailure())));

    expect(find.byType(PillButton), findsNothing);
  });

  testWidgets('con onRetry muestra el botón y lo invoca', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      _host(ErrorView(error: const NetworkFailure(), onRetry: () => retries++)),
    );

    expect(find.text('REINTENTAR'), findsOneWidget);
    await tester.tap(find.byType(PillButton));
    await tester.pump();

    expect(retries, 1);
  });

  testWidgets('respeta el retryLabel recibido', (tester) async {
    await tester.pumpWidget(
      _host(
        ErrorView(
          error: const NotFoundFailure(),
          onRetry: () {},
          retryLabel: 'Ir a Home',
        ),
      ),
    );

    expect(find.text('IR A HOME'), findsOneWidget);
  });

  testWidgets('no desborda a 360 px de ancho', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(ErrorView(error: const ServerFailure(), onRetry: () {})),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
