import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Query,
  Req,
  Res,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ApiTags } from '@nestjs/swagger';
import { randomBytes, timingSafeEqual } from 'node:crypto';
import { Request, Response } from 'express';
import { PublicUser } from '../users/user.types';
import { SkipResponseEnvelope } from '../common/response/skip-response-envelope.decorator';
import { AuthService } from './auth.service';
import { Auth } from './decorators/auth.decorator';
import { CurrentUser } from './decorators/current-user.decorator';
import { ChangePasswordDto } from './dto/change-password.dto';
import { ExchangeCodeDto, RefreshTokenDto } from './dto/token.dto';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly config: ConfigService,
  ) {}

  @Post('register')
  register(@Body() dto: RegisterDto) {
    return this.authService.register(dto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  refresh(@Body() dto: RefreshTokenDto) {
    return this.authService.refresh(dto.refreshToken);
  }

  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  async logout(@Body() dto: RefreshTokenDto): Promise<void> {
    await this.authService.logout(dto.refreshToken);
  }

  @Post('change-password')
  @Auth()
  @HttpCode(HttpStatus.NO_CONTENT)
  async changePassword(
    @CurrentUser() user: PublicUser,
    @Body() dto: ChangePasswordDto,
  ): Promise<void> {
    await this.authService.changePassword(user.id, dto);
  }

  @Get('discord')
  @SkipResponseEnvelope()
  discord(@Res() response: Response): void {
    const state = randomBytes(32).toString('base64url');
    response.cookie('discord_oauth_state', state, {
      httpOnly: true,
      secure: this.config.get<string>('NODE_ENV') === 'production',
      sameSite: 'lax',
      maxAge: 10 * 60 * 1000,
      path: '/api/auth/discord',
    });
    response.redirect(this.authService.buildDiscordAuthorizationUrl(state));
  }

  @Get('discord/callback')
  @SkipResponseEnvelope()
  async discordCallback(
    @Query('code') code: string | undefined,
    @Query('state') state: string | undefined,
    @Req() request: Request,
    @Res() response: Response,
  ): Promise<void> {
    const savedState = request.cookies?.discord_oauth_state as
      string | undefined;
    response.clearCookie('discord_oauth_state', {
      path: '/api/auth/discord',
    });
    if (!code || !state || !savedState || !this.sameValue(state, savedState)) {
      throw new UnauthorizedException('Estado OAuth inválido');
    }

    const exchangeCode = await this.authService.completeDiscordLogin(code);
    const frontendUrl = this.config.getOrThrow<string>('FRONTEND_URL');
    response.redirect(
      `${frontendUrl}/auth/discord/callback?code=${encodeURIComponent(exchangeCode)}`,
    );
  }

  @Post('discord/exchange')
  @HttpCode(HttpStatus.OK)
  exchangeDiscordCode(@Body() dto: ExchangeCodeDto) {
    return this.authService.exchangeOAuthCode(dto.code);
  }

  private sameValue(left: string, right: string): boolean {
    const leftBuffer = Buffer.from(left);
    const rightBuffer = Buffer.from(right);
    return (
      leftBuffer.length === rightBuffer.length &&
      timingSafeEqual(leftBuffer, rightBuffer)
    );
  }
}
