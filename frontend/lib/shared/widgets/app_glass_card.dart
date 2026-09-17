import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

/// Tarjeta estilizada con fondo translúcido y borde sutil.
/// Single Responsibility: Proveer el contenedor visual glassmorphic unificado.
class AppGlassCard extends StatelessWidget {
  const AppGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.borderColor,
    this.backgroundColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      color: borderColor ?? AppColors.cardBorder,
      width: 1.0,
    );

    final cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardBg,
        borderRadius: BorderRadius.circular(18.0),
        border: border,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x223A14C4),
            offset: Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) {
      return cardContent;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.0),
      splashColor: AppColors.accentMid.withAlpha(50),
      highlightColor: AppColors.accentElectric.withAlpha(30),
      child: cardContent,
    );
  }
}
