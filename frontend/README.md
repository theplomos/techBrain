# TechBrain · Frontend

App Flutter de TechBrain (paquete `techbrain`) para web, iOS y Android. La descripción del proyecto, el despliegue y la entrega están en el [README de la raíz](../README.md).

## Requisitos

- Flutter 3.47.0 stable (Dart 3.13)
- Chrome para ejecutar la web. Xcode y el SDK de Android solo hacen falta para móvil

## Ejecutar

```bash
flutter pub get
flutter run -d chrome --web-port 8080
```

## Calidad

```bash
flutter analyze                                  # Sin avisos
flutter test                                     # Toda la suite
flutter test test/shared/widgets_test.dart       # Un solo archivo
flutter test --plain-name "LevelBadge"           # Un solo test por nombre
```

## Documentación

- Requerimiento del frontend: [`../docs/requerimiento_general_frontend.md`](../docs/requerimiento_general_frontend.md)
- Specs por etapa: [`specs/`](specs/)
- Guía para trabajar en esta carpeta: [`CLAUDE.md`](CLAUDE.md)
