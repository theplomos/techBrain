import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_colors.dart';
import 'package:techbrain/config/theme/app_theme.dart';
import 'package:techbrain/config/theme/app_typography.dart';

void main() {
  group('AppTheme.dark', () {
    final ThemeData theme = AppTheme.dark;

    test('es un tema oscuro de Material 3', () {
      expect(theme.brightness, Brightness.dark);
      expect(theme.useMaterial3, isTrue);
    });

    test('deja pasar el fondo cósmico', () {
      expect(theme.scaffoldBackgroundColor, Colors.transparent);
    });

    test('usa los acentos de DevTalles en el ColorScheme', () {
      expect(theme.colorScheme.primary, AppColors.accentElectric);
      expect(theme.colorScheme.secondary, AppColors.accentVivid);
      expect(theme.colorScheme.surface, AppColors.bgBox);
      expect(theme.colorScheme.onSurface, AppColors.textMain);
      expect(theme.colorScheme.error, AppColors.errorRed);
    });

    test('titula con Space Grotesk y escribe con DM Sans', () {
      expect(theme.textTheme.titleLarge!.fontFamily, AppFonts.heading);
      expect(theme.textTheme.bodyMedium!.fontFamily, AppFonts.body);
    });
  });
}
