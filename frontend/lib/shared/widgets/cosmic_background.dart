import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Fondo espacial de TechBrain.
///
/// Se monta en el `builder` de MaterialApp para que cubra todas las rutas,
/// incluida la de error. Ocupa el viewport y no se desplaza con el contenido.
class CosmicBackground extends StatelessWidget {
  const CosmicBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bgPrimary,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // radial-gradient(ellipse 55% 65% at 75% 45%, rgba(58,20,196,.38))
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.5, -0.1),
                  radius: 0.9,
                  colors: <Color>[
                    Color.fromRGBO(58, 20, 196, 0.38),
                    Color.fromRGBO(58, 20, 196, 0.0),
                  ],
                  stops: <double>[0.0, 0.7],
                ),
              ),
            ),
          ),
          // radial-gradient(ellipse 35% 45% at 15% 85%, rgba(90,22,193,.20))
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.7, 0.7),
                  radius: 0.6,
                  colors: <Color>[
                    Color.fromRGBO(90, 22, 193, 0.20),
                    Color.fromRGBO(90, 22, 193, 0.0),
                  ],
                  stops: <double>[0.0, 0.6],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
