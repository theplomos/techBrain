# TechBrain · Frontend

App Flutter de TechBrain (paquete `techbrain`) para web, iOS y Android. La descripción del proyecto, el despliegue y la entrega están en el [README de la raíz](../README.md).

## Requisitos

- Flutter 3.47.0 stable (Dart 3.13)
- Google Chrome para ejecutar la versión web.
- Xcode (macOS) y Android Studio / SDK solo para ejecución en dispositivos móviles o emuladores.

## Ejecutar

```bash
git clone https://github.com/theplomos/techBrain.git
cd techBrain/frontend
flutter pub get
flutter run -d chrome --web-port 8080
```

## Configuración opcional

La app admite configuración mediante variables de entorno en tiempo de compilación (`--dart-define` o `--dart-define-from-file`):

| Variable | Descripción | Valor por defecto | Opciones permitidas |
|---|---|---|---|
| `API_BASE_URL` | URL base de la API REST del backend | `https://api.techbrain.arcentales.dev/api` | Cualquier URL HTTP/HTTPS válida |
| `AUTH_SOURCE` | Estrategia de autenticación | `api` | `api`, `mock` |

Para usar un archivo `.env`:

```bash
cp .env.example .env
flutter run -d chrome --web-port 8080 --dart-define-from-file=.env
```

## Móvil

```bash
flutter run -d <dispositivo>
```

## Calidad

```bash
flutter analyze                                  # Análisis estático sin advertencias (0 issues)
flutter test                                     # Toda la suite de pruebas unitarias y de widgets
flutter test test/shared/widgets/pill_button_test.dart  # Pruebas de un archivo concreto
flutter test --plain-name "LevelBadge"           # Pruebas filtradas por nombre
```

## Código generado

La app utiliza `riverpod_generator` y `build_runner` para la inyección de dependencias y el enrutador:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Los archivos generados (`*.g.dart`) se versionan y commitean en el repositorio. La integración continua verifica que no exista deriva.

## Dataset

Los datasets originales en formato JSON residen en `docs/references/` y se copian empaquetados como assets a `assets/data/` mediante:

```bash
./tool/sync_datasets.sh
```

Si cambian los archivos originales en `docs/references/`, se debe volver a ejecutar el script y commitear los cambios. Un test automatizado en la suite comprueba que la copia en `assets/data/` está al día con el origen.

## Despliegue

Compilación optimizada para producción web y despliegue en Vercel:

```bash
flutter build web --release
npx vercel@latest deploy build/web --prod
```

- **URL de producción:** (se actualizará en el primer despliegue)

## Estructura

```text
frontend/
├── assets/
│   ├── data/                 # Copia empaquetada de cursos y rutas JSON
│   └── fonts/                # Fuentes locales Space Grotesk y DM Sans (TTF + OFL)
├── docs/
│   └── superpowers/          # Planes y registros de ejecución de superpowers
├── lib/
│   ├── app.dart              # TechBrainApp y configuración global
│   ├── main.dart             # Punto de entrada principal y ProviderScope
│   ├── config/
│   │   ├── env.dart          # Lectura tipada de variables de entorno (Env y AuthSource)
│   │   ├── router/           # go_router con StatefulShellRoute y rutas
│   │   └── theme/            # Tokens, colores, tipografía y tema cósmico
│   ├── features/             # Módulos por funcionalidad
│   │   ├── catalog/          # Catálogo y Explorar
│   │   ├── quiz/             # Cuestionarios y evaluación
│   │   ├── roadmap/          # Rutas, progreso y pantalla Home
│   │   └── settings/         # Configuración del usuario
│   └── shared/               # Dominio, errores, layout y componentes compartidos
│       ├── domain/           # Enums de dominio (CourseLevel, CourseCategory, DatasetAssets)
│       ├── errors/           # Jerarquía sellada Failure
│       ├── layout/           # Breakpoints, pestañas, barras superior e inferior y shell
│       └── widgets/          # Componentes reutilizables (GlassContainer, PillButton, Badges, etc.)
├── specs/                    # Especificaciones técnicas por etapa
├── test/                     # Suite completa de pruebas unitarias y de widgets
├── tool/                     # Scripts de utilidad (sync_datasets.sh)
└── web/                      # index.html, manifest.json y vercel.json
```
