import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';
import '../../config/theme/app_typography.dart';

/// Barra de progreso horizontal con degradado, radio píldora y etiqueta opcional.
class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.value, this.showLabel = true});

  /// Valor de progreso que se limitará entre 0.0 y 1.0.
  final double value;

  /// Si es true, muestra a la derecha el porcentaje formateado (p. ej. `50 %`).
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final double clampedValue = value.clamp(0.0, 1.0);
    final int percentage = (clampedValue * 100).round();
    final String labelText = '$percentage %';

    return Semantics(
      label: 'Progreso: $labelText',
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 8.0,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(192, 185, 252, 0.12),
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: constraints.maxWidth * clampedValue,
                      height: 8.0,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: <Color>[
                            AppColors.accentMid,
                            AppColors.accentElectric,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (showLabel) ...<Widget>[
            const SizedBox(width: 8.0),
            Text(labelText, style: AppTextStyles.chip),
          ],
        ],
      ),
    );
  }
}
