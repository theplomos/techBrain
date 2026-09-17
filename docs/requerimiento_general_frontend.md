# TechBrain · Requerimiento general del frontend

| Campo | Valor |
|---|---|
| Proyecto | TechBrain, Equipo #13, DevTalles CodeQuest 2026 (misión CQ03-2026) |
| Alcance de este documento | Frontend en Flutter. El backend lo desarrolla otro equipo |
| Fecha | 16 de septiembre de 2026 |
| Estado | Borrador para revisión |
| Plazo de entrega | **28 de septiembre de 2026, 10:00 CDMX (GMT-6)**. Después de esa hora no se hace push, merge ni tag |

Este documento reúne lo decidido en la sesión de diseño. Cada etapa del proyecto tendrá su propia spec en `docs/superpowers/specs/`, que remite a los identificadores de este documento (`RF-xx`, `RNF-xx`, `DEP-xx`, `P-xx`).

---

## 1. Objetivo

Ayudar a un estudiante de la comunidad DevTalles a **descubrir, guardar y seguir rutas de aprendizaje** con los cursos reales de DevTalles, y a **marcar su avance capítulo a capítulo** hasta completar cada curso y cada ruta.

El brief pide además que la aplicación pueda adaptarse a nuevas necesidades de la comunidad. Por eso el catálogo, las rutas, los temarios y las preguntas se tratan como datos y nunca se escriben a mano en la interfaz.

## 2. Usuarios

| Usuario | Qué necesita |
|---|---|
| Estudiante de DevTalles | Miembro del Discord de DevTalles. Es el único rol que contempla el frontend |
| Jurado del CodeQuest | Clonar el repositorio, ejecutarlo siguiendo el README y usar el enlace desplegado |

La API define también un rol `admin`, pero el panel de administración queda fuera de alcance.

## 3. Fuentes de información

| Fuente | Ubicación |
|---|---|
| Brief del concurso | `docs/rules/CODE QUEST 2026 BRIEF-INFORMATIVO V3.pdf` |
| Catálogo de 91 cursos | `docs/references/cursos_devtalles.json` |
| 13 rutas oficiales | `docs/references/rutas_aprendizaje_devtalles.json` |
| Temarios por capítulo | `docs/references/temarios_devtalles.json` (en recopilación, ver §9) |
| Sistema de diseño | `docs/references/imagen_corporativa_devtalles.md` |
| Prototipos | `docs/ideas/prototipo_stitch_devtalles.md` y `docs/ideas/stitch_screens/` |
| API del backend (v0.1.0) | `https://api.techbrain.arcentales.dev/api/docs` |
| Informe de dudas para backend | https://claude.ai/artifact/GzgRniYJ15H2cpQZLu2dmo |

---

## 4. Alcance

### 4.1 Dentro del MVP

- Los 5 requisitos obligatorios del brief:
  1. Cuestionario de evaluación de habilidades e intereses.
  2. Rutas generadas dinámicamente con cursos de DevTalles.
  3. Guardar y generar varias rutas por usuario.
  4. Marcar el progreso de cada ruta.
  5. Inicio de sesión y registro con Discord.
- **Explorar**: catálogo de cursos y rutas oficiales.
- **DevBot Copilot**: cuestionario conversacional. Su forma final depende del acuerdo con el backend (`P-01`).
- **Progreso por capítulo** de cada curso.

### 4.2 Fuera del MVP

- Login y registro con correo y contraseña, aunque la API ya los ofrece.
- Racha de días, métricas, notificaciones y "precisión en quizzes".
- Entrada por voz.
- Porcentaje de afinidad por curso.
- Renombrar rutas y editar el perfil.
- Panel de administración.
- Publicación en App Store y Google Play.

---

## 5. Requisitos funcionales

### Autenticación

| ID | Requisito |
|---|---|
| RF-01 | Iniciar sesión con Discord a través del backend, en web, iOS y Android |
| RF-02 | El primer inicio de sesión crea la cuenta, lo que cubre el "registro" del brief. La pantalla de login lo explica |
| RF-03 | Al reabrir la app, la sesión se restaura sin volver a iniciar sesión mientras el refresh token sea válido |
| RF-04 | Cerrar sesión desde Configuración |
| RF-05 | Mostrar mensajes distintos según el fallo: la cancelación del usuario no muestra mensaje; un usuario que no es miembro del servidor de DevTalles ve un mensaje específico; un error de red o de servidor muestra un mensaje con botón de reintento |
| RF-06 | Poder activar por configuración un modo de autenticación simulado que no usa la red |

### Catálogo y Explorar

| ID | Requisito |
|---|---|
| RF-07 | Listar las 13 rutas oficiales con su número de cursos y sus horas totales |
| RF-08 | Mostrar el detalle de una ruta oficial con sus cursos agrupados por nivel: Requerido, Recomendado y Opcional |
| RF-09 | Listar los 91 cursos con búsqueda por nombre y filtro por ruta oficial, incluida la opción "Sin ruta" para los 12 cursos que no están en ninguna |
| RF-10 | Mostrar el detalle de un curso: portada, descripción, requisitos, horas, lecciones, instructor, rutas en las que aparece con el nivel que tiene en cada una, temario por capítulos (solo lectura) y enlace al curso en DevTalles |

### Rutas del usuario

| ID | Requisito |
|---|---|
| RF-11 | Guardar una ruta oficial como ruta propia |
| RF-12 | Guardar una ruta generada desde su vista previa |
| RF-13 | Listar todas las rutas guardadas del usuario, sin límite, con su progreso |
| RF-14 | Tener una ruta activa. La primera ruta guardada pasa a ser la activa, y el usuario puede elegir otra |
| RF-15 | Eliminar una ruta tras pedir confirmación. Eliminarla no borra el progreso de sus cursos |
| RF-16 | Editar las horas semanales de cada ruta y recalcular sus fechas estimadas |
| RF-17 | Mostrar el detalle de una ruta: progreso, horas restantes, fecha estimada por nivel y fecha final, y cursos agrupados por nivel con su justificación cuando exista |

### Progreso

| ID | Requisito |
|---|---|
| RF-18 | Marcar y desmarcar capítulos de un curso |
| RF-19 | Marcar un curso como completo, lo que marca todos sus capítulos |
| RF-20 | Calcular el progreso de un curso ponderado por lecciones (lecciones de los capítulos marcados ÷ lecciones totales). El estado se deriva del porcentaje: 0 % es sin empezar, entre 0 % y 100 % es en curso y 100 % es completado |
| RF-21 | Guardar el progreso por usuario y curso, de modo que se comparta entre todas las rutas que contienen ese curso |
| RF-22 | Calcular el progreso de una ruta como lecciones completadas ÷ lecciones de sus cursos únicos |

### Home

| ID | Requisito |
|---|---|
| RF-23 | Saludar al usuario por su nombre |
| RF-24 | Mostrar una tarjeta de la ruta activa con su porcentaje de progreso, la fecha estimada, el siguiente capítulo pendiente y la acción "Continuar" |
| RF-25 | Mostrar un carrusel con las rutas guardadas y su progreso |
| RF-26 | Si no hay rutas guardadas, mostrar un estado vacío con accesos a Cuestionarios y a Explorar |

### Cuestionarios y generación

> **Pendiente de acordar con backend (`P-01`).** Estos requisitos son obligatorios, pero todavía no está decidido quién genera las rutas (IA en el backend o reglas locales), cuáles son las preguntas ni cuál es el contrato. Si el **18 de septiembre** no hay acuerdo, se aplica el plan B: reglas locales sobre el catálogo detrás de la misma interfaz.

| ID | Requisito |
|---|---|
| RF-27 | Cuestionario guiado paso a paso que evalúa las habilidades e intereses del usuario |
| RF-28 | Generar una ruta dinámica a partir de las respuestas, usando solo cursos del catálogo |
| RF-29 | Vista previa de la ruta generada con las acciones "Guardar" y "Ajustar respuestas" |
| RF-30 | DevBot Copilot: un cuestionario conversacional que alimenta la misma generación de rutas |

### Configuración

| ID | Requisito |
|---|---|
| RF-31 | Mostrar el perfil del usuario (nombre, correo y avatar) obtenido de la API |
| RF-32 | Definir las horas semanales por defecto que tendrán las rutas nuevas |
| RF-33 | Mostrar los créditos: equipo, licencia MIT y CodeQuest 2026 |

---

## 6. Requisitos no funcionales

| ID | Requisito |
|---|---|
| RNF-01 | **Plataformas.** Un solo código Flutter. La web es el objetivo de entrega y va desplegada. iOS y Android deben compilar y funcionar, pero no se publican |
| RNF-02 | **Responsive.** Por debajo de 1024 px se usa una barra inferior flotante y las secciones de nivel van apiladas. A partir de 1024 px se usa una barra superior, los niveles van en 3 columnas y el progreso del curso se abre en un panel lateral. Ancho mínimo soportado: 360 px |
| RNF-03 | **Diseño.** Solo tema oscuro, con los valores exactos de `imagen_corporativa_devtalles.md`. Tarjetas glass con radio de 18 px y botones píldora de 50 px. Space Grotesk y DM Sans van empaquetadas como assets |
| RNF-04 | **Tecnologías.** Solo las que se enseñan en los cursos de DevTalles. Antes de añadir un framework, un servicio o un proveedor, se comprueba en `cursos_devtalles.json` |
| RNF-05 | **Datos como datos.** El catálogo, las rutas, los temarios y las preguntas se cargan desde archivos o desde la API, nunca desde la UI |
| RNF-06 | **Intercambiabilidad.** Cada feature expone un repositorio abstracto. Pasar de un datasource mock a la API no toca la capa de presentación |
| RNF-07 | **Funciona al clonar.** Seguir el README basta para ejecutar la app. No hace falta un `.env` (hay valores por defecto), los archivos `.g.dart` generados se commitean y el puerto web es fijo, el 8080 |
| RNF-08 | **Seguridad.** El front no contiene secretos. Los tokens se guardan en `flutter_secure_storage` como un único valor. Por la URL solo viaja el código de un solo uso del callback de login |
| RNF-09 | **Calidad.** `flutter analyze` sin avisos y `flutter test` en verde, comprobados en CI antes de cada merge |
| RNF-10 | **Ramas.** Cada etapa se desarrolla en `feature/*` y se integra en `main` por PR con merge commit, sin squash. `main` siempre compila y se puede desplegar |
| RNF-11 | **Accesibilidad básica.** Áreas táctiles de al menos 44 px, etiquetas semánticas en botones y checkboxes, y navegación por teclado en web |
| RNF-12 | **Idioma.** La interfaz está en español |

---

## 7. Arquitectura

### 7.1 Stack

| Uso | Elección |
|---|---|
| Framework | Flutter 3.47 (stable), proyecto en la raíz del repositorio |
| Estado | `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator` y `build_runner` |
| Navegación | `go_router`, con `StatefulShellRoute.indexedStack` para las pestañas y guard de sesión en `redirect` |
| HTTP | `dio`, con un interceptor que añade el Bearer, hace refresh ante un 401 y desenvuelve el envelope |
| Login OAuth | `flutter_web_auth_2`: popup y `web/auth.html` en web; `techbrain://auth/callback` en móvil |
| Tokens | `flutter_secure_storage` |
| Persistencia mientras no haya API | `shared_preferences` |
| Configuración | `String.fromEnvironment` con valores por defecto, y `--dart-define-from-file=.env` de forma opcional |
| Despliegue web | Vercel, de forma provisional (`P-03`), con `web/vercel.json` para las rutas SPA |

### 7.2 Estructura

```text
lib/
├── main.dart
├── config/        # router, tema, env, cliente dio
├── shared/        # Failure, widgets base (glass card, pill button, badges)
└── features/
    ├── auth/      # domain · infrastructure (api_ y mock_) · presentation
    ├── catalog/   # cursos, rutas oficiales y temarios
    ├── roadmap/   # rutas del usuario, progreso y cálculos
    ├── quiz/      # cuestionario guiado (P-01)
    ├── devbot/    # chat conversacional (P-01)
    └── settings/
```

### 7.3 Variables de entorno

| Variable | Valor por defecto | Uso |
|---|---|---|
| `API_BASE_URL` | `https://api.techbrain.arcentales.dev/api` | URL base de la API |
| `AUTH_SOURCE` | `api` | `api` para el login real; `mock` para el usuario demo sin red |

### 7.4 Modelo de dominio

```text
Course         slug, url, name, description, requirements[], coverUrl, hours, lessons,
               instructor, chapters[]
Chapter        index, title, lessons[]
OfficialRoute  id, name, url, courses: RouteCourse[]
RouteCourse    slug, level, category
Roadmap        id, userId, title, source (quiz | devbot | official), weeklyHours,
               createdAt, items: RoadmapItem[]
RoadmapItem    slug, level, category, order, rationale?
CourseProgress userId, slug, completedChapters: Set<int>
User           id, fullName, email, avatarUrl?, roles[]
```

### 7.5 Reglas de datos (verificadas sobre el dataset)

| Situación | Regla |
|---|---|
| `slug` distingue mayúsculas y no está normalizado (`NET-Backend`, `Ingenier%C3%ADa-de-prompts`) | Es la clave de unión y se usa tal cual |
| `nivel` y `categoria` dependen de la ruta | Se leen siempre de la ruta, nunca del curso |
| Hay slugs repetidos dentro de una ruta (`react`, `dart-movil`) | Se deduplican conservando el nivel más fuerte: Requerido > Recomendado > Opcional |
| En 56 de 113 entradas el nombre de la ruta no coincide con el del catálogo, y algunos llevan `<br>` | El nombre, las horas y la portada salen siempre del catálogo |
| `horas` y `lecciones` son texto (`"40.5 horas"`, `"45 lecciones"`) | Se convierten a `double` y a `int` |
| `niveles_disponibles` no es fiable | Se ignora; los niveles se obtienen de los cursos |
| 15 cursos tienen como requisito un texto de relleno | Se tratan como lista vacía |
| `instructor` tiene variantes | Se normaliza con un mapa de alias |
| El sistema de diseño no tiene badge `FULLSTACK` | Se crea uno con los tokens existentes |
| Un curso sin temario | Se trata como un único capítulo llamado "Curso completo" |

### 7.6 Persistencia local

Estas claves se usan mientras el backend no ofrezca persistencia:

| Clave | Contenido |
|---|---|
| `roadmaps:<userId>` | Lista de rutas guardadas, en JSON |
| `activeRoadmap:<userId>` | Id de la ruta activa |
| `progress:<userId>:<slug>` | Índices de los capítulos completados |
| `settings:<userId>` | Horas semanales por defecto |

### 7.7 Cálculos

| Cálculo | Fórmula |
|---|---|
| Horas restantes de un curso | `horas × (1 − progreso)` |
| Fecha estimada | Se recorren los niveles en orden Requerido → Recomendado → Opcional, acumulando `horas restantes ÷ weeklyHours` semanas desde hoy. Da una fecha por nivel y una final |
| Siguiente capítulo | El primer capítulo sin completar del primer curso sin completar de la ruta activa, siguiendo el orden de la ruta |

---

## 8. Integración con el backend

### 8.1 Qué ofrece la API (v0.1.0)

| Área | Endpoints |
|---|---|
| Discord | `GET /auth/discord` → `GET /auth/discord/callback` → `POST /auth/discord/exchange { code }` |
| Sesión | `POST /auth/refresh`, `POST /auth/logout` |
| Usuario | `GET /users/me` |
| Salud | `GET /health`, `/health/ready`, `/health/live` |
| Formato | Todas las respuestas usan el envelope `{ success, statusCode, data, path, timestamp }`. Autenticación por Bearer JWT |

El frontend usa la API real **solo para autenticación y perfil**. Catálogo, rutas, progreso, cuestionario y DevBot funcionan con datasources locales hasta que existan sus contratos.

### 8.2 Dependencias abiertas

| ID | Qué se necesita del backend |
|---|---|
| DEP-01 | Corregir el `redirect_uri` de Discord, que hoy apunta a `http://3.135.86.234:3000`, para que use el dominio público con HTTPS |
| DEP-02 | Que `GET /auth/discord` acepte un destino validado contra una lista blanca: `http://localhost:8080/auth.html`, el dominio de producción en Vercel y `techbrain://auth/callback` |
| DEP-03 | Documentar en Swagger las respuestas de `exchange`, `refresh` y `users/me`, y el envelope de error |
| DEP-04 | Definir un código de error para "no es miembro del servidor de DevTalles" |
| DEP-05 | Configurar CORS para `http://localhost:8080` y para el dominio de producción en Vercel |
| DEP-06 | Definir los contratos de generación de rutas, DevBot y persistencia (ver el informe de dudas) |

---

## 9. Formato esperado de `temarios_devtalles.json`

Se usan claves en español, igual que en el resto del dataset. El archivo puede incluir más campos, como la historia de cada curso; el mapper ignora los que no conoce hasta que se incorporen al modelo.

```json
{
  "generado_en": "2026-09-16",
  "cursos": [
    {
      "slug": "tanstack-query",
      "capitulos": [
        {
          "indice": 1,
          "titulo": "Sección 1 - Introducción al curso",
          "lecciones": ["Introducción al curso", "¿Cómo hacer preguntas?"]
        }
      ]
    }
  ]
}
```

Reglas:

- `slug` coincide exactamente con el del catálogo.
- `indice` empieza en 1 y sigue el orden del temario. Es el valor que se guarda en el progreso.
- La suma de lecciones de un curso debe coincidir con el campo `lecciones` del catálogo. Un test lo comprueba.

---

## 10. Etapas del proyecto

Cada etapa tiene su propia spec, su plan de implementación y su rama.

| Etapa | Nombre | Rama | Cubre | Depende de | Fechas propuestas |
|---|---|---|---|---|---|
| **1** | **Fundaciones** | `feature/project-setup` | Base de RNF-01 a RNF-12 | — | 16–17 sep |
| 2 | Autenticación con Discord | `feature/auth-discord` | RF-01 a RF-06 | Etapa 1, DEP-01 a DEP-05 | 17–18 sep |
| 3 | Catálogo y Explorar | `feature/catalog-explore` | RF-07 a RF-10 | Etapa 1, temarios (§9) | 19–20 sep |
| 4 | Rutas, progreso y Home | `feature/roadmap-progress` | RF-11, RF-13 a RF-26 | Etapas 2 y 3 | 20–22 sep |
| 5 | Configuración | `feature/settings` | RF-04, RF-31 a RF-33 | Etapa 2 | 23 sep |
| 6 | Cuestionario, generación y DevBot | `feature/quiz-devbot` | RF-12, RF-27 a RF-30 | Etapas 3 y 4, P-01 | 23–25 sep |
| 7 | Release | `feature/release` | RNF-07 verificado de punta a punta, deploy automático, README final y video | Todas | 26–27 sep |

### Etapa 1 · Fundaciones (resumen)

Deja lista la base sobre la que se construyen las demás etapas. No incluye ninguna funcionalidad de negocio.

- Proyecto Flutter en la raíz, con soporte para web, iOS y Android.
- Dependencias de §7.1 y `analysis_options.yaml`.
- Tema oscuro con los tokens de DevTalles y las fuentes empaquetadas.
- `env.dart` y `.env.example`.
- Router con el shell de 4 pestañas (Home, Explorar, Cuestionarios y Configuración) y pantallas provisionales. Barra inferior o superior según el ancho.
- Widgets base en `shared/`: tarjeta glass, botón píldora y badges de nivel y categoría.
- `Failure` tipado y `ErrorView` común.
- Assets de datos declarados en `pubspec.yaml`.
- CI con GitHub Actions (analyze y test).
- README con los pasos reales para ejecutar la app.
- `web/vercel.json` y un primer despliegue manual en Vercel.

---

## 11. Criterios de aceptación

### 11.1 Del proyecto

- Los 5 requisitos obligatorios del brief se pueden demostrar en el enlace desplegado.
- Clonar el repositorio y seguir el README levanta la app en Chrome.
- El repositorio es público, tiene licencia MIT y muestra el trabajo en ramas `feature/*`.
- Existe un video de entre 1:00 y 1:30 minutos.
- No se modifica el repositorio después del 28 de septiembre a las 10:00 CDMX.

### 11.2 De cada etapa

- Sus requisitos están cubiertos, con pruebas donde la spec las pida.
- `flutter analyze` no da avisos y `flutter test` pasa en CI.
- Se integró en `main` por PR con merge commit.
- El README y el despliegue quedan actualizados si la etapa los afecta.

---

## 12. Decisiones pendientes

| ID | Decisión | Responsable | Límite |
|---|---|---|---|
| P-01 | Estrategia de generación de rutas y DevBot (IA en backend o reglas locales), preguntas y contrato | Front y backend | 18 sep. Si no hay acuerdo, plan B con reglas locales |
| P-02 | Formato final de `temarios_devtalles.json` y campos extra, como la historia del curso | Front | Antes de la Etapa 3 |
| P-03 | Hosting definitivo. Vercel es provisional | Front y backend | Antes de la Etapa 7 |
| P-04 | Fuente de verdad del catálogo: assets del front o API | Front y backend | Con P-01 |

## 13. Riesgos

| Riesgo | Mitigación |
|---|---|
| La IA del backend no llega a tiempo | Plan B de P-01 con reglas locales detrás del mismo repositorio |
| El backend no está disponible durante el desarrollo o la evaluación | `AUTH_SOURCE=mock` permite recorrer toda la app |
| Vercel y algunos paquetes de Flutter (`flutter_web_auth_2`, `flutter_secure_storage`) no aparecen en las descripciones del catálogo | Se interpreta que la regla de tecnologías aplica a frameworks, servicios y proveedores. Flutter, Riverpod, Dart y Firebase sí aparecen, y Firebase Hosting es la alternativa si Vercel se cuestiona |
| Temarios incompletos | Capítulo virtual "Curso completo" (§7.5) |
| Poco margen de tiempo para una sola persona en el front | Etapas pequeñas con fecha, y la Etapa 6 aislada para que su bloqueo no frene al resto |
