# SPEC 03 — Estructura gráfica de la app

> **Estado:** approved
> **Depende de:** SPEC 01, SPEC 02
> **Fecha:** 2026-09-21
> **Objetivo:** Sustituir las pantallas provisionales por la maqueta navegable de Home, Explorar, Cuestionarios, Configuración y el detalle de ruta, alimentada con datos mock, sin lógica de negocio.

## Por qué existe esta spec

Las SPEC 01 y 02 dejaron el shell de 4 pestañas con pantallas "Disponible en la Etapa N". Antes de construir autenticación, catálogo, rutas, configuración y cuestionario, queremos la base gráfica completa: ver cada pantalla con su contenido definitivo y moverse entre ellas.

La referencia es **solo visual**: el demo de la rama `01-frontend`, recuperable con `git show 86b7aa1^:frontend/lib/features/<feature>/presentation/<vista>.dart`. De ese demo se toma la composición de cada pantalla. No se toman sus modelos, su `MockData` ni su `responsive_shell.dart`: la arquitectura es la de la SPEC 01.

Cada etapa posterior (2 a 6) reemplaza los datos mock de su pantalla por datos reales sin rehacer la UI. Por eso todo el contenido sale de `lib/shared/mock/` y ninguna pantalla escribe textos de cursos o rutas a mano.

## Precondiciones

1. `feature/fundaciones` tiene el árbol limpio y `flutter analyze` y `flutter test` pasan.
2. Se crea la rama `feature/estructura-grafica` desde `feature/fundaciones`, porque esta aún no está fusionada en `develop`. Cuando se fusione `feature/fundaciones`, el PR de esta rama apunta a `develop`.
3. `/spec-impl` ofrecerá crear `spec-03-estructura-grafica`: se responde que no y se trabaja en `feature/estructura-grafica`.

## Alcance

**Dentro:**

- Datos mock tipados en `lib/shared/mock/`: un usuario, 12 cursos, 3 rutas y 3 preguntas del cuestionario.
- 4 widgets compartidos nuevos: `SectionHeader`, `MetricCard`, `ProgressBar` y `CourseCard`.
- Ruta `/routes/:id` a pantalla completa, fuera del shell, con `RouteDetailScreen`.
- Home: saludo, ruta activa, métricas y rutas guardadas. El muestrario de componentes se conserva al final.
- Explorar: buscador, chips de categoría, contador, rejilla de `CourseCard` y estado vacío.
- Cuestionarios: 3 preguntas de opción única con pasos, y "Generar mi ruta" abre el detalle de una ruta mock.
- Configuración: perfil, ritmo de estudio con slider local, estado de Discord, "Cerrar sesión" deshabilitado e información del evento.
- Detalle de ruta: 3 columnas por nivel a partir de 1024 px y lista con filtro por nivel por debajo.
- Interacción con estado local (`setState`) únicamente: filtros, pasos del cuestionario, slider y botón "Guardar".
- Test de widget de cada pantalla a 375 × 812 px y 1280 × 800 px, y tests de los flujos de navegación.

**Fuera de alcance (para futuras specs):**

- Pantalla de login y registro, ruta `/login` y guard de sesión. Etapa 2.
- Cuestionario conversacional DevBot. Etapa 6.
- Detalle de curso con capítulos y lecciones. Etapa 3.
- Lectura del dataset real, modelos de dominio `Course` y `OfficialRoute`, y deduplicación de slugs. Etapa 3.
- Persistencia de cualquier tipo: nada sobrevive a una recarga. Etapa 4.
- Marcar el progreso de un curso. Etapa 4.
- Cálculo de fechas estimadas con las horas semanales. Etapas 4 y 5.
- Providers de Riverpod para los datos mock.
- Avatar y menú de usuario en la barra superior.
- Imágenes de red: el avatar se dibuja con iniciales.
- Eliminar el muestrario de componentes. Sigue previsto para la Etapa 4.

## Archivos que aparecen o cambian

```text
lib/
├── config/router/
│   ├── app_routes.dart                  # + routeDetail y route(id)
│   └── app_router.dart                  # + GoRoute /routes/:id en el navigator raíz
├── shared/
│   ├── mock/
│   │   ├── mock_models.dart             # nuevo
│   │   └── mock_data.dart               # nuevo
│   └── widgets/
│       ├── section_header.dart          # nuevo
│       ├── metric_card.dart             # nuevo
│       ├── progress_bar.dart            # nuevo
│       └── course_card.dart             # nuevo
└── features/
    ├── roadmap/presentation/
    │   ├── screens/home_screen.dart     # se reescribe la parte superior
    │   ├── screens/route_detail_screen.dart   # nuevo
    │   └── widgets/
    │       ├── active_route_card.dart   # nuevo
    │       ├── saved_route_tile.dart    # nuevo
    │       └── level_column.dart        # nuevo
    ├── catalog/presentation/screens/explore_screen.dart
    ├── quiz/presentation/screens/quiz_screen.dart
    └── settings/presentation/screens/settings_screen.dart
test/
├── helpers/pump_at_size.dart            # nuevo
├── shared/mock/mock_data_test.dart      # nuevo
├── shared/widgets/                      # + section_header, metric_card, progress_bar, course_card
├── config/router/app_router_test.dart   # + casos de /routes/:id
└── features/                            # home (se ajusta), explore, quiz, settings, route_detail
```

`ComingSoonView` deja de usarse en las pantallas, pero se conserva con su test: las etapas pueden volver a necesitarlo.

## Modelo de datos

Los modelos mock son de presentación y temporales. Reutilizan `CourseLevel` y `CourseCategory` de la SPEC 01 y no se parecen a propósito a los modelos de dominio de la Etapa 3, para que nadie los confunda.

```dart
// lib/shared/mock/mock_models.dart
class MockCourse {
  const MockCourse({required this.slug, required this.name, required this.hours,
      required this.lessons, required this.instructor, required this.category,
      required this.level, this.isCompleted = false});
  final String slug;            // Slug real de cursos_devtalles.json.
  final String name;
  final double hours;
  final int lessons;
  final String instructor;
  final CourseCategory category;
  final CourseLevel level;      // Nivel dentro de la ruta mock.
  final bool isCompleted;
}

class MockRoute {
  const MockRoute({required this.id, required this.title,
      required this.description, required this.courses});
  final String id;              // kebab-case, usado en /routes/:id.
  final String title;
  final String description;
  final List<MockCourse> courses;   // Sin slugs repetidos.

  int get completedCount;       // Cursos con isCompleted.
  double get progress;          // completedCount / courses.length, 0 si está vacía.
  double get totalHours;        // Suma de hours.
}

class MockUser {
  const MockUser({required this.name, required this.discordTag,
      required this.weeklyHours, required this.streakDays});
  final String name;
  final String discordTag;
  final int weeklyHours;        // 1–40.
  final int streakDays;
}

class MockQuizQuestion {
  const MockQuizQuestion({required this.prompt, required this.options});
  final String prompt;
  final List<String> options;   // 3 o 4 opciones.
}
```

```dart
// lib/shared/mock/mock_data.dart
/// Datos de ejemplo de la maqueta. Temporal: cada etapa los sustituye.
abstract final class MockData {
  static const MockUser user;                     // name 'Alex Rivera', weeklyHours 10, streakDays 5.
  static const List<MockCourse> catalog;          // 12 cursos, las 6 categorías presentes.
  static const List<MockRoute> routes;            // 3 rutas: 'frontend-react', 'backend-nest', 'movil-flutter'.
  static const String activeRouteId = 'frontend-react';
  static const String generatedRouteId = 'frontend-react';   // Destino de "Generar mi ruta".
  static const List<MockQuizQuestion> quizQuestions;         // Interés, nivel y horas por semana.

  /// Devuelve null si el id no existe.
  static MockRoute? routeById(String id);
}
```

Reglas del mock:

- Los slugs, nombres, horas y lecciones se copian de `docs/references/cursos_devtalles.json`. El slug se copia tal cual, sin normalizar.
- Cada ruta mock tiene cursos de los 3 niveles, entre 5 y 8 cursos, y al menos uno completado y uno pendiente.
- La ruta activa tiene progreso estrictamente entre 0 y 1.

### Navegación

```dart
// lib/config/router/app_routes.dart
static const String routeDetail = '/routes/:id';
static String route(String id) => '/routes/$id';
```

- La `GoRoute` de `routeDetail` cuelga de `routes` del `GoRouter`, al mismo nivel que el `StatefulShellRoute`, con `parentNavigatorKey: _rootNavigatorKey`. Se muestra sin barras de navegación.
- Se abre siempre con `context.push(AppRoutes.route(id))`, para que exista historial.
- Si `MockData.routeById(id)` devuelve null, la pantalla muestra `ErrorView(error: NotFoundFailure(), onRetry: () => context.go(AppRoutes.home), retryLabel: 'Ir a Home')`.

## Componentes y pantallas

### Widgets compartidos

**`SectionHeader(String title, {Widget? trailing})`**

- `title.toUpperCase()` en `AppTextStyles.columnHeader`, con `trailing` alineado a la derecha.
- 12 px de separación inferior.
- `Semantics(header: true)`.

**`MetricCard({required String value, required String label, IconData? icon})`**

- `GlassContainer` sin `onTap`, con padding de 20 px.
- `value` en Space Grotesk 700 a 28 px y color `textMain`, y `label` en `bodySmall` con color `textMuted`.
- `icon`, si existe, a 20 px en `accentLavender` encima de la cifra.

**`ProgressBar({required double value, bool showLabel = true})`**

- `value` se limita a 0–1.
- Pista de 8 px de alto con radio `AppRadii.pill` y color `rgba(192, 185, 252, 0.12)`.
- Relleno con degradado de `accentMid` a `accentElectric`.
- Con `showLabel`, muestra `NN %` a la derecha en `AppTextStyles.chip`.
- Etiqueta semántica: `Progreso: NN %`.

**`CourseCard({required MockCourse course, bool showLevel = true})`**

- `GlassContainer` sin `onTap`, con padding de 16 px.
- Fila superior con `CategoryBadge` y, si `showLevel`, `LevelBadge`.
- `name` en `titleMedium` con un máximo de 2 líneas y elipsis.
- Pie con `Icons.schedule` y `N h`, `Icons.play_lesson_outlined` y `N lecciones`, en `textMuted`.
- Si `isCompleted`, un `Icons.check_circle` en `accentVivid` en la esquina superior derecha, con etiqueta semántica `Completado`.

### Home

`HomeScreen` es un `ListView` que conserva el padding superior e inferior que fijó la SPEC 02. De arriba abajo:

1. Saludo `Hola, <user.name>` en `headlineMedium` y la línea `🔥 <streakDays> días de racha` en `textMuted`.
2. `ActiveRouteCard(route: MockData.routeById(MockData.activeRouteId)!)`:
   - `GlassContainer` con la etiqueta `RUTA ACTIVA`, el título, la descripción en 2 líneas y `ProgressBar(value: route.progress)`.
   - `PillButton` `primary` "Continuar ruta" que hace `context.push(AppRoutes.route(route.id))`.
   - Es `primary` y no `vivid` porque el muestrario ya contiene el `vivid` de la pantalla.
3. `SectionHeader('Mis métricas')` y 3 `MetricCard`:
   - Horas totales: suma de horas de los cursos completados de las 3 rutas, formateada sin decimales.
   - Cursos completados: número de cursos completados en las 3 rutas.
   - Rutas guardadas: `MockData.routes.length`.
   - En fila de 3 a partir de 600 px de ancho del contenido y en columna por debajo.
4. `SectionHeader('Mis rutas guardadas')` y un `SavedRouteTile` por ruta:
   - `GlassContainer` con `onTap` que abre el detalle y `semanticLabel` `Abrir ruta <title>`.
   - Contiene el título, `N cursos · N h` y `ProgressBar(value: progress)`.
5. El muestrario de componentes actual, sin cambios, con su título "Muestrario de componentes (temporal)".

`ComingSoonView` sale de Home.

### Explorar

`ExploreScreen` es un `StatefulWidget`:

- Título `Catálogo de cursos` en `headlineMedium` y el subtítulo `Explora los cursos oficiales de DevTalles.` en `textMuted`.
- `TextField` con `Icons.search` y el hint `Buscar por nombre o tecnología`. Filtra por `name` o `slug`, sin distinguir mayúsculas y quitando espacios al principio y al final.
- Fila desplazable horizontal de `ChoiceChip`: `Todos` más una por cada `CourseCategory`, con el texto de `datasetValue`. Solo hay una seleccionada.
- `SectionHeader('Cursos disponibles (N)')`, con N igual al número de resultados. Si hay texto o una categoría distinta de `Todos`, lleva como `trailing` un `TextButton` "Limpiar filtros" que restablece ambos.
- Rejilla de `CourseCard(showLevel: false)`: 1 columna por debajo de 600 px, 2 hasta 1024 px y 3 a partir de ahí, con 16 px de separación.
- Sin resultados: `GlassContainer` con `Icons.search_off`, `No se encontraron cursos` e `Intenta con otro término o limpia los filtros.`.
- El nivel no se muestra porque en el dataset depende de la ruta, no del curso.

### Cuestionarios

`QuizScreen` es un `StatefulWidget` que guarda en memoria el índice actual y una respuesta por pregunta:

- Etiqueta `EVALUACIÓN DIAGNÓSTICA`, el texto `Pregunta N de 3` y `ProgressBar(value: (N) / 3, showLabel: false)`.
- La pregunta en `titleLarge` y sus opciones como `GlassContainer` con `onTap`. La seleccionada lleva borde de 2 px en `accentLavender` y `Icons.radio_button_checked`; las demás, `Icons.radio_button_unchecked`. Cada opción tiene `Semantics(selected: …)`.
- Botones al pie:
  - `PillButton` `secondary` "Anterior", con `onPressed: null` en la primera pregunta.
  - `PillButton` "Siguiente", `primary`, con `onPressed: null` hasta que se elige una opción.
  - En la última pregunta, el botón de avance pasa a ser "Generar mi ruta", variante `vivid`, y hace `context.push(AppRoutes.route(MockData.generatedRouteId))`.
- Volver a la pestaña conserva el paso y las respuestas mientras la app siga abierta. Es el comportamiento que ya da `StatefulShellRoute.indexedStack`.

### Configuración

`SettingsScreen` es un `StatefulWidget`:

- Título `Configuración y perfil`.
- Tarjeta de perfil: círculo de 56 px con las iniciales de `user.name` sobre degradado `accentMid` → `accentElectric`, el nombre, `@<discordTag>` y un chip `Miembro de DevTalles`.
- `SectionHeader('Ritmo de estudio')` y un `GlassContainer` con:
  - `Horas semanales` y el valor actual `N h/semana`.
  - `Slider` de 1 a 40 con 39 divisiones, que empieza en `user.weeklyHours` y solo cambia el estado local.
  - El texto `Se usará para estimar la fecha de fin de tus rutas.` en `textMuted`.
- `SectionHeader('Cuenta')` y un `GlassContainer` con:
  - `Icons.discord` o, si no existe en la versión de Flutter, `Icons.forum`, en `brandDiscord`, y `Conectado con Discord`.
  - `PillButton` `secondary` "Cerrar sesión" con `onPressed: null`.
- `SectionHeader('Acerca de')` y un `GlassContainer` con `TechBrain · Equipo #13`, `DevTalles CodeQuest 2026 · Misión CQ03-2026` y `Licencia MIT`.

### Detalle de ruta

`RouteDetailScreen({required String routeId})` es un `StatefulWidget` dentro de su propio `Scaffold` transparente:

- Cabecera:
  - `IconButton` "Volver" con `Icons.arrow_back`, que hace `context.pop()` si `context.canPop()` y `context.go(AppRoutes.home)` si no.
  - Etiqueta `RUTA DE APRENDIZAJE`, el título en `headlineMedium` y la descripción.
  - `N cursos · N h · N completados` y `ProgressBar(value: progress)`.
  - `PillButton` `primary` "Guardar en mis rutas". Al pulsarlo pasa a "Guardada" con `onPressed: null`. Es solo estado local.
- Contenido, según el ancho de la ventana:
  - **A partir de 1024 px:** una `Row` con 3 `LevelColumn`, una por `CourseLevel` en orden de declaración, con ancho máximo de contenido `Breakpoints.maxContentWidth`.
  - `LevelColumn(level, courses)` muestra `LevelBadge(level)`, la descripción del nivel y sus `CourseCard(showLevel: false)`. Si no hay cursos, el texto `Sin cursos en este nivel.`.
  - **Por debajo de 1024 px:** una fila de `ChoiceChip` `Todos (N)`, `Requerido (N)`, `Recomendado (N)` y `Opcional (N)`, y debajo la lista filtrada de `CourseCard(showLevel: true)`, agrupada en orden de nivel.
- Descripciones de nivel: `Fundamentos y prerrequisitos obligatorios.`, `Especialización y frameworks más demandados.` y `Herramientas complementarias.`.
- Padding horizontal de 16 px por debajo de 1024 px y de 32 px a partir de ahí. Padding superior con el área segura.

### Test helper

`test/helpers/pump_at_size.dart` expone `pumpScreenAt(tester, Widget screen, Size size)` y `pumpAppAt(tester, Size size, {String? initialLocation})`. Mueve ahí el `pumpAppAt` de `home_screen_test.dart`. `initialLocation` permite abrir `/routes/<id>` directamente llamando a `router.go` tras montar la app.

## Implementación

1. Crear `feature/estructura-grafica` desde `feature/fundaciones`.
2. Añadir `mock_models.dart` y `mock_data.dart`, con `mock_data_test.dart`: 12 cursos, las 6 categorías, 3 rutas, slugs sin repetir por ruta, los 3 niveles en cada ruta, progreso de la ruta activa entre 0 y 1, y `routeById('no-existe')` null.
3. Añadir `SectionHeader`, `MetricCard` y `ProgressBar` con sus tests: texto en mayúsculas, `value` fuera de rango limitado y etiqueta semántica.
4. Añadir `CourseCard` con su test: muestra nombre, horas y lecciones, oculta el `LevelBadge` con `showLevel: false` y muestra `Completado` solo si procede.
5. Añadir `test/helpers/pump_at_size.dart` y migrar `home_screen_test.dart` a él sin cambiar sus casos.
6. Añadir `AppRoutes.routeDetail`, `AppRoutes.route(id)` y la `GoRoute` con un `RouteDetailScreen` que de momento solo muestra la cabecera. Tests: `/routes/frontend-react` muestra el título sin barras de navegación y `/routes/no-existe` muestra `ErrorView`.
7. Completar `RouteDetailScreen` con `LevelColumn`, el filtro por nivel y el botón "Guardar". Tests a 1280 px (3 columnas) y a 375 px (chips y filtrado).
8. Reescribir la parte superior de Home con `ActiveRouteCard`, las métricas y `SavedRouteTile`, y quitar `ComingSoonView`. Ajustar los tests de Home: `PillButton` pasa de 4 a 5, `ComingSoonView` ya no aparece, y se añaden "Continuar ruta" → detalle y un `SavedRouteTile` → detalle. Los tests de padding de la SPEC 02 se mantienen.
9. Implementar Explorar con su test: la búsqueda filtra, el chip filtra, "Limpiar filtros" restablece, el contador cambia y aparece el estado vacío.
10. Implementar Cuestionarios con su test: "Siguiente" deshabilitado sin respuesta, "Anterior" deshabilitado en la primera pregunta, avance y retroceso conservan la respuesta, y "Generar mi ruta" abre el detalle.
11. Implementar Configuración con su test: iniciales, el slider cambia `N h/semana` y "Cerrar sesión" está deshabilitado.
12. Cambiar el estado de esta spec a `Implementado` y añadir a la SPEC 01 una nota de estado que diga que las pantallas provisionales las sustituye esta spec.

Cada paso termina con `flutter analyze` sin avisos, `dart format` aplicado y `flutter test` en verde, y se commitea por separado.

## Criterios de aceptación

- [ ] `flutter analyze` termina sin avisos y `flutter test` pasa entero.
- [ ] La CI de `.github/workflows/ci.yml` pasa en el PR de `feature/estructura-grafica`.
- [ ] Home, Explorar, Cuestionarios, Configuración y `/routes/frontend-react` se renderizan a 375 × 812 px y a 1280 × 800 px sin excepciones de overflow en los tests.
- [ ] Ninguna pantalla contiene nombres de cursos o rutas escritos a mano: todos salen de `MockData`.
- [ ] Todos los slugs de `MockData` existen en `docs/references/cursos_devtalles.json`.
- [ ] En Home, "Continuar ruta" abre `/routes/frontend-react` sin barras de navegación, y "Volver" regresa a Home con la barra.
- [ ] En Home, pulsar una ruta guardada abre su detalle.
- [ ] El muestrario de componentes sigue visible al final de Home.
- [ ] En Explorar, escribir `flutter` reduce la rejilla a los cursos cuyo nombre o slug lo contiene, y el contador coincide.
- [ ] En Explorar, elegir el chip `MÓVIL` muestra solo cursos de esa categoría, y "Limpiar filtros" vuelve a los 12.
- [ ] En Explorar, una búsqueda sin coincidencias muestra `No se encontraron cursos`.
- [ ] En Cuestionarios, "Siguiente" está deshabilitado hasta elegir opción, y en la pregunta 3 el botón dice "Generar mi ruta" y abre el detalle.
- [ ] En Configuración, mover el slider cambia el texto `N h/semana`, y "Cerrar sesión" no responde.
- [ ] A 1280 px el detalle muestra 3 columnas encabezadas por `LevelBadge`. A 375 px muestra los chips de nivel, y elegir `Requerido` deja solo cursos de ese nivel.
- [ ] Abrir `/routes/no-existe` muestra `ErrorView` con "Ir a Home".
- [ ] Recargar el navegador en `/routes/frontend-react` abre el detalle directamente.
- [ ] Nada de lo que se cambia en la maqueta (filtros, respuestas, slider, "Guardar") sobrevive a una recarga.

## Decisiones

- **Sí:** 4 pestañas más el detalle de ruta. Es lo que tenía el demo y cubre los 4 requisitos visibles del brief salvo el login.
- **No:** login, DevBot y detalle de curso en esta spec. Cada uno tiene su etapa y su lógica propia.
- **Sí:** mock tipado en `lib/shared/mock/`. Cumple la regla de tratar catálogo y rutas como datos y deja un único punto que sustituir por etapa.
- **No:** leer ya el dataset real. Adelantaría los modelos, el parseo y la deduplicación de la Etapa 3.
- **No:** textos fijos en cada pantalla. Chocan con la regla anterior y habría que reescribir la UI en cada etapa.
- **Sí:** clases `Mock*` separadas de los futuros modelos de dominio. El prefijo deja claro qué hay que borrar.
- **No:** providers de Riverpod para el mock. Los datos son `const` y no cambian; los providers llegan con los repositorios reales.
- **Sí:** interacción con `setState` y nada persistido. Basta para enseñar el flujo y no genera código que luego haya que migrar.
- **No:** progreso marcable ni cuestionario que "genere" algo. Es lógica de las Etapas 4 y 6 que se reescribiría.
- **Sí:** detalle en `/routes/:id` a pantalla completa, fuera del shell. Da foco a la ruta, como el demo.
- **No:** detalle como subruta de Home (`/home/routes/:id`). Se descartó a favor de la pantalla completa.
- **Sí:** 3 columnas a partir de 1024 px y filtro por nivel por debajo. Reutiliza el corte de `Breakpoints.desktop`.
- **Sí:** conservar el muestrario en Home. La SPEC 01 fija su retirada en la Etapa 4.
- **Sí:** "Continuar ruta" en `primary`. El muestrario ya contiene el único `vivid` permitido en Home.
- **Sí:** `CourseCard` sin nivel en Explorar. En el dataset el nivel depende de la ruta, no del curso.
- **Sí:** avatar con iniciales. Evita imágenes de red en la web y en los tests.
- **Sí:** rama `feature/estructura-grafica` desde `feature/fundaciones`. No espera al PR de fundaciones y mantiene una rama por etapa.
- **Sí:** test de widget por pantalla en dos anchos y tests de navegación. Los desbordes y los enlaces rotos son los fallos más probables de una maqueta.

## Riesgos

| Riesgo | Mitigación |
|---|---|
| El mock se queda en producción porque "ya funciona" | Prefijo `Mock*`, carpeta `lib/shared/mock/` y comentario de temporalidad. Cada spec de etapa incluye retirar su parte. |
| `feature/fundaciones` cambia antes de fusionarse | Rebase de `feature/estructura-grafica` sobre ella antes de abrir el PR. |
| Los tests de Home de la SPEC 02 se rompen al reescribir la pantalla | El paso 8 los ajusta explícitamente y conserva los de padding. |
| `Icons.discord` no existe en la versión de Flutter del proyecto | Se usa `Icons.forum` en su lugar, como prevé la sección de Configuración. |
| El slider o las 3 columnas desbordan a 1024 px exactos | Los tests de layout cubren 375 y 1280 px. Se prueba a mano también a 1024 px. |

## Lo que **no** entra en esta spec

- Login, registro y guard de sesión.
- DevBot.
- Detalle de curso.
- Dataset real y modelos de dominio.
- Persistencia y progreso marcable.
- Fechas estimadas.
- Retirar el muestrario de Home.

Cada uno llega en su etapa, con su propia spec.
