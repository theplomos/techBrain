import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/config/theme/app_theme.dart';
import 'package:frontend/shared/models/course.dart';
import 'package:frontend/shared/widgets/app_glass_card.dart';
import 'package:frontend/shared/widgets/app_pill_button.dart';
import 'package:frontend/shared/widgets/category_badge.dart';
import 'package:frontend/shared/widgets/devtalles_logo.dart';
import 'package:frontend/shared/widgets/level_badge.dart';
import 'package:frontend/shared/widgets/metric_card.dart';
import 'package:frontend/shared/widgets/progress_bar_widget.dart';

Widget _wrapWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('Reusable Atomic Widgets Tests (SRP)', () {
    testWidgets('DevTallesLogo renders brand name and braces', (tester) async {
      await tester.pumpWidget(_wrapWidget(const DevTallesLogo()));
      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsOneWidget);
      final richText = tester.widget<RichText>(richTextFinder);
      expect(richText.text.toPlainText(), equals('{tech/prime}'));
    });

    testWidgets('CategoryBadge renders appropriate label', (tester) async {
      await tester.pumpWidget(
        _wrapWidget(const CategoryBadge(category: CourseCategory.frontend)),
      );
      expect(find.text('FRONTEND'), findsOneWidget);
    });

    testWidgets('LevelBadge renders universal symbol and label', (tester) async {
      await tester.pumpWidget(
        _wrapWidget(const LevelBadge(level: CourseLevel.required)),
      );
      expect(find.text('⬢'), findsOneWidget);
      expect(find.text('REQUERIDO'), findsOneWidget);
    });

    testWidgets('ProgressBarWidget displays percentage', (tester) async {
      await tester.pumpWidget(
        _wrapWidget(const ProgressBarWidget(progress: 0.68)),
      );
      expect(find.text('68%'), findsOneWidget);
      expect(find.text('PROGRESO ACUMULADO'), findsOneWidget);
    });

    testWidgets('AppPillButton triggers callback when pressed', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        _wrapWidget(
          AppPillButton(
            label: 'Continuar',
            variant: AppPillButtonVariant.vivid,
            onPressed: () => pressed = true,
          ),
        ),
      );

      expect(find.text('CONTINUAR'), findsOneWidget);
      await tester.tap(find.text('CONTINUAR'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('MetricCard displays highlight value and label', (tester) async {
      await tester.pumpWidget(
        _wrapWidget(
          const MetricCard(
            icon: Icons.timer_outlined,
            value: '34h',
            label: 'Horas Totales',
          ),
        ),
      );

      expect(find.text('34h'), findsOneWidget);
      expect(find.text('HORAS TOTALES'), findsOneWidget);
      expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
    });

    testWidgets('AppGlassCard invokes onTap when configured', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrapWidget(
          AppGlassCard(
            onTap: () => tapped = true,
            child: const Text('Tarjeta Glass'),
          ),
        ),
      );

      expect(find.text('Tarjeta Glass'), findsOneWidget);
      await tester.tap(find.text('Tarjeta Glass'));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
