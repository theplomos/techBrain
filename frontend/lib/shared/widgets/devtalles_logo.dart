import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';

/// Logotipo oficial con llaves estéticas en lavanda y tipografía Space Grotesk.
/// Single Responsibility: Renderizar la marca gráfica `{tech/prime}`.
class DevTallesLogo extends StatelessWidget {
  const DevTallesLogo({
    super.key,
    this.fontSize = 20.0,
    this.prefix = 'tech',
    this.suffix = 'prime',
  });

  final double fontSize;
  final String prefix;
  final String suffix;

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
        children: <TextSpan>[
          const TextSpan(
            text: '{',
            style: TextStyle(
              color: AppColors.accentLavender,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: prefix,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(
            text: '/',
            style: TextStyle(
              color: AppColors.accentLavender,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: suffix,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(
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
