import './instrument';

import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as Sentry from '@sentry/nestjs';
import cookieParser from 'cookie-parser';
import helmet from 'helmet';
import { join } from 'node:path';
import { AppModule } from './app.module';
import { GlobalExceptionFilter } from './common/filters/global-exception.filter';
import { AppLoggerService } from './common/logger/app-logger.service';
import { buildCorsOptions } from './config/cors.config';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    bufferLogs: true,
  });
  const config = app.get(ConfigService);
  const logger = app.get(AppLoggerService);

  app.useLogger(logger);
  app.flushLogs();
  app.setGlobalPrefix('api');
  app.use(helmet());
  app.use(cookieParser());
  app.useStaticAssets(join(__dirname, '..', 'public'));
  app.enableCors(buildCorsOptions(config));
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  app.useGlobalFilters(new GlobalExceptionFilter(logger));
  app.enableShutdownHooks();

  const swaggerConfig = new DocumentBuilder()
    .setTitle(config.get<string>('APP_NAME', 'TechBrain API'))
    .setDescription('API para rutas de aprendizaje personalizadas')
    .setVersion('0.1.0')
    .addBearerAuth()
    .build();
  SwaggerModule.setup('api/docs', app, () =>
    SwaggerModule.createDocument(app, swaggerConfig),
  );

  const port = config.get<number>('PORT', 3000);
  await app.listen(port);
  logger.log(`TechBrain API ejecutándose en el puerto ${port}`, 'Bootstrap');
}

void bootstrap().catch(async (error: unknown) => {
  Sentry.captureException(error);
  await Sentry.flush(2_000);
  console.error('No se pudo iniciar TechBrain API', error);
  process.exitCode = 1;
});
