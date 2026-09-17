import { Controller, Get } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Controller('health')
export class HealthController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  async ready() {
    await this.prisma.$queryRaw`SELECT 1`;
    return { status: 'ok', database: 'up' };
  }

  @Get('ready')
  async readiness() {
    return this.ready();
  }

  @Get('live')
  live() {
    return { status: 'ok' };
  }
}
