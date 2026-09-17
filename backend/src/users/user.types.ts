import { Prisma } from '@prisma/client';

export const publicUserSelect = {
  id: true,
  email: true,
  fullName: true,
  discordId: true,
  avatarUrl: true,
  isActive: true,
  roles: true,
  lastLoginAt: true,
  createdAt: true,
  updatedAt: true,
} satisfies Prisma.UserSelect;

export type PublicUser = Prisma.UserGetPayload<{
  select: typeof publicUserSelect;
}>;
