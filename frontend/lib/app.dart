import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/theme/app_theme.dart';
import 'shared/widgets/cosmic_background.dart';

/// Raíz de la aplicación.
///
/// Vive fuera de `main.dart` para poder montarla en los tests de widget.
class TechBrainApp extends StatelessWidget {
  const TechBrainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechBrain',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: const Locale('es'),
      supportedLocales: const <Locale>[Locale('es')],
      localizationsDelegates: const <LocalizationsDelegate<Object?>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (BuildContext context, Widget? child) =>
          CosmicBackground(child: child ?? const SizedBox.shrink()),
      home: const Scaffold(
        body: Center(child: Text('TechBrain')),
      ),
    );
  }
}
