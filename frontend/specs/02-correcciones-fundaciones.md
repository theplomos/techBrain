# SPEC 02 — Correcciones de las Fundaciones

> **Estado:** aproved
> **Depende de:** SPEC 01
> **Fecha:** 2026-09-20
> **Objetivo:** Corregir en `feature/fundaciones` los 6 fallos de layout y accesibilidad que la revisión de código encontró en la Etapa 1, con un test de regresión por fallo.

## Por qué existe esta spec

La Etapa 1 quedó implementada, pero la revisión de `feature/fundaciones` frente a `develop` encontró 6 fallos que incumplen criterios de aceptación de la propia SPEC 01 y el RNF-11 (accesibilidad). Tres están verificados con pruebas; los otros tres salen de leer el código.

| # | Archivo | Fallo |
|---|---|---|
| 1 | `lib/features/roadmap/presentation/screens/home_screen.dart` | La barra superior de 72 px tapa el inicio de Home en escritorio: el `ListView` tiene 24 px fijos arriba y no suma el hueco que inyecta `extendBodyBehindAppBar`. Verificado: la tarjeta empieza en `y=24`. |
| 2 | `lib/shared/widgets/pill_button.dart` | `PillButton` no expone `SemanticsAction.tap`: `ExcludeSemantics` borra la acción del `GestureDetector` y el `Semantics` exterior no la repone. Verificado. |
| 3 | `lib/shared/layout/app_bottom_nav_bar.dart` · `app_top_nav_bar.dart` | Las 4 pestañas tienen el mismo problema: se anuncian como botón, pero al activarlas no navegan. Verificado. |
| 4 | `lib/shared/widgets/pill_button.dart` | `alignment: Alignment.center` hace que el botón ocupe todo el ancho acotado. Verificado: 1136 px a 1280 px de pantalla. |
| 5 | Las dos barras de navegación | El foco sale de `InkWell.focusColor`, que se pinta en el `Material` del `Scaffold`, por debajo del vidrio (`navBg` al 85 %). No hay anillo visible con Tab. |
| 6 | `home_screen.dart` | El `SizedBox(height: 96)` final no cubre la barra inferior real (52 + 12 + 2 + 16 = 82 px más el área segura, unos 116 px en un iPhone con indicador de inicio). |

Los fallos 1, 2, 3, 5 y 6 incumplen criterios ya marcados en la SPEC 01, así que esta spec los cierra de verdad en lugar de dejarlos como deuda.

## Precondiciones

1. La rama activa es `feature/fundaciones`, con el árbol limpio y sin fusionar todavía en `develop`.
2. `flutter analyze` y `flutter test` pasan en el estado actual de la rama.

## Alcance

**Dentro:**

- Padding de las pantallas desplazables a partir de `MediaQuery.paddingOf(context)`, que es donde el `Scaffold` deja el alto de las barras.
- `PillButton` ajustado a su contenido.
- Acción de activación semántica en `PillButton` y en las 4 pestañas de navegación.
- Anillo de foco de 2 px en `accentLavender` para pestañas, `PillButton` y `GlassContainer`.
- Token de foco en `lib/config/theme/app_tokens.dart`.
- Un test de regresión por fallo, en los archivos de test que ya existen.
- Nota de estado en `specs/01-fundaciones.md` y reglas nuevas en `frontend/CLAUDE.md`.

**Fuera de alcance (para futuras specs):**

- Auditoría general de accesibilidad: contraste, orden de tabulación y etiquetas del resto de widgets.
- El header `Cache-Control: immutable` de un año sobre `/assets/` en `vercel.json`, que congelaría los JSON del dataset en los navegadores que ya visitaron la app. Se revisa cuando la Etapa 3 lea el catálogo de verdad.
- Cualquier cambio de diseño que no venga de los 6 fallos.
- El muestrario temporal de Home, que la Etapa 4 elimina entero.
- Tests de accesibilidad automáticos de Flutter (`meetsGuideline`), que se valorarán en la Etapa 7.

## Archivos que cambian

```text
lib/config/theme/app_tokens.dart                     # AppFocus
lib/shared/widgets/glass_container.dart              # anillo de foco
lib/shared/widgets/pill_button.dart                  # ancho, semántica y anillo
lib/shared/layout/app_bottom_nav_bar.dart            # semántica y anillo
lib/shared/layout/app_top_nav_bar.dart               # semántica y anillo
lib/features/roadmap/presentation/screens/home_screen.dart  # padding real
test/shared/widgets/glass_container_test.dart
test/shared/widgets/pill_button_test.dart
test/shared/layout/app_shell_test.dart
test/features/home_screen_test.dart
specs/01-fundaciones.md · CLAUDE.md                  # documentación
```

No aparece ningún archivo nuevo.

## Modelo de datos

Esta spec no introduce estructuras de datos. Solo añade un grupo de tokens de diseño:

```dart
// lib/config/theme/app_tokens.dart
/// Anillo de foco común a todos los controles enfocables (RNF-11).
abstract final class AppFocus {
  static const double ringWidth = 2.0;
  static const Color ringColor = AppColors.accentLavender;
}
```

Convenciones que fija esta spec:

- El anillo se pinta con `foregroundDecoration`, nunca con `border`: así no cambia el tamaño del control al enfocarlo y no desplaza el layout.
- El radio del anillo es el del control que lo lleva: `AppRadii.pill` en `PillButton`, `AppRadii.inner` en las pestañas de la barra inferior, `borderRadius` en `GlassContainer` y `0` en las pestañas de la barra superior.
- Una pantalla desplazable nunca escribe a mano el hueco de una barra: lo toma de `MediaQuery.paddingOf(context)` y le suma su propio margen.

## Plan de implementación

1. **Token de foco y anillo en `GlassContainer`.**
   - Añadir `AppFocus` a `app_tokens.dart`.
   - En `GlassContainer`, pintar el anillo con `foregroundDecoration` cuando `_focused` es true, con el radio del propio contenedor.
   - Ampliar `glass_container_test.dart`: al enfocarlo con `Focus.of(...).requestFocus()` o con Tab, el `AnimatedContainer` tiene `foregroundDecoration` con borde de 2 px en `accentLavender`; sin foco, es null.
2. **`PillButton` ajustado a su contenido.**
   - Quitar `alignment: Alignment.center` del `AnimatedContainer` y centrar el contenido con el `Row` que ya existe (`mainAxisSize: MainAxisSize.min`).
   - Quitar el `Opacity(opacity: 1.0)` que no hace nada.
   - Ampliar `pill_button_test.dart`: dentro de un `Center` de 800 px de ancho, el botón 'Primario' mide menos de 300 px y conserva 44 px de alto mínimo.
3. **Anillo de foco en `PillButton`.**
   - Pintar el anillo con `foregroundDecoration` y radio `AppRadii.pill` cuando `_focused` es true y el botón está habilitado.
   - Test: enfocado tiene anillo; deshabilitado no lo recibe.
4. **Activación semántica de `PillButton`.**
   - Añadir `onTap: onPressed` al `Semantics` exterior, manteniendo `ExcludeSemantics` sobre el árbol interno para no duplicar nodos.
   - Test con `tester.ensureSemantics()`: el nodo tiene `SemanticsAction.tap`, invocarla dispara el callback, y el botón deshabilitado no la expone.
5. **Activación semántica de las pestañas.**
   - Añadir `onTap: onTap` al `Semantics` de `_BottomNavItem` y de `_TopNavItem`.
   - Ampliar `app_shell_test.dart`: invocar la acción semántica de 'Explorar' a 390 px y a 1280 px navega a `ExploreScreen`.
6. **Anillo de foco en las pestañas.**
   - Convertir `_BottomNavItem` y `_TopNavItem` en `StatefulWidget`, guardar el foco con `InkWell.onFocusChange` y pintar el anillo con `foregroundDecoration` sobre el `DecoratedBox` que ya existe.
   - Test: la pestaña enfocada tiene anillo de 2 px en `accentLavender` en las dos barras.
7. **Padding real en Home.**
   - Sustituir el padding fijo del `ListView` por `MediaQuery.paddingOf(context)` más 24 px arriba y abajo, y borrar el `SizedBox(height: 96)` final.
   - Ampliar `home_screen_test.dart`: a 1280 px el primer hijo empieza por debajo de `AppTopNavBar.height`; a 390 px con `padding.bottom` simulado de 34 px, el último hijo termina por encima del borde superior de `AppBottomNavBar`.
8. **Documentación.**
   - En `specs/01-fundaciones.md`, nota de estado que remite a esta spec en los criterios de foco y de accesibilidad.
   - En `frontend/CLAUDE.md`, las dos reglas nuevas: padding desde `MediaQuery` y anillo de foco con `AppFocus`.

## Criterios de aceptación

- [ ] `flutter analyze` termina con "No issues found!".
- [ ] `flutter test` pasa sin fallos.
- [ ] A 1280 px, un test comprueba que el primer hijo de `HomeScreen` empieza en `y >= AppTopNavBar.height`.
- [ ] A 390 px con un `padding.bottom` de 34 px, un test comprueba que el último hijo de `HomeScreen` termina por encima de `AppBottomNavBar`.
- [ ] Dentro de un `Center` de 800 px, un test comprueba que `PillButton('Primario')` mide menos de 300 px de ancho y al menos 44 px de alto.
- [ ] Un test comprueba que el nodo semántico de `PillButton` tiene `SemanticsAction.tap` y que invocarla llama a `onPressed`.
- [ ] Un test comprueba que `PillButton` con `onPressed: null` no expone `SemanticsAction.tap`.
- [ ] Un test comprueba que invocar `SemanticsAction.tap` sobre la pestaña 'Explorar' navega a `ExploreScreen`, a 390 px y a 1280 px.
- [ ] Un test comprueba que la pestaña enfocada de cada barra pinta un anillo de 2 px en `accentLavender`.
- [ ] Un test comprueba que `PillButton` y `GlassContainer` pintan ese mismo anillo al recibir el foco, y nada al perderlo.
- [ ] En Chrome, Tab recorre las 4 pestañas con el anillo visible sobre el vidrio de la barra, y Enter navega a la pestaña enfocada.
- [ ] En Chrome a 1280 px, el título 'Home' se ve entero por debajo de la barra superior.
- [ ] `grep -n "SizedBox(height: 96" lib/features/roadmap/presentation/screens/home_screen.dart` no devuelve nada.
- [ ] `specs/01-fundaciones.md` remite a esta spec en los criterios de accesibilidad que no cumplía.
- [ ] `frontend/CLAUDE.md` documenta la regla de padding y la del anillo de foco.
- [ ] Los arreglos van en `feature/fundaciones`, en commits `fix(frontend): …`, antes del PR a `develop`.

## Decisiones

- **Sí:** corregir en `feature/fundaciones`, que aún no se ha fusionado. **No:** una rama aparte ni un arreglo posterior desde `develop`, porque meterían en `develop` una Etapa 1 con fallos de accesibilidad conocidos.
- **Sí:** el padding sale de `MediaQuery.paddingOf(context)`, que es donde el `Scaffold` deja el alto de cada barra. **No:** que `AppShell` reserve el hueco, porque el contenido dejaría de pasar por detrás del vidrio y el `BackdropFilter` de las barras perdería el sentido. **No:** seguir con números escritos a mano, que es justo el origen de los fallos 1 y 6.
- **Sí:** `PillButton` ajustado a su contenido; quien quiera uno a todo el ancho lo envuelve en un `SizedBox(width: double.infinity)`. **No:** un parámetro `expand`, porque hoy no lo necesita ninguna pantalla.
- **Sí:** `onTap` en el `Semantics` exterior manteniendo `ExcludeSemantics` dentro. **No:** quitar `ExcludeSemantics`, porque volverían a aparecer nodos duplicados del `InkWell` y del `GestureDetector`.
- **Sí:** anillo de foco en pestañas, `PillButton` y `GlassContainer`, con un token común. **No:** solo en las pestañas, que es el mínimo literal de la SPEC 01, porque los otros dos controles son enfocables y hoy solo se desplazan unos píxeles.
- **Sí:** anillo con `foregroundDecoration`, que se pinta sobre el hijo. **No:** `InkWell.focusColor`, porque el `Material` del `Scaffold` queda por debajo del vidrio de la barra y el resalte no se ve. **No:** `border`, porque cambiaría el tamaño del control al enfocarlo.
- **Sí:** un test de regresión por fallo, en los archivos de test que ya existen. **No:** solo verificación manual, porque la CI no detectaría la reaparición.
- **Sí:** spec propia en lugar de commits sueltos, para que quede el registro de por qué cambian estos widgets.

## Riesgos

| Riesgo | Mitigación |
|---|---|
| Otras pantallas repiten el padding escrito a mano | La regla queda en `frontend/CLAUDE.md` y las pantallas de las etapas 3 y 4 nacen con ella. |
| `MediaQuery.paddingOf` devuelve 0 en un test que no monta el `Scaffold` completo | Los tests de Home montan la app entera con su router, como ya hace `app_shell_test.dart`. |
| El anillo sobre la pestaña activa se confunde con su degradado | El anillo es `accentLavender` sobre un fondo morado oscuro y se comprueba a ojo en Chrome, además del test. |
| Ajustar el ancho de `PillButton` descoloca el muestrario de Home | El test de overflow a 360 px de `home_screen_test.dart` sigue vigilándolo. |

## Lo que **no** entra en esta spec

- Auditoría general de accesibilidad del resto de widgets.
- El header de caché de `/assets/` en `vercel.json`.
- Rediseño de las barras, del muestrario o de cualquier widget de la Etapa 1.
- Tests automáticos con las guías de accesibilidad de Flutter.

Cada uno de estos puntos, si llega, va en su propia spec.
