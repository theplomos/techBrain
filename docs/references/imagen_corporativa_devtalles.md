# Manual de Identidad Visual y Sistema de Diseño: DevTalles

Este documento define la **imagen corporativa, tokens de diseño, tipografías, colores y patrones de componentes** de **DevTalles** para ser implementados en la aplicación del **CodeQuest 2026** por el equipo **TechBrain**.

El objetivo es lograr una interfaz con **100% de coherencia visual**, indistinguible de la plataforma oficial.

---

## 1. Filosofía Visual y ADN de la Marca

* **Estilo Visual:** *Cosmic Cyberpunk / Dark Space Minimalism*.
* **Atmósfera:** Fondos oscuros de espacio profundo con nebulosas violetas, micro-estrellas dispersas, superficies translúcidas con efecto de vidrio esmerilado (*glassmorphism*) y acentos vibrantes neón (morado eléctrico y lima cibernético).
* **Mascotas e Iconografía:** Robots esféricos oscuros con visores/auriculares violetas y el distintivo monograma `{dev/talles}` enmarcado entre llaves `{}`.

---

## 2. Paleta de Colores Oficial (Design Tokens)

### 2.1 Colores Principales y Fondos

| Token | Variable CSS | Hex / Valor | Uso |
|---|---|---|---|
| **Canvas Background** | `--bg-primary` | `#171027` | Fondo global de la aplicación (violeta espacio profundo). |
| **Surface / Card Box** | `--bg-box` | `#1c1829` | Fondo base sólido para modales y contenedores. |
| **Glass Card Fill** | `--card-bg` | `rgba(28, 24, 41, 0.85)` | Fondo con transparencia para tarjetas y paneles con blur. |
| **Card Border** | `--card-border` | `rgba(192, 185, 252, 0.12)` | Borde sutil traslúcido para separación de componentes. |
| **Card Border Hover**| `--card-border-hover` | `rgba(192, 185, 252, 0.30)` | Borde al interactuar o pasar el cursor. |
| **Navbar Background** | `--nav-bg` | `rgba(23, 16, 39, 0.85)` | Barra de navegación superior fija con blur. |

### 2.2 Acentos y Estados

| Token | Variable CSS | Hex / Valor | Uso |
|---|---|---|---|
| **Electric Violet** | `--accent-electric` | `#3a14c4` | Color insignia de DevTalles (botones primarios, glows). |
| **Mid Purple** | `--accent-mid` | `#4725af` | Tono intermedio para gradientes de botones y badges. |
| **Deep Purple** | `--accent-deep` | `#5a16c1` | Tono para sombras profundas y fondos de acento. |
| **Lavender Light** | `--accent-lt` | `#c0b9fc` | Títulos secundarios, bordes sutiles y estados inactivos. |
| **Cyber Lime (Vivid)**| `--accent-vivid` | `#c8dd09` | Acento neón de alto impacto para botones CTA, badges "NUEVO" y progreso. |
| **Discord Brand** | `--brand-discord` | `#5865F2` | Botón de inicio de sesión con Discord (OAuth2). |

### 2.3 Tipografía y Textos

| Token | Variable CSS | Hex / Valor | Uso |
|---|---|---|---|
| **Text Primary** | `--text-main` | `#f0eeff` | Texto principal, encabezados h1/h2/h3 (blanco liláceo nítido). |
| **Text Muted** | `--text-muted` | `#9b93c8` | Párrafos descriptivos, metadatos y etiquetas secundarias. |
| **Text Subtitle / Tag**| `--text-sub` | `rgba(192, 185, 252, 0.55)` | Encabezados de columnas (ej. `REQUERIDO`) con tracking ancho. |

### 2.4 Etiquetas de Categorías y Especialidad (Badges de Ruta)

En las rutas oficiales de DevTalles, cada curso tiene un chip distintivo que indica su área tecnológica:

| Categoría | Variable CSS | Valor de Fondo | Borde / Resalte |
|---|---|---|---|
| **BASES** | `--basesBOX-color` | `rgba(192, 185, 252, 0.20)` | Borde lavanda `#c0b9fc` |
| **FRONTEND** | `--frontendBOX-color` | `rgba(48, 10, 111, 0.55)` | Borde violeta profundo `#7e70f9` |
| **BACKEND** | `--backendBOX-color` | `rgba(58, 20, 196, 0.50)` | Borde azul eléctrico `#3a14c4` |
| **MÓVIL** | `--movilBOX-color` | `rgba(200, 221, 9, 0.25)` | Borde verde lima neón `#c8dd09` |
| **WEB** | `--webBOX-color` | `rgba(244, 174, 163, 0.25)` | Borde coral suave `#f4aea3` |
| **AGENTES IA** | `--aiBOX-color` | `rgba(162, 0, 255, 0.35)` | Borde púrpura neón `#a200ff` |

---

## 3. Tipografía y Jerarquía

DevTalles utiliza dos tipografías de Google Fonts con funciones bien delimitadas:

```html
<!-- Importación Oficial en HTML -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:ital,wght@0,300;0,400;0,500;0,700;1,400&family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
```

### 3.1 `Space Grotesk` (Títulos, Branding y Números)
* **Familia:** `'Space Grotesk', sans-serif`
* **Pesos:** 500 (Medium), 600 (SemiBold), 700 (Bold).
* **Usos:**
  * Logo de marca: `{dev/talles}`
  * Títulos de sección (`h1`, `h2`, `h3`)
  * Títulos de cursos y tarjetas
  * Porcentajes de progreso y números destacados

### 3.2 `DM Sans` (Cuerpo, Botones, UI e Inputs)
* **Familia:** `'DM Sans', sans-serif`
* **Pesos:** 400 (Regular), 500 (Medium), 700 (Bold).
* **Usos:**
  * Párrafos y descripciones de cursos
  * Botones (siempre en `font-weight: 500` con `letter-spacing: 2px` en mayúsculas)
  * Chips de categoría y filtros
  * Encabezados de columnas (`REQUERIDO`, `RECOMENDADO`) en tamaño `0.75rem` y `letter-spacing: 2.5px`

### 3.3 Monospace (Código y Comandos)
* **Familia:** `ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Fira Code", monospace`
* **Usos:** Snippets, tags técnicos, IDs y credenciales de Discord.

---

## 4. Patrones de Diseño de Componentes

### 4.1 Tarjeta de Curso (`Course Card`)
La tarjeta es el bloque central de la experiencia en DevTalles.

```css
.devtalles-card {
  display: flex;
  flex-direction: column;
  position: relative;
  background: rgba(28, 24, 41, 0.85);
  border: 1px solid rgba(192, 185, 252, 0.12);
  border-radius: 18px;
  overflow: hidden;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  box-shadow: 
    0 0 0 1px rgba(192, 185, 252, 0.06), 
    0 8px 32px rgba(58, 20, 196, 0.18);
  transition: transform 0.2s cubic-bezier(0.16, 1, 0.3, 1), 
              border-color 0.2s ease, 
              box-shadow 0.2s ease;
}

.devtalles-card:hover {
  transform: translateY(-4px);
  border-color: rgba(192, 185, 252, 0.30);
  box-shadow: 
    0 0 0 1px rgba(192, 185, 252, 0.10), 
    0 16px 48px rgba(58, 20, 196, 0.35);
}
```

* **Aspect Ratio de Carátula:** `16:9` o `300px x 170px`.
* **Badge "NUEVO" o "PRO":** Posicionado en la esquina superior izquierda sobre la imagen con fondo neón o violeta sólido (`border-radius: 4px` o píldora).

---

### 4.2 Botones (`Buttons`)
Los botones de DevTalles tienen forma de **píldora redondeada completa (`border-radius: 50px` / `rounded-full`)**, texto en mayúsculas con espaciado amplio.

#### Botón Primario (Electric Gradient)
```css
.btn-primary {
  font-family: 'DM Sans', sans-serif;
  font-size: 0.813rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 2px;
  color: #ffffff;
  background: linear-gradient(135deg, #4725af 0%, #3a14c4 100%);
  padding: 13px 28px;
  border-radius: 50px;
  border: none;
  cursor: pointer;
  box-shadow: 0 4px 14px rgba(58, 20, 196, 0.39);
  transition: transform 0.18s ease, box-shadow 0.18s ease, filter 0.18s ease;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.btn-primary:hover {
  transform: translateY(-2px);
  filter: brightness(1.1);
  box-shadow: 0 8px 24px rgba(58, 20, 196, 0.55);
}
```

#### Botón Secundario (Outline Lavanda)
```css
.btn-secondary {
  font-family: 'DM Sans', sans-serif;
  font-size: 0.813rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 2px;
  color: #f0eeff;
  background: transparent;
  padding: 12px 26px;
  border-radius: 50px;
  border: 2px solid #c0b9fc;
  cursor: pointer;
  transition: background 0.18s, border-color 0.18s, transform 0.18s;
}

.btn-secondary:hover {
  background: rgba(192, 185, 252, 0.12);
  border-color: #ffffff;
  transform: translateY(-2px);
}
```

#### Botón Call-to-Action (Cyber Lime)
```css
.btn-vivid {
  font-family: 'DM Sans', sans-serif;
  font-size: 0.813rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1.5px;
  color: #0F172A; /* Texto oscuro para máximo contraste WCAG AAA */
  background: #c8dd09;
  padding: 13px 28px;
  border-radius: 50px;
  border: none;
  box-shadow: 0 0 20px rgba(200, 221, 9, 0.35);
  cursor: pointer;
  transition: transform 0.18s, box-shadow 0.18s;
}

.btn-vivid:hover {
  transform: translateY(-2px);
  box-shadow: 0 0 30px rgba(200, 221, 9, 0.60);
}

/* Regla Semántica de Jerarquía de Botones (ui-ux-pro-max):
   1. .btn-vivid (Cyber Lime #c8dd09): Exclusivo para la Acción Clave #1 por viewport (ej. 'Continuar Lección ▶', 'Generar Mi Ruta ⚡').
   2. .btn-primary (Gradiente Eléctrico): Acciones de submit o del sistema ('Iniciar Sesión', 'Crear Cuenta', 'Guardar').
   3. .btn-secondary (Outline Glass): Acciones de exploración o secundarias ('Explorar 13 Rutas', 'Marcar Completada', 'Volver').
*/
```

#### Botón Discord OAuth (Obligatorio en CodeQuest)
```css
.btn-discord {
  font-family: 'DM Sans', sans-serif;
  font-size: 0.875rem;
  font-weight: 500;
  color: #ffffff;
  background: #5865F2;
  padding: 12px 24px;
  border-radius: 50px;
  border: none;
  display: inline-flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  transition: background 0.2s, transform 0.2s;
}

.btn-discord:hover {
  background: #4752c4;
  transform: translateY(-2px);
}
```

---

### 4.3 Simbología Universal de Rutas (WCAG 2.2 & Daltonismo)

Para garantizar accesibilidad universal y evitar depender exclusivamente del color para comunicar prioridad, los 3 niveles de la ruta usan **símbolos geométricos únicos**:

| Nivel | Símbolo | Color Base | Background / Borde | Significado Pedagógico |
|---|---|---|---|---|
| **Nivel 1: Requerido** | **`⬢` (Diamante)** | `#ef4444` (Carmesí) | `rgba(239, 68, 68, 0.15)` / `border-rose-500/40` | Fundamentos críticos y prerrequisitos obligatorios. |
| **Nivel 2: Recomendado**| **`★` (Estrella)** | `#c8dd09` (Cyber Lime)| `rgba(200, 221, 9, 0.15)` / `border-lime-400/40` | Especialización, frameworks y demanda laboral. |
| **Nivel 3: Opcional** | **`●` (Círculo)** | `#c0b9fc` (Lavanda) | `rgba(192, 185, 252, 0.15)` / `border-lavender/30` | Herramientas complementarias y superpoderes electivos. |

---

### 4.4 Estandarización de Bordes y Superficies Glassmorphism

```css
:root {
  /* Escala Uniforme de Border Radius */
  --radius-card: 16px;       /* Tarjetas de cursos, formularios, modales (rounded-2xl) */
  --radius-inner: 10px;      /* Inputs, badges, botones secundarios (rounded-xl) */
  --radius-pill: 9999px;     /* Chips, quick prompts, botones primarios (rounded-full) */

  /* Glassmorphism Balanceado para Alto Rendimiento (60 FPS) */
  --glass-surface: rgba(26, 17, 46, 0.75);
  --glass-border: rgba(192, 185, 252, 0.15);
  --glass-blur: 16px;
}

/* Regla de Rendimiento Mobile:
   El backdrop-filter blur se aplica ÚNICAMENTE en la Top App Bar y la Bottom Navigation Bar fijas.
   Las tarjetas y burbujas internas usan fondo opaco estilizado (background: #1c1533) sin blur anidado.
*/
```

---

### 4.5 Arquitectura de Navegación Unificada (Web & Mobile)

Para eliminar incongruencias de taxonomía, la aplicación se estructura en 4 vistas centrales:

1. **Dashboard** (`/home`): Centro de mando del estudiante, racha, ruta activa y métricas.
2. **Rutas** (`/rutas`): Catálogo interactivo de 13 rutas oficiales con filtros por stack.
3. **Copiloto IA** (`/copilot`): Cuestionario adaptativo y diálogo en tiempo real con DevBot.
4. **Mi Ruta** (`/mi-ruta`): Tablero en 3 niveles (`⬢`, `★`, `●`) con panel lateral *sticky* de detalles.
* **Ajustes & Discord:** Menú desplegable accesible desde el Avatar del usuario en el extremo derecho.

---

### 4.6 Visualizador de Rutas de Aprendizaje (`RutaWrapper`)
El diseño del árbol o ruta de aprendizaje oficial de DevTalles estructura el progreso en tres carriles o columnas:

* **Distribución:** Grid de 3 columnas (`grid-template-columns: 1fr 1fr 1fr; gap: 20px;`)
* **Encabezados de Columna (`.encabezado`):**
  * `font-family: 'DM Sans', sans-serif;`
  * `font-size: 0.688rem;` (11px)
  * `letter-spacing: 2.5px;`
  * `text-transform: uppercase;`
  * `color: rgba(192, 185, 252, 0.55);`
* **Cajas de Curso de Ruta (`.main-box`):**
  * Ancho fijo o máx: `300px`.
  * `background: rgba(28, 24, 41, 0.85);`
  * `border: 1px solid rgba(192, 185, 252, 0.12);`
  * `border-radius: var(--radius-card);`
  * En la parte inferior (`.bottom-box`), incluye el chip de categoría (`bases-box`, `frontend-box`, `backend-box`) y el logo SVG de la tecnología (`42px x 42px`).

---

### 4.4 Fondo Espacial con Resplandor Cósmico (`Cosmic Background`)
DevTalles no usa un fondo plano, sino un fondo multicapa que le da profundidad:

```css
body {
  margin: 0;
  background-color: #171027;
  color: #f0eeff;
  font-family: 'DM Sans', sans-serif;
  background-image: 
    radial-gradient(ellipse 55% 65% at 75% 45%, rgba(58, 20, 196, 0.38) 0%, transparent 70%),
    radial-gradient(ellipse 35% 45% at 15% 85%, rgba(90, 22, 193, 0.20) 0%, transparent 60%);
  background-attachment: fixed;
  min-height: 100vh;
}
```

---

## 5. Recursos e Íconos Oficiales (SVGs)

DevTalles utiliza los siguientes íconos oficiales para las categorías y tecnologías:

| Tecnología | URL del Ícono Oficial |
|---|---|
| **DevTalles Icon** | `https://import.cdn.thinkific.com/643563%2Fcustom_site_themes%2Fid%2FWfAxXZRxQleTTbGJPzpp_devtalles-icon.png` |
| **Fundamentos (VS Code)**| `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-STUDIOCODE.svg` |
| **JavaScript** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-JS.svg` |
| **TypeScript** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-TS.svg` |
| **React** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-REACT.svg` |
| **Vue** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-VUE.svg` |
| **Angular** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-ANGULAR.svg` |
| **Node.js** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-NODE.svg` |
| **NestJS** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-NEST.svg` |
| **Dart / Flutter** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-DART.svg` |
| **Python** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-PYTHON.svg` |
| **Java** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-JAVA.svg` |
| **C# (.NET)** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/2ICON-CSHARP.svg` |
| **Inteligencia Artificial** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-IA.svg` |
| **PHP** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-PHP4.svg` |
| **Go** | `https://raw.githubusercontent.com/Nleivas/Backgrounds/refs/heads/main/ICON-GO.svg` |

---

## 6. Configuración Lista para Copiar en `tailwind.config.js`

Para que el equipo TechBrain pueda maquetar directamente en Tailwind CSS sin adivinar valores:

```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        devtalles: {
          bg: '#171027',            // Fondo cósmico principal
          box: '#1c1829',           // Contenedor sólido
          card: 'rgba(28, 24, 41, 0.85)', // Glassmorphic card
          border: 'rgba(192, 185, 252, 0.12)',
          'border-hover': 'rgba(192, 185, 252, 0.30)',
          electric: '#3a14c4',      // Morado vibrante insignia
          mid: '#4725af',           // Morado medio
          deep: '#5a16c1',          // Morado oscuro
          lavender: '#c0b9fc',      // Lavanda suave
          lime: '#c8dd09',          // Verde lima cyber CTA
          text: '#f0eeff',          // Texto blanco liláceo
          muted: '#9b93c8',         // Texto secundario
          discord: '#5865F2',       // Discord OAuth
        },
        category: {
          bases: 'rgba(192, 185, 252, 0.25)',
          frontend: 'rgba(48, 10, 111, 0.55)',
          backend: 'rgba(58, 20, 196, 0.50)',
          movil: 'rgba(200, 221, 9, 0.25)',
          web: 'rgba(244, 174, 163, 0.25)',
          ai: 'rgba(162, 0, 255, 0.35)',
        }
      },
      fontFamily: {
        heading: ['"Space Grotesk"', 'sans-serif'],
        sans: ['"DM Sans"', 'sans-serif'],
        code: ['ui-monospace', 'SFMono-Regular', 'Menlo', 'Monaco', 'Consolas', 'monospace'],
      },
      borderRadius: {
        'pill': '50px',
        'card': '18px',
      },
      boxShadow: {
        'glow-sm': '0 0 0 1px rgba(192, 185, 252, 0.06), 0 8px 32px rgba(58, 20, 196, 0.18)',
        'glow-lg': '0 0 0 1px rgba(192, 185, 252, 0.10), 0 16px 48px rgba(58, 20, 196, 0.35)',
        'glow-lime': '0 0 25px rgba(200, 221, 9, 0.45)',
        'glow-discord': '0 4px 16px rgba(88, 101, 242, 0.40)',
      }
    },
  },
  plugins: [],
}
```

---

## 7. Claves de Éxito en UI para la Evaluación del Jurado

1. **Mantener siempre el tema oscuro (*Dark Mode first*):** DevTalles no usa modo claro tradicional; toda la identidad es cósmica oscura.
2. **Píldoras redondeadas (`rounded-full` / `50px`):** Todos los botones e insignias deben tener los bordes completamente redondeados.
3. **Resplandor morado en hover (`box-shadow` suave):** Todo componente interactivo (tarjetas, botones, inputs) debe elevarse ligeramente (`translate-y-1`) y emitir un glow violeta al pasar el cursor.
4. **Logotipo tipográfico:** Usar `{dev/talles}` destacando las llaves `{ }` con el color lavanda `#c0b9fc` y el texto en blanco negrita con fuente `Space Grotesk`.
