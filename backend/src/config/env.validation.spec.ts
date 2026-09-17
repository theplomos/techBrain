import { describe, expect, it } from '@jest/globals';
import { envValidationSchema } from './env.validation';

const validEnvironment = {
  NODE_ENV: 'test',
  FRONTEND_URL: 'http://localhost:3001',
  DATABASE_URL: 'postgresql://postgres:postgres@localhost:5432/techbrain',
  JWT_ACCESS_SECRET: 'a-secure-secret-with-at-least-32-characters',
  DISCORD_CLIENT_ID: 'client-id',
  DISCORD_CLIENT_SECRET: 'client-secret',
  DISCORD_CALLBACK_URL: 'http://localhost:3000/api/auth/discord/callback',
};

describe('envValidationSchema', () => {
  it('aplica defaults seguros', () => {
    const result = envValidationSchema.validate(validEnvironment);
    const value = result.value as Record<string, unknown>;

    expect(result.error).toBeUndefined();
    expect(value.LOG_LEVEL).toBe('log');
    expect(value.SENTRY_TRACES_SAMPLE_RATE).toBe(0);
  });

  it('requiere guild id cuando se valida membresía de Discord', () => {
    const result = envValidationSchema.validate({
      ...validEnvironment,
      DISCORD_REQUIRE_GUILD_MEMBERSHIP: true,
      DISCORD_GUILD_ID: '',
    });

    expect(result.error).toBeDefined();
  });

  it('rechaza niveles y sample rates inválidos', () => {
    const result = envValidationSchema.validate({
      ...validEnvironment,
      LOG_LEVEL: 'trace',
      SENTRY_TRACES_SAMPLE_RATE: 2,
    });

    expect(result.error?.details).toHaveLength(2);
  });
});
