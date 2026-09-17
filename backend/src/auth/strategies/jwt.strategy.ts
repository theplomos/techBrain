import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { PublicUser } from '../../users/user.types';
import { UsersService } from '../../users/users.service';

interface AccessTokenPayload {
  sub: string;
  type: 'access';
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    config: ConfigService,
    private readonly usersService: UsersService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.getOrThrow<string>('JWT_ACCESS_SECRET'),
      algorithms: ['HS256'],
    });
  }

  async validate(payload: AccessTokenPayload): Promise<PublicUser> {
    if (payload.type !== 'access') throw new UnauthorizedException();
    const user = await this.usersService.findById(payload.sub);
    if (!user?.isActive) throw new UnauthorizedException();
    return user;
  }
}
