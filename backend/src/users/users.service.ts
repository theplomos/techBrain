import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Prisma, Role, User } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { PublicUser, publicUserSelect } from './user.types';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  findById(id: string): Promise<PublicUser | null> {
    return this.prisma.user.findUnique({
      where: { id },
      select: publicUserSelect,
    });
  }

  findByEmail(email: string): Promise<PublicUser | null> {
    return this.prisma.user.findUnique({
      where: { email: email.toLowerCase() },
      select: publicUserSelect,
    });
  }

  findByDiscordId(discordId: string): Promise<PublicUser | null> {
    return this.prisma.user.findUnique({
      where: { discordId },
      select: publicUserSelect,
    });
  }

  findByEmailWithPassword(email: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { email: email.toLowerCase() },
    });
  }

  findByIdWithPassword(id: string): Promise<User | null> {
    return this.prisma.user.findUnique({ where: { id } });
  }

  async createLocal(data: {
    email: string;
    fullName: string;
    passwordHash: string | null;
  }): Promise<PublicUser> {
    try {
      return await this.prisma.user.create({
        data,
        select: publicUserSelect,
      });
    } catch (error) {
      this.handleUniqueViolation(error, 'El correo ya está registrado');
    }
  }

  async createDiscord(data: {
    email: string;
    fullName: string;
    discordId: string;
    avatarUrl: string | null;
  }): Promise<PublicUser> {
    try {
      return await this.prisma.user.create({
        data: { ...data, lastLoginAt: new Date() },
        select: publicUserSelect,
      });
    } catch (error) {
      this.handleUniqueViolation(error, 'La cuenta ya está vinculada');
    }
  }

  updateLastLogin(id: string): Promise<PublicUser> {
    return this.prisma.user.update({
      where: { id },
      data: { lastLoginAt: new Date() },
      select: publicUserSelect,
    });
  }

  async linkDiscord(
    id: string,
    discordId: string,
    avatarUrl: string | null,
  ): Promise<PublicUser> {
    try {
      return await this.prisma.user.update({
        where: { id },
        data: {
          discordId,
          avatarUrl: avatarUrl ?? undefined,
          lastLoginAt: new Date(),
        },
        select: publicUserSelect,
      });
    } catch (error) {
      this.handleUniqueViolation(error, 'La cuenta ya está vinculada');
    }
  }

  updatePassword(id: string, passwordHash: string): Promise<PublicUser> {
    return this.prisma.user.update({
      where: { id },
      data: { passwordHash },
      select: publicUserSelect,
    });
  }

  async updateProfile(id: string, dto: UpdateProfileDto): Promise<PublicUser> {
    await this.assertExists(id);
    return this.prisma.user.update({
      where: { id },
      data: dto,
      select: publicUserSelect,
    });
  }

  findAll(): Promise<PublicUser[]> {
    return this.prisma.user.findMany({
      select: publicUserSelect,
      orderBy: { createdAt: 'desc' },
    });
  }

  async updateAccess(
    id: string,
    access: { roles?: Role[]; isActive?: boolean },
  ): Promise<PublicUser> {
    await this.assertExists(id);
    return this.prisma.user.update({
      where: { id },
      data: access,
      select: publicUserSelect,
    });
  }

  async promoteByEmail(email: string): Promise<PublicUser> {
    const user = await this.findByEmail(email);
    if (!user) throw new NotFoundException('Usuario no encontrado');
    const roles = user.roles.includes(Role.admin)
      ? user.roles
      : [...user.roles, Role.admin];
    return this.prisma.user.update({
      where: { id: user.id },
      data: { roles },
      select: publicUserSelect,
    });
  }

  private async assertExists(id: string): Promise<void> {
    const user = await this.prisma.user.findUnique({
      where: { id },
      select: { id: true },
    });
    if (!user) throw new NotFoundException('Usuario no encontrado');
  }

  private handleUniqueViolation(error: unknown, message: string): never {
    if (
      error instanceof Prisma.PrismaClientKnownRequestError &&
      error.code === 'P2002'
    ) {
      throw new ConflictException(message);
    }
    throw error;
  }
}
