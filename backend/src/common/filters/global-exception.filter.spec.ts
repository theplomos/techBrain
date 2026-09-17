import { describe, expect, it, jest } from '@jest/globals';
import { ArgumentsHost, BadRequestException } from '@nestjs/common';
import { GlobalExceptionFilter } from './global-exception.filter';
import { AppLoggerService } from '../logger/app-logger.service';

describe('GlobalExceptionFilter', () => {
  it('preserva los mensajes de validación de HttpException', () => {
    const { filter, response, logger } = createFilter();
    const exception = new BadRequestException({
      message: ['email must be an email'],
      error: 'Bad Request',
    });

    filter.catch(exception, createHost(response));

    expect(response.status).toHaveBeenCalledWith(400);
    expect(response.json).toHaveBeenCalledWith(
      expect.objectContaining({
        success: false,
        message: ['email must be an email'],
        error: 'Bad Request',
      }),
    );
    expect(logger.reportException).not.toHaveBeenCalled();
  });

  it('reporta excepciones inesperadas y oculta sus detalles', () => {
    const { filter, response, logger } = createFilter();
    const exception = new Error('secreto interno');

    filter.catch(exception, createHost(response));

    expect(logger.reportException).toHaveBeenCalledWith(exception, {
      method: 'GET',
      path: '/api/test',
    });
    expect(response.status).toHaveBeenCalledWith(500);
    expect(response.json).toHaveBeenCalledWith(
      expect.objectContaining({
        success: false,
        message: 'Error interno del servidor',
      }),
    );
  });

  function createFilter() {
    const logger = { reportException: jest.fn() };
    const response = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
    return {
      logger,
      response,
      filter: new GlobalExceptionFilter(logger as unknown as AppLoggerService),
    };
  }

  function createHost(response: unknown): ArgumentsHost {
    return {
      switchToHttp: () => ({
        getRequest: () => ({ method: 'GET', originalUrl: '/api/test' }),
        getResponse: () => response,
      }),
    } as unknown as ArgumentsHost;
  }
});
