# Variables de entorno

TechBrain separa dos clases de configuración:

- Variables de Docker Compose: controlan contenedores, imágenes, puertos y PostgreSQL.
- Variables de aplicación: son recibidas por NestJS, Prisma, JWT, Discord y Sentry.

## Perfiles disponibles

| Archivo | Uso | Git |
|---|---|---|
| `env/dev.env` | Stack Docker local listo para usar | Versionado |
| `env/production.env.example` | Plantilla de producción sin secretos reales | Versionado |
| `env/production.env` | Configuración real de producción | Ignorado |
| `backend/.env` | NestJS y Prisma ejecutados directamente en el host | Ignorado |
| `backend/.env.example` | Plantilla para ejecución directa en el host | Versionado |

## Docker Compose

| Variable | Requerida | Descripción |
|---|---|---|
| `COMPOSE_PROJECT_NAME` | No | Nombre del proyecto Compose. Separa redes y recursos entre ambientes. |
| `CONTAINER_NAME_PREFIX` | No | Prefijo de los contenedores de API y PostgreSQL. |
| `BACKEND_IMAGE_NAME` | No | Nombre de la imagen de la API. |
| `MIGRATIONS_IMAGE_NAME` | No | Nombre de la imagen que ejecuta `prisma migrate deploy`. |
| `IMAGE_TAG` | No | Etiqueta de ambas imágenes, por ejemplo `dev` o un SHA de Git. |
| `POSTGRES_IMAGE` | No | Imagen y versión de PostgreSQL. |
| `POSTGRES_PORT` | No | Puerto de PostgreSQL publicado en el host. |
| `POSTGRES_VOLUME_NAME` | No | Nombre del volumen persistente. Cada ambiente debe usar uno diferente. |
| `POSTGRES_USER` | Sí | Usuario creado por la imagen oficial de PostgreSQL. |
| `POSTGRES_PASSWORD` | Sí | Contraseña de PostgreSQL. Debe coincidir con `DATABASE_URL`. |
| `POSTGRES_DB` | Sí | Base creada al inicializar el volumen. Debe coincidir con `DATABASE_URL`. |

## Aplicación

| Variable | Requerida | Descripción |
|---|---|---|
| `NODE_ENV` | No | Ambiente de ejecución: `development`, `test`, `staging` o `production`. Activa cookies seguras en producción y etiqueta eventos de Sentry. |
| `PORT` | No | Puerto interno en el que escucha NestJS. El valor predeterminado es `3000`. |
| `APP_NAME` | No | Nombre mostrado por Swagger y utilizado para identificar la API. |
| `FRONTEND_URL` | Sí | URL principal del frontend. Se usa como destino después del login de Discord y como fallback de CORS. |
| `CORS_ORIGINS` | No | Lista de orígenes permitidos separada por comas. Si está vacía se usa `FRONTEND_URL`. No admite `*` con credenciales. |
| `LOG_LEVEL` | No | Nivel mínimo de consola: `verbose`, `debug`, `log`, `warn`, `error` o `fatal`. |

## PostgreSQL y Prisma

| Variable | Requerida | Descripción |
|---|---|---|
| `DATABASE_URL` | Sí | Conexión PostgreSQL usada por Prisma y las migraciones. Dentro de Compose el hostname es `postgres`; desde el host es `localhost`. |

Si la contraseña contiene caracteres reservados como `@`, `:`, `/` o `#`, debe codificarse para URL antes de incluirla en `DATABASE_URL`.

## JWT y sesiones

| Variable | Requerida | Descripción |
|---|---|---|
| `JWT_ACCESS_SECRET` | Sí | Secreto HMAC para firmar access tokens. Debe tener al menos 32 caracteres aleatorios y ser distinto por ambiente. |
| `JWT_ACCESS_TTL_SECONDS` | No | Duración del access token en segundos. El valor recomendado es `900` (15 minutos). |
| `REFRESH_TOKEN_TTL_DAYS` | No | Duración de refresh sessions en días. Los tokens se almacenan como hash y se rotan al usarlos. |

## Discord OAuth2

| Variable | Requerida | Descripción |
|---|---|---|
| `DISCORD_CLIENT_ID` | Sí | Identificador público de la aplicación en Discord Developer Portal. |
| `DISCORD_CLIENT_SECRET` | Sí | Secreto OAuth2 de Discord. Nunca debe subirse a Git. |
| `DISCORD_CALLBACK_URL` | Sí | URL exacta registrada en Discord para `/api/auth/discord/callback`. |
| `DISCORD_REQUIRE_GUILD_MEMBERSHIP` | No | Si es `true`, exige pertenecer al servidor configurado. |
| `DISCORD_GUILD_ID` | Condicional | ID del servidor DevTalles. Es obligatorio cuando la validación de membresía está activa. |

## Sentry

| Variable | Requerida | Descripción |
|---|---|---|
| `SENTRY_DSN` | No | DSN del proyecto Sentry. Vacío desactiva completamente el envío. |
| `SENTRY_RELEASE` | No | Versión desplegada, idealmente `techbrain@<git-sha>`. Permite relacionar errores con releases. |
| `SENTRY_TRACES_SAMPLE_RATE` | No | Proporción de trazas entre `0` y `1`. Usa `0` en local y un valor bajo como `0.1` en producción. |

Sentry toma el ambiente directamente de `NODE_ENV`; no se mantiene una variable duplicada para ello.

## Variables eliminadas

| Variable | Motivo |
|---|---|
| `API_URL` | No tenía ningún consumidor en el backend. |
| `SENTRY_ENVIRONMENT` | Duplicaba `NODE_ENV`. |
| `DB_HOST`, `DB_PORT`, `DB_SSL` | Prisma utiliza exclusivamente `DATABASE_URL`. |
| `POSTGRES_BIND_ADDRESS` | Un valor fijo disfrazado de configuración. El bind del compose quedó fijo en `127.0.0.1`. |
| `API_BIND_ADDRESS` | Con Nginx en el host no aporta nada. La API se publica fija en `127.0.0.1` con `PORT`. |
| `API_PORT` | Duplicaba `PORT`. La API se publica con una sola variable: `127.0.0.1:${PORT}:${PORT}`. |

## Publicación de puertos

El `docker-compose.yml` define los binds fijos:

- API: `127.0.0.1:${PORT}:${PORT}` (loopback, alcanzable desde el VPS por Nginx en el host).
- PostgreSQL: `127.0.0.1:${POSTGRES_PORT:-5432}:5432` (loopback, solo herramientas del host).

El backend nunca usa el puerto publicado de PostgreSQL: se conecta por la red Docker usando `postgres:5432` en `DATABASE_URL`.

Nota: como `PORT` es a la vez el puerto interno de NestJS y el publicado, `PORT` debe coincidir en ambos lados. Para probar directo por `http://3.135.86.234:3000` hay que cambiar el compose a `0.0.0.0:${PORT}:${PORT}` de forma temporal, o permitir el puerto 3000 en el Security Group de AWS.

## Comandos

Desarrollo completo:

```bash
docker compose --env-file env/dev.env up --build -d
```

Detener desarrollo sin eliminar datos:

```bash
docker compose --env-file env/dev.env down
```

Producción:

```bash
cp env/production.env.example env/production.env
# Editar secretos y dominios antes de continuar.
docker compose --env-file env/production.env up --build -d
```

Consultar el resultado de interpolación antes de desplegar:

```bash
docker compose --env-file env/production.env config
```

Validar las variables que recibirá NestJS antes de levantar contenedores:

```bash
cd backend
npm run env:validate -- ../env/dev.env
npm run env:validate -- ../env/production.env
```
