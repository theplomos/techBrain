import * as Joi from 'joi';

export const envValidationSchema = Joi.object({
  NODE_ENV: Joi.string()
    .valid('development', 'test', 'staging', 'production')
    .default('development'),
  PORT: Joi.number().port().default(3000),
  APP_NAME: Joi.string().default('TechBrain API'),
  FRONTEND_URL: Joi.string().uri().required(),
  CORS_ORIGINS: Joi.string().allow('').default(''),
  LOG_LEVEL: Joi.string()
    .valid('verbose', 'debug', 'log', 'warn', 'error', 'fatal')
    .default('log'),
  SENTRY_DSN: Joi.string().uri().allow('').default(''),
  SENTRY_RELEASE: Joi.string().allow('').default(''),
  SENTRY_TRACES_SAMPLE_RATE: Joi.number().min(0).max(1).default(0),
  DATABASE_URL: Joi.string()
    .uri({ scheme: ['postgresql', 'postgres'] })
    .required(),
  JWT_ACCESS_SECRET: Joi.string().min(32).required(),
  JWT_ACCESS_TTL_SECONDS: Joi.number().integer().positive().default(900),
  REFRESH_TOKEN_TTL_DAYS: Joi.number().integer().positive().default(30),
  DISCORD_CLIENT_ID: Joi.string().required(),
  DISCORD_CLIENT_SECRET: Joi.string().required(),
  DISCORD_CALLBACK_URL: Joi.string().uri().required(),
  DISCORD_GUILD_ID: Joi.when('DISCORD_REQUIRE_GUILD_MEMBERSHIP', {
    is: true,
    then: Joi.string().required(),
    otherwise: Joi.string().allow('').default(''),
  }),
  DISCORD_REQUIRE_GUILD_MEMBERSHIP: Joi.boolean()
    .truthy('true')
    .falsy('false')
    .default(false),
}).options({ abortEarly: false });
