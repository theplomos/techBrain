import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_colors.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/domain/course_level.dart';
import 'package:techbrain/shared/mock/mock_models.dart';
import 'package:techbrain/shared/widgets/category_badge.dart';
import 'package:techbrain/shared/widgets/course_card.dart';
import 'package:techbrain/shared/widgets/glass_container.dart';
import 'package:techbrain/shared/widgets/level_badge.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

const MockCourse _testCourse = MockCourse(
  slug: 'react-de-cero',
  name: 'React: de cero a experto - Edición 2025',
  hours: 46.0,
  lessons: 452,
  instructor: 'Fernando Herrera',
  category: CourseCategory.frontend,
  level: CourseLevel.required,
  isCompleted: false,
);

const MockCourse _testCompletedCourse = MockCourse(
  slug: 'typescript-guia-completa',
  name: 'TypeScript: Guía Completa',
  hours: 8.5,
  lessons: 115,
  instructor: 'Fernando Herrera',
  category: CourseCategory.bases,
  level: CourseLevel.recommended,
  isCompleted: true,
);

void main() {
  group('CourseCard', () {
    testWidgets('muestra nombre, horas y lecciones del curso', (tester) async {
      await tester.pumpWidget(_host(const CourseCard(course: _testCourse)));

      expect(
        find.text('React: de cero a experto - Edición 2025'),
        findsOneWidget,
      );
      expect(find.text('46 h'), findsOneWidget);
      expect(find.text('452 lecciones'), findsOneWidget);

      expect(find.byIcon(Icons.schedule), findsOneWidget);
      expect(find.byIcon(Icons.play_lesson_outlined), findsOneWidget);
    });

    testWidgets('formatea correctamente horas decimales (8.5 h)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(const CourseCard(course: _testCompletedCourse)),
      );

      expect(find.text('8.5 h'), findsOneWidget);
      expect(find.text('115 lecciones'), findsOneWidget);
    });

    testWidgets('muestra CategoryBadge siempre', (tester) async {
      await tester.pumpWidget(_host(const CourseCard(course: _testCourse)));

      expect(find.byType(CategoryBadge), findsOneWidget);
    });

    testWidgets(
      'muestra LevelBadge por defecto y lo oculta con showLevel: false',
      (tester) async {
        // Por defecto showLevel es true
        await tester.pumpWidget(_host(const CourseCard(course: _testCourse)));
        expect(find.byType(LevelBadge), findsOneWidget);

        // Con showLevel: false
        await tester.pumpWidget(
          _host(const CourseCard(course: _testCourse, showLevel: false)),
        );
        expect(find.byType(LevelBadge), findsNothing);
      },
    );

    testWidgets(
      'muestra icono de completado y semántica solo si isCompleted es true',
      (tester) async {
        // Curso no completado
        await tester.pumpWidget(_host(const CourseCard(course: _testCourse)));
        expect(find.byIcon(Icons.check_circle), findsNothing);
        expect(find.bySemanticsLabel('Completado'), findsNothing);

        // Curso completado
        await tester.pumpWidget(
          _host(const CourseCard(course: _testCompletedCourse)),
        );
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
        expect(find.bySemanticsLabel('Completado'), findsOneWidget);

        final Icon icon = tester.widget<Icon>(find.byIcon(Icons.check_circle));
        expect(icon.color, equals(AppColors.accentVivid));
        expect(icon.size, equals(20.0));
      },
    );

    testWidgets(
      'se monta dentro de GlassContainer con 16 px de padding sin onTap',
      (tester) async {
        await tester.pumpWidget(_host(const CourseCard(course: _testCourse)));

        final GlassContainer glass = tester.widget<GlassContainer>(
          find.byType(GlassContainer),
        );
        expect(glass.padding, equals(const EdgeInsets.all(16.0)));
        expect(glass.onTap, isNull);
      },
    );
  });
}
