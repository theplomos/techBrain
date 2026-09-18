import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_bottom_nav_bar.dart';

/// Contenedor de las 4 pestañas.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// Cambia de pestaña.
  ///
  /// `initialLocation: true` cuando ya se está en la pestaña reinicia su pila
  /// de navegación, que es lo que espera el usuario al volver a pulsarla.
  void _goToTab(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El contenido pasa por detrás de la barra flotante.
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: navigationShell,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTabSelected: _goToTab,
      ),
    );
  }
}
