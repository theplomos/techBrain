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
    ├── references/                            # Dataset de cursos e identidad de marca
    │   ├── cursos_devtalles.json              # Dataset JSON de 91 cursos de DevTalles
    │   ├── cursos_devtalles.md                # Catálogo en Markdown con prerrequisitos y duración
    │   └── imagen_corporativa_devtalles.md    # Tokens de diseño, colores y tipografía
    └── rules/                                 # Bases del concurso y rutas oficiales
        ├── CODE QUEST 2026 BRIEF-INFORMATIVO V3.pdf # Brief oficial del CodeQuest 2026
        ├── rutas_aprendizaje_devtalles.json   # 13 rutas de aprendizaje oficiales
        └── rutas_aprendizaje_devtalles.md     # Detalle de cada ruta y sus cursos asociados
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
flutter run -d chrome
```

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

