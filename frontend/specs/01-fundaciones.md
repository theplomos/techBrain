# SPEC 01 — Fundaciones del frontend Flutter

> **Estado:** Borrador
> **Depende de:** —
> **Fecha:** 2026-09-16
> **Objetivo:** Crear la base Flutter de TechBrain (tema DevTalles, shell responsive de 4 pestañas, widgets base, CI y primer despliegue web) sin ninguna funcionalidad de negocio.

## Por qué existe esta spec

Es la Etapa 1 de `docs/requerimiento_general_frontend.md` (§10) y cubre la base de RNF-01 a RNF-12.

Las etapas 2 a 7 heredan sus decisiones: el patrón de errores, los paths, los tokens, los enums de nivel y categoría, y el widget glass. Cambiarlas después obliga a tocar todas las features.

Esta spec se aparta del requerimiento en tres puntos, por decisión explícita:

- Las specs viven en `specs/` y no en `docs/superpowers/specs/`, porque `/spec-impl` solo lee `specs/`.
- De las dependencias de §7.1 solo se añaden las que usa esta etapa.
- Los paths de las pestañas están en inglés.

Durante la definición aparecieron dos hallazgos que afectan a otras etapas y no se resuelven aquí:

- `cursos_devtalles.json` ya incluye `capitulos` con sus `lecciones` en los 91 cursos, y la suma de lecciones coincide con `cantidad_lecciones` en todos. La Etapa 3 puede cerrar P-02 sin crear `temarios_devtalles.json`.
- Vercel, GitHub Actions, Riverpod y go_router sí aparecen en el catálogo, así que el riesgo de tecnologías de §13 es menor de lo que indica el requerimiento.

## Precondiciones

1. Los cambios de documentación que siguen pendientes en `main` están commiteados. Incluyen el traslado de `rutas_aprendizaje_devtalles.*` a `docs/references/`, `CLAUDE.md`, `docs/requerimiento_general_frontend.md` y esta spec.
2. El repositorio de GitHub se renombró de `theplomos/terchBrain` a `theplomos/techBrain`, y el remoto local apunta a `https://github.com/theplomos/techBrain.git`.
3. La rama `feature/project-setup` está creada desde `main` y activa. `/spec-impl` ofrecerá crear `spec-01-fundaciones`: se responde que no y se confirma que se trabaja en `feature/project-setup`.

## Alcance

**Dentro:**

- Proyecto Flutter en la raíz del repositorio: nombre `techbrain`, organización `dev.arcentales` y plataformas web, iOS y Android.
- Bundle ID de iOS y `applicationId` de Android: `dev.arcentales.techbrain`.
- Dependencias: `flutter_riverpod`, `riverpod_annotation`, `go_router`, `flutter_localizations` y `flutter_web_plugins`.
- Dependencias de desarrollo: `riverpod_generator`, `build_runner` y `flutter_lints`.
- `pubspec.lock` y los `.g.dart` generados se commitean.
- `analysis_options.yaml` basado en `flutter_lints`, que excluye `**/*.g.dart`.
- Interfaz en español: `locale` `es` con `flutter_localizations` y textos escritos en el código, sin ARB.
- URLs sin `#` gracias a `usePathUrlStrategy()`.
- Tema oscuro con los tokens de `docs/references/imagen_corporativa_devtalles.md`.
- Space Grotesk y DM Sans empaquetadas como assets.
- Fondo cósmico detrás de todas las rutas.
- `lib/config/env.dart` con `API_BASE_URL` y `AUTH_SOURCE`, y `.env.example`.
- Router con `StatefulShellRoute.indexedStack` y 4 ramas: `/home`, `/explore`, `/quiz` y `/settings`.
- `/` redirige a `/home`, y una ruta desconocida muestra `ErrorView`.
- Shell responsive: barra inferior flotante por debajo de 1024 px y barra superior a partir de 1024 px.
- Pantallas provisionales para las 4 pestañas. La de Home incluye un muestrario temporal de los widgets base.
- Widgets base: `GlassContainer`, `PillButton`, `LevelBadge`, `CategoryBadge`, `TechBrainLogo`, `CosmicBackground`, `ErrorView` y `ComingSoonView`.
- Enums `CourseLevel` y `CourseCategory` en `lib/shared/domain/`.
- `Failure` sellado en `lib/shared/errors/failure.dart`.
- `docs/references/cursos_devtalles.json` y `docs/references/rutas_aprendizaje_devtalles.json` declarados como assets en `pubspec.yaml`.
- `web/index.html` y `web/manifest.json` con el nombre, el idioma y los colores de TechBrain.
- `web/vercel.json` con reescrituras para las rutas de la SPA.
- Workflow de CI en `.github/workflows/ci.yml`.
- `README.md` con los pasos reales y `CLAUDE.md` actualizado con el stack y los comandos.
- Primer despliegue manual en Vercel, que hace el usuario, y la URL anotada en el README.

**Fuera de alcance (para futuras specs):**

- Login, ruta `/login`, guard de sesión en `redirect`, `dio`, `flutter_web_auth_2`, `flutter_secure_storage`, variante Discord de `PillButton` y `web/auth.html`. Etapa 2.
- Modelos `Course`, `OfficialRoute` y los demás de §7.4, sus mappers y la lectura real del catálogo. Etapa 3.
- `shared_preferences` y cualquier persistencia local. Etapa 4.
- Avatar y menú de usuario en la barra superior. Etapas 2 y 5.
- Iconos de la app, favicon y splash con la marca. Etapa 7.
- Despliegue automático desde CI. Etapa 7.
- Compilaciones de iOS y Android en CI.
- Reglas de protección de rama en GitHub, que son un ajuste del repositorio y no un archivo.
- Badge `WEB`, porque ningún curso lo usa.
- `temarios_devtalles.json` y la decisión P-02.

## Archivos que aparecen o cambian

```text
.github/workflows/ci.yml
.env.example
.gitignore                       # se añaden las entradas de Flutter
analysis_options.yaml
pubspec.yaml · pubspec.lock
README.md · CLAUDE.md
android/ · ios/ · web/           # generados por flutter create
web/index.html · web/manifest.json · web/vercel.json
assets/fonts/                    # 6 TTF y 2 licencias OFL
lib/
├── main.dart
├── app.dart
├── config/
│   ├── env.dart
│   ├── router/   app_routes.dart · app_router.dart · app_router.g.dart
│   └── theme/    app_colors.dart · app_tokens.dart · app_typography.dart · app_theme.dart
├── shared/
│   ├── domain/   course_level.dart · course_category.dart
│   ├── errors/   failure.dart
│   ├── layout/   app_shell.dart · app_bottom_nav_bar.dart · app_top_nav_bar.dart · app_tabs.dart · breakpoints.dart
│   └── widgets/  glass_container.dart · pill_button.dart · level_badge.dart · category_badge.dart
│                 tech_brain_logo.dart · cosmic_background.dart · error_view.dart · coming_soon_view.dart
└── features/
    ├── roadmap/presentation/screens/home_screen.dart
    ├── catalog/presentation/screens/explore_screen.dart
    ├── quiz/presentation/screens/quiz_screen.dart
    └── settings/presentation/screens/settings_screen.dart
test/                            # replica la estructura de lib/
```

## Modelo de datos

### Entorno

```dart
// lib/config/env.dart
enum AuthSource {
  api,
  mock;

  /// 'api' → api, 'mock' → mock y cualquier otro valor → null.
  static AuthSource? tryParse(String value);
}

abstract final class Env {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.techbrain.arcentales.dev/api',
  );

  /// Lee AUTH_SOURCE, que por defecto vale 'api'.
  /// Un valor desconocido cae en api y dispara un assert en debug.
  static AuthSource get authSource;
}
```

```text
# .env.example (opcional)
# Uso: flutter run -d chrome --web-port 8080 --dart-define-from-file=.env
API_BASE_URL=https://api.techbrain.arcentales.dev/api
AUTH_SOURCE=api
```

### Errores

```dart
// lib/shared/errors/failure.dart
sealed class Failure implements Exception {
  const Failure(this.message);
  final String message; // Texto para el usuario, en español.
}

final class NetworkFailure extends Failure { /* ... */ }      // Sin conexión o timeout.
final class ServerFailure extends Failure { final int? statusCode; } // 5xx o respuesta inválida.
final class UnauthorizedFailure extends Failure { /* ... */ } // 401 que el refresh no recupera.
final class NotFoundFailure extends Failure { /* ... */ }     // Recurso o ruta inexistente.
final class LocalDataFailure extends Failure { /* ... */ }    // Error al leer assets o datos locales.
final class UnexpectedFailure extends Failure { final Object? cause; }
```

| Subtipo | Mensaje por defecto |
|---|---|
| `NetworkFailure` | No hay conexión. Revisa tu red e inténtalo de nuevo. |
| `ServerFailure` | El servidor no respondió como esperábamos. Inténtalo más tarde. |
| `UnauthorizedFailure` | Tu sesión expiró. Inicia sesión de nuevo. |
| `NotFoundFailure` | No encontramos lo que buscas. |
| `LocalDataFailure` | No pudimos leer los datos de la app. |
| `UnexpectedFailure` | Algo salió mal. Inténtalo de nuevo. |

Reglas:

- Los repositorios lanzan `Failure`, y Riverpod la expone como `AsyncValue.error`.
- `ErrorView` recibe un `Object`. Si es una `Failure`, muestra su `message`; si no, muestra el mensaje de `UnexpectedFailure`.
- Como la clase es `sealed`, los subtipos nuevos se añaden en el mismo archivo. La Etapa 2 añadirá ahí los de autenticación.

### Dominio compartido

```dart
// lib/shared/domain/course_level.dart
enum CourseLevel {
  required('REQUERIDO', 'Requerido'),
  recommended('RECOMENDADO', 'Recomendado'),
  optional('OPCIONAL PERO MUY ÚTIL', 'Opcional');

  const CourseLevel(this.datasetValue, this.label);
  final String datasetValue; // Valor exacto en rutas_aprendizaje_devtalles.json.
  final String label;        // Texto visible.

  /// Lanza LocalDataFailure si el valor no coincide exactamente.
  static CourseLevel fromDataset(String value);
}

// lib/shared/domain/course_category.dart
enum CourseCategory {
  bases('BASES'),
  frontend('FRONTEND'),
  backend('BACKEND'),
  mobile('MÓVIL'),
  aiAgents('AGENTES IA'),
  fullstack('FULLSTACK');

  const CourseCategory(this.datasetValue);
  final String datasetValue; // Valor exacto en el dataset y texto visible del chip.

  /// Lanza LocalDataFailure si el valor no coincide exactamente.
  static CourseCategory fromDataset(String value);
}
```

Convenciones:

- El orden de declaración de `CourseLevel` es el orden de fuerza: Requerido > Recomendado > Opcional. La Etapa 3 lo usa para deduplicar y la Etapa 4 para calcular las fechas.
- La comparación con el dataset es exacta: no se normalizan mayúsculas ni tildes.

### Tokens de diseño

`AppColors` (en `lib/config/theme/app_colors.dart`) define como `const Color` todos los valores de las tablas siguientes. Los valores con transparencia usan `Color.fromRGBO`.

| Grupo | Token | Valor |
|---|---|---|
| Fondos | `bgPrimary` · `bgBox` | `#171027` · `#1c1829` |
| Fondos | `cardBg` · `navBg` | `rgba(28, 24, 41, 0.85)` · `rgba(23, 16, 39, 0.85)` |
| Bordes | `cardBorder` · `cardBorderHover` | `rgba(192, 185, 252, 0.12)` · `rgba(192, 185, 252, 0.30)` |
| Acentos | `accentElectric` · `accentMid` · `accentDeep` | `#3a14c4` · `#4725af` · `#5a16c1` |
| Acentos | `accentLavender` · `accentVivid` · `brandDiscord` | `#c0b9fc` · `#c8dd09` · `#5865F2` |
| Texto | `textMain` · `textMuted` · `textSub` | `#f0eeff` · `#9b93c8` · `rgba(192, 185, 252, 0.55)` |
| Texto | `textOnVivid` | `#0F172A` |

Chips de nivel y de categoría:

| Chip | Fondo | Borde | Contenido |
|---|---|---|---|
| `CourseLevel.required` | `rgba(239, 68, 68, 0.15)` | `rgba(239, 68, 68, 0.40)` | `Icons.hexagon` en `#ef4444` + `REQUERIDO` |
| `CourseLevel.recommended` | `rgba(200, 221, 9, 0.15)` | `rgba(200, 221, 9, 0.40)` | `Icons.star` en `#c8dd09` + `RECOMENDADO` |
| `CourseLevel.optional` | `rgba(192, 185, 252, 0.15)` | `rgba(192, 185, 252, 0.30)` | `Icons.circle` en `#c0b9fc` + `OPCIONAL` |
| `CourseCategory.bases` | `rgba(192, 185, 252, 0.20)` | `#c0b9fc` | `BASES` |
| `CourseCategory.frontend` | `rgba(48, 10, 111, 0.55)` | `#7e70f9` | `FRONTEND` |
| `CourseCategory.backend` | `rgba(58, 20, 196, 0.50)` | `#3a14c4` | `BACKEND` |
| `CourseCategory.mobile` | `rgba(200, 221, 9, 0.25)` | `#c8dd09` | `MÓVIL` |
| `CourseCategory.aiAgents` | `rgba(162, 0, 255, 0.35)` | `#a200ff` | `AGENTES IA` |
| `CourseCategory.fullstack` | `rgba(244, 174, 163, 0.25)` | `#f4aea3` | `FULLSTACK` |

`lib/config/theme/app_tokens.dart`:

| Clase | Token | Valor |
|---|---|---|
| `AppRadii` | `card` · `inner` · `pill` | `18` · `10` · `50` |
| `AppShadows` | `glowSm` | Anillo de 1 px `rgba(192, 185, 252, 0.06)` + `0 8 32 rgba(58, 20, 196, 0.18)` |
| `AppShadows` | `glowLg` | Anillo de 1 px `rgba(192, 185, 252, 0.10)` + `0 16 48 rgba(58, 20, 196, 0.35)` |
| `AppShadows` | `buttonPrimary` · `buttonPrimaryHover` | `0 4 14 rgba(58, 20, 196, 0.39)` · `0 8 24 rgba(58, 20, 196, 0.55)` |
| `AppShadows` | `buttonVivid` · `buttonVividHover` | `0 0 20 rgba(200, 221, 9, 0.35)` · `0 0 30 rgba(200, 221, 9, 0.60)` |
| `AppMotion` | `hover` · `hoverCurve` | `200 ms` · `Cubic(0.16, 1, 0.3, 1)` |
| `AppBlur` | `bar` | Sigma `16` |

### Tipografía

| Familia en `pubspec.yaml` | Archivo | Peso |
|---|---|---|
| `SpaceGrotesk` | `assets/fonts/SpaceGrotesk-Medium.ttf` | 500 |
| `SpaceGrotesk` | `assets/fonts/SpaceGrotesk-SemiBold.ttf` | 600 |
| `SpaceGrotesk` | `assets/fonts/SpaceGrotesk-Bold.ttf` | 700 |
| `DMSans` | `assets/fonts/DMSans-Regular.ttf` | 400 |
| `DMSans` | `assets/fonts/DMSans-Medium.ttf` | 500 |
| `DMSans` | `assets/fonts/DMSans-Bold.ttf` | 700 |

- Son los TTF estáticos de la descarga oficial de Google Fonts. Sus licencias van en `assets/fonts/SpaceGrotesk-OFL.txt` y `assets/fonts/DMSans-OFL.txt`.
- En el `TextTheme`, los estilos `display*`, `headline*` y `title*` usan `SpaceGrotesk` (700 en display y 600 en el resto), y `body*` y `label*` usan `DMSans`. Los tamaños son los de Material 3.
- `AppTextStyles` (en `app_typography.dart`) añade estos estilos:
  - `button`: `DMSans` 500, 13 px y `letterSpacing` 2.
  - `buttonVivid`: `DMSans` 700, 13 px y `letterSpacing` 1.5.
  - `chip`: `DMSans` 500, 11 px y `letterSpacing` 1.5.
  - `columnHeader`: `DMSans` 500, 11 px, `letterSpacing` 2.5 y color `textSub`.

### Navegación

```dart
// lib/config/router/app_routes.dart
abstract final class AppRoutes {
  static const home = '/home';
  static const explore = '/explore';
  static const quiz = '/quiz';
  static const settings = '/settings';
}

// lib/shared/layout/app_tabs.dart
typedef AppTab = ({String path, String label, IconData icon, IconData selectedIcon});

const appTabs = <AppTab>[
  (path: AppRoutes.home, label: 'Home', icon: Icons.home_outlined, selectedIcon: Icons.home_rounded),
  (path: AppRoutes.explore, label: 'Explorar', icon: Icons.explore_outlined, selectedIcon: Icons.explore),
  (path: AppRoutes.quiz, label: 'Cuestionarios', icon: Icons.quiz_outlined, selectedIcon: Icons.quiz),
  (path: AppRoutes.settings, label: 'Configuración', icon: Icons.settings_outlined, selectedIcon: Icons.settings),
];

// lib/shared/layout/breakpoints.dart
abstract final class Breakpoints {
  static const desktop = 1024.0;        // A partir de aquí, barra superior.
  static const minSupported = 360.0;
  static const maxContentWidth = 1200.0;
}
```

`appRouterProvider` se genera con `@Riverpod(keepAlive: true)` en `lib/config/router/app_router.dart`.

## Componentes y layout

### App

- `lib/main.dart` llama a `usePathUrlStrategy()` y ejecuta `ProviderScope(child: TechBrainApp())`.
- `TechBrainApp` (en `lib/app.dart`) es un `MaterialApp.router` con esta configuración:
  - `title` `'TechBrain'`, `theme` `AppTheme.dark` y `debugShowCheckedModeBanner` a false.
  - `locale` `Locale('es')`, con los delegates de `flutter_localizations`.
  - `routerConfig` sale de `ref.watch(appRouterProvider)`.
  - `builder` envuelve cada ruta en `CosmicBackground`.
- `AppTheme.dark`:
  - `Brightness.dark` y `scaffoldBackgroundColor` transparente.
  - `ColorScheme.dark` con `primary` `accentElectric`, `secondary` `accentVivid`, `surface` `bgBox`, `onSurface` `textMain` y `error` `#ef4444`.

### Widgets base

**`GlassContainer({required child, blur = false, color = AppColors.cardBg, borderRadius = AppRadii.card, padding, onTap, semanticLabel})`**

- Borde de 1 px `cardBorder` y sombra `glowSm`.
- Con `blur: true` aplica un `BackdropFilter` con sigma `AppBlur.bar`. Solo lo usan las barras de navegación.
- Con `onTap`, al pasar el cursor o recibir el foco, sube 4 px, el borde pasa a `cardBorderHover` y la sombra a `glowLg`. Usa `AppMotion.hover` y `AppMotion.hoverCurve`.
- Con `onTap`, Enter y Espacio lo activan.
- Si `MediaQuery.disableAnimationsOf(context)` es true, no hay desplazamiento.

**`PillButton({required label, required onPressed, variant = PillButtonVariant.primary, icon})`**

| Variante | Fondo | Texto | Borde | Sombra | Hover |
|---|---|---|---|---|---|
| `primary` | Degradado de 135° de `accentMid` a `accentElectric` | Blanco, `AppTextStyles.button` | — | `buttonPrimary` | `buttonPrimaryHover` |
| `secondary` | Transparente | `textMain`, `AppTextStyles.button` | 2 px `accentLavender` | — | Fondo `rgba(192, 185, 252, 0.12)` y borde blanco |
| `vivid` | `accentVivid` | `textOnVivid`, `AppTextStyles.buttonVivid` | — | `buttonVivid` | `buttonVividHover` |

- El texto va en mayúsculas, con radio `AppRadii.pill`, padding de 13 × 28 px y altura mínima de 44 px.
- En hover y foco, el botón sube 2 px.
- `onPressed: null` lo deshabilita: opacidad 0,5 y sin efecto hover.
- Según el §4.2 del sistema de diseño, cada pantalla tiene como máximo un botón `vivid`.

**`LevelBadge(CourseLevel level)` y `CategoryBadge(CourseCategory category)`**

- Son chips con radio `AppRadii.pill`, borde de 1 px, colores de la tabla de chips y texto `AppTextStyles.chip` en `textMain`.
- `LevelBadge` muestra el icono de su nivel a 14 px y `label.toUpperCase()`.
- `CategoryBadge` muestra `datasetValue`.
- Etiquetas semánticas: `Nivel: Requerido` y `Categoría: FRONTEND`.

**Otros widgets**

- `TechBrainLogo({fontSize = 22})`:
  - Muestra `{tech/brain}` en `SpaceGrotesk` 700.
  - Las llaves van en `accentLavender` y `tech/brain` en `textMain`.
  - Su etiqueta semántica es `TechBrain`.
- `CosmicBackground({required child})`:
  - Pinta `bgPrimary` con los dos degradados radiales del fondo espacial del sistema de diseño.
  - Ocupa todo el viewport y no se desplaza con el contenido.
- `ErrorView({required Object error, VoidCallback? onRetry, String retryLabel = 'Reintentar'})`:
  - Muestra un `GlassContainer` centrado de 420 px de ancho máximo, con `Icons.error_outline` en `accentLavender` y el mensaje.
  - Si `onRetry` no es null, añade un `PillButton` `secondary` con `retryLabel`.
- `ComingSoonView({required String title, required int stage})`: muestra el título en Space Grotesk y el texto `Disponible en la Etapa <stage>.` dentro de un `GlassContainer`.

### Shell y router

- El router arranca en `AppRoutes.home`, y un `redirect` global lleva `/` a `/home`.
- `errorBuilder` muestra `ErrorView(error: NotFoundFailure(), onRetry: () => context.go(AppRoutes.home), retryLabel: 'Ir a Home')` sin barras de navegación.
- `AppShell(navigationShell)` elige la barra según el ancho: `AppBottomNavBar` por debajo de `Breakpoints.desktop` y `AppTopNavBar` a partir de ahí.
- Al pulsar una pestaña se llama a `navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex)`.
- **Por debajo de 1024 px:**
  - `Scaffold(extendBody: true)` con `AppBottomNavBar` como `bottomNavigationBar`. El contenido pasa por detrás de la barra y recibe su altura como padding inferior.
  - La barra es un `GlassContainer(blur: true, color: AppColors.navBg)` flotante, con 16 px de margen lateral e inferior y el área segura.
  - Cada una de las 4 pestañas muestra el icono sobre la etiqueta.
  - La pestaña activa tiene fondo con degradado de `accentMid` a `accentElectric`, radio `AppRadii.inner`, `selectedIcon` y texto `textMain`. Las inactivas usan `textMuted`.
  - El contenido lleva 16 px de padding horizontal.
- **A partir de 1024 px:**
  - `Scaffold(extendBodyBehindAppBar: true)` con `AppTopNavBar` de 72 px de alto.
  - La barra es un `GlassContainer(blur: true, color: AppColors.navBg, borderRadius: 0)` con borde inferior `cardBorder`.
  - Tiene `TechBrainLogo` a la izquierda y las 4 pestañas a la derecha, cada una con icono y etiqueta.
  - La pestaña activa va en `textMain` con un indicador inferior de 2 px en `accentVivid`. Las inactivas usan `textMuted`.
  - El contenido se centra con un ancho máximo de `Breakpoints.maxContentWidth` y 32 px de padding horizontal.
- **Accesibilidad de las pestañas (RNF-11):**
  - Área mínima de 44 × 44 px.
  - `Semantics` con `button`, `selected` y `label`.
  - Se enfocan con Tab y se activan con Enter o Espacio.
  - Anillo de foco de 2 px en `accentLavender`.

### Pantallas provisionales

| Pantalla | Archivo | Contenido |
|---|---|---|
| `HomeScreen` | `features/roadmap/presentation/screens/home_screen.dart` | `ComingSoonView(title: 'Home', stage: 4)` y la sección "Muestrario de componentes (temporal)" |
| `ExploreScreen` | `features/catalog/presentation/screens/explore_screen.dart` | `ComingSoonView(title: 'Explorar', stage: 3)` |
| `QuizScreen` | `features/quiz/presentation/screens/quiz_screen.dart` | `ComingSoonView(title: 'Cuestionarios', stage: 6)` |
| `SettingsScreen` | `features/settings/presentation/screens/settings_screen.dart` | `ComingSoonView(title: 'Configuración', stage: 5)` |

El muestrario de Home es una lista desplazable con:

- Las 3 variantes de `PillButton`, más una deshabilitada.
- Los 3 `LevelBadge`.
- Los 6 `CategoryBadge`.
- Un `GlassContainer` con `onTap` que no hace nada.

Se elimina en la Etapa 4.

### Web y despliegue

- `web/index.html`:
  - `<html lang="es">`, `<title>TechBrain</title>` y `<meta name="theme-color" content="#171027">`.
  - `<meta name="description" content="Rutas de aprendizaje personalizadas con los cursos de DevTalles.">`.
  - `background-color: #171027` en el `body`, para que no haya un destello blanco mientras carga.
- `web/manifest.json`: `name` y `short_name` `TechBrain`, `background_color` y `theme_color` `#171027`, y la misma descripción.
- `web/vercel.json` reescribe `/(.*)` a `/index.html`.
  - Vercel sirve primero los archivos que existen, así que `main.dart.js`, `flutter_bootstrap.js` y `assets/` no se reescriben.
  - `flutter build web` copia este archivo a `build/web/`.
- Despliegue manual, que hace el usuario con su cuenta:
  1. `flutter build web --release`.
  2. `npx vercel@latest deploy build/web --prod`. El nombre sugerido para el proyecto es `techbrain`.
  3. La URL resultante se anota en el README y se comparte con el backend para DEP-02 y DEP-05.

### CI

`.github/workflows/ci.yml`:

- Se ejecuta en `pull_request` hacia `main` y en `push` a `main`, con `permissions: contents: read`.
- Un `concurrency` por ref cancela la ejecución anterior.
- Hay un único job en `ubuntu-latest`, con `actions/checkout` y `subosito/flutter-action` en su última versión mayor. Usa Flutter `3.47.0` del canal stable, con caché.
- Pasos, en este orden:
  1. `flutter pub get`.
  2. `dart format --output=none --set-exit-if-changed` sobre los `.dart` versionados que no terminan en `.g.dart`.
  3. `dart run build_runner build --delete-conflicting-outputs`.
  4. `test -z "$(git status --porcelain)"`, que falla si los `.g.dart` commiteados no están al día.
  5. `flutter analyze`.
  6. `flutter test`.
  7. `flutter build web --release`.

### Documentación

- `README.md` conserva la descripción del proyecto y el equipo. Estas secciones se sustituyen o se añaden:
  - **Requisitos:** Flutter 3.47.0 stable (Dart 3.13) y Chrome. Xcode y el SDK de Android solo hacen falta para móvil.
  - **Ejecutar:** `git clone https://github.com/theplomos/techBrain.git`, `flutter pub get` y `flutter run -d chrome --web-port 8080`.
  - **Configuración opcional:** tabla de variables, copia de `.env.example` y uso de `--dart-define-from-file=.env`.
  - **Móvil:** `flutter run -d <dispositivo>`.
  - **Calidad:** `flutter analyze`, `flutter test` y un solo test (`flutter test test/<ruta>_test.dart` o `--plain-name "<nombre>"`).
  - **Código generado:** `dart run build_runner build --delete-conflicting-outputs`. Los `.g.dart` se commitean.
  - **Despliegue:** los pasos manuales de Vercel y la URL de producción.
  - **Estructura del repositorio:** actualizada con `lib/`, `test/`, `web/`, `specs/` y `docs/references/`.
- `CLAUDE.md`:
  - "Estado del proyecto" indica que el stack es Flutter según `docs/requerimiento_general_frontend.md` y enumera los comandos reales.
  - La ruta de `rutas_aprendizaje_devtalles.json` pasa a `docs/references/`.
  - Menciona que las specs están en `specs/`.

## Plan de implementación

1. **Proyecto base.**
   - Ejecutar `flutter create --project-name techbrain --org dev.arcentales --platforms web,ios,android .`, que no sobrescribe `README.md`, `LICENSE` ni `.gitignore`.
   - Añadir a `.gitignore` `.flutter-plugins`, `.flutter-plugins-dependencies`, `.pub-cache/`, `.pub/`, `*.iml`, `.idea/` y `.vercel`.
   - Poner `publish_to: 'none'` en `pubspec.yaml`.
   - Sustituir la app contador por un `TechBrainApp` mínimo en `lib/app.dart` que muestre el texto `TechBrain`.
   - Sustituir `test/widget_test.dart` por un test de humo en `test/app_test.dart`.
   - Comprobación: `flutter analyze` y `flutter test` pasan, y `flutter run -d chrome --web-port 8080` muestra el texto.
2. **Lints, idioma y URLs.**
   - Crear `analysis_options.yaml` y añadir `flutter_localizations` y `flutter_web_plugins`.
   - Configurar `locale` `es` y los delegates en `TechBrainApp`, y llamar a `usePathUrlStrategy()` en `main.dart`.
   - Comprobación: la app abre en `http://localhost:8080/` sin `#` y `flutter analyze` no da avisos.
3. **Entorno.**
   - Crear `lib/config/env.dart`, `.env.example` y `test/config/env_test.dart`.
   - Comprobación: el test confirma los valores por defecto y que `AuthSource.tryParse` devuelve `api`, `mock` o `null`.
4. **Fuentes y tipografía.**
   - Añadir los 6 TTF y las 2 licencias OFL en `assets/fonts/`, declararlos en `pubspec.yaml` y crear `app_typography.dart`.
   - Comprobación: en Chrome, el texto de prueba se ve en DM Sans y un título en Space Grotesk.
5. **Colores, tokens, tema y fondo.**
   - Crear `app_colors.dart`, `app_tokens.dart`, `app_theme.dart` y `CosmicBackground`, y aplicarlos en `TechBrainApp` (`theme` y `builder`).
   - Añadir `test/config/theme/app_theme_test.dart`.
   - Comprobación: en Chrome se ve el fondo cósmico.
6. **`GlassContainer` y `TechBrainLogo`.**
   - Crear los dos widgets y sus tests.
   - Comprobación: los tests confirman que `onTap` se dispara con toque, con Enter y con Espacio, y que el `BackdropFilter` solo existe con `blur: true`.
7. **`PillButton`.**
   - Crear el widget con sus 3 variantes y sus tests.
   - Comprobación: los tests confirman la etiqueta en mayúsculas, la altura mínima de 44 px, `onPressed` y el estado deshabilitado.
8. **`Failure` y `ErrorView`.**
   - Crear `failure.dart`, `error_view.dart` y sus tests.
   - Comprobación: los tests confirman los mensajes por defecto, el mensaje genérico ante un error que no es `Failure` y que el botón solo aparece con `onRetry`.
9. **Enums y assets de datos.**
   - Crear `course_level.dart` y `course_category.dart` con sus tests, y declarar los dos JSON de `docs/references/` en `pubspec.yaml`.
   - Añadir `test/shared/domain/dataset_values_test.dart`, que carga los JSON con `rootBundle`.
   - Comprobación: todos los `nivel` y `categoria` de las rutas se convierten sin error, y el catálogo carga 91 cursos.
10. **Badges.**
    - Crear `LevelBadge` y `CategoryBadge` con sus tests.
    - Comprobación: los tests confirman el texto y la etiqueta semántica de cada valor, y los colores de `CourseCategory.fullstack`.
11. **Router y pantallas provisionales.**
    - Añadir `flutter_riverpod`, `riverpod_annotation`, `go_router`, `riverpod_generator` y `build_runner`.
    - Crear `app_routes.dart`, `app_router.dart` con su `.g.dart` generado, `ComingSoonView` y las 4 pantallas.
    - Crear un `AppShell` que por ahora solo muestra `navigationShell`.
    - Pasar a `ProviderScope` y `MaterialApp.router`.
    - Añadir `test/config/router/app_router_test.dart`.
    - Comprobación: en Chrome, escribir `/quiz` en la barra de direcciones muestra el placeholder de Cuestionarios.
12. **Barra inferior.**
    - Crear `app_tabs.dart`, `breakpoints.dart` y `AppBottomNavBar`, y usar la barra en `AppShell` a cualquier ancho.
    - Añadir `test/shared/layout/app_shell_test.dart`.
    - Comprobación: a 390 px se navega entre las 4 pestañas.
13. **Barra superior.**
    - Crear `AppTopNavBar` y hacer que `AppShell` cambie de barra en 1024 px, con el ancho máximo de contenido.
    - Ampliar `app_shell_test.dart` con anchos de 1023 y 1280 px.
    - Comprobación: al redimensionar Chrome, la barra cambia en 1024 px.
14. **Muestrario en Home.**
    - Añadir el muestrario temporal a `HomeScreen`.
    - Comprobación: en Chrome a 360 px y a 1280 px se ven todas las variantes sin errores de overflow.
15. **Web.**
    - Actualizar `web/index.html` y `web/manifest.json`, y crear `web/vercel.json`.
    - Comprobación: `flutter build web --release` genera `build/web/vercel.json`.
16. **CI.**
    - Crear `.github/workflows/ci.yml`.
    - Comprobación: al abrir el PR de `feature/project-setup` a `main`, todos los pasos del workflow pasan.
17. **Documentación.**
    - Actualizar `README.md` y `CLAUDE.md`.
    - Comprobación: seguir el README desde un clon limpio levanta la app.
18. **Primer despliegue.**
    - El usuario despliega en Vercel siguiendo los pasos manuales, y se anota la URL de producción en el README.

## Criterios de aceptación

**Proyecto y plataformas**

- [ ] Existen `android/`, `ios/` y `web/` en la raíz del repositorio.
- [ ] `PRODUCT_BUNDLE_IDENTIFIER` de `ios/Runner.xcodeproj/project.pbxproj` y `applicationId` de `android/app/build.gradle.kts` valen `dev.arcentales.techbrain`.
- [ ] `flutter analyze` termina con "No issues found!".
- [ ] `flutter test` pasa sin fallos.
- [ ] Tras `dart run build_runner build --delete-conflicting-outputs`, `git status --porcelain` no muestra nada.
- [ ] `flutter build web --release`, `flutter build apk --debug` y `flutter build ios --debug --no-codesign` terminan sin errores en local.
- [ ] `pubspec.yaml` no contiene `dio`, `flutter_web_auth_2`, `flutter_secure_storage` ni `shared_preferences`.
- [ ] En un clon limpio y sin `.env`, `flutter pub get` seguido de `flutter run -d chrome --web-port 8080` abre la app en `http://localhost:8080/home`.

**Navegación y layout**

- [ ] Abrir `http://localhost:8080/` redirige a `/home`.
- [ ] Abrir directamente `/explore`, `/quiz` o `/settings` muestra su pantalla con la pestaña marcada como activa.
- [ ] Abrir `/no-existe` muestra "No encontramos lo que buscas.", y el botón "IR A HOME" lleva a `/home`.
- [ ] Un test comprueba que a 390 px aparece `AppBottomNavBar` y no `AppTopNavBar`.
- [ ] Un test comprueba que a 1023 px aparece `AppBottomNavBar` y a 1024 px aparece `AppTopNavBar`.
- [ ] Un test comprueba que a 1280 px aparece `AppTopNavBar` con `TechBrainLogo` y no `AppBottomNavBar`.
- [ ] Un test comprueba que al pulsar "Explorar" en la barra inferior se muestra `ExploreScreen`.
- [ ] Un test a 360 px no registra excepciones de overflow (`tester.takeException()` es null).
- [ ] Un test comprueba que cada pestaña de navegación y cada `PillButton` miden al menos 44 × 44 px.
- [ ] En Chrome, la tecla Tab recorre las 4 pestañas con un anillo de foco visible, y Enter navega a la pestaña enfocada.

**Tema y widgets**

- [ ] Un test comprueba que `AppTheme.dark` tiene `Brightness.dark`, títulos con `SpaceGrotesk` y cuerpo con `DMSans`.
- [ ] Todas las pantallas se ven sobre el fondo cósmico `#171027`, también la de error.
- [ ] Un test comprueba que `CategoryBadge(CourseCategory.fullstack)` usa fondo `rgba(244, 174, 163, 0.25)` y borde `#f4aea3`.
- [ ] Un test comprueba que `LevelBadge` muestra `REQUERIDO`, `RECOMENDADO` y `OPCIONAL` con sus etiquetas semánticas.
- [ ] Un test comprueba que `GlassContainer` solo contiene un `BackdropFilter` con `blur: true`.
- [ ] Un test comprueba que `ErrorView` muestra el botón de reintento solo cuando recibe `onRetry`, y que llama al callback al pulsarlo.
- [ ] Un test comprueba que `ErrorView` con un `StateError` muestra "Algo salió mal. Inténtalo de nuevo."
- [ ] La Home muestra las 3 variantes de `PillButton`, un botón deshabilitado, los 3 `LevelBadge` y los 6 `CategoryBadge`.

**Datos y entorno**

- [ ] Un test comprueba que todos los `nivel` y `categoria` de `docs/references/rutas_aprendizaje_devtalles.json`, cargados con `rootBundle`, se convierten con `fromDataset` sin excepciones.
- [ ] Un test comprueba que `docs/references/cursos_devtalles.json`, cargado con `rootBundle`, contiene 91 cursos.
- [ ] Un test comprueba que `fromDataset('Requerido')` lanza `LocalDataFailure`.
- [ ] Un test comprueba que sin defines `Env.apiBaseUrl` vale `https://api.techbrain.arcentales.dev/api` y `Env.authSource` vale `AuthSource.api`.
- [ ] `.env.example` está versionado y `.env` está en `.gitignore`.

**Web, CI y entrega**

- [ ] Las URLs de la app no contienen `#`.
- [ ] `web/index.html` tiene `lang="es"`, título `TechBrain` y `theme-color` `#171027`.
- [ ] `build/web/vercel.json` existe tras `flutter build web --release`.
- [ ] El workflow `CI` pasa todos sus pasos en el PR de `feature/project-setup` a `main`.
- [ ] La URL de Vercel carga `/home`, y recargar el navegador en `/explore` muestra la app en lugar de un 404 de Vercel.
- [ ] El README contiene la URL de producción, los pasos de clonado y ejecución, y el comando para lanzar un solo test.
- [ ] `CLAUDE.md` ya no dice que no hay código ni que el stack está sin decidir, e incluye los comandos reales.
- [ ] La rama `feature/project-setup` se integra en `main` por PR con merge commit, sin squash.

## Decisiones

- **Sí:** specs en `specs/`. **No:** `docs/superpowers/specs/`, porque `/spec-impl` no lo lee.
- **Sí:** rama `feature/project-setup` creada a mano, con `AutoCreateBranch: false`. **No:** `spec-01-fundaciones`, porque rompe la convención `feature/*` de RNF-10 que evalúa el jurado.
- **Sí:** una sola spec para la Etapa 1, con pasos commiteables. **No:** dividirla en dos, porque duplicaría ramas y PR dentro de una misma etapa.
- **Sí:** añadir solo las dependencias que usa esta etapa. **No:** todas las de §7.1, porque entrarían paquetes sin usar y configuración nativa sin probar.
- **Sí:** `Failure` sellada que se lanza como excepción y se recoge con `AsyncValue`. **No:** un `Result<T>` propio, porque duplica lo que ya hace `AsyncValue`. **No:** `fpdart` ni `dartz`, porque no aparecen en el catálogo (RNF-04).
- **Sí:** paths en inglés (`/home`, `/explore`, `/quiz`, `/settings`), alineados con las carpetas de features. **No:** paths en español.
- **Sí:** declarar los JSON directamente desde `docs/references/`. **No:** copiarlos a `assets/data/`, porque sería una tercera copia que sincronizar a mano. **No:** moverlos, porque obliga a actualizar toda la documentación que los cita.
- **Sí:** un único `GlassContainer` reutilizable, con `blur` apagado por defecto y activado solo en las barras. **No:** blur siempre, por el coste de rendimiento con listas largas. **No:** sin blur nunca, porque las barras perderían el efecto de vidrio.
- **Sí:** bundle ID `dev.arcentales.techbrain`, el dominio que ya usa el equipo para la API. **No:** `io.github.theplomos.techbrain`.
- **Sí:** CI completa en Ubuntu. **No:** CI mínima, porque no detectaría un `.g.dart` desactualizado ni que la web deje de compilar. **No:** compilaciones móviles en CI, por el coste en minutos de macOS. iOS y Android se comprueban en local.
- **Sí:** despliegue manual con Vercel CLI, hecho por el usuario. **No:** la integración de Vercel con GitHub, porque su imagen no trae Flutter. **No:** aplazar el despliegue, porque el backend necesita el dominio para DEP-02 y DEP-05.
- **Sí:** FULLSTACK con los tokens de WEB, que ninguna categoría usa. **No:** un degradado de FRONTEND a BACKEND, porque es un estilo nuevo que en un chip pequeño se distingue poco. **No:** enum `WEB`, porque no hay datos que lo usen.
- **Sí:** logotipo `{tech/brain}` con el estilo DevTalles. **No:** `{dev/talles}`, porque confunde la app con la plataforma oficial.
- **Sí:** enums en `lib/shared/domain/`. **No:** en `lib/features/catalog/domain/`, porque `shared/` dependería de una feature.
- **Sí:** renombrar el repositorio a `techBrain` antes de empezar, para que el README y el jurado vean el nombre correcto.
- **Sí:** radio de tarjeta de 18 px, como piden RNF-03 y `CLAUDE.md`. **No:** los 16 px del §4.4 del sistema de diseño, que contradicen ambos.
- **Sí:** fondo de BASES `rgba(192, 185, 252, 0.20)`, de la tabla de tokens (§2.4). **No:** el 0.25 de `tailwind.config.js`, porque ese archivo deriva de la tabla.
- **Sí:** bordes de nivel con el color base y la opacidad de la clase Tailwind (40 %, 40 % y 30 %). **No:** los colores `rose-500` y `lime-400` de Tailwind, que están fuera del sistema.
- **Sí:** símbolos de nivel con `Icons.hexagon`, `Icons.star` e `Icons.circle`. **No:** los glifos ⬢ ★ ●, porque no están en las fuentes empaquetadas y en web se descargarían fuentes de respaldo.
- **Sí:** TTF estáticos, uno por peso. **No:** fuentes variables, porque `FontWeight` no selecciona el eje `wght` de forma fiable en todas las plataformas. **No:** el paquete `google_fonts`, porque descarga las fuentes en tiempo de ejecución y RNF-03 pide empaquetarlas.
- **Sí:** `flutter_lints`, que viene con `flutter create`. **No:** `very_good_analysis`, porque no aparece en el catálogo y añade fricción con un plazo corto.
- **Sí:** `CosmicBackground` en el `builder` de `MaterialApp.router`, para que cubra todas las rutas, también la de error.
- **Sí:** `HomeScreen` provisional en `features/roadmap/`, porque la implementa la Etapa 4 (Rutas, progreso y Home) y §7.2 no tiene feature `home`.
- **Sí:** `usePathUrlStrategy()` para URLs limpias. **No:** URLs con `#`, porque ensucian la dirección visible.
- **Sí:** `TechBrainApp` en `lib/app.dart`, para poder montarla en los tests. §7.2 solo nombra `main.dart`.
- **Sí:** textos en español escritos en el código. **No:** ARB ni `intl` para traducciones, porque solo hay un idioma (RNF-12).
- **Sí:** muestrario temporal en Home, para revisar los widgets en el despliegue. Se elimina en la Etapa 4.
- **Sí:** un `AUTH_SOURCE` desconocido cae en `api` con un assert en debug. **No:** fallar al arrancar en release, porque la demo quedaría en blanco.

## Riesgos

| Riesgo | Mitigación |
|---|---|
| `flutter create .` en un directorio con archivos | Sin `--overwrite` no pisa los existentes. Se revisa `git status` al terminar el paso 1. |
| Alguien mueve o renombra un JSON de `docs/references/` | `dataset_values_test.dart` falla en CI. |
| Al ser `sealed`, `Failure` obliga a editar `shared/` para añadir subtipos | Se acepta y queda documentado. Son pocos subtipos y así los `switch` son exhaustivos. |
| `dart format` reformatea los `.g.dart` y rompe la CI | La CI excluye los archivos generados del chequeo de formato. |
| `BackdropFilter` es costoso en web | Solo lo usan las dos barras de navegación. |
| Vercel CLI intenta detectar un framework al desplegar `build/web` | La carpeta no tiene `package.json` y se despliega como estática. Si falla, la alternativa es Firebase Hosting (§13 del requerimiento). |
| El renombrado del repositorio rompe enlaces | GitHub redirige la URL antigua. El README y el remoto usan el nombre nuevo. |
| Riverpod o go_router no son compatibles con Dart 3.13 | `flutter pub add` resuelve versiones compatibles, `pubspec.lock` se commitea y la CI fija Flutter 3.47.0. |
| En web se piden fuentes de respaldo para caracteres que no están en las fuentes empaquetadas | Esta etapa no usa emoji ni glifos especiales en la UI. |

## Lo que **no** entra en esta spec

- Login con Discord, sesión, guard de rutas y cliente HTTP (Etapa 2).
- Modelos de dominio y lectura real del catálogo y las rutas (Etapa 3).
- Persistencia local, rutas del usuario, progreso y Home real (Etapa 4).
- Perfil, avatar y menú de usuario (etapas 2 y 5).
- Cuestionario, generación de rutas y DevBot (Etapa 6).
- Iconos de la app, splash, despliegue automático y README final (Etapa 7).
- Compilaciones móviles en CI y protección de rama en GitHub.
- Badge `WEB` y `temarios_devtalles.json`.

Cada uno de estos puntos, si llega, va en su propia spec.
