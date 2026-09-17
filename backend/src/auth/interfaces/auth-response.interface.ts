import { PublicUser } from '../../users/user.types';

export interface AuthResponse {
  user: PublicUser;
  accessToken: string;
  refreshToken: string;
  tokenType: 'Bearer';
  expiresIn: number;
}

export interface DiscordProfile {
  id: string;
  email: string | null;
  verified: boolean;
  global_name: string | null;
  username: string;
  avatar: string | null;
}
