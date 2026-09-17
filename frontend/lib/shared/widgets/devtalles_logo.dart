import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';

/// Logotipo oficial de DevTalles con llaves estéticas en lavanda.
/// Single Responsibility: Renderizar la marca gráfica `{dev/talles}`.
class DevTallesLogo extends StatelessWidget {
  const DevTallesLogo({super.key, this.fontSize = 20.0});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: AppTypography.headingFamily,
          fontFamilyFallback: AppTypography.fontFallbacks,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        children: const <TextSpan>[
          TextSpan(
            text: '{',
            style: TextStyle(
              color: AppColors.accentLavender,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: 'dev',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: '/',
            style: TextStyle(
              color: AppColors.accentLavender,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: 'talles',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: '}',
            style: TextStyle(
              color: AppColors.accentLavender,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
