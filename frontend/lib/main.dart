import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TechBrainApp()));
}

/// Punto de entrada del aplicativo TechBrain (Web, iOS, Android).
/// Single Responsibility: Inicializar la aplicación con tema y enrutamiento global.
class TechBrainApp extends StatelessWidget {
  const TechBrainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TechBrain • DevTalles',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
