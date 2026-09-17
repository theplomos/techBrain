import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_colors.dart';
import 'package:techbrain/config/theme/app_typography.dart';

void main() {
  group('buildAppTextTheme', () {
    final TextTheme theme = buildAppTextTheme();

    test('los títulos usan Space Grotesk', () {
      expect(theme.displayLarge!.fontFamily, AppFonts.heading);
      expect(theme.displayLarge!.fontWeight, FontWeight.w700);
      expect(theme.headlineMedium!.fontFamily, AppFonts.heading);
      expect(theme.headlineMedium!.fontWeight, FontWeight.w600);
      expect(theme.titleLarge!.fontFamily, AppFonts.heading);
      expect(theme.titleLarge!.fontWeight, FontWeight.w600);
    });

    test('el cuerpo y las etiquetas usan DM Sans', () {
      expect(theme.bodyLarge!.fontFamily, AppFonts.body);
      expect(theme.bodyMedium!.fontFamily, AppFonts.body);
      expect(theme.bodySmall!.fontFamily, AppFonts.body);
      expect(theme.labelLarge!.fontFamily, AppFonts.body);
      expect(theme.labelSmall!.fontFamily, AppFonts.body);
    });

    test('el texto se lee en claro sobre el fondo oscuro', () {
      expect(theme.bodyMedium!.color, AppColors.textMain);
      expect(theme.titleLarge!.color, AppColors.textMain);
    });

    test('conserva los tamaños de Material 3', () {
      final TextTheme material3 = Typography.material2021(
        platform: TargetPlatform.android,
      ).white;
      expect(theme.bodyMedium!.fontSize, material3.bodyMedium!.fontSize);
      expect(theme.titleLarge!.fontSize, material3.titleLarge!.fontSize);
    });
  });

  group('AppTextStyles', () {
    test('button y buttonVivid siguen el sistema de diseño', () {
      expect(AppTextStyles.button.fontFamily, AppFonts.body);
      expect(AppTextStyles.button.fontWeight, FontWeight.w500);
      expect(AppTextStyles.button.fontSize, 13.0);
      expect(AppTextStyles.button.letterSpacing, 2.0);

      expect(AppTextStyles.buttonVivid.fontWeight, FontWeight.w700);
      expect(AppTextStyles.buttonVivid.letterSpacing, 1.5);
    });

    test('chip y columnHeader siguen el sistema de diseño', () {
      expect(AppTextStyles.chip.fontSize, 11.0);
      expect(AppTextStyles.chip.letterSpacing, 1.5);

      expect(AppTextStyles.columnHeader.fontSize, 11.0);
      expect(AppTextStyles.columnHeader.letterSpacing, 2.5);
      expect(AppTextStyles.columnHeader.color, AppColors.textSub);
    });
  });
}
