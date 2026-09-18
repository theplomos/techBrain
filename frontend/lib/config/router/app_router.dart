import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/catalog/presentation/screens/explore_screen.dart';
import '../../features/quiz/presentation/screens/quiz_screen.dart';
import '../../features/roadmap/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../shared/errors/failure.dart';
import '../../shared/layout/app_shell.dart';
import '../../shared/widgets/error_view.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Router de la app.
///
/// Se mantiene vivo durante toda la sesión: recrearlo perdería el historial
/// de navegación de cada pestaña.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    redirect: (BuildContext context, GoRouterState state) =>
        state.uri.path == '/' ? AppRoutes.home : null,
    errorBuilder: (BuildContext context, GoRouterState state) => ErrorView(
      error: const NotFoundFailure(),
      onRetry: () => context.go(AppRoutes.home),
      retryLabel: 'Ir a Home',
    ),
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) => AppShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (BuildContext _, GoRouterState _) => const NoTransitionPage<void>(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.explore,
                pageBuilder: (BuildContext _, GoRouterState _) => const NoTransitionPage<void>(
                  child: ExploreScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.quiz,
                pageBuilder: (BuildContext _, GoRouterState _) => const NoTransitionPage<void>(
                  child: QuizScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.settings,
                pageBuilder: (BuildContext _, GoRouterState _) => const NoTransitionPage<void>(
                  child: SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
