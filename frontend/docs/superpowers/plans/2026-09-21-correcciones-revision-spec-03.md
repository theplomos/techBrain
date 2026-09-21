# Correcciones de la revisión de la SPEC 03: plan de implementación

> **Para agentes:** SUB-SKILL OBLIGATORIA: usa superpowers:subagent-driven-development (recomendada) o superpowers:executing-plans para ejecutar este plan tarea a tarea. Los pasos usan casillas (`- [ ]`) para el seguimiento.

**Objetivo:** Corregir los 3 hallazgos de la revisión de código de la SPEC 03: las métricas de Home cuentan cursos repetidos, Configuración usa `Icons.forum` en vez de `Icons.discord` y `_getInitials` falla con nombres vacíos.

**Arquitectura:** Tres correcciones independientes y pequeñas. La deduplicación de cursos completados pasa a una función pura en `mock_models.dart`, que se prueba con tests unitarios. Las iniciales se extraen a `lib/shared/utils/initials.dart`, también como función pura con test unitario. El icono de Discord se cambia en la pantalla y se cubre con un test de widget.

**Tech Stack:** Flutter 3 (Dart 3), `flutter_test`, `go_router`. Sin dependencias nuevas.

**Spec:** `frontend/specs/03-estructura-grafica.md` (secciones «Home», punto 3, y «Configuración»).

## Restricciones globales

- Solo se toca `frontend/`. Nada de `backend/`, `env/` ni `docker-compose.yml`.
- Todos los comandos se ejecutan desde `frontend/`.
- Cada tarea termina con `flutter analyze` sin avisos, `dart format .` aplicado y `flutter test` en verde, y se commitea por separado.
- Mensajes de commit en español, con el formato `tipo(frontend): descripción`. **Sin trailers `Co-Authored-By` ni ninguna mención a Claude o a la IA.**
- Se trabaja en la rama actual, `spec-03-estructura-grafica`. No hay que crear otra.
- `slug` distingue mayúsculas y no se normaliza: la deduplicación compara slugs tal cual.
- Métrica «Horas totales»: formateada **sin decimales** (SPEC 03, Home §3). Se redondea con `round()`, no se trunca con `toInt()`.
- Icono de Discord: `Icons.discord` en color `AppColors.brandDiscord` (SPEC 03, Configuración). `Icons.forum` solo si `Icons.discord` no existiera, y en el SDK del proyecto sí existe.

---

## Mapa de archivos

| Archivo | Acción | Responsabilidad |
|---|---|---|
| `lib/shared/mock/mock_models.dart` | Modificar | + `uniqueCompletedCourses(Iterable<MockRoute>)` |
| `lib/features/roadmap/presentation/screens/home_screen.dart` | Modificar | Usa la función nueva y redondea las horas |
| `test/shared/mock/mock_models_test.dart` | Crear | Tests unitarios de la deduplicación |
| `test/features/home_screen_test.dart` | Modificar | Test de los valores de las métricas |
| `lib/shared/utils/initials.dart` | Crear | `initialsOf(String name)` |
| `test/shared/utils/initials_test.dart` | Crear | Tests unitarios de las iniciales |
| `lib/features/settings/presentation/screens/settings_screen.dart` | Modificar | Usa `initialsOf` y `Icons.discord` |
| `test/features/settings/settings_screen_test.dart` | Modificar | Test del icono de Discord |
| `specs/03-estructura-grafica.md` | Modificar | Aclara que las métricas cuentan cursos distintos |

---

### Tarea 1: métricas de Home sin cursos repetidos

**Problema:** `home_screen.dart:33-40` hace `MockData.routes.expand((r) => r.courses).where((c) => c.isCompleted)`. `typescript-guia-completa` está completado en 2 rutas y `git-github-control-versiones-desde-cero` en 3, así que Home muestra 7 cursos y 107 h. El usuario ha terminado 4 cursos distintos: TypeScript (8.5 h), React (46 h), Git (11.5 h) y Dart (10 h), que suman **76 h**.

**Archivos:**
- Modificar: `lib/shared/mock/mock_models.dart` (añadir al final)
- Modificar: `lib/features/roadmap/presentation/screens/home_screen.dart:33-40` y `:89` (`value: '${totalHours.toInt()}'`)
- Crear: `test/shared/mock/mock_models_test.dart`
- Modificar: `test/features/home_screen_test.dart` (tras el test `'muestra la sección de métricas con 3 MetricCard'`)
- Modificar: `specs/03-estructura-grafica.md` (Home, punto 3)

**Interfaces:**
- Produce: `List<MockCourse> uniqueCompletedCourses(Iterable<MockRoute> routes)`, una función de nivel superior en `mock_models.dart`. Devuelve los cursos con `isCompleted`, sin slugs repetidos, conservando la primera aparición y el orden de las rutas.

- [ ] **Paso 1: escribir el test unitario que falla**

Crear `test/shared/mock/mock_models_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/domain/course_level.dart';
import 'package:techbrain/shared/mock/mock_data.dart';
import 'package:techbrain/shared/mock/mock_models.dart';

MockCourse _course(String slug, double hours, {bool completed = true}) =>
    MockCourse(
      slug: slug,
      name: slug,
      hours: hours,
      lessons: 1,
      instructor: 'Fernando Herrera',
      category: CourseCategory.bases,
      level: CourseLevel.required,
      isCompleted: completed,
    );

MockRoute _route(String id, List<MockCourse> courses) =>
    MockRoute(id: id, title: id, description: id, courses: courses);

void main() {
  group('uniqueCompletedCourses', () {
    test('cuenta una sola vez un curso completado en varias rutas', () {
      final List<MockCourse> result = uniqueCompletedCourses(<MockRoute>[
        _route('a', <MockCourse>[_course('git', 11.5), _course('ts', 8.5)]),
        _route('b', <MockCourse>[_course('git', 11.5)]),
      ]);

      expect(result.map((c) => c.slug), <String>['git', 'ts']);
    });

    test('ignora los cursos no completados', () {
      final List<MockCourse> result = uniqueCompletedCourses(<MockRoute>[
        _route('a', <MockCourse>[
          _course('git', 11.5),
          _course('nest', 24.5, completed: false),
        ]),
      ]);

      expect(result.map((c) => c.slug), <String>['git']);
    });

    test('distingue slugs que solo difieren en mayúsculas', () {
      final List<MockCourse> result = uniqueCompletedCourses(<MockRoute>[
        _route('a', <MockCourse>[
          _course('flutter-intermedio', 1),
          _course('flutter-Intermedio', 1),
        ]),
      ]);

      expect(result, hasLength(2));
    });

    test('devuelve una lista vacía si no hay rutas', () {
      expect(uniqueCompletedCourses(const <MockRoute>[]), isEmpty);
    });

    test('con MockData hay 4 cursos completados distintos que suman 76 h', () {
      final List<MockCourse> result = uniqueCompletedCourses(MockData.routes);

      expect(result, hasLength(4));
      expect(
        result.fold<double>(0.0, (double acc, MockCourse c) => acc + c.hours),
        76.0,
      );
    });
  });
}
```

- [ ] **Paso 2: comprobar que falla**

Ejecutar: `flutter test test/shared/mock/mock_models_test.dart`
Esperado: FALLA en compilación con `Method not found: 'uniqueCompletedCourses'`.

- [ ] **Paso 3: implementar la función**

Añadir al final de `lib/shared/mock/mock_models.dart`:

```dart
/// Cursos completados en [routes], sin repetir slug.
///
/// Un mismo curso puede estar en varias rutas: se cuenta una sola vez y se
/// conserva su primera aparición. El slug se compara tal cual, sin normalizar.
List<MockCourse> uniqueCompletedCourses(Iterable<MockRoute> routes) {
  final Set<String> seen = <String>{};
  return <MockCourse>[
    for (final MockRoute route in routes)
      for (final MockCourse course in route.courses)
        if (course.isCompleted && seen.add(course.slug)) course,
  ];
}
```

- [ ] **Paso 4: comprobar que pasa**

Ejecutar: `flutter test test/shared/mock/mock_models_test.dart`
Esperado: PASA (5 tests).

- [ ] **Paso 5: escribir el test de widget que falla**

En `test/features/home_screen_test.dart`, justo después del test `'muestra la sección de métricas con 3 MetricCard'`, añadir:

```dart
  testWidgets('las métricas cuentan cada curso completado una sola vez', (
    tester,
  ) async {
    await pumpHome(tester, const Size(1280, 2400));

    Finder metricValue(String value) => find.descendant(
      of: find.byType(MetricCard),
      matching: find.text(value),
    );

    expect(metricValue('76'), findsOneWidget); // Horas totales.
    expect(metricValue('4'), findsOneWidget); // Cursos completados.
    expect(metricValue('3'), findsOneWidget); // Rutas guardadas.
  });
```

- [ ] **Paso 6: comprobar que falla**

Ejecutar: `flutter test test/features/home_screen_test.dart --plain-name "una sola vez"`
Esperado: FALLA. `metricValue('76')` encuentra 0 widgets, porque hoy se muestra `107`.

- [ ] **Paso 7: usar la función en Home y redondear**

En `lib/features/roadmap/presentation/screens/home_screen.dart`, sustituir el cálculo de las líneas 33-40:

```dart
    final int completedCourses = MockData.routes
        .expand((r) => r.courses)
        .where((c) => c.isCompleted)
        .length;
    final double totalHours = MockData.routes
        .expand((r) => r.courses)
        .where((c) => c.isCompleted)
        .fold<double>(0.0, (acc, c) => acc + c.hours);
```

por:

```dart
    final List<MockCourse> completed = uniqueCompletedCourses(MockData.routes);
    final int completedCourses = completed.length;
    final double totalHours = completed.fold<double>(
      0.0,
      (double acc, MockCourse c) => acc + c.hours,
    );
```

Y en la `MetricCard` de horas, sustituir `value: '${totalHours.toInt()}',` por:

```dart
                      value: '${totalHours.round()}',
```

`mock_models.dart` ya está importado en `home_screen.dart`, así que no hace falta añadir imports.

- [ ] **Paso 8: comprobar que pasa**

Ejecutar: `flutter test test/features/home_screen_test.dart`
Esperado: PASAN todos, incluidos los de padding de la SPEC 02.

- [ ] **Paso 9: aclarar la spec**

En `specs/03-estructura-grafica.md`, sección «Home», punto 3, sustituir las dos primeras viñetas:

```markdown
   - Horas totales: suma de horas de los cursos completados de las 3 rutas, formateada sin decimales.
   - Cursos completados: número de cursos completados en las 3 rutas.
```

por:

```markdown
   - Horas totales: suma de horas de los cursos completados distintos (por slug) de las 3 rutas, redondeada sin decimales.
   - Cursos completados: número de cursos completados distintos (por slug) en las 3 rutas. Un curso que está en varias rutas cuenta una vez.
```

- [ ] **Paso 10: verificar y commitear**

```bash
dart format .
flutter analyze
flutter test
git add lib/shared/mock/mock_models.dart lib/features/roadmap/presentation/screens/home_screen.dart test/shared/mock/mock_models_test.dart test/features/home_screen_test.dart specs/03-estructura-grafica.md
git commit -m "fix(frontend): contar una sola vez los cursos completados en las métricas de Home"
```

---

### Tarea 2: iniciales robustas para el avatar

**Problema:** en `settings_screen.dart:30-35`, `''.split(RegExp(r'\s+'))` devuelve `['']`, así que la comprobación `parts.isEmpty` nunca se cumple y `parts[0].substring(0, 1)` lanza `RangeError` con un nombre vacío o de solo espacios. Además, `[0]` corta por unidades UTF-16 y rompe los nombres que empiezan por emoji, algo habitual en los nombres de Discord que llegan en la Etapa 2.

**Archivos:**
- Crear: `lib/shared/utils/initials.dart`
- Crear: `test/shared/utils/initials_test.dart`
- Modificar: `lib/features/settings/presentation/screens/settings_screen.dart:30-35` (quitar `_getInitials`) y la llamada `_getInitials(user.name)`

**Interfaces:**
- Produce: `String initialsOf(String name)`. Devuelve `''` si `name` está vacío o solo tiene espacios, la primera letra en mayúscula si hay una palabra, y la primera letra de la primera y de la última palabra en mayúsculas si hay varias. Trabaja por grafemas (`characters`).

- [ ] **Paso 1: escribir el test que falla**

Crear `test/shared/utils/initials_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/utils/initials.dart';

void main() {
  group('initialsOf', () {
    test('nombre y apellido', () {
      expect(initialsOf('Alex Rivera'), 'AR');
    });

    test('usa la primera y la última palabra', () {
      expect(initialsOf('ana maría de la cruz'), 'AC');
    });

    test('una sola palabra', () {
      expect(initialsOf('fernando'), 'F');
    });

    test('ignora espacios al principio, al final y repetidos', () {
      expect(initialsOf('  Alex   Rivera  '), 'AR');
    });

    test('nombre vacío devuelve cadena vacía', () {
      expect(initialsOf(''), '');
    });

    test('nombre de solo espacios devuelve cadena vacía', () {
      expect(initialsOf('   '), '');
    });

    test('no parte un emoji por la mitad', () {
      expect(initialsOf('🚀 Dev'), '🚀D');
    });
  });
}
```

- [ ] **Paso 2: comprobar que falla**

Ejecutar: `flutter test test/shared/utils/initials_test.dart`
Esperado: FALLA en compilación porque no existe `package:techbrain/shared/utils/initials.dart`.

- [ ] **Paso 3: implementar la función**

Crear `lib/shared/utils/initials.dart`:

```dart
import 'package:flutter/widgets.dart';

/// Iniciales de [name] para un avatar: la primera letra de la primera y de la
/// última palabra, en mayúsculas.
///
/// Devuelve una cadena vacía si [name] no tiene ninguna palabra. Trabaja por
/// grafemas para no partir emojis ni letras compuestas.
String initialsOf(String name) {
  final List<String> words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((String word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty) return '';

  String firstOf(String word) => word.characters.first.toUpperCase();

  if (words.length == 1) return firstOf(words.first);
  return '${firstOf(words.first)}${firstOf(words.last)}';
}
```

`package:flutter/widgets.dart` reexporta `package:characters`, así que no hace falta añadir dependencias.

- [ ] **Paso 4: comprobar que pasa**

Ejecutar: `flutter test test/shared/utils/initials_test.dart`
Esperado: PASA (7 tests).

- [ ] **Paso 5: usarla en Configuración**

En `lib/features/settings/presentation/screens/settings_screen.dart`:

1. Borrar el método `_getInitials` entero (líneas 30-35).
2. Añadir el import junto a los demás de `shared/`:

```dart
import '../../../../shared/utils/initials.dart';
```

3. Sustituir `_getInitials(user.name),` por:

```dart
                          initialsOf(user.name),
```

- [ ] **Paso 6: comprobar que Configuración sigue en verde**

Ejecutar: `flutter test test/features/settings/settings_screen_test.dart`
Esperado: PASA. El test `'muestra tarjeta de perfil con iniciales AR…'` sigue encontrando `AR`.

- [ ] **Paso 7: verificar y commitear**

```bash
dart format .
flutter analyze
flutter test
git add lib/shared/utils/initials.dart test/shared/utils/initials_test.dart lib/features/settings/presentation/screens/settings_screen.dart
git commit -m "fix(frontend): calcular las iniciales del avatar sin fallar con nombres vacíos"
```

---

### Tarea 3: icono de Discord en Configuración

**Problema:** `settings_screen.dart` usa `Icons.forum`, pero la SPEC 03 pide `Icons.discord` y el SDK del proyecto lo define. `Icons.forum` era solo la alternativa para cuando no existiera.

**Archivos:**
- Modificar: `lib/features/settings/presentation/screens/settings_screen.dart` (el `Icon` dentro de `discordInfo`)
- Modificar: `test/features/settings/settings_screen_test.dart` (añadir un test dentro del `group('SettingsScreen', …)`)

**Interfaces:** ninguna nueva.

- [ ] **Paso 1: escribir el test que falla**

En `test/features/settings/settings_screen_test.dart`, añadir el import:

```dart
import 'package:techbrain/config/theme/app_colors.dart';
```

y, dentro de `group('SettingsScreen', () { … })`, este test:

```dart
    testWidgets('muestra el icono de Discord en su color de marca', (
      tester,
    ) async {
      await pumpScreenAt(tester, const SettingsScreen(), const Size(1280, 800));

      final Finder discordIcon = find.byIcon(Icons.discord);
      expect(discordIcon, findsOneWidget);
      expect(find.byIcon(Icons.forum), findsNothing);
      expect(tester.widget<Icon>(discordIcon).color, AppColors.brandDiscord);
      expect(find.text('Conectado con Discord'), findsOneWidget);
    });
```

- [ ] **Paso 2: comprobar que falla**

Ejecutar: `flutter test test/features/settings/settings_screen_test.dart --plain-name "icono de Discord"`
Esperado: FALLA con `Expected: exactly one matching candidate / Actual: … Found 0 widgets`.

- [ ] **Paso 3: cambiar el icono**

En `lib/features/settings/presentation/screens/settings_screen.dart`, dentro de `discordInfo`, sustituir:

```dart
                              const Icon(
                                Icons.forum,
```

por:

```dart
                              const Icon(
                                Icons.discord,
```

- [ ] **Paso 4: comprobar que pasa**

Ejecutar: `flutter test test/features/settings/settings_screen_test.dart`
Esperado: PASAN todos, incluido el de overflow a 375 y 1280 px.

- [ ] **Paso 5: verificar y commitear**

```bash
dart format .
flutter analyze
flutter test
git add lib/features/settings/presentation/screens/settings_screen.dart test/features/settings/settings_screen_test.dart
git commit -m "fix(frontend): usar Icons.discord en la tarjeta de cuenta de Configuración"
```

---

## Verificación final

- [ ] `flutter analyze` termina con `No issues found!`.
- [ ] `flutter test` pasa entero: 172 tests previos más 13 nuevos (5 + 1 + 7) más 1 de Configuración, 186 en total.
- [ ] `dart format --output=none --set-exit-if-changed .` termina con código 0, que es lo que comprueba la CI.
- [ ] `git log --oneline -3` muestra los 3 commits `fix(frontend): …`, sin trailers de coautoría.
- [ ] Revisión manual con `flutter run -d chrome --web-port 8080`: Home muestra 76 / 4 / 3 en las métricas y Configuración muestra el logo de Discord.
