import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import 'glass_container.dart';

/// Tarjeta de métrica con cifra destacada en Space Grotesk 700 y etiqueta descriptiva.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
  });

  final String value;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassContainer(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 20.0, color: AppColors.accentLavender),
            const SizedBox(height: 8.0),
          ],
          Text(
            value,
            style: const TextStyle(
              fontFamily: AppFonts.heading,
              fontWeight: FontWeight.w700,
              fontSize: 28.0,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
