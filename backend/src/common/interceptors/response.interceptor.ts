import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Request, Response } from 'express';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { SKIP_RESPONSE_ENVELOPE } from '../response/skip-response-envelope.decorator';

export interface SuccessResponse<T> {
  success: true;
  statusCode: number;
  data: T;
  meta?: unknown;
  path: string;
  timestamp: string;
}

@Injectable()
export class ResponseInterceptor<T> implements NestInterceptor<
  T,
  T | SuccessResponse<unknown>
> {
  constructor(private readonly reflector: Reflector) {}

  intercept(
    context: ExecutionContext,
    next: CallHandler<T>,
  ): Observable<T | SuccessResponse<unknown>> {
    const skip = this.reflector.getAllAndOverride<boolean>(
      SKIP_RESPONSE_ENVELOPE,
      [context.getHandler(), context.getClass()],
    );
    const http = context.switchToHttp();
    const response = http.getResponse<Response>();

    if (skip || response.statusCode === 204) {
      return next.handle();
    }

    const request = http.getRequest<Request>();
    return next.handle().pipe(
      map((body) => {
        if (this.isSuccessResponse(body)) return body;

        const envelope: SuccessResponse<unknown> = {
          success: true,
          statusCode: response.statusCode,
          data: this.isPaginated(body) ? body.data : body,
          path: request.originalUrl,
          timestamp: new Date().toISOString(),
        };
        if (this.isPaginated(body)) envelope.meta = body.meta;
        return envelope;
      }),
    );
  }

  private isSuccessResponse(value: unknown): value is SuccessResponse<unknown> {
    return (
      typeof value === 'object' &&
      value !== null &&
      'success' in value &&
      value.success === true &&
      'data' in value
    );
  }

  private isPaginated(
    value: unknown,
  ): value is { data: unknown; meta: unknown } {
    return (
      typeof value === 'object' &&
      value !== null &&
      'data' in value &&
      'meta' in value
    );
  }
}
