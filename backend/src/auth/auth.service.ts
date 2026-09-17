import {
  BadGatewayException,
  BadRequestException,
  ForbiddenException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { compare, hash } from 'bcryptjs';
import { createHash, randomBytes } from 'node:crypto';
import { PrismaService } from '../prisma/prisma.service';
import { PublicUser, publicUserSelect } from '../users/user.types';
import { UsersService } from '../users/users.service';
import { ChangePasswordDto } from './dto/change-password.dto';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import {
  AuthResponse,
  DiscordProfile,
} from './interfaces/auth-response.interface';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService,
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
    private readonly config: ConfigService,
  ) {}

  async register(dto: RegisterDto): Promise<AuthResponse> {
    const user = await this.usersService.createLocal({
      email: dto.email,
      fullName: dto.fullName,
      passwordHash: await hash(dto.password, 12),
    });
    return this.createSession(user.id);
  }

  async login(dto: LoginDto): Promise<AuthResponse> {
    const user = await this.usersService.findByEmailWithPassword(dto.email);
    const isValid = Boolean(
      user?.passwordHash && (await compare(dto.password, user.passwordHash)),
    );
    if (!user || !isValid || !user.isActive) {
      throw new UnauthorizedException('Credenciales inválidas');
    }

    const publicUser = await this.usersService.updateLastLogin(user.id);
    return this.createSession(publicUser.id);
  }

  async refresh(rawToken: string): Promise<AuthResponse> {
    const refreshToken = this.randomToken();
    const refreshDays = this.config.get<number>('REFRESH_TOKEN_TTL_DAYS', 30);
    const now = new Date();

    const user = await this.prisma.$transaction(async (transaction) => {
      const session = await transaction.refreshSession.findFirst({
        where: {
          tokenHash: this.digest(rawToken),
          revokedAt: null,
          expiresAt: { gt: now },
        },
      });
      if (!session) throw new UnauthorizedException('Refresh token inválido');

      const revoked = await transaction.refreshSession.updateMany({
        where: { id: session.id, revokedAt: null },
        data: { revokedAt: now },
      });
      if (revoked.count !== 1) {
        throw new UnauthorizedException('Refresh token ya utilizado');
      }

      const currentUser = await transaction.user.findUnique({
        where: { id: session.userId },
        select: publicUserSelect,
      });
      if (!currentUser?.isActive) throw new UnauthorizedException();

      await transaction.refreshSession.create({
        data: {
          tokenHash: this.digest(refreshToken),
          userId: currentUser.id,
          expiresAt: new Date(now.getTime() + refreshDays * 86_400_000),
        },
      });
      return currentUser;
    });

    return this.buildAuthResponse(user, refreshToken);
  }

  async logout(rawToken: string): Promise<void> {
    await this.prisma.refreshSession.updateMany({
      where: { tokenHash: this.digest(rawToken), revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }

  async changePassword(userId: string, dto: ChangePasswordDto): Promise<void> {
    const user = await this.usersService.findByIdWithPassword(userId);
    const isValid = Boolean(
      user?.passwordHash &&
      (await compare(dto.currentPassword, user.passwordHash)),
    );
    if (!user || !isValid) {
      throw new UnauthorizedException('Contraseña actual inválida');
    }

    const passwordHash = await hash(dto.newPassword, 12);
    await this.prisma.$transaction([
      this.prisma.user.update({
        where: { id: userId },
        data: { passwordHash },
      }),
      this.prisma.refreshSession.updateMany({
        where: { userId, revokedAt: null },
        data: { revokedAt: new Date() },
      }),
    ]);
  }

  buildDiscordAuthorizationUrl(state: string): string {
    const scopes = ['identify', 'email'];
    if (this.config.get<boolean>('DISCORD_REQUIRE_GUILD_MEMBERSHIP')) {
      scopes.push('guilds');
    }
    const params = new URLSearchParams({
      client_id: this.config.getOrThrow<string>('DISCORD_CLIENT_ID'),
      redirect_uri: this.config.getOrThrow<string>('DISCORD_CALLBACK_URL'),
      response_type: 'code',
      scope: scopes.join(' '),
      state,
      prompt: 'consent',
    });
    return `https://discord.com/oauth2/authorize?${params.toString()}`;
  }

  async completeDiscordLogin(code: string): Promise<string> {
    const accessToken = await this.exchangeDiscordCode(code);
    const profile = await this.fetchDiscordProfile(accessToken);
    await this.assertGuildMembership(accessToken);
    const user = await this.findOrCreateDiscordUser(profile);

    const rawCode = this.randomToken();
    await this.prisma.oAuthCode.create({
      data: {
        codeHash: this.digest(rawCode),
        userId: user.id,
        expiresAt: new Date(Date.now() + 60_000),
      },
    });
    return rawCode;
  }

  async exchangeOAuthCode(rawCode: string): Promise<AuthResponse> {
    const refreshToken = this.randomToken();
    const refreshDays = this.config.get<number>('REFRESH_TOKEN_TTL_DAYS', 30);
    const now = new Date();

    const user = await this.prisma.$transaction(async (transaction) => {
      const oauthCode = await transaction.oAuthCode.findFirst({
        where: {
          codeHash: this.digest(rawCode),
          usedAt: null,
          expiresAt: { gt: now },
        },
      });
      if (!oauthCode) {
        throw new UnauthorizedException('Código inválido o expirado');
      }

      const consumed = await transaction.oAuthCode.updateMany({
        where: { id: oauthCode.id, usedAt: null },
        data: { usedAt: now },
      });
      if (consumed.count !== 1) {
        throw new UnauthorizedException('Código ya utilizado');
      }

      const currentUser = await transaction.user.findUnique({
        where: { id: oauthCode.userId },
        select: publicUserSelect,
      });
      if (!currentUser?.isActive) throw new UnauthorizedException();

      await transaction.refreshSession.create({
        data: {
          tokenHash: this.digest(refreshToken),
          userId: currentUser.id,
          expiresAt: new Date(now.getTime() + refreshDays * 86_400_000),
        },
      });
      return currentUser;
    });

    return this.buildAuthResponse(user, refreshToken);
  }

  private async createSession(userId: string): Promise<AuthResponse> {
    const user = await this.usersService.findById(userId);
    if (!user?.isActive) throw new UnauthorizedException();

    const refreshDays = this.config.get<number>('REFRESH_TOKEN_TTL_DAYS', 30);
    const refreshToken = this.randomToken();
    await this.prisma.refreshSession.create({
      data: {
        tokenHash: this.digest(refreshToken),
        userId,
        expiresAt: new Date(Date.now() + refreshDays * 86_400_000),
      },
    });
    return this.buildAuthResponse(user, refreshToken);
  }

  private async buildAuthResponse(
    user: PublicUser,
    refreshToken: string,
  ): Promise<AuthResponse> {
    const expiresIn = this.config.get<number>('JWT_ACCESS_TTL_SECONDS', 900);
    return {
      user,
      accessToken: await this.jwtService.signAsync(
        { sub: user.id, type: 'access' },
        { expiresIn },
      ),
      refreshToken,
      tokenType: 'Bearer',
      expiresIn,
    };
  }

  private async exchangeDiscordCode(code: string): Promise<string> {
    const body = new URLSearchParams({
      client_id: this.config.getOrThrow<string>('DISCORD_CLIENT_ID'),
      client_secret: this.config.getOrThrow<string>('DISCORD_CLIENT_SECRET'),
      grant_type: 'authorization_code',
      code,
      redirect_uri: this.config.getOrThrow<string>('DISCORD_CALLBACK_URL'),
    });
    const response = await fetch('https://discord.com/api/oauth2/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body,
    });
    if (!response.ok) {
      throw new BadRequestException('Código de Discord inválido');
    }
    const payload = (await response.json()) as { access_token?: string };
    if (!payload.access_token) {
      throw new BadGatewayException('Respuesta inválida de Discord');
    }
    return payload.access_token;
  }

  private async fetchDiscordProfile(token: string): Promise<DiscordProfile> {
    const response = await fetch('https://discord.com/api/users/@me', {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (!response.ok) {
      throw new BadGatewayException('No se pudo consultar Discord');
    }
    return (await response.json()) as DiscordProfile;
  }

  private async assertGuildMembership(token: string): Promise<void> {
    if (!this.config.get<boolean>('DISCORD_REQUIRE_GUILD_MEMBERSHIP')) return;
    const guildId = this.config.getOrThrow<string>('DISCORD_GUILD_ID');
    const response = await fetch('https://discord.com/api/users/@me/guilds', {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (!response.ok) {
      throw new BadGatewayException('No se pudieron consultar los servidores');
    }
    const guilds = (await response.json()) as Array<{ id: string }>;
    if (!guilds.some((guild) => guild.id === guildId)) {
      throw new ForbiddenException('Debes pertenecer al servidor de DevTalles');
    }
  }

  private async findOrCreateDiscordUser(
    profile: DiscordProfile,
  ): Promise<PublicUser> {
    const discordUser = await this.usersService.findByDiscordId(profile.id);
    if (discordUser) {
      if (!discordUser.isActive) {
        throw new UnauthorizedException('Cuenta inactiva');
      }
      return this.usersService.updateLastLogin(discordUser.id);
    }

    if (!profile.email || !profile.verified) {
      throw new BadRequestException(
        'Discord debe proporcionar un correo verificado',
      );
    }
    const userByEmail = await this.usersService.findByEmail(profile.email);
    const avatarUrl = profile.avatar
      ? `https://cdn.discordapp.com/avatars/${profile.id}/${profile.avatar}.png`
      : null;

    if (userByEmail) {
      if (!userByEmail.isActive) {
        throw new UnauthorizedException('Cuenta inactiva');
      }
      return this.usersService.linkDiscord(
        userByEmail.id,
        profile.id,
        avatarUrl,
      );
    }

    return this.usersService.createDiscord({
      email: profile.email.toLowerCase(),
      fullName: profile.global_name ?? profile.username,
      discordId: profile.id,
      avatarUrl,
    });
  }

  private randomToken(): string {
    return randomBytes(48).toString('base64url');
  }

  private digest(value: string): string {
    return createHash('sha256').update(value).digest('hex');
  }
}
