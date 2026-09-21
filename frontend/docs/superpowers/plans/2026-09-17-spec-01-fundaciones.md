# Plan de implementación — Etapa 1: Fundaciones del frontend Flutter

> **Para agentes ejecutores:** SUB-SKILL OBLIGATORIA: usa `superpowers:subagent-driven-development` (recomendada) o `superpowers:executing-plans` para implementar este plan tarea a tarea. Los pasos usan sintaxis de checkbox (`- [ ]`) para el seguimiento.

**Objetivo:** Sustituir el demo de `frontend/` por la base definitiva de TechBrain (tema DevTalles con tokens exactos, shell responsive de 4 pestañas, widgets base, dominio compartido, dataset como asset, CI y despliegue) sin ninguna funcionalidad de negocio.

**Arquitectura:** Paquete Flutter `techbrain` en `frontend/`, con `lib/config/` (entorno, tema, router), `lib/shared/` (dominio, errores, layout, widgets) y `lib/features/<feature>/presentation/screens/`. La navegación es `go_router` con `StatefulShellRoute.indexedStack` y un `appRouterProvider` generado por Riverpod. El estado global se monta con `ProviderScope`; esta etapa no define ningún otro provider.

**Stack:** Flutter 3.47.0 stable (Dart 3.13) · `flutter_riverpod` · `riverpod_annotation` + `riverpod_generator` + `build_runner` · `go_router` · `flutter_localizations` · `flutter_web_plugins` · `flutter_lints`.

**Spec:** [frontend/specs/01-fundaciones.md](frontend/specs/01-fundaciones.md)

**Requerimiento:** [docs/requerimiento_general_frontend.md](docs/requerimiento_general_frontend.md) · **Sistema de diseño:** [docs/references/imagen_corporativa_devtalles.md](docs/references/imagen_corporativa_devtalles.md)

---

## Reinterpretación de la spec

La spec 01 se escribió antes del demo y describe un proyecto Flutter en la raíz del repositorio. Hoy la app vive en `frontend/` y ya contiene el demo de la rama `01-frontend`. Este plan la reinterpreta así, y estas son las únicas desviaciones permitidas:

| Punto de la spec | Cómo se aplica aquí | Motivo |
|---|---|---|
| Rutas en la raíz (`lib/`, `web/`, `test/`) | Todas con prefijo `frontend/` | La app vive en `frontend/` |
| Paso 1: `flutter create` | Ya existe el proyecto. La Tarea 1 hace la **demolición** del demo en su lugar | El proyecto, los bundle IDs y las plataformas ya están creados y correctos |
| `docs/references/*.json` declarados con `../` | Se copian a `frontend/assets/data/` con `tool/sync_datasets.sh` y un test comprueba que la copia está al día | Decisión del usuario. Cierra la deuda del `CLAUDE.md` y funciona en iOS y Android |
| `web/vercel.json` nuevo | Ya existe en `frontend/web/vercel.json` y es correcto. Solo se verifica | Lo resolvió el demo |
| `.github/workflows/ci.yml` nuevo | Ya existe con `pub get`/`analyze`/`test`/`build web`. La Tarea 15 le **añade** formato, deriva de `.g.dart` y deriva del dataset | Lo resolvió el demo |
| Rama `feature/project-setup` desde `main`, PR a `main` | Rama `feature/fundaciones` desde `develop`, PR a `develop` | Gitflow ya adoptado: `main` y `develop` publicadas, `develop` es la rama por defecto |
| Dependencias añadidas paso a paso | `pubspec.yaml` ya declara todas las de la Etapa 1. La Tarea 1 solo **quita `dio`** | Evita churn; `dio` es de la Etapa 2 y un criterio de aceptación exige que no esté |
| `.env.example` en la raíz | `frontend/.env.example` | `--dart-define-from-file=.env` se ejecuta desde `frontend/` |

**Decisión de alcance del usuario (17 sep 2026):** sustitución limpia. Se borran `mock_data.dart`, `shared/models/`, `roadmap_detail_view.dart` y los widgets del demo que no están en la spec. El demo desplegado pierde el detalle de ruta y las métricas hasta las Etapas 3 y 4.

---

## Restricciones globales

Se aplican a **todas** las tareas. Cada tarea las hereda sin repetirlas.

- **Flutter 3.47.0 stable, Dart 3.13.** No se cambia de versión.
- **Todo el trabajo ocurre en `frontend/`**, más `.github/workflows/ci.yml` y el `README.md` de la raíz. **Nunca** se tocan `backend/`, `env/` ni `docker-compose.yml`.
- **Paquete `techbrain`.** Los imports entre archivos de `lib/` son **relativos** (el demo ya lo hace así); los tests importan `package:techbrain/…`.
- Bundle ID de iOS y `applicationId` de Android: `dev.arcentales.techbrain`. Ya están puestos: no se tocan.
- **Idioma:** textos de la interfaz, comentarios de código y mensajes de commit **en español**. Los identificadores del código, **en inglés**.
- **Nunca** se atribuye el trabajo a Claude ni a ninguna IA en commits, PR, tags ni comentarios. Sin trailers `Co-Authored-By`.
- **Solo tema oscuro** sobre `#171027`. No existe tema claro.
- **No se añade ningún paquete** fuera de los ya declarados en `pubspec.yaml`. Añadir uno requiere comprobar antes que la tecnología aparece en `docs/references/cursos_devtalles.json` (RNF-04).
- **Colores con transparencia:** siempre `Color.fromRGBO(r, g, b, opacidad)`, nunca hex con alfa. Los opacos, `Color(0xFFRRGGBB)`.
- **Accesibilidad (RNF-11):** todo control interactivo mide al menos 44 × 44 px, lleva `Semantics` con etiqueta y se activa con Enter y Espacio.
- **Antes de cada commit:** `flutter analyze` termina en `No issues found!` y `flutter test` pasa sin fallos. Si alguno falla, el commit no se hace.
- **Ancho mínimo soportado:** 360 px. Corte responsive: 1024 px.
- **Datos:** ningún dato del catálogo se escribe a mano en la UI (RNF-05).

### Comandos de referencia

Todos desde `frontend/`:

```bash
flutter pub get
flutter analyze
flutter test
flutter test test/shared/widgets/pill_button_test.dart
flutter test --plain-name "LevelBadge"
dart format lib test
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome --web-port 8080
flutter build web --release
```

---

## Estructura de archivos

Estado al terminar la Etapa 1. `[N]` indica la tarea que crea o modifica cada archivo.

```text
frontend/
├── pubspec.yaml                        [1,4,9]  deps, fuentes y assets
├── analysis_options.yaml               [1]      flutter_lints + exclusión de *.g.dart
├── .gitignore                          [1]      entradas de Flutter y .vercel
├── .env.example                        [2]      variables documentadas
├── tool/sync_datasets.sh               [9]      copia los JSON del dataset a assets/data/
├── assets/
│   ├── fonts/                          [4]      6 TTF + 2 licencias OFL
│   └── data/                           [9]      copia versionada de los 2 JSON
├── web/
│   ├── index.html                      [15]     lang, título, theme-color, fondo
│   ├── manifest.json                   [15]     nombre, colores, descripción
│   └── vercel.json                     [15]     rewrites de la SPA (ya existe)
├── lib/
│   ├── main.dart                       [1,11]   usePathUrlStrategy + ProviderScope
│   ├── app.dart                        [1,5,11] TechBrainApp
│   ├── config/
│   │   ├── env.dart                    [2]      Env + AuthSource
│   │   ├── theme/
│   │   │   ├── app_colors.dart         [3]      todos los Color const
│   │   │   ├── app_tokens.dart         [3]      AppRadii, AppShadows, AppMotion, AppBlur
│   │   │   ├── app_typography.dart     [4]      AppFonts, AppTextStyles, buildAppTextTheme()
│   │   │   └── app_theme.dart          [5]      AppTheme.dark
│   │   └── router/
│   │       ├── app_routes.dart         [11]     constantes de path
│   │       ├── app_router.dart         [11]     appRouter + StatefulShellRoute
│   │       └── app_router.g.dart       [11]     generado, se commitea
│   ├── shared/
│   │   ├── domain/
│   │   │   ├── course_level.dart       [9]      enum CourseLevel
│   │   │   ├── course_category.dart    [9]      enum CourseCategory
│   │   │   └── dataset_assets.dart     [9]      rutas de los JSON en el bundle
│   │   ├── errors/failure.dart         [8]      jerarquía sellada
│   │   ├── layout/
│   │   │   ├── breakpoints.dart        [12]     Breakpoints
│   │   │   ├── app_tabs.dart           [12]     appTabs
│   │   │   ├── app_bottom_nav_bar.dart [12]     barra flotante < 1024 px
│   │   │   ├── app_top_nav_bar.dart    [13]     barra superior >= 1024 px
│   │   │   └── app_shell.dart          [11,12,13] elige barra según ancho
│   │   └── widgets/
│   │       ├── cosmic_background.dart  [5]      fondo con 2 degradados radiales
│   │       ├── glass_container.dart    [6]      tarjeta glass reutilizable
│   │       ├── tech_brain_logo.dart    [6]      {tech/brain}
│   │       ├── pill_button.dart        [7]      3 variantes
│   │       ├── error_view.dart         [8]      vista de error
│   │       ├── level_badge.dart        [10]     chip de nivel
│   │       ├── category_badge.dart     [10]     chip de categoría
│   │       └── coming_soon_view.dart   [11]     placeholder de etapa
│   └── features/
│       ├── roadmap/presentation/screens/home_screen.dart      [11,14]
│       ├── catalog/presentation/screens/explore_screen.dart   [11]
│       ├── quiz/presentation/screens/quiz_screen.dart         [11]
│       └── settings/presentation/screens/settings_screen.dart [11]
└── test/                               replica la estructura de lib/
    ├── app_test.dart                                    [1,5,11]
    ├── config/
    │   ├── env_test.dart                                [2]
    │   ├── theme/
    │   │   ├── app_colors_test.dart                     [3]
    │   │   ├── app_typography_test.dart                 [4]
    │   │   └── app_theme_test.dart                      [5]
    │   └── router/app_router_test.dart                  [11]
    ├── features/home_screen_test.dart                   [14]
    └── shared/
        ├── domain/
        │   ├── course_enums_test.dart                   [9]
        │   └── dataset_values_test.dart                 [9]
        ├── errors/failure_test.dart                     [8]
        ├── layout/app_shell_test.dart                   [12,13]
        └── widgets/
            ├── glass_container_test.dart                [6]
            ├── tech_brain_logo_test.dart                [6]
            ├── pill_button_test.dart                    [7]
            ├── error_view_test.dart                     [8]
            └── badges_test.dart                         [10]
```

---

## Tarea 1: Demolición del demo y app mínima

Deja `frontend/lib` con solo `main.dart` y `app.dart`, un `MaterialApp` en español que muestra el texto `TechBrain`, y URLs sin `#`. Es un solo commit porque borrar el demo rompe el router, las vistas y los tests a la vez: no hay punto intermedio verde.

**Archivos:**
- Borrar: `frontend/lib/shared/data/mock_data.dart`, `frontend/lib/shared/models/` (3 archivos), `frontend/lib/shared/widgets/` (10 archivos), `frontend/lib/features/` (5 archivos), `frontend/lib/config/router/app_router.dart`, `frontend/lib/config/theme/` (3 archivos), `frontend/test/` (4 archivos)
- Crear: `frontend/lib/app.dart`, `frontend/test/app_test.dart`
- Modificar: `frontend/lib/main.dart`, `frontend/pubspec.yaml`, `frontend/analysis_options.yaml`, `frontend/.gitignore`

**Interfaces:**
- Consume: nada.
- Produce: `TechBrainApp` (`StatelessWidget`, constructor `const TechBrainApp({super.key})`) en `lib/app.dart`. Todas las tareas siguientes la modifican o la montan en tests.

- [ ] **Paso 1: Crear la rama desde `develop`**

```bash
cd /Users/fjbarrientos/Desktop/techBrain
git checkout develop
git pull --ff-only
git checkout -b feature/fundaciones
```

- [ ] **Paso 2: Borrar el código del demo**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend
git rm -r --quiet lib/features lib/shared lib/config/router lib/config/theme test
git status --short
```

Esperado: `lib/` conserva solo `main.dart`; `lib/config/` queda vacío y git no lo lista.

- [ ] **Paso 3: Escribir el test de humo (falla)**

Crear `frontend/test/app_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/app.dart';

void main() {
  testWidgets('TechBrainApp arranca y muestra el nombre de la app', (tester) async {
    await tester.pumpWidget(const TechBrainApp());

    expect(find.text('TechBrain'), findsOneWidget);
  });

  testWidgets('TechBrainApp resuelve el locale español', (tester) async {
    await tester.pumpWidget(const TechBrainApp());

    final context = tester.element(find.text('TechBrain'));
    expect(Localizations.localeOf(context), const Locale('es'));
  });

  testWidgets('TechBrainApp oculta el banner de depuración', (tester) async {
    await tester.pumpWidget(const TechBrainApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.debugShowCheckedModeBanner, isFalse);
  });
}
```

- [ ] **Paso 4: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/app_test.dart
```

Esperado: FALLA con `Error: Couldn't resolve the package 'techbrain'` o `Target of URI doesn't exist: 'package:techbrain/app.dart'`.

- [ ] **Paso 5: Escribir `lib/app.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Raíz de la aplicación.
///
/// Vive fuera de `main.dart` para poder montarla en los tests de widget.
class TechBrainApp extends StatelessWidget {
  const TechBrainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TechBrain',
      debugShowCheckedModeBanner: false,
      locale: Locale('es'),
      supportedLocales: <Locale>[Locale('es')],
      localizationsDelegates: <LocalizationsDelegate<Object?>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: Center(child: Text('TechBrain')),
      ),
    );
  }
}
```

- [ ] **Paso 6: Reescribir `lib/main.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';

void main() {
  // Quita el '#' de las URLs en web. En móvil es una operación sin efecto.
  usePathUrlStrategy();
  runApp(const TechBrainApp());
}
```

- [ ] **Paso 7: Quitar `dio` de `pubspec.yaml`**

Borrar la línea `  dio: ^5.11.1` del bloque `dependencies`. El resto del archivo no se toca en este paso.

Comprobación:

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter pub get && ! grep -q '^\s*dio:' pubspec.yaml && echo "dio fuera"
```

Esperado: `dio fuera`.

- [ ] **Paso 8: Excluir el código generado del análisis**

Sustituir `frontend/analysis_options.yaml` por:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - build/**
    - android/**
    - ios/**
    - web/**
    - windows/**
    - macos/**
    - linux/**
    # El código que genera riverpod_generator no se analiza ni se formatea.
    - "**/*.g.dart"
```

- [ ] **Paso 9: Completar `.gitignore`**

Añadir al final de `frontend/.gitignore`, bajo la sección `# TechBrain` que ya existe:

```gitignore
.flutter-plugins
.pub-cache/
.pub/
```

(`*.iml`, `.idea/`, `.env` y `.vercel` ya están.)

- [ ] **Paso 10: Ejecutar análisis y tests**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter analyze && flutter test
```

Esperado: `No issues found!` y `All tests passed!` con 3 tests.

- [ ] **Paso 11: Verificar que `usePathUrlStrategy()` no rompe móvil**

`flutter_web_plugins` es un paquete de web. Esta comprobación se hace una sola vez, aquí, porque es el punto de riesgo.

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter build apk --debug
```

Esperado: termina con `✓ Built build/app/outputs/flutter-apk/app-debug.apk`.

Si falla con un error de compilación en `main.dart`, sustituir el import y la llamada por una importación condicional: crear `lib/config/url_strategy_stub.dart` con `void configureUrlStrategy() {}`, `lib/config/url_strategy_web.dart` con `import 'package:flutter_web_plugins/url_strategy.dart'; void configureUrlStrategy() => usePathUrlStrategy();`, y en `main.dart` usar `import 'config/url_strategy_stub.dart' if (dart.library.js_interop) 'config/url_strategy_web.dart';` llamando a `configureUrlStrategy()`. Registrar el cambio en el mensaje de commit.

- [ ] **Paso 12: Verificar en el navegador**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter run -d chrome --web-port 8080
```

Esperado: `http://localhost:8080/` muestra `TechBrain` sobre fondo blanco (el tema llega en la Tarea 5) y la URL **no** contiene `#`.

- [ ] **Paso 13: Commit**

```bash
cd /Users/fjbarrientos/Desktop/techBrain
git add -A frontend/
git commit -m "refactor(frontend): retirar el demo y dejar la app mínima en español

Borra los mocks, los modelos y los widgets del demo de la rama 01-frontend
para construir encima la estructura de la spec 01. Deja TechBrainApp con
locale es, URLs sin almohadilla y un test de humo.

Quita dio del pubspec: es una dependencia de la Etapa 2."
```

---

## Tarea 2: Entorno (`Env` y `AuthSource`)

**Archivos:**
- Crear: `frontend/lib/config/env.dart`, `frontend/.env.example`, `frontend/test/config/env_test.dart`

**Interfaces:**
- Consume: nada.
- Produce:
  - `enum AuthSource { api, mock }` con `static AuthSource? tryParse(String value)`.
  - `abstract final class Env` con `static const String apiBaseUrl` y `static AuthSource get authSource`.
  - La Etapa 2 lee `Env.apiBaseUrl` para configurar el cliente HTTP y `Env.authSource` para elegir el datasource.

- [ ] **Paso 1: Escribir el test (falla)**

Crear `frontend/test/config/env_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/env.dart';

void main() {
  group('AuthSource.tryParse', () {
    test('reconoce los dos valores válidos', () {
      expect(AuthSource.tryParse('api'), AuthSource.api);
      expect(AuthSource.tryParse('mock'), AuthSource.mock);
    });

    test('devuelve null con cualquier otro valor', () {
      expect(AuthSource.tryParse('API'), isNull);
      expect(AuthSource.tryParse('firebase'), isNull);
      expect(AuthSource.tryParse(''), isNull);
    });
  });

  group('Env', () {
    test('sin defines usa la URL de la API del equipo', () {
      expect(Env.apiBaseUrl, 'https://api.techbrain.arcentales.dev/api');
    });

    test('sin defines el origen de autenticación es la API', () {
      expect(Env.authSource, AuthSource.api);
    });
  });
}
```

- [ ] **Paso 2: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/config/env_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/config/env.dart'`.

- [ ] **Paso 3: Escribir `lib/config/env.dart`**

```dart
/// Origen de los datos de autenticación.
enum AuthSource {
  /// Se habla con el backend real.
  api,

  /// Se usan datos locales, sin red.
  mock;

  /// Convierte el valor textual de `AUTH_SOURCE`.
  ///
  /// Devuelve null si no coincide exactamente con `api` ni con `mock`.
  static AuthSource? tryParse(String value) => switch (value) {
    'api' => AuthSource.api,
    'mock' => AuthSource.mock,
    _ => null,
  };
}

/// Configuración que llega por `--dart-define` o `--dart-define-from-file`.
///
/// Los valores se resuelven en tiempo de compilación, así que no hay ningún
/// archivo `.env` que leer en tiempo de ejecución.
abstract final class Env {
  /// Raíz de la API del backend.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.techbrain.arcentales.dev/api',
  );

  static const String _rawAuthSource = String.fromEnvironment(
    'AUTH_SOURCE',
    defaultValue: 'api',
  );

  /// Origen de autenticación configurado.
  ///
  /// Un valor desconocido cae en [AuthSource.api] y dispara un assert en
  /// debug: fallar al arrancar dejaría la demo en blanco.
  static AuthSource get authSource {
    final AuthSource? parsed = AuthSource.tryParse(_rawAuthSource);
    assert(
      parsed != null,
      'AUTH_SOURCE="$_rawAuthSource" no es válido. Usa "api" o "mock".',
    );
    return parsed ?? AuthSource.api;
  }
}
```

- [ ] **Paso 4: Ejecutar el test para confirmar que pasa**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/config/env_test.dart
```

Esperado: PASA, 4 tests.

- [ ] **Paso 5: Crear `frontend/.env.example`**

```text
# Configuración opcional de TechBrain.
#
# Uso:
#   cp .env.example .env
#   flutter run -d chrome --web-port 8080 --dart-define-from-file=.env
#
# Sin este archivo la app arranca con los valores por defecto.

# Raíz de la API del backend.
API_BASE_URL=https://api.techbrain.arcentales.dev/api

# Origen de autenticación: api | mock
AUTH_SOURCE=api
```

- [ ] **Paso 6: Comprobar que `.env` está ignorado y `.env.example` no**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && git check-ignore -q .env && echo ".env ignorado" && git check-ignore -q .env.example || echo ".env.example versionable"
```

Esperado: `.env ignorado` y `.env.example versionable`.

- [ ] **Paso 7: Comprobar que los defines llegan**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/config/env_test.dart --dart-define=AUTH_SOURCE=mock 2>&1 | tail -20
```

Esperado: FALLA el test `sin defines el origen de autenticación es la API`, porque `Env.authSource` vale `AuthSource.mock`. Esto confirma que el mecanismo funciona. No se deja ningún test dependiente de defines en la suite.

- [ ] **Paso 8: Análisis, suite completa y commit**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter analyze && flutter test
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/lib/config/env.dart frontend/.env.example frontend/test/config/env_test.dart
git commit -m "feat(frontend): añadir la configuración de entorno con Env y AuthSource

Lee API_BASE_URL y AUTH_SOURCE con String.fromEnvironment. Un AUTH_SOURCE
desconocido cae en api con un assert en debug, para que una demo mal
configurada no arranque en blanco."
```

---

## Tarea 3: Colores y tokens de diseño

Traduce a Dart las tablas de tokens de la spec. No hay UI todavía: los tests verifican los valores que otras tareas darán por buenos.

**Archivos:**
- Crear: `frontend/lib/config/theme/app_colors.dart`, `frontend/lib/config/theme/app_tokens.dart`, `frontend/test/config/theme/app_colors_test.dart`

**Interfaces:**
- Consume: nada.
- Produce:
  - `AppColors`: `bgPrimary`, `bgBox`, `cardBg`, `navBg`, `cardBorder`, `cardBorderHover`, `accentElectric`, `accentMid`, `accentDeep`, `accentLavender`, `accentVivid`, `brandDiscord`, `textMain`, `textMuted`, `textSub`, `textOnVivid`, `errorRed`, y los pares de chips `levelRequiredBg/Border/Fg`, `levelRecommendedBg/Border/Fg`, `levelOptionalBg/Border/Fg`, `catBasesBg/Border`, `catFrontendBg/Border`, `catBackendBg/Border`, `catMobileBg/Border`, `catAiAgentsBg/Border`, `catFullstackBg/Border`. Todos `static const Color`.
  - `AppRadii` (`card`, `inner`, `pill` — `double`), `AppShadows` (`glowSm`, `glowLg`, `buttonPrimary`, `buttonPrimaryHover`, `buttonVivid`, `buttonVividHover` — `List<BoxShadow>`), `AppMotion` (`hover` — `Duration`, `hoverCurve` — `Curve`), `AppBlur` (`bar` — `double`).

- [ ] **Paso 1: Escribir el test (falla)**

Crear `frontend/test/config/theme/app_colors_test.dart`:

```dart
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
```

- [ ] **Paso 2: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/config/theme/app_colors_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/config/theme/app_colors.dart'`.

- [ ] **Paso 3: Escribir `lib/config/theme/app_colors.dart`**

```dart
import 'package:flutter/material.dart';

/// Paleta de TechBrain.
///
/// Los valores salen de las tablas de tokens de
/// `docs/references/imagen_corporativa_devtalles.md` y de la spec 01.
/// No se inventa ningún color: si hace falta uno nuevo, primero se añade al
/// sistema de diseño.
abstract final class AppColors {
  // Fondos y superficies.
  static const Color bgPrimary = Color(0xFF171027);
  static const Color bgBox = Color(0xFF1C1829);
  static const Color cardBg = Color.fromRGBO(28, 24, 41, 0.85);
  static const Color navBg = Color.fromRGBO(23, 16, 39, 0.85);

  // Bordes.
  static const Color cardBorder = Color.fromRGBO(192, 185, 252, 0.12);
  static const Color cardBorderHover = Color.fromRGBO(192, 185, 252, 0.30);

  // Acentos.
  static const Color accentElectric = Color(0xFF3A14C4);
  static const Color accentMid = Color(0xFF4725AF);
  static const Color accentDeep = Color(0xFF5A16C1);
  static const Color accentLavender = Color(0xFFC0B9FC);
  static const Color accentVivid = Color(0xFFC8DD09);
  static const Color brandDiscord = Color(0xFF5865F2);

  // Texto.
  static const Color textMain = Color(0xFFF0EEFF);
  static const Color textMuted = Color(0xFF9B93C8);
  static const Color textSub = Color.fromRGBO(192, 185, 252, 0.55);
  static const Color textOnVivid = Color(0xFF0F172A);

  /// Rojo de error del ColorScheme y del nivel REQUERIDO.
  static const Color errorRed = Color(0xFFEF4444);

  // Chips de nivel (CourseLevel).
  static const Color levelRequiredBg = Color.fromRGBO(239, 68, 68, 0.15);
  static const Color levelRequiredBorder = Color.fromRGBO(239, 68, 68, 0.40);
  static const Color levelRequiredFg = Color(0xFFEF4444);

  static const Color levelRecommendedBg = Color.fromRGBO(200, 221, 9, 0.15);
  static const Color levelRecommendedBorder = Color.fromRGBO(200, 221, 9, 0.40);
  static const Color levelRecommendedFg = Color(0xFFC8DD09);

  static const Color levelOptionalBg = Color.fromRGBO(192, 185, 252, 0.15);
  static const Color levelOptionalBorder = Color.fromRGBO(192, 185, 252, 0.30);
  static const Color levelOptionalFg = Color(0xFFC0B9FC);

  // Chips de categoría (CourseCategory).
  static const Color catBasesBg = Color.fromRGBO(192, 185, 252, 0.20);
  static const Color catBasesBorder = Color(0xFFC0B9FC);

  static const Color catFrontendBg = Color.fromRGBO(48, 10, 111, 0.55);
  static const Color catFrontendBorder = Color(0xFF7E70F9);

  static const Color catBackendBg = Color.fromRGBO(58, 20, 196, 0.50);
  static const Color catBackendBorder = Color(0xFF3A14C4);

  static const Color catMobileBg = Color.fromRGBO(200, 221, 9, 0.25);
  static const Color catMobileBorder = Color(0xFFC8DD09);

  static const Color catAiAgentsBg = Color.fromRGBO(162, 0, 255, 0.35);
  static const Color catAiAgentsBorder = Color(0xFFA200FF);

  /// FULLSTACK reutiliza los tokens que el sistema de diseño llama WEB:
  /// ningún curso usa la categoría WEB, y FULLSTACK no tenía chip propio.
  static const Color catFullstackBg = Color.fromRGBO(244, 174, 163, 0.25);
  static const Color catFullstackBorder = Color(0xFFF4AEA3);
}
```

- [ ] **Paso 4: Escribir `lib/config/theme/app_tokens.dart`**

```dart
import 'package:flutter/material.dart';

/// Radios de esquina.
abstract final class AppRadii {
  /// Tarjetas glass (RNF-03).
  static const double card = 18.0;

  /// Elementos dentro de una tarjeta, como la pestaña activa de la barra.
  static const double inner = 10.0;

  /// Botones e insignias en forma de píldora.
  static const double pill = 50.0;
}

/// Sombras y resplandores.
abstract final class AppShadows {
  /// Estado de reposo de una tarjeta glass.
  static const List<BoxShadow> glowSm = <BoxShadow>[
    BoxShadow(color: Color.fromRGBO(192, 185, 252, 0.06), spreadRadius: 1),
    BoxShadow(
      color: Color.fromRGBO(58, 20, 196, 0.18),
      offset: Offset(0, 8),
      blurRadius: 32,
    ),
  ];

  /// Tarjeta glass interactiva con el cursor encima o con el foco.
  static const List<BoxShadow> glowLg = <BoxShadow>[
    BoxShadow(color: Color.fromRGBO(192, 185, 252, 0.10), spreadRadius: 1),
    BoxShadow(
      color: Color.fromRGBO(58, 20, 196, 0.35),
      offset: Offset(0, 16),
      blurRadius: 48,
    ),
  ];

  static const List<BoxShadow> buttonPrimary = <BoxShadow>[
    BoxShadow(
      color: Color.fromRGBO(58, 20, 196, 0.39),
      offset: Offset(0, 4),
      blurRadius: 14,
    ),
  ];

  static const List<BoxShadow> buttonPrimaryHover = <BoxShadow>[
    BoxShadow(
      color: Color.fromRGBO(58, 20, 196, 0.55),
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  static const List<BoxShadow> buttonVivid = <BoxShadow>[
    BoxShadow(color: Color.fromRGBO(200, 221, 9, 0.35), blurRadius: 20),
  ];

  static const List<BoxShadow> buttonVividHover = <BoxShadow>[
    BoxShadow(color: Color.fromRGBO(200, 221, 9, 0.60), blurRadius: 30),
  ];
}

/// Duraciones y curvas.
abstract final class AppMotion {
  static const Duration hover = Duration(milliseconds: 200);
  static const Curve hoverCurve = Cubic(0.16, 1, 0.3, 1);
}

/// Intensidad de los desenfoques.
abstract final class AppBlur {
  /// Sigma del BackdropFilter de las barras de navegación.
  static const double bar = 16.0;
}
```

- [ ] **Paso 5: Ejecutar el test para confirmar que pasa**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/config/theme/app_colors_test.dart
```

Esperado: PASA, 9 tests.

- [ ] **Paso 6: Análisis, suite completa y commit**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter analyze && flutter test
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/lib/config/theme frontend/test/config/theme
git commit -m "feat(frontend): añadir la paleta y los tokens de diseño de DevTalles

Traduce a Dart las tablas de imagen_corporativa_devtalles.md: colores,
radios, sombras, curvas de animación y desenfoque. FULLSTACK reutiliza los
tokens de WEB, que ninguna categoría del dataset usa."
```

---

## Tarea 4: Fuentes empaquetadas y tipografía

Cierra RNF-03: las fuentes se sirven desde el propio bundle, no desde `google_fonts` ni desde la CDN de Google.

**Archivos:**
- Crear: `frontend/assets/fonts/` (6 TTF + 2 OFL), `frontend/lib/config/theme/app_typography.dart`, `frontend/test/config/theme/app_typography_test.dart`
- Modificar: `frontend/pubspec.yaml` (sección `fonts:`)

**Interfaces:**
- Consume: `AppColors` (Tarea 3).
- Produce:
  - `AppFonts.heading` == `'SpaceGrotesk'` y `AppFonts.body` == `'DMSans'` (`String`).
  - `AppTextStyles.button`, `.buttonVivid`, `.chip`, `.columnHeader` (`TextStyle`).
  - `TextTheme buildAppTextTheme()`.

- [ ] **Paso 1: Descargar las fuentes y dejarlas con el nombre canónico**

Los zips de Google Fonts cambian de nomenclatura entre versiones (`DMSans-Regular.ttf` o `DMSans_18pt-Regular.ttf`), así que el script busca por peso y renombra.

```bash
set -euo pipefail
SCRATCH="$(mktemp -d)"
DEST="/Users/fjbarrientos/Desktop/techBrain/frontend/assets/fonts"
mkdir -p "$DEST"

for pair in "Space%20Grotesk:SpaceGrotesk" "DM%20Sans:DMSans"; do
  query="${pair%%:*}"; family="${pair##*:}"
  curl -sSL -o "$SCRATCH/$family.zip" "https://fonts.google.com/download?family=$query"
  unzip -qo "$SCRATCH/$family.zip" -d "$SCRATCH/$family"
  cp "$(find "$SCRATCH/$family" -name 'OFL.txt' | head -1)" "$DEST/$family-OFL.txt"
  for weight in Regular Medium SemiBold Bold; do
    src="$(find "$SCRATCH/$family" -name "*-$weight.ttf" ! -name "*Italic*" | head -1)"
    [ -n "$src" ] && cp "$src" "$DEST/$family-$weight.ttf"
  done
done

rm -rf "$SCRATCH"
ls -1 "$DEST"
```

Esperado, exactamente 8 archivos:

```text
DMSans-Bold.ttf
DMSans-Medium.ttf
DMSans-OFL.txt
DMSans-Regular.ttf
SpaceGrotesk-Bold.ttf
SpaceGrotesk-Medium.ttf
SpaceGrotesk-OFL.txt
SpaceGrotesk-SemiBold.ttf
```

Si falta alguno (por ejemplo `DMSans-SemiBold.ttf`, que la spec no pide, o un `SpaceGrotesk-Regular.ttf` sobrante), borrar los que sobren y comprobar que están los 6 TTF de la tabla. Si el zip solo trae la fuente variable, descargar los estáticos desde `https://github.com/google/fonts/tree/main/ofl/<familia>/static`.

- [ ] **Paso 2: Declarar las fuentes en `pubspec.yaml`**

Sustituir el bloque `flutter:` por:

```yaml
flutter:
  uses-material-design: true

  fonts:
    - family: SpaceGrotesk
      fonts:
        - asset: assets/fonts/SpaceGrotesk-Medium.ttf
          weight: 500
        - asset: assets/fonts/SpaceGrotesk-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/SpaceGrotesk-Bold.ttf
          weight: 700
    - family: DMSans
      fonts:
        - asset: assets/fonts/DMSans-Regular.ttf
          weight: 400
        - asset: assets/fonts/DMSans-Medium.ttf
          weight: 500
        - asset: assets/fonts/DMSans-Bold.ttf
          weight: 700
```

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter pub get
```

- [ ] **Paso 3: Escribir el test (falla)**

Crear `frontend/test/config/theme/app_typography_test.dart`:

```dart
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
```

- [ ] **Paso 4: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/config/theme/app_typography_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/config/theme/app_typography.dart'`.

- [ ] **Paso 5: Escribir `lib/config/theme/app_typography.dart`**

```dart
import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Familias empaquetadas en `assets/fonts/`.
///
/// Los nombres coinciden con la clave `family` de `pubspec.yaml`.
abstract final class AppFonts {
  /// Títulos, cifras y marca.
  static const String heading = 'SpaceGrotesk';

  /// Texto corrido, botones, chips y navegación.
  static const String body = 'DMSans';
}

/// Estilos que Material 3 no cubre.
abstract final class AppTextStyles {
  /// Texto de PillButton en sus variantes primary y secondary.
  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    letterSpacing: 2.0,
  );

  /// Texto de PillButton en la variante vivid.
  static const TextStyle buttonVivid = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: 13.0,
    letterSpacing: 1.5,
  );

  /// Texto de LevelBadge y CategoryBadge.
  static const TextStyle chip = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    letterSpacing: 1.5,
  );

  /// Encabezado de las columnas REQUERIDO / RECOMENDADO / OPCIONAL.
  static const TextStyle columnHeader = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    letterSpacing: 2.5,
    color: AppColors.textSub,
  );
}

/// TextTheme de Material 3 con las familias de TechBrain aplicadas.
///
/// Se conservan los tamaños de Material 3 y solo se cambian familia, peso y
/// color: `display*`, `headline*` y `title*` en Space Grotesk; `body*` y
/// `label*` en DM Sans.
TextTheme buildAppTextTheme() {
  final TextTheme base = Typography.material2021(
    platform: TargetPlatform.android,
  ).white.apply(bodyColor: AppColors.textMain, displayColor: AppColors.textMain);

  TextStyle heading(TextStyle? style, FontWeight weight) =>
      style!.copyWith(fontFamily: AppFonts.heading, fontWeight: weight);

  TextStyle body(TextStyle? style) =>
      style!.copyWith(fontFamily: AppFonts.body);

  return base.copyWith(
    displayLarge: heading(base.displayLarge, FontWeight.w700),
    displayMedium: heading(base.displayMedium, FontWeight.w700),
    displaySmall: heading(base.displaySmall, FontWeight.w700),
    headlineLarge: heading(base.headlineLarge, FontWeight.w600),
    headlineMedium: heading(base.headlineMedium, FontWeight.w600),
    headlineSmall: heading(base.headlineSmall, FontWeight.w600),
    titleLarge: heading(base.titleLarge, FontWeight.w600),
    titleMedium: heading(base.titleMedium, FontWeight.w600),
    titleSmall: heading(base.titleSmall, FontWeight.w600),
    bodyLarge: body(base.bodyLarge),
    bodyMedium: body(base.bodyMedium),
    bodySmall: body(base.bodySmall),
    labelLarge: body(base.labelLarge),
    labelMedium: body(base.labelMedium),
    labelSmall: body(base.labelSmall),
  );
}
```

- [ ] **Paso 6: Ejecutar el test para confirmar que pasa**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/config/theme/app_typography_test.dart
```

Esperado: PASA, 6 tests.

- [ ] **Paso 7: Comprobar que las fuentes entran en el bundle web**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter build web --release && ls build/web/assets/assets/fonts/
```

Esperado: los 6 TTF listados. (Flutter anida `assets/` dentro del bundle, de ahí la ruta doble.)

- [ ] **Paso 8: Análisis, suite completa y commit**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter analyze && flutter test
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/assets/fonts frontend/pubspec.yaml frontend/lib/config/theme/app_typography.dart frontend/test/config/theme/app_typography_test.dart
git commit -m "feat(frontend): empaquetar Space Grotesk y DM Sans (RNF-03)

Añade los 6 TTF estáticos con sus licencias OFL y construye el TextTheme
de Material 3 sobre ellos. Se descarta google_fonts porque descarga las
fuentes en tiempo de ejecución."
```

---

## Tarea 5: Tema oscuro y fondo cósmico

**Archivos:**
- Crear: `frontend/lib/config/theme/app_theme.dart`, `frontend/lib/shared/widgets/cosmic_background.dart`, `frontend/test/config/theme/app_theme_test.dart`
- Modificar: `frontend/lib/app.dart`, `frontend/test/app_test.dart`

**Interfaces:**
- Consume: `AppColors` (Tarea 3), `buildAppTextTheme()` (Tarea 4).
- Produce:
  - `AppTheme.dark` (`ThemeData`, getter estático).
  - `CosmicBackground({required Widget child})`.

- [ ] **Paso 1: Escribir el test del tema (falla)**

Crear `frontend/test/config/theme/app_theme_test.dart`:

```dart
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
```

- [ ] **Paso 2: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/config/theme/app_theme_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/config/theme/app_theme.dart'`.

- [ ] **Paso 3: Escribir `lib/config/theme/app_theme.dart`**

```dart
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Tema de TechBrain. Solo hay modo oscuro.
abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Transparente para que se vea el CosmicBackground que envuelve las rutas.
    scaffoldBackgroundColor: Colors.transparent,

    textTheme: buildAppTextTheme(),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentElectric,
      onPrimary: Colors.white,
      secondary: AppColors.accentVivid,
      onSecondary: AppColors.textOnVivid,
      surface: AppColors.bgBox,
      onSurface: AppColors.textMain,
      error: AppColors.errorRed,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.cardBorder,
      thickness: 1.0,
    ),
  );
}
```

- [ ] **Paso 4: Escribir `lib/shared/widgets/cosmic_background.dart`**

Los dos degradados salen del `body` del sistema de diseño (§ fondo espacial). `RadialGradient` es circular, así que las elipses se aproximan con radios distintos; la diferencia no es perceptible a pantalla completa.

```dart
import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Fondo espacial de TechBrain.
///
/// Se monta en el `builder` de MaterialApp para que cubra todas las rutas,
/// incluida la de error. Ocupa el viewport y no se desplaza con el contenido.
class CosmicBackground extends StatelessWidget {
  const CosmicBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bgPrimary,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // radial-gradient(ellipse 55% 65% at 75% 45%, rgba(58,20,196,.38))
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.5, -0.1),
                  radius: 0.9,
                  colors: <Color>[
                    Color.fromRGBO(58, 20, 196, 0.38),
                    Color.fromRGBO(58, 20, 196, 0.0),
                  ],
                  stops: <double>[0.0, 0.7],
                ),
              ),
            ),
          ),
          // radial-gradient(ellipse 35% 45% at 15% 85%, rgba(90,22,193,.20))
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.7, 0.7),
                  radius: 0.6,
                  colors: <Color>[
                    Color.fromRGBO(90, 22, 193, 0.20),
                    Color.fromRGBO(90, 22, 193, 0.0),
                  ],
                  stops: <double>[0.0, 0.6],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
```

- [ ] **Paso 5: Aplicar el tema y el fondo en `lib/app.dart`**

Sustituir el cuerpo de `build` por:

```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechBrain',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: const Locale('es'),
      supportedLocales: const <Locale>[Locale('es')],
      localizationsDelegates: const <LocalizationsDelegate<Object?>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (BuildContext context, Widget? child) =>
          CosmicBackground(child: child ?? const SizedBox.shrink()),
      home: const Scaffold(
        body: Center(child: Text('TechBrain')),
      ),
    );
  }
```

Añadir los imports `'config/theme/app_theme.dart'` y `'shared/widgets/cosmic_background.dart'`, y quitar el `const` del constructor de `MaterialApp`.

- [ ] **Paso 6: Añadir el test del fondo a `test/app_test.dart`**

```dart
  testWidgets('TechBrainApp envuelve las rutas en el fondo cósmico', (tester) async {
    await tester.pumpWidget(const TechBrainApp());

    expect(find.byType(CosmicBackground), findsOneWidget);
  });

  testWidgets('TechBrainApp aplica el tema oscuro', (tester) async {
    await tester.pumpWidget(const TechBrainApp());

    final context = tester.element(find.text('TechBrain'));
    expect(Theme.of(context).brightness, Brightness.dark);
  });
```

Añadir los imports `package:techbrain/shared/widgets/cosmic_background.dart`.

- [ ] **Paso 7: Ejecutar los tests para confirmar que pasan**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test
```

Esperado: PASA todo, incluidos los 5 de `app_test.dart` y los 4 de `app_theme_test.dart`.

- [ ] **Paso 8: Comprobar en el navegador**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter run -d chrome --web-port 8080
```

Esperado: fondo `#171027` con el resplandor violeta a la derecha y otro más tenue abajo a la izquierda. El texto `TechBrain` se ve en DM Sans y en claro.

- [ ] **Paso 9: Análisis y commit**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter analyze && flutter test
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/lib frontend/test
git commit -m "feat(frontend): aplicar el tema oscuro y el fondo cósmico

AppTheme.dark deja el Scaffold transparente y CosmicBackground se monta en
el builder de MaterialApp, para que el fondo cubra también la ruta de error."
```

---

## Tarea 6: `GlassContainer` y `TechBrainLogo`

`GlassContainer` es el widget que más se reutiliza en toda la app: tarjetas, barras de navegación y `ErrorView`. Su API se congela aquí.

**Archivos:**
- Crear: `frontend/lib/shared/widgets/glass_container.dart`, `frontend/lib/shared/widgets/tech_brain_logo.dart`, `frontend/test/shared/widgets/glass_container_test.dart`, `frontend/test/shared/widgets/tech_brain_logo_test.dart`

**Interfaces:**
- Consume: `AppColors` (Tarea 3), `AppRadii`/`AppShadows`/`AppMotion`/`AppBlur` (Tarea 3), `AppFonts` (Tarea 4).
- Produce:
  - `GlassContainer({Key? key, required Widget child, bool blur = false, Color color = AppColors.cardBg, double borderRadius = AppRadii.card, EdgeInsetsGeometry? padding, VoidCallback? onTap, String? semanticLabel})`.
  - `TechBrainLogo({Key? key, double fontSize = 22})`.

- [ ] **Paso 1: Escribir el test de `GlassContainer` (falla)**

Crear `frontend/test/shared/widgets/glass_container_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/widgets/glass_container.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('sin blur no monta ningún BackdropFilter', (tester) async {
    await tester.pumpWidget(_host(const GlassContainer(child: Text('contenido'))));

    expect(find.byType(BackdropFilter), findsNothing);
    expect(find.text('contenido'), findsOneWidget);
  });

  testWidgets('con blur monta un BackdropFilter', (tester) async {
    await tester.pumpWidget(
      _host(const GlassContainer(blur: true, child: Text('contenido'))),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
  });

  testWidgets('dispara onTap al tocarlo', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(GlassContainer(onTap: () => taps++, child: const Text('tocable'))),
    );

    await tester.tap(find.text('tocable'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('se activa con Enter cuando tiene el foco', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(GlassContainer(onTap: () => taps++, child: const Text('tocable'))),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('se activa con Espacio cuando tiene el foco', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(GlassContainer(onTap: () => taps++, child: const Text('tocable'))),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('sin onTap no es enfocable', (tester) async {
    await tester.pumpWidget(_host(const GlassContainer(child: Text('estático'))));

    expect(find.byType(FocusableActionDetector), findsNothing);
  });

  testWidgets('expone la etiqueta semántica recibida', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        GlassContainer(
          semanticLabel: 'Tarjeta de ejemplo',
          onTap: () {},
          child: const Text('contenido'),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Tarjeta de ejemplo'), findsOneWidget);
    handle.dispose();
  });
}
```

- [ ] **Paso 2: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/widgets/glass_container_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/shared/widgets/glass_container.dart'`.

- [ ] **Paso 3: Escribir `lib/shared/widgets/glass_container.dart`**

```dart
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';

/// Superficie de vidrio de TechBrain.
///
/// Es la única tarjeta glass de la app: tarjetas de contenido, barras de
/// navegación y vistas de error se construyen sobre ella.
///
/// El desenfoque está apagado por defecto porque `BackdropFilter` es caro en
/// web; solo las dos barras de navegación lo encienden.
class GlassContainer extends StatefulWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.blur = false,
    this.color = AppColors.cardBg,
    this.borderRadius = AppRadii.card,
    this.padding,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;

  /// Aplica un BackdropFilter con [AppBlur.bar]. Solo para las barras.
  final bool blur;

  final Color color;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  /// Si no es null, la tarjeta reacciona al cursor, al foco, al toque,
  /// a Enter y a Espacio.
  final VoidCallback? onTap;

  final String? semanticLabel;

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer> {
  bool _hovered = false;
  bool _focused = false;

  bool get _interactive => widget.onTap != null;
  bool get _highlighted => _interactive && (_hovered || _focused);

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(widget.borderRadius);
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    Widget surface = AnimatedContainer(
      duration: AppMotion.hover,
      curve: AppMotion.hoverCurve,
      transform: Matrix4.translationValues(
        0,
        _highlighted && !reduceMotion ? -4.0 : 0.0,
        0,
      ),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: radius,
        border: Border.all(
          color: _highlighted ? AppColors.cardBorderHover : AppColors.cardBorder,
        ),
        boxShadow: _highlighted ? AppShadows.glowLg : AppShadows.glowSm,
      ),
      child: widget.child,
    );

    if (widget.blur) {
      surface = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppBlur.bar, sigmaY: AppBlur.bar),
          child: surface,
        ),
      );
    }

    if (!_interactive) {
      if (widget.semanticLabel == null) return surface;
      return Semantics(
        label: widget.semanticLabel,
        container: true,
        child: surface,
      );
    }

    final VoidCallback onTap = widget.onTap!;

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      container: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (bool value) => setState(() => _hovered = value),
        onShowFocusHighlight: (bool value) => setState(() => _focused = value),
        actions: <Type, Action<Intent>>{
          // Enter mapea a ButtonActivateIntent en escritorio y web,
          // y Espacio a ActivateIntent. Se registran los dos.
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              onTap();
              return null;
            },
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (_) {
              onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: surface,
        ),
      ),
    );
  }
}
```

- [ ] **Paso 4: Ejecutar el test para confirmar que pasa**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/widgets/glass_container_test.dart
```

Esperado: PASA, 7 tests.

Si el test de Espacio falla porque el foco no llega con Tab, añadir `autofocus: true` al `FocusableActionDetector` **solo en el test**, montándolo dentro de un `Focus(autofocus: true)`; no se cambia el widget de producción.

- [ ] **Paso 5: Escribir el test de `TechBrainLogo` (falla)**

Crear `frontend/test/shared/widgets/tech_brain_logo_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_colors.dart';
import 'package:techbrain/shared/widgets/tech_brain_logo.dart';

void main() {
  testWidgets('muestra la marca entre llaves', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: TechBrainLogo())),
    );

    final RichText text = tester.widget<RichText>(find.byType(RichText));
    expect(text.text.toPlainText(), '{tech/brain}');
  });

  testWidgets('pinta las llaves en lavanda y la palabra en texto principal',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: TechBrainLogo())),
    );

    final RichText text = tester.widget<RichText>(find.byType(RichText));
    final List<InlineSpan> spans = (text.text as TextSpan).children!;
    expect(spans, hasLength(3));
    expect(spans[0].style!.color, AppColors.accentLavender);
    expect(spans[1].style!.color, AppColors.textMain);
    expect(spans[2].style!.color, AppColors.accentLavender);
  });

  testWidgets('se anuncia como TechBrain', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: TechBrainLogo())),
    );

    expect(find.bySemanticsLabel('TechBrain'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('respeta el fontSize recibido', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: TechBrainLogo(fontSize: 32))),
    );

    final RichText text = tester.widget<RichText>(find.byType(RichText));
    final List<InlineSpan> spans = (text.text as TextSpan).children!;
    expect(spans[1].style!.fontSize, 32.0);
  });
}
```

- [ ] **Paso 6: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/widgets/tech_brain_logo_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/shared/widgets/tech_brain_logo.dart'`.

- [ ] **Paso 7: Escribir `lib/shared/widgets/tech_brain_logo.dart`**

```dart
import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';

/// Logotipo de TechBrain: `{tech/brain}`.
///
/// Sigue el estilo de llaves de DevTalles sin copiar su marca, para que la app
/// no se confunda con la plataforma oficial.
class TechBrainLogo extends StatelessWidget {
  const TechBrainLogo({super.key, this.fontSize = 22});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = TextStyle(
      fontFamily: AppFonts.heading,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      height: 1.0,
    );

    return Semantics(
      label: 'TechBrain',
      child: ExcludeSemantics(
        child: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: '{',
                style: base.copyWith(color: AppColors.accentLavender),
              ),
              TextSpan(
                text: 'tech/brain',
                style: base.copyWith(color: AppColors.textMain),
              ),
              TextSpan(
                text: '}',
                style: base.copyWith(color: AppColors.accentLavender),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Paso 8: Ejecutar el test, analizar y commitear**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test && flutter analyze
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/lib/shared/widgets frontend/test/shared/widgets
git commit -m "feat(frontend): añadir GlassContainer y TechBrainLogo

GlassContainer es la única superficie glass de la app: eleva 4 px con el
cursor o el foco, se activa con Enter y Espacio, y solo enciende el
BackdropFilter cuando se le pide."
```

---

## Tarea 7: `PillButton`

**Archivos:**
- Crear: `frontend/lib/shared/widgets/pill_button.dart`, `frontend/test/shared/widgets/pill_button_test.dart`

**Interfaces:**
- Consume: `AppColors`, `AppRadii`, `AppShadows`, `AppMotion` (Tarea 3), `AppTextStyles` (Tarea 4).
- Produce:
  - `enum PillButtonVariant { primary, secondary, vivid }`.
  - `PillButton({Key? key, required String label, required VoidCallback? onPressed, PillButtonVariant variant = PillButtonVariant.primary, IconData? icon})`.
  - La Etapa 2 añadirá una variante `discord` a este mismo enum.

- [ ] **Paso 1: Escribir el test (falla)**

Crear `frontend/test/shared/widgets/pill_button_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/config/theme/app_typography.dart';
import 'package:techbrain/shared/widgets/pill_button.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('escribe la etiqueta en mayúsculas', (tester) async {
    await tester.pumpWidget(
      _host(PillButton(label: 'Empezar ahora', onPressed: () {})),
    );

    expect(find.text('EMPEZAR AHORA'), findsOneWidget);
    expect(find.text('Empezar ahora'), findsNothing);
  });

  testWidgets('llama a onPressed al pulsarlo', (tester) async {
    var presses = 0;
    await tester.pumpWidget(
      _host(PillButton(label: 'Pulsar', onPressed: () => presses++)),
    );

    await tester.tap(find.byType(PillButton));
    await tester.pump();

    expect(presses, 1);
  });

  testWidgets('con onPressed null no reacciona al toque', (tester) async {
    await tester.pumpWidget(
      _host(const PillButton(label: 'Inactivo', onPressed: null)),
    );

    await tester.tap(find.byType(PillButton));
    await tester.pump();

    expect(tester.takeException(), isNull);
    final Opacity opacity = tester.widget<Opacity>(
      find.descendant(of: find.byType(PillButton), matching: find.byType(Opacity)),
    );
    expect(opacity.opacity, 0.5);
  });

  testWidgets('cumple el área táctil mínima de 44 px', (tester) async {
    await tester.pumpWidget(
      _host(PillButton(label: 'OK', onPressed: () {})),
    );

    final Size size = tester.getSize(find.byType(PillButton));
    expect(size.height, greaterThanOrEqualTo(44.0));
    expect(size.width, greaterThanOrEqualTo(44.0));
  });

  testWidgets('la variante vivid usa su propio estilo de texto', (tester) async {
    await tester.pumpWidget(
      _host(PillButton(
        label: 'Generar',
        variant: PillButtonVariant.vivid,
        onPressed: () {},
      )),
    );

    final Text text = tester.widget<Text>(find.text('GENERAR'));
    expect(text.style!.fontWeight, AppTextStyles.buttonVivid.fontWeight);
    expect(text.style!.letterSpacing, AppTextStyles.buttonVivid.letterSpacing);
  });

  testWidgets('la variante secondary tiene borde y no degradado', (tester) async {
    await tester.pumpWidget(
      _host(PillButton(
        label: 'Reintentar',
        variant: PillButtonVariant.secondary,
        onPressed: () {},
      )),
    );

    final AnimatedContainer container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(PillButton),
        matching: find.byType(AnimatedContainer),
      ),
    );
    final BoxDecoration decoration = container.decoration! as BoxDecoration;
    expect(decoration.gradient, isNull);
    expect(decoration.border, isNotNull);
  });

  testWidgets('muestra el icono cuando se le pasa uno', (tester) async {
    await tester.pumpWidget(
      _host(PillButton(
        label: 'Ir a Home',
        icon: Icons.home_rounded,
        onPressed: () {},
      )),
    );

    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
  });

  testWidgets('se anuncia como botón con su etiqueta', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(PillButton(label: 'Guardar', onPressed: () {})),
    );

    expect(find.bySemanticsLabel('GUARDAR'), findsOneWidget);
    handle.dispose();
  });
}
```

- [ ] **Paso 2: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/widgets/pill_button_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/shared/widgets/pill_button.dart'`.

- [ ] **Paso 3: Escribir `lib/shared/widgets/pill_button.dart`**

```dart
import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';
import '../../config/theme/app_typography.dart';

/// Variantes de [PillButton].
///
/// Según el §4.2 del sistema de diseño, cada pantalla usa como máximo un
/// botón [vivid].
enum PillButtonVariant { primary, secondary, vivid }

/// Botón en forma de píldora de TechBrain.
class PillButton extends StatefulWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PillButtonVariant.primary,
    this.icon,
  });

  /// Se muestra siempre en mayúsculas.
  final String label;

  /// Con null el botón queda deshabilitado.
  final VoidCallback? onPressed;

  final PillButtonVariant variant;
  final IconData? icon;

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  bool _hovered = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;
  bool get _highlighted => _enabled && (_hovered || _focused);

  BoxDecoration get _decoration {
    final BorderRadius radius = BorderRadius.circular(AppRadii.pill);

    return switch (widget.variant) {
      PillButtonVariant.primary => BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.accentMid, AppColors.accentElectric],
        ),
        boxShadow: _highlighted
            ? AppShadows.buttonPrimaryHover
            : AppShadows.buttonPrimary,
      ),
      PillButtonVariant.secondary => BoxDecoration(
        borderRadius: radius,
        color: _highlighted
            ? const Color.fromRGBO(192, 185, 252, 0.12)
            : Colors.transparent,
        border: Border.all(
          color: _highlighted ? Colors.white : AppColors.accentLavender,
          width: 2.0,
        ),
      ),
      PillButtonVariant.vivid => BoxDecoration(
        borderRadius: radius,
        color: AppColors.accentVivid,
        boxShadow: _highlighted
            ? AppShadows.buttonVividHover
            : AppShadows.buttonVivid,
      ),
    };
  }

  TextStyle get _textStyle => switch (widget.variant) {
    PillButtonVariant.primary =>
      AppTextStyles.button.copyWith(color: Colors.white),
    PillButtonVariant.secondary =>
      AppTextStyles.button.copyWith(color: AppColors.textMain),
    PillButtonVariant.vivid =>
      AppTextStyles.buttonVivid.copyWith(color: AppColors.textOnVivid),
  };

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    final TextStyle style = _textStyle;
    final String label = widget.label.toUpperCase();

    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.icon != null) ...<Widget>[
          Icon(widget.icon, size: 16.0, color: style.color),
          const SizedBox(width: 8.0),
        ],
        Text(label, style: style),
      ],
    );

    final Widget button = AnimatedContainer(
      duration: AppMotion.hover,
      curve: AppMotion.hoverCurve,
      transform: Matrix4.translationValues(
        0,
        _highlighted && !reduceMotion ? -2.0 : 0.0,
        0,
      ),
      constraints: const BoxConstraints(minHeight: 44.0, minWidth: 44.0),
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 13.0),
      alignment: Alignment.center,
      decoration: _decoration,
      child: content,
    );

    if (!_enabled) {
      return Semantics(
        label: label,
        button: true,
        enabled: false,
        child: ExcludeSemantics(child: Opacity(opacity: 0.5, child: button)),
      );
    }

    final VoidCallback onPressed = widget.onPressed!;

    return Semantics(
      label: label,
      button: true,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          onShowHoverHighlight: (bool value) => setState(() => _hovered = value),
          onShowFocusHighlight: (bool value) => setState(() => _focused = value),
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                onPressed();
                return null;
              },
            ),
            ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
              onInvoke: (_) {
                onPressed();
                return null;
              },
            ),
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed,
            child: Opacity(opacity: 1.0, child: button),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Paso 4: Ejecutar el test para confirmar que pasa**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/widgets/pill_button_test.dart
```

Esperado: PASA, 8 tests.

- [ ] **Paso 5: Análisis, suite completa y commit**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter analyze && flutter test
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/lib/shared/widgets/pill_button.dart frontend/test/shared/widgets/pill_button_test.dart
git commit -m "feat(frontend): añadir PillButton con sus tres variantes

Etiqueta en mayúsculas, radio de 50 px, altura mínima de 44 px y elevación
de 2 px con el cursor o el foco. Con onPressed null baja a opacidad 0,5 y
deja de reaccionar."
```

---

## Tarea 8: `Failure` y `ErrorView`

**Archivos:**
- Crear: `frontend/lib/shared/errors/failure.dart`, `frontend/lib/shared/widgets/error_view.dart`, `frontend/test/shared/errors/failure_test.dart`, `frontend/test/shared/widgets/error_view_test.dart`

**Interfaces:**
- Consume: `GlassContainer` (Tarea 6), `PillButton` (Tarea 7), `AppColors` (Tarea 3).
- Produce:
  - `sealed class Failure implements Exception` con `final String message` y constructor `const Failure({required this.message})`.
  - Subtipos, todos `const` y con **parámetros con nombre**: `NetworkFailure({String message})`, `ServerFailure({String message, int? statusCode})`, `UnauthorizedFailure({String message})`, `NotFoundFailure({String message})`, `LocalDataFailure({String message})`, `UnexpectedFailure({String message, Object? cause})`. `message` siempre tiene valor por defecto, así que `const NotFoundFailure()` funciona.
  - `ErrorView({Key? key, required Object error, VoidCallback? onRetry, String retryLabel = 'Reintentar'})`.
  - La Etapa 2 añade `AuthFailure` en este mismo archivo, porque la clase es `sealed`.

- [ ] **Paso 1: Escribir el test de `Failure` (falla)**

Crear `frontend/test/shared/errors/failure_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/errors/failure.dart';

void main() {
  group('mensajes por defecto', () {
    test('cada subtipo trae su texto en español', () {
      expect(const NetworkFailure().message,
          'No hay conexión. Revisa tu red e inténtalo de nuevo.');
      expect(const ServerFailure().message,
          'El servidor no respondió como esperábamos. Inténtalo más tarde.');
      expect(const UnauthorizedFailure().message,
          'Tu sesión expiró. Inicia sesión de nuevo.');
      expect(const NotFoundFailure().message, 'No encontramos lo que buscas.');
      expect(const LocalDataFailure().message,
          'No pudimos leer los datos de la app.');
      expect(const UnexpectedFailure().message,
          'Algo salió mal. Inténtalo de nuevo.');
    });

    test('se puede sustituir el mensaje por uno más concreto', () {
      const failure = LocalDataFailure(message: 'El nivel "Requerido" no existe.');
      expect(failure.message, 'El nivel "Requerido" no existe.');
    });
  });

  group('contexto adicional', () {
    test('ServerFailure guarda el código de estado', () {
      expect(const ServerFailure(statusCode: 503).statusCode, 503);
      expect(const ServerFailure().statusCode, isNull);
    });

    test('UnexpectedFailure guarda la causa original', () {
      final error = StateError('roto');
      expect(UnexpectedFailure(cause: error).cause, same(error));
    });
  });

  test('es una excepción, así que los repositorios pueden lanzarla', () {
    expect(
      () => throw const NetworkFailure(),
      throwsA(isA<Failure>().having((f) => f.message, 'message',
          contains('conexión'))),
    );
  });

  test('el switch sobre Failure es exhaustivo sin rama por defecto', () {
    String describe(Failure failure) => switch (failure) {
      NetworkFailure() => 'red',
      ServerFailure() => 'servidor',
      UnauthorizedFailure() => 'sesión',
      NotFoundFailure() => 'no encontrado',
      LocalDataFailure() => 'datos locales',
      UnexpectedFailure() => 'inesperado',
    };

    expect(describe(const NotFoundFailure()), 'no encontrado');
  });
}
```

- [ ] **Paso 2: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/errors/failure_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/shared/errors/failure.dart'`.

- [ ] **Paso 3: Escribir `lib/shared/errors/failure.dart`**

```dart
/// Errores que la app sabe explicar al usuario.
///
/// Los repositorios lanzan un [Failure] y Riverpod lo expone como
/// `AsyncValue.error`. No hay un `Result<T>` propio porque `AsyncValue` ya
/// distingue carga, dato y error.
///
/// La clase es sellada para que los `switch` sean exhaustivos. Los subtipos
/// nuevos se añaden en este mismo archivo: la Etapa 2 pondrá aquí los de
/// autenticación.
///
/// Todos los constructores usan parámetros con nombre para poder combinar el
/// `message` por defecto con el contexto extra de cada subtipo.
sealed class Failure implements Exception {
  const Failure({required this.message});

  /// Texto listo para mostrar al usuario, en español.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Sin conexión o tiempo de espera agotado.
final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No hay conexión. Revisa tu red e inténtalo de nuevo.',
  });
}

/// Respuesta 5xx o cuerpo que no se puede interpretar.
final class ServerFailure extends Failure {
  const ServerFailure({
    super.message =
        'El servidor no respondió como esperábamos. Inténtalo más tarde.',
    this.statusCode,
  });

  final int? statusCode;
}

/// 401 que el refresco de sesión no recupera.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Tu sesión expiró. Inicia sesión de nuevo.',
  });
}

/// Recurso o ruta que no existe.
final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'No encontramos lo que buscas.',
  });
}

/// Error al leer un asset o los datos guardados en el dispositivo.
final class LocalDataFailure extends Failure {
  const LocalDataFailure({
    super.message = 'No pudimos leer los datos de la app.',
  });
}

/// Cualquier otra cosa. Guarda la causa original para los logs.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Algo salió mal. Inténtalo de nuevo.',
    this.cause,
  });

  final Object? cause;
}
```

- [ ] **Paso 4: Ejecutar el test para confirmar que pasa**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/errors/failure_test.dart
```

Esperado: PASA, 6 tests.

- [ ] **Paso 5: Escribir el test de `ErrorView` (falla)**

Crear `frontend/test/shared/widgets/error_view_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/errors/failure.dart';
import 'package:techbrain/shared/widgets/error_view.dart';
import 'package:techbrain/shared/widgets/pill_button.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('muestra el mensaje de la Failure recibida', (tester) async {
    await tester.pumpWidget(
      _host(const ErrorView(error: NotFoundFailure())),
    );

    expect(find.text('No encontramos lo que buscas.'), findsOneWidget);
  });

  testWidgets('ante un error que no es Failure muestra el mensaje genérico',
      (tester) async {
    await tester.pumpWidget(
      _host(ErrorView(error: StateError('roto'))),
    );

    expect(find.text('Algo salió mal. Inténtalo de nuevo.'), findsOneWidget);
    expect(find.textContaining('roto'), findsNothing);
  });

  testWidgets('sin onRetry no muestra botón', (tester) async {
    await tester.pumpWidget(
      _host(const ErrorView(error: NetworkFailure())),
    );

    expect(find.byType(PillButton), findsNothing);
  });

  testWidgets('con onRetry muestra el botón y lo invoca', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      _host(ErrorView(error: const NetworkFailure(), onRetry: () => retries++)),
    );

    expect(find.text('REINTENTAR'), findsOneWidget);
    await tester.tap(find.byType(PillButton));
    await tester.pump();

    expect(retries, 1);
  });

  testWidgets('respeta el retryLabel recibido', (tester) async {
    await tester.pumpWidget(
      _host(ErrorView(
        error: const NotFoundFailure(),
        onRetry: () {},
        retryLabel: 'Ir a Home',
      )),
    );

    expect(find.text('IR A HOME'), findsOneWidget);
  });

  testWidgets('no desborda a 360 px de ancho', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(ErrorView(error: const ServerFailure(), onRetry: () {})),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
```

- [ ] **Paso 6: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/widgets/error_view_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/shared/widgets/error_view.dart'`.

- [ ] **Paso 7: Escribir `lib/shared/widgets/error_view.dart`**

```dart
import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../errors/failure.dart';
import 'glass_container.dart';
import 'pill_button.dart';

/// Vista de error reutilizable.
///
/// Recibe un [Object] porque `AsyncValue.error` no garantiza que el error sea
/// una [Failure]: si no lo es, se muestra el mensaje de [UnexpectedFailure]
/// para no enseñar al usuario un texto técnico.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.retryLabel = 'Reintentar',
  });

  final Object error;
  final VoidCallback? onRetry;
  final String retryLabel;

  String get _message => switch (error) {
    final Failure failure => failure.message,
    _ => const UnexpectedFailure().message,
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420.0),
        child: GlassContainer(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                size: 40.0,
                color: AppColors.accentLavender,
              ),
              const SizedBox(height: 16.0),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (onRetry != null) ...<Widget>[
                const SizedBox(height: 24.0),
                PillButton(
                  label: retryLabel,
                  variant: PillButtonVariant.secondary,
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Paso 8: Ejecutar, analizar y commitear**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test && flutter analyze
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/lib/shared frontend/test/shared
git commit -m "feat(frontend): añadir la jerarquía Failure y la vista de error

Failure es sellada para que los switch sean exhaustivos y trae el mensaje
en español de cada caso. ErrorView acepta cualquier Object y cae en el
mensaje genérico cuando el error no es una Failure."
```

---

## Tarea 9: Enums del dominio y dataset como asset

Cierra el enganche con el dataset: los enums se validan contra los datos reales, no contra literales escritos a mano.

**Archivos:**
- Crear: `frontend/tool/sync_datasets.sh`, `frontend/assets/data/cursos_devtalles.json`, `frontend/assets/data/rutas_aprendizaje_devtalles.json`, `frontend/lib/shared/domain/course_level.dart`, `frontend/lib/shared/domain/course_category.dart`, `frontend/lib/shared/domain/dataset_assets.dart`, `frontend/test/shared/domain/course_enums_test.dart`, `frontend/test/shared/domain/dataset_values_test.dart`
- Modificar: `frontend/pubspec.yaml` (sección `assets:`)

**Interfaces:**
- Consume: `LocalDataFailure` (Tarea 8).
- Produce:
  - `enum CourseLevel { required, recommended, optional }` con `final String datasetValue`, `final String label` y `static CourseLevel fromDataset(String value)`. El **orden de declaración es el orden de fuerza**: Requerido > Recomendado > Opcional. Las Etapas 3 y 4 lo usan para deduplicar slugs y ordenar columnas.
  - `enum CourseCategory { bases, frontend, backend, mobile, aiAgents, fullstack }` con `final String datasetValue` y `static CourseCategory fromDataset(String value)`.
  - `abstract final class DatasetAssets` con `static const String courses = 'assets/data/cursos_devtalles.json'` y `static const String routes = 'assets/data/rutas_aprendizaje_devtalles.json'`. La Etapa 3 los carga con `rootBundle`.

- [ ] **Paso 1: Escribir el script de sincronización**

Crear `frontend/tool/sync_datasets.sh`:

```bash
#!/usr/bin/env bash
#
# Copia los JSON del dataset de DevTalles a assets/data/.
#
# Los originales viven en docs/references/, fuera del paquete Flutter. Se
# copian en lugar de declararlos con '../' para que acaben en
# build/web/assets/ y para que funcionen en iOS y en Android.
#
# Si cambian los originales, ejecuta este script y commitea la copia.
# dataset_values_test.dart falla si la copia se queda atrás.
set -euo pipefail

PACKAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$PACKAGE_DIR/../docs/references"
TARGET_DIR="$PACKAGE_DIR/assets/data"

mkdir -p "$TARGET_DIR"

for file in cursos_devtalles.json rutas_aprendizaje_devtalles.json; do
  cp "$SOURCE_DIR/$file" "$TARGET_DIR/$file"
  echo "copiado: $file"
done
```

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && chmod +x tool/sync_datasets.sh && ./tool/sync_datasets.sh && ls -la assets/data/
```

Esperado: `copiado: cursos_devtalles.json`, `copiado: rutas_aprendizaje_devtalles.json` y los dos archivos listados (≈1,0 MB y ≈90 KB).

- [ ] **Paso 2: Declarar los assets en `pubspec.yaml`**

Añadir dentro del bloque `flutter:`, antes de `fonts:`:

```yaml
  assets:
    - assets/data/
```

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter pub get
```

- [ ] **Paso 3: Escribir el test de los enums (falla)**

Crear `frontend/test/shared/domain/course_enums_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/shared/domain/course_category.dart';
import 'package:techbrain/shared/domain/course_level.dart';
import 'package:techbrain/shared/errors/failure.dart';

void main() {
  group('CourseLevel', () {
    test('convierte los tres valores del dataset', () {
      expect(CourseLevel.fromDataset('REQUERIDO'), CourseLevel.required);
      expect(CourseLevel.fromDataset('RECOMENDADO'), CourseLevel.recommended);
      expect(
        CourseLevel.fromDataset('OPCIONAL PERO MUY ÚTIL'),
        CourseLevel.optional,
      );
    });

    test('la comparación es exacta: no normaliza mayúsculas', () {
      expect(
        () => CourseLevel.fromDataset('Requerido'),
        throwsA(isA<LocalDataFailure>()),
      );
    });

    test('un valor desconocido lanza LocalDataFailure', () {
      expect(
        () => CourseLevel.fromDataset('IMPRESCINDIBLE'),
        throwsA(isA<LocalDataFailure>()),
      );
    });

    test('el orden de declaración es el orden de fuerza', () {
      expect(CourseLevel.values, <CourseLevel>[
        CourseLevel.required,
        CourseLevel.recommended,
        CourseLevel.optional,
      ]);
      expect(CourseLevel.required.index, lessThan(CourseLevel.optional.index));
    });

    test('la etiqueta visible es más corta que el valor del dataset', () {
      expect(CourseLevel.optional.label, 'Opcional');
      expect(CourseLevel.required.label, 'Requerido');
      expect(CourseLevel.recommended.label, 'Recomendado');
    });
  });

  group('CourseCategory', () {
    test('convierte las seis categorías del dataset', () {
      expect(CourseCategory.fromDataset('BASES'), CourseCategory.bases);
      expect(CourseCategory.fromDataset('FRONTEND'), CourseCategory.frontend);
      expect(CourseCategory.fromDataset('BACKEND'), CourseCategory.backend);
      expect(CourseCategory.fromDataset('MÓVIL'), CourseCategory.mobile);
      expect(CourseCategory.fromDataset('AGENTES IA'), CourseCategory.aiAgents);
      expect(CourseCategory.fromDataset('FULLSTACK'), CourseCategory.fullstack);
    });

    test('no acepta MOVIL sin tilde', () {
      expect(
        () => CourseCategory.fromDataset('MOVIL'),
        throwsA(isA<LocalDataFailure>()),
      );
    });

    test('no existe la categoría WEB, que ningún curso usa', () {
      expect(
        () => CourseCategory.fromDataset('WEB'),
        throwsA(isA<LocalDataFailure>()),
      );
    });
  });
}
```

- [ ] **Paso 4: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/domain/course_enums_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/shared/domain/course_level.dart'`.

- [ ] **Paso 5: Escribir `lib/shared/domain/course_level.dart`**

```dart
import '../errors/failure.dart';

/// Nivel de un curso dentro de una ruta.
///
/// El nivel no es una propiedad del curso: sale de la ruta. Un mismo curso
/// puede ser REQUERIDO en una ruta y OPCIONAL en otra.
///
/// El orden de declaración es el orden de fuerza (Requerido > Recomendado >
/// Opcional). Se usa para deduplicar slugs repetidos dentro de una ruta
/// conservando el nivel más fuerte, y para ordenar las columnas.
enum CourseLevel {
  required('REQUERIDO', 'Requerido'),
  recommended('RECOMENDADO', 'Recomendado'),
  optional('OPCIONAL PERO MUY ÚTIL', 'Opcional');

  const CourseLevel(this.datasetValue, this.label);

  /// Valor exacto en `rutas_aprendizaje_devtalles.json`.
  final String datasetValue;

  /// Texto visible en la interfaz.
  final String label;

  /// Convierte el valor del dataset.
  ///
  /// La comparación es exacta: no se normalizan mayúsculas ni tildes, para
  /// que un cambio en el dataset se note en vez de pasar desapercibido.
  ///
  /// Lanza [LocalDataFailure] si el valor no coincide.
  static CourseLevel fromDataset(String value) {
    for (final CourseLevel level in CourseLevel.values) {
      if (level.datasetValue == value) return level;
    }
    throw LocalDataFailure(
      message: 'Nivel desconocido en el dataset: "$value".',
    );
  }
}
```

- [ ] **Paso 6: Escribir `lib/shared/domain/course_category.dart`**

```dart
import '../errors/failure.dart';

/// Categoría de un curso dentro de una ruta.
///
/// Como el nivel, depende de la ruta y no del curso. No existe la categoría
/// WEB del sistema de diseño porque ningún curso la usa; sus tokens se
/// reutilizan para [fullstack].
enum CourseCategory {
  bases('BASES'),
  frontend('FRONTEND'),
  backend('BACKEND'),
  mobile('MÓVIL'),
  aiAgents('AGENTES IA'),
  fullstack('FULLSTACK');

  const CourseCategory(this.datasetValue);

  /// Valor exacto en el dataset. También es el texto visible del chip.
  final String datasetValue;

  /// Convierte el valor del dataset. La comparación es exacta.
  ///
  /// Lanza [LocalDataFailure] si el valor no coincide.
  static CourseCategory fromDataset(String value) {
    for (final CourseCategory category in CourseCategory.values) {
      if (category.datasetValue == value) return category;
    }
    throw LocalDataFailure(
      message: 'Categoría desconocida en el dataset: "$value".',
    );
  }
}
```

- [ ] **Paso 7: Escribir `lib/shared/domain/dataset_assets.dart`**

```dart
/// Rutas de los JSON del dataset dentro del bundle.
///
/// Son copias de `docs/references/`, generadas con `tool/sync_datasets.sh`.
abstract final class DatasetAssets {
  static const String courses = 'assets/data/cursos_devtalles.json';
  static const String routes = 'assets/data/rutas_aprendizaje_devtalles.json';
}
```

- [ ] **Paso 8: Ejecutar el test de enums para confirmar que pasa**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/domain/course_enums_test.dart
```

Esperado: PASA, 8 tests.

- [ ] **Paso 9: Escribir el test contra el dataset real (falla)**

Crear `frontend/test/shared/domain/dataset_values_test.dart`:

```dart
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
```

- [ ] **Paso 10: Ejecutar el test contra el dataset**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/domain/dataset_values_test.dart
```

Esperado: PASA, 4 tests.

Los dos JSON son una **lista en la raíz**, comprobado el 17 sep 2026:
`cursos_devtalles.json` tiene 91 elementos y `rutas_aprendizaje_devtalles.json`
tiene 13, con 113 entradas de curso en total. Las claves de cada entrada de
ruta son `slug`, `nombre`, `nivel`, `categoria`, `duracion`, `requisitos`,
`caratula` y `url`.

Si el test de la copia falla, ejecutar `./tool/sync_datasets.sh` y volver a
intentarlo. Si falla la conversión de un `nivel` o una `categoria`, el
dataset cambió: **no** se relaja `fromDataset`; se mira el valor nuevo y se
decide si entra en el enum.

- [ ] **Paso 11: Análisis, suite completa y commit**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter analyze && flutter test
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/tool frontend/assets/data frontend/pubspec.yaml frontend/lib/shared/domain frontend/test/shared/domain
git commit -m "feat(frontend): añadir CourseLevel, CourseCategory y el dataset como asset

Los JSON se copian de docs/references/ a assets/data/ con
tool/sync_datasets.sh, para que acaben en build/web/assets/ y funcionen en
móvil. Un test compara la copia con el original y falla si se queda atrás.

Los enums comparan el valor del dataset de forma exacta y lanzan
LocalDataFailure ante cualquier variante, para que un cambio en los datos
se note."
```

---

## Tarea 10: `LevelBadge` y `CategoryBadge`

**Archivos:**
- Crear: `frontend/lib/shared/widgets/level_badge.dart`, `frontend/lib/shared/widgets/category_badge.dart`, `frontend/test/shared/widgets/badges_test.dart`

**Interfaces:**
- Consume: `CourseLevel`, `CourseCategory` (Tarea 9), `AppColors`, `AppRadii` (Tarea 3), `AppTextStyles` (Tarea 4).
- Produce:
  - `LevelBadge({Key? key, required CourseLevel level})` — constructor con parámetro **con nombre**.
  - `CategoryBadge({Key? key, required CourseCategory category})`.

- [ ] **Paso 1: Escribir el test (falla)**

Crear `frontend/test/shared/widgets/badges_test.dart`:

```dart
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
    find.descendant(of: find.byType(widgetType), matching: find.byType(Container)),
  );
  return container.decoration! as BoxDecoration;
}

void main() {
  group('LevelBadge', () {
    testWidgets('escribe la etiqueta de cada nivel en mayúsculas',
        (tester) async {
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
      await tester.pumpWidget(_host(const LevelBadge(level: CourseLevel.required)));
      expect(find.byIcon(Icons.hexagon), findsOneWidget);

      await tester.pumpWidget(
        _host(const LevelBadge(level: CourseLevel.recommended)),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);

      await tester.pumpWidget(_host(const LevelBadge(level: CourseLevel.optional)));
      expect(find.byIcon(Icons.circle), findsOneWidget);
    });

    testWidgets('se anuncia como "Nivel: <etiqueta>"', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_host(const LevelBadge(level: CourseLevel.required)));

      expect(find.bySemanticsLabel('Nivel: Requerido'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('REQUERIDO usa los colores de su fila de la tabla de chips',
        (tester) async {
      await tester.pumpWidget(_host(const LevelBadge(level: CourseLevel.required)));

      final BoxDecoration decoration = _decorationOf(tester, LevelBadge);
      expect(decoration.color, AppColors.levelRequiredBg);
      expect((decoration.border! as Border).top.color,
          AppColors.levelRequiredBorder);
    });
  });

  group('CategoryBadge', () {
    testWidgets('escribe el valor del dataset de las seis categorías',
        (tester) async {
      for (final CourseCategory category in CourseCategory.values) {
        await tester.pumpWidget(_host(CategoryBadge(category: category)));
        expect(find.text(category.datasetValue), findsOneWidget,
            reason: 'categoría $category');
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

    testWidgets('FULLSTACK usa los tokens que el sistema llama WEB',
        (tester) async {
      await tester.pumpWidget(
        _host(const CategoryBadge(category: CourseCategory.fullstack)),
      );

      final BoxDecoration decoration = _decorationOf(tester, CategoryBadge);
      expect(decoration.color, const Color.fromRGBO(244, 174, 163, 0.25));
      expect((decoration.border! as Border).top.color, const Color(0xFFF4AEA3));
    });
  });
}
```

- [ ] **Paso 2: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/widgets/badges_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/shared/widgets/level_badge.dart'`.

- [ ] **Paso 3: Escribir `lib/shared/widgets/level_badge.dart`**

```dart
import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';
import '../../config/theme/app_typography.dart';
import '../domain/course_level.dart';

/// Insignia del nivel de un curso dentro de una ruta.
class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key, required this.level});

  final CourseLevel level;

  ({Color background, Color border, Color icon, IconData symbol}) get _style =>
      switch (level) {
        CourseLevel.required => (
          background: AppColors.levelRequiredBg,
          border: AppColors.levelRequiredBorder,
          icon: AppColors.levelRequiredFg,
          symbol: Icons.hexagon,
        ),
        CourseLevel.recommended => (
          background: AppColors.levelRecommendedBg,
          border: AppColors.levelRecommendedBorder,
          icon: AppColors.levelRecommendedFg,
          symbol: Icons.star,
        ),
        CourseLevel.optional => (
          background: AppColors.levelOptionalBg,
          border: AppColors.levelOptionalBorder,
          icon: AppColors.levelOptionalFg,
          symbol: Icons.circle,
        ),
      };

  @override
  Widget build(BuildContext context) {
    final style = _style;

    return Semantics(
      label: 'Nivel: ${level.label}',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            border: Border.all(color: style.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(style.symbol, size: 14.0, color: style.icon),
              const SizedBox(width: 6.0),
              Text(
                level.label.toUpperCase(),
                style: AppTextStyles.chip.copyWith(color: AppColors.textMain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Paso 4: Escribir `lib/shared/widgets/category_badge.dart`**

```dart
import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';
import '../../config/theme/app_typography.dart';
import '../domain/course_category.dart';

/// Insignia de la categoría de un curso dentro de una ruta.
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.category});

  final CourseCategory category;

  ({Color background, Color border}) get _style => switch (category) {
    CourseCategory.bases => (
      background: AppColors.catBasesBg,
      border: AppColors.catBasesBorder,
    ),
    CourseCategory.frontend => (
      background: AppColors.catFrontendBg,
      border: AppColors.catFrontendBorder,
    ),
    CourseCategory.backend => (
      background: AppColors.catBackendBg,
      border: AppColors.catBackendBorder,
    ),
    CourseCategory.mobile => (
      background: AppColors.catMobileBg,
      border: AppColors.catMobileBorder,
    ),
    CourseCategory.aiAgents => (
      background: AppColors.catAiAgentsBg,
      border: AppColors.catAiAgentsBorder,
    ),
    CourseCategory.fullstack => (
      background: AppColors.catFullstackBg,
      border: AppColors.catFullstackBorder,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final style = _style;

    return Semantics(
      label: 'Categoría: ${category.datasetValue}',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            border: Border.all(color: style.border),
          ),
          child: Text(
            category.datasetValue,
            style: AppTextStyles.chip.copyWith(color: AppColors.textMain),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Paso 5: Ejecutar, analizar y commitear**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/widgets/badges_test.dart && flutter analyze && flutter test
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/lib/shared/widgets/level_badge.dart frontend/lib/shared/widgets/category_badge.dart frontend/test/shared/widgets/badges_test.dart
git commit -m "feat(frontend): añadir LevelBadge y CategoryBadge

Chips píldora con los colores exactos de la tabla del sistema de diseño.
Los símbolos de nivel son iconos de Material y no glifos, para no obligar
al navegador a descargar una fuente de respaldo."
```

---

## Tarea 11: Router, pantallas provisionales y `ProviderScope`

Primera tarea con código generado. A partir de aquí, cualquier cambio en `app_router.dart` obliga a regenerar `app_router.g.dart` y a commitearlo.

**Archivos:**
- Crear: `frontend/lib/config/router/app_routes.dart`, `frontend/lib/config/router/app_router.dart`, `frontend/lib/config/router/app_router.g.dart` (generado), `frontend/lib/shared/layout/app_shell.dart`, `frontend/lib/shared/widgets/coming_soon_view.dart`, las 4 pantallas de `frontend/lib/features/`, `frontend/test/config/router/app_router_test.dart`
- Modificar: `frontend/lib/app.dart`, `frontend/lib/main.dart`, `frontend/test/app_test.dart`

**Interfaces:**
- Consume: `ErrorView`, `NotFoundFailure` (Tarea 8), `GlassContainer` (Tarea 6), `CosmicBackground` (Tarea 5).
- Produce:
  - `AppRoutes.home` `'/home'`, `.explore` `'/explore'`, `.quiz` `'/quiz'`, `.settings` `'/settings'`.
  - `appRouterProvider` (generado a partir de `GoRouter appRouter(Ref ref)`), que la Etapa 2 ampliará con el guard de sesión en `redirect`.
  - `AppShell({Key? key, required StatefulNavigationShell navigationShell})`.
  - `ComingSoonView({Key? key, required String title, required int stage})`.
  - `HomeScreen`, `ExploreScreen`, `QuizScreen`, `SettingsScreen`, todas `const` y sin parámetros.

- [ ] **Paso 1: Escribir el test del router (falla)**

Crear `frontend/test/config/router/app_router_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:techbrain/config/router/app_router.dart';
import 'package:techbrain/config/router/app_routes.dart';
import 'package:techbrain/features/catalog/presentation/screens/explore_screen.dart';
import 'package:techbrain/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:techbrain/features/roadmap/presentation/screens/home_screen.dart';
import 'package:techbrain/features/settings/presentation/screens/settings_screen.dart';
import 'package:techbrain/shared/widgets/error_view.dart';

/// Monta la app con el router apuntando a [location].
Future<GoRouter> pumpRouter(WidgetTester tester, String location) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);

  final GoRouter router = container.read(appRouterProvider);
  router.go(location);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

void main() {
  testWidgets('/ redirige a /home', (tester) async {
    final GoRouter router = await pumpRouter(tester, '/');

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      AppRoutes.home,
    );
  });

  testWidgets('cada path abre su pantalla', (tester) async {
    for (final (String path, Type screen) in <(String, Type)>[
      (AppRoutes.home, HomeScreen),
      (AppRoutes.explore, ExploreScreen),
      (AppRoutes.quiz, QuizScreen),
      (AppRoutes.settings, SettingsScreen),
    ]) {
      await pumpRouter(tester, path);
      expect(find.byType(screen), findsOneWidget, reason: 'path $path');
    }
  });

  testWidgets('una ruta desconocida muestra ErrorView con el texto de 404',
      (tester) async {
    await pumpRouter(tester, '/no-existe');

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('No encontramos lo que buscas.'), findsOneWidget);
    expect(find.text('IR A HOME'), findsOneWidget);
  });

  testWidgets('el botón de la ruta desconocida vuelve a Home', (tester) async {
    await pumpRouter(tester, '/no-existe');

    await tester.tap(find.text('IR A HOME'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('el provider mantiene la misma instancia de GoRouter',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(appRouterProvider),
        same(container.read(appRouterProvider)));
  });
}
```

- [ ] **Paso 2: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/config/router/app_router_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/config/router/app_router.dart'`.

- [ ] **Paso 3: Escribir `lib/config/router/app_routes.dart`**

```dart
/// Paths de la navegación.
///
/// Van en inglés para que coincidan con los nombres de carpeta de
/// `lib/features/`.
abstract final class AppRoutes {
  static const String home = '/home';
  static const String explore = '/explore';
  static const String quiz = '/quiz';
  static const String settings = '/settings';
}
```

- [ ] **Paso 4: Escribir `lib/shared/widgets/coming_soon_view.dart`**

```dart
import 'package:flutter/material.dart';

import 'glass_container.dart';

/// Marcador de una pantalla que implementa una etapa posterior.
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key, required this.title, required this.stage});

  final String title;

  /// Número de etapa que construirá esta pantalla.
  final int stage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420.0),
        child: GlassContainer(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12.0),
              Text(
                'Disponible en la Etapa $stage.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Paso 5: Escribir las 4 pantallas provisionales**

`lib/features/roadmap/presentation/screens/home_screen.dart`:

```dart
import 'package:flutter/material.dart';

import '../../../../shared/widgets/coming_soon_view.dart';

/// Pantalla de inicio. La Etapa 4 la implementa con la ruta activa,
/// las rutas guardadas y las métricas del usuario.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonView(title: 'Home', stage: 4);
  }
}
```

`lib/features/catalog/presentation/screens/explore_screen.dart`: idéntico, con `class ExploreScreen` y `ComingSoonView(title: 'Explorar', stage: 3)`.

`lib/features/quiz/presentation/screens/quiz_screen.dart`: idéntico, con `class QuizScreen` y `ComingSoonView(title: 'Cuestionarios', stage: 6)`.

`lib/features/settings/presentation/screens/settings_screen.dart`: idéntico, con `class SettingsScreen` y `ComingSoonView(title: 'Configuración', stage: 5)`.

- [ ] **Paso 6: Escribir `lib/shared/layout/app_shell.dart` en su versión mínima**

Las barras llegan en las Tareas 12 y 13.

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Contenedor de las 4 pestañas.
///
/// Elige la barra de navegación según el ancho disponible. De momento solo
/// muestra el contenido: las barras llegan en las tareas siguientes.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: navigationShell);
  }
}
```

- [ ] **Paso 7: Escribir `lib/config/router/app_router.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/catalog/presentation/screens/explore_screen.dart';
import '../../features/quiz/presentation/screens/quiz_screen.dart';
import '../../features/roadmap/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../shared/errors/failure.dart';
import '../../shared/layout/app_shell.dart';
import '../../shared/widgets/error_view.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Router de la app.
///
/// Se mantiene vivo durante toda la sesión: recrearlo perdería el historial
/// de navegación de cada pestaña.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    redirect: (BuildContext context, GoRouterState state) =>
        state.uri.path == '/' ? AppRoutes.home : null,
    errorBuilder: (BuildContext context, GoRouterState state) => ErrorView(
      error: const NotFoundFailure(),
      onRetry: () => context.go(AppRoutes.home),
      retryLabel: 'Ir a Home',
    ),
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) => AppShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (_, _) => const NoTransitionPage<void>(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.explore,
                pageBuilder: (_, _) => const NoTransitionPage<void>(
                  child: ExploreScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.quiz,
                pageBuilder: (_, _) => const NoTransitionPage<void>(
                  child: QuizScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.settings,
                pageBuilder: (_, _) => const NoTransitionPage<void>(
                  child: SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
```

Si `dart analyze` se queja de los parámetros `_` duplicados en `pageBuilder` (wildcards, disponibles desde Dart 3.7), nombrarlos `(context, state)` y añadir `// ignore: unused_local_variable` no hace falta: basta con usar `(BuildContext _, GoRouterState _)`.

- [ ] **Paso 8: Generar `app_router.g.dart`**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && dart run build_runner build --delete-conflicting-outputs
```

Esperado: `Succeeded` y el archivo `lib/config/router/app_router.g.dart` creado, con un `appRouterProvider`.

Si el generador se queja del tipo del parámetro `ref`, usar exactamente el tipo que indique el mensaje. La firma correcta con `riverpod_generator` 4.x es `GoRouter appRouter(Ref ref)`.

- [ ] **Paso 9: Conectar el router en `app.dart` y `main.dart`**

`lib/app.dart` pasa a ser un `ConsumerWidget`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'shared/widgets/cosmic_background.dart';

/// Raíz de la aplicación.
class TechBrainApp extends ConsumerWidget {
  const TechBrainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'TechBrain',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: const Locale('es'),
      supportedLocales: const <Locale>[Locale('es')],
      localizationsDelegates: const <LocalizationsDelegate<Object?>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.watch(appRouterProvider),
      builder: (BuildContext context, Widget? child) =>
          CosmicBackground(child: child ?? const SizedBox.shrink()),
    );
  }
}
```

`lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';

void main() {
  // Quita el '#' de las URLs en web. En móvil es una operación sin efecto.
  usePathUrlStrategy();
  runApp(const ProviderScope(child: TechBrainApp()));
}
```

- [ ] **Paso 10: Actualizar `test/app_test.dart`**

`TechBrainApp` ya no muestra el texto `TechBrain` ni acepta montarse sin `ProviderScope`. Sustituir el archivo por:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/app.dart';
import 'package:techbrain/features/roadmap/presentation/screens/home_screen.dart';
import 'package:techbrain/shared/widgets/cosmic_background.dart';

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: TechBrainApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('la app arranca en Home', (tester) async {
    await pumpApp(tester);

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('envuelve las rutas en el fondo cósmico', (tester) async {
    await pumpApp(tester);

    expect(find.byType(CosmicBackground), findsOneWidget);
  });

  testWidgets('resuelve el locale español y el tema oscuro', (tester) async {
    await pumpApp(tester);

    final BuildContext context = tester.element(find.byType(HomeScreen));
    expect(Localizations.localeOf(context), const Locale('es'));
    expect(Theme.of(context).brightness, Brightness.dark);
  });

  testWidgets('oculta el banner de depuración', (tester) async {
    await pumpApp(tester);

    final MaterialApp app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.debugShowCheckedModeBanner, isFalse);
  });
}
```

- [ ] **Paso 11: Ejecutar la suite**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test
```

Esperado: PASA todo, incluidos los 5 tests del router y los 4 de `app_test.dart`.

- [ ] **Paso 12: Comprobar en el navegador**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter run -d chrome --web-port 8080
```

Esperado:
- `http://localhost:8080/` redirige a `/home` y muestra "Disponible en la Etapa 4."
- Escribir `/quiz` en la barra de direcciones muestra "Cuestionarios · Disponible en la Etapa 6."
- Escribir `/no-existe` muestra "No encontramos lo que buscas." con el botón "IR A HOME", sobre el fondo cósmico.

- [ ] **Paso 13: Análisis, comprobación de deriva y commit**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter analyze && dart run build_runner build --delete-conflicting-outputs
cd /Users/fjbarrientos/Desktop/techBrain && test -z "$(git status --porcelain frontend/lib/config/router)" && echo "el código generado está al día"
git add frontend/lib frontend/test
git commit -m "feat(frontend): añadir el router con las 4 pestañas y sus pantallas

appRouterProvider se genera con @Riverpod(keepAlive: true) para no perder
el historial de cada pestaña. La raíz redirige a /home y una ruta
desconocida muestra ErrorView con NotFoundFailure.

El .g.dart generado se commitea: la CI comprueba que está al día."
```

---

## Tarea 12: Barra de navegación inferior

**Archivos:**
- Crear: `frontend/lib/shared/layout/breakpoints.dart`, `frontend/lib/shared/layout/app_tabs.dart`, `frontend/lib/shared/layout/app_bottom_nav_bar.dart`, `frontend/test/shared/layout/app_shell_test.dart`
- Modificar: `frontend/lib/shared/layout/app_shell.dart`

**Interfaces:**
- Consume: `AppRoutes` (Tarea 11), `GlassContainer` (Tarea 6), `AppColors`, `AppRadii` (Tarea 3), `AppTextStyles` (Tarea 4).
- Produce:
  - `Breakpoints.desktop` `1024.0`, `.minSupported` `360.0`, `.maxContentWidth` `1200.0`.
  - `typedef AppTab = ({String path, String label, IconData icon, IconData selectedIcon})` y `const List<AppTab> appTabs` con las 4 pestañas en orden: Home, Explorar, Cuestionarios, Configuración.
  - `AppBottomNavBar({Key? key, required int currentIndex, required ValueChanged<int> onTabSelected})`.

- [ ] **Paso 1: Escribir el test del shell (falla)**

Crear `frontend/test/shared/layout/app_shell_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techbrain/app.dart';
import 'package:techbrain/features/catalog/presentation/screens/explore_screen.dart';
import 'package:techbrain/features/roadmap/presentation/screens/home_screen.dart';
import 'package:techbrain/shared/layout/app_bottom_nav_bar.dart';

/// Monta la app con un viewport de [size] lógicos.
Future<void> pumpAppAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const ProviderScope(child: TechBrainApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a 390 px muestra la barra inferior', (tester) async {
    await pumpAppAt(tester, const Size(390, 844));

    expect(find.byType(AppBottomNavBar), findsOneWidget);
  });

  testWidgets('la barra inferior lista las 4 pestañas', (tester) async {
    await pumpAppAt(tester, const Size(390, 844));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explorar'), findsOneWidget);
    expect(find.text('Cuestionarios'), findsOneWidget);
    expect(find.text('Configuración'), findsOneWidget);
  });

  testWidgets('pulsar Explorar abre ExploreScreen', (tester) async {
    await pumpAppAt(tester, const Size(390, 844));

    await tester.tap(find.text('Explorar'));
    await tester.pumpAndSettle();

    expect(find.byType(ExploreScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('cada pestaña cumple el área táctil de 44 x 44 px',
      (tester) async {
    await pumpAppAt(tester, const Size(390, 844));

    for (final String label in <String>[
      'Home',
      'Explorar',
      'Cuestionarios',
      'Configuración',
    ]) {
      final Size size = tester.getSize(
        find.ancestor(
          of: find.text(label),
          matching: find.byType(ConstrainedBox),
        ).first,
      );
      expect(size.height, greaterThanOrEqualTo(44.0), reason: 'pestaña $label');
      expect(size.width, greaterThanOrEqualTo(44.0), reason: 'pestaña $label');
    }
  });

  testWidgets('a 360 px no hay desbordes', (tester) async {
    await pumpAppAt(tester, const Size(360, 640));

    expect(tester.takeException(), isNull);
  });
}
```

- [ ] **Paso 2: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/layout/app_shell_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/shared/layout/app_bottom_nav_bar.dart'`.

- [ ] **Paso 3: Escribir `lib/shared/layout/breakpoints.dart`**

```dart
/// Anchos que gobiernan el layout.
abstract final class Breakpoints {
  /// A partir de aquí se usa la barra superior en lugar de la inferior.
  static const double desktop = 1024.0;

  /// Ancho mínimo que la app soporta sin desbordes.
  static const double minSupported = 360.0;

  /// Ancho máximo del contenido en escritorio.
  static const double maxContentWidth = 1200.0;
}
```

- [ ] **Paso 4: Escribir `lib/shared/layout/app_tabs.dart`**

```dart
import 'package:flutter/material.dart';

import '../../config/router/app_routes.dart';

/// Una pestaña de la navegación principal.
typedef AppTab = ({
  String path,
  String label,
  IconData icon,
  IconData selectedIcon,
});

/// Las 4 pestañas, en el mismo orden que las ramas del router.
///
/// El índice de esta lista es el índice de rama de StatefulShellRoute.
const List<AppTab> appTabs = <AppTab>[
  (
    path: AppRoutes.home,
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  (
    path: AppRoutes.explore,
    label: 'Explorar',
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore,
  ),
  (
    path: AppRoutes.quiz,
    label: 'Cuestionarios',
    icon: Icons.quiz_outlined,
    selectedIcon: Icons.quiz,
  ),
  (
    path: AppRoutes.settings,
    label: 'Configuración',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
];
```

- [ ] **Paso 5: Escribir `lib/shared/layout/app_bottom_nav_bar.dart`**

```dart
import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';
import '../../config/theme/app_typography.dart';
import '../widgets/glass_container.dart';
import 'app_tabs.dart';

/// Barra de navegación flotante para anchos por debajo de
/// [Breakpoints.desktop].
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  /// Altura de la barra sin contar el área segura ni el margen inferior.
  static const double height = 64.0;

  /// Margen lateral e inferior de la barra flotante.
  static const double margin = 16.0;

  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(margin, 0, margin, margin),
        child: GlassContainer(
          blur: true,
          color: AppColors.navBg,
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: <Widget>[
              for (final (int index, AppTab tab) in appTabs.indexed)
                Expanded(
                  child: _BottomNavItem(
                    tab: tab,
                    selected: index == currentIndex,
                    onTap: () => onTabSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final AppTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color foreground = selected ? AppColors.textMain : AppColors.textMuted;

    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.inner),
          focusColor: const Color.fromRGBO(192, 185, 252, 0.12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52.0, minWidth: 44.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.inner),
                gradient: selected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          AppColors.accentMid,
                          AppColors.accentElectric,
                        ],
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      selected ? tab.selectedIcon : tab.icon,
                      size: 20.0,
                      color: foreground,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      tab.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.chip.copyWith(
                        color: foreground,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

**Nota de accesibilidad:** el anillo de foco de 2 px en `accentLavender` lo aporta el `focusColor` del `InkWell` más el `Focus` que Flutter añade. Si el test de foco de la Tarea 13 no lo ve, envolver el `DecoratedBox` en un `Focus` propio y pintar un `Border.all(color: AppColors.accentLavender, width: 2)` cuando `hasFocus`.

- [ ] **Paso 6: Usar la barra en `AppShell`**

Sustituir `lib/shared/layout/app_shell.dart` por:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_bottom_nav_bar.dart';

/// Contenedor de las 4 pestañas.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// Cambia de pestaña.
  ///
  /// `initialLocation: true` cuando ya se está en la pestaña reinicia su pila
  /// de navegación, que es lo que espera el usuario al volver a pulsarla.
  void _goToTab(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El contenido pasa por detrás de la barra flotante.
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: navigationShell,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTabSelected: _goToTab,
      ),
    );
  }
}
```

- [ ] **Paso 7: Ejecutar los tests**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/layout/app_shell_test.dart
```

Esperado: PASA, 5 tests.

Si el test de 44 px falla porque `find.ancestor` encuentra otro `ConstrainedBox`, cambiar el finder a `find.ancestor(of: find.text(label), matching: find.byType(InkWell)).first`. No bajar el mínimo: el criterio de 44 px es de RNF-11.

- [ ] **Paso 8: Comprobar en el navegador y commitear**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter analyze && flutter test
```

Abrir la app con la ventana estrecha (≈390 px) y comprobar que se navega entre las 4 pestañas y que la pestaña activa lleva el degradado.

```bash
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/lib/shared/layout frontend/test/shared/layout
git commit -m "feat(frontend): añadir la barra de navegación inferior flotante

GlassContainer con blur sobre navBg, margen de 16 px y área segura. La
pestaña activa lleva el degradado de acento; volver a pulsarla reinicia su
pila de navegación."
```

---

## Tarea 13: Barra superior y corte responsive

**Archivos:**
- Crear: `frontend/lib/shared/layout/app_top_nav_bar.dart`
- Modificar: `frontend/lib/shared/layout/app_shell.dart`, `frontend/test/shared/layout/app_shell_test.dart`

**Interfaces:**
- Consume: `appTabs`, `Breakpoints` (Tarea 12), `TechBrainLogo` (Tarea 6), `GlassContainer` (Tarea 6).
- Produce: `AppTopNavBar({Key? key, required int currentIndex, required ValueChanged<int> onTabSelected})` con `static const double height = 72.0`, e implementa `PreferredSizeWidget`.

- [ ] **Paso 1: Ampliar el test con los tres anchos clave (falla)**

Añadir a `frontend/test/shared/layout/app_shell_test.dart`, y añadir el import de `app_top_nav_bar.dart` y de `tech_brain_logo.dart`:

```dart
  testWidgets('a 1023 px sigue mostrando la barra inferior', (tester) async {
    await pumpAppAt(tester, const Size(1023, 800));

    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(find.byType(AppTopNavBar), findsNothing);
  });

  testWidgets('a 1024 px cambia a la barra superior', (tester) async {
    await pumpAppAt(tester, const Size(1024, 800));

    expect(find.byType(AppTopNavBar), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsNothing);
  });

  testWidgets('a 1280 px la barra superior lleva el logotipo', (tester) async {
    await pumpAppAt(tester, const Size(1280, 800));

    expect(find.byType(AppTopNavBar), findsOneWidget);
    expect(find.byType(TechBrainLogo), findsOneWidget);
    expect(find.byType(AppBottomNavBar), findsNothing);
  });

  testWidgets('en escritorio el contenido no pasa del ancho máximo',
      (tester) async {
    await pumpAppAt(tester, const Size(1600, 900));

    final Size size = tester.getSize(find.byType(HomeScreen));
    expect(size.width, lessThanOrEqualTo(Breakpoints.maxContentWidth));
  });

  testWidgets('en escritorio se navega entre pestañas', (tester) async {
    await pumpAppAt(tester, const Size(1280, 800));

    await tester.tap(find.text('Cuestionarios'));
    await tester.pumpAndSettle();

    expect(find.byType(QuizScreen), findsOneWidget);
  });
```

Añadir también los imports de `Breakpoints` y `QuizScreen`.

- [ ] **Paso 2: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/layout/app_shell_test.dart
```

Esperado: FALLA con `Target of URI doesn't exist: 'package:techbrain/shared/layout/app_top_nav_bar.dart'`.

- [ ] **Paso 3: Escribir `lib/shared/layout/app_top_nav_bar.dart`**

```dart
import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import '../widgets/glass_container.dart';
import '../widgets/tech_brain_logo.dart';
import 'app_tabs.dart';

/// Barra de navegación superior para anchos a partir de
/// [Breakpoints.desktop].
class AppTopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  static const double height = 72.0;

  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: true,
      color: AppColors.navBg,
      borderRadius: 0.0,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: SizedBox(
        height: height,
        child: Row(
          children: <Widget>[
            const TechBrainLogo(),
            const Spacer(),
            for (final (int index, AppTab tab) in appTabs.indexed)
              _TopNavItem(
                tab: tab,
                selected: index == currentIndex,
                onTap: () => onTabSelected(index),
              ),
          ],
        ),
      ),
    );
  }
}

class _TopNavItem extends StatelessWidget {
  const _TopNavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final AppTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color foreground = selected ? AppColors.textMain : AppColors.textMuted;

    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          focusColor: const Color.fromRGBO(192, 185, 252, 0.12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44.0, minWidth: 44.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        selected ? tab.selectedIcon : tab.icon,
                        size: 18.0,
                        color: foreground,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        tab.label,
                        style: AppTextStyles.chip.copyWith(
                          color: foreground,
                          letterSpacing: 0.0,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Indicador de la pestaña activa.
                  Container(
                    height: 2.0,
                    color: selected ? AppColors.accentVivid : Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Paso 4: Hacer que `AppShell` elija la barra según el ancho**

Sustituir el `build` de `lib/shared/layout/app_shell.dart`:

```dart
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;

    if (width >= Breakpoints.desktop) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppTopNavBar(
          currentIndex: navigationShell.currentIndex,
          onTabSelected: _goToTab,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.maxContentWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: navigationShell,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      // El contenido pasa por detrás de la barra flotante.
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: navigationShell,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTabSelected: _goToTab,
      ),
    );
  }
```

Añadir los imports de `app_top_nav_bar.dart` y `breakpoints.dart`.

- [ ] **Paso 5: Ejecutar los tests**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/shared/layout/app_shell_test.dart
```

Esperado: PASA, 10 tests.

El test de ancho máximo mide `HomeScreen`, que incluye el padding de 32 px: si devuelve 1200 exactos o algo menor, está bien. Si devuelve más, el `ConstrainedBox` no está envolviendo al `navigationShell`.

- [ ] **Paso 6: Comprobar el foco de teclado en el navegador**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter run -d chrome --web-port 8080
```

Con la ventana ancha (≥1024 px): pulsar Tab recorre las 4 pestañas con un indicador de foco visible, y Enter navega a la pestaña enfocada. Redimensionar la ventana cruzando los 1024 px cambia de barra sin errores en consola.

Si el anillo de foco no se ve, aplicar la nota de accesibilidad de la Tarea 12 a los dos `_NavItem`.

- [ ] **Paso 7: Análisis y commit**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter analyze && flutter test
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/lib/shared/layout frontend/test/shared/layout
git commit -m "feat(frontend): añadir la barra superior y el corte responsive en 1024 px

Por debajo de 1024 px manda la barra inferior flotante; a partir de ahí,
una barra superior de 72 px con el logotipo y el indicador de pestaña
activa. El contenido de escritorio se centra con un máximo de 1200 px."
```

---

## Tarea 14: Muestrario de componentes en Home

Escaparate temporal para revisar los widgets en el despliegue. **La Etapa 4 lo elimina.**

**Archivos:**
- Modificar: `frontend/lib/features/roadmap/presentation/screens/home_screen.dart`
- Crear: `frontend/test/features/home_screen_test.dart`

**Interfaces:**
- Consume: `ComingSoonView` (Tarea 11), `PillButton` (Tarea 7), `LevelBadge`, `CategoryBadge` (Tarea 10), `GlassContainer` (Tarea 6), `CourseLevel`, `CourseCategory` (Tarea 9), `AppTextStyles` (Tarea 4).
- Produce: nada que otra tarea consuma.

- [ ] **Paso 1: Escribir el test (falla)**

Crear `frontend/test/features/home_screen_test.dart`:

```dart
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
    expect(find.byType(CategoryBadge), findsNWidgets(CourseCategory.values.length));
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
```

- [ ] **Paso 2: Ejecutar el test para confirmar que falla**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/features/home_screen_test.dart
```

Esperado: FALLA porque `HomeScreen` solo contiene `ComingSoonView`: `Expected: exactly 4 matching candidates, Actual: _TypeWidgetFinder: found 0`.

- [ ] **Paso 3: Escribir el muestrario en `home_screen.dart`**

```dart
import 'package:flutter/material.dart';

import '../../../../config/theme/app_typography.dart';
import '../../../../shared/domain/course_category.dart';
import '../../../../shared/domain/course_level.dart';
import '../../../../shared/widgets/category_badge.dart';
import '../../../../shared/widgets/coming_soon_view.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/level_badge.dart';
import '../../../../shared/widgets/pill_button.dart';

/// Pantalla de inicio. La Etapa 4 la implementa con la ruta activa,
/// las rutas guardadas y las métricas del usuario, y elimina el muestrario.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      children: <Widget>[
        const ComingSoonView(title: 'Home', stage: 4),
        const SizedBox(height: 32.0),
        const _ShowcaseHeader(),
        const SizedBox(height: 16.0),
        const _ShowcaseSection(
          title: 'Botones',
          child: _ButtonShowcase(),
        ),
        const SizedBox(height: 16.0),
        _ShowcaseSection(
          title: 'Niveles',
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: <Widget>[
              for (final CourseLevel level in CourseLevel.values)
                LevelBadge(level: level),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        _ShowcaseSection(
          title: 'Categorías',
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: <Widget>[
              for (final CourseCategory category in CourseCategory.values)
                CategoryBadge(category: category),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        _ShowcaseSection(
          title: 'Tarjeta interactiva',
          child: GlassContainer(
            padding: const EdgeInsets.all(20.0),
            semanticLabel: 'Tarjeta de ejemplo',
            onTap: () {},
            child: Text(
              'Pasa el cursor o enfócala con Tab.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        // Deja sitio para la barra inferior flotante.
        const SizedBox(height: 96.0),
      ],
    );
  }
}

class _ShowcaseHeader extends StatelessWidget {
  const _ShowcaseHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Muestrario de componentes (temporal)',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class _ShowcaseSection extends StatelessWidget {
  const _ShowcaseSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title.toUpperCase(), style: AppTextStyles.columnHeader),
        const SizedBox(height: 8.0),
        child,
      ],
    );
  }
}

class _ButtonShowcase extends StatelessWidget {
  const _ButtonShowcase();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: <Widget>[
        PillButton(label: 'Primario', onPressed: _noop),
        PillButton(
          label: 'Secundario',
          variant: PillButtonVariant.secondary,
          onPressed: _noop,
        ),
        PillButton(
          label: 'Generar ruta',
          variant: PillButtonVariant.vivid,
          onPressed: _noop,
        ),
        PillButton(label: 'Deshabilitado', onPressed: null),
      ],
    );
  }
}

/// Callback vacío del muestrario: los botones no hacen nada todavía.
void _noop() {}
```

- [ ] **Paso 4: Ejecutar el test para confirmar que pasa**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter test test/features/home_screen_test.dart
```

Esperado: PASA, 5 tests.

- [ ] **Paso 5: Revisar en el navegador a los dos extremos**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter run -d chrome --web-port 8080
```

A 360 px y a 1280 px: se ven las 4 variantes de botón, los 3 niveles, las 6 categorías y la tarjeta interactiva, sin franjas amarillas de overflow ni errores en consola. El botón deshabilitado se ve a media opacidad y no reacciona.

- [ ] **Paso 6: Análisis, suite completa y commit**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter analyze && flutter test
cd /Users/fjbarrientos/Desktop/techBrain
git add frontend/lib/features/roadmap frontend/test/features
git commit -m "feat(frontend): añadir el muestrario temporal de componentes a Home

Sirve para revisar los widgets base en el despliegue. La Etapa 4 lo
sustituye por la Home real."
```

---

## Tarea 15: Web y CI

El demo ya dejó `web/index.html`, `web/manifest.json` y `web/vercel.json` correctos, y un workflow `CI` que ejecuta `pub get`, `analyze`, `test` y `build web`. Aquí se **verifica** lo primero y se **completa** lo segundo con los tres controles que la spec añade: formato, deriva del código generado y deriva del dataset.

**Archivos:**
- Verificar sin cambios previsibles: `frontend/web/index.html`, `frontend/web/manifest.json`, `frontend/web/vercel.json`
- Modificar: `.github/workflows/ci.yml`

**Interfaces:**
- Consume: `tool/sync_datasets.sh` (Tarea 9), `app_router.g.dart` (Tarea 11).
- Produce: nada que otra tarea consuma.

- [ ] **Paso 1: Verificar los archivos web**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend
grep -q '<html lang="es">' web/index.html && echo "lang ok"
grep -q '<title>TechBrain</title>' web/index.html && echo "título ok"
grep -q 'name="theme-color" content="#171027"' web/index.html && echo "theme-color ok"
grep -q 'background-color: #171027' web/index.html && echo "fondo ok"
grep -q 'Rutas de aprendizaje personalizadas' web/index.html && echo "descripción ok"
grep -q '"theme_color": "#171027"' web/manifest.json && echo "manifest ok"
grep -q '"destination": "/index.html"' web/vercel.json && echo "rewrites ok"
```

Esperado: las 7 líneas `ok`. Corregir solo lo que falte.

- [ ] **Paso 2: Comprobar que `vercel.json` llega al build**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && flutter build web --release && test -f build/web/vercel.json && echo "vercel.json en el build"
```

Esperado: `vercel.json en el build`.

- [ ] **Paso 3: Comprobar que el formato actual está limpio**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend && dart format lib test && git -C /Users/fjbarrientos/Desktop/techBrain status --short frontend/
```

Si `dart format` reformatea algo, commitear ese cambio antes de seguir; el paso de CI del siguiente paso lo exigirá.

- [ ] **Paso 4: Ampliar `.github/workflows/ci.yml`**

Insertar estos pasos en el job `frontend`, entre `Dependencias` y `Análisis estático`:

```yaml
      - name: Formato
        run: |
          files=$(git ls-files '*.dart' | grep -v '\.g\.dart$' || true)
          if [ -n "$files" ]; then
            dart format --output=none --set-exit-if-changed $files
          fi

      - name: Regenerar el código de Riverpod
        run: dart run build_runner build --delete-conflicting-outputs

      - name: El código generado está al día
        run: |
          if [ -n "$(git status --porcelain)" ]; then
            echo "Hay archivos generados sin commitear:"
            git status --porcelain
            echo "Ejecuta: dart run build_runner build --delete-conflicting-outputs"
            exit 1
          fi

      - name: El dataset copiado está al día
        run: |
          ./tool/sync_datasets.sh
          if [ -n "$(git status --porcelain assets/data)" ]; then
            echo "assets/data/ no coincide con docs/references/."
            echo "Ejecuta: ./tool/sync_datasets.sh y commitea la copia."
            exit 1
          fi
```

Los pasos `Formato`, `El código generado está al día` y `El dataset copiado está al día` ejecutan `git` con el `working-directory: ./frontend` que el job ya define, así que `git ls-files` y `git status --porcelain` se limitan a `frontend/`. Eso es justo lo que se quiere: la CI del frontend no juzga cambios de `backend/`.

Ampliar también el disparador para que el workflow reaccione a un cambio del dataset:

```yaml
on:
  pull_request:
    branches: [develop, main]
    paths:
      - 'frontend/**'
      - 'docs/references/*.json'
      - '.github/workflows/ci.yml'
  push:
    branches: [develop, main]
    paths:
      - 'frontend/**'
      - 'docs/references/*.json'
      - '.github/workflows/ci.yml'
```

- [ ] **Paso 5: Ensayar los pasos nuevos en local**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend
files=$(git ls-files '*.dart' | grep -v '\.g\.dart$'); dart format --output=none --set-exit-if-changed $files && echo "formato ok"
dart run build_runner build --delete-conflicting-outputs
test -z "$(git status --porcelain)" && echo "generado al día"
./tool/sync_datasets.sh && test -z "$(git status --porcelain assets/data)" && echo "dataset al día"
```

Esperado: `formato ok`, `generado al día` y `dataset al día`.

- [ ] **Paso 6: Verificar el YAML y commitear**

```bash
cd /Users/fjbarrientos/Desktop/techBrain && python3 -c "import yaml,sys; yaml.safe_load(open('.github/workflows/ci.yml')); print('YAML válido')"
git add .github/workflows/ci.yml frontend/
git commit -m "ci: comprobar formato, código generado y copia del dataset

Añade al workflow del frontend tres controles que faltaban: dart format
sobre los .dart versionados que no son generados, regeneración de los
.g.dart para detectar deriva, y ejecución de sync_datasets.sh para que
assets/data/ no se quede atrás respecto a docs/references/."
```

---

## Tarea 16: Documentación

**Archivos:**
- Modificar: `frontend/README.md`, `README.md` (raíz), `frontend/CLAUDE.md`, `CLAUDE.md` (raíz)

**Interfaces:**
- Consume: todo lo anterior.
- Produce: nada de código.

> `CLAUDE.md` no se versiona (es local, igual que `frontend/CLAUDE.md`). Se actualiza igualmente, pero **no entra en el `git add`**. Comprobar con `git check-ignore` antes de commitear.

- [ ] **Paso 1: Actualizar `frontend/README.md`**

Debe contener, con estos encabezados:

- **Requisitos:** Flutter 3.47.0 stable (Dart 3.13) y Chrome. Xcode y el SDK de Android solo para móvil.
- **Ejecutar:**
  ```bash
  git clone https://github.com/theplomos/techBrain.git
  cd techBrain/frontend
  flutter pub get
  flutter run -d chrome --web-port 8080
  ```
- **Configuración opcional:** tabla con `API_BASE_URL` (por defecto `https://api.techbrain.arcentales.dev/api`) y `AUTH_SOURCE` (`api` | `mock`, por defecto `api`), más `cp .env.example .env` y `flutter run -d chrome --web-port 8080 --dart-define-from-file=.env`.
- **Móvil:** `flutter run -d <dispositivo>`.
- **Calidad:** `flutter analyze`, `flutter test`, `flutter test test/shared/widgets/pill_button_test.dart` y `flutter test --plain-name "LevelBadge"`.
- **Código generado:** `dart run build_runner build --delete-conflicting-outputs`. Los `.g.dart` se commitean.
- **Dataset:** los JSON viven en `docs/references/` y se copian a `frontend/assets/data/` con `./tool/sync_datasets.sh`. Si cambian los originales, ejecutar el script y commitear la copia.
- **Despliegue:** `flutter build web --release` y `npx vercel@latest deploy build/web --prod`, más la URL de producción (la rellena la Tarea 17).
- **Estructura:** el árbol de `lib/`, `test/`, `web/`, `assets/`, `tool/` y `specs/`.

- [ ] **Paso 2: Actualizar el `README.md` de la raíz**

- Conservar la descripción del proyecto, el equipo y la licencia MIT.
- Apuntar a `frontend/README.md` para los pasos del frontend.
- Añadir la URL de producción cuando la Tarea 17 la produzca.

- [ ] **Paso 3: Actualizar `frontend/CLAUDE.md`**

- Sustituir la sección **Estructura** por la real: `config/env.dart`, `config/theme/` con 4 archivos, `config/router/` con 3, `shared/domain/`, `shared/errors/`, `shared/layout/`, `shared/widgets/`, `features/<feature>/presentation/screens/`.
- Borrar la mención a `shared/data/mock_data.dart` y a `shared/models/`, que ya no existen.
- Borrar el aviso `> El pubspec.yaml actual ya trae dio y riverpod_annotation sin usarlos, herencia del demo.`: `dio` ya no está y `riverpod_annotation` se usa.
- Sustituir el párrafo final sobre los JSON con `../` por: los JSON se copian a `assets/data/` con `tool/sync_datasets.sh`, la CI comprueba que la copia está al día, y la decisión queda cerrada.
- Sustituir "Lo que hay ahora es el demo de la rama 01-frontend" por el estado real: la Etapa 1 está implementada y el muestrario de Home es temporal.
- Añadir `./tool/sync_datasets.sh` a la lista de comandos.

- [ ] **Paso 4: Actualizar el `CLAUDE.md` de la raíz**

- En **Aprendizajes del demo**, marcar como cerradas las deudas que esta etapa resuelve: mocks, fuentes sin empaquetar, `dio` sin usar, ausencia de `Failure`, ausencia de `env.dart`, CI incompleta y los assets fuera del paquete.
- Dejar abiertas las que siguen abiertas: modelos de dominio y lectura real del catálogo (Etapa 3), persistencia (Etapa 4), iconos y splash (Etapa 7).
- Actualizar el árbol del repositorio con `frontend/assets/`, `frontend/tool/` y `frontend/docs/superpowers/`.

- [ ] **Paso 5: Verificar el README desde un clon limpio**

```bash
cd /tmp && rm -rf techbrain-clon && git clone --branch feature/fundaciones \
  /Users/fjbarrientos/Desktop/techBrain techbrain-clon
cd techbrain-clon/frontend && flutter pub get && flutter test && flutter build web --release
```

Esperado: `All tests passed!` y el build web completo, sin ningún paso que el README no mencione. Si hace falta algo más (por ejemplo ejecutar `sync_datasets.sh`), añadirlo al README.

```bash
rm -rf /tmp/techbrain-clon
```

- [ ] **Paso 6: Commit (sin los CLAUDE.md)**

```bash
cd /Users/fjbarrientos/Desktop/techBrain
git check-ignore -q CLAUDE.md frontend/CLAUDE.md && echo "los CLAUDE.md están ignorados: no entran en el commit"
git add README.md frontend/README.md
git commit -m "docs: documentar la instalación, la calidad y el dataset del frontend

El README del frontend recoge los pasos reales desde un clon limpio, las
variables de entorno, los comandos de test y la sincronización del
dataset."
```

Si `git check-ignore` no los marca como ignorados, **no** añadirlos igualmente: comprobar primero con el usuario, porque el `CLAUDE.md` de la raíz dice que son locales.

---

## Tarea 17: Pull request y primer despliegue

Última tarea. Incluye acciones que **hace el usuario**, no el agente: el despliegue usa su cuenta de Vercel.

**Archivos:**
- Modificar: `frontend/README.md`, `README.md` (raíz) — solo para anotar la URL

**Interfaces:**
- Consume: todo lo anterior.
- Produce: la URL de producción, que el backend necesita para DEP-02 y DEP-05.

- [ ] **Paso 1: Repasar los criterios de aceptación en local**

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend
flutter analyze
flutter test
dart run build_runner build --delete-conflicting-outputs
test -z "$(git status --porcelain)" && echo "sin deriva de generados"
grep -Eq '^\s*(dio|flutter_web_auth_2|flutter_secure_storage|shared_preferences):' pubspec.yaml \
  && echo "FALLO: hay dependencias de etapas posteriores" \
  || echo "pubspec limpio"
grep -q 'PRODUCT_BUNDLE_IDENTIFIER = dev.arcentales.techbrain;' ios/Runner.xcodeproj/project.pbxproj \
  && echo "bundle ID de iOS ok"
grep -q 'applicationId = "dev.arcentales.techbrain"' android/app/build.gradle.kts \
  && echo "applicationId de Android ok"
flutter build web --release
flutter build apk --debug
flutter build ios --debug --no-codesign
```

Esperado: `No issues found!`, `All tests passed!`, `sin deriva de generados`, `pubspec limpio` y los tres builds completos.

`flutter build ios` solo funciona en macOS con Xcode. Si no está disponible, anotarlo en el PR en lugar de omitirlo en silencio.

- [ ] **Paso 2: Abrir el Pull Request a `develop`**

```bash
cd /Users/fjbarrientos/Desktop/techBrain
git push -u origin feature/fundaciones
gh pr create --base develop --head feature/fundaciones \
  --title "Etapa 1: fundaciones del frontend Flutter" \
  --body "Implementa frontend/specs/01-fundaciones.md.

Sustituye el demo de la rama 01-frontend por la base definitiva:

- Tema oscuro con los tokens exactos del sistema de diseño y las fuentes
  Space Grotesk y DM Sans empaquetadas (RNF-03).
- Shell responsive con 4 pestañas y corte en 1024 px.
- Widgets base: GlassContainer, PillButton, LevelBadge, CategoryBadge,
  TechBrainLogo, CosmicBackground, ErrorView y ComingSoonView.
- Dominio compartido: CourseLevel, CourseCategory y la jerarquía sellada
  Failure.
- El dataset de DevTalles se copia a assets/data/ y un test comprueba que
  la copia está al día (RNF-05).
- Configuración de entorno con Env y .env.example.
- CI ampliada con formato, deriva de código generado y deriva del dataset.

Fuera de alcance: login (Etapa 2), modelos y lectura real del catálogo
(Etapa 3), persistencia (Etapa 4).

El muestrario de componentes de Home es temporal y lo elimina la Etapa 4."
```

- [ ] **Paso 3: Esperar a que la CI pase**

```bash
cd /Users/fjbarrientos/Desktop/techBrain && gh pr checks --watch
```

Esperado: el check `Análisis y pruebas del frontend` en verde. Si falla, corregir en la rama y volver a empujar; no se fusiona con la CI en rojo.

- [ ] **Paso 4: Despliegue manual en Vercel — lo hace el usuario**

Este paso no lo ejecuta el agente: usa la cuenta de Vercel del usuario.

```bash
cd /Users/fjbarrientos/Desktop/techBrain/frontend
flutter build web --release
npx vercel@latest deploy build/web --prod
```

Nombre sugerido para el proyecto: `techbrain`. Vercel no detecta framework en `build/web` porque no hay `package.json`: se despliega como sitio estático.

Si falla, la alternativa documentada en el §13 del requerimiento es Firebase Hosting.

- [ ] **Paso 5: Comprobar el despliegue**

Con la URL que devuelve Vercel:

- `https://<url>/` carga y redirige a `/home`.
- Navegar a `/explore` y **recargar el navegador** muestra la app, no un 404 de Vercel. Esto valida los rewrites de `web/vercel.json`.
- `/no-existe` muestra "No encontramos lo que buscas.".
- Las URLs no llevan `#`.
- Las fuentes se ven correctas: título en Space Grotesk, texto en DM Sans.

- [ ] **Paso 6: Anotar la URL y cerrar**

Añadir la URL de producción a `frontend/README.md` (sección **Despliegue**) y al `README.md` de la raíz.

```bash
cd /Users/fjbarrientos/Desktop/techBrain
git add README.md frontend/README.md
git commit -m "docs: anotar la URL de producción del frontend

El backend la necesita para DEP-02 y DEP-05."
git push
```

- [ ] **Paso 7: Fusionar con merge commit, sin squash**

Lo hace el usuario desde GitHub o con:

```bash
cd /Users/fjbarrientos/Desktop/techBrain && gh pr merge --merge --delete-branch
```

`--merge` y no `--squash`: el jurado evalúa el uso de ramas (RNF-10) y el historial de la feature debe quedar visible.

Compartir la URL de producción con la persona que lleva el backend.

---

## Cobertura de los criterios de aceptación

Cada criterio de la spec, con la tarea que lo cumple.

**Proyecto y plataformas**

| Criterio | Tarea |
|---|---|
| Existen `android/`, `ios/` y `web/` | Ya existen. Verificado en 17 |
| Bundle ID y `applicationId` `dev.arcentales.techbrain` | Ya puestos. Verificado en 17 |
| `flutter analyze` sin avisos | Todas (último paso de cada tarea) + 17 |
| `flutter test` sin fallos | Todas + 17 |
| Sin deriva tras `build_runner` | 11, verificado en 15 y 17 |
| Builds de web, APK e iOS | 1 (APK), 4 y 15 (web), 17 (los tres) |
| `pubspec.yaml` sin `dio` ni las demás | 1, verificado en 17 |
| Clon limpio sin `.env` levanta la app | 16 (paso 5) |

**Navegación y layout**

| Criterio | Tarea |
|---|---|
| `/` redirige a `/home` | 11 |
| `/explore`, `/quiz`, `/settings` abren su pantalla | 11 |
| `/no-existe` muestra el 404 y "IR A HOME" funciona | 11 |
| A 390 px hay barra inferior y no superior | 12 |
| A 1023 px inferior, a 1024 px superior | 13 |
| A 1280 px superior con `TechBrainLogo` | 13 |
| Pulsar "Explorar" abre `ExploreScreen` | 12 |
| A 360 px no hay excepciones de overflow | 12 y 14 |
| Pestañas y `PillButton` de 44 × 44 px | 7 y 12 |
| Tab recorre las pestañas y Enter navega | 13 (paso 6, en navegador) |

**Tema y widgets**

| Criterio | Tarea |
|---|---|
| `AppTheme.dark` oscuro, títulos Space Grotesk, cuerpo DM Sans | 4 y 5 |
| Fondo cósmico en todas las pantallas, también la de error | 5 (el `builder` cubre `errorBuilder`) |
| `CategoryBadge(fullstack)` con sus colores exactos | 10 |
| `LevelBadge` con los 3 textos y sus etiquetas semánticas | 10 |
| `GlassContainer` solo con `BackdropFilter` si `blur: true` | 6 |
| `ErrorView` muestra el botón solo con `onRetry` y lo invoca | 8 |
| `ErrorView` con `StateError` muestra el mensaje genérico | 8 |
| Home muestra las 4 variantes de botón y los 9 chips | 14 |

**Datos y entorno**

| Criterio | Tarea |
|---|---|
| Todos los `nivel` y `categoria` se convierten | 9 |
| El catálogo carga 91 cursos | 9 |
| `fromDataset('Requerido')` lanza `LocalDataFailure` | 9 |
| Valores por defecto de `Env` | 2 |
| `.env.example` versionado y `.env` ignorado | 2 |

**Web, CI y entrega**

| Criterio | Tarea |
|---|---|
| URLs sin `#` | 1, verificado en 17 |
| `index.html` con `lang`, título y `theme-color` | 15 |
| `build/web/vercel.json` existe tras el build | 15 |
| El workflow pasa en el PR | 17 |
| La URL de Vercel carga `/home` y `/explore` recarga sin 404 | 17 |
| README con URL, clonado y comando de un solo test | 16 y 17 |
| `CLAUDE.md` con el stack y los comandos reales | 16 |
| Integración por PR con merge commit, sin squash | 17 |

### Criterios que cambian respecto a la spec

- **PR a `develop`, no a `main`.** La spec se escribió antes de adoptar Gitflow. El criterio "la rama se integra en `main` por PR con merge commit" se cumple contra `develop`; `main` recibirá el trabajo en la `release/*` de la etapa correspondiente.
- **Criterios ya satisfechos por el demo** (plataformas, bundle IDs, `index.html`, `manifest.json`, `vercel.json`, base de la CI): no se recrean, se verifican.

---

## Notas para quien ejecute

- **Cada tarea es un commit.** No se acumulan dos tareas en un commit ni se parte una tarea en varios, salvo que un paso lo indique.
- **No inventes colores ni medidas.** Si un valor no está en este plan ni en `docs/references/imagen_corporativa_devtalles.md`, pregunta en vez de improvisar.
- **Los tests vienen escritos.** Escríbelos tal cual, comprueba que fallan, implementa, comprueba que pasan. Si un test está mal planteado, corrígelo y **di explícitamente qué cambiaste y por qué**; no lo relajes para que pase.
- **Las tareas 3 a 10 son independientes entre sí** salvo por los `import`. Si se ejecutan en paralelo, respeta el orden de dependencias: 3 → 4 → 5, y 8 antes que 9, 6 y 7 antes que 8.
- **Las tareas 11, 12 y 13 son secuenciales**: cada una modifica `app_shell.dart`.
- **Las tareas 4 (descarga de fuentes) y 17 (despliegue) tocan la red o cuentas del usuario.** La 4 descarga de `fonts.google.com`; la 17 la ejecuta el usuario.

---
