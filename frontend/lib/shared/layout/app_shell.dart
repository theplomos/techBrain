import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Contenedor de las 4 pestañas.
///
/// Elige la barra de navegación según el ancho disponible. De momento solo
/// muestra el contenido: las barras llegan en las tareas siguientes.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: navigationShell);
  }
}
