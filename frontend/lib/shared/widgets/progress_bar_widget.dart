import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';

/// Barra de progreso estilizada con acento Cyber Lime neón.
/// Single Responsibility: Renderizar el porcentaje de progreso visual de un curso o ruta.
class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    super.key,
    required this.progress,
    this.showLabel = true,
    this.height = 8.0,
  });

  /// Valor entre 0.0 y 1.0
  final double progress;
  final bool showLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percentageInt = (clampedProgress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showLabel) ...<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'PROGRESO ACUMULADO',
                style: AppTypography.columnHeader,
              ),
              Text(
                '$percentageInt%',
                style: AppTypography.numberHighlight.copyWith(
                  color: AppColors.accentVividLime,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
        ],
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.bgBox,
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(color: AppColors.cardBorder, width: 1.0),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: clampedProgress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                gradient: const LinearGradient(
                  colors: <Color>[
                    AppColors.accentMid,
                    AppColors.accentVividLime,
                  ],
                ),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x66C8DD09),
                    blurRadius: 8,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
