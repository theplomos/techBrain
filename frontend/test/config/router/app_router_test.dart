import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:techbrain/config/router/app_router.dart';
import 'package:techbrain/config/router/app_routes.dart';
import 'package:techbrain/features/catalog/presentation/screens/explore_screen.dart';
import 'package:techbrain/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:techbrain/features/roadmap/presentation/screens/home_screen.dart';
import 'package:techbrain/features/roadmap/presentation/screens/route_detail_screen.dart';
import 'package:techbrain/features/settings/presentation/screens/settings_screen.dart';
import 'package:techbrain/shared/layout/app_bottom_nav_bar.dart';
import 'package:techbrain/shared/layout/app_top_nav_bar.dart';
import 'package:techbrain/shared/widgets/error_view.dart';

/// Monta la app con el router apuntando a [location].
Future<GoRouter> pumpRouter(WidgetTester tester, String location) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  final GoRouter router = container.read(appRouterProvider);
  router.go(location);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

void main() {
  testWidgets('/ redirige a /home', (tester) async {
    final GoRouter router = await pumpRouter(tester, '/');

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(router.routerDelegate.currentConfiguration.uri.path, AppRoutes.home);
  });

  testWidgets('cada path abre su pantalla', (tester) async {
    for (final (String path, Type screen) in <(String, Type)>[
      (AppRoutes.home, HomeScreen),
      (AppRoutes.explore, ExploreScreen),
      (AppRoutes.quiz, QuizScreen),
      (AppRoutes.settings, SettingsScreen),
    ]) {
      await pumpRouter(tester, path);
      expect(find.byType(screen), findsOneWidget, reason: 'path $path');
    }
  });

  testWidgets('una ruta desconocida muestra ErrorView con el texto de 404', (
    tester,
  ) async {
    await pumpRouter(tester, '/no-existe');

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('No encontramos lo que buscas.'), findsOneWidget);
    expect(find.text('IR A HOME'), findsOneWidget);
  });

  testWidgets('el botón de la ruta desconocida vuelve a Home', (tester) async {
    await pumpRouter(tester, '/no-existe');

    await tester.tap(find.text('IR A HOME'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets(
    '/routes/frontend-react muestra el título sin barras de navegación',
    (tester) async {
      await pumpRouter(tester, '/routes/frontend-react');

      expect(find.byType(RouteDetailScreen), findsOneWidget);
      expect(
        find.text('Frontend Profesional con React y Next.js'),
        findsOneWidget,
      );
      expect(find.byType(AppTopNavBar), findsNothing);
      expect(find.byType(AppBottomNavBar), findsNothing);
    },
  );

  testWidgets(
    '/routes/no-existe muestra ErrorView con botón para volver a Home',
    (tester) async {
      await pumpRouter(tester, '/routes/no-existe');

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('No encontramos lo que buscas.'), findsOneWidget);
      expect(find.text('IR A HOME'), findsOneWidget);

      await tester.tap(find.text('IR A HOME'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    },
  );

  testWidgets('el provider mantiene la misma instancia de GoRouter', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(appRouterProvider),
      same(container.read(appRouterProvider)),
    );
  });
}
