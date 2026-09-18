import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';

/// Logotipo de TechBrain: `{tech/brain}`.
///
/// Sigue el estilo de llaves de DevTalles sin copiar su marca, para que la app
/// no se confunda con la plataforma oficial.
class TechBrainLogo extends StatelessWidget {
  const TechBrainLogo({super.key, this.fontSize = 22});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = TextStyle(
      fontFamily: AppFonts.heading,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      height: 1.0,
    );

    return Semantics(
      label: 'TechBrain',
      child: ExcludeSemantics(
        child: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: '{',
                style: base.copyWith(color: AppColors.accentLavender),
              ),
              TextSpan(
                text: 'tech/brain',
                style: base.copyWith(color: AppColors.textMain),
              ),
              TextSpan(
                text: '}',
                style: base.copyWith(color: AppColors.accentLavender),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
