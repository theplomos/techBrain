import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/features/roadmap/presentation/screens/home_screen.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/widgets/category_badge.dart';
import 'package:techbrain/shared/widgets/level_badge.dart';
import 'package:techbrain/shared/widgets/pill_button.dart';

Future<void> pumpHome(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    const MaterialApp(home: Scaffold(body: HomeScreen())),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('muestra las 4 variantes de PillButton', (tester) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.byType(PillButton), findsNWidgets(4));
  });

  testWidgets('muestra los 3 niveles y las 6 categorías', (tester) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.byType(LevelBadge), findsNWidgets(3));
    expect(
        find.byType(CategoryBadge), findsNWidgets(CourseCategory.values.length));
  });

  testWidgets('anuncia que el muestrario es temporal', (tester) async {
    await pumpHome(tester, const Size(1280, 2400));

    expect(find.text('Muestrario de componentes (temporal)'), findsOneWidget);
  });

  testWidgets('a 360 px no desborda', (tester) async {
    await pumpHome(tester, const Size(360, 640));

    expect(tester.takeException(), isNull);
  });

  testWidgets('a 1280 px no desborda', (tester) async {
    await pumpHome(tester, const Size(1280, 800));

    expect(tester.takeException(), isNull);
  });
}
