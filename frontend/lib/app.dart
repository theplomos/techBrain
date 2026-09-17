import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Raíz de la aplicación.
///
/// Vive fuera de `main.dart` para poder montarla en los tests de widget.
class TechBrainApp extends StatelessWidget {
  const TechBrainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TechBrain',
      debugShowCheckedModeBanner: false,
      locale: Locale('es'),
      supportedLocales: <Locale>[Locale('es')],
      localizationsDelegates: <LocalizationsDelegate<Object?>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: Center(child: Text('TechBrain')),
      ),
    );
  }
}
