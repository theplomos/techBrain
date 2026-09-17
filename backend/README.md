# TechBrain Backend

API REST de **TechBrain**, plataforma que genera rutas de aprendizaje dinámicas para DevTalles (CodeQuest 2026). Este módulo implementa la capa de autenticación, gestión de usuarios, observabilidad y el contrato HTTP de la plataforma.

## Stack

| Componente | Tecnología |
|---|---|
| Framework | NestJS 11 |
| Lenguaje | TypeScript 5 (estricto) |
| ORM | Prisma 6.19.3 |
| Base de datos | PostgreSQL 17 |
| Autenticación | JWT + refresh rotados, bcrypt (costo 12), OAuth2 Discord |
| Documentación | Swagger (`/api/docs`) |
| Observabilidad | Sentry, logger por niveles |
| Contenedores | Docker multistage, Docker Compose |

## Estructura

```text
backend/
├── prisma/
│   ├── schema.prisma          # Fuente única del modelo relacional
│   └── migrations/            # Historial SQL versionado
├── src/
│   ├── auth/                  # Registro, login, JWT, refresh y Discord OAuth2
│   ├── users/                 # Perfil, usuarios y roles
│   ├── prisma/                # PrismaService global para NestJS
│   ├── health/                # Health checks de vida y disponibilidad
│   ├── common/                # Logger, interceptor, filtro global y normalizadores
│   ├── config/                # Validación de entorno y CORS
│   └── scripts/               # Utilidades CLI (promote, validación de entorno)
├── .env.example
└── Dockerfile                 # Multistage: base, deps, validation, migrations, production
```

## Requisitos

- Node.js 22 o superior
- npm
- Docker Desktop (para el stack completo)

## Puesta en marcha local

### Opción A: stack completo en Docker (recomendada)

Desde la raíz del repositorio:

```bash
docker compose --env-file env/dev.env up --build -d
```

Compose levanta PostgreSQL, ejecuta `migrations` (espera a que la base esté sana, aplica `prisma migrate deploy` y termina) y solo después inicia la API.

| Comando | Efecto |
|---|---|
| `docker compose --env-file env/dev.env ps -a` | Estado de los contenedores |
| `docker compose --env-file env/dev.env logs -f backend` | Logs de la API |
| `docker compose --env-file env/dev.env down` | Detener sin borrar datos |
| `docker compose --env-file env/dev.env down -v` | Detener y borrar el volumen (pierde datos) |

La API queda en `http://localhost:3000/api` y Swagger en `http://localhost:3000/api/docs`.

### Opción B: NestJS en el host

Levanta solo PostgreSQL y ejecuta la API desde Node:

```bash
docker compose --env-file env/dev.env up -d postgres
cd backend
npm install
npm run prisma:deploy
npm run start:dev
```

En este modo se usa `backend/.env`; su `DATABASE_URL` apunta a `localhost` en lugar del servicio `postgres`.

## Configuración de entorno

La documentación completa de cada variable está en `docs/environment-variables.md` (raíz del repositorio). Puntos clave:

- `backend/.env` define la ejecución directa en el host. `env/dev.env` define el stack Docker local. `env/production.env` define el despliegue.
- `env/production.env` está ignorado por Git. Nunca debe subirse.
- `DATABASE_URL` dentro de Compose usa el hostname `postgres`; desde el host usa `localhost`.
- Debe existir `JWT_ACCESS_SECRET` (≥ 32 caracteres aleatorios) y `DISCORD_CLIENT_SECRET`.

Para validar un archivo de entorno contra el esquema Joi:

```bash
npm run env:validate -- ../env/dev.env
npm run env:validate -- ../env/production.env
```

## Scripts npm

| Script | Descripción |
|---|---|
| `npm start` / `npm run start:dev` | Arranca NestJS (dev con watch) |
| `npm run start:prod` | Arranca la compilación de `dist` |
| `npm run build` | Compila a `dist` |
| `npm run lint` | ESLint sobre `src` y `test` |
| `npm test` | Pruebas unitarias (Jest) |
| `npm run prisma:generate` | Genera el cliente Prisma |
| `npm run prisma:migrate -- --name X` | Crea una migración tras editar el schema |
| `npm run prisma:deploy` | Aplica migraciones versionadas |
| `npm run prisma:studio` | Navegador visual de la base local |
| `npm run prisma:reset` | Reinicia la base (borra datos) |
| `npm run user:promote -- correo@example.com` | Promueve un usuario a `admin` |
| `npm run env:validate -- <ruta>` | Valida un archivo de entorno |

## Autenticación

- Registro y login con email/contraseña (mensajes que no revelan qué dato es incorrecto).
- Access tokens JWT de corta duración (`JWT_ACCESS_TTL_SECONDS`).
- Refresh tokens opacos, almacenados como hash y rotados tras cada uso.
- Logout revoca el refresh token; cambiar la contraseña revoca todas las sesiones.
- Login OAuth2 con Discord protegido contra CSRF (`state` en cookie) y canje de un código temporal de un solo uso (evita exponer el JWT en la URL).
- Roles `user` y `admin`. El registro público siempre crea usuarios `user`; promueve cuentas con `npm run user:promote`.

## Contrato de respuestas

Respuestas exitosas:

```json
{
  "success": true,
  "statusCode": 200,
  "data": {},
  "path": "/api/users/me",
  "timestamp": "2026-09-16T13:13:05.954Z"
}
```

Errores:

```json
{
  "success": false,
  "statusCode": 400,
  "message": "mensaje o lista de mensajes",
  "error": "Bad Request",
  "path": "/api/users/me",
  "timestamp": "2026-09-16T13:13:05.954Z"
}
```

Las respuestas `204` y los redirects OAuth no se envuelven. El interceptor conserva `meta` en listados paginados.

## Endpoints principales

| Método | Ruta | Acceso | Descripción |
|---|---|---|---|
| `GET` | `/api/health` | Público | Estado de API y base |
| `GET` | `/api/health/live` | Público | Proceso vivo |
| `GET` | `/api/health/ready` | Público | Conexión a PostgreSQL |
| `POST` | `/api/auth/register` | Público | Registro |
| `POST` | `/api/auth/login` | Público | Login |
| `POST` | `/api/auth/refresh` | Público | Rota el refresh token |
| `POST` | `/api/auth/logout` | Público | Revoca sesión |
| `POST` | `/api/auth/change-password` | JWT | Cambia contraseña |
| `GET` | `/api/auth/discord` | Público | Inicia OAuth2 Discord |
| `GET` | `/api/auth/discord/callback` | Discord | Callback OAuth2 |
| `POST` | `/api/auth/discord/exchange` | Público | Canjea el código temporal |
| `GET` | `/api/users/me` | JWT | Perfil actual |
| `PATCH` | `/api/users/me` | JWT | Actualiza perfil |
| `GET` | `/api/users` | Admin | Lista usuarios |
| `PATCH` | `/api/users/:id/access` | Admin | Roles/estado |

Los endpoints protegidos usan `Authorization: Bearer <accessToken>`.

## Observabilidad

- Logger por niveles: `verbose → debug → log → warn → error → fatal`.
- `LOG_LEVEL` controla la consola. Sentry recibe `warn`, `error`, `fatal` y excepciones inesperadas (5xx).
- Con `SENTRY_DSN` vacío la integración queda desactivada.
- Recomendación: sample rate `0.1` y `SENTRY_RELEASE` ligado al commit desplegado.

## Docker

El `Dockerfile` es multistage con un target por etapa:

| Target | Uso |
|---|---|
| `base` | Imagen base node:22-alpine |
| `dependencies` | `npm ci` con caché |
| `validation` | `prisma generate`, lint, build y tests |
| `production-dependencies` | Dependencias de producción |
| `migrations` | Aplica `prisma migrate deploy` y termina |
| `production` | Imagen final: dumb-init, usuario `node`, healthcheck |

Compose usa `target: migrations` y `target: production`. El servicio `migrations` es un job de una sola vez; el servicio `backend` es el proceso vivo que expone la API en `127.0.0.1:${PORT}`.

## Despliegue

El flujo de producción se documenta por completo en la guía de comandos (ver `README.md` de comandos o el `runbook` en el escritorio). Resumen: construir las imágenes con el perfil de producción, publicarlas en Docker Hub y en el servidor ejecutar `pull` + `up --no-build`.

## Calidad

```bash
npm run lint
npm run build
npm test -- --runInBand
npx tsc --noEmit --incremental false -p tsconfig.json
npx prisma validate
```

## Licencia

MIT.