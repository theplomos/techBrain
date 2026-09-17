import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/explore/presentation/explore_view.dart';
import '../../features/home/presentation/home_view.dart';
import '../../features/quiz/presentation/quiz_view.dart';
import '../../features/settings/presentation/settings_view.dart';
import '../../shared/widgets/responsive_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Configuración central de navegación mediante GoRouter y StatefulShellRoute.
/// Single Responsibility: Definir el grafo de rutas de la aplicación.
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ResponsiveShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          // Rama 0: Home / Dashboard
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                name: 'home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeView(),
                ),
              ),
            ],
          ),

          // Rama 1: Explorar
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/explore',
                name: 'explore',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ExploreView(),
                ),
              ),
            ],
          ),

          // Rama 2: Cuestionarios
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/quiz',
                name: 'quiz',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: QuizView(),
                ),
              ),
            ],
          ),

          // Rama 3: Ajustes
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/settings',
                name: 'settings',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsView(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
