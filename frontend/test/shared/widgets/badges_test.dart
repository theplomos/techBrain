import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_colors.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/domain/course_level.dart';
import 'package:techbrain/shared/widgets/category_badge.dart';
import 'package:techbrain/shared/widgets/level_badge.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

BoxDecoration _decorationOf(WidgetTester tester, Type widgetType) {
  final Container container = tester.widget<Container>(
    find.descendant(
      of: find.byType(widgetType),
      matching: find.byType(Container),
    ),
  );
  return container.decoration! as BoxDecoration;
}

void main() {
  group('LevelBadge', () {
    testWidgets('escribe la etiqueta de cada nivel en mayúsculas', (
      tester,
    ) async {
      for (final (CourseLevel level, String text) in <(CourseLevel, String)>[
        (CourseLevel.required, 'REQUERIDO'),
        (CourseLevel.recommended, 'RECOMENDADO'),
        (CourseLevel.optional, 'OPCIONAL'),
      ]) {
        await tester.pumpWidget(_host(LevelBadge(level: level)));
        expect(find.text(text), findsOneWidget, reason: 'nivel $level');
      }
    });

    testWidgets('usa el icono de cada nivel', (tester) async {
      await tester.pumpWidget(
        _host(const LevelBadge(level: CourseLevel.required)),
      );
      expect(find.byIcon(Icons.hexagon), findsOneWidget);

      await tester.pumpWidget(
        _host(const LevelBadge(level: CourseLevel.recommended)),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);

      await tester.pumpWidget(
        _host(const LevelBadge(level: CourseLevel.optional)),
      );
      expect(find.byIcon(Icons.circle), findsOneWidget);
    });

    testWidgets('se anuncia como "Nivel: <etiqueta>"', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(const LevelBadge(level: CourseLevel.required)),
      );

      expect(find.bySemanticsLabel('Nivel: Requerido'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('REQUERIDO usa los colores de su fila de la tabla de chips', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const LevelBadge(level: CourseLevel.required)),
      );

      final BoxDecoration decoration = _decorationOf(tester, LevelBadge);
      expect(decoration.color, AppColors.levelRequiredBg);
      expect(
        (decoration.border! as Border).top.color,
        AppColors.levelRequiredBorder,
      );
    });
  });

  group('CategoryBadge', () {
    testWidgets('escribe el valor del dataset de las seis categorías', (
      tester,
    ) async {
      for (final CourseCategory category in CourseCategory.values) {
        await tester.pumpWidget(_host(CategoryBadge(category: category)));
        expect(
          find.text(category.datasetValue),
          findsOneWidget,
          reason: 'categoría $category',
        );
      }
    });

    testWidgets('se anuncia como "Categoría: <valor>"', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(const CategoryBadge(category: CourseCategory.frontend)),
      );

      expect(find.bySemanticsLabel('Categoría: FRONTEND'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('FULLSTACK usa los tokens que el sistema llama WEB', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const CategoryBadge(category: CourseCategory.fullstack)),
      );

      final BoxDecoration decoration = _decorationOf(tester, CategoryBadge);
      expect(decoration.color, const Color.fromRGBO(244, 174, 163, 0.25));
      expect((decoration.border! as Border).top.color, const Color(0xFFF4AEA3));
    });
  });
}
