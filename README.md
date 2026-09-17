# 🧠 TechBrain — Generador de Rutas de Aprendizaje Dinámicas

> **DevTalles CodeQuest 2026** — *Equipo #13 (TechBrain)*  
> **Licencia:** MIT License

---

## 📌 Descripción del Proyecto

**TechBrain** es una plataforma interactiva e inteligente diseñada para solucionar la sobrecarga de información que enfrentan los estudiantes al elegir su camino de aprendizaje tecnológico. 

Utilizando el catálogo oficial de más de 90 cursos de [DevTalles](https://devtalles.com), TechBrain evalúa las habilidades actuales del usuario mediante cuestionarios adaptativos y un asistente conversacional con Inteligencia Artificial (**DevBot Copilot**), generando una ruta de estudio personalizada estructurada en tres niveles clave:
1. **Requerido (Fundamentos críticos)**
2. **Recomendado (Especialización y profundización)**
3. **Opcional (Complementos y herramientas avanzadas)**

---

## 📁 Estructura del Repositorio

El proyecto cuenta con una sólida base de documentación técnica, diseño y datos:

```text
techBrain/
├── README.md                                  # Información general del proyecto
├── LICENSE                                    # Licencia MIT oficial
├── .gitignore                                 # Exclusiones de Git
├── vercel.json · vercel-build.sh              # Compilación y despliegue de la web en Vercel
├── scripts/deploy-demo.sh                     # Despliegue manual del demo
├── docker-compose.yml · env/                  # Entorno de desarrollo del backend
├── backend/                                   # API NestJS con Prisma y autenticación con Discord
├── frontend/                                  # Aplicación Flutter (paquete `techbrain`)
│   ├── lib/                                   # config/ (router y tema) · features/ · shared/
│   ├── test/                                  # Pruebas de widgets, modelos y navegación
│   ├── web/                                   # index.html, manifest y vercel.json de la SPA
│   └── specs/                                 # Especificación de cada etapa del desarrollo
└── docs/
    ├── Presentacion_Diseno_CodeQuest2026_TechBrain.pdf # Presentación visual del diseño (PDF)
    ├── ideas/                                 # Prototipos y pantallas móviles en Stitch
    │   ├── prototipo_stitch_devtalles.md      # Especificación técnica del proyecto en Stitch
    │   ├── stitch_screens/                    # Capturas HD de las pantallas diseñadas
    │   │   ├── 1_login.png                    # Inicio de sesión con Discord OAuth2
    │   │   ├── 2_registro.png                 # Registro de usuario
    │   │   ├── 3_home.png                     # Dashboard con Navbar, Stats y Progreso
    │   │   ├── 4_cuestionario.png             # Cuestionario de evaluación tradicional
    │   │   └── 5_cuestionario_ia.png          # Cuestionario conversacional con IA
    │   └── stitch_edit_screen_2.json          # Registro de iteración de diseño
    ├── requerimiento_general_frontend.md      # Requerimiento del frontend: alcance, etapas y arquitectura
    ├── references/                            # Dataset de cursos e identidad de marca
    │   ├── cursos_devtalles.json              # Dataset JSON de 91 cursos de DevTalles
    │   ├── cursos_devtalles.md                # Catálogo en Markdown con prerrequisitos y duración
    │   ├── rutas_aprendizaje_devtalles.json   # 13 rutas de aprendizaje oficiales
    │   ├── rutas_aprendizaje_devtalles.md     # Detalle de cada ruta y sus cursos asociados
    │   └── imagen_corporativa_devtalles.md    # Tokens de diseño, colores y tipografía
    └── rules/                                 # Bases del concurso
        └── CODE QUEST 2026 BRIEF-INFORMATIVO V3.pdf # Brief oficial del CodeQuest 2026
```

---

## 🎨 Sistema de Diseño Cósmico (DevTalles UI)

El diseño visual está alineado 1:1 con la identidad de marca de DevTalles:

- **Fondo Deep Space:** `#171027`
- **Púrpura Primario:** `#3a14c4` / `#4d1cd6`
- **Lavanda Suave:** `#c0b9fc`
- **Acento Neón (Volt):** `#c8dd09` (indicadores de progreso y call-to-actions destacados)
- **Tipografía:** *Space Grotesk* (encabezados) y *DM Sans* (texto de lectura).

---

## 🚀 Prototipo Stitch

El proyecto interactivo se encuentra modelado en **Google Stitch** con soporte de diseño responsive mobile:
- **Proyecto Stitch ID:** `projects/14643612934649054340`
- **Design System:** `assets/9033636429044497341` (*DevTalles Cosmic Design System*)

---

---

## 🛠️ Ejecución Local

Para ejecutar el frontend en tu entorno local:

```bash
cd frontend
flutter pub get
flutter run -d chrome --web-port 8080
```

Comprobaciones de calidad, desde `frontend/`:

```bash
flutter analyze
flutter test
flutter test test/shared/widgets_test.dart   # Un solo archivo de pruebas
```

> Lo desplegado hoy es un **demo visual** con datos de ejemplo. Las funcionalidades del concurso se incorporan por etapas, siguiendo `docs/requerimiento_general_frontend.md` y las specs de `frontend/specs/`.

---

## 🌐 Despliegue en Vercel (Demo)

El proyecto está 100% configurado para desplegarse en Vercel mediante tres métodos:

### Método 1: Despliegue Rápido con CLI (Recomendado para demos inmediatas)
Ejecuta el script automatizado desde la raíz del repositorio:
```bash
./scripts/deploy-demo.sh
```
O manualmente:
```bash
cd frontend && flutter build web --release
cd build/web && npx vercel --prod
```

### Método 2: Despliegue continuo desde GitHub (Automático)
El repositorio incluye el workflow de GitHub Actions en `.github/workflows/deploy-vercel.yml`. Cada `push` a la rama `main` compilará la versión web y la publicará automáticamente en Vercel (requiere configurar los secrets `VERCEL_TOKEN`, `VERCEL_ORG_ID` y `VERCEL_PROJECT_ID`).

### Método 3: Compilación directa en Vercel (Vercel Build)
Al importar el repositorio en el panel de Vercel, el archivo `vercel.json` invoca automáticamente `vercel-build.sh`, el cual descarga el SDK de Flutter en el contenedor y compila los archivos estáticos en `frontend/build/web`.

> **Nota:** El archivo `vercel.json` incluye las reglas de reescritura (*rewrites*) necesarias para que el enrutamiento con `go_router` (`/home`, `/explore`, `/quiz`, `/settings`) no arroje error 404 al recargar el navegador.

---

## 👥 Equipo TechBrain (#13)

- Desarrollado con dedicación para el reto **DevTalles CodeQuest 2026**.

