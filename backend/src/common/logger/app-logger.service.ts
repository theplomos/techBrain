import {
  ConsoleLogger,
  Injectable,
  LogLevel,
  OnApplicationShutdown,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as Sentry from '@sentry/nestjs';

const LEVEL_PRIORITY: Record<LogLevel, number> = {
  verbose: 0,
  debug: 1,
  log: 2,
  warn: 3,
  error: 4,
  fatal: 5,
};

const LOG_LEVELS = Object.keys(LEVEL_PRIORITY) as LogLevel[];

@Injectable()
export class AppLoggerService
  extends ConsoleLogger
  implements OnApplicationShutdown
{
  private readonly minLevel: LogLevel;
  private readonly sentryEnabled: boolean;

  constructor(config: ConfigService) {
    super();
    const configuredLevel = config.get<string>('LOG_LEVEL', 'log') as LogLevel;
    this.minLevel = LOG_LEVELS.includes(configuredLevel)
      ? configuredLevel
      : 'log';
    this.sentryEnabled = Boolean(config.get<string>('SENTRY_DSN')?.trim());
  }

  log(message: unknown, ...optionalParams: unknown[]): void {
    if (this.isEnabled('log')) super.log(message, ...optionalParams);
  }

  debug(message: unknown, ...optionalParams: unknown[]): void {
    if (this.isEnabled('debug')) super.debug(message, ...optionalParams);
  }

  verbose(message: unknown, ...optionalParams: unknown[]): void {
    if (this.isEnabled('verbose')) super.verbose(message, ...optionalParams);
  }

  warn(message: unknown, ...optionalParams: unknown[]): void {
    if (!this.isEnabled('warn')) return;
    super.warn(message, ...optionalParams);
    this.sendLogToSentry('warn', message, optionalParams);
  }

  error(message: unknown, ...optionalParams: unknown[]): void {
    if (!this.isEnabled('error')) return;
    super.error(message, ...optionalParams);
    this.sendLogToSentry('error', message, optionalParams);
  }

  fatal(message: unknown, ...optionalParams: unknown[]): void {
    if (!this.isEnabled('fatal')) return;
    super.fatal(message, ...optionalParams);
    this.sendLogToSentry('fatal', message, optionalParams);
  }

  reportException(
    exception: unknown,
    context: { method?: string; path?: string } = {},
  ): void {
    const error =
      exception instanceof Error
        ? exception
        : new Error(this.serialize(exception));
    const request = [context.method, context.path].filter(Boolean).join(' ');

    if (this.isEnabled('error')) {
      super.error(
        request
          ? `Unhandled exception on ${request}: ${error.message}`
          : error.message,
        error.stack,
        'GlobalExceptionFilter',
      );
    }

    if (this.sentryEnabled) {
      Sentry.withScope((scope) => {
        if (context.method) scope.setTag('http.method', context.method);
        if (context.path) scope.setContext('request', { url: context.path });
        Sentry.captureException(error);
      });
    }
  }

  async onApplicationShutdown(): Promise<void> {
    if (this.sentryEnabled) await Sentry.flush(2_000);
  }

  private isEnabled(level: LogLevel): boolean {
    return LEVEL_PRIORITY[level] >= LEVEL_PRIORITY[this.minLevel];
  }

  private sendLogToSentry(
    level: 'warn' | 'error' | 'fatal',
    message: unknown,
    optionalParams: unknown[],
  ): void {
    if (!this.sentryEnabled) return;

    const context = this.extractContext(optionalParams);
    const attributes = context ? { context } : undefined;
    const text = this.serialize(message);

    if (level === 'warn') Sentry.logger.warn(text, attributes);
    else if (level === 'fatal') Sentry.logger.fatal(text, attributes);
    else Sentry.logger.error(text, attributes);
  }

  private extractContext(optionalParams: unknown[]): string | undefined {
    const candidate = optionalParams.at(-1);
    return typeof candidate === 'string' && !candidate.includes('\n')
      ? candidate
      : undefined;
  }

  private serialize(message: unknown): string {
    if (typeof message === 'string') return message;
    if (message instanceof Error) return message.message;
    try {
      return JSON.stringify(message, (_key, value: unknown) =>
        typeof value === 'bigint' ? value.toString() : value,
      );
    } catch {
      return String(message);
    }
  }
}
