import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_bottom_nav_bar.dart';
import 'app_top_nav_bar.dart';
import 'breakpoints.dart';

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
    final double width = MediaQuery.sizeOf(context).width;

    if (width >= Breakpoints.desktop) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppTopNavBar(
          currentIndex: navigationShell.currentIndex,
          onTabSelected: _goToTab,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.maxContentWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: navigationShell,
            ),
          ),
        ),
      );
    }

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
