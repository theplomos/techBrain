import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/domain/course_level.dart';
import 'package:techbrain/shared/domain/dataset_assets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('copia del dataset', () {
    test('assets/data/ está al día con docs/references/', () {
      for (final String name in <String>[
        'cursos_devtalles.json',
        'rutas_aprendizaje_devtalles.json',
      ]) {
        final File source = File('../docs/references/$name');
        final File copy = File('assets/data/$name');

        expect(source.existsSync(), isTrue,
            reason: 'Falta el original $name en docs/references/.');
        expect(copy.existsSync(), isTrue,
            reason: 'Falta la copia $name. Ejecuta tool/sync_datasets.sh.');
        expect(copy.readAsBytesSync(), source.readAsBytesSync(),
            reason: '$name cambió en docs/references/. '
                'Ejecuta tool/sync_datasets.sh y commitea la copia.');
      }
    });
  });

  group('valores reales del dataset', () {
    test('el catálogo tiene 91 cursos', () async {
      final String raw = await rootBundle.loadString(DatasetAssets.courses);
      final List<dynamic> courses = jsonDecode(raw) as List<dynamic>;

      expect(courses, hasLength(91));
    });

    test('hay 13 rutas oficiales con 113 entradas de curso', () async {
      final String raw = await rootBundle.loadString(DatasetAssets.routes);
      final List<dynamic> routes = jsonDecode(raw) as List<dynamic>;

      expect(routes, hasLength(13));
      final int entries = routes.fold<int>(
        0,
        (int total, dynamic route) =>
            total +
            ((route as Map<String, dynamic>)['cursos'] as List<dynamic>).length,
      );
      expect(entries, 113);
    });

    test('todos los nivel y categoria de las rutas se convierten sin error',
        () async {
      final String raw = await rootBundle.loadString(DatasetAssets.routes);
      final List<dynamic> routes = jsonDecode(raw) as List<dynamic>;

      for (final dynamic route in routes) {
        final Map<String, dynamic> map = route as Map<String, dynamic>;
        for (final dynamic course in map['cursos'] as List<dynamic>) {
          final Map<String, dynamic> item = course as Map<String, dynamic>;
          // Cualquier valor inesperado lanza LocalDataFailure y rompe el test.
          CourseLevel.fromDataset(item['nivel'] as String);
          CourseCategory.fromDataset(item['categoria'] as String);
        }
      }
    });
  });
}
