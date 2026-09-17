import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

/// Fondo cósmico espacial con resplandor neón violeta en capas.
/// Single Responsibility: Renderizar la atmósfera visual de DevTalles.
class CosmicBackground extends StatelessWidget {
  const CosmicBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        gradient: RadialGradient(
          center: Alignment(0.7, -0.2),
          radius: 1.2,
          colors: <Color>[
            Color(0x385A16C1), // Resplandor violeta profundo
            Colors.transparent,
          ],
          stops: <double>[0.0, 0.7],
        ),
      ),
      child: Stack(
        children: <Widget>[
          // Segunda capa sutil en la esquina inferior izquierda
          Positioned(
            left: -100,
            bottom: -100,
            child: IgnorePointer(
              child: Container(
                width: 320,
                height: 320,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      Color(0x203A14C4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
