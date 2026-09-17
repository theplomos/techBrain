import {
  afterEach,
  beforeEach,
  describe,
  expect,
  it,
  jest,
} from '@jest/globals';
import { ConsoleLogger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as Sentry from '@sentry/nestjs';
import { AppLoggerService } from './app-logger.service';

jest.mock('@sentry/nestjs', () => ({
  logger: {
    warn: jest.fn(),
    error: jest.fn(),
    fatal: jest.fn(),
  },
  captureException: jest.fn(),
  flush: jest.fn(() => Promise.resolve(true)),
  withScope: jest.fn((callback: (scope: unknown) => void) =>
    callback({ setTag: jest.fn(), setContext: jest.fn() }),
  ),
}));

describe('AppLoggerService', () => {
  beforeEach(() => {
    jest
      .spyOn(ConsoleLogger.prototype, 'log')
      .mockImplementation(() => undefined);
    jest
      .spyOn(ConsoleLogger.prototype, 'warn')
      .mockImplementation(() => undefined);
    jest
      .spyOn(ConsoleLogger.prototype, 'error')
      .mockImplementation(() => undefined);
    jest
      .spyOn(ConsoleLogger.prototype, 'debug')
      .mockImplementation(() => undefined);
    jest
      .spyOn(ConsoleLogger.prototype, 'verbose')
      .mockImplementation(() => undefined);
    jest
      .spyOn(ConsoleLogger.prototype, 'fatal')
      .mockImplementation(() => undefined);
    jest.clearAllMocks();
  });

  afterEach(() => {
    jest.restoreAllMocks();
  });

  it('respeta el nivel mínimo y envía warnings a Sentry', () => {
    const logger = createLogger('warn', 'https://examplePublicKey@sentry.io/1');

    logger.log('ignorado');
    logger.warn('atención', 'AuthService');

    // The prototype method is intentionally inspected as a Jest spy.
    // eslint-disable-next-line @typescript-eslint/unbound-method
    expect(ConsoleLogger.prototype.log).not.toHaveBeenCalled();
    const sentryWarn = jest.mocked(Sentry.logger.warn);
    expect(sentryWarn).toHaveBeenCalledWith('atención', {
      context: 'AuthService',
    });
  });

  it('no envía eventos cuando Sentry está desactivado', () => {
    const logger = createLogger('verbose', '');

    logger.error('fallo');
    logger.fatal('fatal');

    const sentryError = jest.mocked(Sentry.logger.error);
    const sentryFatal = jest.mocked(Sentry.logger.fatal);
    expect(sentryError).not.toHaveBeenCalled();
    expect(sentryFatal).not.toHaveBeenCalled();
  });

  it('envía error y fatal a Sentry cuando están habilitados', () => {
    const logger = createLogger(
      'error',
      'https://examplePublicKey@sentry.io/1',
    );

    logger.error('fallo');
    logger.fatal('caída total');

    expect(jest.mocked(Sentry.logger.error)).toHaveBeenCalledWith(
      'fallo',
      undefined,
    );
    expect(jest.mocked(Sentry.logger.fatal)).toHaveBeenCalledWith(
      'caída total',
      undefined,
    );
  });

  it('captura una excepción con su stack sin duplicarla como log', () => {
    const logger = createLogger(
      'error',
      'https://examplePublicKey@sentry.io/1',
    );
    const error = new Error('fallo inesperado');

    logger.reportException(error, { method: 'GET', path: '/api/test' });

    const captureException = jest.mocked(Sentry.captureException);
    const sentryError = jest.mocked(Sentry.logger.error);
    expect(captureException).toHaveBeenCalledWith(error);
    expect(sentryError).not.toHaveBeenCalled();
  });

  function createLogger(level: string, dsn: string): AppLoggerService {
    const config = {
      get: jest.fn((key: string, fallback?: unknown) => {
        if (key === 'LOG_LEVEL') return level;
        if (key === 'SENTRY_DSN') return dsn;
        return fallback;
      }),
    };
    return new AppLoggerService(config as unknown as ConfigService);
  }
});
