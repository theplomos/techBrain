import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_colors.dart';
import 'package:techbrain/config/theme/app_tokens.dart';

void main() {
  group('AppColors', () {
    test('los fondos usan los valores del sistema de diseño', () {
      expect(AppColors.bgPrimary, const Color(0xFF171027));
      expect(AppColors.bgBox, const Color(0xFF1C1829));
      expect(AppColors.cardBg, const Color.fromRGBO(28, 24, 41, 0.85));
      expect(AppColors.navBg, const Color.fromRGBO(23, 16, 39, 0.85));
    });

    test('los acentos usan los valores del sistema de diseño', () {
      expect(AppColors.accentElectric, const Color(0xFF3A14C4));
      expect(AppColors.accentMid, const Color(0xFF4725AF));
      expect(AppColors.accentDeep, const Color(0xFF5A16C1));
      expect(AppColors.accentLavender, const Color(0xFFC0B9FC));
      expect(AppColors.accentVivid, const Color(0xFFC8DD09));
      expect(AppColors.brandDiscord, const Color(0xFF5865F2));
    });

    test('los textos usan los valores del sistema de diseño', () {
      expect(AppColors.textMain, const Color(0xFFF0EEFF));
      expect(AppColors.textMuted, const Color(0xFF9B93C8));
      expect(AppColors.textSub, const Color.fromRGBO(192, 185, 252, 0.55));
      expect(AppColors.textOnVivid, const Color(0xFF0F172A));
    });

    test('FULLSTACK reutiliza los tokens que el sistema llama WEB', () {
      expect(AppColors.catFullstackBg, const Color.fromRGBO(244, 174, 163, 0.25));
      expect(AppColors.catFullstackBorder, const Color(0xFFF4AEA3));
    });

    test('el chip de BASES usa la opacidad de la tabla de tokens, no la de Tailwind', () {
      expect(AppColors.catBasesBg, const Color.fromRGBO(192, 185, 252, 0.20));
    });
  });

  group('AppTokens', () {
    test('los radios cumplen RNF-03', () {
      expect(AppRadii.card, 18.0);
      expect(AppRadii.inner, 10.0);
      expect(AppRadii.pill, 50.0);
    });

    test('glowLg es más intenso que glowSm', () {
      expect(AppShadows.glowSm, hasLength(2));
      expect(AppShadows.glowLg, hasLength(2));
      expect(AppShadows.glowLg.last.blurRadius,
          greaterThan(AppShadows.glowSm.last.blurRadius));
    });

    test('la animación de hover dura 200 ms', () {
      expect(AppMotion.hover, const Duration(milliseconds: 200));
      expect(AppMotion.hoverCurve, const Cubic(0.16, 1, 0.3, 1));
    });

    test('el desenfoque de las barras usa sigma 16', () {
      expect(AppBlur.bar, 16.0);
    });
  });
}
