import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/app.dart';
import 'package:techbrain/config/router/app_router.dart';

/// Monta una pantalla aislada dentro de un MaterialApp y Scaffold a un tamaño específico.
Future<void> pumpScreenAt(WidgetTester tester, Widget screen, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(MaterialApp(home: Scaffold(body: screen)));
  await tester.pumpAndSettle();
}

/// Monta la app completa con su router y dependencias a un tamaño específico.
///
/// Si se pasa [initialLocation], navega directamente a esa ruta tras montar la app.
/// Permite simular el área segura de dispositivos mediante [padding].
Future<void> pumpAppAt(
  WidgetTester tester,
  Size size, {
  String? initialLocation,
  FakeViewPadding padding = FakeViewPadding.zero,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  tester.view.padding = padding;
  addTearDown(tester.view.reset);

  final ProviderContainer container = ProviderContainer();
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const TechBrainApp(),
    ),
  );

  if (initialLocation != null) {
    container.read(appRouterProvider).go(initialLocation);
  }

  await tester.pumpAndSettle();
}
