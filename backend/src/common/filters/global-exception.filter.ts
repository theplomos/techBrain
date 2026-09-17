import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { Request, Response } from 'express';
import { AppLoggerService } from '../logger/app-logger.service';

interface ErrorBody {
  success: false;
  statusCode: number;
  message: string | string[];
  error?: string;
  path: string;
  timestamp: string;
}

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  constructor(private readonly logger: AppLoggerService) {}

  catch(exception: unknown, host: ArgumentsHost): void {
    const context = host.switchToHttp();
    const request = context.getRequest<Request>();
    const response = context.getResponse<Response>();
    const { status, message, error } = this.resolveException(exception);

    if (Number(status) >= 500) {
      this.logger.reportException(exception, {
        method: request.method,
        path: request.originalUrl,
      });
    }

    const body: ErrorBody = {
      success: false,
      statusCode: status,
      message,
      path: request.originalUrl,
      timestamp: new Date().toISOString(),
    };
    if (error) body.error = error;
    response.status(status).json(body);
  }

  private resolveException(exception: unknown): {
    status: number;
    message: string | string[];
    error?: string;
  } {
    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      const payload = exception.getResponse();
      if (typeof payload === 'string') return { status, message: payload };

      const response = payload as {
        message?: string | string[];
        error?: string;
      };
      return {
        status,
        message: response.message ?? exception.message,
        error: response.error,
      };
    }

    if (exception instanceof Prisma.PrismaClientKnownRequestError) {
      if (exception.code === 'P2002') {
        return { status: HttpStatus.CONFLICT, message: 'El recurso ya existe' };
      }
      if (exception.code === 'P2025') {
        return {
          status: HttpStatus.NOT_FOUND,
          message: 'Recurso no encontrado',
        };
      }
      if (exception.code === 'P2003') {
        return {
          status: HttpStatus.CONFLICT,
          message: 'El recurso está relacionado con otros registros',
        };
      }
    }

    if (exception instanceof Prisma.PrismaClientInitializationError) {
      return {
        status: HttpStatus.SERVICE_UNAVAILABLE,
        message: 'Base de datos no disponible',
      };
    }

    return {
      status: HttpStatus.INTERNAL_SERVER_ERROR,
      message: 'Error interno del servidor',
    };
  }
}
