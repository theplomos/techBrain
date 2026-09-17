import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import 'app_glass_card.dart';

/// Ficha compacta de métricas para el Dashboard.
/// Single Responsibility: Renderizar un valor métrico destacado con icono y etiqueta.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.highlightColor = AppColors.accentLavender,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 18.0, color: highlightColor),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: AppTypography.columnHeader.copyWith(fontSize: 10.0),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: AppTypography.numberHighlight.copyWith(
              color: AppColors.textMain,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
