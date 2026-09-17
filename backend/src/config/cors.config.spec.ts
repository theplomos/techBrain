import { describe, expect, it, jest } from '@jest/globals';
import { ConfigService } from '@nestjs/config';
import { buildCorsOptions } from './cors.config';

describe('buildCorsOptions', () => {
  it('acepta orígenes configurados y normaliza la barra final', () => {
    const options = buildCorsOptions(
      createConfig('https://app.example.com, http://localhost:3001/'),
    );
    const callback = jest.fn();

    expect(typeof options.origin).toBe('function');
    if (typeof options.origin === 'function') {
      options.origin('http://localhost:3001', callback);
    }

    expect(callback).toHaveBeenCalledWith(null, true);
  });

  it('rechaza orígenes que no están en la lista', () => {
    const options = buildCorsOptions(createConfig('https://app.example.com'));
    const callback = jest.fn();

    if (typeof options.origin === 'function') {
      options.origin('https://attacker.example', callback);
    }

    expect(callback).toHaveBeenCalledWith(expect.any(Error), false);
  });

  it('usa FRONTEND_URL cuando CORS_ORIGINS está vacío', () => {
    const options = buildCorsOptions(createConfig(''));
    const callback = jest.fn();

    if (typeof options.origin === 'function') {
      options.origin('http://localhost:3001', callback);
    }

    expect(callback).toHaveBeenCalledWith(null, true);
  });

  function createConfig(corsOrigins: string): ConfigService {
    return {
      get: jest.fn((key: string, fallback?: unknown) =>
        key === 'CORS_ORIGINS' ? corsOrigins : fallback,
      ),
      getOrThrow: jest.fn(() => 'http://localhost:3001'),
    } as unknown as ConfigService;
  }
});
