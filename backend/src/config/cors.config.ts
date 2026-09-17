import { ConfigService } from '@nestjs/config';
import { CorsOptions } from '@nestjs/common/interfaces/external/cors-options.interface';

export function buildCorsOptions(config: ConfigService): CorsOptions {
  const configuredOrigins = config.get<string>('CORS_ORIGINS', '');
  const fallbackOrigin = config.getOrThrow<string>('FRONTEND_URL');
  const allowedOrigins = (configuredOrigins || fallbackOrigin)
    .split(',')
    .map((origin) => origin.trim().replace(/\/$/, ''))
    .filter(Boolean);

  return {
    origin: (origin, callback) => {
      if (!origin || allowedOrigins.includes(origin.replace(/\/$/, ''))) {
        callback(null, true);
        return;
      }
      callback(new Error(`Origen no permitido por CORS: ${origin}`), false);
    },
    methods: ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE', 'OPTIONS'],
    allowedHeaders: [
      'Authorization',
      'Content-Type',
      'Accept',
      'Origin',
      'sentry-trace',
      'baggage',
    ],
    credentials: true,
    maxAge: 86_400,
  };
}
