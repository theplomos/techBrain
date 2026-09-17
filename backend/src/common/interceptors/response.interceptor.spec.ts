import { describe, expect, it, jest } from '@jest/globals';
import { CallHandler, ExecutionContext, HttpStatus } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { lastValueFrom, of } from 'rxjs';
import { ResponseInterceptor } from './response.interceptor';

describe('ResponseInterceptor', () => {
  it('envuelve una respuesta exitosa', async () => {
    const interceptor = createInterceptor(false);
    const result = await lastValueFrom(
      interceptor.intercept(
        createContext(HttpStatus.CREATED),
        createHandler({ id: 'course-id' }),
      ),
    );

    expect(result).toEqual(
      expect.objectContaining({
        success: true,
        statusCode: 201,
        data: { id: 'course-id' },
        path: '/api/courses',
      }),
    );
  });

  it('separa data y meta en respuestas paginadas', async () => {
    const interceptor = createInterceptor(false);
    const result = await lastValueFrom(
      interceptor.intercept(
        createContext(HttpStatus.OK),
        createHandler({ data: [{ id: 1 }], meta: { page: 1, total: 1 } }),
      ),
    );

    expect(result).toEqual(
      expect.objectContaining({
        data: [{ id: 1 }],
        meta: { page: 1, total: 1 },
      }),
    );
  });

  it('no agrega cuerpo a una respuesta 204', async () => {
    const interceptor = createInterceptor(false);
    const result = await lastValueFrom(
      interceptor.intercept(
        createContext(HttpStatus.NO_CONTENT),
        createHandler(undefined),
      ),
    );

    expect(result).toBeUndefined();
  });

  it('respeta endpoints excluidos y evita doble envoltura', async () => {
    const skipped = await lastValueFrom(
      createInterceptor(true).intercept(
        createContext(HttpStatus.FOUND),
        createHandler('redirect'),
      ),
    );
    const envelope = {
      success: true as const,
      statusCode: 200,
      data: { id: 1 },
      path: '/api/courses',
      timestamp: new Date().toISOString(),
    };
    const existing = await lastValueFrom(
      createInterceptor(false).intercept(
        createContext(HttpStatus.OK),
        createHandler(envelope),
      ),
    );

    expect(skipped).toBe('redirect');
    expect(existing).toBe(envelope);
  });

  function createInterceptor(skip: boolean): ResponseInterceptor<unknown> {
    const reflector = {
      getAllAndOverride: jest.fn(() => skip),
    };
    return new ResponseInterceptor(reflector as unknown as Reflector);
  }

  function createHandler<T>(value: T): CallHandler<T> {
    return { handle: () => of(value) };
  }

  function createContext(statusCode: number): ExecutionContext {
    return {
      getHandler: () => function handler() {},
      getClass: () => class Controller {},
      switchToHttp: () => ({
        getRequest: () => ({ originalUrl: '/api/courses' }),
        getResponse: () => ({ statusCode }),
      }),
    } as unknown as ExecutionContext;
  }
});
