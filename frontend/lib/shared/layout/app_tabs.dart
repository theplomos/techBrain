import 'package:flutter/material.dart';

import '../../config/router/app_routes.dart';

/// Una pestaña de la navegación principal.
typedef AppTab = ({
  String path,
  String label,
  IconData icon,
  IconData selectedIcon,
});

/// Las 4 pestañas, en el mismo orden que las ramas del router.
///
/// El índice de esta lista es el índice de rama de StatefulShellRoute.
const List<AppTab> appTabs = <AppTab>[
  (
    path: AppRoutes.home,
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  (
    path: AppRoutes.explore,
    label: 'Explorar',
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore,
  ),
  (
    path: AppRoutes.quiz,
    label: 'Cuestionarios',
    icon: Icons.quiz_outlined,
    selectedIcon: Icons.quiz,
  ),
  (
    path: AppRoutes.settings,
    label: 'Configuración',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
];
