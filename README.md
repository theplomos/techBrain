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

El proyecto cuenta con una sólida base de documentación técnica, diseño, dataset y código:

```text
techBrain/
├── README.md                                  # Información general del proyecto
├── LICENSE                                    # Licencia MIT oficial
├── .gitignore                                 # Exclusiones de Git
├── vercel.json · vercel-build.sh              # Compilación y despliegue de la web en Vercel
├── docker-compose.yml · env/                  # Entorno de desarrollo del backend
├── backend/                                   # API NestJS con Prisma y autenticación con Discord
├── frontend/                                  # Aplicación Flutter (paquete `techbrain`)
│   ├── assets/                                # Datasets locales JSON y fuentes empaquetadas
│   ├── docs/superpowers/                      # Planes y artefactos de desarrollo
│   ├── lib/                                   # config/ · features/ · shared/
│   ├── specs/                                 # Especificaciones técnicas por etapa
│   ├── test/                                  # Pruebas unitarias, de widgets y responsive
│   ├── tool/                                  # Herramientas y scripts de sincronización
│   └── web/                                   # index.html, manifest.json y vercel.json de la SPA
└── docs/
    ├── Presentacion_Diseno_CodeQuest2026_TechBrain.pdf # Presentación visual del diseño (PDF)
    ├── ideas/                                 # Prototipos y pantallas móviles en Stitch
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
- **Tipografía:** *Space Grotesk* (encabezados) y *DM Sans* (texto de lectura), empaquetadas localmente en assets.

---

## 🚀 Prototipo Stitch

El proyecto interactivo se encuentra modelado en **Google Stitch** con soporte de diseño responsive mobile:
- **Proyecto Stitch ID:** `projects/14643612934649054340`
- **Design System:** `assets/9033636429044497341` (*DevTalles Cosmic Design System*)

---

## 🛠️ Ejecución y Desarrollo del Frontend

Toda la documentación detallada de instalación, variables de entorno, comandos de calidad y arquitectura de la app se encuentra en el [README del Frontend](frontend/README.md).

Para ejecutar rápidamente en local:

```bash
cd frontend
flutter pub get
flutter run -d chrome --web-port 8080
```

Calidad y pruebas automáticas:

```bash
cd frontend
flutter analyze
flutter test
```

---

## 🌐 Despliegue en Producción (Vercel)

El proyecto está configurado para desplegarse como Single Page Application en Vercel con reglas de reescritura que soportan enrutamiento profundo sin errores 404:

```bash
cd frontend
flutter build web --release
npx vercel@latest deploy build/web --prod
```

- **URL de producción:** (se actualizará en el primer despliegue)

---

## 👥 Equipo TechBrain (#13)

- Desarrollado con dedicación para el reto **DevTalles CodeQuest 2026**.
